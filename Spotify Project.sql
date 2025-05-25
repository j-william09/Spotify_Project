--EDA

SELECT COUNT (*) FROM Spotify;

SELECT COUNT(DISTINCT artist) FROM Spotify;

SELECT COUNT(DISTINCT album_type)FROM Spotify;

SELECT MAX(duration_min)FROM Spotify;

SELECT MIN(duration_min)FROM Spotify;

SELECT * FROM Spotify
WHERE duration_min IN
(SELECT MIN(duration_min)FROM Spotify);

DELETE FROM Spotify
WHERE duration_min IN
(SELECT MIN(duration_min)FROM Spotify);

SELECT DISTINCT(Channel)FROM Spotify;

SELECT DISTINCT most_played_on FROM Spotify;


--1 Retrieve the names of all tracks that have more than 1 billion streams.
SELECT track FROM Spotify
WHERE Stream > 1000000000;

--2 List all the albums along with their respective artists.
SELECT DISTINCT album, artist FROM Spotify
ORDER BY artist, album; 

--3 Get the total number of comments for tracks where licensed = True.
SELECT SUM(comments) FROM Spotify
WHERE Licensed='True';

--4 Find all tracks that belong to the album type single.
SELECT track FROM Spotify
WHERE album_type ILIKE'single';

--5 Count the total number of tracks by each artist.
SELECT Artist, COUNT(DISTINCT track) AS "Total No of Tracks" FROM Spotify
GROUP BY artist
ORDER BY "Total No of Tracks" DESC;

--6 Calculate the average danceability of tracks in each album.
SELECT album, AVG(danceability) AS "Avg Danceability of Tracks" FROM Spotify
GROUP BY album
ORDER BY "Avg Danceability of Tracks" DESC;

--7 Find the top 5 tracks with the highest energy values.
SELECT track, energy FROM Spotify
ORDER BY energy DESC
LIMIT 5;

--8 List all tracks along with their views and likes where official_video = True.
SELECT track, SUM(views) AS "Total_Views", SUM(likes) AS "Total_Likes" FROM Spotify
WHERE official_video='True'
GROUP BY track
ORDER BY "Total_Views" DESC;

--9 For each album, calculate the total views of all associated tracks.
SELECT album, track, SUM(views) AS "Total_Views" FROM Spotify
GROUP BY album, track
ORDER BY "Total_Views" DESC;


--10 Retrieve the track names that have been streamed on Spotify more than Youtube.
SELECT * FROM 
(SELECT 
    track,
    COALESCE(SUM(CASE WHEN most_played_on = 'Youtube' THEN stream END), 0) AS "Streamed_on_Youtube",
    COALESCE(SUM(CASE WHEN most_played_on = 'Spotify' THEN stream END), 0) AS "Streamed_on_Spotify"
  FROM Spotify 
  GROUP BY track
) AS sub
WHERE "Streamed_on_Spotify" > "Streamed_on_Youtube" 
  AND "Streamed_on_Youtube" <> 0;

-- 11 Find the top 3 most-viewed tracks for each artist using window functions.
SELECT *
FROM (SELECT 
        artist, 
        track, 
        SUM(views) AS Total_Views,
        DENSE_RANK() OVER (PARTITION BY artist ORDER BY SUM(views) DESC) AS rank
    FROM Spotify
    GROUP BY artist, track) AS ranked
WHERE rank <= 3
ORDER BY artist, Total_Views DESC;

--12 Write a query to find tracks where the liveness score is above the average.
SELECT track FROM Spotify 
WHERE liveness > 
(SELECT AVG(liveness) FROM Spotify);

--13 Use a WITH clause to calculate the difference between the highest and lowest energy values for tracks in each album.
WITH energy_stats AS 
(SELECT 
    album, 
    MAX(energy) AS "Highest_Energy",
    MIN(energy) AS "Lowest_Energy"
  FROM Spotify
  GROUP BY album)

SELECT 
  album, 
  "Highest_Energy", 
  "Lowest_Energy",  
  "Highest_Energy" - "Lowest_Energy" AS "Energy_Difference" 
FROM energy_stats;

--14 Find tracks where the energy-to-liveness ratio is greater than 1.2.
SELECT track FROM Spotify 
WHERE energy/liveness > 1.2;

--15 Calculate the cumulative sum of likes for tracks ordered by the number of views, using windows functions.
SELECT 
       	track, 
        views, 
        likes, 
		SUM(likes) OVER (ORDER BY views) AS "Cumulative_Likes"
FROM Spotify
ORDER BY views DESC;




