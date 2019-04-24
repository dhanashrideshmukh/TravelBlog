-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 23, 2019 at 06:49 PM
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
CREATE DATABASE IF NOT EXISTS `travelblog` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci;
USE `travelblog`;

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `addBlog` (IN `formUsername` VARCHAR(50), IN `formTitle` VARCHAR(100), IN `formContent` TEXT, IN `formCountryName` VARCHAR(100), IN `formContinentName` VARCHAR(100), IN `formCategoryName` VARCHAR(50))  INSERT INTO blog(UserID, Title, Content, CountryID, ContinentID, CategoryID, DatePosted)
VALUES ((SELECT UserID FROM user WHERE Username = formUsername) 
        ,formTitle
        ,formContent
        ,(SELECT CountryID FROM country WHERE CountryName = formCountryName)
        ,(SELECT ContinentID FROM continent WHERE ContinentName = formContinentName)
        ,(SELECT CategoryID FROM category WHERE CategoryName = formCategoryName)
        ,CURRENT_DATE)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addComment` (IN `formUsername` VARCHAR(50), IN `formBlogID` INT(11), IN `formContent` VARCHAR(2000), IN `formSenderName` VARCHAR(50))  NO SQL
INSERT INTO comment(UserID, BlogID, Content, senderName)
VALUES ((SELECT UserID FROM user WHERE Username = formUsername), 
        formBlogID,
        formContent,
        formSenderName)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addLikeCounter` (IN `formBlogID` SMALLINT(5))  UPDATE blog SET

LikeCounter = LikeCounter+1

WHERE BlogID=formBlogID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBlog` (IN `formBlogID` SMALLINT(5))  BEGIN
    IF (select count(*) from blogimage where BlogID=formBlogID) >0
    THEN
    BEGIN
        DELETE FROM blogimage WHERE BlogID = formBlogID;
    END;
    END IF;
IF EXISTS (SELECT * FROM blog WHERE BlogId = formBlogID)
    THEN
    BEGIN
DELETE from blog  where BlogID = formBlogID;
    END;
    END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `fetchComments` (IN `getBlogID` INT(11))  NO SQL
SELECT *

FROM comment as c

WHERE BlogID = getBlogID ORDER BY DatePosted DESC LIMIT 2$$

CREATE DEFINER=`blog`@`localhost` PROCEDURE `findAllPublishedBlogs` ()  READS SQL DATA
    SQL SECURITY INVOKER
SELECT 
b.BlogID
,u.Username
,b.Title
,b.Content
,cou.CountryName
,con.ContinentName
,cat.CategoryName
,b.DatePosted
,b.LikeCounter

FROM `blog` as b
INNER JOIN country as cou
ON b.CountryID = cou.CountryID
INNER JOIN continent as con
ON b.ContinentID = con.ContinentID
INNER JOIN category as cat
ON b.CategoryID = cat.CategoryID
INNER JOIN user as u
ON b.UserID = u.UserID


WHERE b.Published =1
ORDER BY b.DatePosted DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `findBlogByID` (IN `formBlogID` SMALLINT(5))  SELECT 
b.BlogID
,u.Username
,b.Title
,b.Content
,cou.CountryName
,con.ContinentName
,cat.CategoryName
,b.DatePosted
,b.LikeCounter

FROM `blog` as b
INNER JOIN country as cou
ON b.CountryID = cou.CountryID
INNER JOIN continent as con
ON b.ContinentID = con.ContinentID
INNER JOIN category as cat
ON b.CategoryID = cat.CategoryID
INNER JOIN user as u
ON b.UserID = u.UserID


WHERE b.BlogID = formBlogID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `readMyBlogs` (IN `formUsername` VARCHAR(50))  SELECT 
               b.BlogID
               ,u.Username
               ,b.Title
               ,b.Content
                ,cou.CountryName
                ,con.ContinentName
                ,cat.CategoryName
                ,b.DatePosted
               ,b.LikeCounter
               
                FROM `blog` as b
               INNER JOIN country as cou
               ON b.CountryID = cou.CountryID
              INNER JOIN continent as con
               ON b.ContinentID = con.ContinentID
               INNER JOIN category as cat
               ON b.CategoryID = cat.CategoryID
                INNER JOIN user as u
               ON b.UserID = u.UserID
               
               WHERE u.Username = formUsername
               ORDER BY b.DatePosted DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `searchBlog` (IN `searchquery` VARCHAR(50))  SELECT 
                b.BlogID
                ,u.Username
               ,b.Title
               ,b.Content
               ,cou.CountryName
              ,con.ContinentName
              ,cat.CategoryName
               ,b.DatePosted
               ,b.LikeCounter
               
              FROM `blog` as b
               INNER JOIN country as cou
              ON b.CountryID = cou.CountryID
              INNER JOIN continent as con
               ON b.ContinentID = con.ContinentID
               INNER JOIN category as cat
              ON b.CategoryID = cat.CategoryID
               INNER JOIN user as u
               ON b.UserID = u.UserID
               
               WHERE (cou.CountryName LIKE searchquery) OR (cat.CategoryName LIKE searchquery) OR (con.ContinentName LIKE searchquery) OR (b.Title LIKE searchquery) OR (b.Content LIKE searchquery)
               ORDER BY b.DatePosted DESC$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `subtractLikeCounter` (IN `formBlogID` SMALLINT(5))  UPDATE blog SET

LikeCounter = LikeCounter-1

WHERE BlogID=formBlogID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBlog` (IN `formBlogID` SMALLINT(5), IN `formUsername` VARCHAR(50), IN `formTitle` VARCHAR(100), IN `formContent` TEXT, IN `formCountryName` VARCHAR(100), IN `formContinentName` VARCHAR(100), IN `formCategoryName` VARCHAR(50))  UPDATE blog SET
UserID = (SELECT UserID FROM user WHERE Username = formUsername) 
,Title = formTitle
, Content = formContent
, CountryID = (SELECT CountryID FROM country WHERE CountryName = formCountryName)
, ContinentID = (SELECT ContinentID FROM continent WHERE ContinentName = formContinentName)
, CategoryID = (SELECT CategoryID FROM category WHERE CategoryName = formCategoryName)

WHERE BlogID=formBlogID$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `blog`
--

CREATE TABLE `blog` (
  `BlogID` smallint(5) NOT NULL,
  `UserID` smallint(5) NOT NULL,
  `Title` varchar(100) NOT NULL,
  `Content` text NOT NULL,
  `CountryID` smallint(5) NOT NULL,
  `ContinentID` smallint(5) NOT NULL,
  `CategoryID` smallint(5) NOT NULL,
  `DatePosted` date NOT NULL,
  `LikeCounter` int(11) NOT NULL DEFAULT '0',
  `Published` tinyint(1) NOT NULL DEFAULT '1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `blog`
--

INSERT INTO `blog` (`BlogID`, `UserID`, `Title`, `Content`, `CountryID`, `ContinentID`, `CategoryID`, `DatePosted`, `LikeCounter`, `Published`) VALUES
(1, 2, 'Review: Chichen Itza', 'I thoroughly enjoyed my trip to Chichen Itza. Yes it is the most touristy Mayan Ruin but 1. Tourists can be avoid by turning up early and 2. What it doesn\'t have in solitude Chichen Itza more than makes up for in its sheer size and the degree of detail on the excavated pieces.\r\n\r\nI travelled to Chichen Itza from Valladolid which took 45 minutes. To avoid the 6 hour round trip from Cancún I would advise spending tome in either Merida or Valladolid - both are nice colonial cities with their own sights and things to do. In Valladolid, you can take colectivos from outside the bus terminal (calle 39 y 44) for 30 pesos or a Oriente coach for the same price. The first collectivo left at 7 - I arrived at 7.45 and was second in line for a ticket (232 pesos).\r\n\r\nGoing early means that you can 1. Avoid the hottest part of the day, 2. Avoid the majority of vendors (who haven\'t set up yet) and 3. Avoid the majority of tourists. When I was reading the TA reviews prior to my trip these seemed to be the three biggest complaints. \r\n\r\nThat being said, I was able to take tourist-less photos still at 10/11 AM - it just takes a bit of patience and the right angle.\r\n\r\nI opted to have a tour guide as I wanted to be able to understand the full significance of what I was seeing. Non-Spanish tours are 750 pesos. As I was travelling alone I opted to do a \'Collective tour\' with a group of people. I did have to wait 45 minutes until other people arrived who also wanted to do a group tour however with the seven of us we only had to pay 107 pesos each - and we learnt more as there were more questions asked. If getting a local guide I would suggest speaking with them first to ensure they have sufficient skill in the chosen language - especially if you are paying the full 750!\r\n\r\nThe ruins themselves are grand and great as many reviewers have detailed. The cenote is also picturesque. There are small placards beside each monument detailing what things are. In addition to seeing New Chichen Itza (where the temple and ball court are) go beyond this to the Old Chichen Itza - it\'s quieter, has more shade, and has lots more ornate buildings to see!\r\n\r\nDefinitely visit Chichen Itza if in Yucatán and make sure you bring: comfortable shoes, water, repellent, sun cream and umbrella/sunhat, and wet wipes to cool off.', 19, 6, 4, '2013-12-16', 26, 1),
(2, 2, 'On my own again in Potosí and Sucre', 'From La Paz i took a snazzy (it had leather seats) overnight \'cama\' bus to Potosí. I spent the first day walking around the town but there really wasn\'t that much to do or see.\r\n\r\nMy second day was slightly more eventful, starting with a trip to the mines within \'Cerro Rico\'. Cerro Rico is a mountain that towers over the city, and sits atop a large deposit of siver and other minerals. It was the biggest mine in the world during the Spanish colonial period.\r\n\r\n Our guide, a crazy man, and ex-miner, called Pedro started off by taking us to the miners\' market. Here, they freely sell dynamite, even to children! We bought gifts of coca leaves, beverages and exercise books (for their children) for the miners and then set off to get geared up. We were given overalls, boots and helmets so definitely looked the part! \r\n\r\nBefore visiting the mines, we visited a mineral refinery. There were lots of machines, apparently processing the silver but I didn\'t really understand how.\r\n\r\nI had a blast in the mines! They were really stable, not what I was expecting. We had to crouch in some places and I hit my head more times than I can remember - it was hard to judge my height with my helmet on!\r\n\r\nWe weaved our way through, frequently stopping to give away our gifts and for Pedro to give us background info to the mines. The youngest miner we saw there was 15 years old.\r\n\r\nHalf way through we had to climb a series of 3 vertical ladders in order to reach \'Tio\'. I was so out of breath by the end that I almost had a panic attack hehe. Counting to 15 helped me breathe normally again.\r\n\r\nTio is the andean devil who protects the miners - they make offerings of alcohol and coca leaves to him. We sat in front of Tio and Pedro told us about the comraderie and the nicknames that the miners have for one another. These included \'ruso\' (russian), \'barbie\' (apparently the miner looks like a girl), \'chicken-stealer\', and \'pipe\' (this miner who has been married a long time but has no children).\r\n\r\nAfter the mines I visited the cathedral expecting to have a quick wander round and look at the views from the belltower. Instead i was greeted by a zany guide who took us on a tour of the building. He insisted on giving us 3 Brits a Spanish lesson by talking in slow and very animated Spanish the whole time (despite being able to speak english himself). He also quizzed us on Christinaity and our historical knowledge - excitedly hi-5-ing us whenever one of us got something correct.\r\n\r\nIn the evening I met with Pedro and most of the people from the mining tour earlier in the day to watch a Bolivian Premier league match - Potosí vs Santa Cruz. Potosí, as the home team, had the advantage of being accustomed to at an altitude of 4000m above sea level. They won 3-0 with two men from Santa Cruz being sent off in the process. The stadium only had about 100 people in it. Peculiar things I saw duing the game included: a dog sitting in he stands, five year olds selling cigarettes, and armed guards on the pitch breaking up the teams at the end - apparently that\'s normal.\r\n\r\nWith not much else to do in Potosí, I moved onto Sucre, the \'ciudad blanca\' (white city). I spent 5 days here, it was much warmer than La Paz and Potosí so I made the most of it! I ate better, topped up my vitamin D and spent a lot of time wondering the various markets.\r\nOne tourist attraction I did visit (once I figured out how to navigate the local buses/campervans) was the Dino park. The attraction surrounds a set of dinosaur footprint that were found in a cement quarry. Our tour guide took us right up close to them and told us about the type of dinosaurs that created them. There were also life sized replicas of the beasts to aid our imagination.\r\n\r\nSucre is a really pretty city and the real capital of Bolivia (it says so in section 6 of the constitution apparently), although everyone seems to think of La Paz as the capital. It´s a young and vibrant city so I was able to kick back and relax a little.', 5, 7, 1, '2014-06-14', 17, 1),
(3, 1, 'Top things to see in Springfield', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt.', 30, 6, 5, '2019-04-12', 1, 1),
(4, 2, 'test', 'Hi there, \r\nThis is my first post here...! ', 3, 4, 5, '2013-05-19', 20, 0),
(5, 3, 'Cats in Greece 2', 'Test update content for Cats in Greece blog post.', 13, 5, 1, '2019-04-15', 1, 1),
(6, 5, 'Hotels in Australia update', 'Testing update storedproc', 3, 8, 2, '2013-05-19', 20, 0),
(7, 3, 'Adventures in Omaha', 'Testing update from app', 30, 6, 1, '2019-04-18', 0, 1),
(8, 1, 'Best Beaches in Goa', '1. Test beach 2. Test beach 2 3. Another one 4. Another one 5. A fifth beach 6.7.8.9.10.', 15, 4, 4, '2019-04-19', 0, 1),
(9, 1, 'World Cup in Brazil', 'ole ole ole', 6, 7, 1, '2019-04-20', 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `blogimage`
--

CREATE TABLE `blogimage` (
  `ImageID` smallint(5) NOT NULL,
  `BlogID` smallint(5) NOT NULL,
  `ImageName` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `blogimage`
--

INSERT INTO `blogimage` (`ImageID`, `BlogID`, `ImageName`) VALUES
(1, 1, ''),
(2, 1, ''),
(3, 3, '');

-- --------------------------------------------------------

--
-- Table structure for table `category`
--

CREATE TABLE `category` (
  `CategoryID` smallint(5) NOT NULL,
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
-- Table structure for table `comment`
--

CREATE TABLE `comment` (
  `CommentID` smallint(5) NOT NULL,
  `BlogID` smallint(5) DEFAULT NULL,
  `UserID` smallint(5) DEFAULT NULL,
  `Content` varchar(2000) NOT NULL,
  `DatePosted` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `senderName` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `comment`
--

INSERT INTO `comment` (`CommentID`, `BlogID`, `UserID`, `Content`, `DatePosted`, `senderName`) VALUES
(1, 3, NULL, 'coolblog', '2019-04-22 12:39:26', 'JOJO'),
(2, 9, NULL, '  fghfghfghfnfg', '2019-04-22 13:55:54', '  fgdfgdgf'),
(3, 8, NULL, '  jbjbkjbkj', '2019-04-22 13:56:29', '  hjhvhvnh'),
(4, 7, NULL, '  hvjhvhgvh', '2019-04-22 13:57:04', '  hvhvjhnh'),
(5, 9, NULL, '  test', '2019-04-22 13:58:15', 'test  '),
(6, 9, NULL, '  testing fetch comment', '2019-04-23 11:32:11', 'jomana'),
(7, 9, NULL, '  testingggggggg  ', '2019-04-23 11:33:25', 'bob  '),
(8, 9, NULL, '  procedure test', '2019-04-23 12:03:22', 'name'),
(9, 8, NULL, '  very cool ', '2019-04-23 12:04:02', '  bartman'),
(10, 8, NULL, '  nice blog', '2019-04-23 12:05:49', '  bartman'),
(11, 7, NULL, '  i like your blog', '2019-04-23 12:08:27', '  bartman'),
(12, 1, 3, 'testtestest', '2019-04-23 12:10:25', 'bartman'),
(13, 7, NULL, '  testing addcomment', '2019-04-23 12:13:04', '  bartman'),
(29, 9, NULL, '  88888888888', '2019-04-23 14:55:19', '  88888888'),
(30, 9, 1, '  7777777777777', '2019-04-23 14:55:43', '  77777777'),
(31, 9, NULL, '  fdhdfhfh', '2019-04-23 14:57:43', '  bart'),
(32, 9, NULL, '  fdhdfhfh', '2019-04-23 14:57:56', '  bart'),
(33, 9, NULL, '  hfhgfhfghfghf', '2019-04-23 14:58:01', '  dfgdfdf'),
(34, 9, 5, '  lovely post love brazil', '2019-04-23 15:01:56', '  balletboy'),
(35, 9, NULL, ' great post', '2019-04-23 15:22:38', '  name'),
(36, 8, NULL, ' test comment', '2019-04-23 15:24:18', '  not logged in'),
(37, 7, 5, ' sick post', '2019-04-23 15:25:02', '  balletboy'),
(38, 7, 5, ' ', '2019-04-23 15:25:30', '  '),
(39, 7, 5, ' ', '2019-04-23 15:26:51', '  '),
(40, 7, 5, ' ', '2019-04-23 15:26:56', '  '),
(41, 9, NULL, ' ', '2019-04-23 15:32:14', 'Jojo');

-- --------------------------------------------------------

--
-- Table structure for table `continent`
--

CREATE TABLE `continent` (
  `ContinentID` smallint(5) NOT NULL,
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
  `CountryID` smallint(5) NOT NULL,
  `CountryName` varchar(100) NOT NULL,
  `ContinentID` smallint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`CountryID`, `CountryName`, `ContinentID`) VALUES
(1, 'Not Applicable', 1),
(2, 'Argentina', 7),
(3, 'Australia', 8),
(4, 'Austria', 5),
(5, 'Bolivia', 5),
(6, 'Brazil', 7),
(7, 'Canada', 6),
(8, 'Chile', 7),
(9, 'China', 4),
(10, 'Egypt', 2),
(11, 'France', 5),
(12, 'Germany', 5),
(13, 'Greece', 5),
(14, 'Hong Kong', 4),
(15, 'India', 4),
(16, 'Italy', 5),
(17, 'Japan', 4),
(18, 'Malaysia', 4),
(19, 'Mexico', 6),
(20, 'Morocco', 2),
(21, 'Portugal', 5),
(22, 'Saudi Arabia', 4),
(23, 'Singapore', 4),
(24, 'South Africa', 2),
(25, 'Spain', 5),
(26, 'Thailand', 0),
(27, 'Tunisia', 0),
(28, 'Turkey', 0),
(29, 'United Kingdom', 0),
(30, 'USA', 0);

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
  `UserID` smallint(5) NOT NULL,
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
(1, 'Bartman', 'bartsimpson@gmail.com', 'Maggie123', 1, NULL, NULL),
(2, 'faithege', 'fege@example.com', 'H3110World', 1, NULL, NULL),
(3, 'catlover', 'emmasmith@hotmail.co.uk', 'mrkitty12', 1, NULL, NULL),
(4, 'iclimbmountains', 'stuart.paul@example.com', '2015kilimanjaro', 1, NULL, NULL),
(5, 'balletboy', 'billyelliot@test.com', 'test321', 1, NULL, NULL),
(6, 'Faithtest', 'faithege@hotmail.co.uk', '123456', 1, NULL, NULL);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `blog`
--
ALTER TABLE `blog`
  ADD PRIMARY KEY (`BlogID`),
  ADD KEY `UserID` (`UserID`),
  ADD KEY `CategoryID` (`CategoryID`),
  ADD KEY `ContinentID` (`ContinentID`),
  ADD KEY `CountryID` (`CountryID`);

--
-- Indexes for table `blogimage`
--
ALTER TABLE `blogimage`
  ADD PRIMARY KEY (`ImageID`),
  ADD KEY `BlogID` (`BlogID`);

--
-- Indexes for table `category`
--
ALTER TABLE `category`
  ADD PRIMARY KEY (`CategoryID`);

--
-- Indexes for table `comment`
--
ALTER TABLE `comment`
  ADD PRIMARY KEY (`CommentID`),
  ADD KEY `BlogID` (`BlogID`),
  ADD KEY `UserID` (`UserID`);

--
-- Indexes for table `continent`
--
ALTER TABLE `continent`
  ADD PRIMARY KEY (`ContinentID`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`CountryID`);

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
-- AUTO_INCREMENT for table `blog`
--
ALTER TABLE `blog`
  MODIFY `BlogID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `blogimage`
--
ALTER TABLE `blogimage`
  MODIFY `ImageID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `category`
--
ALTER TABLE `category`
  MODIFY `CategoryID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `comment`
--
ALTER TABLE `comment`
  MODIFY `CommentID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `continent`
--
ALTER TABLE `continent`
  MODIFY `ContinentID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `CountryID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;

--
-- AUTO_INCREMENT for table `permission`
--
ALTER TABLE `permission`
  MODIFY `PermissionID` tinyint(1) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `UserID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `blog`
--
ALTER TABLE `blog`
  ADD CONSTRAINT `blog_ibfk_1` FOREIGN KEY (`CategoryID`) REFERENCES `category` (`CategoryID`),
  ADD CONSTRAINT `blog_ibfk_2` FOREIGN KEY (`ContinentID`) REFERENCES `continent` (`ContinentID`),
  ADD CONSTRAINT `blog_ibfk_3` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`),
  ADD CONSTRAINT `blog_ibfk_4` FOREIGN KEY (`CountryID`) REFERENCES `country` (`CountryID`);

--
-- Constraints for table `blogimage`
--
ALTER TABLE `blogimage`
  ADD CONSTRAINT `blogimage_ibfk_1` FOREIGN KEY (`BlogID`) REFERENCES `blog` (`BlogID`);

--
-- Constraints for table `comment`
--
ALTER TABLE `comment`
  ADD CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`BlogID`) REFERENCES `blog` (`BlogID`),
  ADD CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`);

--
-- Constraints for table `user`
--
ALTER TABLE `user`
  ADD CONSTRAINT `user_ibfk_1` FOREIGN KEY (`PermissionID`) REFERENCES `permission` (`PermissionID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
