/* Question: Assume there are three Spotify tables containing information about the artists, songs, and music charts. Write a query to determine the top 5 artists whose songs appear in the Top 10 of the global_song_rank table the highest number of times. From now on, we'll refer to this ranking number as "song appearances”.

Output the top 5 artist names in ascending order along with their song appearances ranking (not the number of song appearances, but the rank of who has the most appearances). The order of the rank should take precedence.

Answer: 
In order to solve this query, we will break the question in 3 parts:
1.	Find the top 10 artists by rank along with the largest number of the song appearances in the top 10 global_song_rank table.
2.	We will then rank the artists according to their number of song appearances in the previous step
3.	Lastly, we will use LIMIT to get the top 5 artists

To start off with we will use the INNER JOIN function to join the songs and global_song_rank to get a table with artist and their song rankings. We will then use the COUNT function to count the number of times an artist’s song/songs in the table and group by the artist. Lastly, we will filter for the top 10 ranks. */

SELECT
	songs.artist_id,
	COUNT(songs.song_id) AS song_count   
FROM songs
INNER JOIN global_song_rank AS ranking
	ON songs.song_id = ranking.song_id
WHERE ranking.rank <= 10
GROUP BY songs.artist_id;


/* Now we need to rank the artists based on the number of times their songs appeared in the Top 10 chart. In order to accomplish this, we use the above query as a subquery and implement DENSE_RANK window function. DENSE_RANK will help us create a ranking which will be based on the number of times an artists’ songs have appeared in a descending order. You may think RANK would essentially work the same, but we are using DENSE_RANK instead of RANK since RANK skips the next number however, in this case we do not want to skip any numbers. */

SELECT
	artist_id,
	DENSE_RANK() OVER(
			ORDER BY song_count DESC) AS artist_rank
FROM(
SELECT
	songs.artist_id,
	COUNT(songs.song_id) AS song_count   
FROM songs
INNER JOIN global_song_rank AS ranking
	ON songs.song_id = ranking.song_id
WHERE ranking.rank <= 10
GROUP BY songs.artist_id) AS top_songs;


-- In the final step we will now use CTE to find the top 5 artists and then use the JOIN function to join it with the artists table in order to their names.


WITH top_artists
AS (
	SELECT
	artist_id,
	DENSE_RANK() OVER(
				ORDER BY song_count DESC) AS artist_rank
FROM(
SELECT
	songs.artist_id,
	COUNT(songs.song_id) AS song_count   
FROM songs
INNER JOIN global_song_rank AS ranking
	ON songs.song_id = ranking.song_id
WHERE ranking.rank <= 10
GROUP BY songs.artist_id) AS top_songs)

SELECT 
  artists.artist_name, top_artists.artist_rank
FROM top_artists
INNER JOIN artists
  ON top_artists.artist_id = artists.artist_id
WHERE top_artists.artist_rank <= 5
ORDER BY top_artists.artist_rank, artists.artist_name;
