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

// ── 2. Update Equity/ETF prices from Yahoo Finance ────────────────────────
logMsg('Fetching Equity/ETF prices from Yahoo Finance...');
$instruments = $instrument->getEquityETFForPriceUpdate();
$symbols     = array_column($instruments, 'symbol', 'id');

$batches      = array_chunk($symbols, 50, true);
$totalUpdated = 0;

foreach ($batches as $batch) {
    $symbolList = implode(',', array_values($batch));
    $url        = 'https://query1.finance.yahoo.com/v7/finance/quote?symbols=' . urlencode($symbolList) . '&fields=regularMarketPrice,regularMarketTime';
    $ctx        = stream_context_create(['http' => [
        'timeout' => 15,
        'header'  => "User-Agent: Mozilla/5.0\r\n",
    ]]);
    $response = @file_get_contents($url, false, $ctx);
    if (!$response) {
        logMsg('Yahoo batch failed, skipping.');
        continue;
    }

    $data   = json_decode($response, true);
    $quotes = $data['quoteResponse']['result'] ?? [];

    foreach ($quotes as $quote) {
        $sym   = $quote['symbol'] ?? '';
        $price = $quote['regularMarketPrice'] ?? null;
        $ts    = $quote['regularMarketTime'] ?? time();
        if (!$price) continue;
        $priceDate = date('Y-m-d', $ts);
        // Find id for this symbol
        $id = array_search($sym, $batch);
        if ($id !== false) {
            $instrument->updatePrice((int) $id, (float) $price, $priceDate);
            $totalUpdated++;
        }
    }
    usleep(300000); // 300ms pause between batches
}

logMsg("Updated $totalUpdated equity/ETF prices.");
logMsg('Price update complete.');
