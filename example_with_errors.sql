-- --------------------------------------------------------
-- SQL Dump Example WITH ERRORS for Testing
-- This file contains intentional errors to test the analyzer
-- --------------------------------------------------------

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

-- --------------------------------------------------------
-- Table structure for table `users`
-- --------------------------------------------------------

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `users` (`id`, `name`, `email`, `created_at`) VALUES
(1, 'John Doe', 'john@example.com', '2024-01-15 10:30:00'),
(2, 'Jane Smith', 'jane@example.com', '2024-01-16 14:20:00');

-- --------------------------------------------------------
-- Table structure for table `products`
-- --------------------------------------------------------

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

INSERT INTO `products` (`id`, `name`, `price`, `created_at`) VALUES
(1, 'Laptop Pro', 1299.99, '2024-01-10 08:00:00'),
(2, 'Wireless Mouse', 29.99, '2024-01-11 09:30:00');

-- --------------------------------------------------------
-- Table structure for table `redirects`
-- ERROR: This table will cause AUTO_INCREMENT error
-- --------------------------------------------------------

CREATE TABLE `redirects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `from_path` varchar(255) NOT NULL,
  `to_path` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ERROR 1: MODIFY with AUTO_INCREMENT before PRIMARY KEY is defined
ALTER TABLE `redirects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

-- ERROR 2: Missing opening parenthesis in PRIMARY KEY
ALTER TABLE `redirects`
  ADD PRIMARY KEY `id`);

-- --------------------------------------------------------
-- Table structure for table `widgets`
-- --------------------------------------------------------

CREATE TABLE `widgets` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ERROR 3: Missing opening parenthesis after table name in INSERT
INSERT INTO `widgets` `id`, `name`, `created_at`) VALUES
(1, 'Header Widget', '2024-01-01 00:00:00'),
(2, 'Footer Widget', '2024-01-02 00:00:00');

-- --------------------------------------------------------
-- Indexes for table `users`
-- --------------------------------------------------------

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

-- --------------------------------------------------------
-- Indexes for table `products`
-- --------------------------------------------------------

ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
