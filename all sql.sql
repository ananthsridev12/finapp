-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Mar 29, 2026 at 09:17 PM
-- Server version: 5.7.23-23
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `de2shrnx_personalfin`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(10) UNSIGNED NOT NULL,
  `bank_name` varchar(150) NOT NULL,
  `account_name` varchar(150) NOT NULL,
  `account_type` enum('savings','current','credit_card','cash','wallet','other') NOT NULL DEFAULT 'savings',
  `account_type_id` int(10) UNSIGNED DEFAULT NULL,
  `account_number` varchar(64) DEFAULT NULL,
  `ifsc` varchar(32) DEFAULT NULL,
  `opening_balance` decimal(16,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `is_default` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `bank_name`, `account_name`, `account_type`, `account_type_id`, `account_number`, `ifsc`, `opening_balance`, `created_at`, `updated_at`, `is_default`) VALUES
(2, 'HDFC BANK', 'HDFC SAVINGS', 'savings', NULL, '895', 'TSI01', 463.53, '2026-03-04 15:30:28', '2026-03-21 12:12:42', 0),
(3, 'AXIS BANK', 'AXIS SAVING ACCOUNT', 'savings', NULL, '884', 'CHN01', 181.84, '2026-03-04 16:13:37', '2026-03-04 16:13:37', 0),
(4, 'IOB', 'INDIAN OVERSEAS BANK ACCOUNT', 'savings', NULL, '1319', 'NRGM001', 2383.58, '2026-03-04 16:21:40', '2026-03-24 16:03:38', 1),
(5, 'Cash', 'Cash', 'savings', NULL, NULL, NULL, 0.00, '2026-03-04 19:23:13', '2026-03-04 19:23:13', 0),
(13, 'IDFC FIRST BANK', 'FIRST SELECT', 'credit_card', 3, NULL, NULL, 0.00, '2026-03-04 20:48:43', '2026-03-20 18:52:10', 0),
(14, 'HDFC BANK', 'REGALIA CREDIT CARD', 'credit_card', 3, NULL, NULL, 0.00, '2026-03-06 18:56:17', '2026-03-20 07:32:00', 0),
(15, 'HDFC BANK', 'RUPAY CREDIT CARD', 'credit_card', 3, NULL, NULL, 0.00, '2026-03-06 19:03:39', '2026-03-20 18:50:20', 0),
(16, 'AXIS BANK', 'FLIPKART AXIS', 'credit_card', 3, NULL, NULL, 0.00, '2026-03-06 19:12:02', '2026-03-20 18:48:20', 0),
(17, 'AXIS BANK', 'AXIS NEO', 'credit_card', NULL, NULL, NULL, 0.00, '2026-03-06 19:12:58', '2026-03-06 19:12:58', 0),
(18, 'ICICI', 'AMAZON PAY', 'credit_card', NULL, NULL, NULL, 0.00, '2026-03-06 19:16:31', '2026-03-06 19:16:31', 0),
(19, 'RBL', 'Indian Oil XTRA Credit Card', 'credit_card', 3, NULL, NULL, 0.00, '2026-03-06 19:20:42', '2026-03-20 19:30:33', 0),
(20, 'Amazon Pay', 'Amazon Wallet', 'wallet', NULL, '9790777702', NULL, 134.00, '2026-03-13 08:22:42', '2026-03-13 09:20:04', 0),
(21, 'Flipkart', 'GIFT CARD', 'wallet', NULL, NULL, NULL, 0.00, '2026-03-13 09:19:22', '2026-03-13 09:19:22', 0),
(23, 'GPAY', 'UPI Lite', 'wallet', 5, NULL, NULL, 0.00, '2026-03-18 17:28:59', '2026-03-24 16:03:38', 0),
(25, 'IRCTC WALLET', 'IRCTC WALLET', 'wallet', 5, '9790777706', NULL, 1043.11, '2026-03-20 05:39:49', '2026-03-20 19:59:27', 0),
(28, 'IOCL', 'Indian Oil XTRA Credit Card', 'credit_card', 8, NULL, NULL, 0.00, '2026-03-20 20:34:03', '2026-03-20 20:34:03', 0);

-- --------------------------------------------------------

--
-- Table structure for table `account_types`
--

CREATE TABLE `account_types` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8_unicode_ci NOT NULL,
  `system_key` varchar(40) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `template` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT 'System type key this custom type is based on (savings, current, credit_card, cash, wallet, other)'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `account_types`
--

INSERT INTO `account_types` (`id`, `name`, `system_key`, `created_at`, `template`) VALUES
(1, 'Savings', 'savings', '2026-03-13 15:00:55', NULL),
(2, 'Current', 'current', '2026-03-13 15:00:55', NULL),
(3, 'Credit Card', 'credit_card', '2026-03-13 15:00:55', NULL),
(4, 'Cash', 'cash', '2026-03-13 15:00:55', NULL),
(5, 'Wallet', 'wallet', '2026-03-13 15:00:55', NULL),
(6, 'Other', 'other', '2026-03-13 15:00:55', NULL),
(8, 'Petrol Reward Points', NULL, '2026-03-20 20:34:03', 'credit_card');

-- --------------------------------------------------------

--
-- Table structure for table `bills`
--

CREATE TABLE `bills` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `due_date` date NOT NULL,
  `paid_amount` decimal(16,2) NOT NULL DEFAULT '0.00',
  `status` enum('pending','paid','missed') NOT NULL DEFAULT 'pending',
  `reminder_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` enum('income','expense','transfer') NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_fuel` tinyint(1) NOT NULL DEFAULT '0' COMMENT '1 = fuel category, used for surcharge tracking',
  `exclude_from_analytics` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `type`, `created_at`, `is_fuel`, `exclude_from_analytics`) VALUES
(1, 'Earnings', 'income', '2026-03-04 13:38:03', 0, 0),
(2, 'GROCERY', 'expense', '2026-03-04 15:31:42', 0, 0),
(3, 'SNACKS', 'expense', '2026-03-04 16:14:49', 0, 0),
(4, 'CREDIT CARD PAYMENT', 'transfer', '2026-03-04 16:14:56', 0, 1),
(5, 'SELF-TRANSFER', 'transfer', '2026-03-04 16:15:04', 0, 0),
(6, 'GROUP-SPENT', 'transfer', '2026-03-04 16:16:14', 0, 0),
(8, 'GROUPSPENT', 'expense', '2026-03-04 16:16:56', 0, 0),
(12, 'FOOD', 'expense', '2026-03-04 16:19:21', 0, 0),
(13, 'RENT', 'expense', '2026-03-04 19:18:01', 0, 0),
(14, 'Fuel', 'expense', '2026-03-04 19:18:18', 1, 0),
(15, 'Shopping', 'expense', '2026-03-04 19:18:34', 0, 0),
(16, 'House Rent', 'expense', '2026-03-04 19:18:57', 0, 0),
(17, 'Telecom', 'expense', '2026-03-04 19:19:09', 0, 0),
(18, 'EB Bill', 'expense', '2026-03-04 19:19:35', 0, 0),
(19, 'Tickets', 'expense', '2026-03-04 19:19:41', 0, 0),
(20, 'Parking Charges', 'expense', '2026-03-04 19:20:04', 0, 0),
(21, 'Digital Marketing', 'expense', '2026-03-04 19:20:10', 0, 0),
(22, 'Digital_Marketing', 'income', '2026-03-04 19:20:18', 0, 0),
(23, 'Cashback', 'income', '2026-03-04 19:20:24', 0, 0),
(24, 'Gas Cylinder', 'expense', '2026-03-04 19:20:29', 0, 0),
(25, 'Medicine', 'expense', '2026-03-04 19:20:32', 0, 0),
(26, 'Hospital', 'expense', '2026-03-04 19:20:35', 0, 0),
(27, 'Lended', 'expense', '2026-03-05 09:00:46', 0, 0),
(28, 'ATM Withdrawal', 'transfer', '2026-03-06 18:19:10', 0, 0),
(29, 'Reimbursement', 'income', '2026-03-06 18:20:37', 0, 0),
(30, 'Investment', 'transfer', '2026-03-06 18:30:35', 0, 0),
(31, 'TRANSFER', 'transfer', '2026-03-06 19:26:48', 0, 0),
(32, 'LEND-DEBIT', 'expense', '2026-03-06 19:27:13', 0, 0),
(33, 'LEND-CREDIT', 'income', '2026-03-06 19:27:20', 0, 0),
(34, 'Subscription', 'expense', '2026-03-20 10:59:18', 0, 0),
(35, 'Trading', 'expense', '2026-03-27 17:44:01', 0, 0);

-- --------------------------------------------------------

--
-- Table structure for table `contacts`
--

CREATE TABLE `contacts` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `address` text,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `contact_type` enum('tenant','lending','both','other') NOT NULL DEFAULT 'other',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `contacts`
--

INSERT INTO `contacts` (`id`, `name`, `mobile`, `email`, `address`, `city`, `state`, `contact_type`, `notes`, `created_at`) VALUES
(1, 'MUTHULAKSHMI', '9786514477', 'muthulakshmi051967@gmail.com', '', 'Nainararagam, Tenkasi', 'TAMILNADU', 'other', '', '2026-03-05 08:12:22'),
(2, 'Shunmugadevi', '6369889383', '', '', 'Chennai', 'Tamilnadu', 'other', 'Wife', '2026-03-06 22:01:06'),
(3, 'DhanLAP Office Food Split', '', '', '', '', '', 'other', 'DhanLAP Office Food Split', '2026-03-13 09:25:30'),
(4, 'Sriram', '9629289188', '', '', '', '', 'other', '', '2026-03-18 17:32:23'),
(5, 'Magizhvadana', '', '', '', '', '', 'other', '', '2026-03-19 14:38:14'),
(6, 'VJ', '', '', '', '', '', 'other', '', '2026-03-19 16:18:01'),
(7, 'Family', '', '', '', '', '', 'other', '', '2026-03-24 14:45:32'),
(8, 'Self', '', '', '', '', '', 'other', '', '2026-03-24 14:45:42');

-- --------------------------------------------------------

--
-- Table structure for table `credit_cards`
--

CREATE TABLE `credit_cards` (
  `id` int(10) UNSIGNED NOT NULL,
  `account_id` int(10) UNSIGNED DEFAULT NULL,
  `bank_name` varchar(150) NOT NULL,
  `card_name` varchar(150) NOT NULL,
  `credit_limit` decimal(16,2) NOT NULL DEFAULT '0.00',
  `billing_date` tinyint(3) UNSIGNED NOT NULL,
  `due_date` tinyint(3) UNSIGNED NOT NULL,
  `outstanding_balance` decimal(16,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `outstanding_principal` decimal(16,2) NOT NULL DEFAULT '0.00',
  `interest_rate` decimal(5,2) NOT NULL DEFAULT '0.00',
  `tenure_months` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `processing_fee` decimal(16,2) NOT NULL DEFAULT '0.00',
  `gst_rate` decimal(5,2) NOT NULL DEFAULT '0.00',
  `emi_amount` decimal(16,2) NOT NULL DEFAULT '0.00',
  `emi_start_date` date DEFAULT NULL,
  `points_balance` decimal(16,2) NOT NULL DEFAULT '0.00',
  `fuel_surcharge_rate` decimal(5,2) NOT NULL DEFAULT '1.00' COMMENT 'Surcharge % charged on fuel transactions (e.g. 1.00 = 1%)',
  `fuel_surcharge_min_refund` decimal(10,2) NOT NULL DEFAULT '400.00' COMMENT 'Minimum transaction amount (₹) to qualify for surcharge refund'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `credit_cards`
--

INSERT INTO `credit_cards` (`id`, `account_id`, `bank_name`, `card_name`, `credit_limit`, `billing_date`, `due_date`, `outstanding_balance`, `created_at`, `updated_at`, `outstanding_principal`, `interest_rate`, `tenure_months`, `processing_fee`, `gst_rate`, `emi_amount`, `emi_start_date`, `points_balance`, `fuel_surcharge_rate`, `fuel_surcharge_min_refund`) VALUES
(5, 13, 'IDFC FIRST BANK', 'FIRST SELECT', 390000.00, 24, 11, 453.00, '2026-03-04 20:48:43', '2026-03-20 18:52:10', 0.00, 0.00, 0, 0.00, 18.00, 0.00, NULL, 0.00, 1.00, 400.00),
(6, 14, 'HDFC BANK', 'HDFC-REGALIA', 394000.00, 19, 11, 937.00, '2026-03-06 18:56:17', '2026-03-20 07:32:00', 0.00, 0.00, 0, 0.00, 0.00, 0.00, NULL, 0.00, 1.00, 400.00),
(7, 15, 'HDFC BANK', 'RUPAY CREDIT CARD', 394000.00, 19, 9, 5761.25, '2026-03-06 19:03:39', '2026-03-20 18:50:20', 0.00, 0.00, 0, 0.00, 18.00, 0.00, NULL, 0.00, 1.00, 400.00),
(8, 16, 'AXIS BANK', 'FLIPKART AXIS', 375000.00, 20, 12, 32146.46, '2026-03-06 19:12:02', '2026-03-20 18:48:20', 0.00, 0.00, 0, 0.00, 18.00, 0.00, NULL, 0.00, 1.00, 400.00),
(9, 17, 'AXIS BANK', 'AXIS NEO', 375000.00, 18, 10, 0.00, '2026-03-06 19:12:58', '2026-03-06 19:12:58', 0.00, 0.00, 0, 0.00, 18.00, 0.00, NULL, 0.00, 1.00, 400.00),
(10, 18, 'ICICI', 'AMAZON PAY', 210000.00, 5, 23, 0.00, '2026-03-06 19:16:31', '2026-03-20 12:48:47', 0.00, 0.00, 0, 0.00, 18.00, 0.00, NULL, 0.00, 1.00, 400.00),
(11, 19, 'RBL', 'IOCL Xtra Credit Card', 25000.00, 23, 14, 6658.00, '2026-03-06 19:20:42', '2026-03-20 20:37:23', 0.00, 0.00, 0, 0.00, 18.00, 0.00, NULL, 852.00, 1.00, 400.00),
(15, 28, 'IOCL', 'XTRA REWARDS REDEMPTION', 0.00, 1, 1, 0.00, '2026-03-20 20:34:03', '2026-03-20 20:34:03', 0.00, 0.00, 0, 0.00, 18.00, 0.00, NULL, 9610.00, 0.00, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `credit_card_emi_payments`
--

CREATE TABLE `credit_card_emi_payments` (
  `id` int(10) UNSIGNED NOT NULL,
  `emi_plan_id` int(10) UNSIGNED NOT NULL,
  `credit_card_id` int(10) UNSIGNED NOT NULL,
  `account_id` int(10) UNSIGNED DEFAULT NULL,
  `payment_date` date NOT NULL,
  `principal_component` decimal(16,2) NOT NULL DEFAULT '0.00',
  `interest_component` decimal(16,2) NOT NULL DEFAULT '0.00',
  `processing_fee` decimal(16,2) NOT NULL DEFAULT '0.00',
  `gst_amount` decimal(16,2) NOT NULL DEFAULT '0.00',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `credit_card_emi_plans`
--

CREATE TABLE `credit_card_emi_plans` (
  `id` int(10) UNSIGNED NOT NULL,
  `credit_card_id` int(10) UNSIGNED NOT NULL,
  `plan_name` varchar(180) NOT NULL,
  `principal_amount` decimal(16,2) NOT NULL,
  `outstanding_principal` decimal(16,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL DEFAULT '0.00',
  `tenure_months` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `emi_amount` decimal(16,2) NOT NULL DEFAULT '0.00',
  `processing_fee` decimal(16,2) NOT NULL DEFAULT '0.00',
  `gst_rate` decimal(5,2) NOT NULL DEFAULT '0.00',
  `start_date` date NOT NULL,
  `next_due_date` date NOT NULL,
  `total_emis` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `paid_emis` smallint(5) UNSIGNED NOT NULL DEFAULT '0',
  `status` enum('active','closed','paused') NOT NULL DEFAULT 'active',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `credit_card_emi_schedule`
--

CREATE TABLE `credit_card_emi_schedule` (
  `id` int(10) UNSIGNED NOT NULL,
  `emi_plan_id` int(10) UNSIGNED NOT NULL,
  `installment_no` smallint(5) UNSIGNED NOT NULL,
  `due_date` date NOT NULL,
  `opening_principal` decimal(16,2) NOT NULL,
  `principal_component` decimal(16,2) NOT NULL,
  `interest_component` decimal(16,2) NOT NULL DEFAULT '0.00',
  `processing_fee` decimal(16,2) NOT NULL DEFAULT '0.00',
  `gst_amount` decimal(16,2) NOT NULL DEFAULT '0.00',
  `total_due` decimal(16,2) NOT NULL,
  `status` enum('upcoming','pending','paid','skipped') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `credit_card_payments`
--

CREATE TABLE `credit_card_payments` (
  `id` int(10) UNSIGNED NOT NULL,
  `credit_card_id` int(10) UNSIGNED NOT NULL,
  `account_id` int(10) UNSIGNED DEFAULT NULL,
  `payment_date` date NOT NULL,
  `principal_component` decimal(16,2) NOT NULL,
  `interest_component` decimal(16,2) NOT NULL,
  `processing_fee` decimal(16,2) NOT NULL DEFAULT '0.00',
  `gst_amount` decimal(16,2) NOT NULL DEFAULT '0.00',
  `is_emi` tinyint(1) NOT NULL DEFAULT '1',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `credit_card_rewards`
--

CREATE TABLE `credit_card_rewards` (
  `id` int(10) UNSIGNED NOT NULL,
  `credit_card_id` int(10) UNSIGNED NOT NULL,
  `points_redeemed` decimal(16,2) NOT NULL,
  `rate_per_point` decimal(16,4) NOT NULL DEFAULT '0.0000',
  `cash_value` decimal(16,2) NOT NULL DEFAULT '0.00',
  `redemption_date` date NOT NULL,
  `deposit_account_id` int(10) UNSIGNED DEFAULT NULL,
  `deposit_account_type` varchar(32) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'savings',
  `transaction_id` int(10) UNSIGNED DEFAULT NULL,
  `notes` text COLLATE utf8_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `investments`
--

CREATE TABLE `investments` (
  `id` int(10) UNSIGNED NOT NULL,
  `type` enum('mutual_fund','equity','fd','rd','other') NOT NULL,
  `name` varchar(150) NOT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `investments`
--

INSERT INTO `investments` (`id`, `type`, `name`, `notes`, `created_at`) VALUES
(2, 'mutual_fund', 'Mirae Asset ELSS Tax Savings', '', '2026-03-20 18:00:52');

-- --------------------------------------------------------

--
-- Table structure for table `investment_transactions`
--

CREATE TABLE `investment_transactions` (
  `id` int(10) UNSIGNED NOT NULL,
  `investment_id` int(10) UNSIGNED NOT NULL,
  `transaction_type` enum('buy','sell','dividend') NOT NULL,
  `amount` decimal(16,2) NOT NULL,
  `units` decimal(20,8) DEFAULT '0.00000000',
  `transaction_date` date NOT NULL,
  `account_id` int(10) UNSIGNED DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `investment_transactions`
--

INSERT INTO `investment_transactions` (`id`, `investment_id`, `transaction_type`, `amount`, `units`, `transaction_date`, `account_id`, `notes`, `created_at`) VALUES
(1, 2, 'buy', 3500.00, 99.84600000, '2023-01-05', NULL, '', '2026-03-20 18:02:12');

-- --------------------------------------------------------

--
-- Table structure for table `lending_records`
--

CREATE TABLE `lending_records` (
  `id` int(10) UNSIGNED NOT NULL,
  `contact_id` int(10) UNSIGNED NOT NULL,
  `principal_amount` decimal(16,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `lending_date` date NOT NULL,
  `due_date` date DEFAULT NULL,
  `total_repaid` decimal(16,2) NOT NULL DEFAULT '0.00',
  `outstanding_amount` decimal(16,2) NOT NULL,
  `status` enum('ongoing','closed','defaulted') NOT NULL DEFAULT 'ongoing',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `lending_records`
--

INSERT INTO `lending_records` (`id`, `contact_id`, `principal_amount`, `interest_rate`, `lending_date`, `due_date`, `total_repaid`, `outstanding_amount`, `status`, `notes`, `created_at`, `updated_at`) VALUES
(9, 4, 3528.60, 0.00, '2026-03-18', '2026-03-31', 0.00, 3528.60, 'ongoing', '', '2026-03-19 16:06:20', '2026-03-24 15:51:45'),
(10, 3, 120.00, 0.00, '2026-03-19', NULL, 0.00, 120.00, 'ongoing', 'Giri 120 and Self 170 (Group spend split)', '2026-03-19 16:10:35', '2026-03-19 16:10:35'),
(11, 6, 694314.00, 13.25, '2023-08-05', '0000-00-00', 145000.00, 549314.00, 'ongoing', '', '2026-03-19 16:19:11', '2026-03-24 15:50:37'),
(12, 3, 110.00, 0.00, '2026-03-25', NULL, 0.00, 110.00, 'ongoing', 'Group spend split', '2026-03-25 14:37:10', '2026-03-25 14:37:10'),
(13, 3, 50.00, 0.00, '2026-03-27', NULL, 5000.00, 0.00, 'closed', 'Group spend split', '2026-03-27 18:03:11', '2026-03-27 18:12:56'),
(14, 3, 120.00, 0.00, '2026-03-27', NULL, 5000.00, 0.00, 'closed', 'Group spend split', '2026-03-27 18:10:31', '2026-03-27 18:12:42');

-- --------------------------------------------------------

--
-- Table structure for table `lending_repayments`
--

CREATE TABLE `lending_repayments` (
  `id` int(11) NOT NULL,
  `lending_record_id` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `repayment_date` date NOT NULL,
  `deposit_account_type` varchar(30) COLLATE utf8_unicode_ci DEFAULT NULL,
  `deposit_account_id` int(11) DEFAULT NULL,
  `notes` text COLLATE utf8_unicode_ci,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `lending_repayments`
--

INSERT INTO `lending_repayments` (`id`, `lending_record_id`, `amount`, `repayment_date`, `deposit_account_type`, `deposit_account_id`, `notes`, `created_at`) VALUES
(1, 11, 5000.00, '2023-09-11', NULL, NULL, 'Sriram', '2026-03-19 18:47:04'),
(2, 11, 5000.00, '2023-10-14', NULL, NULL, 'Sriram', '2026-03-19 18:47:28'),
(3, 11, 5000.00, '2023-12-16', NULL, NULL, 'Sriram', '2026-03-19 18:50:38'),
(4, 11, 5000.00, '2024-02-07', NULL, NULL, 'Sriram', '2026-03-19 18:50:38'),
(5, 11, 5000.00, '2024-02-10', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(6, 11, 5000.00, '2024-03-07', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(7, 11, 5000.00, '2024-03-12', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(8, 11, 5000.00, '2024-04-08', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(9, 11, 5000.00, '2024-07-11', NULL, NULL, 'Arunika', '2026-03-19 18:50:38'),
(10, 11, 5000.00, '2024-08-20', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(11, 11, 5000.00, '2024-09-21', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(12, 11, 5000.00, '2024-10-21', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(13, 11, 5000.00, '2024-11-22', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(14, 11, 5000.00, '2024-12-22', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(15, 11, 5000.00, '2025-01-22', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(16, 11, 5000.00, '2025-02-21', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(17, 11, 5000.00, '2025-03-20', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(18, 11, 5000.00, '2025-04-21', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(19, 11, 5000.00, '2025-05-23', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(20, 11, 5000.00, '2025-06-21', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(21, 11, 5000.00, '2025-08-22', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(22, 11, 5000.00, '2025-09-22', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(23, 11, 5000.00, '2025-10-23', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(24, 11, 5000.00, '2025-11-22', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(25, 11, 5000.00, '2025-12-22', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(26, 11, 5000.00, '2026-01-23', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(27, 11, 5000.00, '2026-02-23', NULL, NULL, 'Vijayakumar', '2026-03-19 18:50:38'),
(28, 11, 5000.00, '2023-10-14', NULL, NULL, 'Sriram', '2026-03-19 18:51:43'),
(61, 11, 5000.00, '2026-03-24', 'savings', 4, 'Vijayakumar', '2026-03-24 14:55:55'),
(63, 14, 120.00, '2026-03-27', 'savings', 4, NULL, '2026-03-27 18:12:42'),
(64, 13, 50.00, '2026-03-27', 'savings', 4, NULL, '2026-03-27 18:12:56');

-- --------------------------------------------------------

--
-- Table structure for table `loans`
--

CREATE TABLE `loans` (
  `id` int(10) UNSIGNED NOT NULL,
  `loan_type` varchar(64) NOT NULL,
  `loan_name` varchar(150) NOT NULL,
  `repayment_type` enum('emi','interest_only') NOT NULL DEFAULT 'emi',
  `principal_amount` decimal(16,2) NOT NULL,
  `interest_rate` decimal(5,2) NOT NULL,
  `tenure_months` smallint(5) UNSIGNED NOT NULL,
  `emi_amount` decimal(16,2) NOT NULL,
  `processing_fee` decimal(16,2) DEFAULT '0.00',
  `gst` decimal(5,2) DEFAULT '0.00',
  `start_date` date NOT NULL,
  `outstanding_principal` decimal(16,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `linked_lending_id` int(11) DEFAULT NULL,
  `prior_payments` decimal(15,2) NOT NULL DEFAULT '0.00'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `loans`
--

INSERT INTO `loans` (`id`, `loan_type`, `loan_name`, `repayment_type`, `principal_amount`, `interest_rate`, `tenure_months`, `emi_amount`, `processing_fee`, `gst`, `start_date`, `outstanding_principal`, `created_at`, `updated_at`, `linked_lending_id`, `prior_payments`) VALUES
(7, 'personal', 'AXIS - PL', 'emi', 500000.00, 13.25, 28, 11441.00, 0.00, 0.00, '2023-08-05', 271008.00, '2026-03-19 11:01:33', '2026-03-24 15:30:07', 11, 366112.00),
(8, 'gold', 'IOB GOLD LOAN - JAMUNA CHAIN', 'interest_only', 88000.00, 8.00, 12, 586.67, 0.00, 0.00, '2025-10-10', 88000.00, '2026-03-19 14:55:50', '2026-03-19 14:55:50', NULL, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `loan_emi_schedule`
--

CREATE TABLE `loan_emi_schedule` (
  `id` int(10) UNSIGNED NOT NULL,
  `loan_id` int(10) UNSIGNED NOT NULL,
  `emi_date` date NOT NULL,
  `principal_component` decimal(16,2) NOT NULL,
  `interest_component` decimal(16,2) NOT NULL,
  `total_amount` decimal(16,2) GENERATED ALWAYS AS ((`principal_component` + `interest_component`)) STORED,
  `status` enum('pending','paid','missed') NOT NULL DEFAULT 'pending',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `loan_emi_schedule`
--

INSERT INTO `loan_emi_schedule` (`id`, `loan_id`, `emi_date`, `principal_component`, `interest_component`, `status`, `created_at`) VALUES
(121, 7, '2026-04-05', 8448.62, 2992.38, 'pending', '2026-03-19 11:01:33'),
(122, 7, '2026-05-05', 8541.91, 2899.09, 'pending', '2026-03-19 11:01:33'),
(123, 7, '2026-06-05', 8636.22, 2804.78, 'pending', '2026-03-19 11:01:33'),
(124, 7, '2026-07-05', 8731.58, 2709.42, 'pending', '2026-03-19 11:01:33'),
(125, 7, '2026-08-05', 8827.99, 2613.01, 'pending', '2026-03-19 11:01:33'),
(126, 7, '2026-09-05', 8925.47, 2515.53, 'pending', '2026-03-19 11:01:33'),
(127, 7, '2026-10-05', 9024.02, 2416.98, 'pending', '2026-03-19 11:01:33'),
(128, 7, '2026-11-05', 9123.66, 2317.34, 'pending', '2026-03-19 11:01:33'),
(129, 7, '2026-12-05', 9224.40, 2216.60, 'pending', '2026-03-19 11:01:33'),
(130, 7, '2027-01-05', 9326.25, 2114.75, 'pending', '2026-03-19 11:01:33'),
(131, 7, '2027-02-05', 9429.23, 2011.77, 'pending', '2026-03-19 11:01:33'),
(132, 7, '2027-03-05', 9533.35, 1907.65, 'pending', '2026-03-19 11:01:33'),
(133, 7, '2027-04-05', 9638.61, 1802.39, 'pending', '2026-03-19 11:01:33'),
(134, 7, '2027-05-05', 9745.04, 1695.96, 'pending', '2026-03-19 11:01:33'),
(135, 7, '2027-06-05', 9852.64, 1588.36, 'pending', '2026-03-19 11:01:33'),
(136, 7, '2027-07-05', 9961.43, 1479.57, 'pending', '2026-03-19 11:01:33'),
(137, 7, '2027-08-05', 10071.42, 1369.58, 'pending', '2026-03-19 11:01:33'),
(138, 7, '2027-09-05', 10182.62, 1258.38, 'pending', '2026-03-19 11:01:33'),
(139, 7, '2027-10-05', 10295.06, 1145.94, 'pending', '2026-03-19 11:01:33'),
(140, 7, '2027-11-05', 10408.73, 1032.27, 'pending', '2026-03-19 11:01:33'),
(141, 7, '2027-12-05', 10523.66, 917.34, 'pending', '2026-03-19 11:01:33'),
(142, 7, '2028-01-05', 10639.86, 801.14, 'pending', '2026-03-19 11:01:33'),
(143, 7, '2028-02-05', 10757.34, 683.66, 'pending', '2026-03-19 11:01:33'),
(144, 7, '2028-03-05', 10876.12, 564.88, 'pending', '2026-03-19 11:01:33'),
(145, 7, '2028-04-05', 10996.21, 444.79, 'pending', '2026-03-19 11:01:33'),
(146, 7, '2028-05-05', 11117.63, 323.37, 'pending', '2026-03-19 11:01:33'),
(147, 7, '2028-06-05', 11240.38, 200.62, 'pending', '2026-03-19 11:01:33'),
(148, 7, '2028-07-05', 6928.54, 76.50, 'pending', '2026-03-19 11:01:33'),
(149, 8, '2026-10-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(150, 8, '2026-11-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(151, 8, '2026-12-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(152, 8, '2027-01-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(153, 8, '2027-02-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(154, 8, '2027-03-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(155, 8, '2027-04-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(156, 8, '2027-05-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(157, 8, '2027-06-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(158, 8, '2027-07-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(159, 8, '2027-08-10', 0.00, 586.67, 'pending', '2026-03-19 14:55:50'),
(160, 8, '2027-09-10', 88000.00, 586.67, 'pending', '2026-03-19 14:55:50');

-- --------------------------------------------------------

--
-- Table structure for table `payment_methods`
--

CREATE TABLE `payment_methods` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(120) COLLATE utf8_unicode_ci NOT NULL,
  `is_system` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `payment_methods`
--

INSERT INTO `payment_methods` (`id`, `name`, `is_system`, `created_at`, `updated_at`) VALUES
(1, 'Gpay', 1, '2026-03-06 19:49:43', '2026-03-06 19:49:43'),
(2, 'Phonepe', 1, '2026-03-06 19:49:43', '2026-03-06 19:49:43'),
(3, 'Amazon Pay', 1, '2026-03-06 19:49:43', '2026-03-06 19:49:43'),
(4, 'Cred', 1, '2026-03-06 19:49:43', '2026-03-06 19:49:43'),
(5, 'POS Card Swipe/Tap', 1, '2026-03-06 19:49:43', '2026-03-06 19:49:43'),
(6, 'Payment Gateway', 1, '2026-03-06 19:49:43', '2026-03-06 19:49:43'),
(7, 'PayTM Wallet', 1, '2026-03-06 19:49:43', '2026-03-06 19:49:43'),
(8, 'Other', 1, '2026-03-06 19:49:43', '2026-03-06 19:49:43'),
(17, 'Cash', 0, '2026-03-09 13:42:54', '2026-03-09 13:42:54'),
(18, 'IRCTC WALLET', 0, '2026-03-20 05:42:15', '2026-03-20 05:42:15');

-- --------------------------------------------------------

--
-- Table structure for table `properties`
--

CREATE TABLE `properties` (
  `id` int(10) UNSIGNED NOT NULL,
  `property_name` varchar(200) NOT NULL,
  `address` text,
  `monthly_rent` decimal(16,2) NOT NULL,
  `security_deposit` decimal(16,2) NOT NULL DEFAULT '0.00',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `purchase_sources`
--

CREATE TABLE `purchase_sources` (
  `id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(160) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `purchase_sources`
--

INSERT INTO `purchase_sources` (`id`, `parent_id`, `name`, `created_at`) VALUES
(1, NULL, 'Daily Essentials', '2026-03-06 19:49:43'),
(2, NULL, 'Fuel & Utilities', '2026-03-06 19:49:43'),
(3, NULL, 'Online & Digital', '2026-03-06 19:49:43'),
(4, NULL, 'Retail & Lifestyle', '2026-03-06 19:49:43'),
(5, NULL, 'Food & Leisure', '2026-03-06 19:49:43'),
(6, NULL, 'Business & Services', '2026-03-06 19:49:43'),
(7, NULL, 'Other', '2026-03-06 19:49:43'),
(8, 1, 'Vegetable Store', '2026-03-06 19:49:43'),
(9, 1, 'Fruit Shop', '2026-03-06 19:49:43'),
(10, 1, 'Maligai Kadai', '2026-03-06 19:49:43'),
(11, 1, 'Aavin Milk', '2026-03-06 19:49:43'),
(12, 1, 'Rajan Stores', '2026-03-06 19:49:43'),
(13, 1, 'Maavu Kadai', '2026-03-06 19:49:43'),
(14, 1, 'Medplus', '2026-03-06 19:49:43'),
(15, 1, 'Water Can', '2026-03-06 19:49:43'),
(16, 1, 'Local Stores', '2026-03-06 19:49:43'),
(17, 1, 'Watercan Vehicle', '2026-03-06 19:49:43'),
(18, 2, 'Bharat Petroleum', '2026-03-06 19:49:43'),
(19, 2, 'Shell Petrol Bunk', '2026-03-06 19:49:43'),
(20, 2, 'TANGEDCO', '2026-03-06 19:49:43'),
(21, 2, 'Indane', '2026-03-06 19:49:43'),
(22, 2, 'Jio Fibre', '2026-03-06 19:49:43'),
(23, 2, 'Hathway', '2026-03-06 19:49:43'),
(24, 3, 'Flipkart', '2026-03-06 19:49:43'),
(25, 3, 'Amazon', '2026-03-06 19:49:43'),
(26, 3, 'Google Ads', '2026-03-06 19:49:43'),
(27, 3, 'IRCTC', '2026-03-06 19:49:43'),
(28, 3, 'Zepto', '2026-03-06 19:49:43'),
(29, 3, 'Ajio/Trends', '2026-03-06 19:49:43'),
(30, 4, 'Saravana Stores', '2026-03-06 19:49:43'),
(31, 4, 'The Chennai Silks', '2026-03-06 19:49:43'),
(32, 4, 'Clothing Stores', '2026-03-06 19:49:43'),
(33, 4, 'DMart', '2026-03-06 19:49:43'),
(34, 4, 'Toys Shop', '2026-03-06 19:49:43'),
(35, 5, 'Hotel', '2026-03-06 19:49:43'),
(36, 5, 'Snacks Shop', '2026-03-06 19:49:43'),
(37, 5, 'Sweets and Bakery', '2026-03-06 19:49:43'),
(38, 5, 'Tea Kadai', '2026-03-06 19:49:43'),
(39, 6, 'Zerotha', '2026-03-06 19:49:43'),
(40, 6, 'DhanLAP - Office Spent', '2026-03-06 19:49:43'),
(41, 7, 'Question type', '2026-03-06 19:49:43'),
(42, 7, 'Other', '2026-03-06 19:49:43'),
(43, NULL, 'Daily Essentials', '2026-03-06 19:51:01'),
(44, NULL, 'Fuel & Utilities', '2026-03-06 19:51:01'),
(45, NULL, 'Online & Digital', '2026-03-06 19:51:01'),
(46, NULL, 'Retail & Lifestyle', '2026-03-06 19:51:01'),
(47, NULL, 'Food & Leisure', '2026-03-06 19:51:01'),
(48, NULL, 'Business & Services', '2026-03-06 19:51:01'),
(49, NULL, 'Other', '2026-03-06 19:51:01'),
(85, 1, 'DMart', '2026-03-07 14:57:34'),
(86, 1, 'Nesam Supermarket', '2026-03-07 15:19:53'),
(87, 1, 'TEA', '2026-03-08 09:37:22'),
(88, 1, 'Appa', '2026-03-08 14:23:27'),
(89, 1, 'Restaurant', '2026-03-09 13:40:45'),
(90, 7, 'Apollo Pharmacy', '2026-03-10 18:39:12'),
(91, 1, 'Indian Oil Petroleum Pump', '2026-03-10 18:55:48'),
(92, 7, 'Zomato', '2026-03-13 08:21:31'),
(93, 7, 'Meat Stall', '2026-03-14 09:27:05'),
(94, 7, 'ACT Fiber', '2026-03-17 06:22:31'),
(95, 7, 'HP Petrol Bunk', '2026-03-17 17:38:48'),
(96, 7, 'TNSTC - SETC', '2026-03-18 17:34:32'),
(97, 7, 'BigBasket - TATA', '2026-03-18 18:18:12'),
(98, 7, 'Hardware Stores', '2026-03-19 06:56:55'),
(99, 7, 'Anthropic', '2026-03-20 11:00:25'),
(100, 7, 'Swiggy Instamart', '2026-03-20 11:07:29'),
(101, 7, 'Sewage Tanker', '2026-03-20 17:52:45'),
(102, 7, 'Temple Prasadam', '2026-03-21 17:12:24'),
(103, 7, 'Coffee Shop', '2026-03-24 14:52:48'),
(104, 7, 'YouTube', '2026-03-24 16:04:20'),
(105, 7, 'Fyers', '2026-03-27 17:44:01'),
(106, 7, 'Balamurugan Hospitals', '2026-03-28 06:19:34');

-- --------------------------------------------------------

--
-- Table structure for table `reminders`
--

CREATE TABLE `reminders` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(150) NOT NULL,
  `amount` decimal(16,2) DEFAULT NULL,
  `frequency` enum('once','monthly','quarterly','yearly') NOT NULL,
  `next_due_date` date NOT NULL,
  `status` enum('upcoming','completed','missed') NOT NULL DEFAULT 'upcoming',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `rental_contracts`
--

CREATE TABLE `rental_contracts` (
  `id` int(10) UNSIGNED NOT NULL,
  `property_id` int(10) UNSIGNED NOT NULL,
  `tenant_id` int(10) UNSIGNED NOT NULL,
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `deposit_amount` decimal(16,2) DEFAULT '0.00',
  `rent_amount` decimal(16,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `rental_transactions`
--

CREATE TABLE `rental_transactions` (
  `id` int(10) UNSIGNED NOT NULL,
  `contract_id` int(10) UNSIGNED NOT NULL,
  `rent_month` date NOT NULL,
  `due_date` date NOT NULL,
  `paid_amount` decimal(16,2) NOT NULL DEFAULT '0.00',
  `payment_status` enum('pending','partial','paid','overdue') NOT NULL DEFAULT 'pending',
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `sip_schedules`
--

CREATE TABLE `sip_schedules` (
  `id` int(10) UNSIGNED NOT NULL,
  `investment_id` int(10) UNSIGNED NOT NULL,
  `account_id` int(10) UNSIGNED NOT NULL,
  `sip_amount` decimal(16,2) NOT NULL,
  `sip_day` tinyint(3) UNSIGNED NOT NULL,
  `frequency` enum('monthly','quarterly','yearly') NOT NULL DEFAULT 'monthly',
  `start_date` date NOT NULL,
  `end_date` date DEFAULT NULL,
  `next_run_date` date DEFAULT NULL,
  `status` enum('active','paused','ended') NOT NULL DEFAULT 'active',
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `subcategories`
--

CREATE TABLE `subcategories` (
  `id` int(10) UNSIGNED NOT NULL,
  `category_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `subcategories`
--

INSERT INTO `subcategories` (`id`, `category_id`, `name`, `created_at`) VALUES
(1, 1, 'Salary - Ark Neo', '2026-03-04 13:38:10'),
(2, 2, 'MILK', '2026-03-04 15:31:52'),
(3, 2, 'VEGETABLES', '2026-03-04 15:32:27'),
(4, 8, 'DHANLAP', '2026-03-04 16:17:00'),
(5, 2, 'WATER', '2026-03-04 16:18:52'),
(6, 12, 'LUNCH', '2026-03-04 16:19:26'),
(7, 12, 'DINNER', '2026-03-04 16:19:30'),
(8, 12, 'BREAKFAST', '2026-03-04 16:19:36'),
(9, 12, 'TEA', '2026-03-04 16:19:40'),
(10, 2, 'MEAT', '2026-03-04 16:22:24'),
(11, 2, 'GROCERY', '2026-03-04 16:23:31'),
(12, 2, 'FRUITS', '2026-03-04 16:23:38'),
(13, 14, 'BIKE', '2026-03-04 19:18:24'),
(14, 14, 'CAR', '2026-03-04 19:18:28'),
(15, 15, 'DRESS', '2026-03-04 19:18:41'),
(16, 15, 'Home Needs', '2026-03-04 19:18:49'),
(17, 17, 'Mobile', '2026-03-04 19:19:15'),
(18, 17, 'Internet', '2026-03-04 19:19:18'),
(19, 19, 'Bus', '2026-03-04 19:19:44'),
(20, 19, 'TRAIN', '2026-03-04 19:19:48'),
(21, 19, 'Flight', '2026-03-04 19:19:55'),
(22, 19, 'Entertainment', '2026-03-04 19:20:52'),
(23, 16, 'Maintenance', '2026-03-06 18:17:13'),
(24, 29, 'Ark Neo', '2026-03-06 18:20:41'),
(25, 18, 'CHENNAI RENTAL', '2026-03-06 18:26:11'),
(26, 18, 'NRGM HOME', '2026-03-06 18:26:15'),
(27, 30, 'Investments001', '2026-03-06 18:31:18'),
(28, 16, 'House Rent', '2026-03-06 19:23:34'),
(29, 15, 'Toys', '2026-03-19 14:37:41'),
(30, 34, 'Anthropic Claude', '2026-03-20 10:59:35'),
(31, 3, 'Tea Snacks', '2026-03-24 14:47:51'),
(32, 3, 'Bakery Snacks', '2026-03-24 14:51:47'),
(33, 3, 'Coffee Shop and Snacks', '2026-03-24 14:52:48'),
(34, 3, 'Beach Shops', '2026-03-24 15:58:49'),
(35, 34, 'YouTube - Premium', '2026-03-24 16:04:20'),
(36, 35, 'Commodities Market', '2026-03-27 17:44:01');

-- --------------------------------------------------------

--
-- Table structure for table `tenants`
--

CREATE TABLE `tenants` (
  `id` int(10) UNSIGNED NOT NULL,
  `contact_id` int(10) UNSIGNED DEFAULT NULL,
  `name` varchar(150) NOT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `id_proof` varchar(100) DEFAULT NULL,
  `address` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `tenants`
--

INSERT INTO `tenants` (`id`, `contact_id`, `name`, `mobile`, `email`, `id_proof`, `address`, `created_at`) VALUES
(1, NULL, 'SRIRAM', '9629289188', '', '', '', '2026-03-04 17:05:35'),
(2, 1, 'MUTHULAKSHMI', '9786514477', 'muthulakshmi051967@gmail.com', '', '', '2026-03-05 08:50:29');

-- --------------------------------------------------------

--
-- Table structure for table `transactions`
--

CREATE TABLE `transactions` (
  `id` int(10) UNSIGNED NOT NULL,
  `transaction_date` date NOT NULL,
  `account_type` varchar(32) NOT NULL,
  `account_id` int(10) UNSIGNED DEFAULT NULL,
  `transaction_type` enum('income','expense','transfer') NOT NULL,
  `category_id` int(10) UNSIGNED DEFAULT NULL,
  `subcategory_id` int(10) UNSIGNED DEFAULT NULL,
  `payment_method_id` int(10) UNSIGNED DEFAULT NULL,
  `contact_id` int(10) UNSIGNED DEFAULT NULL,
  `purchase_source_id` int(10) UNSIGNED DEFAULT NULL,
  `amount` decimal(16,2) NOT NULL,
  `reference_type` varchar(64) DEFAULT NULL,
  `reference_id` int(10) UNSIGNED DEFAULT NULL,
  `notes` text,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `transactions`
--

INSERT INTO `transactions` (`id`, `transaction_date`, `account_type`, `account_id`, `transaction_type`, `category_id`, `subcategory_id`, `payment_method_id`, `contact_id`, `purchase_source_id`, `amount`, `reference_type`, `reference_id`, `notes`, `created_at`) VALUES
(3, '2026-03-01', 'bank', 2, 'income', 1, 1, NULL, NULL, NULL, 61817.00, '', NULL, '', '2026-03-04 15:31:28'),
(4, '2026-03-04', 'bank', 2, 'expense', 2, 3, NULL, NULL, NULL, 191.00, '', NULL, '', '2026-03-04 15:32:42'),
(5, '2026-03-02', 'bank', 3, 'expense', 3, NULL, NULL, NULL, NULL, 168.00, '', NULL, 'BAKERY', '2026-03-04 16:15:44'),
(6, '2026-03-02', 'bank', 3, 'income', 8, NULL, NULL, NULL, NULL, 210.00, '', NULL, '', '2026-03-04 16:17:54'),
(7, '2026-03-03', 'bank', 3, 'expense', 2, 3, NULL, NULL, NULL, 39.00, '', NULL, '', '2026-03-04 16:18:21'),
(8, '2026-03-04', 'bank', 3, 'expense', 2, 5, NULL, NULL, NULL, 65.00, '', NULL, '', '2026-03-04 16:19:03'),
(9, '2026-03-04', 'bank', 3, 'expense', 12, 6, NULL, NULL, NULL, 62.00, '', NULL, 'Lunch and Tea', '2026-03-04 16:19:55'),
(10, '2026-03-01', 'bank', 4, 'expense', 2, 3, NULL, NULL, NULL, 54.00, '', NULL, 'EGG', '2026-03-04 16:22:06'),
(11, '2026-03-01', 'bank', 4, 'expense', 2, 10, NULL, NULL, NULL, 520.00, '', NULL, 'MUTTON AND CHICKEN', '2026-03-04 16:22:42'),
(12, '2026-03-01', 'bank', 4, 'expense', 2, 11, NULL, NULL, NULL, 60.00, '', NULL, '', '2026-03-04 16:24:14'),
(13, '2026-03-02', 'bank', 4, 'expense', 2, 11, NULL, NULL, NULL, 59.00, '', NULL, 'EGG', '2026-03-04 16:24:31'),
(38, '2026-03-05', 'savings', 2, 'expense', 5, NULL, NULL, NULL, NULL, 12000.00, 'transfer', 3, '', '2026-03-06 18:15:39'),
(39, '2026-03-05', 'savings', 3, 'income', 5, NULL, NULL, NULL, NULL, 12000.00, 'transfer', 2, 'Transfer from account 2', '2026-03-06 18:15:39'),
(40, '2026-03-05', 'savings', 2, 'expense', 12, 6, NULL, NULL, NULL, 150.00, '', NULL, '', '2026-03-06 18:16:00'),
(41, '2026-03-05', 'savings', 2, 'expense', 2, 11, NULL, NULL, NULL, 53.00, '', NULL, 'EGG', '2026-03-06 18:16:39'),
(42, '2026-03-05', 'savings', 2, 'expense', 16, 23, NULL, NULL, NULL, 1248.00, '', NULL, '', '2026-03-06 18:17:47'),
(43, '2026-03-06', 'savings', 2, 'expense', 12, 9, NULL, NULL, NULL, 12.00, '', NULL, '', '2026-03-06 18:18:09'),
(44, '2026-03-06', 'savings', 2, 'expense', 28, NULL, NULL, NULL, NULL, 2000.00, 'transfer', 5, '', '2026-03-06 18:19:25'),
(45, '2026-03-06', 'savings', 5, 'income', 28, NULL, NULL, NULL, NULL, 2000.00, 'transfer', 2, 'Transfer from account 2', '2026-03-06 18:19:25'),
(46, '2026-03-06', 'savings', 2, 'expense', 2, 2, NULL, NULL, NULL, 2262.00, '', NULL, '', '2026-03-06 18:19:51'),
(47, '2026-03-06', 'savings', 2, 'income', 29, 24, NULL, NULL, NULL, 64875.00, '', NULL, '', '2026-03-06 18:21:00'),
(48, '2026-03-06', 'savings', 2, 'expense', 12, 6, NULL, NULL, NULL, 192.00, '', NULL, 'OUTSTANDING FOOD SPEND BY OFFICE FRIENDS', '2026-03-06 18:21:37'),
(49, '2026-03-06', 'savings', 2, 'expense', 12, 6, NULL, NULL, NULL, 145.00, '', NULL, 'OUTSTANDING FOOD SPEND BY OFFICE FRIENDS', '2026-03-06 18:21:51'),
(50, '2026-03-06', 'savings', 2, 'expense', 12, 6, NULL, NULL, NULL, 40.00, '', NULL, 'OUTSTANDING FOOD SPEND BY OFFICE FRIENDS', '2026-03-06 18:22:06'),
(51, '2025-03-05', 'savings', 4, 'expense', 18, 25, NULL, NULL, NULL, 501.00, '', NULL, '', '2026-03-06 18:26:27'),
(52, '2026-03-05', 'savings', 3, 'expense', 30, 27, NULL, NULL, NULL, 11441.00, 'AXIS_Investments', NULL, '', '2026-03-06 18:31:47'),
(53, '2026-03-05', 'savings', 3, 'income', 29, 24, NULL, NULL, NULL, 1000.00, '', NULL, 'STAMP-PAPER-CASHWITHDRAWN-IN-HDFC ACCOUNT. CASH TRANSFERRED TO IOB BY CHANDRA-ARKNEO', '2026-03-06 18:34:01'),
(54, '2026-03-07', 'savings', 2, 'expense', 4, NULL, NULL, NULL, NULL, 16789.00, '', NULL, 'hdfc rupay credit card bill payment', '2026-03-06 18:52:41'),
(55, '2026-03-07', 'savings', 2, 'expense', 4, NULL, NULL, NULL, NULL, 1438.00, '', NULL, 'hdfc regalia credit card bill payment', '2026-03-06 18:53:22'),
(56, '2026-03-07', 'savings', 2, 'expense', 4, NULL, NULL, NULL, NULL, 1315.99, '', NULL, 'CREDIT CARD BILL PAYMENT - AXIS NEO CREDIT CARD', '2026-03-06 19:05:48'),
(58, '2026-03-07', 'savings', 2, 'expense', 4, NULL, NULL, NULL, NULL, 26993.38, '', NULL, 'CREDIT CARD BILL PAYMENT - AXIS FLIPKART AXIS CARD', '2026-03-06 19:08:33'),
(59, '2026-03-07', 'savings', 2, 'expense', 4, NULL, NULL, NULL, NULL, 453.00, 'transfer', 13, 'CREDIT CARD BILL PAYMENT - IDFC FIRST SELECT CREDIT CARD', '2026-03-06 19:14:03'),
(60, '2026-03-07', 'credit_card', 13, 'income', 4, NULL, NULL, NULL, NULL, 453.00, 'transfer', 2, 'Transfer from account 2', '2026-03-06 19:14:03'),
(61, '2026-03-07', 'savings', 2, 'expense', 16, 28, NULL, NULL, NULL, 15000.00, '170,Bliss,F2', NULL, 'Chennai House Rent-Thazhambur', '2026-03-06 19:24:21'),
(62, '2026-03-07', 'savings', 2, 'expense', 32, NULL, 1, 2, NULL, 30000.00, '', NULL, 'Lent money returned', '2026-03-06 22:02:16'),
(63, '2026-03-07', 'savings', 2, 'expense', 2, 12, 1, NULL, 16, 55.00, '', NULL, 'Bought Banana', '2026-03-07 06:06:48'),
(64, '2026-03-07', 'credit_card', 16, 'expense', 15, 16, 5, NULL, 85, 3660.28, '', NULL, 'Purchased grocery, toys, home and kitchen needs.', '2026-03-07 14:57:34'),
(65, '2026-03-07', 'savings', 2, 'expense', 2, 11, 1, NULL, 86, 54.00, '', NULL, 'Idli Maavu', '2026-03-07 15:19:53'),
(66, '2026-03-08', 'savings', 2, 'expense', 2, 10, 1, NULL, 16, 320.00, '', NULL, 'Chicken 1kg 320\r\n\r\nFirst paid 32 then paid 288', '2026-03-08 09:36:04'),
(67, '2026-03-08', 'savings', 2, 'expense', 3, NULL, 1, NULL, 87, 34.00, '', NULL, '', '2026-03-08 09:37:22'),
(68, '2026-03-08', 'savings', 2, 'expense', 2, 5, 1, NULL, 15, 30.00, '', NULL, '', '2026-03-08 09:37:56'),
(69, '2026-03-08', 'savings', 2, 'expense', 2, 11, 1, NULL, 10, 55.00, '', NULL, 'Egg and others', '2026-03-08 09:39:02'),
(70, '2026-03-08', 'savings', 2, 'expense', 2, 11, 1, NULL, 86, 20.00, '', NULL, '', '2026-03-08 09:49:27'),
(71, '2026-03-08', 'savings', 2, 'expense', 2, 11, 1, NULL, 88, 578.00, '', NULL, 'Idli Rice and Meals Rice', '2026-03-08 14:23:27'),
(72, '2026-03-09', 'savings', 2, 'expense', 3, NULL, 1, NULL, 16, 30.00, '', NULL, 'Peanuts', '2026-03-09 13:39:59'),
(73, '2026-03-09', 'savings', 2, 'expense', 12, 6, 1, NULL, 89, 120.00, '', NULL, '', '2026-03-09 13:40:45'),
(74, '2026-03-09', 'savings', 5, 'expense', NULL, NULL, 17, NULL, 40, 1100.00, '', NULL, 'Stamp paper 1000rs and 100rs commission to stamp vendor', '2026-03-09 13:42:54'),
(75, '2026-03-09', 'credit_card', 16, 'expense', 15, 15, 6, NULL, 24, 654.00, '', NULL, 'Bought Redtape sandal for Ananth', '2026-03-09 17:13:41'),
(76, '2026-03-10', 'savings', 2, 'expense', 2, 3, 1, NULL, 16, 99.00, '', NULL, '', '2026-03-10 03:00:26'),
(77, '2026-03-10', 'savings', 2, 'expense', 32, NULL, 1, NULL, 89, 330.00, '', NULL, 'Split lunch with sunil c, giri, arshath', '2026-03-10 08:46:19'),
(78, '2026-03-10', 'savings', 2, 'expense', 12, 6, 1, NULL, 89, 110.00, '', NULL, 'Lunch - Meals\r\nOriginal payment was 440, added remaining 330 to split expense', '2026-03-10 08:47:40'),
(79, '2026-03-10', 'savings', 2, 'expense', 25, NULL, 1, NULL, 90, 219.46, '', NULL, 'Magizh Cold medicines', '2026-03-10 18:39:12'),
(80, '2026-03-10', 'savings', 4, 'income', 33, NULL, 1, NULL, NULL, 20.00, '', NULL, 'Asish peanuts', '2026-03-10 18:42:29'),
(81, '2026-03-10', 'savings', 2, 'expense', 12, 6, 1, NULL, 89, 56.66, '', NULL, '', '2026-03-10 18:43:21'),
(82, '2026-03-10', 'savings', 2, 'expense', 8, 4, 1, NULL, 36, 60.00, '', NULL, 'Ashish, Sathish, self', '2026-03-10 18:44:19'),
(84, '2026-03-11', 'savings', 2, 'expense', 25, NULL, 1, NULL, 90, 139.05, '', NULL, 'Bought cold medicine for Jamuna', '2026-03-11 17:00:29'),
(85, '2026-03-12', 'credit_card', 18, 'expense', 12, 6, 1, NULL, 89, 162.95, '', NULL, 'Bought ss biryani smile chicken briyani combo, shared with Satheesh dhanlap and split bill. Original bill was 325.95', '2026-03-12 13:22:02'),
(86, '2026-03-12', 'credit_card', 18, 'expense', 32, NULL, 1, NULL, 89, 163.00, '', NULL, 'Lend to Satheesh dhanlap.\r\nGroup split bill', '2026-03-12 13:23:05'),
(87, '2026-03-12', 'savings', 2, 'expense', 2, 3, 1, NULL, 10, 171.00, '', NULL, '', '2026-03-13 08:14:29'),
(88, '2026-03-12', 'savings', 2, 'expense', 2, 11, 1, NULL, 86, 60.00, '', NULL, '', '2026-03-13 08:15:07'),
(89, '2026-03-12', 'savings', 2, 'expense', 2, 5, 1, NULL, 86, 105.00, '', NULL, '', '2026-03-13 08:15:31'),
(90, '2026-03-13', 'savings', 2, 'expense', 2, 11, NULL, NULL, 86, 55.00, '', NULL, 'Egg', '2026-03-13 08:16:04'),
(91, '2026-03-13', 'savings', 2, 'expense', 12, 8, 1, NULL, 89, 50.00, '', NULL, '', '2026-03-13 08:16:28'),
(92, '2026-03-13', 'savings', 2, 'expense', 25, NULL, NULL, NULL, 90, 34.00, '', NULL, 'ANANTH SRIDEV COLD MEDICINES', '2026-03-13 08:16:54'),
(93, '2026-03-13', 'savings', 2, 'expense', 32, NULL, 3, NULL, 92, 196.65, '', NULL, 'Bought Lunch for Giri, Sunil and Self', '2026-03-13 08:21:31'),
(94, '2026-03-13', 'other', 20, 'expense', 12, 6, 6, NULL, 92, 134.00, '', NULL, '', '2026-03-13 08:23:19'),
(95, '2026-03-12', 'credit_card', 16, 'expense', 2, 11, 6, NULL, 24, 618.00, '', NULL, 'Bought Home Needs like toilet cleaning liquid, bathroom liquid, tooth brush etc.', '2026-03-13 08:26:02'),
(106, '2026-03-14', 'savings', 2, 'expense', 2, 10, 1, NULL, 93, 1060.00, '', NULL, 'NS Milla Biryani - Kari kadai. Meat Shop', '2026-03-14 09:27:05'),
(107, '2026-03-14', 'savings', 2, 'expense', 3, NULL, 1, NULL, 86, 94.00, '', NULL, 'SNACKS AND CURD', '2026-03-14 09:27:45'),
(108, '2026-03-14', 'savings', 2, 'expense', 2, 11, 1, NULL, 10, 94.00, '', NULL, '', '2026-03-14 15:58:08'),
(109, '2026-03-14', 'savings', 2, 'expense', 2, 11, 1, NULL, 86, 60.00, '', NULL, 'Pocket Maavu', '2026-03-14 16:01:48'),
(110, '2026-03-15', 'savings', 2, 'expense', 4, NULL, 8, NULL, NULL, 5770.00, 'transfer', 19, 'Credit Card Payment', '2026-03-16 07:31:56'),
(112, '2026-03-16', 'savings', 2, 'expense', 3, NULL, 1, NULL, 37, 112.00, '', NULL, 'Bought snacks', '2026-03-16 17:37:14'),
(113, '2026-03-16', 'savings', 2, 'expense', 2, 3, 1, NULL, 10, 165.00, '', NULL, 'Vegetables l', '2026-03-16 17:37:49'),
(114, '2026-03-16', 'savings', 2, 'expense', 2, 5, 1, NULL, 86, 65.00, '', NULL, '', '2026-03-16 17:38:16'),
(115, '2026-03-17', 'savings', 2, 'expense', 17, 18, 1, NULL, 94, 647.82, '', NULL, '', '2026-03-17 06:22:31'),
(117, '2026-03-17', 'savings', 2, 'expense', 2, 3, 1, NULL, 10, 13.00, '', NULL, '', '2026-03-17 17:27:23'),
(118, '2026-03-17', 'savings', 2, 'expense', 2, 3, 1, NULL, 8, 231.00, '', NULL, 'Vegetables and Fruits', '2026-03-17 17:37:44'),
(119, '2026-03-17', 'savings', 2, 'expense', 14, 13, 1, NULL, 95, 100.00, '', NULL, 'DIO', '2026-03-17 17:38:48'),
(120, '2026-03-17', 'savings', 2, 'expense', 2, 11, 1, NULL, 86, 77.00, '', NULL, '', '2026-03-17 17:39:25'),
(121, '2026-03-17', 'savings', 2, 'expense', 2, 11, 1, NULL, 86, 54.00, '', NULL, 'Maavu', '2026-03-17 17:40:06'),
(122, '2026-03-18', 'savings', 4, 'income', 6, NULL, 1, NULL, NULL, 10.00, '', NULL, '', '2026-03-18 17:27:27'),
(123, '2026-03-18', 'savings', 2, 'expense', 14, 13, 1, NULL, 95, 200.00, '', NULL, '200 Petrol for Dio', '2026-03-18 17:28:07'),
(124, '2026-03-18', 'savings', 2, 'expense', 31, NULL, 1, NULL, NULL, 200.00, 'transfer', 23, '', '2026-03-18 17:30:51'),
(125, '2026-03-18', 'wallet', 23, 'income', 31, NULL, 1, NULL, NULL, 200.00, 'transfer', 2, 'Transfer from account 2', '2026-03-18 17:30:51'),
(127, '2026-03-18', 'savings', 2, 'expense', 3, NULL, 1, NULL, 37, 76.00, '', NULL, 'Masala Puri and Buns', '2026-03-18 17:40:36'),
(128, '2026-03-18', 'wallet', 23, 'expense', 2, 11, 1, NULL, 97, 100.58, '', NULL, '', '2026-03-18 18:18:12'),
(129, '2026-03-18', 'savings', 2, 'expense', 31, NULL, 1, NULL, NULL, 200.00, '', 5, '', '2026-03-18 18:18:53'),
(130, '2026-03-18', 'wallet', 23, 'income', 31, NULL, 1, NULL, NULL, 200.00, 'transfer', 5, 'Transfer from account 5', '2026-03-18 18:18:53'),
(131, '2026-03-19', 'wallet', 23, 'expense', 15, NULL, 1, NULL, 98, 5.00, '', NULL, 'Bought Aani Wood', '2026-03-19 06:56:55'),
(133, '2026-03-19', 'credit_card', 18, 'expense', 17, 17, 6, 1, 25, 349.00, '', NULL, 'Monthly Mobile Recharge', '2026-03-19 08:00:42'),
(143, '2026-03-19', 'wallet', 23, 'expense', 15, 29, 1, 5, 34, 100.00, '', NULL, 'Bought Magnetic Skate for Magizh Pappa', '2026-03-19 14:38:38'),
(147, '2026-03-19', 'savings', 2, 'expense', 31, NULL, 1, NULL, NULL, 200.00, 'transfer', 23, '', '2026-03-19 15:15:35'),
(148, '2026-03-19', 'wallet', 23, 'income', 31, NULL, 1, NULL, NULL, 200.00, 'transfer', 2, 'Transfer from account 2', '2026-03-19 15:15:35'),
(149, '2026-03-19', 'savings', 2, 'expense', 31, NULL, 1, NULL, NULL, 200.00, 'transfer', 23, '', '2026-03-19 15:16:43'),
(150, '2026-03-19', 'wallet', 23, 'income', 31, NULL, 1, NULL, NULL, 200.00, 'transfer', 2, 'Transfer from account 2', '2026-03-19 15:16:43'),
(153, '2026-03-18', 'credit_card', 15, 'expense', 27, NULL, NULL, NULL, NULL, 2460.00, 'lending', 9, 'Lending disbursal to contact #4', '2026-03-19 16:06:20'),
(154, '2026-03-18', 'lending', NULL, 'transfer', 27, NULL, NULL, NULL, NULL, 2460.00, 'lending', 9, 'Lending disbursal to contact #4', '2026-03-19 16:06:20'),
(155, '2026-03-19', 'wallet', 23, 'expense', 12, 6, 1, 3, 89, 170.00, ' ', NULL, 'Giri 120 and Self 170', '2026-03-19 16:10:35'),
(156, '2026-03-19', 'wallet', 23, 'expense', 27, NULL, NULL, NULL, NULL, 120.00, 'lending', 10, 'Giri 120 and Self 170 (Group spend split)', '2026-03-19 16:10:35'),
(157, '2026-03-19', 'lending', NULL, 'transfer', 27, NULL, NULL, NULL, NULL, 120.00, 'lending', 10, 'Giri 120 and Self 170 (Group spend split)', '2026-03-19 16:10:35'),
(158, '2026-03-19', 'savings', 4, 'income', 6, NULL, 1, NULL, NULL, 100.00, '', NULL, '', '2026-03-19 20:19:08'),
(159, '2026-03-20', 'savings', 2, 'expense', 5, NULL, 1, NULL, 27, 1500.00, 'transfer', 25, 'WALLET RECHARGE', '2026-03-20 05:40:54'),
(160, '2026-03-20', 'wallet', 25, 'income', 5, NULL, 1, NULL, 27, 1500.00, 'transfer', 2, 'Transfer from account 2', '2026-03-20 05:40:54'),
(162, '2026-03-20', 'wallet', 23, 'expense', 2, 5, 1, NULL, 86, 70.00, '', NULL, '', '2026-03-20 07:28:10'),
(163, '2026-03-19', 'credit_card', 16, 'expense', 34, 30, 6, NULL, 99, 1935.59, '', NULL, 'Anthropic Claude', '2026-03-20 11:00:25'),
(164, '2026-03-18', 'credit_card', 16, 'income', 23, NULL, NULL, NULL, NULL, 274.00, '', NULL, '', '2026-03-20 11:01:19'),
(165, '2026-03-12', 'credit_card', 13, 'expense', 2, 11, 6, NULL, 100, 1031.00, '', NULL, 'Purchased diapers, and grocery', '2026-03-20 11:07:29'),
(167, '2026-03-20', 'wallet', 23, 'expense', 3, NULL, 1, NULL, 36, 30.00, '', NULL, 'Snacks', '2026-03-20 17:49:09'),
(168, '2026-03-20', 'wallet', 23, 'expense', 2, 11, 1, NULL, NULL, 125.00, '', NULL, 'FRUITS AND EGG', '2026-03-20 17:49:40'),
(169, '2026-03-20', 'savings', 2, 'expense', 31, NULL, 1, NULL, NULL, 200.00, 'transfer', 23, '', '2026-03-20 17:50:25'),
(170, '2026-03-20', 'wallet', 23, 'income', 31, NULL, 1, NULL, NULL, 200.00, 'transfer', 2, 'Transfer from account 2', '2026-03-20 17:50:25'),
(171, '2026-03-20', 'savings', 2, 'expense', 31, NULL, 1, NULL, NULL, 1.00, 'transfer', 23, '', '2026-03-20 17:50:48'),
(172, '2026-03-20', 'wallet', 23, 'income', 31, NULL, 1, NULL, NULL, 1.00, 'transfer', 2, 'Transfer from account 2', '2026-03-20 17:50:48'),
(173, '2026-03-20', 'savings', 2, 'expense', 31, NULL, 1, NULL, NULL, 500.00, 'transfer', 23, '', '2026-03-20 17:52:02'),
(174, '2026-03-20', 'wallet', 23, 'income', 31, NULL, 1, NULL, NULL, 500.00, 'transfer', 2, 'Transfer from account 2', '2026-03-20 17:52:02'),
(175, '2026-03-20', 'savings', 2, 'expense', 16, 23, 1, NULL, 101, 1800.00, '', NULL, 'Sewage', '2026-03-20 17:52:45'),
(176, '2026-03-10', 'credit_card', 19, 'expense', 14, 13, 5, NULL, 91, 500.00, '', NULL, '', '2026-03-20 19:25:15'),
(177, '2026-03-15', 'credit_card', 19, 'income', 4, NULL, 6, NULL, NULL, 5770.00, '', NULL, '', '2026-03-20 19:26:10'),
(178, '2026-03-17', 'credit_card', 19, 'expense', 14, 13, 5, NULL, 91, 200.00, '', NULL, '', '2026-03-20 19:26:45'),
(179, '2026-03-19', 'credit_card', 19, 'expense', 14, 13, 1, NULL, 91, 202.00, '', NULL, '', '2026-03-20 19:27:09'),
(180, '2026-03-21', 'wallet', 23, 'expense', 2, 2, 1, NULL, 86, 23.00, '', NULL, '', '2026-03-21 12:15:21'),
(181, '2026-03-21', 'wallet', 23, 'expense', 2, NULL, 1, NULL, 86, 20.00, '', NULL, 'Curd', '2026-03-21 15:24:04'),
(182, '2026-03-21', 'savings', 5, 'expense', 3, NULL, 17, NULL, 102, 240.00, '', NULL, 'Pudupakkam Anjeneyar Temple, Bought Prasadam', '2026-03-21 17:12:24'),
(183, '2026-03-22', 'wallet', 23, 'expense', NULL, NULL, 1, 7, 93, 665.00, '', NULL, 'Nattukozhi and Chicken', '2026-03-24 14:45:49'),
(184, '2026-03-22', 'savings', 2, 'expense', 3, 31, 1, NULL, 37, 60.00, '', NULL, 'Puff', '2026-03-24 14:47:51'),
(185, '2026-03-23', 'wallet', 23, 'expense', 2, 2, NULL, 7, 16, 23.00, '', NULL, '', '2026-03-24 14:48:31'),
(186, '2026-03-22', 'savings', 2, 'expense', 2, 3, 1, 7, 16, 69.00, '', NULL, '', '2026-03-24 14:49:20'),
(187, '2026-03-22', 'savings', 2, 'expense', 2, 11, 1, 7, 86, 88.00, '', NULL, '', '2026-03-24 14:50:01'),
(188, '2026-03-23', 'savings', 4, 'expense', 3, 32, 1, 7, 37, 180.00, '', NULL, '', '2026-03-24 14:51:47'),
(189, '2026-03-23', 'savings', 4, 'expense', 3, 33, 1, 7, 103, 240.00, '', NULL, '', '2026-03-24 14:52:48'),
(190, '2026-03-24', 'savings', 4, 'expense', 2, 3, 1, 7, 16, 136.00, '', NULL, 'Vegetables and 10 Eggs', '2026-03-24 14:53:52'),
(191, '2026-03-24', 'savings', 4, 'income', 27, NULL, NULL, NULL, NULL, 5000.00, 'lending', 11, 'VJ', '2026-03-24 14:55:55'),
(192, '2026-03-24', 'lending', NULL, 'transfer', 27, NULL, NULL, NULL, NULL, 5000.00, 'lending', 11, 'VJ', '2026-03-24 14:55:55'),
(195, '2026-03-20', 'wallet', 25, 'expense', 27, NULL, NULL, NULL, NULL, 1068.60, 'lending', 9, 'Top-up lending — Sriram', '2026-03-24 15:51:45'),
(196, '2026-03-20', 'lending', NULL, 'transfer', 27, NULL, NULL, NULL, NULL, 1068.60, 'lending', 9, 'Top-up lending — Sriram', '2026-03-24 15:51:45'),
(197, '2026-03-24', 'savings', 5, 'expense', 12, 6, 17, 8, 89, 120.00, '', NULL, '', '2026-03-24 15:57:19'),
(198, '2026-03-22', 'savings', 5, 'expense', 3, 34, 17, 7, 36, 120.00, '', NULL, 'Went to Kovalam Beach with Jamuna, Magizh, Lavanya, Pranav and Mithun and had some snacks at the beach.', '2026-03-24 15:58:49'),
(199, '2026-03-14', 'savings', 4, 'expense', 34, 35, 1, 7, 104, 219.00, '', NULL, '', '2026-03-24 16:04:20'),
(200, '2026-03-22', 'credit_card', 19, 'expense', 14, 13, 5, 8, 91, 200.00, '', NULL, '', '2026-03-24 16:36:57'),
(201, '2026-03-22', 'credit_card', 19, 'expense', NULL, NULL, NULL, NULL, NULL, 2.36, 'fuel_surcharge', 200, 'Fuel surcharge: 1% + 18% GST = 2.36', '2026-03-24 16:36:57'),
(202, '2026-03-23', 'credit_card', 19, 'expense', 14, 14, 5, 8, 91, 2401.05, '', NULL, '', '2026-03-24 16:37:43'),
(203, '2026-03-23', 'credit_card', 19, 'expense', NULL, NULL, NULL, NULL, NULL, 28.33, 'fuel_surcharge', 202, 'Fuel surcharge: 1% + 18% GST = 28.33', '2026-03-24 16:37:43'),
(204, '2026-03-23', 'credit_card', 19, 'income', NULL, NULL, NULL, NULL, NULL, 24.01, 'fuel_surcharge_refund', 202, 'Fuel surcharge refund: 1% of 2401.05', '2026-03-24 16:37:43'),
(205, '2026-03-25', 'credit_card', 19, 'expense', 14, 13, 5, NULL, 91, 500.05, '', NULL, '', '2026-03-25 14:35:18'),
(206, '2026-03-25', 'credit_card', 19, 'expense', NULL, NULL, NULL, NULL, NULL, 5.90, 'fuel_surcharge', 205, 'Fuel surcharge: 1% + 18% GST = 5.9', '2026-03-25 14:35:18'),
(207, '2026-03-25', 'credit_card', 19, 'income', NULL, NULL, NULL, NULL, NULL, 5.00, 'fuel_surcharge_refund', 205, 'Fuel surcharge refund: 1% of 500.05', '2026-03-25 14:35:18'),
(208, '2026-03-25', 'savings', 4, 'expense', 12, 6, 1, 3, 89, 60.00, '', NULL, '', '2026-03-25 14:37:10'),
(209, '2026-03-25', 'savings', 4, 'expense', 27, NULL, NULL, NULL, NULL, 110.00, 'lending', 12, 'Group spend split', '2026-03-25 14:37:10'),
(210, '2026-03-25', 'lending', NULL, 'transfer', 27, NULL, NULL, NULL, NULL, 110.00, 'lending', 12, 'Group spend split', '2026-03-25 14:37:10'),
(211, '2026-03-25', 'savings', 4, 'expense', 3, 31, 1, 8, 16, 10.00, '', NULL, '', '2026-03-25 14:39:01'),
(212, '2026-03-25', 'savings', 4, 'expense', 2, 11, 1, 7, 86, 124.00, '', NULL, '', '2026-03-25 14:39:22'),
(213, '2026-03-25', 'savings', 4, 'expense', 2, 5, 1, 7, 86, 80.00, '', NULL, '', '2026-03-25 14:45:03'),
(214, '2026-03-26', 'savings', 4, 'expense', 35, 36, 1, 8, 105, 4500.00, '', NULL, 'Bought 2 lots of Gold Petals', '2026-03-27 17:44:01'),
(215, '2026-03-26', 'savings', 3, 'expense', 5, NULL, 1, NULL, NULL, 1000.00, 'transfer', 4, '', '2026-03-27 18:00:55'),
(216, '2026-03-26', 'savings', 4, 'income', 5, NULL, 1, NULL, NULL, 1000.00, 'transfer', 3, 'Transfer from account 3', '2026-03-27 18:00:55'),
(217, '2026-03-26', 'savings', 4, 'expense', 35, 36, 1, NULL, 105, 1500.00, '', NULL, '', '2026-03-27 18:02:07'),
(218, '2026-03-27', 'savings', 4, 'expense', 12, 6, 1, 3, 89, 50.00, '', NULL, '', '2026-03-27 18:03:11'),
(219, '2026-03-27', 'savings', 4, 'expense', 27, NULL, NULL, NULL, NULL, 50.00, 'lending', 13, 'Group spend split', '2026-03-27 18:03:11'),
(220, '2026-03-27', 'lending', NULL, 'transfer', 27, NULL, NULL, NULL, NULL, 50.00, 'lending', 13, 'Group spend split', '2026-03-27 18:03:11'),
(221, '2026-03-26', 'savings', 3, 'expense', 3, 32, 1, 7, 37, 70.00, '', NULL, '', '2026-03-27 18:05:16'),
(222, '2026-03-26', 'savings', 3, 'expense', 3, 32, 1, 7, 37, 27.00, '', NULL, '', '2026-03-27 18:06:06'),
(223, '2026-03-26', 'savings', 3, 'expense', 12, 7, 1, 7, 89, 123.00, '', NULL, '', '2026-03-27 18:07:03'),
(224, '2026-03-26', 'credit_card', 15, 'expense', 2, 12, 1, 7, 9, 75.00, '', NULL, '', '2026-03-27 18:08:34'),
(225, '2026-03-27', 'wallet', 23, 'expense', 2, 3, 1, 7, 10, 13.00, '', NULL, '', '2026-03-27 18:09:28'),
(226, '2026-03-27', 'savings', 3, 'expense', 12, 6, 1, 3, 89, 130.00, '', NULL, '', '2026-03-27 18:10:31'),
(227, '2026-03-27', 'savings', 3, 'expense', 27, NULL, NULL, NULL, NULL, 120.00, 'lending', 14, 'Group spend split', '2026-03-27 18:10:31'),
(228, '2026-03-27', 'lending', NULL, 'transfer', 27, NULL, NULL, NULL, NULL, 120.00, 'lending', 14, 'Group spend split', '2026-03-27 18:10:31'),
(229, '2026-03-27', 'savings', 4, 'income', 27, NULL, NULL, NULL, NULL, 120.00, 'lending', 14, 'Repayment from DhanLAP Office Food Split', '2026-03-27 18:12:42'),
(230, '2026-03-27', 'lending', NULL, 'transfer', 27, NULL, NULL, NULL, NULL, 120.00, 'lending', 14, 'Repayment from DhanLAP Office Food Split', '2026-03-27 18:12:42'),
(231, '2026-03-27', 'savings', 4, 'income', 27, NULL, NULL, NULL, NULL, 50.00, 'lending', 13, 'Repayment from DhanLAP Office Food Split', '2026-03-27 18:12:56'),
(232, '2026-03-27', 'lending', NULL, 'transfer', 27, NULL, NULL, NULL, NULL, 50.00, 'lending', 13, 'Repayment from DhanLAP Office Food Split', '2026-03-27 18:12:56'),
(233, '2026-03-26', 'credit_card', 16, 'expense', 2, 11, 5, 7, 33, 2853.81, '', NULL, '', '2026-03-27 18:22:01'),
(234, '2026-03-22', 'credit_card', 17, 'expense', 12, 7, 5, 7, 92, 546.96, '', NULL, 'Biryani ordered, Lavanya visited our house', '2026-03-27 19:44:15'),
(235, '2026-03-28', 'credit_card', 15, 'expense', 26, NULL, 1, 8, 106, 520.00, '', NULL, '', '2026-03-28 06:19:34');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_accounts_type_id` (`account_type_id`);

--
-- Indexes for table `account_types`
--
ALTER TABLE `account_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `bills`
--
ALTER TABLE `bills`
  ADD PRIMARY KEY (`id`),
  ADD KEY `reminder_id` (`reminder_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `contacts`
--
ALTER TABLE `contacts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `credit_cards`
--
ALTER TABLE `credit_cards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_credit_cards_account_id` (`account_id`);

--
-- Indexes for table `credit_card_emi_payments`
--
ALTER TABLE `credit_card_emi_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_cc_emi_payment_card` (`credit_card_id`),
  ADD KEY `fk_cc_emi_payment_account` (`account_id`),
  ADD KEY `idx_cc_emi_payment_plan` (`emi_plan_id`);

--
-- Indexes for table `credit_card_emi_plans`
--
ALTER TABLE `credit_card_emi_plans`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_cc_emi_plan_card` (`credit_card_id`),
  ADD KEY `idx_cc_emi_plan_status_due` (`status`,`next_due_date`);

--
-- Indexes for table `credit_card_emi_schedule`
--
ALTER TABLE `credit_card_emi_schedule`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_cc_emi_installment` (`emi_plan_id`,`installment_no`),
  ADD KEY `idx_cc_emi_schedule_due` (`due_date`,`status`);

--
-- Indexes for table `credit_card_payments`
--
ALTER TABLE `credit_card_payments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_ccp_card` (`credit_card_id`),
  ADD KEY `fk_ccp_account` (`account_id`);

--
-- Indexes for table `credit_card_rewards`
--
ALTER TABLE `credit_card_rewards`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_rewards_transaction` (`transaction_id`),
  ADD KEY `idx_rewards_card_date` (`credit_card_id`,`redemption_date`);

--
-- Indexes for table `investments`
--
ALTER TABLE `investments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `investment_transactions`
--
ALTER TABLE `investment_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_investment_tx_investment` (`investment_id`),
  ADD KEY `idx_investment_tx_account` (`account_id`);

--
-- Indexes for table `lending_records`
--
ALTER TABLE `lending_records`
  ADD PRIMARY KEY (`id`),
  ADD KEY `contact_id` (`contact_id`);

--
-- Indexes for table `lending_repayments`
--
ALTER TABLE `lending_repayments`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loans`
--
ALTER TABLE `loans`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `loan_emi_schedule`
--
ALTER TABLE `loan_emi_schedule`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_loan_schedule_loan` (`loan_id`);

--
-- Indexes for table `payment_methods`
--
ALTER TABLE `payment_methods`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `properties`
--
ALTER TABLE `properties`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `purchase_sources`
--
ALTER TABLE `purchase_sources`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_purchase_sources_parent_name` (`parent_id`,`name`);

--
-- Indexes for table `reminders`
--
ALTER TABLE `reminders`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `rental_contracts`
--
ALTER TABLE `rental_contracts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `property_id` (`property_id`),
  ADD KEY `tenant_id` (`tenant_id`);

--
-- Indexes for table `rental_transactions`
--
ALTER TABLE `rental_transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_rental_tx_contract` (`contract_id`);

--
-- Indexes for table `sip_schedules`
--
ALTER TABLE `sip_schedules`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_sip_schedule_investment` (`investment_id`),
  ADD KEY `idx_sip_schedule_account` (`account_id`);

--
-- Indexes for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `category_id` (`category_id`);

--
-- Indexes for table `tenants`
--
ALTER TABLE `tenants`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_tenants_contact_id` (`contact_id`);

--
-- Indexes for table `transactions`
--
ALTER TABLE `transactions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_transactions_account` (`account_id`),
  ADD KEY `idx_transactions_category` (`category_id`),
  ADD KEY `idx_transactions_subcategory` (`subcategory_id`),
  ADD KEY `idx_transactions_payment_method` (`payment_method_id`),
  ADD KEY `idx_transactions_contact` (`contact_id`),
  ADD KEY `idx_transactions_purchase_source` (`purchase_source_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `account_types`
--
ALTER TABLE `account_types`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `bills`
--
ALTER TABLE `bills`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- AUTO_INCREMENT for table `contacts`
--
ALTER TABLE `contacts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `credit_cards`
--
ALTER TABLE `credit_cards`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `credit_card_emi_payments`
--
ALTER TABLE `credit_card_emi_payments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `credit_card_emi_plans`
--
ALTER TABLE `credit_card_emi_plans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `credit_card_emi_schedule`
--
ALTER TABLE `credit_card_emi_schedule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `credit_card_payments`
--
ALTER TABLE `credit_card_payments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `credit_card_rewards`
--
ALTER TABLE `credit_card_rewards`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `investments`
--
ALTER TABLE `investments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `investment_transactions`
--
ALTER TABLE `investment_transactions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `lending_records`
--
ALTER TABLE `lending_records`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `lending_repayments`
--
ALTER TABLE `lending_repayments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=65;

--
-- AUTO_INCREMENT for table `loans`
--
ALTER TABLE `loans`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `loan_emi_schedule`
--
ALTER TABLE `loan_emi_schedule`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=161;

--
-- AUTO_INCREMENT for table `payment_methods`
--
ALTER TABLE `payment_methods`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `properties`
--
ALTER TABLE `properties`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `purchase_sources`
--
ALTER TABLE `purchase_sources`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=107;

--
-- AUTO_INCREMENT for table `reminders`
--
ALTER TABLE `reminders`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rental_contracts`
--
ALTER TABLE `rental_contracts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `rental_transactions`
--
ALTER TABLE `rental_transactions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `sip_schedules`
--
ALTER TABLE `sip_schedules`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `subcategories`
--
ALTER TABLE `subcategories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=37;

--
-- AUTO_INCREMENT for table `tenants`
--
ALTER TABLE `tenants`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `transactions`
--
ALTER TABLE `transactions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=236;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accounts`
--
ALTER TABLE `accounts`
  ADD CONSTRAINT `fk_accounts_type` FOREIGN KEY (`account_type_id`) REFERENCES `account_types` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `bills`
--
ALTER TABLE `bills`
  ADD CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`reminder_id`) REFERENCES `reminders` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `credit_cards`
--
ALTER TABLE `credit_cards`
  ADD CONSTRAINT `fk_credit_cards_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `credit_card_emi_payments`
--
ALTER TABLE `credit_card_emi_payments`
  ADD CONSTRAINT `fk_cc_emi_payment_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_cc_emi_payment_card` FOREIGN KEY (`credit_card_id`) REFERENCES `credit_cards` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cc_emi_payment_plan` FOREIGN KEY (`emi_plan_id`) REFERENCES `credit_card_emi_plans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `credit_card_emi_plans`
--
ALTER TABLE `credit_card_emi_plans`
  ADD CONSTRAINT `fk_cc_emi_plan_card` FOREIGN KEY (`credit_card_id`) REFERENCES `credit_cards` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `credit_card_emi_schedule`
--
ALTER TABLE `credit_card_emi_schedule`
  ADD CONSTRAINT `fk_cc_emi_schedule_plan` FOREIGN KEY (`emi_plan_id`) REFERENCES `credit_card_emi_plans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `credit_card_payments`
--
ALTER TABLE `credit_card_payments`
  ADD CONSTRAINT `fk_ccp_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_ccp_card` FOREIGN KEY (`credit_card_id`) REFERENCES `credit_cards` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `credit_card_rewards`
--
ALTER TABLE `credit_card_rewards`
  ADD CONSTRAINT `fk_rewards_credit_card` FOREIGN KEY (`credit_card_id`) REFERENCES `credit_cards` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_rewards_transaction` FOREIGN KEY (`transaction_id`) REFERENCES `transactions` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `investment_transactions`
--
ALTER TABLE `investment_transactions`
  ADD CONSTRAINT `investment_transactions_ibfk_1` FOREIGN KEY (`investment_id`) REFERENCES `investments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `investment_transactions_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `lending_records`
--
ALTER TABLE `lending_records`
  ADD CONSTRAINT `lending_records_ibfk_1` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `loan_emi_schedule`
--
ALTER TABLE `loan_emi_schedule`
  ADD CONSTRAINT `loan_emi_schedule_ibfk_1` FOREIGN KEY (`loan_id`) REFERENCES `loans` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `purchase_sources`
--
ALTER TABLE `purchase_sources`
  ADD CONSTRAINT `fk_purchase_sources_parent` FOREIGN KEY (`parent_id`) REFERENCES `purchase_sources` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rental_contracts`
--
ALTER TABLE `rental_contracts`
  ADD CONSTRAINT `rental_contracts_ibfk_1` FOREIGN KEY (`property_id`) REFERENCES `properties` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `rental_contracts_ibfk_2` FOREIGN KEY (`tenant_id`) REFERENCES `tenants` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `rental_transactions`
--
ALTER TABLE `rental_transactions`
  ADD CONSTRAINT `rental_transactions_ibfk_1` FOREIGN KEY (`contract_id`) REFERENCES `rental_contracts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `sip_schedules`
--
ALTER TABLE `sip_schedules`
  ADD CONSTRAINT `sip_schedules_ibfk_1` FOREIGN KEY (`investment_id`) REFERENCES `investments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `sip_schedules_ibfk_2` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `subcategories`
--
ALTER TABLE `subcategories`
  ADD CONSTRAINT `subcategories_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `tenants`
--
ALTER TABLE `tenants`
  ADD CONSTRAINT `fk_tenants_contact` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `transactions`
--
ALTER TABLE `transactions`
  ADD CONSTRAINT `fk_transactions_contact` FOREIGN KEY (`contact_id`) REFERENCES `contacts` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_transactions_payment_method` FOREIGN KEY (`payment_method_id`) REFERENCES `payment_methods` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_transactions_purchase_source` FOREIGN KEY (`purchase_source_id`) REFERENCES `purchase_sources` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transactions_ibfk_1` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transactions_ibfk_2` FOREIGN KEY (`subcategory_id`) REFERENCES `subcategories` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `transactions_ibfk_3` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
