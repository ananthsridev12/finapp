<?php

require_once __DIR__ . '/bootstrap.php';

use Models\Instrument;

$instrument = getInstrumentModel();

// ── 1. Sync NSE Equity list ───────────────────────────────────────────────
logMsg('Syncing NSE Equity instrument list...');
$url = 'https://archives.nseindia.com/content/equities/EQUITY_L.csv';
$ctx = stream_context_create(['http' => [
    'timeout' => 30,
    'header'  => "User-Agent: Mozilla/5.0\r\nReferer: https://www.nseindia.com/\r\n",
]]);
$raw = @file_get_contents($url, false, $ctx);

if ($raw) {
    $lines  = explode("\n", $raw);
    $header = str_getcsv(array_shift($lines)); // skip header
    $count  = 0;
    foreach ($lines as $line) {
        $line = trim($line);
        if (!$line) continue;
        $cols = str_getcsv($line);
        // Columns: SYMBOL,NAME OF COMPANY,SERIES,DATE OF LISTING,PAID UP VALUE,MARKET LOT,ISIN NUMBER,FACE VALUE
        if (count($cols) < 7) continue;
        [$symbol, $name, $series] = $cols;
        $isin = trim($cols[6] ?? '');
        if ($series !== 'EQ') continue; // only regular equity
        $instrument->upsertEquityETF(trim($symbol) . '.NS', trim($name), $isin, 'equity');
        $count++;
    }
    logMsg("Synced $count equity instruments.");
} else {
    logMsg('ERROR: Failed to fetch NSE equity list.');
}

// ── 2. Sync NSE ETF list ──────────────────────────────────────────────────
logMsg('Syncing NSE ETF instrument list...');
$etfUrl = 'https://archives.nseindia.com/content/equities/eq_etfseclist.csv';
$raw    = @file_get_contents($etfUrl, false, $ctx);

if ($raw) {
    $lines = explode("\n", $raw);
    array_shift($lines); // skip header
    $count = 0;
    foreach ($lines as $line) {
        $line = trim($line);
        if (!$line) continue;
        $cols = str_getcsv($line);
        if (count($cols) < 3) continue;
        [$symbol, $name] = $cols;
        $isin = trim($cols[2] ?? '');
        $instrument->upsertEquityETF(trim($symbol) . '.NS', trim($name), $isin, 'etf');
        $count++;
    }
    logMsg("Synced $count ETF instruments.");
} else {
    logMsg('ERROR: Failed to fetch NSE ETF list.');
}

// ── 3. Sync Mutual Funds from AMFI NAV file ───────────────────────────────
logMsg('Syncing MF instrument list from AMFI NAV file...');
$amfiUrl = 'https://www.amfiindia.com/spages/NAVAll.txt';
$ctx2    = stream_context_create(['http' => ['timeout' => 60, 'header' => "User-Agent: Mozilla/5.0\r\n"]]);
$raw     = @file_get_contents($amfiUrl, false, $ctx2);

if ($raw) {
    $lines = explode("\n", $raw);
    $count = 0;
    foreach ($lines as $line) {
        $line  = trim($line);
        $parts = explode(';', $line);
        if (count($parts) < 6) continue;
        [$schemeCode, $isinDiv, $isinGrowth, $name, $nav, $date] = $parts;
        $schemeCode = trim($schemeCode);
        $name       = trim($name);
        if (!is_numeric($schemeCode) || $name === '') continue;
        $isin = trim($isinGrowth) ?: trim($isinDiv);
        $navVal    = is_numeric(trim($nav)) ? (float)trim($nav) : 0;
        $priceDate = $navVal > 0 ? (date('Y-m-d', strtotime(trim($date))) ?: date('Y-m-d')) : date('Y-m-d');
        $instrument->upsertMF($schemeCode, $name, $isin, $navVal, $priceDate);
        $count++;
    }
    logMsg("Synced $count MF instruments.");
} else {
    logMsg('ERROR: Failed to fetch AMFI NAV file.');
}

logMsg('Instrument sync complete.');
