-- Migration 010: Instruments master table

CREATE TABLE IF NOT EXISTS `instruments` (
    `id`               INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    `type`             ENUM('mutual_fund','equity','etf') NOT NULL,
    `name`             VARCHAR(255) NOT NULL,
    `isin`             VARCHAR(12) DEFAULT NULL,
    `scheme_code`      VARCHAR(20) DEFAULT NULL COMMENT 'AMFI scheme code for MF',
    `symbol`           VARCHAR(50) DEFAULT NULL COMMENT 'NSE symbol for equity/ETF e.g. RELIANCE.NS',
    `current_price`    DECIMAL(16,4) DEFAULT NULL,
    `price_date`       DATE DEFAULT NULL,
    `price_updated_at` TIMESTAMP NULL DEFAULT NULL,
    `is_active`        TINYINT(1) NOT NULL DEFAULT 1,
    `created_at`       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    `updated_at`       TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY `uq_isin` (`isin`),
    UNIQUE KEY `uq_scheme_code` (`scheme_code`),
    INDEX `idx_type` (`type`),
    INDEX `idx_symbol` (`symbol`),
    INDEX `idx_active` (`is_active`),
    FULLTEXT KEY `ft_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Add instrument_id to investments table
ALTER TABLE `investments`
    ADD COLUMN `instrument_id` INT UNSIGNED NULL DEFAULT NULL AFTER `type`,
    ADD CONSTRAINT `fk_investments_instrument` FOREIGN KEY (`instrument_id`) REFERENCES `instruments`(`id`) ON DELETE SET NULL;

CREATE INDEX `idx_investments_instrument` ON `investments`(`instrument_id`);
