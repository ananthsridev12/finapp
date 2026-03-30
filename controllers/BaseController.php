<?php

namespace Controllers;

use Config\Database;

class BaseController
{
    protected Database $database;
    protected int $userId = 0;
    protected array $currentUser = [];

    public function __construct()
    {
        $this->database = new Database();
        $this->requireAuth();
    }

    protected function requireAuth(): void
    {
        if (empty($_SESSION['user_id'])) {
            $scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
            $host   = $_SERVER['HTTP_HOST'] ?? 'localhost';
            $script = strtok($_SERVER['REQUEST_URI'] ?? '/', '?');
            header('Location: ' . $scheme . '://' . $host . $script . '?module=login');
            exit;
        }
        $this->userId      = (int) $_SESSION['user_id'];
        $this->currentUser = $_SESSION['user'] ?? [];
    }

    protected function render(string $viewPath, array $params = []): string
    {
        $params['currentUser'] = $this->currentUser;
        extract($params, EXTR_SKIP);
        ob_start();
        include __DIR__ . '/../views/' . $viewPath;
        $content = ob_get_clean();

        ob_start();
        include __DIR__ . '/../views/layout.php';
        return ob_get_clean();
    }
}
