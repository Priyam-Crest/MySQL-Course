-- 1. Finding 5 oldest users
SELECT * FROM users
ORDER BY created_at
LIMIT 5;

-- 2. Most Registerd User On Weekday
SELECT 
	WEEKDAY(created_at) AS day_num, 
    COUNT(*) as total_user 
FROM `users` 
GROUP by day_num 
order by total_user DESC;

-- 3. Finding Inactive users who doesn't post any photo
SELECT 
	us.id as userID, 
    username 
from users us 
left JOIN photos ph 
on ph.user_id = us.id 
WHERE ph.id is null;

-- 4. identify Most likes Photo with username and image_url
SELECT 
	us.username,
    likes.photo_id,
    photos.image_url,
    count(*) as total_likes 
FROM likes 
left join users us 
	on us.id = likes.user_id
INNER JOIN photos
	ON likes.photo_id = photos.id
GROUP by likes.photo_id
ORDER by total_likes DESC
LIMIT 1;

-- 5. How many avrage post by user
SELECT 
	(SELECT Count(*) photos) / (SELECT Count(*) FROM   users) AS avgPOST; 
    
-- 6. Top 5 most populer hastags with their name
SELECT tag_name, COUNT(*) as total_use 
FROM `photo_tags`
left JOIN tags 
	on photo_tags.tag_id = tags.id
GROUP by tag_id
ORDER by total_use desc
LIMIT 5;

-- 7. Find user who liked every photos
SELECT us.id as userID, us.username, COUNT(*) as num_likes
FROM users as us 
INNER JOIN likes
	ON us.id = likes.user_id
GROUP by us.id
HAVING num_likes = (SELECT COUNT(*) FROM photos);




-- TRIGGER EVENT
DELIMITER $$

CREATE TRIGGER prevent_self_follows
	BEFORE INSERT ON follows FOR EACH ROW
    BEGIN
    	IF NEW.follower_id = NEW.followee_id
        THEN 
        	SIGNAL SQLSTATE '45000'
            	SET MESSAGE_TEXT = "You cannot allowed to follow yourself.";
        END IF;	
	END;
$$
DELIMITER ;




DELIMITER $$

CREATE TRIGGER create_unfollow
    AFTER DELETE ON follows FOR EACH ROW 
BEGIN
    INSERT INTO unfollows
    SET follower_id = OLD.follower_id,
        followee_id = OLD.followee_id;
END$$

DELIMITER ;