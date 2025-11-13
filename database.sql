-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 13, 2025 at 03:59 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `test`
--

-- --------------------------------------------------------

--
-- Table structure for table `jwt_blacklist`
--

CREATE TABLE `jwt_blacklist` (
  `id` int(11) NOT NULL,
  `token` text NOT NULL,
  `revoked_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `jwt_blacklist`
--

INSERT INTO `jwt_blacklist` (`id`, `token`, `revoked_at`) VALUES
(1, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJhZG1pbkBkZW1vLmNvbSIsIm5hbWUiOiJBZG1pbmlzdHJhZG9yIiwicGVybWlzc2lvbnMiOlsiMSJdLCJpYXQiOjE3NjI5OTgxOTcsImV4cCI6MTc2Mjk5ODc5N30.w1M8NOPrY2lLOZ1UzDV8m6JXMzbfnWvaGElyYV1BhzI', '2025-11-12 22:43:30'),
(2, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJhZG1pbkBkZW1vLmNvbSIsIm5hbWUiOiJBZG1pbmlzdHJhZG9yIiwicGVybWlzc2lvbnMiOlsiMSJdLCJpYXQiOjE3NjI5OTgyNjAsImV4cCI6MTc2Mjk5ODg2MH0.e2K_fLrjAgn4b_o61l7xtiLzRGy6XAcSNjAeItBcRrI', '2025-11-12 22:44:33'),
(3, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJhZG1pbkBkZW1vLmNvbSIsIm5hbWUiOiJBZG1pbmlzdHJhZG9yIiwicGVybWlzc2lvbnMiOlsiMSJdLCJpYXQiOjE3NjI5OTg0NTgsImV4cCI6MTc2Mjk5OTA1OH0.aidrSr97mKPUSDRGKMutSxPMQX_sTu06GfkPWltSKuc', '2025-11-12 22:48:41'),
(4, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJhZG1pbkBkZW1vLmNvbSIsIm5hbWUiOiJBZG1pbmlzdHJhZG9yIiwicGVybWlzc2lvbnMiOlsiMSIsIjIiXSwiaWF0IjoxNzYzMDAxNzk0LCJleHAiOjE3NjMwMDIzOTR9.1gAuXzIeQR2fXeAYITsNCxxDhsNgj2aqkWJcCtFM8BI', '2025-11-12 23:43:18'),
(5, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJhZG1pbkBkZW1vLmNvbSIsIm5hbWUiOiJBZG1pbmlzdHJhZG9yIiwicGVybWlzc2lvbnMiOlsiMSIsIjIiXSwiaWF0IjoxNzYzMDAxODIzLCJleHAiOjE3NjMwMDI0MjN9.tnEQFZkqE06n6PHFPDqPMOXrB0DbDvBSOQUCnC4PaVA', '2025-11-12 23:44:49'),
(6, 'eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiZW1haWwiOiJhZG1pbkBkZW1vLmNvbSIsIm5hbWUiOiJBZG1pbmlzdHJhZG9yIiwicGVybWlzc2lvbnMiOlsiMSIsIjIiXSwiaWF0IjoxNzYzMDAxOTg3LCJleHAiOjE3NjMwMDI1ODd9.cKBqgiuN-oKL8au-aLXA-eigtcQzP7vC4t8Xo16Frqs', '2025-11-12 23:46:31');

-- --------------------------------------------------------

--
-- Table structure for table `permisosxusuario`
--

CREATE TABLE `permisosxusuario` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `permiso_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `permisosxusuario`
--

INSERT INTO `permisosxusuario` (`id`, `usuario_id`, `permiso_id`) VALUES
(1, 1, 1),
(2, 1, 2),
(3, 2, 2);

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` int(11) NOT NULL,
  `usuario_id` int(11) NOT NULL,
  `token_hash` varchar(128) NOT NULL,
  `expires_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `ip` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `refresh_tokens`
--

INSERT INTO `refresh_tokens` (`id`, `usuario_id`, `token_hash`, `expires_at`, `created_at`, `ip`, `user_agent`) VALUES
(1, 1, '934b75f85c15106fc97ecb07ec562dbb9084fbf85571ffa31b1a2ab8ab0cb4fc', '2025-11-20 02:27:48', '2025-11-12 22:27:48', '::1', 'curl/8.13.0'),
(10, 1, '36447684bc8ff3c69cde5f0f3236a183916bcffb0d67e3e094af15e1dccd2eb3', '2025-11-20 02:51:35', '2025-11-12 22:51:35', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(11, 1, 'd5a999df449153544f37acd05db65e238fcc3813d0ae6b4b5e45b68651110645', '2025-11-20 03:34:09', '2025-11-12 23:34:09', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(12, 1, '2e4d7d8ca4555f7c52f5d1c42d30bd27cbe75f10f0409026dc0eb00e1309de99', '2025-11-20 03:34:13', '2025-11-12 23:34:13', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(13, 1, 'a4e52629619e80dcf1745e48113cb0856db5280699290530a64a73d1efc1cf57', '2025-11-20 03:34:13', '2025-11-12 23:34:13', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(14, 1, '64ad58dfa7a5b0bc784206cbf193d4fd173a4263a5285a4970fd01967276aa9c', '2025-11-20 03:34:14', '2025-11-12 23:34:14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(15, 1, '7e2478f5b37a9be11d56a2aa6c55ff0b0478caa077e89c1a236297332659efe5', '2025-11-20 03:34:24', '2025-11-12 23:34:24', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(16, 1, 'c235053a14d7fed2b31cfa12c229e15a58403f755b542a9d43421c40fe082376', '2025-11-20 03:34:25', '2025-11-12 23:34:25', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(17, 1, 'f6d1c2c1ca0c149efbc92e9236b79d616d4c2cac61b28996150e75e4db20c9e3', '2025-11-20 03:34:25', '2025-11-12 23:34:25', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(18, 1, '230c78e46cc276cb0c2bc7b3d052309903d30d73de349f1ffaf09619ce858523', '2025-11-20 03:34:25', '2025-11-12 23:34:25', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(19, 1, '6b4747e6057656c688146975c0b61895f46ca349ed84a3823a0da22eced1f98b', '2025-11-20 03:34:25', '2025-11-12 23:34:25', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(20, 1, 'b1d1894d372fa3cd42caf69d4f2144fb29240a942197e6144c9d05814896c103', '2025-11-20 03:34:45', '2025-11-12 23:34:45', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(21, 1, 'bf6fe2f5d36f8e5f08868395867bad708ff5932c4cb3825d707209babf9388f9', '2025-11-20 03:34:48', '2025-11-12 23:34:48', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(22, 1, 'c6cde066520a6bc168fd9386350e701cbce1a3fdd85df1b73b6db329968e21a4', '2025-11-20 03:34:48', '2025-11-12 23:34:48', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(23, 1, 'cad609e0363a46e5f88e19f4819065ba14f4878859df8ae55173c2436d1447f3', '2025-11-20 03:35:13', '2025-11-12 23:35:13', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(24, 1, '4b8eea2f08661aa4a8a574362f75b6ae6f7eb7324f73051d762ffdaff1bdfbc0', '2025-11-20 03:35:13', '2025-11-12 23:35:13', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(25, 1, '976766050253299292387e9a90dd0d79d5ec0b39ff3d97c80fda275f8bd8d98c', '2025-11-20 03:35:14', '2025-11-12 23:35:14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(26, 1, '760303f7232e2f656e0bffa02c01c3892879c90e580dbf0629e07f661dc9ca6c', '2025-11-20 03:35:14', '2025-11-12 23:35:14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(27, 1, 'af128a4815d7de12b26a6fde1d360ec317c35c7dc0bb7f852dc332a0f2186d73', '2025-11-20 03:35:14', '2025-11-12 23:35:14', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(28, 1, 'ead27c2cc023835255018fe3b3968ac6e12fd5a79a609330e4f3c9deb90909c1', '2025-11-20 03:35:15', '2025-11-12 23:35:15', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(29, 1, '8f9769c82763015bfacafa5e0e396a64cb7145c6d5ad7fd0a18679f5016ef683', '2025-11-20 03:35:27', '2025-11-12 23:35:27', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(30, 1, '25225c5b989058ae2de3b6a56f91d222fd6c2d1577477d3412c7c8249933f47f', '2025-11-20 03:35:27', '2025-11-12 23:35:27', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36'),
(31, 1, 'c067ed2b7074180900b1b4d1d49c64aa264f7da586dd1365d994d533cb1cdbea', '2025-11-20 03:37:50', '2025-11-12 23:37:50', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(32, 1, '4114ccdbaf5002c9cc6d0054005347e74f67915ce7523d134f226af84fe46d5c', '2025-11-20 03:39:28', '2025-11-12 23:39:28', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(33, 1, 'f5adaf17f6d6b9c5b1c071d41dec7ffdcbfc4977bcd254e36f82847895d159a3', '2025-11-20 03:39:30', '2025-11-12 23:39:30', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(34, 1, 'e6aa8673729e90e199562ce76efc3b68d9cba200ef4b8c779702f95415c3d1b5', '2025-11-20 03:39:33', '2025-11-12 23:39:33', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(35, 1, '91bf8b904f821acf98789cdb7dd58f331e486daead82cc4b43ffe842aaa9cc01', '2025-11-20 03:39:34', '2025-11-12 23:39:34', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(36, 1, 'c487f9617e85222823f9cc65c6b8f370f40dd591a831eb80a2e64a9d4e4b6344', '2025-11-20 03:39:34', '2025-11-12 23:39:34', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(37, 1, '94cec6b52bd964f2ada27742f51e305e3068ca21664eb9779297659d5001bdd9', '2025-11-20 03:39:34', '2025-11-12 23:39:34', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(38, 1, 'e2669339620315d60ecb4750c1326ddc769e048bc5ed3184759091c2bb558b52', '2025-11-20 03:39:35', '2025-11-12 23:39:35', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(39, 1, '697a7cd89aa82242efe847a2f81022fe8f9a5ca7cec059b2fa885ee26236c6a2', '2025-11-20 03:40:31', '2025-11-12 23:40:31', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(45, 1, 'c65518c2c853311c3f1d8fc682d3a12942c9082650d89ea725fdefc288f76b22', '2025-11-20 03:46:52', '2025-11-12 23:46:52', '::1', 'Mozilla/5.0 (Linux; Android 6.0; Nexus 5 Build/MRA58N) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Mobile Safari/537.36'),
(46, 1, 'f33dc5583c0959349c0f4e70b42ad6dad84b5a35167a3c2814240019e868f57b', '2025-11-20 03:49:10', '2025-11-12 23:49:10', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36');

-- --------------------------------------------------------

--
-- Table structure for table `usuarios`
--

CREATE TABLE `usuarios` (
  `id` int(11) NOT NULL,
  `email` varchar(256) NOT NULL,
  `name` text NOT NULL,
  `password` varchar(128) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_swedish_ci;

--
-- Dumping data for table `usuarios`
--

INSERT INTO `usuarios` (`id`, `email`, `name`, `password`) VALUES
(1, 'admin@demo.com', 'Administrador', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `jwt_blacklist`
--
ALTER TABLE `jwt_blacklist`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `permisosxusuario`
--
ALTER TABLE `permisosxusuario`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD KEY `usuario_id` (`usuario_id`);

--
-- Indexes for table `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `id` (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `jwt_blacklist`
--
ALTER TABLE `jwt_blacklist`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `permisosxusuario`
--
ALTER TABLE `permisosxusuario`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- AUTO_INCREMENT for table `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `refresh_tokens_ibfk_1` FOREIGN KEY (`usuario_id`) REFERENCES `usuarios` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
