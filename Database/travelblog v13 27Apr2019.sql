-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Apr 27, 2019 at 06:50 PM
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `addFeedback` (IN `formName` VARCHAR(100), IN `formEmail` VARCHAR(100), `formMessage` TEXT)  INSERT INTO userfeedback (FullName, Email,Comments,DatePosted)
VALUES (formName
        ,formEmail
        ,formMessage
        ,CURRENT_DATE)$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addLikeCounter` (IN `formBlogID` SMALLINT(5))  UPDATE blog SET

LikeCounter = LikeCounter+1

WHERE BlogID=formBlogID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `addViewCounter` (IN `formBlogID` INT(5))  NO SQL
UPDATE blog SET
ViewCounter = ViewCounter+1
WHERE blogID = formBlogID$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `confirmUserExists` (IN `formUsername` VARCHAR(50))  SELECT * FROM `user` where Username=formUsername$$

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
,b.ViewCounter
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
,b.ViewCounter
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
               ,b.ViewCounter
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
               ,b.ViewCounter
               
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePassword` (IN `formUsername` VARCHAR(50), IN `formPassword` VARCHAR(255))  UPDATE `user` SET
	Username = formUsername
	, Password = formPassword

	WHERE Username=formUsername$$

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
  `Published` tinyint(1) NOT NULL DEFAULT '1',
  `ViewCounter` smallint(5) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `blog`
--

INSERT INTO `blog` (`BlogID`, `UserID`, `Title`, `Content`, `CountryID`, `ContinentID`, `CategoryID`, `DatePosted`, `LikeCounter`, `Published`, `ViewCounter`) VALUES
(1, 2, 'Review: Chichen Itza', 'I thoroughly enjoyed my trip to Chichen Itza. Yes it is the most touristy Mayan Ruin but 1. Tourists can be avoid by turning up early and 2. What it doesn\'t have in solitude Chichen Itza more than makes up for in its sheer size and the degree of detail on the excavated pieces.\r\n\r\nI travelled to Chichen Itza from Valladolid which took 45 minutes. To avoid the 6 hour round trip from Cancún I would advise spending tome in either Merida or Valladolid - both are nice colonial cities with their own sights and things to do. In Valladolid, you can take colectivos from outside the bus terminal (calle 39 y 44) for 30 pesos or a Oriente coach for the same price. The first collectivo left at 7 - I arrived at 7.45 and was second in line for a ticket (232 pesos).\r\n\r\nGoing early means that you can 1. Avoid the hottest part of the day, 2. Avoid the majority of vendors (who haven\'t set up yet) and 3. Avoid the majority of tourists. When I was reading the TA reviews prior to my trip these seemed to be the three biggest complaints. \r\n\r\nThat being said, I was able to take tourist-less photos still at 10/11 AM - it just takes a bit of patience and the right angle.\r\n\r\nI opted to have a tour guide as I wanted to be able to understand the full significance of what I was seeing. Non-Spanish tours are 750 pesos. As I was travelling alone I opted to do a \'Collective tour\' with a group of people. I did have to wait 45 minutes until other people arrived who also wanted to do a group tour however with the seven of us we only had to pay 107 pesos each - and we learnt more as there were more questions asked. If getting a local guide I would suggest speaking with them first to ensure they have sufficient skill in the chosen language - especially if you are paying the full 750!\r\n\r\nThe ruins themselves are grand and great as many reviewers have detailed. The cenote is also picturesque. There are small placards beside each monument detailing what things are. In addition to seeing New Chichen Itza (where the temple and ball court are) go beyond this to the Old Chichen Itza - it\'s quieter, has more shade, and has lots more ornate buildings to see!\r\n\r\nDefinitely visit Chichen Itza if in Yucatán and make sure you bring: comfortable shoes, water, repellent, sun cream and umbrella/sunhat, and wet wipes to cool off.', 19, 6, 4, '2013-12-16', 26, 1, 0),
(2, 2, 'On my own again in Potosí and Sucre', 'From La Paz i took a snazzy (it had leather seats) overnight \'cama\' bus to Potosí. I spent the first day walking around the town but there really wasn\'t that much to do or see.\r\n\r\nMy second day was slightly more eventful, starting with a trip to the mines within \'Cerro Rico\'. Cerro Rico is a mountain that towers over the city, and sits atop a large deposit of siver and other minerals. It was the biggest mine in the world during the Spanish colonial period.\r\n\r\n Our guide, a crazy man, and ex-miner, called Pedro started off by taking us to the miners\' market. Here, they freely sell dynamite, even to children! We bought gifts of coca leaves, beverages and exercise books (for their children) for the miners and then set off to get geared up. We were given overalls, boots and helmets so definitely looked the part! \r\n\r\nBefore visiting the mines, we visited a mineral refinery. There were lots of machines, apparently processing the silver but I didn\'t really understand how.\r\n\r\nI had a blast in the mines! They were really stable, not what I was expecting. We had to crouch in some places and I hit my head more times than I can remember - it was hard to judge my height with my helmet on!\r\n\r\nWe weaved our way through, frequently stopping to give away our gifts and for Pedro to give us background info to the mines. The youngest miner we saw there was 15 years old.\r\n\r\nHalf way through we had to climb a series of 3 vertical ladders in order to reach \'Tio\'. I was so out of breath by the end that I almost had a panic attack hehe. Counting to 15 helped me breathe normally again.\r\n\r\nTio is the andean devil who protects the miners - they make offerings of alcohol and coca leaves to him. We sat in front of Tio and Pedro told us about the comraderie and the nicknames that the miners have for one another. These included \'ruso\' (russian), \'barbie\' (apparently the miner looks like a girl), \'chicken-stealer\', and \'pipe\' (this miner who has been married a long time but has no children).\r\n\r\nAfter the mines I visited the cathedral expecting to have a quick wander round and look at the views from the belltower. Instead i was greeted by a zany guide who took us on a tour of the building. He insisted on giving us 3 Brits a Spanish lesson by talking in slow and very animated Spanish the whole time (despite being able to speak english himself). He also quizzed us on Christinaity and our historical knowledge - excitedly hi-5-ing us whenever one of us got something correct.\r\n\r\nIn the evening I met with Pedro and most of the people from the mining tour earlier in the day to watch a Bolivian Premier league match - Potosí vs Santa Cruz. Potosí, as the home team, had the advantage of being accustomed to at an altitude of 4000m above sea level. They won 3-0 with two men from Santa Cruz being sent off in the process. The stadium only had about 100 people in it. Peculiar things I saw duing the game included: a dog sitting in he stands, five year olds selling cigarettes, and armed guards on the pitch breaking up the teams at the end - apparently that\'s normal.\r\n\r\nWith not much else to do in Potosí, I moved onto Sucre, the \'ciudad blanca\' (white city). I spent 5 days here, it was much warmer than La Paz and Potosí so I made the most of it! I ate better, topped up my vitamin D and spent a lot of time wondering the various markets.\r\nOne tourist attraction I did visit (once I figured out how to navigate the local buses/campervans) was the Dino park. The attraction surrounds a set of dinosaur footprint that were found in a cement quarry. Our tour guide took us right up close to them and told us about the type of dinosaurs that created them. There were also life sized replicas of the beasts to aid our imagination.\r\n\r\nSucre is a really pretty city and the real capital of Bolivia (it says so in section 6 of the constitution apparently), although everyone seems to think of La Paz as the capital. It´s a young and vibrant city so I was able to kick back and relax a little.', 5, 7, 1, '2014-06-14', 17, 1, 2),
(3, 1, 'Top things to see in Springfield', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt.', 30, 6, 5, '2019-04-12', 2, 1, 3),
(9, 1, 'World Cup in Brazil', '<u>Match of the tournament</u><br>Brazil 1-7 Germany. There was a point, after 0-0 had raced to 0-5 in the space of 18 minutes, when the goals were coming too quickly to take accurate notes, there were people screaming – literally screaming – beside the pressbox, and I can remember looking at Dominic Fifield next to me and we were both just laughing. It was that kind of what-the-hell-is-going-on kind of laughter.\r\n<br>\r\n<u>Player of the tournament</u><br>Thomas Müller. It seems strange now but, until the semi-final, I would probably have gone for David Luiz. From that point onwards, it was like a switch had gone off in his head.\r\n<br>\r\n<u>Goal of the tournament</u><br>Tim Cahill, Australia v Holland. An honorary mention to James Rodríguez but, unfortunately, I missed his best moments. That’s the only bad thing when you are doing this job at a World Cup: you actually see surprisingly little of the football. You’re either flying, on the road, writing or standing in a queue somewhere.\r\n<br>\r\n<u>Personal highlight</u><br>Being there on Sunday night. The World Cup final, in the Maracanã. Football can make you cynical sometimes but then there are moments like that when you actually remember why you fell in love with the sport in the first place.\r\n<br>\r\n<u>Biggest disappointment</u><br>Holland 0 Argentina 0. All those great players and yet there’s no point dressing it up – the semi-final was an absolute stinker. I was also quite disappointed in myself for swearing at a small Japanese man in the queue at São Paulo airport one day. He had, in fairness, sneezed on my head.', 6, 7, 1, '2019-04-20', 12, 1, 24),
(12, 2, 'Best Diving in Thailand', 'Depending on the seasons, you could find yourself diving in the Andaman Sea or in the Gulf of Thailand.\r\n\r\nWondering where to find the best places to dive in Thailand? I’ve done some research. In this post, you’ll find out more about where to dive in Thailand, what are the best seasons when it comes to diving in Thailand and everything you should know before your trip (including what to pack).\r\n\r\nThe best time to dive in the Andaman Sea would be from November to May. It could be possible to dive during the rainy season, but the visibility will be reduced. When it comes to diving, we all want great visibility, isn’t that right?\r\n\r\nTo make it easier for you, I have divided the dive sites by land locations. That way you can see the options around your destinations.\r\n\r\n \r\n\r\nBest Diving Around Koh Lanta, Thailand\r\n \r\n\r\nDiving from Koh Lanta isn’t necessarily the cheapest as some of the dive sites are located quite far from the island. Some sites are much closer to Koh Phi Phi or Phuket. Although, if you aren’t planning on heading there during your Thailand trip, you can still access these dive sites from Koh Lanta.', 26, 4, 4, '2015-01-04', 0, 1, 0),
(13, 7, 'Europe Travel Guide: Money Saving Tips', 'Individual country guides have more specific information but here are some general tips help you backpack Europe on a budget:\r\n\r\nPicnic – This continent has a lot of little tiny shops where you can be pre-made sandwiches or ingredients to make your own. Buy some food, eat outside, and watch the city go by. It’s a much more enjoyable and cheaper way to eat.\r\nCouchsurf – Hostels can add up really quick. If you don’t have any friends with whom you can stay, consider using the service Couchsurfing, which lets you connect with locals who will let you stay with them for free.\r\nEat local and cheap – Not into picnicking? That’s ok, there are other ways to save money on food. Eat at local sandwich shops, pizza parlors, Maoz, Wok to Walks, outdoor street vendors, and the like. Avoiding restaurants and eating at a lot of the local “grab n’ go” places will give you a taste of the local cuisine at a much cheaper price.\r\nCamp in a garden – A very good camping service specific is Campspace, which allows you to pitch a tent in someone’s backyard for free or a nominal fee (around 4-10 EUR). This is a new service that started in 2010 but more and more people are signing up for it each day. All of the garden owners have profiles that tell you what services and facilities they offer.\r\nTake the bus – Budget bus companies like Flixbus can take you across the continent for cheap. It isn’t glamorous, but for tickets starting at 5 EUR (6 USD) you really can’t complain!\r\nGet a Rail Pass – Eurail Passes have saved me hundreds of dollars when I traveled around. If you are traveling far distances and through many countries, they are a great deal.\r\nTake the free city tours – One of the great things about Europe is that you can find free walking tours in all the major cities. They can be a great way to see the city attractions, take in some history, and learn your bearings without spending any money.\r\nPlan accordingly – Transportation can eat into your budget. Traveling costs money. A good way to save money is to avoid moving in weird directions. Move in a straight line, and avoid doubling back and avoid paying too much for transportation.\r\nFly cheap – If you know where you are going and a train won’t do, try to book flights early. You can often get round trip fares as little as 5 EUR (6 USD) from many of the discount airlines that fly through Europe like Ryanair or Easyjet.\r\nDrink less – Those 5 EUR (6 USD) beers really add up. Hit happy hour or pick and choose when you party. Hostel bars are a good place to get cheap drinks or buy your alcohol at the supermarket. Partying your way across the continent will destroy your bank balance in no time.\r\nGet a city tourist card – Local tourism offices issue a tourist card for all their attractions, tours, and restaurants. This card gives you free entry and substantial discounts on all the attractions and tours in a city, free local public transportation (a huge plus), and discounts at a few restaurants and shopping malls. They save a ton of money. If you plan on doing a lot of sightseeing, get one of these cards.\r\nHave an ISIC Card – To save 20-50% on the cost of admission to museums and other tourist attractions, be sure to present a valid student card. The ISIC is typically accepted in places where a foreign student ID is not.\r\nRideshare – If you’re flexible in your schedule, use the ridesharing service BlaBlaCar and catch rides with locals between cities (or countries). I used this service in Switzerland and, not only did I save a lot of money, but I got to meet interesting people to and learn about local culture and life. Drivers are verified and it’s perfectly safe (though sometimes rides don’t show up, which is why you need to be flexible).', 11, 5, 5, '2019-02-26', 0, 1, 0),
(14, 7, 'Europe Travel Guide: Money Saving Tips', 'Individual country guides have more specific information but here are some general tips help you backpack Europe on a budget:\r\n\r\nPicnic – This continent has a lot of little tiny shops where you can be pre-made sandwiches or ingredients to make your own. Buy some food, eat outside, and watch the city go by. It’s a much more enjoyable and cheaper way to eat.\r\nCouchsurf – Hostels can add up really quick. If you don’t have any friends with whom you can stay, consider using the service Couchsurfing, which lets you connect with locals who will let you stay with them for free.\r\nEat local and cheap – Not into picnicking? That’s ok, there are other ways to save money on food. Eat at local sandwich shops, pizza parlors, Maoz, Wok to Walks, outdoor street vendors, and the like. Avoiding restaurants and eating at a lot of the local “grab n’ go” places will give you a taste of the local cuisine at a much cheaper price.\r\nCamp in a garden – A very good camping service specific is Campspace, which allows you to pitch a tent in someone’s backyard for free or a nominal fee (around 4-10 EUR). This is a new service that started in 2010 but more and more people are signing up for it each day. All of the garden owners have profiles that tell you what services and facilities they offer.\r\nTake the bus – Budget bus companies like Flixbus can take you across the continent for cheap. It isn’t glamorous, but for tickets starting at 5 EUR (6 USD) you really can’t complain!\r\nGet a Rail Pass – Eurail Passes have saved me hundreds of dollars when I traveled around. If you are traveling far distances and through many countries, they are a great deal.\r\nTake the free city tours – One of the great things about Europe is that you can find free walking tours in all the major cities. They can be a great way to see the city attractions, take in some history, and learn your bearings without spending any money.\r\nPlan accordingly – Transportation can eat into your budget. Traveling costs money. A good way to save money is to avoid moving in weird directions. Move in a straight line, and avoid doubling back and avoid paying too much for transportation.\r\nFly cheap – If you know where you are going and a train won’t do, try to book flights early. You can often get round trip fares as little as 5 EUR (6 USD) from many of the discount airlines that fly through Europe like Ryanair or Easyjet.\r\nDrink less – Those 5 EUR (6 USD) beers really add up. Hit happy hour or pick and choose when you party. Hostel bars are a good place to get cheap drinks or buy your alcohol at the supermarket. Partying your way across the continent will destroy your bank balance in no time.\r\nGet a city tourist card – Local tourism offices issue a tourist card for all their attractions, tours, and restaurants. This card gives you free entry and substantial discounts on all the attractions and tours in a city, free local public transportation (a huge plus), and discounts at a few restaurants and shopping malls. They save a ton of money. If you plan on doing a lot of sightseeing, get one of these cards.\r\nHave an ISIC Card – To save 20-50% on the cost of admission to museums and other tourist attractions, be sure to present a valid student card. The ISIC is typically accepted in places where a foreign student ID is not.\r\nRideshare – If you’re flexible in your schedule, use the ridesharing service BlaBlaCar and catch rides with locals between cities (or countries). I used this service in Switzerland and, not only did I save a lot of money, but I got to meet interesting people to and learn about local culture and life. Drivers are verified and it’s perfectly safe (though sometimes rides don’t show up, which is why you need to be flexible).', 11, 5, 5, '2019-01-26', 0, 1, 1),
(15, 1, 'How to Get Around Europe', 'BACKPACKING EUROPE TRAVEL GUIDE FOR 2019\r\nLast Updated: April 6, 2019\r\n\r\n Backpacking Europe on a Budget: The City of Prague\r\n\r\nFrom beautiful Paris, to smoke filled coffeeshops in Amsterdam, to Oktoberfest, to the beaches of Greece, there’s so much to see in Europe that you won’t have any problem filling your time or coming up with suggested activities whether you are backpacking Europe for a few months or just spending a few weeks there on a vacation.\r\n\r\nThe continent holds wonderful beaches, historical architecture, amazing wine, and wonderful people. Every country is incredibly different than the next.\r\n\r\nI first went to Europe when I was backpacking there in 2006. I was hooked. I’ve been visiting ever year since then, have run tours through the continent, and even wrote a book to Europe travel. I am in love with Europe.\r\n\r\nThere is a lot of diversity and so many ways to get around and things to do in Europe that I wrote this Europe travel guide to help you travel better on your visit. I know how complicated figuring out rail passes, finding hostels, getting around, and finding the best stuff to do there can be.\r\n\r\nThis guide will give you an overview of Europe travel and I’ve written extensive travel guides to each of the countries on the continent so you can travel better, longer, and smarter.\r\n\r\nSo sit back and enjoy this backpacking Europe guide!\r\n\r\nTable of Contents\r\nThings to See and Do\r\nTypical Costs\r\nSuggested Budget\r\nMoney Saving Tips\r\nWhere To Stay\r\nHow to Get Around\r\nWhen To Go\r\nHow to Stay Safe\r\nBest Places to Book Your Trip\r\nGear and Packing List\r\nSuggested Reading\r\nMy Detailed Guidebooks\r\nRelated Blogs on Europe\r\nClick Here for Country Guides\r\nTop 5 Things to See and Do in Europe\r\n Visit the Greek Islands \r\n\r\n1. The Greek IslandsThese islands are the mecca of summer beach fun. The island of Ios is party central, Kos and Crete are popular destinations for Brits, Santorini has history, Mykonos is luxurious, and Paros is quiet. With hundreds of islands, you can always find what you are looking for. I try to go every summer.\r\n Ride Europe’s Famous Rail System\r\n\r\n2. Ride the railsEurope is famous for its international rail system. Rail passes make is easy to get from country to country on a relatively small budget. You’ll find lots of backpackers gazing out the windows on the diverse European landscape. Riding the European rails is one of the best ways to not only get around but see the continent!\r\n Visit Paris and All of Its Beauty\r\n\r\n3. Get lost in ParisThe city of lights is everything people say it is. I feel in love with it the first time I stepped foot in Paris. The food, the wine, the atmosphere, the history. It’s hard not to see the magic. You’ll never be able to see the city in just one visit. It would take years to see everything, but, you can get a good feel of the city in a few days.\r\n Travel to the Many Beautiful Cities in Europe\r\n\r\n4. Go city hoppingThere are so many amazing cities in Europe that we’d need a top 100 to list them all. Some of my personal favorites and must sees are: London, Edinburgh, Amsterdam, Berlin, and Barcelona, Lisbon, Prague, Tallin, Florence, and Stockholm. Criss cross the continent, take in the culture, and enjoy all the historic cities!\r\n Visit the Swiss Alps\r\n\r\n5. Hit the Swiss AlpsWhether you go skiing in the winter or hiking in the summer, the Alps hold some of the most breathtaking views in all the world. Italy, France, or Switzerland, all the alps are great! You can’t go wrong with any place you see them and they are one of the greatest natural attractions on the continent.\r\nOther Things to See and Do in Europe\r\n1. Go to Amsterdam\r\nThere’s more to the city than just coffee shops and red lights. I love Amsterdam so much, I lived here for a short period of time in 2006. Cobblestone and brick streets weave around lovely canals. Amsterdam has a vibrant art and music scene and friendly locals willing to help you out. Make sure you get out of the center into the Jordaan and Oost with their wonderful outdoor cafes.\r\n\r\n2. Hang out in Barcelona\r\nBarcelona is a city that goes 24 hours a day, 7 days a week and could give NYC a run for the “city that never sleeps” title. Be prepared for late-night dinners and parties til dawn. Barcelona knows how to get down. Besides a great food and nightlife scene, there is a wonderful beach, Gaudi architecture, and history dating back to Roman times.\r\n\r\n3. Visit Berlin\r\nHip and trendy Berlin is an energetic destination. It is one of Europe’s most affordable capital cities with a vibrant music and art scene and a growing foodie movement. There is a ton of cheap Middle Eastern food. Be sure to check out the history museum – it’s one of the best in the world.\r\n\r\n4. Drink beer at Oktoberfest\r\nOktoberfest is a must for anyone going to or near Germany at the end of September. There are people from all over the world, lots of beer, excitement, music, and wild fun. Watching thousands of people sing together, toast and party atmosphere make you feel good about the world. (Or maybe that’s just the beer?)\r\n\r\n5. Experience London\r\nGet a taste of English culture in diverse London. The museums here are some of the best in the world (and free), plus the city offers great food, and the pub culture is wonderful. Head to Brick Lane for some amazing Sunday food markets. I prefer Paris to London, but there is something sophisticated and fun about London. Just watch those pints – London is not a cheap destination.\r\n\r\n6. Hang out in Scandinavia\r\nMy favorite region in Europe is Scandinavia. The quality of life here is high, the people beautiful and friendly, the cities clean and historic. True, this area of Europe is not cheap, but there are plenty of ways to reduce your expenses. Don’t let the high prices scare you away. Highlights for me include Copenhagen, Stockholm, Gotland, Norway’s fjords, and Lapland in Finland.\r\n\r\n7. Get enchanted in Prague\r\nPrague is a beautiful city with amazing history. It’s a cheap destination and during the weekends it heaves with people enjoying the bars, cheap beer, and delicious food. It is one of the most beautiful and picturesque cities I’ve seen.\r\n\r\n8. Wine and dine along the French Riviera\r\nHave fun in the sun, hob nob with the rich and famous, and sail (or gaze at) gigantic yachts. You can pretend to live the high life for a little bit. Nice is nice and Monaco is just a skip away.\r\n\r\n9. Enjoy the great outdoors in Interlaken\r\nLocated in the beautiful mountains of Switzerland, Interlaken is a great place to unwind with some good hikes, hot chocolate, and outdoor sports. It’s a good alternative from all the cities and museums you constantly see. Interlaken is also a popular party destination for backpackers and other young travelers.\r\n\r\n10. Explore Rome\r\nThis thriving historical city has amazing food and nightlife. Moreover, with its tiny little streets to wander through (you can’t walk two feet without stumbling over a ruin), Rome is a history buff’s dream. Visit the Trastevere area for a taste of “local” Rome and chill bars. It’s my favorite area in the city.\r\n\r\n11. Hike around the Cinque Terre\r\nCinque Terre is my favorite part of Italy. These five beautiful cliff side towns are perched near warm waters and beautiful olive and grape groves. You’ll find some wondrous and strenuous hikes in these hills. For a real challenge, take trail #8. Or just walk the coastline for something less difficult.\r\n\r\n12. See Krakow\r\nKrakow looks like it stepped out of a medieval postcard. It’s even nicer than Prague! It’s a hip, trendy, and youthful city as it is the center of education in Poland. You have a lot of university students here. Most travelers come to party here (the vodka is cheap) but try to enjoy the city’s history and food besides just the bars. Auschwitz concentration camp is also close by.\r\n\r\n13. Visit the ruin bars in Budapest\r\nThe coolest nightlife in all of Europe is found in Budapest. These bars are built in abandoned buildings and lots and feature funky art installations and decor. They are amazing, fun, and great places to meet locals. People of all ages flock here. If you skip these bars, you miss out on one of most unique things about the city.\r\n\r\n14. Explore Cornwall\r\nThe best part of England is outside London, and, unfortunately, not a lot of people leave London. Head west to the area of Cornwall for cheaper prices, friendlier locals, more natural beauty, great hiking, rolling hills, small towns, and overall what you think of “traditional England.”\r\n\r\n15. Walk the Camino\r\nEl Camino de Santiago (The Way of Saint James) is an ancient pilgrimage route that stretches from France all the way across Spain. It is an 800km trail that winds through some incredible terrain, usually taking over a month to complete. Of course, you can just walk a section of it if you don’t have the time.\r\n\r\n16. Throw tomatoes during La Tomatina\r\nBy far my favorite festival, this giant food fight happens during the last Wednesday of August in Bunol, Spain. For about an hour, everyone throws tomatoes at each other and the streets become ankle deep in tomato juice. Afterward, everyone walks down to the river, cleans off, and then heads to the town square for sangria and music.\r\n\r\n17. Find more than Dracula in Romania\r\nNot a lot of people visit Romania but this is off the beaten path country in Eastern Europe has undiscovered medieval towns, gorgeous beaches on the Black Sea, and incredible hiking – all at dirt cheap prices. I spent $30 USD per day here and experienced the country without any of the crowds of central and western Europe!\r\n\r\n18. Drink fine whisky in Islay\r\nWhisky has a long history on Islay. It’s been made there since the 16th–century — first in backyards and then, starting in the 19th–century, in big distilleries. Over the years, whisky from the island came to be considered a specialty and was used to flavor a lot of other blends on the mainland. My visit here was amazing and, even if you don’t like whisky, there are tons of good hikes and walks throughout this magnificent island.\r\n\r\n19. Explore Iceland\r\nIceland is a magical country. You’ll find majestic waterfalls and hidden hot springs around every corner, with sweeping vistas unlike anywhere else in the world.With whale watching in the summer and the northern lights in the winter, there really is no bad time to visit!\r\n\r\nFor more information on specific countries, check out these guides!\r\n\r\nAustria Travel Guide\r\nBelgium Travel Guide\r\nDenmark Travel Guide\r\nEngland Travel Guide\r\nFrance Travel Guide\r\nGermany Travel Guide\r\nGreece Travel Guide\r\nHungary Travel Guide\r\nIreland Travel Guide\r\nItaly Travel Guide\r\nNetherlands Travel Guide\r\nNorway Travel Guide\r\nScotland Travel Guide\r\nSpain Travel Guide\r\nSweden Travel Guide\r\nSwitzerland Travel Guide\r\nUkraine Travel Guide\r\nPortugal Travel Guide\r\nRomania Travel Guide\r\n\r\nEurope Travel Costs\r\nAccommodation – If you’re looking to find a budget-friendly place to stay in Europe, you’re in luck! Accommodation pricing varies, and with my help, you can find the perfect place to stay, for the right price. Hostel dormitory rooms cost between 18-40 EUR (20-45 EUR) per night, depending on the room’s size and the popularity of the hostel. I stayed in a 6-bed dorm in Berlin for 15 EUR (17 USD), while the same one would have cost me around 32 EUR (36 USD) in Paris. A room in Paris will cost on the higher end and a room in cheaper Athens will cost on the lower end. Campsites cost between 9-15 EUR (10-17 USD) per night per person for a tented space.\r\n\r\nIn Eastern Europe, hostel dorm rooms cost between 6-15 EUR (7-18 USD) per night depending on the size of the dorm room and popularity of the hostel. The further east you go, the cheaper it gets. Expect to pay around 27-55 EUR (31-62 USD) per night for a private room that sleeps two.\r\n\r\nIn Scandinavia, hostel dorm beds will cost between 22-42 EUR (25-48 USD), while private rooms are 70-85 EUR (79-96 USD). Budget hotel rooms start at around 60 EUR (68 USD).\r\n\r\nMost hostels offer free linens, free WiFi, and a lot offer free breakfast but it’s important to check specific websites for exact amenities. Rooms that sleep two start at 27 EUR (31 USD) per night in a 2-star hotel. These hotels come with amenities like breakfast, private bathrooms, and WiFi. Airbnb is also available throughout Europe. You can find shared rooms starting around 10 EUR (11 USD) per night and entire homes (including studio apartments) starting around 24 EUR (27 USD).\r\n\r\nFood – Finding places to eat within your budget is easier than you think. Throughout Western Europe, you can find small shops where you can get sandwiches, slices of pizza, or sausages for between 4-7 EUR. You find these shops are most often found in train stations, bus stations, and main pedestrian areas. These small sandwich shops offer cheap food alternatives that can have you eating on between 9-15 EUR (10-17 USD) per day. Restaurant meals cost around 13-25 EUR (15-28 USD) for a main dish and drink. Food is much cheaper in the east than in the west. Even if you are eating out for all your meals, you still get by on as little as 9 EUR (10 USD) per day. You can cook your own food for around 65 EUR (74 USD) per week.\r\n\r\nYou can money by shopping for food at discount supermarkets like Profi, Lidl, Aldi, and Penny Market.\r\n\r\nIf you eat out, do so at lunch and get the prix-fixe menu (two-course or three-course set menu). Restaurants offer this set menu during lunch, and with prices between 10–20 EUR (11-23 USD), it’s a way better deal than the regular dinner menu! You can also get affordable lunches at outdoor markets. So many European cities have huge fresh food markets throughout town.\r\n\r\nIf you want to save big money on meals, head to one of the markets, pick up some cheese, wine, bread, meats, or anything else, and go to the park for a picnic. (Or grab a sandwich for later!) You’ll find the locals doing the same thing, and it’s one of the cheaper ways to get a true taste of local food.\r\n\r\nActivities – Wine tours will be your priciest activity at around 90 EUR (102 USD) per day. Going up the Eiffel Tower will cost between 7-17 EUR (8-19 USD) and visiting the Versailles Palace and Gardens will cost 25 EUR (28 USD). The Tower of London is about 28 EUR (32 USD). Bike tours and river cruises can cost 24-40 EUR (27-45 USD). Most museums and tours start at around 14 EUR/16 USD (it’s cheaper of course in the east). Full day tours cost between 35-100 EUR (40-114 USD). Prices vary drastically per country so it’s hard to give a good general cost. See country information for more details.\r\n\r\nBackpacking Europe Suggested Budgets\r\nPrices for Europe travel vary greatly depending on how far north, east, south or west your travel.\r\n\r\nIf you stick to the budget accommodations, food, and tours listed here and ignore all my tips on saving money, you’ll need about $75 USD per day in Western Europe, $45 USD in Eastern Europe, and about $100 USD in Scandinavia. Those numbers refl ect a traveler who stays in hostels, doesn’t cook meals, eats mostly cheap food, drinks, and visits a lot of attractions. This is your typical backpacker budget. You aren’t going to have a fancy time, but you aren’t going to want for anything either.\r\n\r\nHowever, by getting tourist cards and rail passes, avoiding flights, occasionally couch-surfing, and cooking some meals, you can travel a lot cheaper.\r\n\r\nIn Western Europe, you can spend between $50 USD and $60 USD per day. In Eastern Europe, which is already cheap, by implementing my tips, you can travel on around $35 USD per day. In Scandinavia, there are so few ways to save that the cheapest you can do is around $70 USD per day.\r\n\r\nOn the ultra cheap, if you were to use Couchsurfing every day (or even camped), cooked all your meals, didn’t drink, and saw a minimum of sights, you could do Western Europe on $35 USD per day, Eastern Europe on $20 USD, and Scandinavia on $50 USD. Th at would require you to take a train or a bus or hitchhike everywhere, skip most museums, and limit how often you go out.\r\n\r\nGenerally, the suggested daily budget for Europe is 40-70 EUR / 42-75 USD.\r\n\r\nDorm Bed\r\nGuesthouse\r\nMeal\r\nBus Ride\r\nAttractions\r\nAverage Daily Cost\r\nEastern Europe\r\n$5-15\r\n$28-46\r\n$1.15-4\r\n$1.15-2.30\r\n$6-8\r\n$45\r\nWestern Europe\r\n$25-40\r\n$40-68\r\n$5-8\r\n$1.70-2.85\r\n$17-23\r\n$68\r\nScandinavia\r\n$22-42\r\n$70-85\r\n$5-8\r\n$5\r\n$10\r\n$97\r\nEurope Travel Guide: Money Saving Tips\r\nIndividual country guides have more specific information but here are some general tips help you backpack Europe on a budget:\r\n\r\nPicnic – This continent has a lot of little tiny shops where you can be pre-made sandwiches or ingredients to make your own. Buy some food, eat outside, and watch the city go by. It’s a much more enjoyable and cheaper way to eat.\r\nCouchsurf – Hostels can add up really quick. If you don’t have any friends with whom you can stay, consider using the service Couchsurfing, which lets you connect with locals who will let you stay with them for free.\r\nEat local and cheap – Not into picnicking? That’s ok, there are other ways to save money on food. Eat at local sandwich shops, pizza parlors, Maoz, Wok to Walks, outdoor street vendors, and the like. Avoiding restaurants and eating at a lot of the local “grab n’ go” places will give you a taste of the local cuisine at a much cheaper price.\r\nCamp in a garden – A very good camping service specific is Campspace, which allows you to pitch a tent in someone’s backyard for free or a nominal fee (around 4-10 EUR). This is a new service that started in 2010 but more and more people are signing up for it each day. All of the garden owners have profiles that tell you what services and facilities they offer.\r\nTake the bus – Budget bus companies like Flixbus can take you across the continent for cheap. It isn’t glamorous, but for tickets starting at 5 EUR (6 USD) you really can’t complain!\r\nGet a Rail Pass – Eurail Passes have saved me hundreds of dollars when I traveled around. If you are traveling far distances and through many countries, they are a great deal.\r\nTake the free city tours – One of the great things about Europe is that you can find free walking tours in all the major cities. They can be a great way to see the city attractions, take in some history, and learn your bearings without spending any money.\r\nPlan accordingly – Transportation can eat into your budget. Traveling costs money. A good way to save money is to avoid moving in weird directions. Move in a straight line, and avoid doubling back and avoid paying too much for transportation.\r\nFly cheap – If you know where you are going and a train won’t do, try to book flights early. You can often get round trip fares as little as 5 EUR (6 USD) from many of the discount airlines that fly through Europe like Ryanair or Easyjet.\r\nDrink less – Those 5 EUR (6 USD) beers really add up. Hit happy hour or pick and choose when you party. Hostel bars are a good place to get cheap drinks or buy your alcohol at the supermarket. Partying your way across the continent will destroy your bank balance in no time.\r\nGet a city tourist card – Local tourism offices issue a tourist card for all their attractions, tours, and restaurants. This card gives you free entry and substantial discounts on all the attractions and tours in a city, free local public transportation (a huge plus), and discounts at a few restaurants and shopping malls. They save a ton of money. If you plan on doing a lot of sightseeing, get one of these cards.\r\nHave an ISIC Card – To save 20-50% on the cost of admission to museums and other tourist attractions, be sure to present a valid student card. The ISIC is typically accepted in places where a foreign student ID is not.\r\nRideshare – If you’re flexible in your schedule, use the ridesharing service BlaBlaCar and catch rides with locals between cities (or countries). I used this service in Switzerland and, not only did I save a lot of money, but I got to meet interesting people to and learn about local culture and life. Drivers are verified and it’s perfectly safe (though sometimes rides don’t show up, which is why you need to be flexible).\r\nWhere to Stay in Europe\r\nLooking for the best hostel in Europe? Check out this list of favorites (and for an even deeper selection of favorites, visit our specific city and country guides for even more options):\r\n\r\nThe Bulldog (Amsterdam, The Netherlands)\r\nCentral Station (Kiev, Ukraine)\r\nCity Backpackers (Stockholm, Sweden)\r\nEuphoria Hostel (Tallinn, Estonia)\r\nThe Flying Pig (Amsterdam, The Netherlands)\r\nFrancescos (Ios, Greece)\r\nGallery Hostel (Porto, Portugal)\r\nGenerator Hostel (Copenhagen, Denmark)\r\nGenerator Hostel (Dublin, Ireland)\r\nGoodnight Hostel (Lisbon, Portugal)\r\nGreg and Tom’s Party Hostel (Krakow, Poland)\r\nHostel Blues (Bratislava, Slovakia)\r\nHostel Mostel (Sofia, Bulgaria)\r\nKabul (Barcelona, Spain)\r\nKismet Dao (Brasov, Romania)\r\nOstello Archi Rossi (Florence, Italy)\r\nSkanstull (Stockholm, Sweden)\r\nSnuffel Backpacker Hostel (Bruges, Belgium)\r\nSophie’s Hostel (Prague, Czech Republic)\r\nSt. Christopher’s Inn (Barcelona, Spain)\r\nTallinn Backpackers (Tallinn, Estonia)\r\nWombats (Berlin, Germany)\r\nWombats (Vienna, Austria)\r\nThe Yellow (Rome, Italy)\r\nHow to Get Around Europe\r\nA key part of backpacking Europe is choosing how you’re going to travel to your next destination. Transportation around most European cities by local tram, subway, or bus is typically under 2 EUR (2.30 USD) for a one-way ticket. Intercity transportation varies widely.\r\n\r\nHere’s a breakdown of each option:\r\n\r\nBudget Airlines – Budget airlines are so prolific that competition helps keep fares low. You can often find tickets where the fare is just 5 EUR (6 USD) round-trip! Companies like Transavia, EasyJet, Ryanair, Wizz, and Vueling offer mind-blowingly cheap flights throughout Europe.\r\n\r\nBook at least a month early to scoop up great deals.\r\n\r\nMake sure that the airport they fly into isn’t too far out of your way (transportation from the secondary airport sometimes negates the savings from using the budget airline itself).\r\n\r\nAlso, keep in mind that you’ll have to pay to check your baggage on these cheap flights. It costs about 25-39 EUR (28-44 USD) for one checked bag. If you wait to pay for your luggage at the gate you’ll end up paying almost double.\r\n\r\nBuses – Buses are not quite as comfortable as Europe’s trains, although certain lines do have great amenities (like roomy seats and Wi-Fi). They also take a lot longer than trains. Buses are also not the most efficient way to travel around the continent, but they’re certainly dependable and reliable, and the cost the least. You can find last minute rides for as little as 5 EUR (6 USD). A route from Berlin to Munich is about 25 EUR (28 USD), while Paris to Bordeaux is 13 EUR (15 USD). Longer routes, like Amsterdam to Copenhagen, start at around 56 EUR (64 USD).\r\n\r\nEach country has its own national bus service, but some lines will also take you long distances internationally. Megabus (UK), Eurolines, Flixbus, and Busabout are some of the most popular companies.\r\n\r\nTrains – Train travel is a great way to see Europe, albeit sometimes not the most cost effective or efficient. Most European rail companies allow customers to purchase tickets online in advance, which is recommended for faster trains or popular trains like France’s TGV and Germany’s Deutsche Bahn. Intercity train prices vary wildly from country to country and depending on whether you take the slow train or a high-speed train.\r\n\r\nFor example, a high-speed train from Berlin to Munich costs around 190 EUR (216 USD), Bordeaux to Paris is about 95 EUR (108 USD), and Madrid to Barcelona is about 150 EUR (170 USD). Non-high speed trains and other intercity lines are a lot cheaper, generally costing about 40-50% the price of high-speed trains. Eastern Europe inter-country trains usually cost between 45-100 EUR (51-114 USD) when the ticket is booked last minute. Short trains rides of 2-3 hours within countries cost about 27 EUR (31 USD).\r\n\r\nYou may also want to consider getting a EuRail Pass, which allows travelers to explore Europe by providing a set number of stops in a specific time period. These passes are continent-wide, country specific, or regional.\r\n\r\nRide sharing/Car sharing – If you’re schedule is flexible, use a ridesharing service and catch rides with locals between cities (or countries). Drivers are verified and it’s perfectly safe. BlaBlaCar is the most popular.\r\n\r\nHitchhiking – Hitchhiking in Europe is very safe, but it’s not for everyone. Hitching is quite common around the continent, and I’ve met a number of travelers who have done it (I, myself, traveled this way in Bulgaria and Iceland). Some countries will be very supportive (Romania, Iceland, Germany) while others may be a bit more time consuming (Italy, Spain). HitchWiki is the best website for hitchhiking info.\r\n\r\nHere are my suggested articles for how to get around Europe:\r\n\r\n7 Cheap Ways to Travel Across Europe\r\nHow to Use the Sharing Economy to Travel on a Budget\r\nAre Eurail Passes a Giant Scam or Do They Save You Money?\r\nThe Ultimate Guide to Finding Cheap Flights\r\n', 12, 5, 5, '2019-02-26', 0, 1, 2),
(16, 8, 'Fuerteventura in 4 days – Road trip ', 'Fuerteventura is known to be a paradise island with more amazing beaches than any of the Canary Islands. Nevertheless, there are more things to see and do in Fuerteventura than just laying down on one of these dream beaches. We will tell you in this article where the best beaches in Fuerteventura are, but during the road trip we propose you, you will have the chance to see fascinating landscapes, picturesque villages and other incredible sights. In this post, we provide you with all the information you need to prepare your own route with the most indispensable things to see in Fuerteventura in 4 days, or if you have less time available, you can prepare your itinerary that includes the highlights to visit in Fuerteventura in 3 days.Fuerteventura can be divided into different well-defined zones and in this itinerary, you can dedicate a day to each of them without the necessity of being too much time on the road. As we usually do, our proposed route of 4 days in Fuerteventura focuses on the natural sights (mountains, viewpoints, etc.), the best beaches in Fuerteventura and authentic villages, while we skipped theme parks and other sights we consider tourist traps.\r\n\r\nAlthough Fuerteventura does not seem to be too big on the map, there are many dirt roads – for instance the one going to Cofete Beach, one of the nicest beaches in Fuerteventura -, which makes it difficult to get from one tip to another in short time. The first day in the 4-day itinerary is dedicated to the Jandia Peninsula (Península de Jandía) on the South, the second day to the mountains and villages in the interior of the island, the third day you can spend on the best Caribbean-style beaches in Fuerteventura in the  area around El Cotillo and the fourth day you will spend between the beaches and sand dunes of Corralejo Natural Park.\r\n\r\nWhat to visit in Fuerteventura in 4 days\r\nDay 1 – The Jandia Peninsula\r\nWe recommend you to spend your first entire day in the Jandia Peninsula situated at the Southeast end of the island. In this peninsula, you will visit some of the most spectacular beaches in Fuerteventura and also some other incredible and lesser-known sights.\r\n\r\nEnjoying the beaches of Jandia\r\nWithout any doubt one of the greatest things to do in Fuerteventura is simply enjoying one of the many paradise beaches situated on the Eastern shore of the Jandia Peninsula. We especially recommend you to visit several points of the Sotavento Beaches (Playas de Sotavento), a 10 km long stretch of beautiful golden sand beaches, which seem to come out of a dreamy postcard. ', 25, 5, 1, '2019-04-10', 0, 1, 5);
INSERT INTO `blog` (`BlogID`, `UserID`, `Title`, `Content`, `CountryID`, `ContinentID`, `CategoryID`, `DatePosted`, `LikeCounter`, `Published`, `ViewCounter`) VALUES
(17, 4, 'Adventures along the Great wall of China', '<p>THE GREAT WALL OF CHINA</p>\r\n\r\n<p>Welcome to Beijing, China! While on a long layover (10-hours), we decided to see one of the wonders of the world during our&nbsp;Beijing Layover Tour,&nbsp;<strong>The Great Wall of China</strong>&nbsp;was our first stop.</p>\r\n\r\n<p><img alt=\"\" src=\"https://i0.wp.com/wanderlustyle.com/wp-content/uploads/2017/07/467A6367-1000x667.jpg?resize=770%2C514\" />After about an hour drive from Beijing airport 40 miles/65km, we arrived at&nbsp;<strong>Mutianyu Great Wall.</strong>&nbsp;Mutianyu is one of the four main tourist sections of The Great Wall of China. This section is notable as the most beautiful and less crowded areas of The Great Wall.</p>\r\n\r\n<p><img alt=\"\" src=\"https://i2.wp.com/wanderlustyle.com/wp-content/uploads/2017/07/467A6380-1000x667.jpg?resize=770%2C514\" /><img alt=\"\" src=\"https://i2.wp.com/wanderlustyle.com/wp-content/uploads/2017/07/467A6672-800x1000.jpg?resize=770%2C963\" />Once our tour guide, Herbie, purchased our tickets, we headed up via&nbsp;<strong>Cable Car</strong>&nbsp;to the entrance. On the short 5-minute ride up, we saw incredible views of the surrounding area. Good thing it was a quick ride &ndash; our excitement to see The Great Wall was overflowing!</p>\r\n\r\n<p><img alt=\"\" src=\"https://i2.wp.com/wanderlustyle.com/wp-content/uploads/2017/07/467A6529-800x1000.jpg?resize=770%2C963\" />The Mutianyu section of the Great Wall is the most well-preserved part which was like stepping onto a time-capsule to the past. Overall, we walked approximately a mile out and back, but the length reaches as far as 3.4 miles/5,400 meters. To be frank, it was scorching, and I&rsquo;m glad we didn&rsquo;t walk further than we did. Hawaii is hot, but the trade-winds keep it fresh, however, that China heat was stagnant and unbearable.</p>\r\n\r\n<p><strong>Tip: Time your trip to the wall in the cooler months!</strong><img alt=\"\" src=\"https://i0.wp.com/wanderlustyle.com/wp-content/uploads/2017/07/467A6443-1000x667.jpg?resize=770%2C514\" /></p>\r\n\r\n<p><img alt=\"\" src=\"https://i0.wp.com/wanderlustyle.com/wp-content/uploads/2017/07/467A6435-800x1000.jpg?resize=770%2C963\" /></p>\r\n\r\n<p><strong>Some interesting history:</strong><br />\r\n&ndash; The reason this section is so well preserved is because the valley it protects is a leading line into important government centers and temples (Beijing capital).<br />\r\n&ndash; Construction began in 500 CE and continued to be worked on sporadically throughout&nbsp;the years. Even to this day, it is being maintained and repaired which is a major contributor to its longevity.</p>\r\n\r\n<p>After a fantastic time at the Great Wall, it was time to head back down. The cable car was available, but we went with the&nbsp;<strong>Toboggan ride</strong>. It was a first time for everyone and was a highlight of our China stop over. Instead of fancy electronics, gravity was the propulsion, and you control the speed with a brake lever. It was one of the most exciting activities we&rsquo;ve done and was so worth the extra cost!</p>\r\n\r\n<p><strong>Tip: The Toboggan is closed if raining.</strong><img alt=\"\" src=\"https://i2.wp.com/wanderlustyle.com/wp-content/uploads/2017/07/DSC02846-1000x714.jpg?resize=770%2C550\" /></p>\r\n\r\n<p>If you ever have a stop over in Beijing for a few hours, definitely visit the<strong>&nbsp;Great Wall of China through Mutianyu</strong>. It was one of the greatest experience we had during our tour and would love to do the toboggan ride again!</p>\r\n', 9, 4, 4, '2019-04-27', 0, 1, 10),
(18, 3, 'Cats in Greece - my favourite!', '<p>For a cat lover like myself, seeing cats during my travels is pretty exciting. I love snapping a photo or two and petting them if they are friendly. I remember feeding a lot of the stray cats in Asia too. The cats we meet are mostly stray cats,&nbsp;which we don&rsquo;t see at all in Sweden. It could too cold for cats to be out homeless, but also, maybe stray cats are usually reported and then picked up to be brought to a local animal shelter. I volunteer a few times a month at a local cat shelter and there are quite a few kitties looking for a permanent home there.</p>\r\n\r\n<p>During our recent trip to Greece, we saw so many cats. They looked like they were mostly well-fed but still homeless. We read that Greeks feed and take care of the stray dog and cat population.&nbsp;Souvenir postcards even have cats in the photo and when I mentioned to a colleague that I was in Greece this summer, she said, there must have been lots of cats! I guess people just associate cats with the beautiful towns of Greece?</p>\r\n\r\n<p>During our stay on Paros island, an island in the Cyclades area, we saw an organization that takes care of stray animals called&nbsp;<strong>PAWS &ndash; Paros Animal Welfare Society</strong>. I think it is wonderful that there is an organization like this in a country where there are so many stray animals.</p>\r\n\r\n<p>They have boxes all over town where you can drop a donation which goes to provide food for the cats in different areas of the island. They also encourage neutering of strays and arrange adoption or temporary homes for the cats and other animals as well.</p>\r\n\r\n<p>These cats were at the guest house where we stayed on Santorini island. Two young kittens and the mom, super cute and loved Greek Yogurt and my spinach pastries. The lady at the guest house said as long as we don&rsquo;t let them in our room, they were fine to hang out around our place.</p>\r\n\r\n<p>Now that summer is coming to an end, there won&rsquo;t be as many tourists on the Greek islands. Many of the shops and hotels will be closing for low season and the cats won&rsquo;t have as many people to feed&nbsp;them.</p>\r\n\r\n<p>Consider making a donation&nbsp;to&nbsp;<strong>Paros Animal Welfare Society</strong>. Help them continue to take care of the Cats of Greece. And always be sure to support your local animal shelter! Adopt don&rsquo;t shop!</p>\r\n', 13, 5, 1, '2019-04-27', 0, 1, 3);

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
(34, 9, 5, '  lovely post love brazil', '2019-04-23 15:01:56', '  balletboy'),
(35, 9, NULL, ' great post', '2019-04-23 15:22:38', '  name'),
(43, 9, 4, 'I wish I went -  looks like I missed out!', '2019-04-27 17:26:00', 'iclimbmountains'),
(44, 17, 3, 'Looks like you had a great time! Thinking that I should add China to my bucket list :P', '2019-04-27 17:39:40', 'catlover'),
(45, 18, 2, 'Interesting post! My aunt loves taking cat food wherever she goes in case she comes across a stray cat - she&#39;s crazy', '2019-04-27 17:43:25', 'Faith');

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
  `Password` varchar(255) NOT NULL,
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
(6, 'Faithtest', 'faithege@hotmail.co.uk', '123456', 1, NULL, NULL),
(7, 'Neil', 'n@g.com', '$2y$10$21XMltKyTcuzb88pl5Dx0.5um02McCCzNblvTSlQPSq', 1, NULL, NULL),
(8, 'Mandar', 'm@g.com', '$2y$10$LkB6Cjbj.3O6PyBnrVXwnuQ3bBu7UuiT9KCFfVM8mfI', 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `userfeedback`
--

CREATE TABLE `userfeedback` (
  `FeedbackID` int(11) NOT NULL,
  `FullName` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `Email` varchar(100) COLLATE latin1_general_ci NOT NULL,
  `DatePosted` date DEFAULT NULL,
  `Comments` text COLLATE latin1_general_ci
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_general_ci;

--
-- Dumping data for table `userfeedback`
--

INSERT INTO `userfeedback` (`FeedbackID`, `FullName`, `Email`, `DatePosted`, `Comments`) VALUES
(3, 'Faith Ege', 'faithege@hotmail.co.uk', NULL, 'What a wonderful website this is - thank you!'),
(4, 'Elliot Mercure', 'elliot@mercure.com', '2019-04-27', 'How do I discuss advertising my hotel on your page?'),
(691, 'Hannah Banana', 'hannahb@test.com', '2019-04-27', 'Really great website!'),
(692, 'Tony Thomas', 'tonyt@gmail.com', '2019-04-27', 'Please help me, I&#39;m having trouble uploading photos');

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
-- Indexes for table `userfeedback`
--
ALTER TABLE `userfeedback`
  ADD PRIMARY KEY (`FeedbackID`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `blog`
--
ALTER TABLE `blog`
  MODIFY `BlogID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

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
  MODIFY `CommentID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

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
  MODIFY `UserID` smallint(5) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `userfeedback`
--
ALTER TABLE `userfeedback`
  MODIFY `FeedbackID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=693;

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
