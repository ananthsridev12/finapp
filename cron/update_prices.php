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

// NSE bhavcopy URL for today — tries last 5 days in case of holiday/weekend
$priceMap  = []; // symbol => ['price'=>, 'date'=>]
$found     = false;

for ($daysBack = 0; $daysBack <= 5; $daysBack++) {
    $ts      = strtotime("-$daysBack days");
    $dd      = date('d', $ts);
    $mon     = strtoupper(date('M', $ts));
    $yyyy    = date('Y', $ts);
    $dateStr = date('Y-m-d', $ts);

    // Equity bhavcopy
    $equityUrl = "https://archives.nseindia.com/content/historical/EQUITIES/{$yyyy}/{$mon}/cm{$dd}{$mon}{$yyyy}bhav.csv.zip";
    $ctx = stream_context_create(['http' => [
        'timeout' => 30,
        'header'  => "User-Agent: Mozilla/5.0\r\nReferer: https://www.nseindia.com/\r\n",
    ]]);
    $zip = @file_get_contents($equityUrl, false, $ctx);

    if ($zip) {
        // Save zip to temp, extract CSV
        $tmpZip = sys_get_temp_dir() . '/nse_bhav.zip';
        file_put_contents($tmpZip, $zip);
        $za = new ZipArchive();
        if ($za->open($tmpZip) === true) {
            $csv = $za->getFromIndex(0);
            $za->close();
            $lines = explode("\n", $csv);
            array_shift($lines); // skip header: SYMBOL,SERIES,OPEN,HIGH,LOW,CLOSE,...,ISIN
            foreach ($lines as $line) {
                $line = trim($line);
                if (!$line) continue;
                $cols = str_getcsv($line);
                if (count($cols) < 6) continue;
                $sym   = trim($cols[0]) . '.NS';
                $close = (float) trim($cols[5]);
                if ($close <= 0) continue;
                $priceMap[$sym] = ['price' => $close, 'date' => $dateStr];
            }
            logMsg("Parsed equity bhavcopy for $dateStr (" . count($priceMap) . " symbols).");
            $found = true;
        }
        @unlink($tmpZip);
        break;
    }
}

if (!$found) {
    logMsg('ERROR: Could not fetch NSE equity bhavcopy for last 5 days.');
}

// ETF bhavcopy
for ($daysBack = 0; $daysBack <= 5; $daysBack++) {
    $ts   = strtotime("-$daysBack days");
    $dd   = date('d', $ts);
    $mon  = strtoupper(date('M', $ts));
    $yyyy = date('Y', $ts);
    $dateStr = date('Y-m-d', $ts);

    $etfUrl = "https://archives.nseindia.com/content/historical/ETF/{$yyyy}/{$mon}/cm{$dd}{$mon}{$yyyy}bhav.csv.zip";
    $ctx = stream_context_create(['http' => [
        'timeout' => 30,
        'header'  => "User-Agent: Mozilla/5.0\r\nReferer: https://www.nseindia.com/\r\n",
    ]]);
    $zip = @file_get_contents($etfUrl, false, $ctx);

    if ($zip) {
        $tmpZip = sys_get_temp_dir() . '/nse_etf_bhav.zip';
        file_put_contents($tmpZip, $zip);
        $za = new ZipArchive();
        if ($za->open($tmpZip) === true) {
            $csv = $za->getFromIndex(0);
            $za->close();
            $lines = explode("\n", $csv);
            array_shift($lines);
            $etfCount = 0;
            foreach ($lines as $line) {
                $line = trim($line);
                if (!$line) continue;
                $cols = str_getcsv($line);
                if (count($cols) < 6) continue;
                $sym   = trim($cols[0]) . '.NS';
                $close = (float) trim($cols[5]);
                if ($close <= 0) continue;
                $priceMap[$sym] = ['price' => $close, 'date' => $dateStr];
                $etfCount++;
            }
            logMsg("Parsed ETF bhavcopy for $dateStr ($etfCount ETFs).");
        }
        @unlink($tmpZip);
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
