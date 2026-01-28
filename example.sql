-- --------------------------------------------------------
-- SQL Dump Example for Testing
-- Generated for: SQL File Analyzer & Tester
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
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Dumping data for table `users`
-- --------------------------------------------------------

INSERT INTO `users` (`id`, `name`, `email`, `password`, `created_at`, `updated_at`) VALUES
(1, 'John Doe', 'john@example.com', '$2y$10$abcdefghijklmnopqrstuv', '2024-01-15 10:30:00', '2024-01-15 10:30:00'),
(2, 'Jane Smith', 'jane@example.com', '$2y$10$abcdefghijklmnopqrstuv', '2024-01-16 14:20:00', '2024-01-16 14:20:00'),
(3, 'Bob Wilson', 'bob@example.com', '$2y$10$abcdefghijklmnopqrstuv', '2024-01-17 09:15:00', '2024-01-17 09:15:00');

-- --------------------------------------------------------
-- Table structure for table `products`
-- --------------------------------------------------------

CREATE TABLE `products` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `stock` int(11) NOT NULL DEFAULT 0,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Dumping data for table `products`
-- This demonstrates data with semicolons in HTML content
-- --------------------------------------------------------

INSERT INTO `products` (`id`, `name`, `description`, `price`, `stock`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Laptop Pro 15', '<p style="margin: 0px; padding: 0px; font-family: Arial, sans-serif; font-size: 14px;">High performance laptop with 16GB RAM and 512GB SSD. Perfect for developers and designers.</p>', 1299.99, 50, 1, '2024-01-10 08:00:00', '2024-01-10 08:00:00'),
(2, 'Wireless Mouse', '<p style="color: #333; font-weight: bold;">Ergonomic wireless mouse with 3 DPI settings.</p>', 29.99, 200, 1, '2024-01-11 09:30:00', '2024-01-11 09:30:00'),
(3, 'USB-C Hub', '<div style="text-align: justify; line-height: 1.5;">7-in-1 USB-C hub with HDMI, USB 3.0, and SD card reader.</div>', 49.99, 150, 1, '2024-01-12 11:45:00', '2024-01-12 11:45:00');

-- --------------------------------------------------------
-- Table structure for table `orders`
-- --------------------------------------------------------

CREATE TABLE `orders` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `status` enum('pending','processing','shipped','delivered','cancelled') NOT NULL DEFAULT 'pending',
  `shipping_address` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Dumping data for table `orders`
-- --------------------------------------------------------

INSERT INTO `orders` (`id`, `user_id`, `total_amount`, `status`, `shipping_address`, `created_at`, `updated_at`) VALUES
(1, 1, 1329.98, 'delivered', '123 Main Street, New York, NY 10001', '2024-01-20 16:00:00', '2024-01-25 10:00:00'),
(2, 2, 79.98, 'shipped', '456 Oak Avenue, Los Angeles, CA 90001', '2024-01-22 13:30:00', '2024-01-24 09:00:00'),
(3, 1, 49.99, 'pending', '123 Main Street, New York, NY 10001', '2024-01-28 08:45:00', '2024-01-28 08:45:00');

-- --------------------------------------------------------
-- Table structure for table `categories`
-- --------------------------------------------------------

CREATE TABLE `categories` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `parent_id` bigint(20) UNSIGNED DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Dumping data for table `categories`
-- --------------------------------------------------------

INSERT INTO `categories` (`id`, `name`, `slug`, `description`, `parent_id`, `is_active`, `created_at`, `updated_at`) VALUES
(1, 'Electronics', 'electronics', 'Electronic devices and accessories', NULL, 1, '2024-01-01 00:00:00', '2024-01-01 00:00:00'),
(2, 'Computers', 'computers', 'Laptops, desktops and components', 1, 1, '2024-01-01 00:00:00', '2024-01-01 00:00:00'),
(3, 'Accessories', 'accessories', 'Computer and phone accessories', 1, 1, '2024-01-01 00:00:00', '2024-01-01 00:00:00');

-- --------------------------------------------------------
-- Table structure for table `settings`
-- --------------------------------------------------------

CREATE TABLE `settings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `key` varchar(255) NOT NULL,
  `value` text DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Dumping data for table `settings`
-- --------------------------------------------------------

INSERT INTO `settings` (`id`, `key`, `value`, `created_at`, `updated_at`) VALUES
(1, 'site_name', 'My Store', '2024-01-01 00:00:00', '2024-01-01 00:00:00'),
(2, 'site_email', 'contact@mystore.com', '2024-01-01 00:00:00', '2024-01-01 00:00:00'),
(3, 'currency', 'USD', '2024-01-01 00:00:00', '2024-01-01 00:00:00'),
(4, 'tax_rate', '10', '2024-01-01 00:00:00', '2024-01-01 00:00:00');

-- --------------------------------------------------------
-- Table structure for table `redirects`
-- This table demonstrates the AUTO_INCREMENT issue
-- --------------------------------------------------------

CREATE TABLE `redirects` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `from_path` varchar(255) NOT NULL,
  `to_path` varchar(255) DEFAULT NULL,
  `status_code` smallint(5) UNSIGNED NOT NULL DEFAULT 301,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------
-- Indexes for table `users`
-- --------------------------------------------------------

ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

-- --------------------------------------------------------
-- Indexes for table `products`
-- --------------------------------------------------------

ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `products`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

-- --------------------------------------------------------
-- Indexes for table `orders`
-- --------------------------------------------------------

ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `orders_user_id_foreign` (`user_id`);

ALTER TABLE `orders`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

-- --------------------------------------------------------
-- Indexes for table `categories`
-- --------------------------------------------------------

ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `categories_slug_unique` (`slug`);

ALTER TABLE `categories`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

-- --------------------------------------------------------
-- Indexes for table `settings`
-- --------------------------------------------------------

ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `settings_key_unique` (`key`);

ALTER TABLE `settings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

-- --------------------------------------------------------
-- Indexes for table `redirects`
-- --------------------------------------------------------

ALTER TABLE `redirects`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `redirects`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

-- --------------------------------------------------------
-- Constraints for table `orders`
-- --------------------------------------------------------

ALTER TABLE `orders`
  ADD CONSTRAINT `orders_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
