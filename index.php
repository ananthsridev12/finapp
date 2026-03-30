<?php

// TEMP DEBUG - remove after fix
if (($_GET['debug'] ?? '') === 'finapp_debug_2026') {
    session_start();
    die(json_encode([
        'session_id'   => session_id(),
        'session_data' => $_SESSION,
        'cookies'      => $_COOKIE,
        'save_handler' => ini_get('session.save_handler'),
        'save_path'    => session_save_path(),
        'env_exists'   => file_exists(__DIR__ . '/.env'),
    ], JSON_PRETTY_PRINT));
}

header('Cache-Control: no-store, no-cache, must-revalidate, max-age=0');
header('Pragma: no-cache');
header('Expires: Thu, 01 Jan 1970 00:00:00 GMT');

// Load .env if present (for local development)
$envFile = __DIR__ . '/.env';
if (file_exists($envFile)) {
    foreach (file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES) as $line) {
        if (strpos(trim($line), '#') === 0 || strpos($line, '=') === false) continue;
        [$key, $value] = explode('=', $line, 2);
        putenv(trim($key) . '=' . trim($value));
    }
}

require_once __DIR__ . '/autoload.php';

use Config\Database;
use Config\DbSessionHandler;

ini_set('session.gc_maxlifetime', 86400);
session_set_cookie_params(86400);
try {
    $sessionHandler = new DbSessionHandler(new Database());
    session_set_save_handler($sessionHandler, true);
} catch (\Throwable $e) {
    error_log('[FinApp] DB session handler failed: ' . $e->getMessage());
}
session_start();

use Controllers\AuthController;
use Controllers\AccountController;
use Controllers\AnalyticsController;
use Controllers\CategoryController;
use Controllers\ContactController;
use Controllers\CreditCardController;
use Controllers\DashboardController;
use Controllers\InvestmentController;
use Controllers\LoanController;
use Controllers\LendingController;
use Controllers\ReminderController;
use Controllers\RentalController;
use Controllers\SipController;
use Controllers\TransactionController;

// Global logout handler
if (($_GET['action'] ?? '') === 'logout') {
    $authController = new AuthController();
    $authController->logout();
    exit;
}

$moduleInput = filter_input(INPUT_GET, 'module', FILTER_DEFAULT);
$module      = is_string($moduleInput) ? preg_replace('/[^a-z_]/i', '', $moduleInput) : 'dashboard';
$module      = $module !== '' ? $module : 'dashboard';

// Auth routes — accessible without login
if ($module === 'login') {
    $authController = new AuthController();
    echo $authController->loginPage();
    exit;
}

if ($module === 'register') {
    $authController = new AuthController();
    echo $authController->registerPage();
    exit;
}

// All other routes require authentication (enforced inside BaseController)
switch ($module) {
    case 'accounts':
        $controller = new AccountController();
        echo $controller->index();
        break;
    case 'analytics':
        $controller = new AnalyticsController();
        echo $controller->index();
        break;
    case 'categories':
        $controller = new CategoryController();
        echo $controller->index();
        break;
    case 'contacts':
        $controller = new ContactController();
        echo $controller->index();
        break;
    case 'transactions':
        $controller = new TransactionController();
        echo $controller->index();
        break;
    case 'credit_cards':
        $controller = new CreditCardController();
        echo $controller->index();
        break;
    case 'reminders':
        $controller = new ReminderController();
        echo $controller->index();
        break;
    case 'loans':
        $controller = new LoanController();
        echo $controller->index();
        break;
    case 'lending':
        $controller = new LendingController();
        echo $controller->index();
        break;
    case 'investments':
        $controller = new InvestmentController();
        echo $controller->index();
        break;
    case 'sip':
        $controller = new SipController();
        echo $controller->index();
        break;
    case 'rental':
        $controller = new RentalController();
        echo $controller->index();
        break;
    case 'dashboard':
    default:
        $controller = new DashboardController();
        echo $controller->index();
        break;
}
