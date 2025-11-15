-- phpMyAdmin SQL Dump
-- version 5.2.2
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Nov 12, 2025 at 12:52 PM
-- Server version: 8.0.30
-- PHP Version: 8.2.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ciptastok_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `divisi`
--

CREATE TABLE `divisi` (
  `divisi_id` int NOT NULL,
  `nama_divisi` varchar(100) NOT NULL,
  `kode_divisi` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `divisi`
--

INSERT INTO `divisi` (`divisi_id`, `nama_divisi`, `kode_divisi`) VALUES
(1, 'COFFEE', 'MU245'),
(2, 'CANDY', 'CWC');

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `kategori_id` int NOT NULL,
  `nama_kategori` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `opname_assignment`
--

CREATE TABLE `opname_assignment` (
  `assignment_id` int NOT NULL,
  `batch_id` int NOT NULL,
  `user_id` int NOT NULL,
  `divisi_id` int NOT NULL,
  `status_assignment` enum('Pending','In Progress','Submitted','Approved','Rejected') DEFAULT 'Pending',
  `assigned_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `submitted_at` timestamp NULL DEFAULT NULL,
  `approved_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `opname_assignment`
--

INSERT INTO `opname_assignment` (`assignment_id`, `batch_id`, `user_id`, `divisi_id`, `status_assignment`, `assigned_at`, `submitted_at`, `approved_at`) VALUES
(5, 4, 3, 2, 'Approved', '2025-11-06 17:02:49', NULL, '2025-11-06 17:24:23'),
(7, 19, 3, 2, 'Pending', '2025-11-07 12:44:35', NULL, NULL),
(8, 20, 3, 2, 'Pending', '2025-11-07 12:46:33', NULL, NULL),
(9, 21, 3, 2, 'Pending', '2025-11-07 18:49:39', NULL, NULL),
(10, 21, 4, 1, 'Pending', '2025-11-07 18:49:39', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `opname_batch`
--

CREATE TABLE `opname_batch` (
  `batch_id` int NOT NULL,
  `nama_batch` varchar(255) NOT NULL,
  `created_by` int NOT NULL,
  `status_overall` enum('Draft','In Progress','Completed') DEFAULT 'Draft',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `tipe_opname` enum('WH01','WH02','WH03') NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `opname_batch`
--

INSERT INTO `opname_batch` (`batch_id`, `nama_batch`, `created_by`, `status_overall`, `created_at`, `tipe_opname`) VALUES
(4, 'IELTS', 1, 'Completed', '2025-11-06 17:02:49', 'WH01'),
(19, 'IELTS2', 1, 'In Progress', '2025-11-07 12:44:35', 'WH01'),
(20, 'asa', 1, 'In Progress', '2025-11-07 12:46:33', 'WH01'),
(21, 'RRR', 1, 'In Progress', '2025-11-07 18:49:39', 'WH01');

-- --------------------------------------------------------

--
-- Table structure for table `opname_details_wh01`
--

CREATE TABLE `opname_details_wh01` (
  `detail_id` int NOT NULL,
  `assignment_id` int NOT NULL,
  `produk_id` int NOT NULL,
  `pcode` varchar(100) DEFAULT NULL,
  `nama_barang` varchar(255) DEFAULT NULL,
  `sistem_karton` int DEFAULT NULL,
  `sistem_tengah` int DEFAULT NULL,
  `sistem_pieces` int DEFAULT NULL,
  `sistem_exp_date` date DEFAULT NULL,
  `fisik_karton` int DEFAULT NULL,
  `fisik_tengah` int DEFAULT NULL,
  `fisik_pieces` int DEFAULT NULL,
  `fisik_exp_date` date DEFAULT NULL,
  `opname_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `opname_details_wh01`
--

INSERT INTO `opname_details_wh01` (`detail_id`, `assignment_id`, `produk_id`, `pcode`, `nama_barang`, `sistem_karton`, `sistem_tengah`, `sistem_pieces`, `sistem_exp_date`, `fisik_karton`, `fisik_tengah`, `fisik_pieces`, `fisik_exp_date`, `opname_at`) VALUES
(74, 5, 39, '410049', 'FRUTA GUMMY 6GBX10SCX25G', 22, 0, 0, NULL, 22, NULL, NULL, NULL, NULL),
(75, 7, 39, '410049', 'FRUTA GUMMY 6GBX10SCX25G', 22, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL),
(76, 7, 43, '112121', 'FRUTA GUMMY aja', 100, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL),
(78, 8, 39, '410049', 'FRUTA GUMMY 6GBX10SCX25G', 22, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL),
(79, 8, 43, '112121', 'FRUTA GUMMY aja', 100, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL),
(81, 9, 39, '410049', 'FRUTA GUMMY 6GBX10SCX25G', 22, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL),
(82, 9, 43, '112121', 'FRUTA GUMMY aja', 100, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL),
(84, 10, 13, '520156', 'TORABIKA DUO 10X100G', 156, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `opname_details_wh02`
--

CREATE TABLE `opname_details_wh02` (
  `detail_id` int NOT NULL,
  `assignment_id` int NOT NULL,
  `produk_id` int NOT NULL,
  `nomor_koli` int NOT NULL,
  `fisik_pcs` int NOT NULL,
  `opname_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `opname_details_wh03`
--

CREATE TABLE `opname_details_wh03` (
  `detail_id` int NOT NULL,
  `assignment_id` int NOT NULL,
  `produk_id` int NOT NULL,
  `pcode` varchar(100) DEFAULT NULL,
  `nama_barang` varchar(255) DEFAULT NULL,
  `sistem_total_pcs` int DEFAULT NULL,
  `fisik_total_pcs` int DEFAULT NULL,
  `opname_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Table structure for table `produk`
--

CREATE TABLE `produk` (
  `produk_id` int NOT NULL,
  `pcode` varchar(100) NOT NULL,
  `nama_barang` varchar(255) NOT NULL,
  `barcode` varchar(255) DEFAULT NULL,
  `divisi_id` int DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `produk`
--

INSERT INTO `produk` (`produk_id`, `pcode`, `nama_barang`, `barcode`, `divisi_id`, `updated_at`) VALUES
(1, 'PCODE-A1', 'KOPIKO COFFEE CANDY 6JARX612.5G', NULL, 2, '2025-11-01 13:33:44'),
(2, 'PCODE-B2', 'FRUTA GUMMY 6GBX10SCX25G', NULL, 2, '2025-11-01 13:33:44'),
(3, 'PCODE-C3', 'Produk C (Pending)', '33333', 1, '2025-11-01 13:33:44'),
(5, '630247', 'SILVERQUEEN CHUNKY BAR 24X100G', NULL, 1, '2025-10-31 14:51:25'),
(6, '776248', 'TANGO WAFER COKLAT 60X47G', NULL, 2, '2025-10-31 13:54:32'),
(7, '886359', 'ROMA KELAPA 30X300G', NULL, 2, '2025-10-31 13:54:32'),
(8, '763137', 'BENG BENG MAXX 24X31G', NULL, 1, '2025-10-31 14:51:25'),
(9, '874248', 'GOOD TIME CHOCOCHIP 48X80G', NULL, 1, '2025-10-31 14:51:25'),
(13, '520156', 'TORABIKA DUO 10X100G', NULL, 1, '2025-11-06 17:00:53'),
(15, '740358', 'MOLTO ULTRA SEKALI BILAS 12X800ML', NULL, 1, '2025-10-31 14:51:25'),
(16, '850469', 'SUNLIGHT JERUK NIPIS 24X800ML', NULL, 1, '2025-10-31 14:51:25'),
(17, '960571', 'PEPSODENT WHITENING 12X190G', NULL, 1, '2025-10-31 14:51:25'),
(18, '115682', 'MINYAK GORENG BIMOLI 12X2L', NULL, 1, '2025-10-31 14:51:25'),
(19, '225793', 'GULA PASIR GULAKU 20X1KG', NULL, 1, '2025-10-31 14:51:25'),
(20, '335804', 'KOPI KAPAL API SPECIAL 24X165G', NULL, 1, '2025-10-31 14:51:25'),
(21, '445915', 'RINSO ANTI NODA 12X800G', NULL, 2, '2025-10-31 14:51:25'),
(22, '556026', 'LIFEBUOY SABUN BATANG 72X85G', NULL, 2, '2025-10-31 14:51:25'),
(23, '666137', 'AQUA BOTOL 48X600ML', NULL, 2, '2025-10-31 14:51:25'),
(26, '996460', 'BERAS PREMIUM 5KG', NULL, 2, '2025-10-31 14:51:25'),
(27, '107571', 'DANCOW FORTIGRO 12X800G', NULL, 1, '2025-10-31 14:51:25'),
(28, '218682', 'SUSU SGM 3+ 6X900G', NULL, 1, '2025-10-31 14:51:25'),
(29, '329793', 'PAMPERS POPOK BAYI L 6X34S', NULL, 1, '2025-10-31 14:51:25'),
(30, '430804', 'CUSSONS BABY POWDER 24X100G', NULL, 1, '2025-10-31 14:51:25'),
(31, '541915', 'ENERGEN VANILLA 10X10SCX30G', NULL, 1, '2025-10-31 14:51:25'),
(32, '652026', 'MIE SEDAAP GORENG 40X89G', NULL, 1, '2025-10-31 14:51:25'),
(35, '985359', 'REXONA ROLL ON MEN 24X45ML', NULL, 1, '2025-10-31 14:51:25'),
(36, '196460', 'DOWNY PARFUM COLLECTION 12X900ML', NULL, 1, '2025-10-31 14:51:25'),
(37, '207571', 'SUNSILK SHAMPOO HIJAB 24X170ML', NULL, 1, '2025-10-31 14:51:25'),
(38, '318682', 'TEH PUCUK HARUM 24X350ML', NULL, 1, '2025-10-31 14:51:25'),
(39, '410049', 'FRUTA GUMMY 6GBX10SCX25G', NULL, 2, '2025-11-06 17:00:53'),
(43, '112121', 'FRUTA GUMMY aja', NULL, 2, '2025-11-07 12:11:40');

-- --------------------------------------------------------

--
-- Table structure for table `rak`
--

CREATE TABLE `rak` (
  `rak_id` int NOT NULL,
  `nomor_rak` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `rak`
--

INSERT INTO `rak` (`rak_id`, `nomor_rak`) VALUES
(1, 'A-01');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `role_id` int NOT NULL,
  `nama_role` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`role_id`, `nama_role`) VALUES
(1, 'Admin'),
(2, 'User');

-- --------------------------------------------------------

--
-- Table structure for table `stok_wh01`
--

CREATE TABLE `stok_wh01` (
  `stok_id` int NOT NULL,
  `produk_id` int NOT NULL,
  `sistem_karton` int DEFAULT '0',
  `sistem_tengah` int DEFAULT '0',
  `sistem_pieces` int DEFAULT '0',
  `expired_date` date DEFAULT NULL,
  `rak_id` int DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `stok_wh01`
--

INSERT INTO `stok_wh01` (`stok_id`, `produk_id`, `sistem_karton`, `sistem_tengah`, `sistem_pieces`, `expired_date`, `rak_id`, `is_active`, `updated_at`) VALUES
(3, 3, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(4, 4, 22, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(9, 9, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(10, 10, 198, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(11, 11, 76, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(12, 12, 256, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(13, 13, 156, 0, 0, NULL, NULL, 1, '2025-11-07 11:55:59'),
(14, 1, 10, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(15, 2, 5, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(18, 5, 80, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(19, 6, 198, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(20, 7, 76, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(21, 8, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(28, 15, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(29, 16, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(30, 17, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(31, 18, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(32, 19, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(33, 20, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(34, 21, 92, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(35, 22, 145, 33, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(36, 23, 289, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(39, 26, 54, 0, 2, NULL, NULL, 0, '2025-11-06 17:00:53'),
(40, 27, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(41, 28, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(42, 29, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(43, 30, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(44, 31, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(45, 32, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(48, 35, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(49, 36, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(50, 37, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(51, 38, 0, 0, 0, NULL, NULL, 0, '2025-11-06 17:00:53'),
(55, 39, 22, 0, 0, NULL, NULL, 1, '2025-11-07 11:55:59'),
(59, 43, 100, 0, 0, NULL, NULL, 1, '2025-11-07 12:11:40');

-- --------------------------------------------------------

--
-- Table structure for table `stok_wh02`
--

CREATE TABLE `stok_wh02` (
  `stok_id` int NOT NULL,
  `produk_id` int NOT NULL,
  `sistem_total_pcs` int DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `stok_wh02`
--

INSERT INTO `stok_wh02` (`stok_id`, `produk_id`, `sistem_total_pcs`, `is_active`, `updated_at`) VALUES
(3, 43, 0, 1, '2025-11-07 12:11:40');

-- --------------------------------------------------------

--
-- Table structure for table `stok_wh03`
--

CREATE TABLE `stok_wh03` (
  `stok_id` int NOT NULL,
  `produk_id` int NOT NULL,
  `sistem_total_pcs` int DEFAULT '0',
  `is_active` tinyint(1) NOT NULL DEFAULT '1',
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `stok_wh03`
--

INSERT INTO `stok_wh03` (`stok_id`, `produk_id`, `sistem_total_pcs`, `is_active`, `updated_at`) VALUES
(2, 43, 0, 1, '2025-11-07 12:11:40');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int NOT NULL,
  `nama_lengkap` varchar(255) NOT NULL,
  `username` varchar(100) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role_id` int NOT NULL,
  `divisi_id` int DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `nama_lengkap`, `username`, `password_hash`, `role_id`, `divisi_id`, `is_active`, `created_at`) VALUES
(1, 'Herdi Mismuri', 'herdi', '$2b$10$cO/T2nAjEXjphVLNWSOTme/r1BuP3DBfSkLk/0H6AMjWrVFUTea4O', 1, NULL, 1, '2025-10-28 16:59:59'),
(2, 'Yopi Maulana', 'yopi', '$2b$10$nP6IidLS6woBqMvb.Knze.V./u64AFr5A/tnuPo4Tr9qyQfERi6Yi', 2, 1, 1, '2025-10-31 15:04:26'),
(3, 'Adi Supriadi', 'adi', '$2b$10$nP6IidLS6woBqMvb.Knze.V./u64AFr5A/tnuPo4Tr9qyQfERi6Yi', 2, 2, 1, '2025-10-31 15:04:26'),
(4, 'Joko', 'Joko', '$2b$10$y34vClxxxFyeDM5VPR6uQ.5/mSIIoVaNnQ1artwkZasc/DPwMtvYC', 2, 1, 1, '2025-11-05 13:47:38');

-- --------------------------------------------------------

--
-- Table structure for table `user_logs`
--

CREATE TABLE `user_logs` (
  `log_id` int NOT NULL,
  `user_id` int NOT NULL,
  `aktivitas` varchar(50) COLLATE utf8mb4_unicode_ci NOT NULL COMMENT 'login, logout, dll',
  `ip_address` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT 'IP address user',
  `waktu` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Log aktivitas user';

--
-- Dumping data for table `user_logs`
--

INSERT INTO `user_logs` (`log_id`, `user_id`, `aktivitas`, `ip_address`, `waktu`) VALUES
(1, 1, 'login', '::1', '2025-11-08 22:41:13'),
(2, 1, 'login', '::1', '2025-11-09 00:43:19'),
(3, 1, 'login', '::1', '2025-11-09 00:45:33'),
(4, 1, 'login', '::1', '2025-11-09 01:05:29'),
(5, 1, 'login', '::1', '2025-11-09 01:06:43'),
(6, 1, 'login', '::1', '2025-11-09 01:15:31'),
(7, 1, 'login', '::1', '2025-11-09 01:44:31'),
(8, 1, 'login', '::1', '2025-11-09 08:38:39'),
(9, 1, 'login', '::1', '2025-11-09 09:43:32'),
(10, 1, 'login', '::1', '2025-11-09 09:46:42'),
(11, 1, 'login', '::1', '2025-11-10 20:17:13'),
(12, 1, 'login', '::1', '2025-11-10 20:18:16'),
(13, 1, 'login', '::1', '2025-11-10 21:40:20'),
(14, 1, 'login', '::1', '2025-11-11 20:02:05'),
(15, 1, 'login', '::1', '2025-11-11 20:04:36'),
(16, 1, 'login', '::1', '2025-11-12 00:52:13'),
(17, 1, 'login', '::1', '2025-11-12 01:11:39'),
(18, 1, 'login', '::1', '2025-11-12 01:12:00'),
(19, 1, 'login', '::1', '2025-11-12 01:12:03'),
(20, 1, 'login', '::1', '2025-11-12 01:12:05'),
(21, 1, 'login', '::1', '2025-11-12 01:12:07'),
(22, 1, 'login', '::1', '2025-11-12 01:12:08'),
(23, 1, 'login', '::1', '2025-11-12 01:12:09'),
(24, 1, 'login', '::1', '2025-11-12 01:12:18'),
(25, 1, 'login', '::1', '2025-11-12 01:12:19'),
(26, 1, 'login', '::1', '2025-11-12 01:12:54'),
(27, 1, 'login', '::1', '2025-11-12 01:13:17'),
(28, 1, 'login', '::1', '2025-11-12 01:13:23'),
(29, 1, 'login', '::1', '2025-11-12 01:13:28'),
(30, 1, 'login', '::1', '2025-11-12 01:13:33'),
(31, 1, 'login', '::1', '2025-11-12 01:13:47'),
(32, 1, 'login', '::1', '2025-11-12 01:13:57'),
(33, 1, 'login', '::1', '2025-11-12 01:14:28'),
(34, 1, 'login', '::1', '2025-11-12 01:14:39'),
(35, 1, 'login', '::1', '2025-11-12 01:14:55'),
(36, 1, 'login', '::1', '2025-11-12 01:15:14'),
(37, 1, 'login', '::1', '2025-11-12 01:15:25'),
(38, 1, 'login', '::1', '2025-11-12 01:15:27'),
(39, 1, 'login', '::1', '2025-11-12 01:15:31'),
(40, 1, 'login', '::1', '2025-11-12 01:16:43'),
(41, 1, 'login', '::1', '2025-11-12 01:40:06'),
(42, 1, 'login', '::1', '2025-11-12 01:55:57'),
(43, 1, 'login', '::1', '2025-11-12 18:24:55'),
(44, 1, 'login', '::1', '2025-11-12 19:48:24');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `divisi`
--
ALTER TABLE `divisi`
  ADD PRIMARY KEY (`divisi_id`),
  ADD UNIQUE KEY `kode_divisi` (`kode_divisi`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`kategori_id`);

--
-- Indexes for table `opname_assignment`
--
ALTER TABLE `opname_assignment`
  ADD PRIMARY KEY (`assignment_id`),
  ADD KEY `batch_id` (`batch_id`),
  ADD KEY `user_id` (`user_id`),
  ADD KEY `divisi_id` (`divisi_id`);

--
-- Indexes for table `opname_batch`
--
ALTER TABLE `opname_batch`
  ADD PRIMARY KEY (`batch_id`),
  ADD KEY `created_by` (`created_by`);

--
-- Indexes for table `opname_details_wh01`
--
ALTER TABLE `opname_details_wh01`
  ADD PRIMARY KEY (`detail_id`),
  ADD KEY `assignment_id` (`assignment_id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `opname_details_wh02`
--
ALTER TABLE `opname_details_wh02`
  ADD PRIMARY KEY (`detail_id`),
  ADD UNIQUE KEY `unique_opname_koli` (`assignment_id`,`produk_id`,`nomor_koli`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `opname_details_wh03`
--
ALTER TABLE `opname_details_wh03`
  ADD PRIMARY KEY (`detail_id`),
  ADD UNIQUE KEY `assignment_id` (`assignment_id`,`produk_id`),
  ADD KEY `produk_id` (`produk_id`);

--
-- Indexes for table `produk`
--
ALTER TABLE `produk`
  ADD PRIMARY KEY (`produk_id`),
  ADD UNIQUE KEY `pcode` (`pcode`),
  ADD KEY `divisi_id` (`divisi_id`);

--
-- Indexes for table `rak`
--
ALTER TABLE `rak`
  ADD PRIMARY KEY (`rak_id`),
  ADD UNIQUE KEY `nomor_rak` (`nomor_rak`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`role_id`),
  ADD UNIQUE KEY `nama_role` (`nama_role`);

--
-- Indexes for table `stok_wh01`
--
ALTER TABLE `stok_wh01`
  ADD PRIMARY KEY (`stok_id`),
  ADD UNIQUE KEY `produk_id` (`produk_id`),
  ADD KEY `rak_id` (`rak_id`);

--
-- Indexes for table `stok_wh02`
--
ALTER TABLE `stok_wh02`
  ADD PRIMARY KEY (`stok_id`),
  ADD UNIQUE KEY `produk_id` (`produk_id`);

--
-- Indexes for table `stok_wh03`
--
ALTER TABLE `stok_wh03`
  ADD PRIMARY KEY (`stok_id`),
  ADD UNIQUE KEY `produk_id` (`produk_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `username` (`username`),
  ADD KEY `role_id` (`role_id`),
  ADD KEY `divisi_id` (`divisi_id`);

--
-- Indexes for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_user_waktu` (`user_id`,`waktu`),
  ADD KEY `idx_waktu` (`waktu` DESC);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `divisi`
--
ALTER TABLE `divisi`
  MODIFY `divisi_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `kategori_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `opname_assignment`
--
ALTER TABLE `opname_assignment`
  MODIFY `assignment_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `opname_batch`
--
ALTER TABLE `opname_batch`
  MODIFY `batch_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `opname_details_wh01`
--
ALTER TABLE `opname_details_wh01`
  MODIFY `detail_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=85;

--
-- AUTO_INCREMENT for table `opname_details_wh02`
--
ALTER TABLE `opname_details_wh02`
  MODIFY `detail_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `opname_details_wh03`
--
ALTER TABLE `opname_details_wh03`
  MODIFY `detail_id` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `produk`
--
ALTER TABLE `produk`
  MODIFY `produk_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=44;

--
-- AUTO_INCREMENT for table `rak`
--
ALTER TABLE `rak`
  MODIFY `rak_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `role_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `stok_wh01`
--
ALTER TABLE `stok_wh01`
  MODIFY `stok_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=60;

--
-- AUTO_INCREMENT for table `stok_wh02`
--
ALTER TABLE `stok_wh02`
  MODIFY `stok_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `stok_wh03`
--
ALTER TABLE `stok_wh03`
  MODIFY `stok_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user_logs`
--
ALTER TABLE `user_logs`
  MODIFY `log_id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `opname_assignment`
--
ALTER TABLE `opname_assignment`
  ADD CONSTRAINT `opname_assignment_ibfk_1` FOREIGN KEY (`batch_id`) REFERENCES `opname_batch` (`batch_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `opname_assignment_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  ADD CONSTRAINT `opname_assignment_ibfk_3` FOREIGN KEY (`divisi_id`) REFERENCES `divisi` (`divisi_id`);

--
-- Constraints for table `opname_batch`
--
ALTER TABLE `opname_batch`
  ADD CONSTRAINT `opname_batch_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `opname_details_wh01`
--
ALTER TABLE `opname_details_wh01`
  ADD CONSTRAINT `opname_details_wh01_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `opname_assignment` (`assignment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `opname_details_wh01_ibfk_2` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`);

--
-- Constraints for table `opname_details_wh02`
--
ALTER TABLE `opname_details_wh02`
  ADD CONSTRAINT `opname_details_wh02_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `opname_assignment` (`assignment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `opname_details_wh02_ibfk_2` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`);

--
-- Constraints for table `opname_details_wh03`
--
ALTER TABLE `opname_details_wh03`
  ADD CONSTRAINT `opname_details_wh03_ibfk_1` FOREIGN KEY (`assignment_id`) REFERENCES `opname_assignment` (`assignment_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `opname_details_wh03_ibfk_2` FOREIGN KEY (`produk_id`) REFERENCES `produk` (`produk_id`);

--
-- Constraints for table `produk`
--
ALTER TABLE `produk`
  ADD CONSTRAINT `produk_ibfk_1` FOREIGN KEY (`divisi_id`) REFERENCES `divisi` (`divisi_id`);

--
-- Constraints for table `user_logs`
--
ALTER TABLE `user_logs`
  ADD CONSTRAINT `user_logs_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
