-- Add 'etf' to investments.type ENUM
ALTER TABLE `investments`
    MODIFY COLUMN `type` ENUM('mutual_fund','equity','etf','fd','rd','other') NOT NULL;
