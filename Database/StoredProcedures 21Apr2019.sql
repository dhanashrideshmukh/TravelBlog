-- Procedures
--
#####################################
#ADD BLOG

CREATE DEFINER=`root`@`localhost` PROCEDURE `addBlog` (IN `formUsername` VARCHAR(50), IN `formTitle` VARCHAR(100), IN `formContent` TEXT, IN `formCountryName` VARCHAR(100), IN `formContinentName` VARCHAR(100), IN `formCategoryName` VARCHAR(50))  INSERT INTO blog(UserID, Title, Content, CountryID, ContinentID, CategoryID, DatePosted)
VALUES ((SELECT UserID FROM user WHERE Username = formUsername) 
        ,formTitle
        ,formContent
        ,(SELECT CountryID FROM country WHERE CountryName = formCountryName)
        ,(SELECT ContinentID FROM continent WHERE ContinentName = formContinentName)
        ,(SELECT CategoryID FROM category WHERE CategoryName = formCategoryName)
        ,CURRENT_DATE)$$

#####################################
#DELETE BLOG

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

#####################################
#FIND ALL BLOGS

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

#####################################
#FIND BLOG BY ID

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

#####################################
#UPDATE BLOG

CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBlog` (IN `formBlogID` SMALLINT(5), IN `formUsername` VARCHAR(50), IN `formTitle` VARCHAR(100), IN `formContent` TEXT, IN `formCountryName` VARCHAR(100), IN `formContinentName` VARCHAR(100), IN `formCategoryName` VARCHAR(50))  UPDATE blog SET
UserID = (SELECT UserID FROM user WHERE Username = formUsername) 
,Title = formTitle
, Content = formContent
, CountryID = (SELECT CountryID FROM country WHERE CountryName = formCountryName)
, ContinentID = (SELECT ContinentID FROM continent WHERE ContinentName = formContinentName)
, CategoryID = (SELECT CategoryID FROM category WHERE CategoryName = formCategoryName)

WHERE BlogID=formBlogID$$

DELIMITER ;

############################################
#ADD LIKE COUNTER
Create PROCEDURE addLikeCounter(IN formBlogID SMALLINT(5))

UPDATE blog SET

LikeCounter = LikeCounter+1

WHERE BlogID=formBlogID;


############################################
#SUBTRACT LIKE COUNTER
Create PROCEDURE subtractLikeCounter(IN formBlogID SMALLINT(5))

UPDATE blog SET

LikeCounter = LikeCounter-1

WHERE BlogID=formBlogID;