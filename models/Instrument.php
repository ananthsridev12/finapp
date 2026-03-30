<?php

namespace Models;

use PDO;

class Instrument extends BaseModel
{
    /**
     * Search instruments by name (FULLTEXT for longer queries, LIKE for short ones).
     * Returns array of matching instruments for AJAX autocomplete.
     */
    public function search(string $query, string $type = '', int $limit = 15): array
    {
        $query = trim($query);
        if (strlen($query) < 2) return [];

        $where  = ['is_active = 1'];
        $params = [];

        if ($type !== '') {
            $where[]        = 'type = :type';
            $params[':type'] = $type;
        }

        // Use FULLTEXT search for longer queries, LIKE for short ones
        if (strlen($query) >= 3) {
            $where[]          = 'MATCH(name) AGAINST(:query IN BOOLEAN MODE)';
            $params[':query']  = $query . '*';
        } else {
            $where[]          = 'name LIKE :query';
            $params[':query']  = $query . '%';
        }

        $sql = 'SELECT id, type, name, isin, scheme_code, symbol, current_price, price_date
                FROM instruments
                WHERE ' . implode(' AND ', $where) . '
                ORDER BY is_active DESC, name ASC
                LIMIT ' . (int) $limit;

        $stmt = $this->db->prepare($sql);
        $stmt->execute($params);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function getById(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM instruments WHERE id = :id LIMIT 1');
        $stmt->execute([':id' => $id]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }

    public function getBySchemeCode(string $code): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM instruments WHERE scheme_code = :code LIMIT 1');
        $stmt->execute([':code' => $code]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }

    public function getBySymbol(string $symbol): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM instruments WHERE symbol = :symbol LIMIT 1');
        $stmt->execute([':symbol' => $symbol]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }

    public function upsertMF(string $schemeCode, string $name, string $isin, float $nav, string $priceDate): void
    {
        $stmt = $this->db->prepare(
            'INSERT INTO instruments (type, name, isin, scheme_code, current_price, price_date, price_updated_at)
             VALUES ("mutual_fund", :name, :isin, :scheme_code, :price, :price_date, NOW())
             ON DUPLICATE KEY UPDATE
                name              = VALUES(name),
                isin              = VALUES(isin),
                current_price     = VALUES(current_price),
                price_date        = VALUES(price_date),
                price_updated_at  = NOW()'
        );
        $isinVal = (trim($isin) !== '' && trim($isin) !== '-') ? trim($isin) : null;
        $stmt->execute([
            ':name'        => $name,
            ':isin'        => $isinVal,
            ':scheme_code' => $schemeCode,
            ':price'       => $nav > 0 ? $nav : null,
            ':price_date'  => $nav > 0 ? $priceDate : null,
        ]);
    }

    public function upsertEquityETF(string $symbol, string $name, string $isin, string $type): void
    {
        // ON DUPLICATE KEY on uq_scheme_code won't fire for equity; uses uq_symbol unique key
        $stmt = $this->db->prepare(
            'INSERT INTO instruments (type, name, isin, symbol)
             VALUES (:type, :name, :isin, :symbol)
             ON DUPLICATE KEY UPDATE
                name = VALUES(name),
                isin = VALUES(isin),
                type = VALUES(type)'
        );
        $stmt->execute([
            ':type'   => $type,
            ':name'   => $name,
            ':isin'   => $isin ?: null,
            ':symbol' => $symbol,
        ]);
    }

    public function updatePrice(int $id, float $price, string $priceDate): void
    {
        $stmt = $this->db->prepare(
            'UPDATE instruments SET current_price = :price, price_date = :date, price_updated_at = NOW() WHERE id = :id'
        );
        $stmt->execute([':price' => $price, ':date' => $priceDate, ':id' => $id]);
    }

    public function getEquityETFForPriceUpdate(): array
    {
        $stmt = $this->db->prepare(
            'SELECT id, symbol FROM instruments WHERE type IN ("equity","etf") AND symbol IS NOT NULL AND is_active = 1'
        );
        $stmt->execute();
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function countByType(): array
    {
        $stmt = $this->db->query('SELECT type, COUNT(*) as cnt FROM instruments GROUP BY type');
        return $stmt->fetchAll(PDO::FETCH_KEY_PAIR);
    }
}
