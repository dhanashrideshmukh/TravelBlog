-- phpMyAdmin SQL Dump
-- version 4.8.4
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Apr 14, 2019 at 01:27 AM
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
-- Database: `TravelBlog`
--

-- --------------------------------------------------------

--
-- Table structure for table `Blog`
--

CREATE TABLE `Blog` (
  `blogID` int(5) NOT NULL,
  `UserID` int(5) NOT NULL,
  `Title` varchar(100) NOT NULL,
  `content` text NOT NULL,
  `countryID` int(11) NOT NULL,
  `continentID` int(11) NOT NULL,
  `categoryID` int(11) NOT NULL,
  `datePosted` date NOT NULL,
  `likeCounter` int(11) NOT NULL,
  `save/published` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `Blog`
--

INSERT INTO `Blog` (`blogID`, `UserID`, `Title`, `content`, `countryID`, `continentID`, `categoryID`, `datePosted`, `likeCounter`, `save/published`) VALUES
(1, 2, 'Review: Chichen Itza', 'I thoroughly enjoyed my trip to Chichen Itza. Yes it is the most touristy Mayan Ruin but 1. Tourists can be avoid by turning up early and 2. What it doesn\'t have in solitude Chichen Itza more than makes up for in its sheer size and the degree of detail on the excavated pieces.\r\n\r\nI travelled to Chichen Itza from Valladolid which took 45 minutes. To avoid the 6 hour round trip from Cancún I would advise spending tome in either Merida or Valladolid - both are nice colonial cities with their own sights and things to do. In Valladolid, you can take colectivos from outside the bus terminal (calle 39 y 44) for 30 pesos or a Oriente coach for the same price. The first collectivo left at 7 - I arrived at 7.45 and was second in line for a ticket (232 pesos).\r\n\r\nGoing early means that you can 1. Avoid the hottest part of the day, 2. Avoid the majority of vendors (who haven\'t set up yet) and 3. Avoid the majority of tourists. When I was reading the TA reviews prior to my trip these seemed to be the three biggest complaints. \r\n\r\nThat being said, I was able to take tourist-less photos still at 10/11 AM - it just takes a bit of patience and the right angle.\r\n\r\nI opted to have a tour guide as I wanted to be able to understand the full significance of what I was seeing. Non-Spanish tours are 750 pesos. As I was travelling alone I opted to do a \'Collective tour\' with a group of people. I did have to wait 45 minutes until other people arrived who also wanted to do a group tour however with the seven of us we only had to pay 107 pesos each - and we learnt more as there were more questions asked. If getting a local guide I would suggest speaking with them first to ensure they have sufficient skill in the chosen language - especially if you are paying the full 750!\r\n\r\nThe ruins themselves are grand and great as many reviewers have detailed. The cenote is also picturesque. There are small placards beside each monument detailing what things are. In addition to seeing New Chichen Itza (where the temple and ball court are) go beyond this to the Old Chichen Itza - it\'s quieter, has more shade, and has lots more ornate buildings to see!\r\n\r\nDefinitely visit Chichen Itza if in Yucatán and make sure you bring: comfortable shoes, water, repellent, sun cream and umbrella/sunhat, and wet wipes to cool off.', 7, 6, 4, '2023-12-16', 25, 0),
(2, 2, 'On my own again in Potosí and Sucre', 'From La Paz i took a snazzy (it had leather seats) overnight \'cama\' bus to Potosí. I spent the first day walking around the town but there really wasn\'t that much to do or see.\r\n\r\nMy second day was slightly more eventful, starting with a trip to the mines within \'Cerro Rico\'. Cerro Rico is a mountain that towers over the city, and sits atop a large deposit of siver and other minerals. It was the biggest mine in the world during the Spanish colonial period.\r\n\r\n Our guide, a crazy man, and ex-miner, called Pedro started off by taking us to the miners\' market. Here, they freely sell dynamite, even to children! We bought gifts of coca leaves, beverages and exercise books (for their children) for the miners and then set off to get geared up. We were given overalls, boots and helmets so definitely looked the part! \r\n\r\nBefore visiting the mines, we visited a mineral refinery. There were lots of machines, apparently processing the silver but I didn\'t really understand how.\r\n\r\nI had a blast in the mines! They were really stable, not what I was expecting. We had to crouch in some places and I hit my head more times than I can remember - it was hard to judge my height with my helmet on!\r\n\r\nWe weaved our way through, frequently stopping to give away our gifts and for Pedro to give us background info to the mines. The youngest miner we saw there was 15 years old.\r\n\r\nHalf way through we had to climb a series of 3 vertical ladders in order to reach \'Tio\'. I was so out of breath by the end that I almost had a panic attack hehe. Counting to 15 helped me breathe normally again.\r\n\r\nTio is the andean devil who protects the miners - they make offerings of alcohol and coca leaves to him. We sat in front of Tio and Pedro told us about the comraderie and the nicknames that the miners have for one another. These included \'ruso\' (russian), \'barbie\' (apparently the miner looks like a girl), \'chicken-stealer\', and \'pipe\' (this miner who has been married a long time but has no children).\r\n\r\nAfter the mines I visited the cathedral expecting to have a quick wander round and look at the views from the belltower. Instead i was greeted by a zany guide who took us on a tour of the building. He insisted on giving us 3 Brits a Spanish lesson by talking in slow and very animated Spanish the whole time (despite being able to speak english himself). He also quizzed us on Christinaity and our historical knowledge - excitedly hi-5-ing us whenever one of us got something correct.\r\n\r\nIn the evening I met with Pedro and most of the people from the mining tour earlier in the day to watch a Bolivian Premier league match - Potosí vs Santa Cruz. Potosí, as the home team, had the advantage of being accustomed to at an altitude of 4000m above sea level. They won 3-0 with two men from Santa Cruz being sent off in the process. The stadium only had about 100 people in it. Peculiar things I saw duing the game included: a dog sitting in he stands, five year olds selling cigarettes, and armed guards on the pitch breaking up the teams at the end - apparently that\'s normal.\r\n\r\nWith not much else to do in Potosí, I moved onto Sucre, the \'ciudad blanca\' (white city). I spent 5 days here, it was much warmer than La Paz and Potosí so I made the most of it! I ate better, topped up my vitamin D and spent a lot of time wondering the various markets.\r\nOne tourist attraction I did visit (once I figured out how to navigate the local buses/campervans) was the Dino park. The attraction surrounds a set of dinosaur footprint that were found in a cement quarry. Our tour guide took us right up close to them and told us about the type of dinosaurs that created them. There were also life sized replicas of the beasts to aid our imagination.\r\n\r\nSucre is a really pretty city and the real capital of Bolivia (it says so in section 6 of the constitution apparently), although everyone seems to think of La Paz as the capital. It´s a young and vibrant city so I was able to kick back and relax a little.', 3, 7, 1, '2014-06-14', 17, 1),
(3, 1, 'Top things to see in Springfield', 'Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt.', 11, 6, 5, '2019-04-12', 1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `BlogImage`
--

CREATE TABLE `BlogImage` (
  `imageID` int(6) NOT NULL,
  `blogID` int(6) NOT NULL,
  `imageName` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `BlogImage`
--

INSERT INTO `BlogImage` (`imageID`, `blogID`, `imageName`) VALUES
(1, 1, ''),
(2, 1, ''),
(3, 3, ''),
(3, 3, '');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `Blog`
--
ALTER TABLE `Blog`
  ADD PRIMARY KEY (`blogID`);

--
-- Indexes for table `BlogImage`
--
ALTER TABLE `BlogImage`
  ADD KEY `blogID` (`blogID`);

--
-- Constraints for dumped tables
--

--
-- Constraints for table `BlogImage`
--
ALTER TABLE `BlogImage`
  ADD CONSTRAINT `blogimage_ibfk_1` FOREIGN KEY (`blogID`) REFERENCES `Blog` (`blogID`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
