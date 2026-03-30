<?php
// One-time instrument sync trigger — DELETE THIS FILE after use
if (($_GET['key'] ?? '') !== 'finapp_sync_2026') {
    die('Unauthorized');
}

set_time_limit(300);
ini_set('max_execution_time', 300);

ob_start();
require_once __DIR__ . '/cron/sync_instruments.php';
$output = ob_get_clean();

echo '<pre>' . htmlspecialchars($output) . '</pre>';
echo '<p>Done. Delete this file now.</p>';
