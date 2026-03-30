<?php

require_once __DIR__ . '/bootstrap.php';

use Models\Instrument;
use Config\Database;

$instrument = getInstrumentModel();

// ── 1. Update Mutual Fund NAVs from AMFI ──────────────────────────────────
logMsg('Fetching MF NAVs from AMFI...');
$amfiUrl = 'https://www.amfiindia.com/spages/NAVAll.txt';
$ctx     = stream_context_create(['http' => ['timeout' => 30]]);
$raw     = @file_get_contents($amfiUrl, false, $ctx);

if ($raw) {
    $lines   = explode("\n", $raw);
    $updated = 0;
    foreach ($lines as $line) {
        $line = trim($line);
        // Format: SchemeCode;ISINDiv;ISINGrowth;SchemeName;NAV;Date
        $parts = explode(';', $line);
        if (count($parts) < 6) continue;
        [$schemeCode, $isinDiv, $isinGrowth, $name, $nav, $date] = $parts;
        if (!is_numeric($schemeCode) || !is_numeric($nav) || (float) $nav <= 0) continue;
        $isin      = $isinGrowth ?: $isinDiv;
        // Parse date from DD-Mon-YYYY to YYYY-MM-DD
        $priceDate = date('Y-m-d', strtotime($date)) ?: date('Y-m-d');
        $instrument->upsertMF(trim($schemeCode), trim($name), trim($isin), (float) $nav, $priceDate);
        $updated++;
    }
    logMsg("Updated $updated MF NAVs.");
} else {
    logMsg('ERROR: Failed to fetch AMFI NAV file.');
}

// ── 2. Update Equity/ETF prices from NSE Bhavcopy ────────────────────────
logMsg('Fetching Equity/ETF prices from NSE Bhavcopy...');

function fetchWithCurl(string $url): string|false {
    if (!function_exists('curl_init')) return false;
    $ch = curl_init($url);
    curl_setopt_array($ch, [
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_TIMEOUT        => 30,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_HTTPHEADER     => [
            'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
            'Accept-Language: en-US,en;q=0.5',
            'Referer: https://www.nseindia.com/',
        ],
    ]);
    $data = curl_exec($ch);
    $code = curl_getinfo($ch, CURLINFO_HTTP_CODE);
    curl_close($ch);
    return ($code === 200 && $data) ? $data : false;
}

function parseBhavZip(string $zip, string $dateStr, array &$priceMap): int {
    $tmpZip = sys_get_temp_dir() . '/nse_bhav_' . uniqid() . '.zip';
    file_put_contents($tmpZip, $zip);
    $count = 0;
    $za = new ZipArchive();
    if ($za->open($tmpZip) === true) {
        $csv = $za->getFromIndex(0);
        $za->close();
        $lines = explode("\n", $csv);

        // Read header to detect format
        $headerLine = trim(array_shift($lines));
        $headers    = str_getcsv($headerLine);
        $headers    = array_map('trim', $headers);

        // New NSE format: TckrSymb, ClsPric or PrvsClsg
        // Old NSE format: SYMBOL (col 0), CLOSE (col 5)
        $symCol   = array_search('TckrSymb', $headers);
        $closeCol = array_search('ClsPric', $headers);
        if ($closeCol === false) $closeCol = array_search('PrvsClsg', $headers);

        // Fall back to old positional format
        if ($symCol === false) { $symCol = 0; }
        if ($closeCol === false) { $closeCol = 5; }

        foreach ($lines as $line) {
            $line = trim($line);
            if (!$line) continue;
            $cols = str_getcsv($line);
            if (count($cols) <= max($symCol, $closeCol)) continue;
            $sym   = trim($cols[$symCol]) . '.NS';
            $close = (float) str_replace(',', '', trim($cols[$closeCol]));
            if ($close <= 0) continue;
            $priceMap[$sym] = ['price' => $close, 'date' => $dateStr];
            $count++;
        }
    }
    @unlink($tmpZip);
    return $count;
}

$priceMap = [];
$found    = false;

for ($daysBack = 0; $daysBack <= 6; $daysBack++) {
    $ts      = strtotime("-$daysBack days");
    $dd      = date('d', $ts);
    $mon     = strtoupper(date('M', $ts));
    $yyyy    = date('Y', $ts);
    $yyyymmdd = date('Ymd', $ts);
    $dateStr  = date('Y-m-d', $ts);

    // Try new NSE archives URL first, then old format
    $urls = [
        "https://nsearchives.nseindia.com/content/cm/BhavCopy_NSE_CM_0_0_0_{$yyyymmdd}_F_0000.csv.zip",
        "https://archives.nseindia.com/content/historical/EQUITIES/{$yyyy}/{$mon}/cm{$dd}{$mon}{$yyyy}bhav.csv.zip",
    ];

    foreach ($urls as $url) {
        $zip = fetchWithCurl($url);
        if ($zip) {
            $count = parseBhavZip($zip, $dateStr, $priceMap);
            logMsg("Parsed equity bhavcopy for $dateStr ($count symbols) from $url");
            $found = true;
            break 2;
        }
    }
}

if (!$found) {
    logMsg('ERROR: Could not fetch NSE equity bhavcopy for last 6 days.');
}

// ETF bhavcopy
for ($daysBack = 0; $daysBack <= 6; $daysBack++) {
    $ts       = strtotime("-$daysBack days");
    $dd       = date('d', $ts);
    $mon      = strtoupper(date('M', $ts));
    $yyyy     = date('Y', $ts);
    $dateStr  = date('Y-m-d', $ts);

    $etfUrl = "https://archives.nseindia.com/content/historical/ETF/{$yyyy}/{$mon}/cm{$dd}{$mon}{$yyyy}bhav.csv.zip";
    $zip = fetchWithCurl($etfUrl);
    if ($zip) {
        $count = parseBhavZip($zip, $dateStr, $priceMap);
        logMsg("Parsed ETF bhavcopy for $dateStr ($count ETFs).");
        break;
    }
}

// Now update DB using priceMap
if (!empty($priceMap)) {
    $instruments  = $instrument->getEquityETFForPriceUpdate();
    $totalUpdated = 0;
    foreach ($instruments as $row) {
        $sym = $row['symbol'];
        if (isset($priceMap[$sym])) {
            $instrument->updatePrice((int)$row['id'], $priceMap[$sym]['price'], $priceMap[$sym]['date']);
            $totalUpdated++;
        }
    }
    logMsg("Updated $totalUpdated equity/ETF prices.");
} else {
    logMsg('No price data available to update equity/ETF.');
}

logMsg('Price update complete.');
