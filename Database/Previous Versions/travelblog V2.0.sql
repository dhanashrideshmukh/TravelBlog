-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 13, 2019 at 06:44 PM
-- Server version: 10.1.37-MariaDB
-- PHP Version: 7.0.33

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `travelblog`
--

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `CategoryID` int(11) NOT NULL,
  `CategoryName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `category`
--

INSERT INTO `category` (`CategoryID`, `CategoryName`) VALUES
(1, 'Trip Report'),
(2, 'Hotel Review'),
(3, 'Restaurant Review'),
(4, 'Attraction Review'),
(5, 'Travel Advice');

-- --------------------------------------------------------

--
-- Table structure for table `continent`
--

CREATE TABLE `continent` (
  `ContinentID` int(11) NOT NULL,
  `ContinentName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `continent`
--

INSERT INTO `continent` (`ContinentID`, `ContinentName`) VALUES
(1, 'Non Applicable'),
(2, 'Africa'),
(3, 'Antarctica'),
(4, 'Asia'),
(5, 'Europe'),
(6, 'North America'),
(7, 'South America'),
(8, 'Oceania');

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

CREATE TABLE `country` (
  `CountryID` smallint(3) UNSIGNED ZEROFILL NOT NULL,
  `CountryName` varchar(100) NOT NULL,
  `ContinentID` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`CountryID`, `CountryName`, `ContinentID`) VALUES
(001, 'Not Applicable', 1),
(002, 'Argentina', 7),
(003, 'Australia', 8),
(004, 'Austria', 5),
(005, 'Bolivia', 5),
(006, 'Brazil', 7),
(007, 'Canada', 6),
(008, 'Chile', 7),
(009, 'China', 4),
(010, 'Egypt', 2),
(011, 'France', 5),
(012, 'Germany', 5),
(013, 'Greece', 5),
(014, 'Hong Kong', 4),
(015, 'India', 4),
(016, 'Italy', 5),
(017, 'Japan', 4),
(018, 'Malaysia', 4),
(019, 'Mexico', 7),
(020, 'Morocco', 2),
(021, 'Portugal', 5),
(022, 'Saudi Arabia', 4),
(023, 'Singapore', 4),
(024, 'South Africa', 2),
(025, 'Spain', 5),
(026, 'Thailand', 0),
(027, 'Tunisia', 0),
(028, 'Turkey', 0),
(029, 'United Kingdom', 0),
(030, 'USA', 0);

-- --------------------------------------------------------

--
-- Table structure for table `permission`
--

CREATE TABLE `permission` (
  `PermissionID` tinyint(1) UNSIGNED NOT NULL,
  `Permission` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `permission`
--

INSERT INTO `permission` (`PermissionID`, `Permission`) VALUES
(1, 'Member'),
(2, 'Admin');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `UserID` smallint(5) UNSIGNED ZEROFILL NOT NULL,
  `Username` varchar(50) NOT NULL,
  `Email` varchar(50) NOT NULL,
  `Password` varchar(50) NOT NULL,
  `PermissionID` tinyint(1) UNSIGNED NOT NULL DEFAULT '1',
  `Avatar` varchar(250) DEFAULT NULL,
  `Bio` text
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`UserID`, `Username`, `Email`, `Password`, `PermissionID`, `Avatar`, `Bio`) VALUES
(00001, 'Bartman', 'bartsimpson@gmail.com', 'Maggie123', 1, NULL, NULL),
(00002, 'faithege', 'fege@example.com', 'H3110World', 1, NULL, NULL),
(00003, 'catlover', 'emmasmith@hotmail.co.uk', 'mrkitty12', 1, NULL, NULL),
(00004, 'iclimbmountains', 'stuart.paul@example.com', '2015kilimanjaro', 1, NULL, NULL),
(00005, 'balletboy', 'billyelliot@test.com', 'test321', 1, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`CategoryID`);

--
-- Indexes for table `continent`
--
ALTER TABLE `continent`
  ADD PRIMARY KEY (`ContinentID`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`CountryID`),
  ADD KEY `Continent_ID` (`ContinentID`);

--
-- Indexes for table `permission`
--
ALTER TABLE `permission`
  ADD PRIMARY KEY (`PermissionID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserID`),
  ADD KEY `PermissionID` (`PermissionID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `CategoryID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `continent`
--
ALTER TABLE `continent`
  MODIFY `ContinentID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `CountryID` smallint(3) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `permission`
--
ALTER TABLE `permission`
  MODIFY `PermissionID` tinyint(1) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `UserID` smallint(5) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `country`
--
ALTER TABLE `country`
  ADD CONSTRAINT `Continent_ID` FOREIGN KEY (`ContinentID`) REFERENCES `continent` (`ContinentID`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`PermissionID`) REFERENCES `permission` (`PermissionID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
