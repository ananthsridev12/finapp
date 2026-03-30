<?php

namespace Controllers;

use Config\Database;
use Models\User;

class AuthController
{
    private Database $database;
    private User $userModel;

    public function __construct()
    {
        $this->database  = new Database();
        $this->userModel = new User($this->database);
    }

    public function loginPage(): string
    {
        $error = '';

        if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['form'] ?? '') === 'login') {
            $email    = trim((string) ($_POST['email'] ?? ''));
            $password = (string) ($_POST['password'] ?? '');

            if ($email === '' || $password === '') {
                $error = 'Email and password are required.';
            } else {
                $user = $this->userModel->findByEmail($email);
                if ($user && $this->userModel->verifyPassword($user, $password)) {
                    $_SESSION['user_id'] = $user['id'];
                    $_SESSION['user']    = [
                        'id'    => $user['id'],
                        'name'  => $user['name'],
                        'email' => $user['email'],
                    ];
                    header('Location: ' . $this->baseUrl() . '?module=dashboard');
                    exit;
                }
                $error = 'Invalid email or password.';
            }
        }

        ob_start();
        include __DIR__ . '/../views/login.php';
        return ob_get_clean();
    }

    public function registerPage(): string
    {
        $error   = '';
        $success = '';

        if ($_SERVER['REQUEST_METHOD'] === 'POST' && ($_POST['form'] ?? '') === 'register') {
            $name     = trim((string) ($_POST['name'] ?? ''));
            $email    = trim((string) ($_POST['email'] ?? ''));
            $password = (string) ($_POST['password'] ?? '');
            $confirm  = (string) ($_POST['confirm_password'] ?? '');

            if ($name === '' || $email === '' || $password === '') {
                $error = 'All fields are required.';
            } elseif (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
                $error = 'Please enter a valid email address.';
            } elseif (strlen($password) < 8) {
                $error = 'Password must be at least 8 characters.';
            } elseif ($password !== $confirm) {
                $error = 'Passwords do not match.';
            } elseif ($this->userModel->emailExists($email)) {
                $error = 'An account with this email already exists.';
            } else {
                $userId = $this->userModel->create($name, $email, $password);
                if ($userId > 0) {
                    $user = $this->userModel->getById($userId);
                    $_SESSION['user_id'] = $userId;
                    $_SESSION['user']    = [
                        'id'    => $userId,
                        'name'  => $user['name'] ?? $name,
                        'email' => $user['email'] ?? $email,
                    ];
                    header('Location: ' . $this->baseUrl() . '?module=dashboard');
                    exit;
                }
                $error = 'Registration failed. Please try again.';
            }
        }

        ob_start();
        include __DIR__ . '/../views/register.php';
        return ob_get_clean();
    }

    public function logout(): void
    {
        $_SESSION = [];
        if (ini_get('session.use_cookies')) {
            $p = session_get_cookie_params();
            setcookie(session_name(), '', time() - 42000,
                $p['path'], $p['domain'], $p['secure'], $p['httponly']);
        }
        session_destroy();
        header('Location: ' . $this->baseUrl() . '?module=login');
        exit;
    }

    private function baseUrl(): string
    {
        $scheme = (!empty($_SERVER['HTTPS']) && $_SERVER['HTTPS'] !== 'off') ? 'https' : 'http';
        $host   = $_SERVER['HTTP_HOST'] ?? 'localhost';
        $script = strtok($_SERVER['REQUEST_URI'] ?? '/', '?');
        return $scheme . '://' . $host . $script;
    }
}
