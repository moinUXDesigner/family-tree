-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: May 15, 2026 at 06:55 AM
-- Server version: 11.8.6-MariaDB-log
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `u484303972_familytree_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `audit_trails`
--

CREATE TABLE `audit_trails` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `user_role` varchar(50) DEFAULT NULL,
  `family_id` bigint(20) UNSIGNED DEFAULT NULL,
  `event` varchar(120) NOT NULL,
  `method` varchar(10) NOT NULL,
  `path` varchar(255) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `meta` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`meta`)),
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_trails`
--

INSERT INTO `audit_trails` (`id`, `user_id`, `user_role`, `family_id`, `event`, `method`, `path`, `ip_address`, `user_agent`, `meta`, `created_at`, `updated_at`) VALUES
(1, 19, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2406:7400:35:9865:355e:921:e08b:b64f', 'Mozilla/5.0 (iPhone; CPU iPhone OS 14_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/14.0 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":3,\"first_name\":\"Shaik\",\"last_name\":\"Mahdiya Aqeela\",\"gender\":\"female\",\"birth_date\":\"2011-06-05\",\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":null,\"current_country\":null,\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"unmarried\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-03 16:16:17', '2026-05-03 16:16:17'),
(2, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '49.205.98.131', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Duplicate data\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\",\"screenshot\":{}}}', '2026-05-03 16:55:54', '2026-05-03 16:55:54'),
(3, 19, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '49.205.98.131', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"parent\",\"existing_person_id\":42,\"household_id\":null,\"first_name\":\"Syed\",\"last_name\":\"Noor\",\"gender\":\"male\",\"birth_date\":\"1957-05-01\",\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-03 16:57:28', '2026-05-03 16:57:28'),
(4, 19, 'user', 3, 'PUT api/v1/me', 'PUT', 'api/v1/me', '49.205.98.131', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"name\":\"SHAIK KHAJA MYNUDDIN\",\"phone\":\"+918121990714\"}}', '2026-05-03 16:58:10', '2026-05-03 16:58:10'),
(5, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '117.198.101.225', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 05:45:54', '2026-05-04 05:45:54'),
(6, 1, 'super_admin', NULL, 'POST api/v1/users/21', 'POST', 'api/v1/users/21', '117.198.101.225', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"role\":\"admin\"}}', '2026-05-04 05:47:21', '2026-05-04 05:47:21'),
(7, 1, 'super_admin', NULL, 'POST api/v1/users/15', 'POST', 'api/v1/users/15', '117.198.101.225', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"role\":\"admin\"}}', '2026-05-04 05:49:03', '2026-05-04 05:49:03'),
(8, 1, 'super_admin', NULL, 'POST api/v1/users/15', 'POST', 'api/v1/users/15', '117.198.101.225', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"role\":\"user\"}}', '2026-05-04 05:49:14', '2026-05-04 05:49:14'),
(9, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '117.198.101.225', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 05:50:59', '2026-05-04 05:50:59'),
(10, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:9865:2905:77b3:948:bfc', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 08:24:40', '2026-05-04 08:24:40'),
(11, 19, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2406:7400:35:9865:2905:77b3:948:bfc', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":48,\"household_id\":null,\"first_name\":\"Shaik\",\"last_name\":\"Shamshad\",\"gender\":\"female\",\"birth_date\":\"1960-05-04\",\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-04 08:37:19', '2026-05-04 08:37:19'),
(12, 15, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '49.205.98.131', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":2,\"first_name\":\"Deshmukh\",\"last_name\":\"Adil khab\",\"gender\":\"male\",\"birth_date\":\"2004-01-22\",\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"918639943613\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-04 08:43:17', '2026-05-04 08:43:17'),
(13, 15, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '49.205.98.131', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Correct aadil khan name\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-04 08:46:13', '2026-05-04 08:46:13'),
(14, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '49.205.96.120', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 12:50:14', '2026-05-04 12:50:14'),
(15, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '49.205.96.120', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 13:04:04', '2026-05-04 13:04:04'),
(16, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '49.205.96.120', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 13:04:40', '2026-05-04 13:04:40'),
(17, 1, 'super_admin', NULL, 'PUT api/v1/family-members/52', 'PUT', 'api/v1/family-members/52', '49.205.96.120', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik\",\"last_name\":\"Sirajuddin\",\"gender\":\"male\",\"birth_date\":\"1976-02-06\",\"death_date\":null,\"graveyard_location\":null,\"email\":\"afsiraj@gmail.com\",\"phone\":\"9848283859\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":25,\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":\"son\"}}', '2026-05-04 13:06:23', '2026-05-04 13:06:23'),
(18, 1, 'super_admin', NULL, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '49.205.96.120', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Provide birth time recording functionality\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/super-admin\\/feedback\"}}', '2026-05-04 13:06:58', '2026-05-04 13:06:58'),
(19, 1, 'super_admin', NULL, 'POST api/v1/users/22', 'POST', 'api/v1/users/22', '49.205.96.120', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"approval_status\":\"approved\"}}', '2026-05-04 13:16:15', '2026-05-04 13:16:15'),
(20, 1, 'super_admin', NULL, 'POST api/v1/users/22', 'POST', 'api/v1/users/22', '49.205.96.120', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"approval_status\":\"pending\"}}', '2026-05-04 13:19:23', '2026-05-04 13:19:23'),
(21, 1, 'super_admin', NULL, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '49.205.96.120', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Add member profession access only admins and super admins\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/super-admin\\/feedback\"}}', '2026-05-04 13:20:04', '2026-05-04 13:20:04'),
(22, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":403,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"photo\":{}}}', '2026-05-04 16:29:25', '2026-05-04 16:29:25'),
(23, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":403,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"photo\":{}}}', '2026-05-04 16:30:02', '2026-05-04 16:30:02'),
(24, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 16:30:14', '2026-05-04 16:30:14'),
(25, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":403,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"photo\":{}}}', '2026-05-04 16:31:20', '2026-05-04 16:31:20'),
(26, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":403,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"23:03\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"photo\":{}}}', '2026-05-04 16:31:55', '2026-05-04 16:31:55'),
(27, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":403,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"photo\":{}}}', '2026-05-04 16:33:46', '2026-05-04 16:33:46'),
(28, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":403,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"photo\":{}}}', '2026-05-04 16:34:02', '2026-05-04 16:34:02'),
(29, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 16:34:43', '2026-05-04 16:34:43'),
(30, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":403,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"22:05\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"photo\":{}}}', '2026-05-04 16:36:01', '2026-05-04 16:36:01'),
(31, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":403,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"22:05\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"photo\":{}}}', '2026-05-04 16:36:22', '2026-05-04 16:36:22'),
(32, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"son\",\"photo\":{}}}', '2026-05-04 16:53:09', '2026-05-04 16:53:09'),
(33, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 16:53:36', '2026-05-04 16:53:36'),
(34, 1, 'super_admin', NULL, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"add_member_type\":\"spouse\",\"existing_person_id\":\"25\",\"first_name\":\"Shaik Chand Begum\",\"gender\":\"female\",\"birth_date\":\"1960-07-01\",\"birth_time\":\"10:10\",\"email\":\"moinuxdesigner@gmail.com\",\"phone\":\"8121990714\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_selected_family_id\":6,\"photo\":{}}}', '2026-05-04 16:57:38', '2026-05-04 16:57:38'),
(35, 1, 'super_admin', NULL, 'DELETE api/v1/family-members/48', 'DELETE', 'api/v1/family-members/48', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-04 16:59:15', '2026-05-04 16:59:15'),
(36, 1, 'super_admin', NULL, 'PUT api/v1/family-members/61', 'PUT', 'api/v1/family-members/61', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":422,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Chand Begum\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1960-07-01\",\"birth_time\":\"10:10:00\",\"death_date\":\"2014-04-01\",\"graveyard_location\":\"Yakub Saheb Maszid\",\"email\":\"moinuxdesigner@gmail.com\",\"phone\":\"8121990714\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":25,\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"spouse\"}}', '2026-05-04 16:59:44', '2026-05-04 16:59:44'),
(37, 1, 'super_admin', NULL, 'PUT api/v1/family-members/61', 'PUT', 'api/v1/family-members/61', '2406:7400:35:83de:6476:a527:dfa2:345', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Chand Begum\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1960-07-01\",\"birth_time\":\"12:10\",\"death_date\":\"2014-04-01\",\"graveyard_location\":\"Yakub Saheb Maszid\",\"email\":\"moinuxdesigner@gmail.com\",\"phone\":\"8121990714\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":25,\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"spouse\"}}', '2026-05-04 17:00:04', '2026-05-04 17:00:04'),
(38, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"22:36\",\"death_date\":null,\"graveyard_location\":null,\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":25,\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":\"son\"}}', '2026-05-04 17:06:22', '2026-05-04 17:06:22'),
(39, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":422,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"22:36:00\",\"death_date\":null,\"graveyard_location\":null,\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":25,\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":\"son\"}}', '2026-05-04 17:06:28', '2026-05-04 17:06:28'),
(40, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":422,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"22:36:00\",\"death_date\":null,\"graveyard_location\":null,\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":25,\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":\"son\"}}', '2026-05-04 17:06:30', '2026-05-04 17:06:30'),
(41, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '49.205.100.174', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":422,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"22:36:00\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"son\",\"photo\":{}}}', '2026-05-05 13:59:19', '2026-05-05 13:59:19'),
(42, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '49.205.100.174', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"12:30\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"son\",\"photo\":{}}}', '2026-05-05 13:59:47', '2026-05-05 13:59:47'),
(43, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '49.205.100.174', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":422,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"12:30:00\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"son\",\"photo\":{}}}', '2026-05-05 14:03:20', '2026-05-05 14:03:20'),
(44, 19, 'user', 3, 'PUT api/v1/family-members/41', 'PUT', 'api/v1/family-members/41', '49.205.100.174', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik\",\"last_name\":\"Khaja Mynuddin\",\"gender\":\"male\",\"birth_date\":\"1982-05-08\",\"birth_time\":\"12:30\",\"email\":\"smartworldcom@gmail.com\",\"phone\":\"+918121990714\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"25\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"son\",\"photo\":{}}}', '2026-05-05 14:03:32', '2026-05-05 14:03:32'),
(45, 20, 'user', 3, 'PUT api/v1/family-members/42', 'PUT', 'api/v1/family-members/42', '2406:7400:35:83de:dd48:2981:43a6:dab6', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Syed\",\"last_name\":\"Nasreen Fathima\",\"gender\":\"female\",\"birth_date\":\"1985-07-03\",\"email\":\"nasreen1057@gmail.com\",\"phone\":\"9390797705\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"41\",\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"spouse\",\"photo\":{}}}', '2026-05-05 14:15:03', '2026-05-05 14:15:03'),
(46, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-05 17:14:31', '2026-05-05 17:14:31'),
(47, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-05 17:15:21', '2026-05-05 17:15:21'),
(48, 1, 'super_admin', NULL, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"superadmin@familytree.test\",\"password\":\"***\"}}', '2026-05-06 04:23:49', '2026-05-06 04:23:49'),
(49, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-06 04:25:13', '2026-05-06 04:25:13'),
(50, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-06 04:25:16', '2026-05-06 04:25:16'),
(51, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:40f0:3025:7050:37a0:6fb9:7dea:76d1', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-06 05:29:46', '2026-05-06 05:29:46'),
(52, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-06 08:00:38', '2026-05-06 08:00:38'),
(53, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-06 08:01:09', '2026-05-06 08:01:09'),
(54, 1, 'super_admin', NULL, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"superadmin@familytree.test\",\"password\":\"***\"}}', '2026-05-06 08:01:14', '2026-05-06 08:01:14'),
(55, 1, 'super_admin', NULL, 'PUT api/v1/family-members/60', 'PUT', 'api/v1/family-members/60', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Deshmukh Adil Khan\",\"last_name\":\"Adil khab\",\"gender\":\"male\",\"birth_date\":\"2004-01-22\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"918639943613\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":30,\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":\"son\"}}', '2026-05-06 08:02:51', '2026-05-06 08:02:51'),
(56, 1, 'super_admin', NULL, 'DELETE api/v1/family-members/60', 'DELETE', 'api/v1/family-members/60', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-06 08:03:46', '2026-05-06 08:03:46'),
(57, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:83de:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-06 08:04:03', '2026-05-06 08:04:03'),
(58, 23, 'user', NULL, 'AUTH register', 'POST', 'api/v1/register', '2409:40f0:3029:268c:dc7f:baff:fed7:44ca', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"name\":\"SHAIK MUJAHID AKRAM\",\"email\":\"smujahidakram@gmail.com\",\"phone\":\"7013786131\",\"password\":\"***\"}}', '2026-05-07 08:39:51', '2026-05-07 08:39:51'),
(59, 23, 'user', 3, 'POST api/v1/family-connection', 'POST', 'api/v1/family-connection', '2409:40f0:3029:268c:dc7f:baff:fed7:44ca', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"anchor_member_id\":41,\"relationship_to_anchor\":\"father\",\"evidence_notes\":null}}', '2026-05-07 08:41:02', '2026-05-07 08:41:02'),
(60, 23, 'user', 3, 'POST api/v1/family-connection', 'POST', 'api/v1/family-connection', '2409:40f0:3029:268c:dc7f:baff:fed7:44ca', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"anchor_member_id\":41,\"relationship_to_anchor\":\"son\",\"evidence_notes\":null}}', '2026-05-07 08:41:23', '2026-05-07 08:41:23'),
(61, 1, 'super_admin', NULL, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:31c1:313e:bd37:7c16:5963:34bf', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"superadmin@familytree.test\",\"password\":\"***\"}}', '2026-05-07 14:36:13', '2026-05-07 14:36:13'),
(62, 15, 'user', 3, 'POST api/v1/family-members/34/photo', 'POST', 'api/v1/family-members/34/photo', '2401:4900:4948:cdec:98ed:102b:8795:6029', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"a55f77da-d81c-4df7-8031-11b20c19c10e-1_all_16537.jpg\",\"size\":1501869,\"mime\":\"image\\/jpeg\"}}}', '2026-05-07 14:45:28', '2026-05-07 14:45:28'),
(63, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:40f0:3195:df15:a8d6:a9b8:7553:535d', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":[]}', '2026-05-07 14:48:45', '2026-05-07 14:48:45'),
(64, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:3195:df15:a8d6:a9b8:7553:535d', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-07 14:49:05', '2026-05-07 14:49:05'),
(65, 15, 'user', 3, 'POST api/v1/family-members/35/photo', 'POST', 'api/v1/family-members/35/photo', '2401:4900:4948:cdec:98ed:102b:8795:6029', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000204750.jpg\",\"size\":72510,\"mime\":\"image\\/jpeg\"}}}', '2026-05-07 14:54:39', '2026-05-07 14:54:39'),
(66, 15, 'user', 3, 'POST api/v1/family-members/61/photo', 'POST', 'api/v1/family-members/61/photo', '2401:4900:4948:cdec:98ed:102b:8795:6029', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000204751.jpg\",\"size\":117266,\"mime\":\"image\\/jpeg\"}}}', '2026-05-07 15:25:14', '2026-05-07 15:25:14'),
(67, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-07 16:53:22', '2026-05-07 16:53:22'),
(68, 21, 'admin', 3, 'POST api/v1/family-members/54/photo', 'POST', 'api/v1/family-members/54/photo', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"types-of-sensor-768x675.png\",\"size\":760954,\"mime\":\"image\\/png\"}}}', '2026-05-07 16:59:05', '2026-05-07 16:59:05'),
(69, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":32,\"household_id\":null,\"first_name\":\"Hussain Saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"1938-01-01\",\"birth_time\":\"00:02\",\"death_date\":\"1979-01-01\",\"graveyard_location\":\"Yakub saheb masjid\",\"email\":null,\"phone\":null,\"current_city\":\"kadapa\",\"current_country\":\"india\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-07 17:18:30', '2026-05-07 17:18:30'),
(70, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":32,\"household_id\":null,\"first_name\":\"Shaik Mahaboob Chan\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1960-01-01\",\"birth_time\":\"01:01\",\"death_date\":\"2025-01-20\",\"graveyard_location\":\"Yakhoob saheb masjid\",\"email\":null,\"phone\":null,\"current_city\":\"kadapa\",\"current_country\":\"india\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-07 17:34:44', '2026-05-07 17:34:44'),
(71, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"8\",\"first_name\":\"Shaik Mohammed Hussain\",\"gender\":\"male\",\"birth_date\":\"1978-01-01\",\"birth_time\":\"01:01\",\"phone\":\"9989839024\",\"current_city\":\"Kadapa\",\"current_country\":\"india\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"78085.jpg\",\"size\":86010,\"mime\":\"image\\/jpeg\"}}}', '2026-05-07 17:43:05', '2026-05-07 17:43:05'),
(72, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":64,\"household_id\":null,\"first_name\":\"Shaik Nasira\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-07 17:48:14', '2026-05-07 17:48:14'),
(73, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"sibling\",\"existing_person_id\":\"64\",\"first_name\":\"Shaik Nasir Hussain\",\"gender\":\"male\",\"email\":\"nasir1402@gmail.com\",\"phone\":\"8142491580\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"79032.jpg\",\"size\":80082,\"mime\":\"image\\/jpeg\"}}}', '2026-05-07 17:52:47', '2026-05-07 17:52:47'),
(74, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":64,\"household_id\":null,\"first_name\":\"Shaik Farukh Hussain\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"9160778099\",\"current_city\":\"Kadapa\",\"current_country\":\"india\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"unmarried\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-07 17:58:16', '2026-05-07 17:58:16'),
(75, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-07 18:01:52', '2026-05-07 18:01:52'),
(76, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-07 18:02:22', '2026-05-07 18:02:22'),
(77, 1, 'super_admin', NULL, 'AUTH login', 'POST', 'api/v1/login', '117.198.101.225', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"superadmin@familytree.test\",\"password\":\"***\"}}', '2026-05-08 07:20:00', '2026-05-08 07:20:00'),
(78, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '117.198.101.225', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-08 07:23:27', '2026-05-08 07:23:27'),
(79, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '117.198.101.225', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-08 07:23:35', '2026-05-08 07:23:35'),
(80, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '117.198.101.225', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-08 07:25:12', '2026-05-08 07:25:12'),
(81, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:31c1:313e:bf1c:a278:8731:1c59', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-08 14:02:56', '2026-05-08 14:02:56'),
(82, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":25,\"household_id\":null,\"first_name\":\"Shaik Hussain Saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"1950-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-08 14:50:35', '2026-05-08 14:50:35'),
(83, 21, 'admin', 3, 'DELETE api/v1/family-members/62', 'DELETE', 'api/v1/family-members/62', '2409:4091:8003:4011:6cd2:79f3:8b5d:478a', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-08 14:52:38', '2026-05-08 14:52:38'),
(84, 19, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":61,\"household_id\":null,\"first_name\":\"Shaik Shamshad\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1960-05-01\",\"birth_time\":\"09:00\",\"death_date\":null,\"graveyard_location\":null,\"email\":\"moinuxdesigner@gmail.com\",\"phone\":\"08121990714\",\"current_city\":\"Nellore\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 03:31:36', '2026-05-09 03:31:36'),
(85, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Horizontal overflow hiding content button and stepper\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\",\"screenshot\":{\"name\":\"Screenshot_2026-05-09-09-00-48-91_40deb401b9ffe8e1df2f1cc5ba480b12.jpg\",\"size\":255008,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 03:32:22', '2026-05-09 03:32:22'),
(86, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"All added members should approved by super without been approval they should not appear in members or in tree\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-09 03:33:29', '2026-05-09 03:33:29'),
(87, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Make consistent vertical space between form fields to identify which label is related to which input and the input border search should be clear with very light now it has been inc...\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\",\"screenshot\":{\"name\":\"Screenshot_2026-05-09-09-04-01-00_40deb401b9ffe8e1df2f1cc5ba480b12.jpg\",\"size\":246314,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 03:34:44', '2026-05-09 03:34:44'),
(88, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"White background white cards is having some ice train to some users it has to be maintain with a perfect contract\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\",\"screenshot\":{\"name\":\"Screenshot_2026-05-09-09-05-30-06_40deb401b9ffe8e1df2f1cc5ba480b12.jpg\",\"size\":509810,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 03:36:22', '2026-05-09 03:36:22');
INSERT INTO `audit_trails` (`id`, `user_id`, `user_role`, `family_id`, `event`, `method`, `path`, `ip_address`, `user_agent`, `meta`, `created_at`, `updated_at`) VALUES
(89, 19, 'user', 3, 'POST api/v1/family-members/41/photo', 'POST', 'api/v1/family-members/41/photo', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"IMG_20260505_194151.jpg\",\"size\":48500,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 03:54:45', '2026-05-09 03:54:45'),
(90, 19, 'user', 3, 'POST api/v1/family-members/61/photo', 'POST', 'api/v1/family-members/61/photo', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"100_0107.JPG\",\"size\":2125267,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 03:55:30', '2026-05-09 03:55:30'),
(91, 19, 'user', 3, 'POST api/v1/family-members/42/photo', 'POST', 'api/v1/family-members/42/photo', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"Passport size white back ground copy.jpg\",\"size\":258563,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 03:59:53', '2026-05-09 03:59:53'),
(92, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Holding profile I can\'t should display context menu\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-09 04:00:44', '2026-05-09 04:00:44'),
(93, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Display preview when submitting feedback\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-09 04:02:00', '2026-05-09 04:02:00'),
(94, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Combine edit profile and edit member details in profile section in a one form\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-09 04:02:48', '2026-05-09 04:02:48'),
(95, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Here Hussain saheb badeba not appearing though added member\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"Screenshot 2026-05-09 171346.png\",\"size\":76517,\"mime\":\"image\\/png\"}}}', '2026-05-09 11:45:55', '2026-05-09 11:45:55'),
(96, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 12:01:23', '2026-05-09 12:01:23'),
(97, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 12:01:48', '2026-05-09 12:01:48'),
(98, 21, 'admin', 3, 'PUT api/v1/family-members/54', 'PUT', 'api/v1/family-members/54', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Ayesha Siddiqua\",\"last_name\":\"Shaik\",\"gender\":\"female\",\"birth_date\":\"1980-04-03\",\"email\":\"ishasiraj76@gmail.com\",\"phone\":\"9177390705\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"52\",\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"spouse\",\"photo\":{\"name\":\"20160306_174959.jpg\",\"size\":256274,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 12:16:10', '2026-05-09 12:16:10'),
(99, 21, 'admin', 3, 'PUT api/v1/family-members/38', 'PUT', 'api/v1/family-members/38', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Deshmukh\",\"last_name\":\"Ayub Khan\",\"gender\":\"male\",\"birth_date\":\"1968-09-10\",\"phone\":\"9059229774\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":\"30\",\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"spouse\",\"photo\":{\"name\":\"001.JPG\",\"size\":312881,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 12:21:30', '2026-05-09 12:21:30'),
(100, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:dd52:b415:628a:28a5', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 12:29:43', '2026-05-09 12:29:43'),
(101, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:dd52:b415:628a:28a5', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 12:30:59', '2026-05-09 12:30:59'),
(102, 21, 'admin', 3, 'PUT api/v1/family-members/56', 'PUT', 'api/v1/family-members/56', '2409:4091:8003:4011:dd52:b415:628a:28a5', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Mohammed Afraz hussain\",\"last_name\":\"Shaik\",\"gender\":\"male\",\"birth_date\":\"2006-10-20\",\"email\":\"shaikmohammedafrazhussain@gmail.com\",\"phone\":\"8555894652\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"family_head_id\":\"52\",\"relationship_to_family_head\":\"son\",\"marital_status\":\"unmarried\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"son\",\"photo\":{\"name\":\"IMG_0004.jpeg\",\"size\":2643649,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 12:32:21', '2026-05-09 12:32:21'),
(103, 21, 'admin', 3, 'POST api/v1/family-members/56/photo', 'POST', 'api/v1/family-members/56/photo', '2409:4091:8003:4011:dd52:b415:628a:28a5', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"5af32ffe-d923-4ef8-bf1b-1b70e5fa73b9_D67388FA-8833-4D46-9834-BF1E0CDBB156.jpeg\",\"size\":179033,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 12:41:07', '2026-05-09 12:41:07'),
(104, 21, 'admin', 3, 'POST api/v1/family-members/55/photo', 'POST', 'api/v1/family-members/55/photo', '2409:4091:8003:4011:dd52:b415:628a:28a5', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"51f886b4-caa3-4f37-b66d-0f92c8934bf6.jpeg\",\"size\":110669,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 12:44:08', '2026-05-09 12:44:08'),
(105, 21, 'admin', 3, 'POST api/v1/family-members/32/photo', 'POST', 'api/v1/family-members/32/photo', '2409:4091:8003:4011:dd52:b415:628a:28a5', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1b284353-7d7c-4ac5-80fc-0ba53123fe90.jpeg\",\"size\":42124,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 12:45:52', '2026-05-09 12:45:52'),
(106, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 12:53:07', '2026-05-09 12:53:07'),
(107, 21, 'admin', 3, 'PUT api/v1/family-members/63', 'PUT', 'api/v1/family-members/63', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":422,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik Mahaboob Chan\",\"gender\":\"female\",\"birth_date\":\"1960-01-01\",\"birth_time\":\"01:01:00\",\"death_date\":\"2025-01-20\",\"graveyard_location\":\"Yakhoob saheb masjid\",\"current_city\":\"kadapa\",\"current_country\":\"india\",\"family_head_id\":\"32\",\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":\"0\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"spouse\",\"photo\":{\"name\":\"mahaboob chahchi.JPG\",\"size\":383500,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 13:01:32', '2026-05-09 13:01:32'),
(108, 21, 'admin', 3, 'PUT api/v1/family-members/63', 'PUT', 'api/v1/family-members/63', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":422,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik Mahaboob Chan\",\"gender\":\"female\",\"birth_date\":\"1960-01-01\",\"birth_time\":\"01:01:00\",\"death_date\":\"2025-01-20\",\"graveyard_location\":\"Yakhoob saheb masjid\",\"current_city\":\"kadapa\",\"current_country\":\"india\",\"family_head_id\":\"32\",\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":\"0\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"spouse\",\"photo\":{\"name\":\"mahaboob chahchi.JPG\",\"size\":383500,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 13:01:37', '2026-05-09 13:01:37'),
(109, 21, 'admin', 3, 'PUT api/v1/family-members/63', 'PUT', 'api/v1/family-members/63', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":422,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik Mahaboob Chan\",\"gender\":\"female\",\"birth_date\":\"1960-01-01\",\"birth_time\":\"01:01:00\",\"death_date\":\"2025-01-20\",\"graveyard_location\":\"Yakhoob saheb masjid\",\"current_city\":\"kadapa\",\"current_country\":\"india\",\"family_head_id\":\"32\",\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":\"0\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"spouse\",\"photo\":{\"name\":\"mahaboob chahchi.JPG\",\"size\":383500,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 13:01:44', '2026-05-09 13:01:44'),
(110, 21, 'admin', 3, 'POST api/v1/family-members/63/photo', 'POST', 'api/v1/family-members/63/photo', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"mahaboob chahchi.JPG\",\"size\":383500,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 13:02:29', '2026-05-09 13:02:29'),
(111, 21, 'admin', 3, 'PUT api/v1/family-members/22', 'PUT', 'api/v1/family-members/22', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Abdul Razzakh\",\"last_name\":\"Raja Saab\",\"gender\":\"male\",\"birth_date\":\"1940-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"unmarried\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 13:11:34', '2026-05-09 13:11:34'),
(112, 21, 'admin', 3, 'POST api/v1/family-members/22/photo', 'POST', 'api/v1/family-members/22/photo', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"abdul razzak.jpeg\",\"size\":8542,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 13:32:03', '2026-05-09 13:32:03'),
(113, 21, 'admin', 3, 'DELETE api/v1/family-members/57', 'DELETE', 'api/v1/family-members/57', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 13:41:17', '2026-05-09 13:41:17'),
(114, 21, 'admin', 3, 'DELETE api/v1/family-members/69', 'DELETE', 'api/v1/family-members/69', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 13:43:28', '2026-05-09 13:43:28'),
(115, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"spouse\",\"existing_person_id\":\"22\",\"first_name\":\"Shaik Pyaran\",\"gender\":\"female\",\"birth_date\":\"1950-01-01\",\"phone\":\"7702090928\",\"current_city\":\"kadapa\",\"current_country\":\"india\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"pyaran.jpeg\",\"size\":4378,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 13:50:07', '2026-05-09 13:50:07'),
(116, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"10\",\"first_name\":\"Shaik Mohammed Ilyas\",\"gender\":\"male\",\"birth_date\":\"1977-01-01\",\"phone\":\"+966 573143856\",\"current_city\":\"Abha\",\"current_country\":\"Saudi Arabia\",\"marital_status\":\"unmarried\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"elyas.jpeg\",\"size\":128822,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 13:53:30', '2026-05-09 13:53:30'),
(117, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"10\",\"first_name\":\"Shaik Gousepeer\",\"gender\":\"male\",\"birth_date\":\"1966-04-01\",\"current_city\":\"Chilamattur\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-09 at 7.28.31 PM.jpeg\",\"size\":6801,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 14:00:47', '2026-05-09 14:00:47'),
(118, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":10,\"first_name\":\"Shaik Fatimun\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"9000178016\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 14:03:13', '2026-05-09 14:03:13'),
(119, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":10,\"first_name\":\"Shaik Taharun\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"9989387827\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 14:04:29', '2026-05-09 14:04:29'),
(120, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":10,\"first_name\":\"Shaik Begum\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"7702090928\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 14:07:29', '2026-05-09 14:07:29'),
(121, 21, 'admin', 3, 'POST api/v1/family-members/25/photo', 'POST', 'api/v1/family-members/25/photo', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"ABBA Passport size photo.jpg\",\"size\":414855,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 14:13:32', '2026-05-09 14:13:32'),
(122, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"here two house holds duplicate available. Which one i have to delete decide and delete it.\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"Screenshot 2026-05-09 194453.png\",\"size\":89256,\"mime\":\"image\\/png\"}}}', '2026-05-09 14:17:00', '2026-05-09 14:17:00'),
(123, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"5\",\"first_name\":\"Shaik Tajuddin\",\"gender\":\"male\",\"death_date\":\"1990-12-10\",\"graveyard_location\":\"Yakub Saheb Masjid\",\"current_city\":\"Vijayawada\",\"current_country\":\"India\",\"marital_status\":\"unmarried\",\"living_status\":\"deceased\",\"is_living\":\"0\",\"is_private\":\"0\",\"photo\":{\"name\":\"taj bhayya.jpg\",\"size\":64536,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 14:32:00', '2026-05-09 14:32:00'),
(124, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"here we can provide death certificate for upload\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"Screenshot 2026-05-09 200153.png\",\"size\":55051,\"mime\":\"image\\/png\"}}}', '2026-05-09 14:32:59', '2026-05-09 14:32:59'),
(125, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"In date of birth window also we can provide a tab for upload of birth certificate\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\"}}', '2026-05-09 14:33:44', '2026-05-09 14:33:44'),
(126, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"In future if adhar asked there also we can provide tabs for adhar, pan, passport etc. upload options\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\"}}', '2026-05-09 14:34:31', '2026-05-09 14:34:31'),
(127, 21, 'admin', 3, 'POST api/v1/family-members/30/photo', 'POST', 'api/v1/family-members/30/photo', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"004.JPG\",\"size\":400198,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 14:49:05', '2026-05-09 14:49:05'),
(128, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"here 3 house holds of Madar saheb appearing\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"Screenshot 2026-05-09 202008.png\",\"size\":55901,\"mime\":\"image\\/png\"}}}', '2026-05-09 14:50:49', '2026-05-09 14:50:49'),
(129, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"2\",\"first_name\":\"Patan D Adil Khan\",\"gender\":\"male\",\"email\":\"adil2212004@gmail.com\",\"phone\":\"8639943613\",\"current_city\":\"Nellore\",\"current_country\":\"India\",\"marital_status\":\"unmarried\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-09 at 8.26.55 PM.jpeg\",\"size\":27217,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 14:59:30', '2026-05-09 14:59:30'),
(130, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:ca92:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Alias name\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-09 16:31:53', '2026-05-09 16:31:53'),
(131, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:40f0:3194:7254:130:ff67:cd2:3991', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 17:20:22', '2026-05-09 17:20:22'),
(132, 1, 'super_admin', NULL, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:3194:7254:130:ff67:cd2:3991', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"superadmin@familytree.test\",\"password\":\"***\"}}', '2026-05-09 17:20:26', '2026-05-09 17:20:26'),
(133, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:3005:a2:c061:bb14:1ccb:8f96', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 17:21:45', '2026-05-09 17:21:45'),
(134, 1, 'super_admin', NULL, 'PUT api/v1/family-members/22', 'PUT', 'api/v1/family-members/22', '2409:40f0:3194:7254:130:ff67:cd2:3991', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Abdul Razzakh\",\"last_name\":\"Raja Saab\",\"gender\":\"male\",\"birth_date\":\"1940-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Yakub Saheb Maszid\",\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 17:22:52', '2026-05-09 17:22:52'),
(135, 1, 'super_admin', NULL, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:40f0:3194:7254:130:ff67:cd2:3991', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Biography description page for each member\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/super-admin\\/feedback\"}}', '2026-05-09 17:23:34', '2026-05-09 17:23:34'),
(136, 21, 'admin', 3, 'POST api/v1/family-members/52/photo', 'POST', 'api/v1/family-members/52/photo', '2409:40f0:3005:a2:c061:bb14:1ccb:8f96', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"IMG_0850.jpeg\",\"size\":3668483,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 17:25:54', '2026-05-09 17:25:54'),
(137, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:40f0:3194:7254:130:ff67:cd2:3991', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 17:29:21', '2026-05-09 17:29:21'),
(138, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:3194:7254:130:ff67:cd2:3991', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-09 17:29:28', '2026-05-09 17:29:28'),
(139, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 17:45:13', '2026-05-09 17:45:13'),
(140, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 17:45:54', '2026-05-09 17:45:54'),
(141, 1, 'super_admin', NULL, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"superadmin@familytree.test\",\"password\":\"***\"}}', '2026-05-09 17:45:59', '2026-05-09 17:45:59'),
(142, 1, 'super_admin', NULL, 'POST api/v1/family-members/76/photo', 'POST', 'api/v1/family-members/76/photo', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"Screenshot_2026-05-09-21-54-41-44_6012fa4d4ddec268fc5c7112cbb265e7.jpg\",\"size\":637155,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 17:46:22', '2026-05-09 17:46:22'),
(143, 1, 'super_admin', NULL, 'POST api/v1/family-members/76/photo', 'POST', 'api/v1/family-members/76/photo', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"image_8fdfb43f.png\",\"size\":1982169,\"mime\":\"image\\/png\"}}}', '2026-05-09 17:46:34', '2026-05-09 17:46:34'),
(144, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 17:47:37', '2026-05-09 17:47:37'),
(145, 21, 'admin', 3, 'POST api/v1/family-members/61/photo', 'POST', 'api/v1/family-members/61/photo', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"Ammi.JPG\",\"size\":341252,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 17:47:59', '2026-05-09 17:47:59'),
(146, 1, 'super_admin', NULL, 'POST api/v1/family-members/76/photo', 'POST', 'api/v1/family-members/76/photo', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"IMG_20260509_232155.png\",\"size\":148522,\"mime\":\"image\\/png\"}}}', '2026-05-09 17:52:09', '2026-05-09 17:52:09'),
(147, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 17:53:56', '2026-05-09 17:53:56'),
(148, 21, 'admin', 3, 'POST api/v1/family-members/52/photo', 'POST', 'api/v1/family-members/52/photo', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"SHAIK SIRAJUDDIN.jpg\",\"size\":34156,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 17:54:29', '2026-05-09 17:54:29'),
(149, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"2\",\"first_name\":\"Patan D Fazil Khan\",\"gender\":\"male\",\"phone\":\"9347291766\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"unmarried\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"20190116_164852.jpg\",\"size\":2453395,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 18:00:38', '2026-05-09 18:00:38'),
(150, 21, 'admin', 3, 'PUT api/v1/family-members/70', 'PUT', 'api/v1/family-members/70', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Pyaari\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1950-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"7702090928\",\"current_city\":\"kadapa\",\"current_country\":\"india\",\"family_head_id\":22,\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":\"spouse\"}}', '2026-05-09 18:02:36', '2026-05-09 18:02:36'),
(151, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"1\",\"first_name\":\"Syed Madeeha Chasheen\",\"gender\":\"female\",\"marital_status\":\"unmarried\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-09 at 11.36.03 PM.jpeg\",\"size\":186110,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 18:07:39', '2026-05-09 18:07:39'),
(152, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"spouse tab for unmarried died persons has to be removed disabled or removed i.e., ADD button removed.\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"Screenshot 2026-05-09 233917.png\",\"size\":112108,\"mime\":\"image\\/png\"}}}', '2026-05-09 18:11:52', '2026-05-09 18:11:52'),
(153, 21, 'admin', 3, 'POST api/v1/family-members/36/photo', 'POST', 'api/v1/family-members/36/photo', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"WhatsApp Image 2026-05-09 at 11.47.14 PM.jpeg\",\"size\":17529,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 18:18:49', '2026-05-09 18:18:49'),
(154, 21, 'admin', 3, 'POST api/v1/family-members/53/photo', 'POST', 'api/v1/family-members/53/photo', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"sha.png\",\"size\":80122,\"mime\":\"image\\/png\"}}}', '2026-05-09 18:24:53', '2026-05-09 18:24:53'),
(155, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"sibling\",\"existing_person_id\":\"61\",\"first_name\":\"Shaik Shamshad Begum\",\"gender\":\"female\",\"phone\":\"8099905362\",\"current_city\":\"Nellore\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"chan khala.jpg\",\"size\":32108,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 18:44:37', '2026-05-09 18:44:37'),
(156, 21, 'admin', 3, 'DELETE api/v1/family-members/59', 'DELETE', 'api/v1/family-members/59', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 18:46:37', '2026-05-09 18:46:37'),
(157, 21, 'admin', 3, 'POST api/v1/family-members/73/photo', 'POST', 'api/v1/family-members/73/photo', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"fatimun apa.jpg\",\"size\":30113,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 18:47:15', '2026-05-09 18:47:15'),
(158, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 18:49:36', '2026-05-09 18:49:36'),
(159, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 18:50:00', '2026-05-09 18:50:00'),
(160, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Beside Yasmeen title the D.P profile pic has to be displayed\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"Screenshot 2026-05-10 001926.png\",\"size\":64836,\"mime\":\"image\\/png\"}}}', '2026-05-09 18:51:18', '2026-05-09 18:51:18'),
(161, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":25,\"household_id\":null,\"first_name\":\"Shaik zahra bee\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":\"2012-01-04\",\"graveyard_location\":\"Chinna chowk\",\"email\":null,\"phone\":null,\"current_city\":\"Chinna chowk, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 18:55:19', '2026-05-09 18:55:19'),
(162, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":81,\"household_id\":null,\"first_name\":\"Syed Osman Saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":\"2012-01-01\",\"graveyard_location\":\"Chinna chowk\",\"email\":null,\"phone\":null,\"current_city\":\"Chintakommadinne, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 18:58:14', '2026-05-09 18:58:14'),
(163, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":11,\"first_name\":\"Syed Baba Fakruddin\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Chinna chowk, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 19:00:55', '2026-05-09 19:00:55'),
(164, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":11,\"first_name\":\"Syed Aleem\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"9346689593\",\"current_city\":\"Chinna chowk, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 19:02:25', '2026-05-09 19:02:25'),
(165, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":11,\"first_name\":\"Syed Peerullah\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Chinna chowk, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 19:03:28', '2026-05-09 19:03:28'),
(166, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 19:06:29', '2026-05-09 19:06:29'),
(167, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 19:07:03', '2026-05-09 19:07:03'),
(168, 21, 'admin', 3, 'PUT api/v1/family-members/22', 'PUT', 'api/v1/family-members/22', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Abdul Razzakh\",\"last_name\":\"Raja Saab\",\"gender\":\"male\",\"birth_date\":\"1937-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Yakub Saheb Maszid\",\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 19:08:35', '2026-05-09 19:08:35'),
(169, 21, 'admin', 3, 'PUT api/v1/family-members/81', 'PUT', 'api/v1/family-members/81', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik zahra bee\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1939-01-01\",\"birth_time\":null,\"death_date\":\"2012-01-04\",\"graveyard_location\":\"Chinna chowk\",\"email\":null,\"phone\":null,\"current_city\":\"Chinna chowk, Kadapa\",\"current_country\":\"India\",\"family_head_id\":6,\"relationship_to_family_head\":\"sister\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"sister\"}}', '2026-05-09 19:09:13', '2026-05-09 19:09:13'),
(170, 21, 'admin', 3, 'PUT api/v1/family-members/68', 'PUT', 'api/v1/family-members/68', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Hussain Saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"1941-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":6,\"relationship_to_family_head\":\"brother\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"brother\"}}', '2026-05-09 19:10:00', '2026-05-09 19:10:00'),
(171, 21, 'admin', 3, 'PUT api/v1/family-members/25', 'PUT', 'api/v1/family-members/25', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik\",\"last_name\":\"Madar Saheb\",\"gender\":\"male\",\"birth_date\":\"1943-07-01\",\"birth_time\":null,\"death_date\":\"1998-11-08\",\"graveyard_location\":\"Yakub Saheb Maszid Yard\",\"email\":\"son@nannesab.com\",\"phone\":\"1234578945\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":6,\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"son\"}}', '2026-05-09 19:10:36', '2026-05-09 19:10:36'),
(172, 21, 'admin', 3, 'PUT api/v1/family-members/31', 'PUT', 'api/v1/family-members/31', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik\",\"last_name\":\"Khasim saheb\",\"gender\":\"male\",\"birth_date\":\"1946-04-28\",\"birth_time\":null,\"death_date\":\"2020-04-28\",\"graveyard_location\":\"Kadapa\",\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":6,\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"son\"}}', '2026-05-09 19:11:28', '2026-05-09 19:11:28');
INSERT INTO `audit_trails` (`id`, `user_id`, `user_role`, `family_id`, `event`, `method`, `path`, `ip_address`, `user_agent`, `meta`, `created_at`, `updated_at`) VALUES
(173, 21, 'admin', 3, 'PUT api/v1/family-members/32', 'PUT', 'api/v1/family-members/32', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik\",\"last_name\":\"Dastagir Saheb\",\"gender\":\"male\",\"birth_date\":\"1948-04-28\",\"birth_time\":null,\"death_date\":\"2006-04-02\",\"graveyard_location\":\"Kadapa\",\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":6,\"relationship_to_family_head\":\"son\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"son\"}}', '2026-05-09 19:11:51', '2026-05-09 19:11:51'),
(174, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":32,\"household_id\":null,\"first_name\":\"Shaik Maalan bee\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1942-01-01\",\"birth_time\":null,\"death_date\":\"2010-01-01\",\"graveyard_location\":\"chinna chowk\",\"email\":null,\"phone\":null,\"current_city\":\"chinna chowk, kadapa\",\"current_country\":\"india\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 19:14:47', '2026-05-09 19:14:47'),
(175, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":86,\"household_id\":null,\"first_name\":\"Shaik Yakhub sab\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"1935-01-01\",\"birth_time\":null,\"death_date\":\"2002-01-01\",\"graveyard_location\":\"Chintakomma dinne\",\"email\":null,\"phone\":null,\"current_city\":\"Chinna chowk, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 19:17:18', '2026-05-09 19:17:18'),
(176, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Cause of death and in-house, accident, disease etc. tabs shall be kept\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"Screenshot 2026-05-10 005002.png\",\"size\":34081,\"mime\":\"image\\/png\"}}}', '2026-05-09 19:21:12', '2026-05-09 19:21:12'),
(177, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"12\",\"first_name\":\"Shaik Rafi\",\"gender\":\"male\",\"birth_date\":\"1972-01-01\",\"death_date\":\"2015-01-01\",\"graveyard_location\":\"Not known due to AIDS\",\"current_city\":\"Chinna chowk\",\"current_country\":\"India\",\"marital_status\":\"unmarried\",\"living_status\":\"deceased\",\"is_living\":\"0\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-10 at 12.53.44 AM.jpeg\",\"size\":7243,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 19:26:24', '2026-05-09 19:26:24'),
(178, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":500,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"sibling\",\"existing_person_id\":\"61\",\"first_name\":\"Shaik Gouse Basha\",\"gender\":\"male\",\"birth_date\":\"275760-01-01\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-10 at 1.05.36 AM.jpeg\",\"size\":53347,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 19:37:32', '2026-05-09 19:37:32'),
(179, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":500,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"sibling\",\"existing_person_id\":\"61\",\"first_name\":\"Shaik Gouse Basha\",\"gender\":\"male\",\"birth_date\":\"275760-01-01\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-10 at 1.05.36 AM.jpeg\",\"size\":53347,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 19:37:37', '2026-05-09 19:37:37'),
(180, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":500,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"sibling\",\"existing_person_id\":\"61\",\"first_name\":\"Shaik Gouse Basha\",\"gender\":\"male\",\"birth_date\":\"275760-01-01\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-10 at 1.05.36 AM.jpeg\",\"size\":53347,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 19:37:43', '2026-05-09 19:37:43'),
(181, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":500,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"sibling\",\"existing_person_id\":\"61\",\"first_name\":\"Shaik Gouse Basha\",\"gender\":\"male\",\"birth_date\":\"275760-01-01\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-10 at 1.05.36 AM.jpeg\",\"size\":53347,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 19:38:27', '2026-05-09 19:38:27'),
(182, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":500,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"sibling\",\"existing_person_id\":\"61\",\"first_name\":\"Shaik Gouse Basha\",\"gender\":\"male\",\"birth_date\":\"275760-01-01\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-10 at 1.05.36 AM.jpeg\",\"size\":53347,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 19:38:37', '2026-05-09 19:38:37'),
(183, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":500,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"sibling\",\"existing_person_id\":\"61\",\"first_name\":\"Shaik Gouse Basha\",\"gender\":\"male\",\"birth_date\":\"275760-01-01\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-10 at 1.05.36 AM.jpeg\",\"size\":53347,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 19:38:38', '2026-05-09 19:38:38'),
(184, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Basha mamu ammi brother not being added with the above error\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"Screenshot 2026-05-10 010902.png\",\"size\":55646,\"mime\":\"image\\/png\"}}}', '2026-05-09 19:39:51', '2026-05-09 19:39:51'),
(185, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 19:40:16', '2026-05-09 19:40:16'),
(186, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 19:40:31', '2026-05-09 19:40:31'),
(187, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":80,\"household_id\":null,\"first_name\":\"Shaik Kareemullah\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"1957-01-01\",\"birth_time\":null,\"death_date\":\"2002-01-01\",\"graveyard_location\":\"Yakum saheb masjid\",\"email\":null,\"phone\":null,\"current_city\":\"Matti peddapuli, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 19:42:56', '2026-05-09 19:42:56'),
(188, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"sibling\",\"existing_person_id\":\"61\",\"first_name\":\"Shaik Gouse Basha\",\"gender\":\"male\",\"birth_date\":\"1960-01-01\",\"phone\":\"8309396598\",\"current_city\":\"Agadi, Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"WhatsApp Image 2026-05-10 at 1.05.36 AM.jpeg\",\"size\":53347,\"mime\":\"image\\/jpeg\"}}}', '2026-05-09 19:45:27', '2026-05-09 19:45:27'),
(189, 21, 'admin', 3, 'PUT api/v1/feedback/47', 'PUT', 'api/v1/feedback/47', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"status\":\"resolved\"}}', '2026-05-09 19:46:17', '2026-05-09 19:46:17'),
(190, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":8,\"first_name\":\"Shaik Rehana\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1987-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"8374751084\",\"current_city\":\"New Market, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 19:51:44', '2026-05-09 19:51:44'),
(191, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 19:55:17', '2026-05-09 19:55:17'),
(192, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-09 19:55:40', '2026-05-09 19:55:40'),
(193, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":11,\"first_name\":\"Syed Hussain Bee\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1964-01-01\",\"birth_time\":null,\"death_date\":\"2024-01-01\",\"graveyard_location\":\"Due to Sugar and Madfulness\",\"email\":null,\"phone\":null,\"current_city\":\"Sub-Jail, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 19:59:52', '2026-05-09 19:59:52'),
(194, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":92,\"household_id\":null,\"first_name\":\"Shaik Magbool\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"1960-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Sub-Jail, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 20:02:06', '2026-05-09 20:02:06'),
(195, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":14,\"first_name\":\"Shaik Fatimun\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Sub-jail, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 20:03:42', '2026-05-09 20:03:42'),
(196, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":73,\"household_id\":null,\"first_name\":\"Shaik Hayat\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"1980-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Sub-jail, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 20:05:59', '2026-05-09 20:05:59'),
(197, 21, 'admin', 3, 'PUT api/v1/family-members/73', 'PUT', 'api/v1/family-members/73', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Fatimun\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"9000178016\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":22,\"relationship_to_family_head\":\"daughter\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":\"daughter\"}}', '2026-05-09 20:08:36', '2026-05-09 20:08:36'),
(198, 21, 'admin', 3, 'DELETE api/v1/family-members/94', 'DELETE', 'api/v1/family-members/94', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 20:13:07', '2026-05-09 20:13:07'),
(199, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":14,\"first_name\":\"Shaik. Fatimun\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"sub-jail, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 20:15:03', '2026-05-09 20:15:03'),
(200, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":95,\"household_id\":null,\"first_name\":\"Shaik Hayath\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Sub-jail, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 20:16:32', '2026-05-09 20:16:32'),
(201, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":12,\"first_name\":\"Shaik Naazneen\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1977-01-01\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"8919103165\",\"current_city\":\"Chinna chowk, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-09 20:20:51', '2026-05-09 20:20:51'),
(202, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:4091:8003:4011:e009:1687:ad8f:bfa3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-09 20:23:48', '2026-05-09 20:23:48'),
(203, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-10 02:06:05', '2026-05-10 02:06:05'),
(204, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-10 02:06:13', '2026-05-10 02:06:13'),
(205, 19, 'user', 3, 'POST api/v1/family-members/43/photo', 'POST', 'api/v1/family-members/43/photo', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"gemini_remix_20251230_190934.jpg\",\"size\":308094,\"mime\":\"image\\/jpeg\"}}}', '2026-05-10 02:11:46', '2026-05-10 02:11:46'),
(206, 19, 'user', 3, 'POST api/v1/family-members/43/photo', 'POST', 'api/v1/family-members/43/photo', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"IMG_20260510_074340.jpg\",\"size\":147812,\"mime\":\"image\\/jpeg\"}}}', '2026-05-10 02:13:57', '2026-05-10 02:13:57'),
(207, 19, 'user', 3, 'POST api/v1/family-members/43/photo', 'POST', 'api/v1/family-members/43/photo', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"IMG_20260510_074525.jpg\",\"size\":190411,\"mime\":\"image\\/jpeg\"}}}', '2026-05-10 02:18:05', '2026-05-10 02:18:05'),
(208, 19, 'user', 3, 'POST api/v1/family-members/58/photo', 'POST', 'api/v1/family-members/58/photo', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"Noor Uncle small.jpg\",\"size\":12092,\"mime\":\"image\\/jpeg\"}}}', '2026-05-10 02:19:06', '2026-05-10 02:19:06'),
(209, 19, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":49,\"household_id\":null,\"first_name\":\"Shaik Jaaved\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-10 02:21:04', '2026-05-10 02:21:04'),
(210, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Add membership contact auto auto import\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-10 02:21:51', '2026-05-10 02:21:51'),
(211, 19, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"spouse\",\"existing_person_id\":\"58\",\"first_name\":\"Syed Dilshad Begam\",\"gender\":\"female\",\"birth_date\":\"1960-05-10\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"100_0009.JPG\",\"size\":2173396,\"mime\":\"image\\/jpeg\"}}}', '2026-05-10 02:24:25', '2026-05-10 02:24:25'),
(212, 19, 'user', 3, 'POST api/v1/family-members/43/photo', 'POST', 'api/v1/family-members/43/photo', '2406:7400:35:39b8:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"IMG_20260510_075741.jpg\",\"size\":229448,\"mime\":\"image\\/jpeg\"}}}', '2026-05-10 02:27:57', '2026-05-10 02:27:57'),
(213, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:78e1:880a:2805:b49f', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-10 04:44:57', '2026-05-10 04:44:57'),
(214, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":[]}', '2026-05-10 06:09:23', '2026-05-10 06:09:23'),
(215, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-10 06:09:40', '2026-05-10 06:09:40'),
(216, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":6,\"household_id\":null,\"first_name\":\"Shaik Baba saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"2026-05-10\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Nadi kheda, kadapa\",\"email\":null,\"phone\":null,\"current_city\":\"Nadi kheda, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-10 06:32:18', '2026-05-10 06:32:18'),
(217, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":6,\"household_id\":null,\"first_name\":\"Shaik Rahmtu saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Nadi kheda\",\"email\":null,\"phone\":null,\"current_city\":\"Nadi kheda, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-10 06:34:05', '2026-05-10 06:34:05'),
(218, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"sibling\",\"existing_person_id\":6,\"household_id\":null,\"first_name\":\"Shaik Madar saab\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Nadi kheda, kadapa\",\"email\":null,\"phone\":null,\"current_city\":\"Nadi kheda, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-10 06:35:56', '2026-05-10 06:35:56'),
(219, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:301b:ee2:a13d:528f:14e:dbbd', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-10 12:09:12', '2026-05-10 12:09:12'),
(220, 21, 'admin', 3, 'PUT api/v1/family-members/100', 'PUT', 'api/v1/family-members/100', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Baba saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"1920-05-10\",\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Nadi kheda, kadapa\",\"email\":null,\"phone\":null,\"current_city\":\"Nadi kheda, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":\"brother\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"brother\"}}', '2026-05-10 12:27:24', '2026-05-10 12:27:24'),
(221, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:40f0:301b:ee2:a13d:528f:14e:dbbd', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"To Fatima are in one family\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\",\"screenshot\":{\"name\":\"Screenshot_2026-05-10-17-59-54-29_40deb401b9ffe8e1df2f1cc5ba480b12.jpg\",\"size\":379192,\"mime\":\"image\\/jpeg\"}}}', '2026-05-10 12:30:29', '2026-05-10 12:30:29'),
(222, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:40f0:301b:ee2:a13d:528f:14e:dbbd', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-10 12:31:54', '2026-05-10 12:31:54'),
(223, 1, 'super_admin', NULL, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:301b:ee2:a13d:528f:14e:dbbd', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"superadmin@familytree.test\",\"password\":\"***\"}}', '2026-05-10 12:32:04', '2026-05-10 12:32:04'),
(224, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"notes\":\"In i in iPhone, all the tabs such as NEXT is not shoing\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"IMG_1679.png\",\"size\":160644,\"mime\":\"image\\/png\"}}}', '2026-05-10 12:34:06', '2026-05-10 12:34:06'),
(225, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"notes\":\"Person should be shown in age order, not in alphabetical order\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"IMG_1680.png\",\"size\":451848,\"mime\":\"image\\/png\"}}}', '2026-05-10 12:37:10', '2026-05-10 12:37:10'),
(226, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"notes\":\"Bug in this\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"IMG_1681.png\",\"size\":727208,\"mime\":\"image\\/png\"}}}', '2026-05-10 12:52:15', '2026-05-10 12:52:15'),
(227, 21, 'admin', 3, 'DELETE api/v1/family-members/73', 'DELETE', 'api/v1/family-members/73', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":[]}', '2026-05-10 12:59:11', '2026-05-10 12:59:11'),
(228, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"notes\":\"Overlapping tabs\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"IMG_1682.png\",\"size\":146753,\"mime\":\"image\\/png\"}}}', '2026-05-10 13:11:20', '2026-05-10 13:11:20'),
(229, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":10,\"first_name\":\"Shaik Fatimun\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"90001 78016\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-10 13:16:42', '2026-05-10 13:16:42'),
(230, 1, 'super_admin', NULL, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:40f0:301b:ee2:a13d:528f:14e:dbbd', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Add family member the default country is India provide option to change country if user designs\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/super-admin\\/feedback\"}}', '2026-05-10 13:16:46', '2026-05-10 13:16:46'),
(231, 1, 'super_admin', NULL, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:40f0:301b:ee2:a13d:528f:14e:dbbd', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-10 13:17:22', '2026-05-10 13:17:22'),
(232, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:40f0:301b:ee2:a13d:528f:14e:dbbd', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-10 13:17:40', '2026-05-10 13:17:40'),
(233, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:40f0:301b:ee2:a13d:528f:14e:dbbd', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Options of family members childrens anyone by date of birth my alphabet and by generation\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-10 13:18:13', '2026-05-10 13:18:13'),
(234, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:40f0:319e:7da0:285a:3c56:dc53:e479', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"notes\":\"Children Tab must be separable from siblings and must be appeared highlighted\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"IMG_1683.png\",\"size\":313376,\"mime\":\"image\\/png\"}}}', '2026-05-10 13:19:55', '2026-05-10 13:19:55'),
(235, 21, 'admin', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2409:4091:8003:4011:1cc9:ae1d:9b8:da84', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":[]}', '2026-05-10 17:27:41', '2026-05-10 17:27:41'),
(236, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:1cc9:ae1d:9b8:da84', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-10 17:28:00', '2026-05-10 17:28:00'),
(237, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:1cc9:ae1d:9b8:da84', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"parent\",\"existing_person_id\":6,\"household_id\":null,\"first_name\":\"Shaik Buden Saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":\"1920-05-10\",\"graveyard_location\":\"Nadikheda\",\"email\":null,\"phone\":null,\"current_city\":\"Nadi kheda\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-10 17:29:53', '2026-05-10 17:29:53'),
(238, 21, 'admin', 3, 'PUT api/v1/family-members/102', 'PUT', 'api/v1/family-members/102', '2409:4091:8003:4011:1cc9:ae1d:9b8:da84', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Madar saab\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"In kadapa\",\"email\":null,\"phone\":null,\"current_city\":\"Nadi kheda, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":\"brother\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"brother\"}}', '2026-05-10 17:32:20', '2026-05-10 17:32:20'),
(239, 21, 'admin', 3, 'PUT api/v1/family-members/102', 'PUT', 'api/v1/family-members/102', '2409:4091:8003:4011:1cc9:ae1d:9b8:da84', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Madar saab\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Yakub sab masjid\",\"email\":null,\"phone\":null,\"current_city\":\"Nadi kheda, kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":\"brother\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"brother\"}}', '2026-05-10 17:32:59', '2026-05-10 17:32:59'),
(240, 21, 'admin', 3, 'PUT api/v1/family-members/101', 'PUT', 'api/v1/family-members/101', '2409:4091:8003:4011:1cc9:ae1d:9b8:da84', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Rahmtu saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Yakubsab masjid\",\"email\":null,\"phone\":null,\"current_city\":\"Nadi kheda\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":\"brother\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"brother\"}}', '2026-05-10 17:34:12', '2026-05-10 17:34:12'),
(241, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:7486:788c:6f45:5912', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"parent\",\"existing_person_id\":82,\"household_id\":null,\"first_name\":\"Syed Buden saheb\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":\"1910-05-11\",\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Nadi kheda\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-11 15:55:35', '2026-05-11 15:55:35'),
(242, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:8c70:94e9:9f30:7dce:a6cd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-11 16:00:05', '2026-05-11 16:00:05'),
(243, 19, 'user', 3, 'POST api/v1/family-members/41/photo', 'POST', 'api/v1/family-members/41/photo', '2406:7400:35:8c70:94e9:9f30:7dce:a6cd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"Khaja_Mynuddin_Psychologist.png\",\"size\":1334739,\"mime\":\"image\\/png\"}}}', '2026-05-11 16:00:25', '2026-05-11 16:00:25'),
(244, 19, 'user', 3, 'POST api/v1/family-members/41/photo', 'POST', 'api/v1/family-members/41/photo', '2406:7400:35:8c70:94e9:9f30:7dce:a6cd', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"Khaja_Mynuddin_Psychologist_PP_Photo.png\",\"size\":478052,\"mime\":\"image\\/png\"}}}', '2026-05-11 16:02:48', '2026-05-11 16:02:48'),
(245, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:7486:788c:6f45:5912', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"parent\",\"existing_person_id\":61,\"household_id\":null,\"first_name\":\"Shaik Khajamiah\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Maddu khan masjid\",\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-11 17:19:14', '2026-05-11 17:19:14'),
(246, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:7486:788c:6f45:5912', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"parent\",\"existing_person_id\":61,\"household_id\":null,\"first_name\":\"Shaik Zainab Bee\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Maddu khan masjid\",\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-11 17:21:20', '2026-05-11 17:21:20'),
(247, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:8c70:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-12 00:21:00', '2026-05-12 00:21:00'),
(248, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:8c70:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"In members page newly added sort option\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-12 00:22:34', '2026-05-12 00:22:34'),
(249, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:8c70:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Activity for end user\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-12 00:23:34', '2026-05-12 00:23:34'),
(250, 15, 'user', 3, 'POST api/v1/family-members/38/photo', 'POST', 'api/v1/family-members/38/photo', '2405:201:c056:409d:ba4b:af3c:98f8:15a9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000205974.jpg\",\"size\":62019,\"mime\":\"image\\/jpeg\"}}}', '2026-05-12 00:30:17', '2026-05-12 00:30:17'),
(251, 15, 'user', 3, 'POST api/v1/family-members/34/photo', 'POST', 'api/v1/family-members/34/photo', '2405:201:c056:409d:ba4b:af3c:98f8:15a9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000205971.jpg\",\"size\":40783,\"mime\":\"image\\/jpeg\"}}}', '2026-05-12 00:31:33', '2026-05-12 00:31:33');
INSERT INTO `audit_trails` (`id`, `user_id`, `user_role`, `family_id`, `event`, `method`, `path`, `ip_address`, `user_agent`, `meta`, `created_at`, `updated_at`) VALUES
(252, 15, 'user', 3, 'POST api/v1/family-members/30/photo', 'POST', 'api/v1/family-members/30/photo', '2405:201:c056:409d:ba4b:af3c:98f8:15a9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000205972.jpg\",\"size\":185507,\"mime\":\"image\\/jpeg\"}}}', '2026-05-12 00:31:51', '2026-05-12 00:31:51'),
(253, 15, 'user', 3, 'POST api/v1/family-members/35/photo', 'POST', 'api/v1/family-members/35/photo', '2405:201:c056:409d:ba4b:af3c:98f8:15a9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000205976.jpg\",\"size\":113661,\"mime\":\"image\\/jpeg\"}}}', '2026-05-12 00:33:09', '2026-05-12 00:33:09'),
(254, 15, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2405:201:c056:409d:ba4b:af3c:98f8:15a9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Give dragon option to organize by age big to small\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\"}}', '2026-05-12 00:39:55', '2026-05-12 00:39:55'),
(255, 15, 'user', 3, 'POST api/v1/family-members/31/photo', 'POST', 'api/v1/family-members/31/photo', '2405:201:c056:409d:ba4b:af3c:98f8:15a9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000205988.jpg\",\"size\":831985,\"mime\":\"image\\/jpeg\"}}}', '2026-05-12 01:37:20', '2026-05-12 01:37:20'),
(256, 15, 'user', 3, 'POST api/v1/family-members/31/photo', 'POST', 'api/v1/family-members/31/photo', '2405:201:c056:409d:ba4b:af3c:98f8:15a9', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000205989.jpg\",\"size\":495386,\"mime\":\"image\\/jpeg\"}}}', '2026-05-12 01:38:40', '2026-05-12 01:38:40'),
(257, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:d5c:717f:194b:5955', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":13,\"first_name\":\"Shaik shabana\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"+91 90307 41602\",\"current_city\":\"Nellore\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 02:45:47', '2026-05-12 02:45:47'),
(258, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:d5c:717f:194b:5955', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":13,\"first_name\":\"Shaik Reehana\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"91540 04937\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 02:50:42', '2026-05-12 02:50:42'),
(259, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:d5c:717f:194b:5955', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":13,\"first_name\":\"Shaik Chotima\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"81212 00875\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 02:53:12', '2026-05-12 02:53:12'),
(260, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:d5c:717f:194b:5955', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":13,\"first_name\":\"Shaik Ali\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"77025 03508\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 02:54:30', '2026-05-12 02:54:30'),
(261, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:d5c:717f:194b:5955', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":90,\"household_id\":null,\"first_name\":\"Shaik Habeeb\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"+91 8309-396598\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 02:56:48', '2026-05-12 02:56:48'),
(262, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:8c70:2de1:3c80:7790:a5c3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-12 15:23:03', '2026-05-12 15:23:03'),
(263, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:8c70:2de1:3c80:7790:a5c3', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-12 15:27:00', '2026-05-12 15:27:00'),
(264, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '49.47.249.14', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":422,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":68,\"household_id\":null,\"first_name\":\"Shaik Khairunnisa\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"2026-05-12\",\"birth_time\":null,\"death_date\":\"1982-05-12\",\"graveyard_location\":\"Yakhubsab masjid\",\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 15:37:31', '2026-05-12 15:37:31'),
(265, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":68,\"household_id\":null,\"first_name\":\"Shaik Khairunnisa\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":\"1961-05-12\",\"birth_time\":null,\"death_date\":\"1982-05-12\",\"graveyard_location\":\"Yakhubsab masjid\",\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 15:38:35', '2026-05-12 15:38:35'),
(266, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":20,\"first_name\":\"Shaik Abdul khader jeelan\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":\"2024-05-12\",\"graveyard_location\":\"Yakhub sab Masjd\",\"email\":null,\"phone\":null,\"current_city\":\"Kurnool\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 16:02:33', '2026-05-12 16:02:33'),
(267, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":20,\"first_name\":\"Shaik Mahabunnisa\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Mantapampale\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 16:04:19', '2026-05-12 16:04:19'),
(268, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":20,\"first_name\":\"Shaik Munni\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Chagalmarri\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 16:05:21', '2026-05-12 16:05:21'),
(269, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":20,\"first_name\":\"Shaik Iqbal Hussain\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"+91 90305 45487\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 16:08:00', '2026-05-12 16:08:00'),
(270, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":20,\"first_name\":\"Shaik Sirajun\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"96402 54080\",\"current_city\":\"Kagital penta, Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 16:09:36', '2026-05-12 16:09:36'),
(271, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":20,\"first_name\":\"Shaik zeenat\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":\"Yakhub sab masjid\",\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 16:10:57', '2026-05-12 16:10:57'),
(272, 21, 'admin', 3, 'PUT api/v1/family-members/87', 'PUT', 'api/v1/family-members/87', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"family_id\":3,\"tree_family_id\":\"3\",\"add_member_type\":null,\"existing_person_id\":null,\"household_id\":null,\"first_name\":\"Shaik Yakhub sab\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":\"1935-01-01\",\"birth_time\":null,\"death_date\":\"2002-01-01\",\"graveyard_location\":\"Vonthapalli near siiddhavatam\",\"email\":null,\"phone\":null,\"current_city\":\"Chinna chowk, Kadapa\",\"current_country\":\"India\",\"family_head_id\":86,\"relationship_to_family_head\":\"spouse\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":false,\"is_private\":false,\"relation_to_family_head\":\"spouse\"}}', '2026-05-12 16:13:48', '2026-05-12 16:13:48'),
(273, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:7066:360a:a9a3:5445', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-12 17:01:39', '2026-05-12 17:01:39'),
(274, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:7066:360a:a9a3:5445', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":117,\"household_id\":null,\"first_name\":\"Shaik Amreen\",\"last_name\":null,\"gender\":\"female\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"9030545487\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 17:09:51', '2026-05-12 17:09:51'),
(275, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:7066:360a:a9a3:5445', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":103,\"household_id\":null,\"first_name\":\"Shaik Jaffer\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 17:13:11', '2026-05-12 17:13:11'),
(276, 21, 'admin', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2409:4091:8003:4011:7066:360a:a9a3:5445', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"spouse\",\"existing_person_id\":75,\"household_id\":null,\"first_name\":\"Shaik Basheer\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":\"+96550723327\",\"current_city\":null,\"current_country\":\"Kuwait\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-12 17:16:03', '2026-05-12 17:16:03'),
(277, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:8c70:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-13 01:56:10', '2026-05-13 01:56:10'),
(278, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:8c70:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-13 01:56:43', '2026-05-13 01:56:43'),
(279, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:8c70:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-13 01:57:25', '2026-05-13 01:57:25'),
(280, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:8c70:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-13 01:57:49', '2026-05-13 01:57:49'),
(281, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:8c70:a9ed:7746:8f9c:df57', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-13 02:00:00', '2026-05-13 02:00:00'),
(282, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '49.47.249.14', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-13 02:56:13', '2026-05-13 02:56:13'),
(283, 21, 'admin', 3, 'PUT api/v1/family-members/86', 'PUT', 'api/v1/family-members/86', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"family_id\":\"3\",\"tree_family_id\":\"3\",\"first_name\":\"Shaik Maalan bee\",\"gender\":\"female\",\"birth_date\":\"1942-01-01\",\"death_date\":\"2010-01-01\",\"graveyard_location\":\"chinna chowk\",\"current_city\":\"chinna chowk, kadapa\",\"current_country\":\"india\",\"family_head_id\":\"6\",\"relationship_to_family_head\":\"sister\",\"marital_status\":\"married\",\"living_status\":\"deceased\",\"is_living\":\"0\",\"is_private\":\"0\",\"_method\":\"PUT\",\"relation_to_family_head\":\"sister\",\"photo\":{\"name\":\"IMG_1690.jpeg\",\"size\":80311,\"mime\":\"image\\/jpeg\"}}}', '2026-05-13 02:58:11', '2026-05-13 02:58:11'),
(284, 21, 'admin', 3, 'POST api/v1/family-members/87/photo', 'POST', 'api/v1/family-members/87/photo', '2409:4091:8003:4011:6551:8afc:76e:d22a', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"509dffdb-e42f-4d3b-833c-732c7da3e7ce.jpeg\",\"size\":79176,\"mime\":\"image\\/jpeg\"}}}', '2026-05-13 02:58:21', '2026-05-13 02:58:21'),
(285, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:b546:8d8c:bc5b:5516', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"notes\":\"Jeelan Bhaiya and Nazneen bhabhi are added below their parents, but how to add as each other\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\"}}', '2026-05-13 08:14:00', '2026-05-13 08:14:00'),
(286, 21, 'admin', 3, 'POST api/v1/family-members/103/photo', 'POST', 'api/v1/family-members/103/photo', '2409:4091:8003:4011:b546:8d8c:bc5b:5516', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1e0b06b3-055e-4d50-b6a0-78ae3e9be496_938D29EC-24E8-4F3B-8348-6915DC16873E.jpeg\",\"size\":21572,\"mime\":\"image\\/jpeg\"}}}', '2026-05-13 08:15:10', '2026-05-13 08:15:10'),
(287, 21, 'admin', 3, 'POST api/v1/family-members/121/photo', 'POST', 'api/v1/family-members/121/photo', '2409:4091:8003:4011:b546:8d8c:bc5b:5516', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1e0b06b3-055e-4d50-b6a0-78ae3e9be496_B6444C0C-7FE6-4652-9D40-F496BFD844B9.jpeg\",\"size\":23057,\"mime\":\"image\\/jpeg\"}}}', '2026-05-13 08:15:47', '2026-05-13 08:15:47'),
(288, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:b546:8d8c:bc5b:5516', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"notes\":\"Here khaja Mia appears as parent to Ammi, but in children, Ammi is not appearing\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"IMG_1698.png\",\"size\":652924,\"mime\":\"image\\/png\"}}}', '2026-05-13 08:19:18', '2026-05-13 08:19:18'),
(289, 21, 'admin', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2409:4091:8003:4011:b546:8d8c:bc5b:5516', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":201,\"payload\":{\"notes\":\"Here Ammi is not appearing as children to khaja Mia\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/admin\\/feedback\",\"screenshot\":{\"name\":\"IMG_1699.png\",\"size\":185505,\"mime\":\"image\\/png\"}}}', '2026-05-13 08:20:53', '2026-05-13 08:20:53'),
(290, 15, 'user', 3, 'POST api/v1/family-members/74/photo', 'POST', 'api/v1/family-members/74/photo', '2405:201:c056:409d:77b6:7979:e8cd:c05a', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000206367.jpg\",\"size\":28401,\"mime\":\"image\\/jpeg\"}}}', '2026-05-13 14:56:26', '2026-05-13 14:56:26'),
(291, 15, 'user', 3, 'POST api/v1/family-members/91/photo', 'POST', 'api/v1/family-members/91/photo', '2405:201:c056:409d:77b6:7979:e8cd:c05a', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000206377.png\",\"size\":2410487,\"mime\":\"image\\/png\"}}}', '2026-05-13 15:30:01', '2026-05-13 15:30:01'),
(292, 15, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2405:201:c056:409d:77b6:7979:e8cd:c05a', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":8,\"first_name\":\"Shaik mohommad hussain\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-13 15:33:08', '2026-05-13 15:33:08'),
(293, 21, 'admin', 3, 'POST api/v1/family-members/114/photo', 'POST', 'api/v1/family-members/114/photo', '2409:4091:8003:4011:78d3:8c1c:3b7a:c1ad', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"016a539f-d788-49b6-8f89-ae47e93daf92_5C7DED13-8A8D-4038-B7D6-C39C039F7EA9.jpeg\",\"size\":28963,\"mime\":\"image\\/jpeg\"}}}', '2026-05-13 17:27:32', '2026-05-13 17:27:32'),
(294, 21, 'admin', 3, 'POST api/v1/family-members/117/photo', 'POST', 'api/v1/family-members/117/photo', '2409:4091:8003:4011:78d3:8c1c:3b7a:c1ad', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"IMG_1704.jpeg\",\"size\":42024,\"mime\":\"image\\/jpeg\"}}}', '2026-05-13 17:32:10', '2026-05-13 17:32:10'),
(295, 19, 'user', 3, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:9958:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"smartworldcom@gmail.com\",\"password\":\"***\"}}', '2026-05-14 03:40:59', '2026-05-14 03:40:59'),
(296, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:9958:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"For and users existing person should be fixed who is logging and do not provide the option to change the existing person\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\",\"screenshot\":{\"name\":\"Screenshot_2026-05-14-09-13-20-93_40deb401b9ffe8e1df2f1cc5ba480b12.jpg\",\"size\":252839,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 03:44:22', '2026-05-14 03:44:22'),
(297, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:9958:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Concise the upload images God and button and display the images uploaded images preview\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\",\"screenshot\":{\"name\":\"Screenshot_2026-05-14-09-11-14-13_40deb401b9ffe8e1df2f1cc5ba480b12.jpg\",\"size\":390015,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 03:45:40', '2026-05-14 03:45:40'),
(298, 15, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"spouse\",\"existing_person_id\":\"31\",\"first_name\":\"Shaik Aqtar\",\"gender\":\"female\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"1000206507.jpg\",\"size\":50510,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 10:34:17', '2026-05-14 10:34:17'),
(299, 15, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":24,\"first_name\":\"SHIAK IMTIYAAZ\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-14 10:36:22', '2026-05-14 10:36:22'),
(300, 15, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":3,\"tree_family_id\":null,\"add_member_type\":\"child\",\"existing_person_id\":null,\"household_id\":24,\"first_name\":\"Shaik Fayaaz\",\"last_name\":null,\"gender\":\"male\",\"birth_date\":null,\"birth_time\":null,\"death_date\":null,\"graveyard_location\":null,\"email\":null,\"phone\":null,\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"family_head_id\":null,\"relationship_to_family_head\":null,\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":true,\"is_private\":false,\"relation_to_family_head\":null}}', '2026-05-14 10:38:09', '2026-05-14 10:38:09'),
(301, 15, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"24\",\"first_name\":\"Nusrat\",\"gender\":\"female\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"1000206502.png\",\"size\":2503755,\"mime\":\"image\\/png\"}}}', '2026-05-14 10:40:08', '2026-05-14 10:40:08'),
(302, 15, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"24\",\"first_name\":\"Shevaar\",\"gender\":\"female\",\"phone\":\"9182699408\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"1000206508.jpg\",\"size\":49136,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 10:48:01', '2026-05-14 10:48:01'),
(303, 15, 'user', 3, 'POST api/v1/family-members', 'POST', 'api/v1/family-members', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"family_id\":\"3\",\"add_member_type\":\"child\",\"household_id\":\"24\",\"first_name\":\"Tabasum\",\"gender\":\"female\",\"phone\":\"+918897920780\",\"current_city\":\"Kadapa\",\"current_country\":\"India\",\"marital_status\":\"married\",\"living_status\":\"living\",\"is_living\":\"1\",\"is_private\":\"0\",\"photo\":{\"name\":\"1000206505.png\",\"size\":1868155,\"mime\":\"image\\/png\"}}}', '2026-05-14 10:49:23', '2026-05-14 10:49:23'),
(304, 21, 'admin', 3, 'POST api/v1/family-members/25/photo', 'POST', 'api/v1/family-members/25/photo', '2409:4091:8003:4011:7473:13e0:1994:ed3d', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"IMG_1707.jpeg\",\"size\":1424639,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 12:52:16', '2026-05-14 12:52:16'),
(305, 19, 'user', 3, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:19a9:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Recently added filter\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/app\\/feedback\",\"screenshot\":{\"name\":\"Screenshot_2026-05-14-18-57-30-51_40deb401b9ffe8e1df2f1cc5ba480b12.jpg\",\"size\":334967,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 13:27:56', '2026-05-14 13:27:56'),
(306, 19, 'user', 3, 'POST api/v1/logout', 'POST', 'api/v1/logout', '2406:7400:35:19a9:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":[]}', '2026-05-14 13:28:09', '2026-05-14 13:28:09'),
(307, 1, 'super_admin', NULL, 'AUTH login', 'POST', 'api/v1/login', '2406:7400:35:19a9:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"superadmin@familytree.test\",\"password\":\"***\"}}', '2026-05-14 13:28:13', '2026-05-14 13:28:13'),
(308, 1, 'super_admin', NULL, 'POST api/v1/feedback', 'POST', 'api/v1/feedback', '2406:7400:35:19a9:d90f:e99a:d614:65be', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', '{\"status_code\":201,\"payload\":{\"notes\":\"Remove family drop down selection from the admin role superhit mineral\",\"source_url\":\"https:\\/\\/familytree.khajamynuddin.com\\/super-admin\\/feedback\",\"screenshot\":{\"name\":\"Screenshot_2026-05-14-18-58-36-13_40deb401b9ffe8e1df2f1cc5ba480b12.jpg\",\"size\":402941,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 13:29:04', '2026-05-14 13:29:04'),
(309, 15, 'user', 3, 'POST api/v1/family-members/116/photo', 'POST', 'api/v1/family-members/116/photo', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000206696.jpg\",\"size\":158207,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 13:33:28', '2026-05-14 13:33:28'),
(310, 15, 'user', 3, 'POST api/v1/family-members/118/photo', 'POST', 'api/v1/family-members/118/photo', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000206694.jpg\",\"size\":315521,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 13:37:01', '2026-05-14 13:37:01'),
(311, 21, 'admin', 3, 'AUTH login', 'POST', 'api/v1/login', '2409:4091:8003:4011:9ca5:2a92:248b:be1', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":{\"email\":\"afsiraj@gmail.com\",\"password\":\"***\"}}', '2026-05-14 13:37:31', '2026-05-14 13:37:31'),
(312, 15, 'user', 3, 'POST api/v1/family-members/119/photo', 'POST', 'api/v1/family-members/119/photo', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000206725.jpg\",\"size\":551948,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 14:10:13', '2026-05-14 14:10:13'),
(313, 15, 'user', 3, 'POST api/v1/family-members/115/photo', 'POST', 'api/v1/family-members/115/photo', '2405:201:c056:409d:bcbf:d35a:3a8d:8a62', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Mobile Safari/537.36', '{\"status_code\":200,\"payload\":{\"photo\":{\"name\":\"1000206695.jpg\",\"size\":249358,\"mime\":\"image\\/jpeg\"}}}', '2026-05-14 14:12:42', '2026-05-14 14:12:42'),
(314, 21, 'admin', 3, 'DELETE api/v1/family-members/123', 'DELETE', 'api/v1/family-members/123', '2409:4091:8003:4011:8d65:d41d:dd2:a8f9', 'Mozilla/5.0 (iPhone; CPU iPhone OS 18_6_2 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) CriOS/148.0.7778.100 Mobile/15E148 Safari/604.1', '{\"status_code\":200,\"payload\":[]}', '2026-05-14 17:41:09', '2026-05-14 17:41:09'),
(315, 1, 'super_admin', NULL, 'AUTH login', 'POST', 'api/v1/login', '203.153.46.98', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36', '{\"status_code\":200,\"payload\":{\"email\":\"superadmin@familytree.test\",\"password\":\"***\"}}', '2026-05-15 06:28:26', '2026-05-15 06:28:26');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `uuid` varchar(255) NOT NULL,
  `connection` text NOT NULL,
  `queue` text NOT NULL,
  `payload` longtext NOT NULL,
  `exception` longtext NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `families`
--

CREATE TABLE `families` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `slug` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `families`
--

INSERT INTO `families` (`id`, `name`, `slug`, `description`, `is_active`, `created_by`, `created_at`, `updated_at`) VALUES
(3, 'Shaik Nanne Saheb Family', 'shaik-nanne-saheb-family', 'Family rooted at Shaik Nanne Saheb.', 1, 1, '2026-04-27 07:15:43', '2026-04-27 14:15:22'),
(4, 'Shaik Raja Saab Family', 'shaik-raja-saab-family', 'Family branch created for married member Shaik Raja Saab.', 1, 1, '2026-04-27 16:13:16', '2026-04-27 16:13:16'),
(6, 'Shaik Madar Saheb Family', 'shaik-madar-saheb-family', 'Family branch created for married member Shaik Madar Saheb.', 1, 1, '2026-04-28 11:05:53', '2026-04-28 11:05:53'),
(7, 'Shaik Amina Bee Family', 'shaik-amina-bee-family', 'Family branch created for married member Shaik Amina Bee.', 1, 1, '2026-04-28 13:52:36', '2026-04-28 13:52:36'),
(11, 'Shaik Yasmeen Family', 'shaik-yasmeen-family', 'Family branch created for married member Shaik Yasmeen.', 1, NULL, '2026-04-28 15:00:21', '2026-04-28 15:00:21'),
(12, 'Shaik Khsim saheb Family', 'shaik-khsim-saheb-family', 'Family branch created for married member Shaik Khsim saheb.', 1, NULL, '2026-04-28 15:22:15', '2026-04-28 15:22:15'),
(13, 'Shaik Dastagir Saheb Family', 'shaik-dastagir-saheb-family', 'Family branch created for married member Shaik Dastagir Saheb.', 1, NULL, '2026-04-28 15:56:16', '2026-04-28 15:56:16');

-- --------------------------------------------------------

--
-- Table structure for table `family_connection_requests`
--

CREATE TABLE `family_connection_requests` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `family_id` bigint(20) UNSIGNED NOT NULL,
  `anchor_member_id` bigint(20) UNSIGNED NOT NULL,
  `claimed_member_id` bigint(20) UNSIGNED DEFAULT NULL,
  `relationship_to_anchor` varchar(50) NOT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'pending',
  `claimed_first_name` varchar(255) NOT NULL,
  `claimed_last_name` varchar(255) DEFAULT NULL,
  `claimed_email` varchar(255) DEFAULT NULL,
  `claimed_phone` varchar(255) DEFAULT NULL,
  `evidence_notes` text DEFAULT NULL,
  `resolved_by` bigint(20) UNSIGNED DEFAULT NULL,
  `resolved_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `family_connection_requests`
--

INSERT INTO `family_connection_requests` (`id`, `user_id`, `family_id`, `anchor_member_id`, `claimed_member_id`, `relationship_to_anchor`, `status`, `claimed_first_name`, `claimed_last_name`, `claimed_email`, `claimed_phone`, `evidence_notes`, `resolved_by`, `resolved_at`, `created_at`, `updated_at`) VALUES
(3, 15, 3, 25, 34, 'daughter', 'approved', 'Ruhi', 'Ahmad', 'ruhiahmadsayeda@gmail.com', '+919059797297', 'I am daughter of shaik Madar saheb', 1, '2026-05-01 14:10:57', '2026-05-01 14:09:18', '2026-05-01 14:10:57'),
(7, 19, 3, 25, 41, 'son', 'approved', 'SHAIK', 'KHAJA MYNUDDIN', 'smartworldcom@gmail.com', '+918121990714', 'I am the son', 1, '2026-05-01 16:04:06', '2026-05-01 16:03:37', '2026-05-01 16:04:06'),
(8, 20, 3, 41, 42, 'spouse', 'approved', 'Syed', 'Nasreen Fathima', 'nasreen1057@gmail.com', '9390797705', NULL, 1, '2026-05-01 16:57:38', '2026-05-01 16:56:57', '2026-05-01 16:57:38'),
(9, 21, 3, 25, 52, 'son', 'approved', 'Sirajuddin', NULL, 'afsiraj@gmail.com', '9848283859', NULL, 1, '2026-05-03 11:10:15', '2026-05-03 11:09:39', '2026-05-03 11:10:15'),
(10, 23, 3, 41, NULL, 'son', 'pending', 'SHAIK', 'MUJAHID AKRAM', 'smujahidakram@gmail.com', '7013786131', NULL, NULL, NULL, '2026-05-07 08:41:02', '2026-05-07 08:41:23');

-- --------------------------------------------------------

--
-- Table structure for table `family_members`
--

CREATE TABLE `family_members` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `family_id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `first_name` varchar(255) NOT NULL,
  `last_name` varchar(255) DEFAULT NULL,
  `gender` varchar(32) DEFAULT NULL,
  `birth_date` date DEFAULT NULL,
  `birth_time` time DEFAULT NULL,
  `death_date` date DEFAULT NULL,
  `graveyard_location` varchar(255) DEFAULT NULL,
  `photo_path` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `current_city` varchar(255) DEFAULT NULL,
  `current_country` varchar(255) DEFAULT NULL,
  `family_head_id` bigint(20) UNSIGNED DEFAULT NULL,
  `relation_to_family_head` varchar(100) DEFAULT NULL,
  `marital_status` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `is_living` tinyint(1) NOT NULL DEFAULT 1,
  `is_private` tinyint(1) NOT NULL DEFAULT 0,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `family_members`
--

INSERT INTO `family_members` (`id`, `family_id`, `user_id`, `first_name`, `last_name`, `gender`, `birth_date`, `birth_time`, `death_date`, `graveyard_location`, `photo_path`, `email`, `phone`, `current_city`, `current_country`, `family_head_id`, `relation_to_family_head`, `marital_status`, `notes`, `is_living`, `is_private`, `created_by`, `created_at`, `updated_at`) VALUES
(6, 3, NULL, 'Shaik', 'Nanne Saheb', 'male', '1810-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'unmarried', 'Root member for this family tree.', 0, 0, 1, '2026-04-27 07:15:43', '2026-04-28 11:14:03'),
(22, 3, NULL, 'Shaik Abdul Razzakh', 'Raja Saab', 'male', '1937-01-01', NULL, NULL, 'Yakub Saheb Maszid', 'family-members/t1bpi9Y3CQLdy20RGUxNeLzSpSSlgFc2d5flq0AE.jpg', NULL, NULL, 'Kadapa', 'India', NULL, NULL, 'married', NULL, 0, 0, 1, '2026-04-27 16:13:16', '2026-05-09 19:08:35'),
(25, 3, NULL, 'Shaik', 'Madar Saheb', 'male', '1943-07-01', NULL, '1998-11-08', 'Yakub Saheb Maszid Yard', 'family-members/fnaATSC28ZtcXy7B1FQNm5F6x0g3KfybItRy3ypY.jpg', 'son@nannesab.com', '1234578945', 'Kadapa', 'India', 6, 'son', 'married', NULL, 0, 0, 1, '2026-04-28 11:05:53', '2026-05-14 12:52:16'),
(26, 3, NULL, 'Shaik', 'Amina Bee', 'female', '1815-07-01', NULL, NULL, 'Not Known', NULL, NULL, NULL, 'Kadapa', 'India', 6, 'wife', 'married', NULL, 0, 0, 1, '2026-04-28 13:52:36', '2026-04-28 13:52:36'),
(30, 3, NULL, 'Shaik', 'Yasmeen', 'female', '1978-05-16', NULL, NULL, NULL, 'family-members/pRubn86AW3iVTMwC0T2QP6JwuGVaC4mgOKlSGe3n.jpg', NULL, '9154307445', 'Kadapa', 'India', 25, 'daughter', 'married', NULL, 1, 0, NULL, '2026-04-28 15:00:21', '2026-05-12 00:31:51'),
(31, 3, NULL, 'Shaik', 'Khasim saheb', 'male', '1946-04-28', NULL, '2020-04-28', 'Kadapa', 'family-members/MTCnEGdA5iL7o6Tyebx2h4wVNHKfjDY1baUUFi7Q.jpg', NULL, NULL, 'Kadapa', 'India', 6, 'son', 'married', NULL, 0, 0, NULL, '2026-04-28 15:22:15', '2026-05-12 01:38:40'),
(32, 3, NULL, 'Shaik', 'Dastagir Saheb', 'male', '1948-04-28', NULL, '2006-04-02', 'Kadapa', 'family-members/UE6MwDtXbjvd8TpEV7q2M0budJnkyWlz82wbCfIm.jpg', NULL, NULL, 'Kadapa', 'India', 6, 'son', 'married', NULL, 0, 0, NULL, '2026-04-28 15:56:16', '2026-05-09 19:11:51'),
(34, 3, 15, 'Shaik', 'Rahamatunnisa', NULL, '1981-07-22', NULL, NULL, NULL, 'family-members/9nSpdLFGXZfMQDmBcOLI76H6FfFnwmvZEbLiRVAT.jpg', 'ruhiahmadsayeda@gmail.com', '+919059797297', 'Kadapa', 'India', 25, 'daughter', 'married', 'Approved connection as daughter of Shaik Madar Saheb.', 1, 0, 1, '2026-05-01 14:10:57', '2026-05-12 00:31:33'),
(35, 3, NULL, 'Syed', 'Mushtaq Ahmed', 'male', '1972-10-07', NULL, NULL, NULL, 'family-members/pV0cxT5Wz3knKUE7fTzlaAKJbNUo8SKViNb5AkMV.jpg', NULL, '9849081117', 'Kadapa', 'Indian', 34, 'spouse', 'married', NULL, 1, 0, 15, '2026-05-01 14:22:43', '2026-05-12 00:33:09'),
(36, 3, NULL, 'Syeda', 'Uzma Ameera', NULL, '2007-03-24', NULL, NULL, NULL, 'family-members/e5t50xLGCULD2Odt3TmGRwXGqT5EAtI0KlEy4u9u.jpg', 'ruhiahmadsayeda@gmail.com', '9440917861', 'Kadapa', 'India', 34, 'child', 'unmarried', NULL, 1, 0, 15, '2026-05-01 14:26:14', '2026-05-09 18:18:49'),
(38, 3, NULL, 'Deshmukh', 'Ayub Khan', 'male', '1968-09-10', NULL, NULL, NULL, 'family-members/rNSwseiIJqtenWU3SS6djDXAAdwfl5xtSr68r3ea.jpg', NULL, '9059229774', 'Kadapa', 'India', 30, 'spouse', 'married', NULL, 1, 0, 15, '2026-05-01 14:58:51', '2026-05-12 00:30:17'),
(41, 3, 19, 'Shaik', 'Khaja Mynuddin', 'male', '1982-05-08', '12:30:00', NULL, NULL, 'family-members/EONLL2dUTlLAshUgvLqyjbGilhFOVpsCZi02YlWe.png', 'smartworldcom@gmail.com', '+918121990714', 'Vijayawada', 'India', 25, 'son', 'married', 'Approved connection as son of Shaik Madar Saheb.', 1, 0, 1, '2026-05-01 16:04:06', '2026-05-11 16:02:48'),
(42, 3, 20, 'Syed', 'Nasreen Fathima', 'female', '1985-07-03', NULL, NULL, NULL, 'family-members/KhWddYvR4iyLk4csiou0ivOj04ISDgbwjxXmSg5L.jpg', 'nasreen1057@gmail.com', '9390797705', 'Vijayawada', 'India', 41, 'spouse', 'married', 'Approved connection as spouse of SHAIK KHAJA MYNUDDIN.', 1, 0, 19, '2026-05-01 16:10:34', '2026-05-09 03:59:53'),
(43, 3, NULL, 'Shaik Mujahid', 'Akram', 'male', '2007-05-10', NULL, NULL, NULL, 'family-members/KgTBEnxmTTTXYXcp96pqj1VNBAlEhJmUBXYPNX58.jpg', 'nasreen1057@gmail.com', '7013786131', 'Vijayawada', 'India', 41, 'son', 'unmarried', NULL, 1, 0, 20, '2026-05-01 17:02:29', '2026-05-10 02:27:57'),
(44, 3, NULL, 'Shaik Mahdiya', 'Aqeela', 'female', '2011-06-05', NULL, NULL, NULL, NULL, 'nasreen1057@gmail.com', '8885989774', 'Vijayawada', 'India', 41, 'daughter', 'unmarried', NULL, 1, 0, 20, '2026-05-01 17:04:35', '2026-05-01 17:04:35'),
(46, 3, NULL, 'Syed Nazneen', 'Fathima', 'female', '1989-11-27', NULL, NULL, NULL, NULL, 'nasreen1057@gmail.com', '7893958857', 'Hyderabad', 'India', 41, 'sister', 'married', NULL, 1, 0, 20, '2026-05-01 17:22:11', '2026-05-01 17:22:11'),
(47, 3, NULL, 'Syed Yasmeen', 'Fathima', 'female', '1991-09-22', NULL, NULL, NULL, NULL, 'nasreen1057@gmail.com', '8978616501', 'Hyderabad', 'India', 41, 'sister', 'married', NULL, 1, 0, 20, '2026-05-01 17:26:11', '2026-05-01 17:26:11'),
(49, 3, NULL, 'Syed Anjum', 'Fathima', 'female', '1993-12-14', NULL, NULL, NULL, NULL, 'nasreen1057@gmail.com', '9121703351', 'Kadapa', 'India', 41, 'sister', 'married', NULL, 1, 0, 20, '2026-05-01 17:35:56', '2026-05-01 17:35:56'),
(50, 3, NULL, 'Deshmukh', 'Sameera', 'female', '1975-05-01', NULL, NULL, NULL, NULL, NULL, NULL, 'Kadapa', 'India', 30, 'sister', 'married', NULL, 1, 0, 15, '2026-05-01 17:43:11', '2026-05-01 17:43:11'),
(51, 3, NULL, 'Deshmukh', 'Nadira', 'female', '1980-05-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 30, 'sister', 'married', NULL, 1, 0, 15, '2026-05-01 17:51:25', '2026-05-01 17:51:25'),
(52, 3, 21, 'Shaik', 'Sirajuddin', 'male', '1976-02-06', NULL, NULL, NULL, 'family-members/yRo71597Fq4rI3iJKbQG188iLhGPdRFdLamfGzht.jpg', 'afsiraj@gmail.com', '9848283859', 'Vijayawada', 'India', 25, 'son', 'married', 'Approved connection as son of Shaik Madar Saheb.', 1, 0, 1, '2026-05-03 11:10:15', '2026-05-09 17:54:29'),
(53, 3, NULL, 'Syed', 'Shabana', 'female', '1978-05-01', NULL, NULL, NULL, 'family-members/DVQgEpL0uW9SGqUDwiEGQ7nzwhLWAidm6bXzjxQY.png', NULL, '9849120734', 'Hyderabad', 'India', 34, 'sister', 'married', NULL, 1, 0, 15, '2026-05-03 11:53:46', '2026-05-09 18:24:53'),
(54, 3, NULL, 'Ayesha Siddiqua', 'Shaik', 'female', '1980-04-03', NULL, NULL, NULL, 'family-members/QLlbfJuZKhgPYS3AKvwgpp4xEi6ItLHYlkgT0uFQ.jpg', 'ishasiraj76@gmail.com', '9177390705', 'Vijayawada', 'India', 52, 'spouse', 'married', NULL, 1, 0, 21, '2026-05-03 12:29:36', '2026-05-09 12:16:10'),
(55, 3, NULL, 'Mohammed Ashfaq hussain', 'Shaik', 'male', '2005-02-20', NULL, NULL, NULL, 'family-members/mm5l1geBWTfbH4d5LfnzIl2TJB1X2sg5m8R8nzL7.jpg', 'moshaikBTECH22@ced.alliance.edu.in', '9398210242', 'Vijayawada', 'India', 52, 'son', 'unmarried', NULL, 1, 0, 21, '2026-05-03 12:34:52', '2026-05-09 12:44:08'),
(56, 3, NULL, 'Mohammed Afraz hussain', 'Shaik', 'male', '2006-10-20', NULL, NULL, NULL, 'family-members/m3WW4hZkwwVfaDWnt3Xv5O54ZXzBa6ftr3w3UlPD.jpg', 'shaikmohammedafrazhussain@gmail.com', '8555894652', 'Vijayawada', 'India', 52, 'son', 'unmarried', NULL, 1, 0, 21, '2026-05-03 12:45:21', '2026-05-09 12:41:07'),
(58, 3, NULL, 'Syed', 'Noor', 'male', '1957-05-01', NULL, NULL, NULL, 'family-members/bpdzk7QfNLaNXoi8Bt3PP5NDWVhxzfDrl5o7FZr5.jpg', NULL, NULL, 'Kadapa', 'India', 42, 'father', 'married', NULL, 1, 0, 19, '2026-05-03 16:57:28', '2026-05-10 02:19:06'),
(61, 3, NULL, 'Shaik Chand Begum', NULL, 'female', '1960-07-01', '12:10:00', '2014-04-01', 'Yakub Saheb Maszid', 'family-members/TRtwYql46iT5dAjPLizXERYKc85SF0aDahgp70HJ.jpg', 'moinuxdesigner@gmail.com', '8121990714', 'Kadapa', 'India', 25, 'spouse', 'married', NULL, 0, 0, 1, '2026-05-04 16:57:38', '2026-05-09 17:47:59'),
(63, 3, NULL, 'Shaik Mahaboob Chan', NULL, 'female', '1960-01-01', '01:01:00', '2025-01-20', 'Yakhoob saheb masjid', 'family-members/VE5Cj5sYPy9iGk22sTnCEizJmzGQT2QiFi3N0WnG.jpg', NULL, NULL, 'kadapa', 'india', 32, 'spouse', 'married', NULL, 0, 0, 21, '2026-05-07 17:34:44', '2026-05-09 13:02:29'),
(64, 3, NULL, 'Shaik Mohammed Hussain', NULL, 'male', '1978-01-01', '01:01:00', NULL, NULL, 'family-members/dg8RNI8rnGbeyVK6Q5NNQjT4BPPMg4EkC69ZnCdD.jpg', NULL, '9989839024', 'Kadapa', 'india', 32, 'son', 'married', NULL, 1, 0, 21, '2026-05-07 17:43:05', '2026-05-07 17:43:05'),
(65, 3, NULL, 'Shaik Nasira', NULL, 'female', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Kadapa', 'India', 64, 'spouse', 'married', NULL, 1, 0, 21, '2026-05-07 17:48:14', '2026-05-07 17:48:14'),
(66, 3, NULL, 'Shaik Nasir Hussain', NULL, 'male', NULL, NULL, NULL, NULL, 'family-members/tTekpwrCjT3AWqlit2FQDtOu8nYkIMp3845HD9mf.jpg', 'nasir1402@gmail.com', '8142491580', 'Kadapa', 'India', 32, 'brother', 'married', NULL, 1, 0, 21, '2026-05-07 17:52:47', '2026-05-07 17:52:47'),
(67, 3, NULL, 'Shaik Farukh Hussain', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, '9160778099', 'Kadapa', 'india', 32, 'brother', 'unmarried', NULL, 1, 0, 21, '2026-05-07 17:58:16', '2026-05-07 17:58:16'),
(68, 3, NULL, 'Shaik Hussain Saheb', NULL, 'male', '1941-01-01', NULL, NULL, NULL, NULL, NULL, NULL, 'Kadapa', 'India', 6, 'brother', 'married', NULL, 0, 0, 21, '2026-05-08 14:50:35', '2026-05-09 19:10:00'),
(70, 3, NULL, 'Shaik Pyaari', NULL, 'female', '1950-01-01', NULL, NULL, NULL, 'family-members/I0Gm0tnfOKbsi2BQpHd8df6tvezL74p6QBYmaROg.jpg', NULL, '7702090928', 'kadapa', 'india', 22, 'spouse', 'married', NULL, 1, 0, 21, '2026-05-09 13:50:07', '2026-05-09 18:02:36'),
(71, 3, NULL, 'Shaik Mohammed Ilyas', NULL, 'male', '1977-01-01', NULL, NULL, NULL, 'family-members/f5GnBMFV1wsaCpOH3nFdbJiUip8yS0UtlvDkBlKA.jpg', NULL, '+966 573143856', 'Abha', 'Saudi Arabia', 22, 'son', 'unmarried', NULL, 1, 0, 21, '2026-05-09 13:53:30', '2026-05-09 13:53:30'),
(72, 3, NULL, 'Shaik Gousepeer', NULL, 'male', '1966-04-01', NULL, NULL, NULL, 'family-members/dybyKu4mD7sfJJrRmbaXZpSv3xY2f64Szw7UIiO2.jpg', NULL, NULL, 'Chilamattur', 'India', 22, 'son', 'married', NULL, 1, 0, 21, '2026-05-09 14:00:47', '2026-05-09 14:00:47'),
(74, 3, NULL, 'Shaik Taharun', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/ZCiEDWL6uKzgC3htr1eAEqabPFERdbwHTItCWpdY.jpg', NULL, '9989387827', 'Kadapa', 'India', 22, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-09 14:04:29', '2026-05-13 14:56:26'),
(75, 3, NULL, 'Shaik Begum', NULL, 'female', NULL, NULL, NULL, NULL, NULL, NULL, '7702090928', 'Kadapa', 'India', 22, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-09 14:07:29', '2026-05-09 14:07:29'),
(76, 3, NULL, 'Shaik Tajuddin', NULL, 'male', NULL, NULL, '1990-12-10', 'Yakub Saheb Masjid', 'family-members/EPVZV5IPc6RPPoZ2PlphTBFbGajIk2R0MoXzudga.png', NULL, NULL, 'Vijayawada', 'India', 25, 'son', 'unmarried', NULL, 0, 0, 21, '2026-05-09 14:32:00', '2026-05-09 17:52:09'),
(77, 3, NULL, 'Patan D Adil Khan', NULL, 'male', NULL, NULL, NULL, NULL, 'family-members/wkmnLcmjgNEnHMtirWs1q1qjLKwR8Um34zxV5tUk.jpg', 'adil2212004@gmail.com', '8639943613', 'Nellore', 'India', 30, 'son', 'unmarried', NULL, 1, 0, 21, '2026-05-09 14:59:30', '2026-05-09 14:59:30'),
(78, 3, NULL, 'Patan D Fazil Khan', NULL, 'male', NULL, NULL, NULL, NULL, 'family-members/hXw7q8opRqgJWzhdXuo01LBwYK3EDuj8IpguWChq.jpg', NULL, '9347291766', 'Kadapa', 'India', 30, 'son', 'unmarried', NULL, 1, 0, 21, '2026-05-09 18:00:38', '2026-05-09 18:00:38'),
(79, 3, NULL, 'Syed Madeeha Chasheen', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/leBeLa1oEdy1KD2QDoQE3asuMGXF6LIQVuLMQNLp.jpg', NULL, NULL, NULL, NULL, 34, 'daughter', 'unmarried', NULL, 1, 0, 21, '2026-05-09 18:07:39', '2026-05-09 18:07:39'),
(80, 3, NULL, 'Shaik Shamshad Begum', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/NqR61s2wrpZNLFrTEdZRnyR3Z3IflGgLdITOwVxm.jpg', NULL, '8099905362', 'Nellore', 'India', 25, 'sister_in_law', 'married', NULL, 1, 0, 21, '2026-05-09 18:44:37', '2026-05-09 18:44:37'),
(81, 3, NULL, 'Shaik zahra bee', NULL, 'female', '1939-01-01', NULL, '2012-01-04', 'Chinna chowk', NULL, NULL, NULL, 'Chinna chowk, Kadapa', 'India', 6, 'sister', 'married', NULL, 0, 0, 21, '2026-05-09 18:55:19', '2026-05-09 19:09:13'),
(82, 3, NULL, 'Syed Osman Saheb', NULL, 'male', NULL, NULL, '2012-01-01', 'Chinna chowk', NULL, NULL, NULL, 'Chintakommadinne, Kadapa', 'India', 81, 'spouse', 'married', NULL, 0, 0, 21, '2026-05-09 18:58:14', '2026-05-09 18:58:14'),
(83, 3, NULL, 'Syed Baba Fakruddin', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Chinna chowk, kadapa', 'India', 81, 'son', 'married', NULL, 1, 0, 21, '2026-05-09 19:00:55', '2026-05-09 19:00:55'),
(84, 3, NULL, 'Syed Aleem', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, '9346689593', 'Chinna chowk, Kadapa', 'India', 81, 'son', 'married', NULL, 1, 0, 21, '2026-05-09 19:02:25', '2026-05-09 19:02:25'),
(85, 3, NULL, 'Syed Peerullah', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Chinna chowk, Kadapa', 'India', 81, 'son', 'married', NULL, 1, 0, 21, '2026-05-09 19:03:28', '2026-05-09 19:03:28'),
(86, 3, NULL, 'Shaik Maalan bee', NULL, 'female', '1942-01-01', NULL, '2010-01-01', 'chinna chowk', 'family-members/uvcGLtH3YtoPynBAb4iRvIRa1fubiyXsf8kVnYuM.jpg', NULL, NULL, 'chinna chowk, kadapa', 'india', 6, 'sister', 'married', NULL, 0, 0, 21, '2026-05-09 19:14:47', '2026-05-13 02:58:11'),
(87, 3, NULL, 'Shaik Yakhub sab', NULL, 'male', '1935-01-01', NULL, '2002-01-01', 'Vonthapalli near siiddhavatam', 'family-members/t6YA8aM1aUGykXux3Fby5L2eQyuYhaOqvHG1Y30y.jpg', NULL, NULL, 'Chinna chowk, Kadapa', 'India', 86, 'spouse', 'married', NULL, 0, 0, 21, '2026-05-09 19:17:18', '2026-05-13 02:58:21'),
(88, 3, NULL, 'Shaik Rafi', NULL, 'male', '1972-01-01', NULL, '2015-01-01', 'Not known due to AIDS', 'family-members/WiOl8b9Qae4HLjXoatz8n7NKViXzbikzqcrDwflW.jpg', NULL, NULL, 'Chinna chowk', 'India', 86, 'son', 'unmarried', NULL, 0, 0, 21, '2026-05-09 19:26:24', '2026-05-09 19:26:24'),
(89, 3, NULL, 'Shaik Kareemullah', NULL, 'male', '1957-01-01', NULL, '2002-01-01', 'Yakum saheb masjid', NULL, NULL, NULL, 'Matti peddapuli, Kadapa', 'India', 80, 'spouse', 'married', NULL, 0, 0, 21, '2026-05-09 19:42:56', '2026-05-09 19:42:56'),
(90, 3, NULL, 'Shaik Gouse Basha', NULL, 'male', '1960-01-01', NULL, NULL, NULL, 'family-members/kW7IjDMLl3h4Z2KmCjsbgErAcOFjk5e2g71hNwFm.jpg', NULL, '8309396598', 'Agadi, Kadapa', 'India', 25, 'brother_in_law', 'married', NULL, 1, 0, 21, '2026-05-09 19:45:27', '2026-05-09 19:45:27'),
(91, 3, NULL, 'Shaik Rehana', NULL, 'female', '1987-01-01', NULL, NULL, NULL, 'family-members/Rsh9ptG0GfgIvtl5qFFYkhJMLdLswzz6upsxaCBx.png', NULL, '8374751084', 'New Market, Kadapa', 'India', 32, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-09 19:51:44', '2026-05-13 15:30:01'),
(92, 3, NULL, 'Syed Hussain Bee', NULL, 'female', '1964-01-01', NULL, '2024-01-01', 'Due to Sugar and Madfulness', NULL, NULL, NULL, 'Sub-Jail, Kadapa', 'India', 81, 'daughter', 'married', NULL, 0, 0, 21, '2026-05-09 19:59:52', '2026-05-09 19:59:52'),
(93, 3, NULL, 'Shaik Magbool', NULL, 'male', '1960-01-01', NULL, NULL, NULL, NULL, NULL, NULL, 'Sub-Jail, Kadapa', 'India', 92, 'spouse', 'married', NULL, 1, 0, 21, '2026-05-09 20:02:06', '2026-05-09 20:02:06'),
(95, 3, NULL, 'Shaik. Fatimun', NULL, 'female', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'sub-jail, kadapa', 'India', 92, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-09 20:15:03', '2026-05-09 20:15:03'),
(96, 3, NULL, 'Shaik Hayath', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Sub-jail, kadapa', 'India', 95, 'spouse', 'married', NULL, 1, 0, 21, '2026-05-09 20:16:32', '2026-05-09 20:16:32'),
(97, 3, NULL, 'Shaik Naazneen', NULL, 'female', '1977-01-01', NULL, NULL, NULL, NULL, NULL, '8919103165', 'Chinna chowk, Kadapa', 'India', 86, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-09 20:20:51', '2026-05-09 20:20:51'),
(98, 3, NULL, 'Shaik Jaaved', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Kadapa', 'India', 49, 'spouse', 'married', NULL, 1, 0, 19, '2026-05-10 02:21:04', '2026-05-10 02:21:04'),
(99, 3, NULL, 'Syed Dilshad Begam', NULL, 'female', '1960-05-10', NULL, NULL, NULL, 'family-members/cvRGdIOgEVxH4lyBFpldbDOSBN8U3X9kMIBiauaf.jpg', NULL, NULL, 'Kadapa', 'India', 58, 'spouse', 'married', NULL, 1, 0, 19, '2026-05-10 02:24:25', '2026-05-10 02:24:25'),
(100, 3, NULL, 'Shaik Baba saheb', NULL, 'male', '1920-05-10', NULL, NULL, 'Nadi kheda, kadapa', NULL, NULL, NULL, 'Nadi kheda, kadapa', 'India', NULL, 'brother', 'married', NULL, 0, 0, 21, '2026-05-10 06:32:18', '2026-05-10 12:27:24'),
(101, 3, NULL, 'Shaik Rahmtu saheb', NULL, 'male', NULL, NULL, NULL, 'Yakubsab masjid', NULL, NULL, NULL, 'Nadi kheda', 'India', NULL, 'brother', 'married', NULL, 0, 0, 21, '2026-05-10 06:34:05', '2026-05-10 17:34:12'),
(102, 3, NULL, 'Shaik Madar saab', NULL, 'male', NULL, NULL, NULL, 'Yakub sab masjid', NULL, NULL, NULL, 'Nadi kheda, kadapa', 'India', NULL, 'brother', 'married', NULL, 0, 0, 21, '2026-05-10 06:35:56', '2026-05-10 17:32:59'),
(103, 3, NULL, 'Shaik Fatimun', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/uBIJXLZ0sVE68SzamNpJOTJHeXILN6q3Z29eYMc4.jpg', NULL, '90001 78016', 'Kadapa', 'India', 22, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-10 13:16:42', '2026-05-13 08:15:10'),
(104, 3, NULL, 'Shaik Buden Saheb', NULL, 'male', NULL, NULL, '1920-05-10', 'Nadikheda', NULL, NULL, NULL, 'Nadi kheda', 'India', 6, 'father', 'married', NULL, 0, 0, 21, '2026-05-10 17:29:53', '2026-05-10 17:29:53'),
(105, 3, NULL, 'Syed Buden saheb', NULL, 'male', NULL, NULL, '1910-05-11', NULL, NULL, NULL, NULL, 'Nadi kheda', 'India', 82, 'father', 'married', NULL, 0, 0, 21, '2026-05-11 15:55:35', '2026-05-11 15:55:35'),
(106, 3, NULL, 'Shaik Khajamiah', NULL, 'male', NULL, NULL, NULL, 'Maddu khan masjid', NULL, NULL, NULL, 'Kadapa', 'India', 61, 'father', 'married', NULL, 0, 0, 21, '2026-05-11 17:19:14', '2026-05-11 17:19:14'),
(107, 3, NULL, 'Shaik Zainab Bee', NULL, 'female', NULL, NULL, NULL, 'Maddu khan masjid', NULL, NULL, NULL, 'Kadapa', 'India', 61, 'mother', 'married', NULL, 0, 0, 21, '2026-05-11 17:21:20', '2026-05-11 17:21:20'),
(108, 3, NULL, 'Shaik shabana', NULL, 'female', NULL, NULL, NULL, NULL, NULL, NULL, '+91 90307 41602', 'Nellore', 'India', 80, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-12 02:45:47', '2026-05-12 02:45:47'),
(109, 3, NULL, 'Shaik Reehana', NULL, 'female', NULL, NULL, NULL, NULL, NULL, NULL, '91540 04937', 'Kadapa', 'India', 80, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-12 02:50:42', '2026-05-12 02:50:42'),
(110, 3, NULL, 'Shaik Chotima', NULL, 'female', NULL, NULL, NULL, NULL, NULL, NULL, '81212 00875', 'Kadapa', 'India', 80, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-12 02:53:12', '2026-05-12 02:53:12'),
(111, 3, NULL, 'Shaik Ali', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, '77025 03508', 'Kadapa', 'India', 80, 'son', 'married', NULL, 1, 0, 21, '2026-05-12 02:54:30', '2026-05-12 02:54:30'),
(112, 3, NULL, 'Shaik Habeeb', NULL, 'female', NULL, NULL, NULL, NULL, NULL, NULL, '+91 8309-396598', 'Kadapa', 'India', 90, 'spouse', 'married', NULL, 1, 0, 21, '2026-05-12 02:56:48', '2026-05-12 02:56:48'),
(113, 3, NULL, 'Shaik Khairunnisa', NULL, 'female', '1961-05-12', NULL, '1982-05-12', 'Yakhubsab masjid', NULL, NULL, NULL, 'Kadapa', 'India', 68, 'spouse', 'married', NULL, 0, 0, 21, '2026-05-12 15:38:35', '2026-05-12 15:38:35'),
(114, 3, NULL, 'Shaik Abdul khader jeelan', NULL, 'male', NULL, NULL, '2024-05-12', 'Yakhub sab Masjd', 'family-members/dx3ksiEWbIuAYhKLNTDKDDeGO71RXgxKBoRqQHlR.jpg', NULL, NULL, 'Kurnool', 'India', 68, 'son', 'married', NULL, 0, 0, 21, '2026-05-12 16:02:33', '2026-05-13 17:27:32'),
(115, 3, NULL, 'Shaik Mahabunnisa', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/f456YnrjoGhZD2zJxKpfTdTnlQXgu0nDPXl4TWAj.jpg', NULL, NULL, 'Mantapampale', 'India', 68, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-12 16:04:19', '2026-05-14 14:12:42'),
(116, 3, NULL, 'Shaik Munni', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/hCnNAmsnDUPb77ejWki8QCUwqXJYGlxlSmKBrwv8.jpg', NULL, NULL, 'Chagalmarri', 'India', 68, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-12 16:05:21', '2026-05-14 13:33:28'),
(117, 3, NULL, 'Shaik Iqbal Hussain', NULL, 'male', NULL, NULL, NULL, NULL, 'family-members/L9J7At6zA1yxp35dcGnYpR8GvUrDUVyEcN6O67qE.jpg', NULL, '+91 90305 45487', 'Kadapa', 'India', 68, 'son', 'married', NULL, 1, 0, 21, '2026-05-12 16:08:00', '2026-05-13 17:32:10'),
(118, 3, NULL, 'Shaik Sirajun', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/kyVBEtRd1GF5bALGNVwJYHUNsnHRtBnnFjo2Ljl9.jpg', NULL, '96402 54080', 'Kagital penta, Kadapa', 'India', 68, 'daughter', 'married', NULL, 1, 0, 21, '2026-05-12 16:09:36', '2026-05-14 13:37:01'),
(119, 3, NULL, 'Shaik zeenat', NULL, 'female', NULL, NULL, NULL, 'Yakhub sab masjid', 'family-members/GfQQ994FsoxQ4UOP9CZVgzrzC9iiiNMKmFiQudMd.jpg', NULL, NULL, 'Kadapa', 'India', 68, 'daughter', 'married', NULL, 0, 0, 21, '2026-05-12 16:10:57', '2026-05-14 14:10:13'),
(120, 3, NULL, 'Shaik Amreen', NULL, 'female', NULL, NULL, NULL, NULL, NULL, NULL, '9030545487', 'Kadapa', 'India', 117, 'spouse', 'married', NULL, 1, 0, 21, '2026-05-12 17:09:51', '2026-05-12 17:09:51'),
(121, 3, NULL, 'Shaik Jaffer', NULL, 'male', NULL, NULL, NULL, NULL, 'family-members/gg4oLwgKmQ74gGPNulz6nmxucRzlhBNhHwUPwdz4.jpg', NULL, NULL, 'Kadapa', 'India', 103, 'spouse', 'married', NULL, 1, 0, 21, '2026-05-12 17:13:11', '2026-05-13 08:15:47'),
(122, 3, NULL, 'Shaik Basheer', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, '+96550723327', NULL, 'Kuwait', 75, 'spouse', 'married', NULL, 1, 0, 21, '2026-05-12 17:16:03', '2026-05-12 17:16:03'),
(124, 3, NULL, 'Shaik Aqtar', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/GzWDbMB29sTH8D1CE2X2lYQgCq5SMVL4JCzLL4rT.jpg', NULL, NULL, 'Kadapa', 'India', 31, 'spouse', 'married', NULL, 1, 0, 15, '2026-05-14 10:34:17', '2026-05-14 10:34:17'),
(125, 3, NULL, 'SHIAK IMTIYAAZ', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Kadapa', 'India', 31, 'son', 'married', NULL, 1, 0, 15, '2026-05-14 10:36:22', '2026-05-14 10:36:22'),
(126, 3, NULL, 'Shaik Fayaaz', NULL, 'male', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Kadapa', 'India', 31, 'son', 'married', NULL, 1, 0, 15, '2026-05-14 10:38:09', '2026-05-14 10:38:09'),
(127, 3, NULL, 'Nusrat', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/TYzK5KlQwp98JWwpN3x2V5Eipmo754fqermugGJb.png', NULL, NULL, 'Kadapa', 'India', 31, 'daughter', 'married', NULL, 1, 0, 15, '2026-05-14 10:40:08', '2026-05-14 10:40:08'),
(128, 3, NULL, 'Shevaar', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/J5Zli4UTd7idmfBq18VKhl1v5BtvSEuW2sgGW9Ox.jpg', NULL, '9182699408', 'Kadapa', 'India', 31, 'daughter', 'married', NULL, 1, 0, 15, '2026-05-14 10:48:01', '2026-05-14 10:48:01'),
(129, 3, NULL, 'Tabasum', NULL, 'female', NULL, NULL, NULL, NULL, 'family-members/vQbbK9ZyPKbCFXPEVGICCpcxWXz87WWC1WS4hEjA.png', NULL, '+918897920780', 'Kadapa', 'India', 31, 'daughter', 'married', NULL, 1, 0, 15, '2026-05-14 10:49:23', '2026-05-14 10:49:23');

-- --------------------------------------------------------

--
-- Table structure for table `family_relationships`
--

CREATE TABLE `family_relationships` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `family_id` bigint(20) UNSIGNED NOT NULL,
  `from_member_id` bigint(20) UNSIGNED NOT NULL,
  `to_member_id` bigint(20) UNSIGNED NOT NULL,
  `relationship_type` varchar(32) NOT NULL,
  `notes` text DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `family_relationships`
--

INSERT INTO `family_relationships` (`id`, `family_id`, `from_member_id`, `to_member_id`, `relationship_type`, `notes`, `created_by`, `created_at`, `updated_at`) VALUES
(23, 3, 6, 22, 'parent', 'Added as son to family head Shaik Nanne Saheb.', 1, '2026-04-27 16:13:16', '2026-04-27 16:13:16'),
(26, 3, 6, 25, 'parent', 'Added as son to family head Shaik Nanne Saheb.', 1, '2026-04-28 11:05:53', '2026-04-28 11:05:53'),
(27, 3, 6, 26, 'spouse', 'Added as wife to family head Shaik Nanne Saheb.', 1, '2026-04-28 13:52:36', '2026-04-28 13:52:36'),
(31, 3, 25, 30, 'parent', 'Added as daughter to family head Shaik Madar Saheb.', NULL, '2026-04-28 15:00:21', '2026-04-28 15:00:21'),
(32, 3, 6, 31, 'parent', 'Added as son to family head Shaik Nanne Saheb.', NULL, '2026-04-28 15:22:15', '2026-04-28 15:22:15'),
(33, 3, 6, 32, 'parent', 'Added as son to family head Shaik Nanne Saheb.', NULL, '2026-04-28 15:56:16', '2026-04-28 15:56:16'),
(35, 3, 25, 34, 'parent', 'Approved user claim: Ruhi is daughter of Shaik Madar Saheb.', 1, '2026-05-01 14:10:57', '2026-05-01 14:10:57'),
(36, 3, 34, 35, 'spouse', 'Added as spouse to Ruhi Ahmad.', 15, '2026-05-01 14:22:43', '2026-05-01 14:22:43'),
(37, 3, 34, 36, 'parent', 'Added as child in household Ruhi Ahmad & Syed Mushtaq Ahmed Family.', 15, '2026-05-01 14:26:14', '2026-05-01 14:26:14'),
(38, 3, 35, 36, 'parent', 'Added as child in household Ruhi Ahmad & Syed Mushtaq Ahmed Family.', 15, '2026-05-01 14:26:14', '2026-05-01 14:26:14'),
(40, 3, 30, 38, 'spouse', 'Added as spouse to Shaik Yasmeen.', 15, '2026-05-01 14:58:51', '2026-05-01 14:58:51'),
(43, 3, 25, 41, 'parent', 'Approved user claim: SHAIK is son of Shaik Madar Saheb.', 1, '2026-05-01 16:04:06', '2026-05-01 16:04:06'),
(44, 3, 41, 42, 'spouse', 'Approved user claim: Syed is spouse of SHAIK KHAJA MYNUDDIN.', 1, '2026-05-01 16:10:34', '2026-05-01 16:57:38'),
(45, 3, 41, 43, 'parent', 'Added as child in household SHAIK KHAJA MYNUDDIN & Syed Nasreen Fathima Family.', 20, '2026-05-01 17:02:29', '2026-05-01 17:02:29'),
(46, 3, 42, 43, 'parent', 'Added as child in household SHAIK KHAJA MYNUDDIN & Syed Nasreen Fathima Family.', 20, '2026-05-01 17:02:29', '2026-05-01 17:02:29'),
(47, 3, 41, 44, 'parent', 'Added as child in household SHAIK KHAJA MYNUDDIN & Syed Nasreen Fathima Family.', 20, '2026-05-01 17:04:35', '2026-05-01 17:04:35'),
(48, 3, 42, 44, 'parent', 'Added as child in household SHAIK KHAJA MYNUDDIN & Syed Nasreen Fathima Family.', 20, '2026-05-01 17:04:35', '2026-05-01 17:04:35'),
(50, 3, 42, 46, 'sibling', 'Added as sibling to Syed Nasreen Fathima.', 20, '2026-05-01 17:22:11', '2026-05-01 17:22:11'),
(51, 3, 41, 46, 'parent', 'Added as sibling in Syed Nasreen Fathima family.', 20, '2026-05-01 17:22:11', '2026-05-01 17:22:11'),
(52, 3, 42, 47, 'sibling', 'Added as sibling to Syed Nasreen Fathima.', 20, '2026-05-01 17:26:11', '2026-05-01 17:26:11'),
(53, 3, 41, 47, 'parent', 'Added as sibling in Syed Nasreen Fathima family.', 20, '2026-05-01 17:26:11', '2026-05-01 17:26:11'),
(55, 3, 42, 49, 'sibling', 'Added as sibling to Syed Nasreen Fathima.', 20, '2026-05-01 17:35:56', '2026-05-01 17:35:56'),
(56, 3, 41, 49, 'parent', 'Added as sibling in Syed Nasreen Fathima family.', 20, '2026-05-01 17:35:56', '2026-05-01 17:35:56'),
(57, 3, 38, 50, 'sibling', 'Added as sibling to Deshmukh Ayub Khan.', 15, '2026-05-01 17:43:11', '2026-05-01 17:43:11'),
(58, 3, 30, 50, 'parent', 'Added as sibling in Deshmukh Ayub Khan family.', 15, '2026-05-01 17:43:11', '2026-05-01 17:43:11'),
(59, 3, 50, 51, 'sibling', 'Added as sibling to Deshmukh Sameera.', 15, '2026-05-01 17:51:25', '2026-05-01 17:51:25'),
(60, 3, 30, 51, 'parent', 'Added as sibling in Deshmukh Sameera family.', 15, '2026-05-01 17:51:25', '2026-05-01 17:51:25'),
(61, 3, 25, 52, 'parent', 'Approved user claim: Sirajuddin is son of Shaik Madar Saheb.', 1, '2026-05-03 11:10:15', '2026-05-03 11:10:15'),
(62, 3, 35, 53, 'sibling', 'Added as sibling to Syed Mushtaq Ahmed.', 15, '2026-05-03 11:53:46', '2026-05-03 11:53:46'),
(63, 3, 34, 53, 'parent', 'Added as sibling in Syed Mushtaq Ahmed family.', 15, '2026-05-03 11:53:46', '2026-05-03 11:53:46'),
(64, 3, 52, 54, 'spouse', 'Added as spouse to Sirajuddin.', 21, '2026-05-03 12:29:36', '2026-05-03 12:29:36'),
(65, 3, 52, 55, 'parent', 'Added as child in household Sirajuddin & Ayesha Siddiqua Shaik Family.', 21, '2026-05-03 12:34:52', '2026-05-03 12:34:52'),
(66, 3, 54, 55, 'parent', 'Added as child in household Sirajuddin & Ayesha Siddiqua Shaik Family.', 21, '2026-05-03 12:34:52', '2026-05-03 12:34:52'),
(67, 3, 52, 56, 'parent', 'Added as child in household Sirajuddin & Ayesha Siddiqua Shaik Family.', 21, '2026-05-03 12:45:21', '2026-05-03 12:45:21'),
(68, 3, 54, 56, 'parent', 'Added as child in household Sirajuddin & Ayesha Siddiqua Shaik Family.', 21, '2026-05-03 12:45:21', '2026-05-03 12:45:21'),
(71, 3, 58, 42, 'parent', 'Added as parent to Syed Nasreen Fathima.', 19, '2026-05-03 16:57:28', '2026-05-03 16:57:28'),
(75, 3, 25, 61, 'spouse', 'Added as spouse to Shaik Madar Saheb.', 1, '2026-05-04 16:57:38', '2026-05-04 16:57:38'),
(78, 3, 32, 63, 'spouse', 'Added as spouse to Shaik Dastagir Saheb.', 21, '2026-05-07 17:34:44', '2026-05-07 17:34:44'),
(79, 3, 32, 64, 'parent', 'Added as child in household Shaik Dastagir Saheb & Shaik Mahaboob Chan Family.', 21, '2026-05-07 17:43:05', '2026-05-07 17:43:05'),
(80, 3, 63, 64, 'parent', 'Added as child in household Shaik Dastagir Saheb & Shaik Mahaboob Chan Family.', 21, '2026-05-07 17:43:05', '2026-05-07 17:43:05'),
(81, 3, 64, 65, 'spouse', 'Added as spouse to Shaik Mohammed Hussain.', 21, '2026-05-07 17:48:14', '2026-05-07 17:48:14'),
(82, 3, 64, 66, 'sibling', 'Added as sibling to Shaik Mohammed Hussain.', 21, '2026-05-07 17:52:47', '2026-05-07 17:52:47'),
(83, 3, 32, 66, 'parent', 'Added as sibling in Shaik Mohammed Hussain family.', 21, '2026-05-07 17:52:47', '2026-05-07 17:52:47'),
(84, 3, 63, 66, 'parent', 'Added as sibling in Shaik Mohammed Hussain family.', 21, '2026-05-07 17:52:47', '2026-05-07 17:52:47'),
(85, 3, 64, 67, 'sibling', 'Added as sibling to Shaik Mohammed Hussain.', 21, '2026-05-07 17:58:16', '2026-05-07 17:58:16'),
(86, 3, 32, 67, 'parent', 'Added as sibling in Shaik Mohammed Hussain family.', 21, '2026-05-07 17:58:16', '2026-05-07 17:58:16'),
(87, 3, 63, 67, 'parent', 'Added as sibling in Shaik Mohammed Hussain family.', 21, '2026-05-07 17:58:16', '2026-05-07 17:58:16'),
(88, 3, 25, 68, 'sibling', 'Added as sibling to Shaik Madar Saheb.', 21, '2026-05-08 14:50:35', '2026-05-08 14:50:35'),
(89, 3, 6, 68, 'parent', 'Added as sibling in Shaik Madar Saheb family.', 21, '2026-05-08 14:50:35', '2026-05-08 14:50:35'),
(91, 3, 22, 70, 'spouse', 'Added as spouse to Shaik Abdul Razzakh Raja Saab.', 21, '2026-05-09 13:50:07', '2026-05-09 13:50:07'),
(92, 3, 22, 71, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-09 13:53:30', '2026-05-09 13:53:30'),
(93, 3, 70, 71, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-09 13:53:30', '2026-05-09 13:53:30'),
(94, 3, 22, 72, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-09 14:00:47', '2026-05-09 14:00:47'),
(95, 3, 70, 72, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-09 14:00:47', '2026-05-09 14:00:47'),
(98, 3, 22, 74, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-09 14:04:29', '2026-05-09 14:04:29'),
(99, 3, 70, 74, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-09 14:04:29', '2026-05-09 14:04:29'),
(100, 3, 22, 75, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-09 14:07:29', '2026-05-09 14:07:29'),
(101, 3, 70, 75, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-09 14:07:29', '2026-05-09 14:07:29'),
(102, 3, 25, 76, 'parent', 'Added as child in household Shaik Madar Saheb & Shaik Chand Begum Family.', 21, '2026-05-09 14:32:00', '2026-05-09 14:32:00'),
(103, 3, 30, 77, 'parent', 'Added as child in household Shaik Yasmeen & Deshmukh Ayub Khan Family.', 21, '2026-05-09 14:59:30', '2026-05-09 14:59:30'),
(104, 3, 38, 77, 'parent', 'Added as child in household Shaik Yasmeen & Deshmukh Ayub Khan Family.', 21, '2026-05-09 14:59:30', '2026-05-09 14:59:30'),
(105, 3, 30, 78, 'parent', 'Added as child in household Shaik Yasmeen & Deshmukh Ayub Khan Family.', 21, '2026-05-09 18:00:38', '2026-05-09 18:00:38'),
(106, 3, 38, 78, 'parent', 'Added as child in household Shaik Yasmeen & Deshmukh Ayub Khan Family.', 21, '2026-05-09 18:00:38', '2026-05-09 18:00:38'),
(107, 3, 34, 79, 'parent', 'Added as child in household Ruhi Ahmad & Syed Mushtaq Ahmed Family.', 21, '2026-05-09 18:07:39', '2026-05-09 18:07:39'),
(108, 3, 35, 79, 'parent', 'Added as child in household Ruhi Ahmad & Syed Mushtaq Ahmed Family.', 21, '2026-05-09 18:07:39', '2026-05-09 18:07:39'),
(109, 3, 61, 80, 'sibling', 'Added as sibling to Shaik Chand Begum.', 21, '2026-05-09 18:44:37', '2026-05-09 18:44:37'),
(110, 3, 25, 81, 'sibling', 'Added as sibling to Shaik Madar Saheb.', 21, '2026-05-09 18:55:19', '2026-05-09 18:55:19'),
(111, 3, 6, 81, 'parent', 'Added as sibling in Shaik Madar Saheb family.', 21, '2026-05-09 18:55:19', '2026-05-09 18:55:19'),
(112, 3, 81, 82, 'spouse', 'Added as spouse to Shaik zahra bee.', 21, '2026-05-09 18:58:14', '2026-05-09 18:58:14'),
(113, 3, 81, 83, 'parent', 'Added as child in household Shaik zahra bee & Syed Osman Saheb Family.', 21, '2026-05-09 19:00:55', '2026-05-09 19:00:55'),
(114, 3, 82, 83, 'parent', 'Added as child in household Shaik zahra bee & Syed Osman Saheb Family.', 21, '2026-05-09 19:00:55', '2026-05-09 19:00:55'),
(115, 3, 81, 84, 'parent', 'Added as child in household Shaik zahra bee & Syed Osman Saheb Family.', 21, '2026-05-09 19:02:25', '2026-05-09 19:02:25'),
(116, 3, 82, 84, 'parent', 'Added as child in household Shaik zahra bee & Syed Osman Saheb Family.', 21, '2026-05-09 19:02:25', '2026-05-09 19:02:25'),
(117, 3, 81, 85, 'parent', 'Added as child in household Shaik zahra bee & Syed Osman Saheb Family.', 21, '2026-05-09 19:03:28', '2026-05-09 19:03:28'),
(118, 3, 82, 85, 'parent', 'Added as child in household Shaik zahra bee & Syed Osman Saheb Family.', 21, '2026-05-09 19:03:28', '2026-05-09 19:03:28'),
(119, 3, 32, 86, 'sibling', 'Added as sibling to Shaik Dastagir Saheb.', 21, '2026-05-09 19:14:47', '2026-05-09 19:14:47'),
(120, 3, 6, 86, 'parent', 'Added as sibling in Shaik Dastagir Saheb family.', 21, '2026-05-09 19:14:47', '2026-05-09 19:14:47'),
(121, 3, 86, 87, 'spouse', 'Added as spouse to Shaik Maalan bee.', 21, '2026-05-09 19:17:18', '2026-05-09 19:17:18'),
(122, 3, 86, 88, 'parent', 'Added as child in household Shaik Maalan bee & Shaik Yakhub sab Family.', 21, '2026-05-09 19:26:24', '2026-05-09 19:26:24'),
(123, 3, 87, 88, 'parent', 'Added as child in household Shaik Maalan bee & Shaik Yakhub sab Family.', 21, '2026-05-09 19:26:24', '2026-05-09 19:26:24'),
(124, 3, 80, 89, 'spouse', 'Added as spouse to Shaik Shamshad Begum.', 21, '2026-05-09 19:42:56', '2026-05-09 19:42:56'),
(125, 3, 61, 90, 'sibling', 'Added as sibling to Shaik Chand Begum.', 21, '2026-05-09 19:45:27', '2026-05-09 19:45:27'),
(126, 3, 32, 91, 'parent', 'Added as child in household Shaik Dastagir Saheb & Shaik Mahaboob Chan Family.', 21, '2026-05-09 19:51:44', '2026-05-09 19:51:44'),
(127, 3, 63, 91, 'parent', 'Added as child in household Shaik Dastagir Saheb & Shaik Mahaboob Chan Family.', 21, '2026-05-09 19:51:44', '2026-05-09 19:51:44'),
(128, 3, 81, 92, 'parent', 'Added as child in household Shaik zahra bee & Syed Osman Saheb Family.', 21, '2026-05-09 19:59:52', '2026-05-09 19:59:52'),
(129, 3, 82, 92, 'parent', 'Added as child in household Shaik zahra bee & Syed Osman Saheb Family.', 21, '2026-05-09 19:59:52', '2026-05-09 19:59:52'),
(130, 3, 92, 93, 'spouse', 'Added as spouse to Syed Hussain Bee.', 21, '2026-05-09 20:02:06', '2026-05-09 20:02:06'),
(134, 3, 92, 95, 'parent', 'Added as child in household Syed Hussain Bee & Shaik Magbool Family.', 21, '2026-05-09 20:15:03', '2026-05-09 20:15:03'),
(135, 3, 93, 95, 'parent', 'Added as child in household Syed Hussain Bee & Shaik Magbool Family.', 21, '2026-05-09 20:15:03', '2026-05-09 20:15:03'),
(136, 3, 95, 96, 'spouse', 'Added as spouse to Shaik. Fatimun.', 21, '2026-05-09 20:16:32', '2026-05-09 20:16:32'),
(137, 3, 86, 97, 'parent', 'Added as child in household Shaik Maalan bee & Shaik Yakhub sab Family.', 21, '2026-05-09 20:20:51', '2026-05-09 20:20:51'),
(138, 3, 87, 97, 'parent', 'Added as child in household Shaik Maalan bee & Shaik Yakhub sab Family.', 21, '2026-05-09 20:20:51', '2026-05-09 20:20:51'),
(139, 3, 49, 98, 'spouse', 'Added as spouse to Syed Anjum Fathima.', 19, '2026-05-10 02:21:04', '2026-05-10 02:21:04'),
(140, 3, 58, 99, 'spouse', 'Added as spouse to Syed Noor.', 19, '2026-05-10 02:24:25', '2026-05-10 02:24:25'),
(141, 3, 6, 100, 'sibling', 'Added as sibling to Shaik Nanne Saheb.', 21, '2026-05-10 06:32:18', '2026-05-10 06:32:18'),
(142, 3, 6, 101, 'sibling', 'Added as sibling to Shaik Nanne Saheb.', 21, '2026-05-10 06:34:05', '2026-05-10 06:34:05'),
(143, 3, 6, 102, 'sibling', 'Added as sibling to Shaik Nanne Saheb.', 21, '2026-05-10 06:35:56', '2026-05-10 06:35:56'),
(144, 3, 22, 103, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-10 13:16:42', '2026-05-10 13:16:42'),
(145, 3, 70, 103, 'parent', 'Added as child in household Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family.', 21, '2026-05-10 13:16:42', '2026-05-10 13:16:42'),
(146, 3, 104, 6, 'parent', 'Added as parent to Shaik Nanne Saheb.', 21, '2026-05-10 17:29:53', '2026-05-10 17:29:53'),
(147, 3, 105, 82, 'parent', 'Added as parent to Syed Osman Saheb.', 21, '2026-05-11 15:55:35', '2026-05-11 15:55:35'),
(148, 3, 106, 61, 'parent', 'Added as parent to Shaik Chand Begum.', 21, '2026-05-11 17:19:14', '2026-05-11 17:19:14'),
(149, 3, 107, 61, 'parent', 'Added as parent to Shaik Chand Begum.', 21, '2026-05-11 17:21:20', '2026-05-11 17:21:20'),
(150, 3, 80, 108, 'parent', 'Added as child in household Shaik Shamshad Begum & Shaik Kareemullah Family.', 21, '2026-05-12 02:45:47', '2026-05-12 02:45:47'),
(151, 3, 89, 108, 'parent', 'Added as child in household Shaik Shamshad Begum & Shaik Kareemullah Family.', 21, '2026-05-12 02:45:47', '2026-05-12 02:45:47'),
(152, 3, 80, 109, 'parent', 'Added as child in household Shaik Shamshad Begum & Shaik Kareemullah Family.', 21, '2026-05-12 02:50:42', '2026-05-12 02:50:42'),
(153, 3, 89, 109, 'parent', 'Added as child in household Shaik Shamshad Begum & Shaik Kareemullah Family.', 21, '2026-05-12 02:50:42', '2026-05-12 02:50:42'),
(154, 3, 80, 110, 'parent', 'Added as child in household Shaik Shamshad Begum & Shaik Kareemullah Family.', 21, '2026-05-12 02:53:12', '2026-05-12 02:53:12'),
(155, 3, 89, 110, 'parent', 'Added as child in household Shaik Shamshad Begum & Shaik Kareemullah Family.', 21, '2026-05-12 02:53:12', '2026-05-12 02:53:12'),
(156, 3, 80, 111, 'parent', 'Added as child in household Shaik Shamshad Begum & Shaik Kareemullah Family.', 21, '2026-05-12 02:54:30', '2026-05-12 02:54:30'),
(157, 3, 89, 111, 'parent', 'Added as child in household Shaik Shamshad Begum & Shaik Kareemullah Family.', 21, '2026-05-12 02:54:30', '2026-05-12 02:54:30'),
(158, 3, 90, 112, 'spouse', 'Added as spouse to Shaik Gouse Basha.', 21, '2026-05-12 02:56:48', '2026-05-12 02:56:48'),
(159, 3, 68, 113, 'spouse', 'Added as spouse to Shaik Hussain Saheb.', 21, '2026-05-12 15:38:35', '2026-05-12 15:38:35'),
(160, 3, 68, 114, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:02:33', '2026-05-12 16:02:33'),
(161, 3, 113, 114, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:02:33', '2026-05-12 16:02:33'),
(162, 3, 68, 115, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:04:19', '2026-05-12 16:04:19'),
(163, 3, 113, 115, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:04:19', '2026-05-12 16:04:19'),
(164, 3, 68, 116, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:05:21', '2026-05-12 16:05:21'),
(165, 3, 113, 116, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:05:21', '2026-05-12 16:05:21'),
(166, 3, 68, 117, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:08:00', '2026-05-12 16:08:00'),
(167, 3, 113, 117, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:08:00', '2026-05-12 16:08:00'),
(168, 3, 68, 118, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:09:36', '2026-05-12 16:09:36'),
(169, 3, 113, 118, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:09:36', '2026-05-12 16:09:36'),
(170, 3, 68, 119, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:10:57', '2026-05-12 16:10:57'),
(171, 3, 113, 119, 'parent', 'Added as child in household Shaik Hussain Saheb & Shaik Khairunnisa Family.', 21, '2026-05-12 16:10:57', '2026-05-12 16:10:57'),
(172, 3, 117, 120, 'spouse', 'Added as spouse to Shaik Iqbal Hussain.', 21, '2026-05-12 17:09:51', '2026-05-12 17:09:51'),
(173, 3, 103, 121, 'spouse', 'Added as spouse to Shaik Fatimun.', 21, '2026-05-12 17:13:11', '2026-05-12 17:13:11'),
(174, 3, 75, 122, 'spouse', 'Added as spouse to Shaik Begum.', 21, '2026-05-12 17:16:03', '2026-05-12 17:16:03'),
(177, 3, 31, 124, 'spouse', 'Added as spouse to Shaik Khasim saheb.', 15, '2026-05-14 10:34:17', '2026-05-14 10:34:17'),
(178, 3, 31, 125, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:36:22', '2026-05-14 10:36:22'),
(179, 3, 124, 125, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:36:22', '2026-05-14 10:36:22'),
(180, 3, 31, 126, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:38:09', '2026-05-14 10:38:09'),
(181, 3, 124, 126, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:38:09', '2026-05-14 10:38:09'),
(182, 3, 31, 127, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:40:08', '2026-05-14 10:40:08'),
(183, 3, 124, 127, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:40:08', '2026-05-14 10:40:08'),
(184, 3, 31, 128, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:48:01', '2026-05-14 10:48:01'),
(185, 3, 124, 128, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:48:01', '2026-05-14 10:48:01'),
(186, 3, 31, 129, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:49:23', '2026-05-14 10:49:23'),
(187, 3, 124, 129, 'parent', 'Added as child in household Shaik Khasim saheb & Shaik Aqtar Family.', 15, '2026-05-14 10:49:23', '2026-05-14 10:49:23');

-- --------------------------------------------------------

--
-- Table structure for table `feedback_submissions`
--

CREATE TABLE `feedback_submissions` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` bigint(20) UNSIGNED NOT NULL,
  `family_id` bigint(20) UNSIGNED DEFAULT NULL,
  `role` varchar(32) NOT NULL,
  `notes` text DEFAULT NULL,
  `screenshot_path` varchar(255) DEFAULT NULL,
  `screenshot_original_name` varchar(255) DEFAULT NULL,
  `screenshot_mime_type` varchar(120) DEFAULT NULL,
  `screenshot_size` int(10) UNSIGNED DEFAULT NULL,
  `source_url` varchar(2048) DEFAULT NULL,
  `status` varchar(32) NOT NULL DEFAULT 'open',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `feedback_submissions`
--

INSERT INTO `feedback_submissions` (`id`, `user_id`, `family_id`, `role`, `notes`, `screenshot_path`, `screenshot_original_name`, `screenshot_mime_type`, `screenshot_size`, `source_url`, `status`, `created_at`, `updated_at`) VALUES
(1, 15, 3, 'user', 'Back button and select ring', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 14:29:57', '2026-05-01 14:32:03'),
(2, 15, 3, 'user', 'Istarah ka back button nahi hai', 'feedback-screenshots/RHeZo9o939k7I5zMUkijDCZPl8SWB2zrix9ir3ej.jpg', '1000203252.jpg', 'image/jpeg', 425423, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 14:35:42', '2026-05-01 14:35:42'),
(4, 15, 3, 'user', 'Problem discribe karne ke liye video upload nahi ho raha', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 14:44:41', '2026-05-01 14:44:41'),
(5, 15, 3, 'user', 'What is link option', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 15:01:55', '2026-05-01 15:01:55'),
(6, 15, 3, 'user', 'No option for name edit', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 15:02:49', '2026-05-01 15:02:49'),
(7, 15, 3, 'user', 'When I select name select along with name  i mean when we select any thing then ring only move', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 15:06:34', '2026-05-01 15:06:34'),
(9, 15, 3, 'user', 'Deceased word replace with dead', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 15:48:04', '2026-05-01 15:48:04'),
(10, 20, 3, 'user', 'Date of birth and death date beside names', 'feedback-screenshots/hjBstEJJgqCq3dbCggTesZAm7hnA4jh2ndK8fXHh.png', '1000147142.png', 'image/png', 204068, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 17:16:58', '2026-05-01 17:16:58'),
(11, 1, NULL, 'super_admin', 'Create families for the users getting login from you create user account screen', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/super-admin/feedback', 'open', '2026-05-01 17:21:49', '2026-05-01 17:21:49'),
(12, 1, NULL, 'super_admin', 'Provide animated auto hide notification time limited', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/super-admin/feedback', 'open', '2026-05-01 17:22:30', '2026-05-01 17:22:30'),
(13, 20, 3, 'user', 'Sister of is wrong here', 'feedback-screenshots/P7f2SL9MlS0cP0hxzE6inqRFwv03Rx1XAnCOXFfb.png', '1000147143.png', 'image/png', 217146, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 17:28:14', '2026-05-01 17:28:14'),
(14, 20, 3, 'user', 'Nasreen siblings are shown both as siblings and children \r\nNasreen siblings are shown as Mynuddin children', 'feedback-screenshots/ckLHfOWpxlXgUdJLGHMZDfcm3lmyoIonI6g9j87X.png', '1000147149.png', 'image/png', 232921, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-01 17:39:54', '2026-05-01 17:39:54'),
(15, 15, 3, 'user', 'Wrong relationship showing its see like sister but her relationship is sisterinlaw', 'feedback-screenshots/wPVmbebnvtM8v8ZMoyJLJXnu2nV225CBbvMd2kUn.jpg', '1000203281.jpg', 'image/jpeg', 372418, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-01 17:48:22', '2026-05-01 17:48:22'),
(16, 1, NULL, 'super_admin', 'Display the family tree of the person who locked in my default', 'feedback-screenshots/ij8MDqVmAmOFpvzVx3B9n1CQLFCJNo2iVgSOGRfN.jpg', 'Screenshot_2026-05-01-23-20-03-82_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 420091, 'https://familytree.khajamynuddin.com/super-admin/feedback', 'resolved', '2026-05-01 17:51:08', '2026-05-03 11:38:39'),
(17, 15, 3, 'user', 'Member has access to add his own siblings parents and children\'s he cannot able to add any other relationships should not add tricky', 'feedback-screenshots/87kbxH0iOUAz1bPw8kUOIL6f7YSF2vEo9mYgxgA0.jpg', '1000203282.jpg', 'image/jpeg', 277253, 'https://familytree.khajamynuddin.com/app/feedback', 'in_review', '2026-05-01 17:56:27', '2026-05-02 02:44:20'),
(18, 21, 3, 'user', 'Nice appp', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'resolved', '2026-05-03 11:23:21', '2026-05-03 11:24:07'),
(19, 21, 3, 'user', 'Profile edit option may be provided', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-03 11:36:17', '2026-05-03 11:36:17'),
(20, 21, 3, 'user', 'Provide add member option beside not added tab', 'feedback-screenshots/P6W9RJQ6EXW1myQSTa0bXr97c1bON1RK5ytz60Uv.png', 'IMG_1653.png', 'image/png', 297769, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-03 11:39:31', '2026-05-03 11:39:31'),
(21, 21, 3, 'user', 'Every profile shall be titled with head of family in place of just below end user tab family member title', 'feedback-screenshots/3hPJaA1lRW37R0HeTTH6jBYRIfE0lQSTSaT3hU2R.png', 'IMG_1654.png', 'image/png', 395111, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-03 12:06:19', '2026-05-03 12:06:19'),
(22, 21, 3, 'user', 'Duplicate house hold found in madar saheb family', 'feedback-screenshots/q75Q0OhzwMy8lMZwzzK4lJcMjJ9eEqCPeiRS1QYm.png', 'IMG_1655.png', 'image/png', 1074525, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-03 12:17:09', '2026-05-03 12:17:09'),
(23, 21, 3, 'user', 'Added by: not recorded', 'feedback-screenshots/pMxZ8r0hYGONUKkWuMujHUM0nqh1SXWynqfDwZDt.jpg', 'IMG_1656.jpeg', 'image/jpeg', 713530, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-03 12:50:08', '2026-05-03 12:50:08'),
(24, 21, 3, 'user', 'Replace household members in place of you and spouse', 'feedback-screenshots/Kpr7EI3BAK65WDSIw6Pifo0D2HuZmBufnCQmMyGC.png', 'IMG_1657.png', 'image/png', 621833, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-03 12:54:59', '2026-05-03 12:54:59'),
(25, 19, 3, 'user', 'Duplicate data', 'feedback-screenshots/yAhbQrCkFYtLrqDpXLMJJ2Opybm9HknBUOYrTGBO.jpg', 'Screenshot_2026-05-03-22-25-25-61_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 401203, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-03 16:55:54', '2026-05-03 16:55:54'),
(26, 15, 3, 'user', 'Correct aadil khan name', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-04 08:46:13', '2026-05-04 08:46:13'),
(27, 1, NULL, 'super_admin', 'Provide birth time recording functionality', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/super-admin/feedback', 'open', '2026-05-04 13:06:58', '2026-05-04 13:06:58'),
(28, 1, NULL, 'super_admin', 'Add member profession access only admins and super admins', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/super-admin/feedback', 'open', '2026-05-04 13:20:04', '2026-05-04 13:20:04'),
(29, 19, 3, 'user', 'Horizontal overflow hiding content button and stepper', 'feedback-screenshots/uV8uU1d7A8ST6WDzcGtrZpPhfB7nwUfpUu6j5ozD.jpg', 'Screenshot_2026-05-09-09-00-48-91_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 255008, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-09 03:32:22', '2026-05-09 03:32:22'),
(30, 19, 3, 'user', 'All added members should approved by super without been approval they should not appear in members or in tree', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-09 03:33:29', '2026-05-09 03:33:29'),
(31, 19, 3, 'user', 'Make consistent vertical space between form fields to identify which label is related to which input and the input border search should be clear with very light now it has been increased', 'feedback-screenshots/5CtdNAPneLPdBSTQBq53RIh1IzFwqW7sIcOCFxVr.jpg', 'Screenshot_2026-05-09-09-04-01-00_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 246314, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-09 03:34:44', '2026-05-09 03:34:44'),
(32, 19, 3, 'user', 'White background white cards is having some ice train to some users it has to be maintain with a perfect contract', 'feedback-screenshots/KfxCvLL222Fk2Zfs7CgO1xA75jPOpIE1q8GZ8o4t.jpg', 'Screenshot_2026-05-09-09-05-30-06_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 509810, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-09 03:36:22', '2026-05-09 03:36:22'),
(33, 19, 3, 'user', 'Holding profile I can\'t should display context menu', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-09 04:00:44', '2026-05-09 04:00:44'),
(34, 19, 3, 'user', 'Display preview when submitting feedback', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-09 04:02:00', '2026-05-09 04:02:00'),
(35, 19, 3, 'user', 'Combine edit profile and edit member details in profile section in a one form', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-09 04:02:48', '2026-05-09 04:02:48'),
(36, 21, 3, 'admin', 'Here Hussain saheb badeba not appearing though added member', 'feedback-screenshots/F4a1yj5XuSobSbbfccWMAY5HU4HJcnp3rzUWdC33.png', 'Screenshot 2026-05-09 171346.png', 'image/png', 76517, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-09 11:45:55', '2026-05-09 11:45:55'),
(37, 21, 3, 'admin', 'here two house holds duplicate available. Which one i have to delete decide and delete it.', 'feedback-screenshots/ee5xvBI9NjzKKI9A5w24QSZFXPEQ7DQ7iHQ7Lt2F.png', 'Screenshot 2026-05-09 194453.png', 'image/png', 89256, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-09 14:17:00', '2026-05-09 14:17:00'),
(38, 21, 3, 'admin', 'here we can provide death certificate for upload', 'feedback-screenshots/l1G083DdB1midC3mgyKFWSBOF4S5E3cOYWSDUGwv.png', 'Screenshot 2026-05-09 200153.png', 'image/png', 55051, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-09 14:32:59', '2026-05-09 14:32:59'),
(39, 21, 3, 'admin', 'In date of birth window also we can provide a tab for upload of birth certificate', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-09 14:33:44', '2026-05-09 14:33:44'),
(40, 21, 3, 'admin', 'In future if adhar asked there also we can provide tabs for adhar, pan, passport etc. upload options', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-09 14:34:31', '2026-05-09 14:34:31'),
(41, 21, 3, 'admin', 'here 3 house holds of Madar saheb appearing', 'feedback-screenshots/snkFG7zKExaEHZSDrQPBtIN15uTNWXfkOqHlNOHU.png', 'Screenshot 2026-05-09 202008.png', 'image/png', 55901, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-09 14:50:49', '2026-05-09 14:50:49'),
(42, 19, 3, 'user', 'Alias name', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-09 16:31:53', '2026-05-09 16:31:53'),
(43, 1, NULL, 'super_admin', 'Biography description page for each member', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/super-admin/feedback', 'open', '2026-05-09 17:23:34', '2026-05-09 17:23:34'),
(44, 21, 3, 'admin', 'spouse tab for unmarried died persons has to be removed disabled or removed i.e., ADD button removed.', 'feedback-screenshots/6SyYU08fYD7kGT7ARDTV5tapU7muwEHxFT9yrdbY.png', 'Screenshot 2026-05-09 233917.png', 'image/png', 112108, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-09 18:11:52', '2026-05-09 18:11:52'),
(45, 21, 3, 'admin', 'Beside Yasmeen title the D.P profile pic has to be displayed', 'feedback-screenshots/fKxOJQWm9ZHGEodYt1bmlc4uwX4zFh3UhDZGlJlp.png', 'Screenshot 2026-05-10 001926.png', 'image/png', 64836, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-09 18:51:18', '2026-05-09 18:51:18'),
(46, 21, 3, 'admin', 'Cause of death and in-house, accident, disease etc. tabs shall be kept', 'feedback-screenshots/0K7oJb9LhcOMR0AiDDu0SLFYglnBotTWyYrA21Xb.png', 'Screenshot 2026-05-10 005002.png', 'image/png', 34081, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-09 19:21:12', '2026-05-09 19:21:12'),
(47, 21, 3, 'admin', 'Basha mamu ammi brother not being added with the above error', 'feedback-screenshots/EHatn65ucL5idDb4Pd37rSwEDmdTzOQVlh2oVhLY.png', 'Screenshot 2026-05-10 010902.png', 'image/png', 55646, 'https://familytree.khajamynuddin.com/admin/feedback', 'resolved', '2026-05-09 19:39:51', '2026-05-09 19:46:17'),
(48, 19, 3, 'user', 'Add membership contact auto auto import', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-10 02:21:51', '2026-05-10 02:21:51'),
(49, 19, 3, 'user', 'To Fatima are in one family', 'feedback-screenshots/7tmDVIebTO5IkSl347ykSvSBoiyqSHJ1ep6keYAq.jpg', 'Screenshot_2026-05-10-17-59-54-29_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 379192, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-10 12:30:29', '2026-05-10 12:30:29'),
(50, 21, 3, 'admin', 'In i in iPhone, all the tabs such as NEXT is not shoing', 'feedback-screenshots/iMFPaUkcAk8nJtZRSDWTmmlUzFxQhQlyb4KdIrkf.png', 'IMG_1679.png', 'image/png', 160644, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-10 12:34:06', '2026-05-10 12:34:06'),
(51, 21, 3, 'admin', 'Person should be shown in age order, not in alphabetical order', 'feedback-screenshots/FqNbEVMBUZE29tqpeTag9a3UqNUqYFfUEpyx5qkp.png', 'IMG_1680.png', 'image/png', 451848, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-10 12:37:10', '2026-05-10 12:37:10'),
(52, 21, 3, 'admin', 'Bug in this', 'feedback-screenshots/pEDjUEsGzDAyZG1wRx1niEsaOMUEMsVHpVow7ZW5.png', 'IMG_1681.png', 'image/png', 727208, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-10 12:52:15', '2026-05-10 12:52:15'),
(53, 21, 3, 'admin', 'Overlapping tabs', 'feedback-screenshots/TqOchIWd1464ezZpLLO8rTYxjoGsxNvLEBJpeuYw.png', 'IMG_1682.png', 'image/png', 146753, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-10 13:11:20', '2026-05-10 13:11:20'),
(54, 1, NULL, 'super_admin', 'Add family member the default country is India provide option to change country if user designs', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/super-admin/feedback', 'open', '2026-05-10 13:16:46', '2026-05-10 13:16:46'),
(55, 19, 3, 'user', 'Options of family members childrens anyone by date of birth my alphabet and by generation', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-10 13:18:13', '2026-05-10 13:18:13'),
(56, 21, 3, 'admin', 'Children Tab must be separable from siblings and must be appeared highlighted', 'feedback-screenshots/3BLJGZKfyybzOj8yYtizU6uTvtYvrJzmLwa4htl9.png', 'IMG_1683.png', 'image/png', 313376, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-10 13:19:55', '2026-05-10 13:19:55'),
(57, 19, 3, 'user', 'In members page newly added sort option', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-12 00:22:34', '2026-05-12 00:22:34'),
(58, 19, 3, 'user', 'Activity for end user', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-12 00:23:34', '2026-05-12 00:23:34'),
(59, 15, 3, 'user', 'Give dragon option to organize by age big to small', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-12 00:39:55', '2026-05-12 00:39:55'),
(60, 21, 3, 'admin', 'Jeelan Bhaiya and Nazneen bhabhi are added below their parents, but how to add as each other', NULL, NULL, NULL, NULL, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-13 08:14:00', '2026-05-13 08:14:00'),
(61, 21, 3, 'admin', 'Here khaja Mia appears as parent to Ammi, but in children, Ammi is not appearing', 'feedback-screenshots/oJj7dPmCW9wuM8nsOoIxZ8CUmUU5eaCsnFJUsqWZ.png', 'IMG_1698.png', 'image/png', 652924, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-13 08:19:18', '2026-05-13 08:19:18'),
(62, 21, 3, 'admin', 'Here Ammi is not appearing as children to khaja Mia', 'feedback-screenshots/du0fgaIurv1A8bUmDrwapP4Of0XtMxhEgADiFAty.png', 'IMG_1699.png', 'image/png', 185505, 'https://familytree.khajamynuddin.com/admin/feedback', 'open', '2026-05-13 08:20:53', '2026-05-13 08:20:53'),
(63, 19, 3, 'user', 'For and users existing person should be fixed who is logging and do not provide the option to change the existing person', 'feedback-screenshots/c6bxgJMmg1GHt6SeDj6M7JqnvW5RkE4zKardFlii.jpg', 'Screenshot_2026-05-14-09-13-20-93_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 252839, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-14 03:44:22', '2026-05-14 03:44:22'),
(64, 19, 3, 'user', 'Concise the upload images God and button and display the images uploaded images preview', 'feedback-screenshots/RUPSPx4jSCp05tIDUuQrvjUWyYjJexFqF0FoCfqh.jpg', 'Screenshot_2026-05-14-09-11-14-13_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 390015, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-14 03:45:40', '2026-05-14 03:45:40'),
(65, 19, 3, 'user', 'Recently added filter', 'feedback-screenshots/cAI1zSKKyrAsp8UxNmAbiUGy8QiJMDUV6uWGtIQY.jpg', 'Screenshot_2026-05-14-18-57-30-51_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 334967, 'https://familytree.khajamynuddin.com/app/feedback', 'open', '2026-05-14 13:27:56', '2026-05-14 13:27:56'),
(66, 1, NULL, 'super_admin', 'Remove family drop down selection from the admin role superhit mineral', 'feedback-screenshots/wVT1Y3283gSAPG1SdegmdQDnJCOZcyQqpBooBFF1.jpg', 'Screenshot_2026-05-14-18-58-36-13_40deb401b9ffe8e1df2f1cc5ba480b12.jpg', 'image/jpeg', 402941, 'https://familytree.khajamynuddin.com/super-admin/feedback', 'open', '2026-05-14 13:29:04', '2026-05-14 13:29:04');

-- --------------------------------------------------------

--
-- Table structure for table `households`
--

CREATE TABLE `households` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `family_id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `primary_person_id` bigint(20) UNSIGNED DEFAULT NULL,
  `spouse_person_id` bigint(20) UNSIGNED DEFAULT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `households`
--

INSERT INTO `households` (`id`, `family_id`, `name`, `primary_person_id`, `spouse_person_id`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 3, 'Ruhi Ahmad & Syed Mushtaq Ahmed Family', 34, 35, 15, '2026-05-01 14:22:43', '2026-05-01 14:22:43'),
(2, 3, 'Shaik Yasmeen & Deshmukh Ayub Khan Family', 30, 38, 15, '2026-05-01 14:58:51', '2026-05-01 14:58:51'),
(3, 3, 'SHAIK KHAJA MYNUDDIN & Syed Nasreen Fathima Family', 41, 42, 19, '2026-05-01 16:10:34', '2026-05-01 16:10:34'),
(4, 3, 'Shaik Madar Saheb & Shaik Chand Begum Family', 25, NULL, 15, '2026-05-01 17:05:25', '2026-05-01 17:05:25'),
(5, 3, 'Shaik Madar Saheb & Shaik Chand Begum Family', 25, NULL, 15, '2026-05-01 17:28:01', '2026-05-01 17:28:01'),
(6, 3, 'Sirajuddin & Ayesha Siddiqua Shaik Family', 52, 54, 21, '2026-05-03 12:29:36', '2026-05-03 12:29:36'),
(7, 3, 'Shaik Madar Saheb & Shaik Chand Begum Family', 25, 61, 1, '2026-05-04 16:57:38', '2026-05-04 16:57:38'),
(8, 3, 'Shaik Dastagir Saheb & Shaik Mahaboob Chan Family', 32, 63, 21, '2026-05-07 17:34:44', '2026-05-07 17:34:44'),
(9, 3, 'Shaik Mohammed Hussain & Shaik Nasira Family', 64, 65, 21, '2026-05-07 17:48:14', '2026-05-07 17:48:14'),
(10, 3, 'Shaik Abdul Razzakh Raja Saab & Shaik Pyaran Family', 22, 70, 21, '2026-05-09 13:50:07', '2026-05-09 13:50:07'),
(11, 3, 'Shaik zahra bee & Syed Osman Saheb Family', 81, 82, 21, '2026-05-09 18:58:14', '2026-05-09 18:58:14'),
(12, 3, 'Shaik Maalan bee & Shaik Yakhub sab Family', 86, 87, 21, '2026-05-09 19:17:18', '2026-05-09 19:17:18'),
(13, 3, 'Shaik Shamshad Begum & Shaik Kareemullah Family', 80, 89, 21, '2026-05-09 19:42:56', '2026-05-09 19:42:56'),
(14, 3, 'Syed Hussain Bee & Shaik Magbool Family', 92, 93, 21, '2026-05-09 20:02:06', '2026-05-09 20:02:06'),
(15, 3, 'Shaik Fatimun & Shaik Hayat Family', NULL, NULL, 21, '2026-05-09 20:05:59', '2026-05-09 20:05:59'),
(16, 3, 'Shaik. Fatimun & Shaik Hayath Family', 95, 96, 21, '2026-05-09 20:16:32', '2026-05-09 20:16:32'),
(17, 3, 'Syed Anjum Fathima & Shaik Jaaved Family', 49, 98, 19, '2026-05-10 02:21:04', '2026-05-10 02:21:04'),
(18, 3, 'Syed Noor & Syed Dilshad Begam Family', 58, 99, 19, '2026-05-10 02:24:25', '2026-05-10 02:24:25'),
(19, 3, 'Shaik Gouse Basha & Shaik Habeeb Family', 90, 112, 21, '2026-05-12 02:56:48', '2026-05-12 02:56:48'),
(20, 3, 'Shaik Hussain Saheb & Shaik Khairunnisa Family', 68, 113, 21, '2026-05-12 15:38:35', '2026-05-12 15:38:35'),
(21, 3, 'Shaik Iqbal Hussain & Shaik Amreen Family', 117, 120, 21, '2026-05-12 17:09:51', '2026-05-12 17:09:51'),
(22, 3, 'Shaik Fatimun & Shaik Jaffer Family', 103, 121, 21, '2026-05-12 17:13:11', '2026-05-12 17:13:11'),
(23, 3, 'Shaik Begum & Shaik Basheer Family', 75, 122, 21, '2026-05-12 17:16:03', '2026-05-12 17:16:03'),
(24, 3, 'Shaik Khasim saheb & Shaik Aqtar Family', 31, 124, 15, '2026-05-14 10:34:17', '2026-05-14 10:34:17');

-- --------------------------------------------------------

--
-- Table structure for table `household_members`
--

CREATE TABLE `household_members` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `household_id` bigint(20) UNSIGNED NOT NULL,
  `member_id` bigint(20) UNSIGNED NOT NULL,
  `role` varchar(32) NOT NULL,
  `created_by` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `household_members`
--

INSERT INTO `household_members` (`id`, `household_id`, `member_id`, `role`, `created_by`, `created_at`, `updated_at`) VALUES
(1, 1, 34, 'spouse', 15, '2026-05-01 14:22:43', '2026-05-01 14:22:43'),
(2, 1, 35, 'husband', 15, '2026-05-01 14:22:43', '2026-05-01 14:22:43'),
(3, 1, 36, 'child', 15, '2026-05-01 14:26:14', '2026-05-01 14:26:14'),
(4, 2, 30, 'wife', 15, '2026-05-01 14:58:51', '2026-05-01 14:58:51'),
(5, 2, 38, 'husband', 15, '2026-05-01 14:58:51', '2026-05-01 14:58:51'),
(6, 3, 41, 'husband', 19, '2026-05-01 16:10:34', '2026-05-01 16:10:34'),
(7, 3, 42, 'wife', 19, '2026-05-01 16:10:34', '2026-05-01 16:10:34'),
(8, 3, 43, 'child', 20, '2026-05-01 17:02:29', '2026-05-01 17:02:29'),
(9, 3, 44, 'child', 20, '2026-05-01 17:04:35', '2026-05-01 17:04:35'),
(10, 4, 25, 'husband', 15, '2026-05-01 17:05:25', '2026-05-01 17:05:25'),
(12, 5, 25, 'husband', 15, '2026-05-01 17:28:01', '2026-05-01 17:28:01'),
(14, 6, 52, 'spouse', 21, '2026-05-03 12:29:36', '2026-05-03 12:29:36'),
(15, 6, 54, 'wife', 21, '2026-05-03 12:29:36', '2026-05-03 12:29:36'),
(16, 6, 55, 'child', 21, '2026-05-03 12:34:52', '2026-05-03 12:34:52'),
(17, 6, 56, 'child', 21, '2026-05-03 12:45:21', '2026-05-03 12:45:21'),
(20, 7, 25, 'husband', 1, '2026-05-04 16:57:38', '2026-05-04 16:57:38'),
(21, 7, 61, 'wife', 1, '2026-05-04 16:57:38', '2026-05-04 16:57:38'),
(22, 8, 32, 'husband', 21, '2026-05-07 17:34:44', '2026-05-07 17:34:44'),
(23, 8, 63, 'wife', 21, '2026-05-07 17:34:44', '2026-05-07 17:34:44'),
(24, 8, 64, 'child', 21, '2026-05-07 17:43:05', '2026-05-07 17:43:05'),
(25, 9, 64, 'husband', 21, '2026-05-07 17:48:14', '2026-05-07 17:48:14'),
(26, 9, 65, 'wife', 21, '2026-05-07 17:48:14', '2026-05-07 17:48:14'),
(27, 10, 22, 'husband', 21, '2026-05-09 13:50:07', '2026-05-09 13:50:07'),
(28, 10, 70, 'wife', 21, '2026-05-09 13:50:07', '2026-05-09 13:50:07'),
(29, 10, 71, 'child', 21, '2026-05-09 13:53:30', '2026-05-09 13:53:30'),
(30, 10, 72, 'child', 21, '2026-05-09 14:00:47', '2026-05-09 14:00:47'),
(32, 10, 74, 'child', 21, '2026-05-09 14:04:29', '2026-05-09 14:04:29'),
(33, 10, 75, 'child', 21, '2026-05-09 14:07:29', '2026-05-09 14:07:29'),
(34, 5, 76, 'child', 21, '2026-05-09 14:32:00', '2026-05-09 14:32:00'),
(35, 2, 77, 'child', 21, '2026-05-09 14:59:30', '2026-05-09 14:59:30'),
(36, 2, 78, 'child', 21, '2026-05-09 18:00:38', '2026-05-09 18:00:38'),
(37, 1, 79, 'child', 21, '2026-05-09 18:07:39', '2026-05-09 18:07:39'),
(38, 11, 81, 'wife', 21, '2026-05-09 18:58:14', '2026-05-09 18:58:14'),
(39, 11, 82, 'husband', 21, '2026-05-09 18:58:14', '2026-05-09 18:58:14'),
(40, 11, 83, 'child', 21, '2026-05-09 19:00:55', '2026-05-09 19:00:55'),
(41, 11, 84, 'child', 21, '2026-05-09 19:02:25', '2026-05-09 19:02:25'),
(42, 11, 85, 'child', 21, '2026-05-09 19:03:28', '2026-05-09 19:03:28'),
(43, 12, 86, 'wife', 21, '2026-05-09 19:17:18', '2026-05-09 19:17:18'),
(44, 12, 87, 'husband', 21, '2026-05-09 19:17:18', '2026-05-09 19:17:18'),
(45, 12, 88, 'child', 21, '2026-05-09 19:26:24', '2026-05-09 19:26:24'),
(46, 13, 80, 'wife', 21, '2026-05-09 19:42:56', '2026-05-09 19:42:56'),
(47, 13, 89, 'husband', 21, '2026-05-09 19:42:56', '2026-05-09 19:42:56'),
(48, 8, 91, 'child', 21, '2026-05-09 19:51:44', '2026-05-09 19:51:44'),
(49, 11, 92, 'child', 21, '2026-05-09 19:59:52', '2026-05-09 19:59:52'),
(50, 14, 92, 'wife', 21, '2026-05-09 20:02:06', '2026-05-09 20:02:06'),
(51, 14, 93, 'husband', 21, '2026-05-09 20:02:06', '2026-05-09 20:02:06'),
(55, 14, 95, 'child', 21, '2026-05-09 20:15:03', '2026-05-09 20:15:03'),
(56, 16, 95, 'wife', 21, '2026-05-09 20:16:32', '2026-05-09 20:16:32'),
(57, 16, 96, 'husband', 21, '2026-05-09 20:16:32', '2026-05-09 20:16:32'),
(58, 12, 97, 'child', 21, '2026-05-09 20:20:51', '2026-05-09 20:20:51'),
(59, 17, 49, 'wife', 19, '2026-05-10 02:21:04', '2026-05-10 02:21:04'),
(60, 17, 98, 'husband', 19, '2026-05-10 02:21:04', '2026-05-10 02:21:04'),
(61, 18, 58, 'husband', 19, '2026-05-10 02:24:25', '2026-05-10 02:24:25'),
(62, 18, 99, 'wife', 19, '2026-05-10 02:24:25', '2026-05-10 02:24:25'),
(63, 10, 103, 'child', 21, '2026-05-10 13:16:42', '2026-05-10 13:16:42'),
(64, 13, 108, 'child', 21, '2026-05-12 02:45:47', '2026-05-12 02:45:47'),
(65, 13, 109, 'child', 21, '2026-05-12 02:50:42', '2026-05-12 02:50:42'),
(66, 13, 110, 'child', 21, '2026-05-12 02:53:12', '2026-05-12 02:53:12'),
(67, 13, 111, 'child', 21, '2026-05-12 02:54:30', '2026-05-12 02:54:30'),
(68, 19, 90, 'husband', 21, '2026-05-12 02:56:48', '2026-05-12 02:56:48'),
(69, 19, 112, 'wife', 21, '2026-05-12 02:56:48', '2026-05-12 02:56:48'),
(70, 20, 68, 'husband', 21, '2026-05-12 15:38:35', '2026-05-12 15:38:35'),
(71, 20, 113, 'wife', 21, '2026-05-12 15:38:35', '2026-05-12 15:38:35'),
(72, 20, 114, 'child', 21, '2026-05-12 16:02:33', '2026-05-12 16:02:33'),
(73, 20, 115, 'child', 21, '2026-05-12 16:04:19', '2026-05-12 16:04:19'),
(74, 20, 116, 'child', 21, '2026-05-12 16:05:21', '2026-05-12 16:05:21'),
(75, 20, 117, 'child', 21, '2026-05-12 16:08:00', '2026-05-12 16:08:00'),
(76, 20, 118, 'child', 21, '2026-05-12 16:09:36', '2026-05-12 16:09:36'),
(77, 20, 119, 'child', 21, '2026-05-12 16:10:57', '2026-05-12 16:10:57'),
(78, 21, 117, 'husband', 21, '2026-05-12 17:09:51', '2026-05-12 17:09:51'),
(79, 21, 120, 'wife', 21, '2026-05-12 17:09:51', '2026-05-12 17:09:51'),
(80, 22, 103, 'wife', 21, '2026-05-12 17:13:11', '2026-05-12 17:13:11'),
(81, 22, 121, 'husband', 21, '2026-05-12 17:13:11', '2026-05-12 17:13:11'),
(82, 23, 75, 'wife', 21, '2026-05-12 17:16:03', '2026-05-12 17:16:03'),
(83, 23, 122, 'husband', 21, '2026-05-12 17:16:03', '2026-05-12 17:16:03'),
(85, 24, 31, 'husband', 15, '2026-05-14 10:34:17', '2026-05-14 10:34:17'),
(86, 24, 124, 'wife', 15, '2026-05-14 10:34:17', '2026-05-14 10:34:17'),
(87, 24, 125, 'child', 15, '2026-05-14 10:36:22', '2026-05-14 10:36:22'),
(88, 24, 126, 'child', 15, '2026-05-14 10:38:09', '2026-05-14 10:38:09'),
(89, 24, 127, 'child', 15, '2026-05-14 10:40:08', '2026-05-14 10:40:08'),
(90, 24, 128, 'child', 15, '2026-05-14 10:48:01', '2026-05-14 10:48:01'),
(91, 24, 129, 'child', 15, '2026-05-14 10:49:23', '2026-05-14 10:49:23');

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` smallint(5) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_batches`
--

CREATE TABLE `job_batches` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `total_jobs` int(11) NOT NULL,
  `pending_jobs` int(11) NOT NULL,
  `failed_jobs` int(11) NOT NULL,
  `failed_job_ids` longtext NOT NULL,
  `options` mediumtext DEFAULT NULL,
  `cancelled_at` int(11) DEFAULT NULL,
  `created_at` int(11) NOT NULL,
  `finished_at` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '0001_01_01_000000_create_users_table', 1),
(2, '0001_01_01_000001_create_cache_table', 1),
(3, '0001_01_01_000002_create_jobs_table', 1),
(4, '2026_04_26_080720_create_personal_access_tokens_table', 1),
(5, '2026_04_26_140000_create_families_table', 2),
(6, '2026_04_26_140100_add_family_id_to_users_table', 2),
(7, '2026_04_26_140200_create_family_members_table', 2),
(8, '2026_04_26_150000_create_family_relationships_table', 3),
(9, '2026_04_27_170000_add_approval_status_to_users_table', 4),
(10, '2026_04_27_171000_add_photo_path_to_family_members_table', 4),
(11, '2026_04_27_180000_add_phone_to_users_table', 5),
(12, '2026_04_27_181000_add_graveyard_location_to_family_members_table', 6),
(13, '2026_04_28_000000_add_profile_fields_to_family_members_table', 7),
(14, '2026_04_28_103000_ensure_member_profile_and_relationship_schema', 8),
(15, '2026_04_28_120000_create_family_connection_requests_table', 9),
(16, '2026_04_29_030000_create_households_tables', 9),
(17, '2026_04_29_040000_create_feedback_submissions_table', 9),
(18, '2026_05_03_000100_create_audit_trails_table', 10),
(19, '2026_05_04_120000_add_birth_time_to_family_members_table', 11),
(20, '2026_05_04_220000_ensure_birth_time_and_photo_path_on_family_members_table', 11);

-- --------------------------------------------------------

--
-- Table structure for table `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) NOT NULL,
  `token` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) NOT NULL,
  `tokenable_id` bigint(20) UNSIGNED NOT NULL,
  `name` text NOT NULL,
  `token` varchar(64) NOT NULL,
  `abilities` text DEFAULT NULL,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `personal_access_tokens`
--

INSERT INTO `personal_access_tokens` (`id`, `tokenable_type`, `tokenable_id`, `name`, `token`, `abilities`, `last_used_at`, `expires_at`, `created_at`, `updated_at`) VALUES
(14, 'App\\Models\\User', 6, 'web', 'ef5aa82b092d08243303ca893706ba3d43804269cc0d16c713069d0016322823', '[\"*\"]', '2026-04-27 13:13:58', NULL, '2026-04-27 07:30:10', '2026-04-27 13:13:58'),
(28, 'App\\Models\\User', 7, 'web', 'd748a5faf9cccf88dfdcab34907fe65e829a6b31a38d3c8bb1b0e8e801943a9d', '[\"*\"]', '2026-04-27 13:57:27', NULL, '2026-04-27 13:57:27', '2026-04-27 13:57:27'),
(136, 'App\\Models\\User', 20, 'web', 'a139b0561ee8c2c91e2151819fe2903bec0064e80adc3fd951ba2203ca69831f', '[\"*\"]', '2026-05-06 02:19:20', NULL, '2026-05-01 16:57:48', '2026-05-06 02:19:20'),
(141, 'App\\Models\\User', 15, 'web', '915a4108418e1d50d5f0dd0b95d280ed02ad88c4afdfc31e21085a03d1d1f600', '[\"*\"]', '2026-05-14 15:20:30', NULL, '2026-05-01 17:49:59', '2026-05-14 15:20:30'),
(163, 'App\\Models\\User', 22, 'web', '3d1798e33e7e5c52423dc5d4ccd9bcb48184f2c9d692739e5b41578d86eb79ff', '[\"*\"]', '2026-05-05 07:35:19', NULL, '2026-05-03 19:55:24', '2026-05-05 07:35:19'),
(183, 'App\\Models\\User', 23, 'web', 'c0efdaa40deddafac9a4ed17a5eec5a8ef2f925d068303f1c59f50f91fee8926', '[\"*\"]', '2026-05-08 20:43:19', NULL, '2026-05-07 08:39:51', '2026-05-08 20:43:19'),
(223, 'App\\Models\\User', 21, 'web', '9dcaf746568d0f406932bd41e8a9f0ad5770d431dd2b99608e690ffa41519792', '[\"*\"]', '2026-05-14 17:41:44', NULL, '2026-05-14 13:37:31', '2026-05-14 17:41:44'),
(224, 'App\\Models\\User', 1, 'web', '744678ef7852c0ad2ca6467569acea4dded42c7684c316f1c3186180b25c6f79', '[\"*\"]', '2026-05-15 06:28:50', NULL, '2026-05-15 06:28:26', '2026-05-15 06:28:50');

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `sessions`
--

INSERT INTO `sessions` (`id`, `user_id`, `ip_address`, `user_agent`, `payload`, `last_activity`) VALUES
('14r01Z0wgfKDSXQSBlCK2lDQS8bKEuPrNJAciFzT', NULL, '2a02:4780:11:c0de::e', 'Go-http-client/2.0', 'eyJfdG9rZW4iOiJHT25NYzZnbFhIeWduVDNSTVZEMFJpbVZIT1dZQnN6VHVEZkhtWXpRIiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1778139890),
('1WrqSKgNpOf8uE6UloMGqlV8VppURglRfwjGAtzO', NULL, '2a02:4780:11:c0de::e', 'Go-http-client/2.0', 'eyJfdG9rZW4iOiJHOGtoV2ZDclNRQTl1bXd5REpQM1RHU1phMEZKVUxwTlVJWkg2TEh2IiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1778495464),
('5ftygkteEKiWwldZBPm2SG3ubzAFxk9oinlBaZo7', NULL, '2a02:4780:11:c0de::e', 'Go-http-client/2.0', 'eyJfdG9rZW4iOiJ0VFQ1SnBudzZhQjFNUUtVaXRZM2c4OHJNZW9MYU5IcndwbGM1Mlk1IiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1778056002),
('aOjdvHNDDf4R1jlu6jJTgXUqlUkm5QtWPz1tbYh6', NULL, '69.17.115.90', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJtTDFPdFRlYmx1b3JzS2J1b3hBZHlLTlphM09sV1JRSnV1UHFNWVBOIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778509376),
('Br6a2fSmQK79PGQujeiMP0iTGX0jmTLuhaayDtD3', NULL, '216.38.230.125', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiI1OElyQzRWNFRIYjd5MVlrbkpKM2dFYmhHcFhBTkpkMDNRNWJ5NUI1IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778188346),
('cpS5Sg2qjXTYucxufvYXg7IULeTJzRUw3v2Jd8zu', NULL, '2a02:4780:11:c0de::e', 'Go-http-client/2.0', 'eyJfdG9rZW4iOiJhNEhCTEhpenNRNUN2UUI0Y0JEaUNNV1JMNWs2TENaeHdDMmpqN0hJIiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1778544510),
('CZwhtZbKqeIPpfZXGXJB7TCxy841QqU2mpEryy12', NULL, '178.62.83.196', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJHS3hVaW1yMjU5VHB4c3JDUE1nTkFKRzNRY21BdUcwdkpMTFVEVHVRIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778113857),
('g74zWUDC5MqmA9pq5XO1tNTIwTyvBr9brIcfs1Qf', NULL, '69.17.115.90', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJmMDRYWWpnemNZS3RLMkNKYVdkc1RDRXd1N044djU2cmxUZzdXWXB1IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778509379),
('Gg5cCPUFI4frL2rNn3OfohimdhQRdmdTcWMxXAuO', NULL, '193.32.248.249', 'Mozilla/5.0 (Fedora; Linux i686) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/140.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJxTnUzV1U5SWNCelEwTXh0eExSRWpMbEVEelRVMnJhVHg1bVJGQ3pnIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778608107),
('JEQ7gfV7kMIuoxKfPxkS24BtQKV2UCmQhDMk7sR5', NULL, '2a02:4780:11:c0de::e', 'Go-http-client/2.0', 'eyJfdG9rZW4iOiJwYk9UU2RHY3ZpVHRIT0lqOHNORGZueVduZlAwYUhDbnRXZHpGeWY5IiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1778221142),
('JqLctbE2GUaAT5Rh5q5fZCjimtmUBtmierX1BdbS', NULL, '174.138.59.180', 'Mozilla/5.0 (X11; Linux x86_64; rv:142.0) Gecko/20100101 Firefox/142.0', 'eyJfdG9rZW4iOiJDUmdTZ3c2QmNYSmN0Z09aVUFKRldFRnVVandzUTZNVGVNc2poQ05qIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778657076),
('LgcQANMbJE7f9a6OR9lLRatWsz8ZKxhtIq1Kw0v2', NULL, '149.57.180.184', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/119.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJhcDdRVkdNUDRVWVBoMHVzWkZ0clo4MllOMGNFdGRXOEYxRHR5VDJzIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778424820),
('Q2X2seeFgUvGPcgBJlUSnnV5KtdDiSZsJYZ2Mnd3', NULL, '35.208.177.163', 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/135.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiJlS2NXSnpQczYxeFFvZ05sNDdhTnNXazYyTk5GOHJITTFNdVFMWFU5IiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778660283),
('QhgG0i9j6xwTMxsu8CZLHJLGAieO5Fpbs7It42ey', NULL, '2a02:4780:11:c0de::e', 'Go-http-client/2.0', 'eyJfdG9rZW4iOiI5WHJJNGVXc3pOSGFOQTRvdTBWU0o2UFU0eW16aERSSGE0cHdRUmwxIiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1778665612),
('sCbnMDbydynPm7fC7o7gtTcrrtz3J1RqmN0YRIW7', NULL, '108.131.23.161', 'Mozilla/5.0 (compatible; NetcraftSurveyAgent/1.0; +info@netcraft.com)', 'eyJfdG9rZW4iOiJkSWgxQ1pIMDQ5NWU0M1d4WTJDR2xSaXdlWmlCaVdBbzJIRkdVNzJhIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778510078),
('SQmpGrsM3Ql5eweyVhdGV8E8zNUVrRHUn7AgtQA5', NULL, '23.27.145.40', 'Mozilla/5.0 (X11; Linux i686; rv:109.0) Gecko/20100101 Firefox/120.0', 'eyJfdG9rZW4iOiJFZTVJcGlSdFEzUjU2T1RFb0JEVHFydDVibGZ3d1hydU8yWjl5RndtIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778418227),
('tZy5cwMX8hfe4lcCGivXfCraHQb65LXyeNvQWsxu', NULL, '2a02:4780:11:c0de::e', 'Go-http-client/2.0', 'eyJfdG9rZW4iOiJ0WjRQT0pvYUN6QVJiN2VuWXFZc29oNTdhYzE5eWZuWmRMUVNDRkxFIiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1778329799),
('VIxWqVgzEEUrdPhLddbpeytibuoUR0bCmP6ruD7R', NULL, '2a02:4780:11:c0de::e', 'Go-http-client/2.0', 'eyJfdG9rZW4iOiJxdDF4dnN0ZExUWXcwZGx5c3FjbnNrODlKUTJ5aklubm1pck5XT21xIiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1778393614),
('w3TF0hxzaOwtGJyMTNFCqDvhnCfwXRBA6JuDMFiU', NULL, '2a02:4780:11:c0de::e', 'Go-http-client/2.0', 'eyJfdG9rZW4iOiJiQ3dvS2FHTXhwRU1ZMjdYSWtqOXltQnp1T3BJVk9ja2pCREpmSlhUIiwiX2ZsYXNoIjp7Im9sZCI6W10sIm5ldyI6W119fQ==', 1778757389),
('wlN4vFkO42MaIbMSQbQEdRwnS6i9yoOrtC1MjJJo', NULL, '54.152.28.140', 'Mozilla/5.0 (X11; Linux x86_64; rv:130.0) Gecko/20100101 Firefox/130.0', 'eyJfdG9rZW4iOiJ2b3FxNFlMQjRvdk5oWUxtdXc4TU9abmZPdTZkTUhtMjdCRHUwb2gwIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpacWJtUXI4ZHBVWGdZMGVEIn0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778036664),
('yhnShv25OpqdtxWGscGrjVgwwZK9Rgf9rRWJHSCg', NULL, '69.17.115.90', 'Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/147.0.0.0 Mobile Safari/537.36', 'eyJfdG9rZW4iOiJCdzdmUzJuMXFtdUlhSUZHTndXQVRvY2tpdUxkalV5dDJDMHlwUlJpIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778509375),
('yUP8rW5EaTKsfV1Ad8QbsrVIuPUEmjv7C0RQqT5D', NULL, '167.172.169.53', 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', 'eyJfdG9rZW4iOiIwNTJVWklUVGxHZ2o3TnZlcFRvS05rN0hpRkR4YTdEUXhmeldEMlhlIiwiX3ByZXZpb3VzIjp7InVybCI6Imh0dHBzOlwvXC9hcGktZmFtaWx5dHJlZS5raGFqYW15bnVkZGluLmNvbSIsInJvdXRlIjoiZ2VuZXJhdGVkOjpIWGNqV0QwNEs0TjNPbmd0In0sIl9mbGFzaCI6eyJvbGQiOltdLCJuZXciOltdfX0=', 1778289074);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `name` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `email_verified_at` timestamp NULL DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('super_admin','admin','user') NOT NULL DEFAULT 'user',
  `family_id` bigint(20) UNSIGNED DEFAULT NULL,
  `approval_status` varchar(32) NOT NULL DEFAULT 'approved',
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `remember_token` varchar(100) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `name`, `email`, `phone`, `email_verified_at`, `password`, `role`, `family_id`, `approval_status`, `is_active`, `remember_token`, `created_at`, `updated_at`) VALUES
(1, 'Super Admin', 'superadmin@familytree.test', NULL, NULL, '$2y$12$a84MgYu1AjxARjwADyOJY.2lfvHeT0wK/A8QNmgi5d6xx4A5b0.SO', 'super_admin', NULL, 'approved', 1, NULL, '2026-04-26 13:17:11', '2026-05-06 04:16:18'),
(15, 'Ruhi Ahmad', 'ruhiahmadsayeda@gmail.com', '+919059797297', NULL, '$2y$12$hm5rYiMnUZs8qq3XoXkl1.Io5C4nDbNcwg/C.xlICIEWBXCVQgMPu', 'user', 3, 'approved', 1, NULL, '2026-05-01 14:04:47', '2026-05-04 05:49:14'),
(19, 'SHAIK KHAJA MYNUDDIN', 'smartworldcom@gmail.com', '+918121990714', NULL, '$2y$12$u2GX0giQUBNpeCWanSkKWu4YbNZ3a5DWRe6rDtgg3EHlYEHqIz9Nq', 'user', 3, 'approved', 1, NULL, '2026-05-01 16:03:21', '2026-05-01 16:04:06'),
(20, 'Syed Nasreen Fathima', 'nasreen1057@gmail.com', '9390797705', NULL, '$2y$12$yHYOltfB91Qr9t9tG5RJBOAHnUEeZyN6k3nEHc78zCoFPVwVJ7L2G', 'user', 3, 'approved', 1, NULL, '2026-05-01 16:56:16', '2026-05-01 16:57:38'),
(21, 'Sirajuddin', 'afsiraj@gmail.com', '9848283859', NULL, '$2y$12$PYTfAvfkLp4kK4G.kqU6yu3RcEvxarlKw/RfY4Uzr4S3Cnjel5gEa', 'admin', 3, 'approved', 1, NULL, '2026-05-03 11:07:54', '2026-05-04 05:47:21'),
(22, 'pathan adil khan', 'pathanadil2004@gmail.com', '+918639943613', NULL, '$2y$12$V0AHE/QcTXSoKQc/wNRegOPf9mDSdnC9YODq0GSugS5AYbxWwKbbS', 'user', NULL, 'pending', 1, NULL, '2026-05-03 19:55:24', '2026-05-04 13:19:23'),
(23, 'SHAIK MUJAHID AKRAM', 'smujahidakram@gmail.com', '7013786131', NULL, '$2y$12$3TWrXCYw1VGDPKcU/qBtMOXXk4U6GDNpIDmbWhvLNx4He4usxRzvK', 'user', 3, 'pending', 1, NULL, '2026-05-07 08:39:51', '2026-05-07 08:41:02');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `audit_trails`
--
ALTER TABLE `audit_trails`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_trails_user_id_created_at_index` (`user_id`,`created_at`),
  ADD KEY `audit_trails_family_id_created_at_index` (`family_id`,`created_at`),
  ADD KEY `audit_trails_event_created_at_index` (`event`,`created_at`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_expiration_index` (`expiration`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`),
  ADD KEY `cache_locks_expiration_index` (`expiration`);

--
-- Indexes for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Indexes for table `families`
--
ALTER TABLE `families`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `families_slug_unique` (`slug`),
  ADD KEY `families_created_by_foreign` (`created_by`);

--
-- Indexes for table `family_connection_requests`
--
ALTER TABLE `family_connection_requests`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `family_connection_requests_user_id_unique` (`user_id`),
  ADD KEY `family_connection_requests_family_id_foreign` (`family_id`),
  ADD KEY `family_connection_requests_anchor_member_id_foreign` (`anchor_member_id`),
  ADD KEY `family_connection_requests_claimed_member_id_foreign` (`claimed_member_id`),
  ADD KEY `family_connection_requests_resolved_by_foreign` (`resolved_by`),
  ADD KEY `family_connection_requests_status_index` (`status`);

--
-- Indexes for table `family_members`
--
ALTER TABLE `family_members`
  ADD PRIMARY KEY (`id`),
  ADD KEY `family_members_family_id_foreign` (`family_id`),
  ADD KEY `family_members_user_id_foreign` (`user_id`),
  ADD KEY `family_members_created_by_foreign` (`created_by`),
  ADD KEY `family_members_family_head_id_foreign` (`family_head_id`);

--
-- Indexes for table `family_relationships`
--
ALTER TABLE `family_relationships`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `family_relationship_unique` (`family_id`,`from_member_id`,`to_member_id`,`relationship_type`),
  ADD KEY `family_relationships_from_member_id_foreign` (`from_member_id`),
  ADD KEY `family_relationships_to_member_id_foreign` (`to_member_id`),
  ADD KEY `family_relationships_created_by_foreign` (`created_by`);

--
-- Indexes for table `feedback_submissions`
--
ALTER TABLE `feedback_submissions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `feedback_submissions_user_id_foreign` (`user_id`),
  ADD KEY `feedback_submissions_family_id_foreign` (`family_id`),
  ADD KEY `feedback_submissions_status_index` (`status`);

--
-- Indexes for table `households`
--
ALTER TABLE `households`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `households_couple_unique` (`family_id`,`primary_person_id`,`spouse_person_id`),
  ADD KEY `households_primary_person_id_foreign` (`primary_person_id`),
  ADD KEY `households_spouse_person_id_foreign` (`spouse_person_id`),
  ADD KEY `households_created_by_foreign` (`created_by`),
  ADD KEY `households_family_id_name_index` (`family_id`,`name`);

--
-- Indexes for table `household_members`
--
ALTER TABLE `household_members`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `household_members_unique` (`household_id`,`member_id`),
  ADD KEY `household_members_created_by_foreign` (`created_by`),
  ADD KEY `household_members_member_id_role_index` (`member_id`,`role`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `job_batches`
--
ALTER TABLE `job_batches`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Indexes for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`),
  ADD KEY `personal_access_tokens_expires_at_index` (`expires_at`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_email_unique` (`email`),
  ADD KEY `users_role_index` (`role`),
  ADD KEY `users_is_active_index` (`is_active`),
  ADD KEY `users_family_id_foreign` (`family_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `audit_trails`
--
ALTER TABLE `audit_trails`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=316;

--
-- AUTO_INCREMENT for table `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `families`
--
ALTER TABLE `families`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `family_connection_requests`
--
ALTER TABLE `family_connection_requests`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `family_members`
--
ALTER TABLE `family_members`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=130;

--
-- AUTO_INCREMENT for table `family_relationships`
--
ALTER TABLE `family_relationships`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=188;

--
-- AUTO_INCREMENT for table `feedback_submissions`
--
ALTER TABLE `feedback_submissions`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=67;

--
-- AUTO_INCREMENT for table `households`
--
ALTER TABLE `households`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `household_members`
--
ALTER TABLE `household_members`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=92;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=225;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `audit_trails`
--
ALTER TABLE `audit_trails`
  ADD CONSTRAINT `audit_trails_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `families`
--
ALTER TABLE `families`
  ADD CONSTRAINT `families_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `family_connection_requests`
--
ALTER TABLE `family_connection_requests`
  ADD CONSTRAINT `family_connection_requests_anchor_member_id_foreign` FOREIGN KEY (`anchor_member_id`) REFERENCES `family_members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `family_connection_requests_claimed_member_id_foreign` FOREIGN KEY (`claimed_member_id`) REFERENCES `family_members` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `family_connection_requests_family_id_foreign` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `family_connection_requests_resolved_by_foreign` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `family_connection_requests_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `family_members`
--
ALTER TABLE `family_members`
  ADD CONSTRAINT `family_members_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `family_members_family_head_id_foreign` FOREIGN KEY (`family_head_id`) REFERENCES `family_members` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `family_members_family_id_foreign` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `family_members_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `family_relationships`
--
ALTER TABLE `family_relationships`
  ADD CONSTRAINT `family_relationships_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `family_relationships_family_id_foreign` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `family_relationships_from_member_id_foreign` FOREIGN KEY (`from_member_id`) REFERENCES `family_members` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `family_relationships_to_member_id_foreign` FOREIGN KEY (`to_member_id`) REFERENCES `family_members` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `feedback_submissions`
--
ALTER TABLE `feedback_submissions`
  ADD CONSTRAINT `feedback_submissions_family_id_foreign` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `feedback_submissions_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `households`
--
ALTER TABLE `households`
  ADD CONSTRAINT `households_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `households_family_id_foreign` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `households_primary_person_id_foreign` FOREIGN KEY (`primary_person_id`) REFERENCES `family_members` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `households_spouse_person_id_foreign` FOREIGN KEY (`spouse_person_id`) REFERENCES `family_members` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `household_members`
--
ALTER TABLE `household_members`
  ADD CONSTRAINT `household_members_created_by_foreign` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `household_members_household_id_foreign` FOREIGN KEY (`household_id`) REFERENCES `households` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `household_members_member_id_foreign` FOREIGN KEY (`member_id`) REFERENCES `family_members` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_family_id_foreign` FOREIGN KEY (`family_id`) REFERENCES `families` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
