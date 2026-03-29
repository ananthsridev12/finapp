<?php

namespace Config;

use PDO;
use PDOException;

class Database
{
    private string $host;
    private string $dbName;
    private string $username;
    private string $password;
    private ?PDO $pdo = null;

    public function __construct()
    {
        $this->host     = (string) (getenv('DB_HOST') ?: 'localhost');
        $this->dbName   = (string) (getenv('DB_NAME') ?: '');
        $this->username = (string) (getenv('DB_USER') ?: '');
        $this->password = (string) (getenv('DB_PASS') ?: '');
    }

    public function connect(): PDO
    {
        if ($this->pdo === null) {
            $dsn = "mysql:host={$this->host};dbname={$this->dbName};charset=utf8mb4";
            try {
                $this->pdo = new PDO($dsn, $this->username, $this->password, [
                    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
                    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                ]);
            } catch (PDOException $exception) {
                die('Database connection failed: ' . $exception->getMessage());
            }
        }

        return $this->pdo;
    }
}
