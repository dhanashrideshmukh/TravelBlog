USE TravelBlog;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBlog`(IN `formBlogID` SMALLINT(5))
    COMMENT 'Delete a blog'
BEGIN
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
DELIMITER ;