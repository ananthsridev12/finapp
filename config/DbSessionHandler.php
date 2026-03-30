<?php

namespace Config;

use PDO;

class DbSessionHandler implements \SessionHandlerInterface
{
    private PDO $db;

    public function __construct(Database $database)
    {
        $this->db = $database->connect();
        $this->ensureTable();
    }

    private function ensureTable(): void
    {
        $this->db->exec(
            'CREATE TABLE IF NOT EXISTS `sessions` (
                `id`         VARCHAR(128) NOT NULL PRIMARY KEY,
                `data`       MEDIUMTEXT   NOT NULL,
                `expires_at` DATETIME     NOT NULL,
                INDEX `idx_sessions_expires` (`expires_at`)
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci'
        );
    }

    public function open(string $path, string $name): bool { return true; }
    public function close(): bool { return true; }

    public function read(string $id): string|false
    {
        $stmt = $this->db->prepare(
            'SELECT data FROM sessions WHERE id = :id AND expires_at > NOW() LIMIT 1'
        );
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ? $row['data'] : '';
    }

    public function write(string $id, string $data): bool
    {
        $lifetime = (int) ini_get('session.gc_maxlifetime') ?: 86400;
        $stmt = $this->db->prepare(
            'INSERT INTO sessions (id, data, expires_at)
             VALUES (:id, :data, DATE_ADD(NOW(), INTERVAL :lifetime SECOND))
             ON DUPLICATE KEY UPDATE
                data = VALUES(data),
                expires_at = VALUES(expires_at)'
        );
        return $stmt->execute([
            ':id'       => $id,
            ':data'     => $data,
            ':lifetime' => $lifetime,
        ]);
    }

    public function destroy(string $id): bool
    {
        $stmt = $this->db->prepare('DELETE FROM sessions WHERE id = :id');
        return $stmt->execute([':id' => $id]);
    }

    public function gc(int $max_lifetime): int|false
    {
        $stmt = $this->db->prepare('DELETE FROM sessions WHERE expires_at < NOW()');
        $stmt->execute();
        return $stmt->rowCount();
    }
}
