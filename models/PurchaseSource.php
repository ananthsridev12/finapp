<?php

namespace Models;

use PDO;

class PurchaseSource extends BaseModel
{
    public function getParents(): array
    {
        $stmt = $this->db->prepare('SELECT id, name FROM purchase_sources WHERE user_id = :user_id AND parent_id IS NULL ORDER BY name ASC');
        $stmt->execute([':user_id' => $this->userId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getChildren(): array
    {
        $stmt = $this->db->prepare('SELECT id, parent_id, name FROM purchase_sources WHERE user_id = :user_id AND parent_id IS NOT NULL ORDER BY name ASC');
        $stmt->execute([':user_id' => $this->userId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function findOrCreateParent(string $name): ?int
    {
        $normalized = trim($name);
        if ($normalized === '') {
            return null;
        }

        $stmt = $this->db->prepare(
            'SELECT id FROM purchase_sources WHERE user_id = :user_id AND parent_id IS NULL AND LOWER(name) = LOWER(:name) LIMIT 1'
        );
        $stmt->execute([':user_id' => $this->userId, ':name' => $normalized]);
        $existing = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($existing) {
            return (int) $existing['id'];
        }

        $insert = $this->db->prepare('INSERT INTO purchase_sources (user_id, parent_id, name) VALUES (:user_id, NULL, :name)');
        $ok     = $insert->execute([':user_id' => $this->userId, ':name' => $normalized]);
        if (!$ok) {
            return null;
        }

        return (int) $this->db->lastInsertId();
    }

    public function findOrCreateChild(int $parentId, string $name): ?int
    {
        $normalized = trim($name);
        if ($parentId <= 0 || $normalized === '') {
            return null;
        }

        $stmt = $this->db->prepare(
            'SELECT id FROM purchase_sources WHERE user_id = :user_id AND parent_id = :parent_id AND LOWER(name) = LOWER(:name) LIMIT 1'
        );
        $stmt->execute([
            ':user_id'   => $this->userId,
            ':parent_id' => $parentId,
            ':name'      => $normalized,
        ]);
        $existing = $stmt->fetch(PDO::FETCH_ASSOC);
        if ($existing) {
            return (int) $existing['id'];
        }

        $insert = $this->db->prepare('INSERT INTO purchase_sources (user_id, parent_id, name) VALUES (:user_id, :parent_id, :name)');
        $ok     = $insert->execute([
            ':user_id'   => $this->userId,
            ':parent_id' => $parentId,
            ':name'      => $normalized,
        ]);
        if (!$ok) {
            return null;
        }

        return (int) $this->db->lastInsertId();
    }
}
