<?php

namespace Models;

use PDO;

class PaymentMethod extends BaseModel
{
    public function getAll(): array
    {
        $stmt = $this->db->prepare('SELECT id, name FROM payment_methods WHERE user_id = :user_id ORDER BY name ASC');
        $stmt->execute([':user_id' => $this->userId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function findOrCreate(string $name): ?int
    {
        $normalized = trim($name);
        if ($normalized === '') {
            return null;
        }

        $select = $this->db->prepare('SELECT id FROM payment_methods WHERE user_id = :user_id AND LOWER(name) = LOWER(:name) LIMIT 1');
        $select->execute([':user_id' => $this->userId, ':name' => $normalized]);
        $existing = $select->fetch(PDO::FETCH_ASSOC);
        if ($existing) {
            return (int) $existing['id'];
        }

        $insert = $this->db->prepare('INSERT INTO payment_methods (user_id, name, is_system) VALUES (:user_id, :name, 0)');
        $ok     = $insert->execute([':user_id' => $this->userId, ':name' => $normalized]);
        if (!$ok) {
            return null;
        }

        return (int) $this->db->lastInsertId();
    }
}
