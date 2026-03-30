<?php

namespace Models;

use PDO;

class Investment extends BaseModel
{
    public function getAll(): array
    {
        $sql = <<<SQL
SELECT
    i.*,
    ins.current_price,
    ins.price_date,
    ins.isin,
    ins.scheme_code,
    ins.symbol,
    COALESCE(SUM(CASE WHEN it.transaction_type = 'buy' THEN it.units ELSE 0 END) -
             SUM(CASE WHEN it.transaction_type = 'sell' THEN it.units ELSE 0 END), 0) AS total_units,
    COALESCE(SUM(CASE WHEN it.transaction_type = 'buy' THEN it.amount ELSE 0 END), 0) AS total_invested,
    COALESCE(SUM(CASE WHEN it.transaction_type = 'sell' THEN it.amount ELSE 0 END), 0) AS total_redeemed
FROM investments i
LEFT JOIN instruments ins ON ins.id = i.instrument_id
LEFT JOIN investment_transactions it ON it.investment_id = i.id
WHERE i.user_id = :user_id
GROUP BY i.id, ins.current_price, ins.price_date, ins.isin, ins.scheme_code, ins.symbol
ORDER BY i.created_at DESC
SQL;
        $stmt = $this->db->prepare($sql);
        $stmt->execute([':user_id' => $this->userId]);
        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function create(array $input): bool
    {
        $sql  = 'INSERT INTO investments (user_id, instrument_id, type, name, notes) VALUES (:user_id, :instrument_id, :type, :name, :notes)';
        $stmt = $this->db->prepare($sql);

        return $stmt->execute([
            ':user_id'       => $this->userId,
            ':instrument_id' => !empty($input['instrument_id']) ? (int) $input['instrument_id'] : null,
            ':type'          => $input['type'] ?? 'other',
            ':name'          => $input['name'] ?? '',
            ':notes'         => $input['notes'] ?? null,
        ]);
    }

    public function createTransaction(array $input): bool
    {
        $sql  = 'INSERT INTO investment_transactions (investment_id, transaction_type, amount, units, transaction_date, account_id, notes) VALUES (:investment_id, :transaction_type, :amount, :units, :transaction_date, :account_id, :notes)';
        $stmt = $this->db->prepare($sql);

        return $stmt->execute([
            ':investment_id'   => (int) ($input['investment_id'] ?? 0),
            ':transaction_type'=> $input['transaction_type'] ?? 'buy',
            ':amount'          => (float) ($input['amount'] ?? 0),
            ':units'           => (float) ($input['units'] ?? 0),
            ':transaction_date'=> $input['transaction_date'] ?? date('Y-m-d'),
            ':account_id'      => !empty($input['account_id']) ? (int) $input['account_id'] : null,
            ':notes'           => $input['notes'] ?? null,
        ]);
    }

    public function getRecentTransactions(int $limit = 10): array
    {
        $sql = <<<SQL
SELECT
    it.*, i.name AS investment_name, a.account_name
FROM investment_transactions it
LEFT JOIN investments i ON i.id = it.investment_id AND i.user_id = :user_id
LEFT JOIN accounts a ON a.id = it.account_id
WHERE i.user_id = :user_id
ORDER BY it.transaction_date DESC, it.created_at DESC
LIMIT :limit
SQL;
        $stmt = $this->db->prepare($sql);
        $stmt->bindValue(':user_id', $this->userId, PDO::PARAM_INT);
        $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
        $stmt->execute();

        return $stmt->fetchAll(PDO::FETCH_ASSOC);
    }

    public function createWithId(array $input): int
    {
        $sql    = 'INSERT INTO investments (user_id, type, name, notes) VALUES (:user_id, :type, :name, :notes)';
        $stmt   = $this->db->prepare($sql);
        $result = $stmt->execute([
            ':user_id' => $this->userId,
            ':type'    => $input['type'] ?? 'mutual_fund',
            ':name'    => trim($input['name'] ?? 'Untitled'),
            ':notes'   => $input['notes'] ?? null,
        ]);
        return $result ? (int) $this->db->lastInsertId() : 0;
    }

    public function createTransactionWithLedger(array $input, string $fundingToken): bool
    {
        $investmentId = (int) ($input['investment_id'] ?? 0);
        $txType       = $input['transaction_type'] ?? 'buy';
        $amount       = (float) ($input['amount'] ?? 0);
        $units        = (float) ($input['units'] ?? 0);
        $txDate       = $input['transaction_date'] ?? date('Y-m-d');
        $notes        = trim($input['notes'] ?? '');

        if ($investmentId <= 0 || $amount <= 0) {
            return false;
        }

        $sql  = 'INSERT INTO investment_transactions (investment_id, transaction_type, amount, units, transaction_date, notes) VALUES (:investment_id, :transaction_type, :amount, :units, :transaction_date, :notes)';
        $stmt = $this->db->prepare($sql);
        $created = $stmt->execute([
            ':investment_id'    => $investmentId,
            ':transaction_type' => $txType,
            ':amount'           => $amount,
            ':units'            => $units > 0 ? $units : null,
            ':transaction_date' => $txDate,
            ':notes'            => $notes !== '' ? $notes : null,
        ]);

        if (!$created) {
            return false;
        }

        $invTxId = (int) $this->db->lastInsertId();

        if ($fundingToken !== '' && strpos($fundingToken, ':') !== false) {
            [$accountType, $accountIdRaw] = explode(':', $fundingToken, 2);
            $accountId    = (int) $accountIdRaw;
            $allowedTypes = ['savings', 'current', 'cash', 'wallet', 'other', 'credit_card'];
            if ($accountId > 0 && in_array($accountType, $allowedTypes, true)) {
                $entryNote = $notes !== '' ? $notes : ('Investment ' . $txType . ' #' . $investmentId);
                $stmt2     = $this->db->prepare(
                    'INSERT INTO transactions (user_id, transaction_date, account_type, account_id, transaction_type, amount, reference_type, reference_id, notes)
                     VALUES (:user_id, :transaction_date, :account_type, :account_id, :transaction_type, :amount, :reference_type, :reference_id, :notes)'
                );
                $stmt2->execute([
                    ':user_id'          => $this->userId,
                    ':transaction_date' => $txDate,
                    ':account_type'     => $accountType,
                    ':account_id'       => $accountId,
                    ':transaction_type' => $txType === 'sell' ? 'income' : 'expense',
                    ':amount'           => $amount,
                    ':reference_type'   => 'investment',
                    ':reference_id'     => $invTxId,
                    ':notes'            => $entryNote,
                ]);
                $stmt2->execute([
                    ':user_id'          => $this->userId,
                    ':transaction_date' => $txDate,
                    ':account_type'     => 'investment',
                    ':account_id'       => null,
                    ':transaction_type' => 'transfer',
                    ':amount'           => $amount,
                    ':reference_type'   => 'investment',
                    ':reference_id'     => $invTxId,
                    ':notes'            => $entryNote,
                ]);
            }
        }

        return true;
    }

    public function getSummary(): array
    {
        $stmt = $this->db->prepare('SELECT COUNT(*) AS total_investments FROM investments WHERE user_id = :user_id');
        $stmt->execute([':user_id' => $this->userId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        return [
            'count' => (int) $row['total_investments'],
        ];
    }

    public function getById(int $id): ?array
    {
        $stmt = $this->db->prepare('SELECT * FROM investments WHERE id = :id AND user_id = :user_id LIMIT 1');
        $stmt->execute([':id' => $id, ':user_id' => $this->userId]);
        $row = $stmt->fetch(PDO::FETCH_ASSOC);
        return $row ?: null;
    }

    public function update(array $input): bool
    {
        $id = (int) ($input['id'] ?? 0);
        if ($id <= 0) return false;
        $name = trim((string) ($input['name'] ?? ''));
        if ($name === '') return false;
        $stmt = $this->db->prepare('UPDATE investments SET type=:type, name=:name, notes=:notes WHERE id=:id AND user_id=:user_id');
        return $stmt->execute([
            ':type'    => $input['type'] ?? 'mutual_fund',
            ':name'    => $name,
            ':notes'   => $input['notes'] ?? null,
            ':id'      => $id,
            ':user_id' => $this->userId,
        ]);
    }
}
