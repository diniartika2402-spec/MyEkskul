-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 16, 2026 at 06:24 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `myekskul`
--

-- --------------------------------------------------------

--
-- Table structure for table `ekskul`
--

CREATE TABLE `ekskul` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `jadwal` varchar(255) DEFAULT NULL,
  `lokasi` varchar(255) DEFAULT NULL,
  `pembina` varchar(255) DEFAULT NULL,
  `status` enum('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ekskul`
--

INSERT INTO `ekskul` (`id`, `nama`, `deskripsi`, `jadwal`, `lokasi`, `pembina`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Futsal', 'Kegiatan olahraga futsal untuk mengembangkan kemampuan dan kerja sama tim.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01'),
(2, 'Basket', 'Kegiatan olahraga basket untuk meningkatkan kemampuan fisik dan kerja sama.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01'),
(3, 'Bulu Tangkis', 'Kegiatan olahraga bulu tangkis untuk meningkatkan kebugaran dan keterampilan.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01'),
(4, 'Seni Tari', 'Kegiatan seni tari untuk mengembangkan kreativitas dan ekspresi.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01'),
(5, 'Musik', 'Kegiatan musik untuk mengembangkan kemampuan bermusik dan kreativitas.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01'),
(6, 'Coding', 'Kegiatan pemrograman dan pengembangan kemampuan teknologi.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01'),
(7, 'Desain Grafis', 'Kegiatan desain grafis dan pengembangan kreativitas digital.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01'),
(8, 'Pramuka', 'Kegiatan kepemimpinan, kedisiplinan, dan kerja sama.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01'),
(9, 'OSIS', 'Kegiatan organisasi dan kepemimpinan siswa.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01'),
(10, 'Karya Ilmiah Remaja', 'Kegiatan penelitian dan pengembangan kemampuan ilmiah siswa.', NULL, NULL, NULL, 'aktif', '2026-10-01 12:50:01', '2026-10-01 12:50:01');

-- --------------------------------------------------------

--
-- Table structure for table `ekskul_dokumentasi`
--

CREATE TABLE `ekskul_dokumentasi` (
  `id` int(10) UNSIGNED NOT NULL,
  `ekskul_id` int(10) UNSIGNED NOT NULL,
  `gambar` varchar(255) NOT NULL,
  `keterangan` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ekskul_dokumentasi`
--

INSERT INTO `ekskul_dokumentasi` (`id`, `ekskul_id`, `gambar`, `keterangan`, `created_at`) VALUES
(1, 1, 'futsal.jpg', 'Dokumentasi kegiatan futsal', '2026-10-01 16:26:08');

-- --------------------------------------------------------

--
-- Table structure for table `ekskul_kategori`
--

CREATE TABLE `ekskul_kategori` (
  `id` int(10) UNSIGNED NOT NULL,
  `ekskul_id` int(10) UNSIGNED NOT NULL,
  `kategori_id` int(10) UNSIGNED NOT NULL,
  `bobot` decimal(8,2) NOT NULL DEFAULT 1.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `ekskul_kategori`
--

INSERT INTO `ekskul_kategori` (`id`, `ekskul_id`, `kategori_id`, `bobot`) VALUES
(1, 1, 1, 1.00),
(2, 2, 1, 1.00),
(3, 3, 1, 1.00),
(4, 4, 2, 1.00),
(5, 5, 2, 1.00),
(6, 6, 3, 1.00),
(7, 7, 3, 1.00),
(8, 8, 4, 1.00),
(9, 9, 4, 1.00),
(10, 10, 5, 1.00);

-- --------------------------------------------------------

--
-- Table structure for table `hasil_rekomendasi`
--

CREATE TABLE `hasil_rekomendasi` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `ekskul_id` int(10) UNSIGNED NOT NULL,
  `skor` decimal(10,2) NOT NULL,
  `peringkat` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hasil_rekomendasi`
--

INSERT INTO `hasil_rekomendasi` (`id`, `user_id`, `ekskul_id`, `skor`, `peringkat`, `created_at`) VALUES
(10, 2, 10, 72.00, 1, '2026-10-01 13:34:59'),
(11, 2, 8, 60.00, 2, '2026-10-01 13:34:59'),
(12, 2, 9, 60.00, 3, '2026-10-01 13:34:59'),
(13, 2, 6, 60.00, 4, '2026-10-01 13:34:59'),
(14, 2, 7, 60.00, 5, '2026-10-01 13:34:59'),
(15, 2, 1, 52.00, 6, '2026-10-01 13:34:59'),
(16, 2, 2, 52.00, 7, '2026-10-01 13:34:59'),
(17, 2, 3, 52.00, 8, '2026-10-01 13:34:59'),
(18, 2, 4, 52.00, 9, '2026-10-01 13:34:59'),
(19, 2, 5, 52.00, 10, '2026-10-01 13:34:59'),
(210, 7, 10, 96.67, 1, '2026-10-16 14:01:00'),
(211, 7, 6, 84.00, 2, '2026-10-16 14:01:00'),
(212, 7, 7, 84.00, 3, '2026-10-16 14:01:00'),
(213, 7, 4, 76.00, 4, '2026-10-16 14:01:00'),
(214, 7, 5, 76.00, 5, '2026-10-16 14:01:00'),
(215, 7, 8, 64.00, 6, '2026-10-16 14:01:00'),
(216, 7, 9, 64.00, 7, '2026-10-16 14:01:00'),
(217, 7, 1, 44.00, 8, '2026-10-16 14:01:00'),
(218, 7, 2, 44.00, 9, '2026-10-16 14:01:00'),
(219, 7, 3, 44.00, 10, '2026-10-16 14:01:00'),
(220, 3, 4, 80.00, 1, '2026-10-16 15:42:50'),
(221, 3, 5, 80.00, 2, '2026-10-16 15:42:50'),
(222, 3, 6, 80.00, 3, '2026-10-16 15:42:50'),
(223, 3, 7, 80.00, 4, '2026-10-16 15:42:50'),
(224, 3, 1, 76.00, 5, '2026-10-16 15:42:50'),
(225, 3, 2, 76.00, 6, '2026-10-16 15:42:50'),
(226, 3, 3, 76.00, 7, '2026-10-16 15:42:50'),
(227, 3, 10, 73.33, 8, '2026-10-16 15:42:50'),
(228, 3, 8, 60.00, 9, '2026-10-16 15:42:50'),
(229, 3, 9, 60.00, 10, '2026-10-16 15:42:50');

-- --------------------------------------------------------

--
-- Table structure for table `jawaban`
--

CREATE TABLE `jawaban` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `pertanyaan_id` int(10) UNSIGNED NOT NULL,
  `nilai` decimal(8,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `jawaban`
--

INSERT INTO `jawaban` (`id`, `user_id`, `pertanyaan_id`, `nilai`, `created_at`) VALUES
(1, 2, 1, 2.00, '2026-09-30 09:12:52'),
(10, 2, 2, 2.00, '2026-10-01 13:34:34'),
(11, 2, 3, 2.00, '2026-10-01 13:34:35'),
(12, 2, 4, 3.00, '2026-10-01 13:34:36'),
(13, 2, 5, 4.00, '2026-10-01 13:34:37'),
(14, 2, 6, 4.00, '2026-10-01 13:34:38'),
(15, 2, 7, 3.00, '2026-10-01 13:34:39'),
(16, 2, 8, 2.00, '2026-10-01 13:34:41'),
(17, 2, 9, 1.00, '2026-10-01 13:34:42'),
(18, 2, 10, 3.00, '2026-10-01 13:34:43'),
(19, 2, 11, 5.00, '2026-10-01 13:34:44'),
(20, 2, 12, 4.00, '2026-10-01 13:34:45'),
(21, 2, 13, 3.00, '2026-10-01 13:34:46'),
(22, 2, 14, 2.00, '2026-10-01 13:34:47'),
(23, 2, 15, 1.00, '2026-10-01 13:34:48'),
(24, 2, 16, 4.00, '2026-10-01 13:34:49'),
(25, 2, 17, 4.00, '2026-10-01 13:34:50'),
(26, 2, 18, 4.00, '2026-10-01 13:34:51'),
(27, 2, 19, 2.00, '2026-10-01 13:34:52'),
(28, 2, 20, 1.00, '2026-10-01 13:34:53'),
(29, 2, 21, 4.00, '2026-10-01 13:34:54'),
(30, 2, 22, 3.00, '2026-10-01 13:34:55'),
(31, 2, 23, 4.00, '2026-10-01 13:34:56'),
(32, 2, 24, 4.00, '2026-10-01 13:34:57'),
(33, 2, 25, 3.00, '2026-10-01 13:34:58'),
(34, 3, 1, 2.00, '2026-10-01 17:04:08'),
(35, 3, 2, 4.00, '2026-10-01 17:04:09'),
(36, 3, 3, 5.00, '2026-10-01 17:04:10'),
(37, 3, 4, 5.00, '2026-10-01 17:04:11'),
(38, 3, 5, 3.00, '2026-10-01 17:04:12'),
(39, 3, 6, 4.00, '2026-10-01 17:04:13'),
(40, 3, 7, 4.00, '2026-10-01 17:04:14'),
(41, 3, 8, 5.00, '2026-10-01 17:04:15'),
(42, 3, 9, 3.00, '2026-10-01 17:04:16'),
(43, 3, 10, 4.00, '2026-10-01 17:04:17'),
(44, 3, 11, 5.00, '2026-10-01 17:04:18'),
(45, 3, 12, 5.00, '2026-10-01 17:04:19'),
(46, 3, 13, 2.00, '2026-10-01 17:04:20'),
(47, 3, 14, 3.00, '2026-10-01 17:04:21'),
(48, 3, 15, 5.00, '2026-10-01 17:04:23'),
(49, 3, 16, 1.00, '2026-10-01 17:04:24'),
(50, 3, 17, 2.00, '2026-10-01 17:04:25'),
(51, 3, 18, 3.00, '2026-10-01 17:04:26'),
(52, 3, 19, 4.00, '2026-10-01 17:04:27'),
(53, 3, 20, 5.00, '2026-10-01 17:04:28'),
(54, 3, 21, 3.00, '2026-10-01 17:04:29'),
(55, 3, 22, 3.00, '2026-10-01 17:04:30'),
(56, 3, 23, 4.00, '2026-10-01 17:04:31'),
(57, 3, 24, 4.00, '2026-10-01 17:04:32'),
(58, 3, 25, 5.00, '2026-10-01 17:04:33'),
(59, 3, 26, 3.00, '2026-10-01 17:04:34'),
(190, 7, 1, 2.00, '2026-10-16 14:00:34'),
(191, 7, 2, 2.00, '2026-10-16 14:00:35'),
(192, 7, 3, 2.00, '2026-10-16 14:00:36'),
(193, 7, 4, 2.00, '2026-10-16 14:00:37'),
(194, 7, 5, 3.00, '2026-10-16 14:00:38'),
(195, 7, 6, 2.00, '2026-10-16 14:00:39'),
(196, 7, 7, 3.00, '2026-10-16 14:00:40'),
(197, 7, 8, 5.00, '2026-10-16 14:00:41'),
(198, 7, 9, 4.00, '2026-10-16 14:00:42'),
(199, 7, 10, 5.00, '2026-10-16 14:00:43'),
(200, 7, 11, 4.00, '2026-10-16 14:00:44'),
(201, 7, 12, 4.00, '2026-10-16 14:00:45'),
(202, 7, 13, 4.00, '2026-10-16 14:00:46'),
(203, 7, 14, 4.00, '2026-10-16 14:00:47'),
(204, 7, 15, 5.00, '2026-10-16 14:00:48'),
(205, 7, 16, 4.00, '2026-10-16 14:00:49'),
(206, 7, 17, 4.00, '2026-10-16 14:00:50'),
(207, 7, 18, 3.00, '2026-10-16 14:00:51'),
(208, 7, 19, 2.00, '2026-10-16 14:00:52'),
(209, 7, 20, 3.00, '2026-10-16 14:00:53'),
(210, 7, 21, 5.00, '2026-10-16 14:00:54'),
(211, 7, 22, 5.00, '2026-10-16 14:00:55'),
(212, 7, 23, 5.00, '2026-10-16 14:00:56'),
(213, 7, 24, 4.00, '2026-10-16 14:00:57'),
(214, 7, 25, 5.00, '2026-10-16 14:00:58'),
(215, 7, 26, 5.00, '2026-10-16 14:00:59');

-- --------------------------------------------------------

--
-- Table structure for table `kategori`
--

CREATE TABLE `kategori` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `kategori`
--

INSERT INTO `kategori` (`id`, `nama`, `deskripsi`, `created_at`) VALUES
(1, 'Olahraga', 'Minat pada kegiatan olahraga', '2026-09-29 14:38:07'),
(2, 'Seni', 'Minat pada kegiatan seni dan kreativitas', '2026-09-29 14:38:07'),
(3, 'Teknologi', 'Minat pada komputer dan teknologi', '2026-09-29 14:38:07'),
(4, 'Organisasi', 'Minat pada kepemimpinan dan organisasi', '2026-09-29 14:38:07'),
(5, 'Akademik', 'Minat pada kegiatan akademik dan ilmiah', '2026-09-29 14:38:07');

-- --------------------------------------------------------

--
-- Table structure for table `pendaftaran_ekskul`
--

CREATE TABLE `pendaftaran_ekskul` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `ekskul_id` int(10) UNSIGNED NOT NULL,
  `status` enum('menunggu','diterima','ditolak') NOT NULL DEFAULT 'menunggu',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pertanyaan`
--

CREATE TABLE `pertanyaan` (
  `id` int(10) UNSIGNED NOT NULL,
  `pertanyaan` text NOT NULL,
  `kategori_id` int(10) UNSIGNED NOT NULL,
  `bobot` decimal(8,2) NOT NULL DEFAULT 1.00,
  `status` enum('aktif','nonaktif') NOT NULL DEFAULT 'aktif',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pertanyaan`
--

INSERT INTO `pertanyaan` (`id`, `pertanyaan`, `kategori_id`, `bobot`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Saya suka melakukan aktivitas olahraga', 1, 1.00, 'aktif', '2026-09-29 15:34:56', '2026-09-29 15:34:56'),
(2, 'Saya suka bermain olahraga secara berkelompok', 1, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(3, 'Saya senang melakukan aktivitas olahraga secara rutin', 1, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(4, 'Saya tertarik mempelajari teknik olahraga baru', 1, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(5, 'Saya suka mengikuti kegiatan yang membutuhkan aktivitas fisik', 1, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(6, 'Saya suka menari', 2, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(7, 'Saya senang mempelajari gerakan tari baru', 2, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(8, 'Saya suka bermain alat musik atau bernyanyi', 2, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(9, 'Saya senang mengekspresikan diri melalui kegiatan seni', 2, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(10, 'Saya tertarik mempelajari berbagai jenis seni dan kreativitas', 2, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(11, 'Saya tertarik belajar pemrograman', 3, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(12, 'Saya suka mencoba membuat program atau aplikasi', 3, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(13, 'Saya tertarik mempelajari teknologi baru', 3, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(14, 'Saya suka membuat desain menggunakan komputer', 3, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(15, 'Saya senang membuat poster atau desain digital', 3, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(16, 'Saya senang bekerja sama dalam sebuah kelompok', 4, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(17, 'Saya tertarik mengikuti kegiatan organisasi sekolah', 4, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(18, 'Saya suka memimpin sebuah kegiatan', 4, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(19, 'Saya ingin belajar menjadi lebih disiplin dan bertanggung jawab', 4, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(20, 'Saya senang membantu mengatur kegiatan sekolah', 4, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(21, 'Saya suka melakukan penelitian sederhana', 5, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(22, 'Saya tertarik mencari tahu bagaimana sesuatu bekerja', 5, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(23, 'Saya suka melakukan percobaan', 5, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(24, 'Saya senang membaca dan mencari informasi baru', 5, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(25, 'Saya tertarik membuat karya atau proyek ilmiah', 5, 1.00, 'aktif', '2026-10-01 13:24:25', '2026-10-01 13:24:25'),
(26, 'Saya suka mengikuti kegiatan yang berhubungan dengan lingkungan.', 5, 1.00, 'aktif', '2026-10-01 15:04:48', '2026-10-01 15:04:48');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `nama` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('user','admin') NOT NULL DEFAULT 'user',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `nama`, `email`, `password_hash`, `role`, `created_at`, `updated_at`) VALUES
(1, 'Administrator', 'admin@gmail.com', '$2y$10$HRphM6MfNfCIOmvbV4X24eyUlYxi.G8Y1p8yBDI8AYjvcQi4ncLH2', 'admin', '2026-09-29 15:02:47', '2026-09-29 15:02:47'),
(2, 'User Demo', 'user@gmail.com', '$2y$10$dTxPfZTUv81YVDw8PHVFmOkAZ7odzaQwxH0PQl40qMF.HbmVX.uvq', 'user', '2026-09-29 15:23:32', '2026-09-29 15:23:32'),
(3, 'Budi', 'budi@gmail.com', '$2y$10$1zwbedyEAf2Hhv6qUQuMiuu2mmCPvXC9GoLcIQlonOW5uwTxwXgmW', 'user', '2026-10-01 14:05:31', '2026-10-01 14:05:31'),
(4, 'tika', 'artika@gmail.com', '$2y$10$sheMFYHmMgx6.NZMBaMAyu9XabnF0LoFaa/ZJFd3T/CNuoNSYG8xm', 'user', '2026-10-02 06:46:08', '2026-10-02 06:46:08'),
(5, 'Didi', 'di@gmail.com', '$2y$10$9I6AQ59TxImnwL0cr5MATeV7SAVYzTx9ZCTUPPXmBzkLRaYYunxlO', 'user', '2026-10-08 06:48:46', '2026-10-08 06:48:46'),
(6, 'Rahma', 'r@gmail.com', '$2y$10$RWBelDkB5lFKISoO2pR4qug2aaDAe093hBaTMqY6Ws5NkmPpJqi9y', 'user', '2026-10-16 10:14:20', '2026-10-16 10:14:20'),
(7, 'Dini Artika', 'd@gmail.com', '$2y$10$SbD5zSrsJaavSC/Om/AniOS0E3UJTwU//A.PnPBZdVA120d2GQmQK', 'user', '2026-10-16 13:58:42', '2026-10-16 13:58:42');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `ekskul`
--
ALTER TABLE `ekskul`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `ekskul_dokumentasi`
--
ALTER TABLE `ekskul_dokumentasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_dokumentasi_ekskul` (`ekskul_id`);

--
-- Indexes for table `ekskul_kategori`
--
ALTER TABLE `ekskul_kategori`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_ekskul_kategori` (`ekskul_id`,`kategori_id`),
  ADD KEY `fk_ekskul_kategori_kategori` (`kategori_id`);

--
-- Indexes for table `hasil_rekomendasi`
--
ALTER TABLE `hasil_rekomendasi`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_hasil_user` (`user_id`),
  ADD KEY `fk_hasil_ekskul` (`ekskul_id`);

--
-- Indexes for table `jawaban`
--
ALTER TABLE `jawaban`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_user_pertanyaan` (`user_id`,`pertanyaan_id`),
  ADD KEY `fk_jawaban_pertanyaan` (`pertanyaan_id`);

--
-- Indexes for table `kategori`
--
ALTER TABLE `kategori`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `nama` (`nama`);

--
-- Indexes for table `pendaftaran_ekskul`
--
ALTER TABLE `pendaftaran_ekskul`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_pendaftaran` (`user_id`,`ekskul_id`),
  ADD KEY `fk_pendaftaran_ekskul` (`ekskul_id`);

--
-- Indexes for table `pertanyaan`
--
ALTER TABLE `pertanyaan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_pertanyaan_kategori` (`kategori_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `ekskul`
--
ALTER TABLE `ekskul`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `ekskul_dokumentasi`
--
ALTER TABLE `ekskul_dokumentasi`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `ekskul_kategori`
--
ALTER TABLE `ekskul_kategori`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `hasil_rekomendasi`
--
ALTER TABLE `hasil_rekomendasi`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=230;

--
-- AUTO_INCREMENT for table `jawaban`
--
ALTER TABLE `jawaban`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=216;

--
-- AUTO_INCREMENT for table `kategori`
--
ALTER TABLE `kategori`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pendaftaran_ekskul`
--
ALTER TABLE `pendaftaran_ekskul`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pertanyaan`
--
ALTER TABLE `pertanyaan`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `ekskul_dokumentasi`
--
ALTER TABLE `ekskul_dokumentasi`
  ADD CONSTRAINT `fk_dokumentasi_ekskul` FOREIGN KEY (`ekskul_id`) REFERENCES `ekskul` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `ekskul_kategori`
--
ALTER TABLE `ekskul_kategori`
  ADD CONSTRAINT `fk_ekskul_kategori_ekskul` FOREIGN KEY (`ekskul_id`) REFERENCES `ekskul` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_ekskul_kategori_kategori` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `hasil_rekomendasi`
--
ALTER TABLE `hasil_rekomendasi`
  ADD CONSTRAINT `fk_hasil_ekskul` FOREIGN KEY (`ekskul_id`) REFERENCES `ekskul` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_hasil_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `jawaban`
--
ALTER TABLE `jawaban`
  ADD CONSTRAINT `fk_jawaban_pertanyaan` FOREIGN KEY (`pertanyaan_id`) REFERENCES `pertanyaan` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_jawaban_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pendaftaran_ekskul`
--
ALTER TABLE `pendaftaran_ekskul`
  ADD CONSTRAINT `fk_pendaftaran_ekskul` FOREIGN KEY (`ekskul_id`) REFERENCES `ekskul` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_pendaftaran_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `pertanyaan`
--
ALTER TABLE `pertanyaan`
  ADD CONSTRAINT `fk_pertanyaan_kategori` FOREIGN KEY (`kategori_id`) REFERENCES `kategori` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
