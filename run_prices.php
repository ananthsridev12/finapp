<?php
// One-time price update trigger — DELETE THIS FILE after use
if (($_GET['key'] ?? '') !== 'finapp_prices_2026') die('Unauthorized');
set_time_limit(600);
ini_set('max_execution_time', 600);
ob_start();
require_once __DIR__ . '/cron/update_prices.php';
$output = ob_get_clean();
echo '<pre>' . htmlspecialchars($output) . '</pre>';
echo '<p>Done. Delete this file now.</p>';
