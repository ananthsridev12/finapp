<?php

namespace Models;

use PDO;

class User extends BaseModel
{
    public function findByEmail(string $email): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM users WHERE email = :email LIMIT 1');
        $stmt->execute([':email' => strtolower(trim($email))]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }

    public function getById(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT id, name, email, created_at FROM users WHERE id = :id LIMIT 1');
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }

    public function create(string $name, string $email, string $password): int
    {
        $hash = password_hash($password, PASSWORD_BCRYPT, ['cost' => 12]);
        $stmt = $this->db->prepare(
            'INSERT INTO users (name, email, password_hash) VALUES (:name, :email, :password_hash)'
        );
        $ok = $stmt->execute([
            ':name'          => trim($name),
            ':email'         => strtolower(trim($email)),
            ':password_hash' => $hash,
        ]);
        return $ok ? (int) $this->db->lastInsertId() : 0;
    }

    public function emailExists(string $email): bool
    {
        $stmt = $this->db->prepare('SELECT COUNT(*) FROM users WHERE email = :email');
        $stmt->execute([':email' => strtolower(trim($email))]);
        return (int) $stmt->fetchColumn() > 0;
    }

    public function verifyPassword(array $user, string $password): bool
    {
        return password_verify($password, (string) ($user['password_hash'] ?? ''));
    }
}
