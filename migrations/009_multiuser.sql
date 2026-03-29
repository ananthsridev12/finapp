-- Migration 009: Multi-user support
-- Creates users table and adds user_id to all relevant tables.
-- Existing single-user data is assigned to user_id = 1 (the first registered user).

-- 1. Users table
CREATE TABLE IF NOT EXISTS users (
    id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name          VARCHAR(100)  NOT NULL,
    email         VARCHAR(191)  NOT NULL UNIQUE,
    password_hash VARCHAR(255)  NOT NULL,
    created_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP     NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Placeholder default user — update email/password after running migration
INSERT IGNORE INTO users (id, name, email, password_hash)
VALUES (1, 'Owner', 'owner@localhost', '$2y$12$placeholder_change_me_via_register');

-- 2. Add user_id columns (all nullable first so existing rows don't fail)
ALTER TABLE accounts         ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE categories       ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE subcategories    ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE contacts         ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE payment_methods  ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE purchase_sources ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE reminders        ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE investments      ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE properties       ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE tenants          ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE loans            ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE lending_records  ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;
ALTER TABLE transactions     ADD COLUMN IF NOT EXISTS user_id INT UNSIGNED NULL AFTER id;

-- 3. Back-fill existing rows to owner (id = 1)
UPDATE accounts         SET user_id = 1 WHERE user_id IS NULL;
UPDATE categories       SET user_id = 1 WHERE user_id IS NULL;
UPDATE subcategories    SET user_id = 1 WHERE user_id IS NULL;
UPDATE contacts         SET user_id = 1 WHERE user_id IS NULL;
UPDATE payment_methods  SET user_id = 1 WHERE user_id IS NULL;
UPDATE purchase_sources SET user_id = 1 WHERE user_id IS NULL;
UPDATE reminders        SET user_id = 1 WHERE user_id IS NULL;
UPDATE investments      SET user_id = 1 WHERE user_id IS NULL;
UPDATE properties       SET user_id = 1 WHERE user_id IS NULL;
UPDATE tenants          SET user_id = 1 WHERE user_id IS NULL;
UPDATE loans            SET user_id = 1 WHERE user_id IS NULL;
UPDATE lending_records  SET user_id = 1 WHERE user_id IS NULL;
UPDATE transactions     SET user_id = 1 WHERE user_id IS NULL;

-- 4. Make user_id NOT NULL with FK references
ALTER TABLE accounts         MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_accounts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE categories       MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_categories_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE subcategories    MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_subcategories_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE contacts         MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_contacts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE payment_methods  MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_payment_methods_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE purchase_sources MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_purchase_sources_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE reminders        MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_reminders_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE investments      MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_investments_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE properties       MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_properties_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE tenants          MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_tenants_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE loans            MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_loans_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE lending_records  MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_lending_records_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;
ALTER TABLE transactions     MODIFY COLUMN user_id INT UNSIGNED NOT NULL,
                             ADD CONSTRAINT fk_transactions_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE;

-- 5. Indexes for common per-user queries
CREATE INDEX IF NOT EXISTS idx_accounts_user         ON accounts(user_id);
CREATE INDEX IF NOT EXISTS idx_categories_user       ON categories(user_id);
CREATE INDEX IF NOT EXISTS idx_contacts_user         ON contacts(user_id);
CREATE INDEX IF NOT EXISTS idx_transactions_user     ON transactions(user_id);
CREATE INDEX IF NOT EXISTS idx_loans_user            ON loans(user_id);
CREATE INDEX IF NOT EXISTS idx_lending_records_user  ON lending_records(user_id);
CREATE INDEX IF NOT EXISTS idx_investments_user      ON investments(user_id);
CREATE INDEX IF NOT EXISTS idx_reminders_user        ON reminders(user_id);
CREATE INDEX IF NOT EXISTS idx_properties_user       ON properties(user_id);
