-- Sql advance project -- spotify dataset 

-- create table
DROP TABLE IF EXISTS spotify;
CREATE TABLE spotify (
    artist VARCHAR(255),
    track VARCHAR(255),
    album VARCHAR(255),
    album_type VARCHAR(50),
    danceability FLOAT,
    energy FLOAT,
    loudness FLOAT,
    speechiness FLOAT,
    acousticness FLOAT,
    instrumentalness FLOAT,
    liveness FLOAT,
    valence FLOAT,
    tempo FLOAT,
    duration_min FLOAT,
    title VARCHAR(255),
    channel VARCHAR(255),
    views FLOAT,
    likes BIGINT,
    comments BIGINT,
    licensed BOOLEAN,
    official_video BOOLEAN,
    stream BIGINT,
    energy_liveness FLOAT,
    most_played_on VARCHAR(50)
);

select * from spotify ;
where  duration_min = 0 ;


select distinct channel from spotify ;

select distinct most_played_on from spotify ;

-------------------------------------
 -- DATA ANALYSIS - EASY CATEGORY --
-------------------------------------

/*Retrieve the names of all tracks that have more than 1 billion streams.
List all albums along with their respective artists.
Get the total number of comments for tracks where licensed = TRUE.
Find all tracks that belong to the album type single.
Count the total number of tracks by each artist.*/

--Q1. Retrieve the names of all tracks that have more than 1 billion streams.

SELECT * FROM spotify ;
WHERE stream > 1000000000 ;

--Q2. List all albums along with their respective artists.

SELECT  distinct album  ,artist    FROM spotify ; 

--Q3. Get the total number of comments for tracks where licensed = TRUE.

SELECT   track , SUM(comments) AS Total_Number_of_comments 
FROM spotify 
WHERE licensed = 'true' 
GROUP BY track ;

--Q4. Find all tracks that belong to the album type single.

SELECT  distinct track , album_type from spotify 
where album_type =  'single' ;

--Q5. Count the total number of tracks by each artist.*/

SELECT artist,COUNT(track) 
FROM spotify 
GROUP BY artist ;

-------------------------------------
 -- DATA ANALYSIS - MEDIUM CATEGORY --
-------------------------------------

/*Calculate the average danceability of tracks in each album.
Find the top 5 tracks with the highest energy values.
List all tracks along with their views and likes where official_video = TRUE.
For each album, calculate the total views of all associated tracks.
Retrieve the track names that have been streamed on Spotify more than YouTube.*/

--Q1. Calculate the average danceability of tracks in each album.

SELECT * FROM SPOTIFY ;
SELECT    album, COALESCE(AVG(danceability),0) AS Average_Danceability 
FROM spotify 
GROUP BY album 
ORDER BY Average_Danceability Desc; 

--Q2. Find the top 5 tracks with the highest energy values.

SELECT track  , energy_liveness FROM spotify 
ORDER BY energy_liveness DESC
LIMIT 5;

--Q3. List all tracks along with their views and likes where official_video = TRUE.

SELECT * FROM SPOTIFY ;

SELECT track ,
	   SUM(views) AS total_views ,
	   SUM(likes) AS Toytal_likes 
FROM spotify 
WHERE official_video = 'true' 
GROUP BY track 
ORDER BY 2 DESC ;


--Q4. For each album, calculate the total views of all associated tracks.

SELECT album ,
	   track ,
	   SUM(views)
FROM spotify 
GROUP BY 1 , 2 
ORDER BY 3 DESC ; 


--Q5. Retrieve the track names that have been streamed on Spotify more than YouTube

SELECT * FROM 
(SELECT track ,
	   --most_played_on  
	   COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END),0) AS Stream_on_Youtube, 
	   COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END ),0) AS Stream_on_Spotify
FROM spotify 
GROUP BY 1 
) AS T1 
WHERE stream_on_Spotify > stream_on_Youtube 
	AND	
	stream_on_Youtube <> 0 


-------------------------------------
 -- DATA ANALYSIS - ADVANCE CATEGORY --
-------------------------------------

/*Find the top 3 most-viewed tracks for each artist using window functions.
Write a query to find tracks where the liveness score is above the average.
Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
Find tracks where the energy-to-liveness ratio is greater than 1.2.
Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.*/

-- Q1. Find the top 3 most-viewed tracks for each artist using window functions.

WITH ranking_artist 
AS
(
SELECT artist ,
	   track ,
	   SUM(views) AS total_view,
 	   DENSE_RANK() OVER(PARTITION BY artist ORDER BY SUM(views) DESC) AS Top_3_Tracks 
FROM spotify
GROUP BY 1 , 2 
ORDER BY 1 , 3 DESC
)
SELECT * FROM ranking_artist
WHERE Top_3_Tracks <= 3 

-- Q2. Write a query to find tracks where the liveness score is above the average.

select * from spotify

SELECT 
	track , 
	artist ,
	liveness 
FROM spotify 
WHERE liveness > ( SELECT AVG( liveness ) FROM spotify )
	
-- Q3. Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.

SELECT * FROM SPOTIFY 

WITH cte
AS
(SELECT 
	   album,
	   Max(energy) AS Max_Energy ,
	   Min(energy) AS Min_Energy 
 FROM spotify
 GROUP BY 1 
)
SELECT 
	album,
	Max_Energy - min_energy as energy_difference 
from cte ;


-- Q4. Find tracks where the energy-to-liveness ratio is greater than 1.2

SELECT DISTINCT album, track, (energy / liveness) AS energy_to_live_ratio
FROM spotify
WHERE (energy / liveness) > 1.2;

-- Q5. Calculate the cumulative sum of likes for tracks ordered by the number of views, using window functions.

SELECT
    artist,
    track,
    views,
    likes,
    -- Cumulative likes in order of views
    SUM(likes) OVER (ORDER BY views DESC) AS cumulative_likes,
    -- Each track's likes as % of total likes
    ROUND(100.0 * likes / SUM(likes) OVER (), 2) AS pct_total_likes
FROM spotify
ORDER BY views DESC;


                                                       --===========================--
                                                            --PROJECT FINISHED--
                                                       --===========================--
														        --THANK YOU--
															---------------------	

															
	
