<?php

// Cron bootstrap — loads env and autoloader
$root = dirname(__DIR__);

$envFile = $root . '/.env';
if (file_exists($envFile)) {
    foreach (file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
        if (strpos(trim($line), '#') === 0 || strpos($line, '=') === false) continue;
        [$key, $value] = explode('=', $line, 2);
        putenv(trim($key) . '=' . trim($value));
    }
}

require_once $root . '/autoload.php';

use Config\Database;
use Models\Instrument;

function getDb(): Database
{
    return new Database();
}

function getInstrumentModel(): Instrument
{
    return new Instrument(getDb());
}

function logMsg(string $msg): void
{
    echo '[' . date('Y-m-d H:i:s') . '] ' . $msg . PHP_EOL;
}
