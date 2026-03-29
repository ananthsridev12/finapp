<?php

namespace Models;

use PDO;

class Category extends BaseModel
{
    public function getAllWithSubcategories(): array
    {
        $sql = <<<SQL
SELECT
    c.id AS category_id,
    c.name AS category_name,
    c.type AS category_type,
    c.is_fuel AS category_is_fuel,
    c.exclude_from_analytics AS category_exclude_from_analytics,
    c.created_at AS category_created_at,
    sc.id AS sub_id,
    sc.name AS sub_name,
    sc.created_at AS sub_created_at
FROM categories c
LEFT JOIN subcategories sc ON sc.category_id = c.id AND sc.user_id = :user_id
WHERE c.user_id = :user_id
ORDER BY c.name ASC, sc.name ASC
SQL;
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':user_id' => $this->userId]);
        $rows = $stmt->fetchAll();

        $result = [];
        foreach ($rows as $row) {
            if (!isset($result[$row['category_id']])) {
                $result[$row['category_id']] = [
                    'id'                     => $row['category_id'],
                    'name'                   => $row['category_name'],
                    'type'                   => $row['category_type'],
                    'is_fuel'                => (bool) $row['category_is_fuel'],
                    'exclude_from_analytics' => (bool) $row['category_exclude_from_analytics'],
                    'created_at'             => $row['category_created_at'],
                    'subcategories'          => [],
                ];
            }

            if ($row['sub_id']) {
                $result[$row['category_id']]['subcategories'][] = [
                    'id'         => $row['sub_id'],
                    'name'       => $row['sub_name'],
                    'created_at' => $row['sub_created_at'],
                ];
            }
        }

        return array_values($result);
    }

    public function getCategoryList(): array
    {
        $stmt = $this->db->prepare('SELECT id, name FROM categories WHERE user_id = :user_id ORDER BY name ASC');
        $stmt->execute([':user_id' => $this->userId]);

        return $stmt->fetchAll();
    }

    public function createCategory(string $name, string $type, bool $isFuel = false): int
    {
        $sql  = 'INSERT INTO categories (user_id, name, type, is_fuel) VALUES (:user_id, :name, :type, :is_fuel)';
        $stmt = $this->db->prepare($sql);
        $ok   = $stmt->execute([
            ':user_id' => $this->userId,
            ':name'    => trim($name),
            ':type'    => $type,
            ':is_fuel' => $isFuel ? 1 : 0,
        ]);
        return $ok ? (int) $this->db->lastInsertId() : 0;
    }

    public function createSubcategory(int $categoryId, string $name): int
    {
        $sql  = 'INSERT INTO subcategories (user_id, category_id, name) VALUES (:user_id, :category_id, :name)';
        $stmt = $this->db->prepare($sql);
        $ok   = $stmt->execute([
            ':user_id'     => $this->userId,
            ':category_id' => $categoryId,
            ':name'        => trim($name),
        ]);
        return $ok ? (int) $this->db->lastInsertId() : 0;
    }

    public function count(): int
    {
        $stmt = $this->db->prepare('SELECT COUNT(*) FROM categories WHERE user_id = :user_id');
        $stmt->execute([':user_id' => $this->userId]);

        return (int) $stmt->fetchColumn();
    }

    public function getCategoryById(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM categories WHERE id = :id AND user_id = :user_id LIMIT 1');
        $stmt->execute([':id' => $id, ':user_id' => $this->userId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }

    public function getSubcategoryById(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM subcategories WHERE id = :id AND user_id = :user_id LIMIT 1');
        $stmt->execute([':id' => $id, ':user_id' => $this->userId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }

    public function updateCategory(array $input): bool
    {
        $id = (int) ($input['id'] ?? 0);
        if ($id <= 0) return false;
        $name = trim((string) ($input['name'] ?? ''));
        if ($name === '') return false;
        $type    = (string) ($input['type'] ?? 'expense');
        $allowed = ['income', 'expense', 'transfer'];
        if (!in_array($type, $allowed, true)) $type = 'expense';
        $isFuel  = isset($input['is_fuel'])  && $input['is_fuel']  ? 1 : 0;
        $exclude = isset($input['exclude_from_analytics']) && $input['exclude_from_analytics'] ? 1 : 0;
        $stmt    = $this->db->prepare('UPDATE categories SET name=:name, type=:type, is_fuel=:is_fuel, exclude_from_analytics=:exclude WHERE id=:id AND user_id=:user_id');
        return $stmt->execute([':name' => $name, ':type' => $type, ':is_fuel' => $isFuel, ':exclude' => $exclude, ':id' => $id, ':user_id' => $this->userId]);
    }

    public function toggleExcludeFromAnalytics(int $id): bool
    {
        if ($id <= 0) return false;
        $stmt = $this->db->prepare(
            'UPDATE categories SET exclude_from_analytics = 1 - exclude_from_analytics WHERE id = :id AND user_id = :user_id'
        );
        return $stmt->execute([':id' => $id, ':user_id' => $this->userId]);
    }

    public function updateSubcategory(array $input): bool
    {
        $id = (int) ($input['id'] ?? 0);
        if ($id <= 0) return false;
        $name = trim((string) ($input['name'] ?? ''));
        if ($name === '') return false;
        $stmt = $this->db->prepare('UPDATE subcategories SET name=:name WHERE id=:id AND user_id=:user_id');
        return $stmt->execute([':name' => $name, ':id' => $id, ':user_id' => $this->userId]);
    }
}
