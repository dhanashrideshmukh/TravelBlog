##Select all blogs where published is true

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
ORDER BY b.DatePosted DESC