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

// ── 3. Sync Mutual Funds from AMFI ────────────────────────────────────────
logMsg('Syncing MF instrument list from AMFI...');
$amfiUrl = 'https://api.mfapi.in/mf';
$ctx2    = stream_context_create(['http' => ['timeout' => 30]]);
$response = @file_get_contents($amfiUrl, false, $ctx2);

if ($response) {
    $funds = json_decode($response, true) ?? [];
    $count = 0;
    foreach ($funds as $fund) {
        $schemeCode = (string) ($fund['schemeCode'] ?? '');
        $name       = trim($fund['schemeName'] ?? '');
        if (!$schemeCode || !$name) continue;
        // upsertMF with 0 price — price will be updated by update_prices.php
        $instrument->upsertMF($schemeCode, $name, '', 0, date('Y-m-d'));
        $count++;
    }
    logMsg("Synced $count MF instruments.");
} else {
    logMsg('ERROR: Failed to fetch AMFI MF list.');
}

logMsg('Instrument sync complete.');
