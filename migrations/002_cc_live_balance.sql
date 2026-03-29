-- Migration 002: Reset credit card outstanding_balance and outstanding_principal
-- to their initial (user-entered) values, so balance can be calculated live
-- from the transactions table going forward.
--
-- Background: outstanding_balance was previously updated on every transaction
-- create/delete via applyTransactionMovement(). This caused balance to be stale
-- after transaction edits or direct DB changes. Going forward, balance is
-- calculated live: opening_outstanding + SUM(expense) - SUM(income).
--
-- NOTE: If you have EMI plans that updated outstanding_balance directly
-- (without a matching expense transaction), those amounts will be lost in this
-- reset. Re-enter them manually as opening_outstanding adjustment if needed.

UPDATE credit_cards cc
JOIN accounts a ON a.id = cc.account_id
SET
    cc.outstanding_balance = GREATEST(0, cc.outstanding_balance -
        COALESCE((
            SELECT SUM(CASE
                WHEN t.transaction_type = 'expense' THEN t.amount
                WHEN t.transaction_type = 'income'  THEN -t.amount
                ELSE 0
            END)
            FROM transactions t
            WHERE t.account_id = a.id
        ), 0)
    ),
    cc.outstanding_principal = GREATEST(0, cc.outstanding_principal -
        COALESCE((
            SELECT SUM(CASE
                WHEN t.transaction_type = 'expense' THEN t.amount
                WHEN t.transaction_type = 'income'  THEN -t.amount
                ELSE 0
            END)
            FROM transactions t
            WHERE t.account_id = a.id
        ), 0)
    );



SELECT
      a.id,
      a.bank_name,
      a.account_name,
      cc.outstanding_balance AS opening_outstanding,
      COALESCE(SUM(CASE
          WHEN t.transaction_type = 'expense' THEN t.amount
          WHEN t.transaction_type = 'income'  THEN -t.amount
          ELSE 0
      END), 0) AS net_transactions,
      GREATEST(0, cc.outstanding_balance + COALESCE(SUM(CASE
          WHEN t.transaction_type = 'expense' THEN t.amount
          WHEN t.transaction_type = 'income'  THEN -t.amount
          ELSE 0
      END), 0)) AS live_outstanding,
      cc.credit_limit
  FROM accounts a
  JOIN credit_cards cc ON cc.account_id = a.id
  LEFT JOIN transactions t ON t.account_id = a.id
  WHERE a.account_type = 'credit_card'
  GROUP BY a.id, a.bank_name, a.account_name, cc.outstanding_balance, cc.credit_limit
  ORDER BY a.bank_name;