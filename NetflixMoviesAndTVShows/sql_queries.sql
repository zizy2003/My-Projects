-- CREATE DATABASE netflixmoviesdata;

CREATE TABLE IF NOT EXISTS netflix_titles (
show_id VARCHAR(20) PRIMARY KEY,
type2 VARCHAR(10) NOT NULL,
title TEXT NOT NULL,
director TEXT ,
cast_members TEXT,
country TEXT ,
date_added DATE ,
release_year INTEGER NOT NULL,
rating VARCHAR(5),
duration TEXT NOT NULL,
listed_in TEXT NOT NULL,
description TEXT NOT NULL


);
-- Quick check for a table
SELECT * FROM netflix_titles;

-- Changing data type of date_added column
ALTER TABLE netflix_titles
ALTER COLUMN date_added TYPE TEXT;

--Changing name of type column
ALTER TABLE netflix_titles
RENAME COLUMN "type" TO type2;

-- Changing type of rating column
ALTER TABLE netflix_titles
ALTER COLUMN rating TYPE VARCHAR(10);

-- Changing condition to import data (allow null values)
ALTER TABLE public.netflix_titles ALTER COLUMN duration DROP NOT NULL;

-- Changing data type of date_added column back
ALTER TABLE netflix_titles
ALTER COLUMN date_added TYPE date USING date_added::date;

--Checking what rows have null values in director column
SELECT title,director FROM netflix_titles
WHERE cast_members IS NULL;

--Removing null values in director column , replace them with N/A 
SELECT show_id, type2,title,
CASE WHEN director IS NULL THEN 'N/A' ELSE director END AS director
FROM netflix_titles

-- Сount the number of each missing value in the table, creating a cte
WITH nulls AS (
SELECT COUNT(*) as total_rows,
SUM(CASE WHEN type2 IS NULL THEN 1 ELSE 0 END) as type2_null,
SUM(CASE WHEN title IS NULL THEN 1 ELSE 0 END) as title_null,
SUM(CASE WHEN cast_members IS NULL THEN 1 ELSE 0 END) as cast_members_null,
SUM(CASE WHEN country IS NULL THEN 1 ELSE 0 END) as country_null,
SUM(CASE WHEN date_added IS NULL THEN 1 ELSE 0 END) as date_added_null,
SUM(CASE WHEN release_year IS NULL THEN 1 ELSE 0 END) as release_year_null,
SUM(CASE WHEN rating IS NULL THEN 1 ELSE 0 END) as rating_null,
SUM(CASE WHEN duration IS NULL THEN 1 ELSE 0 END) as duration_null,
SUM(CASE WHEN listed_in IS NULL THEN 1 ELSE 0 END) as listed_in_null,
SUM(CASE WHEN description IS NULL THEN 1 ELSE 0 END) as description_null

FROM netflix_titles
) 
SELECT * FROM nulls;

-- Replacing missing values using function COALESCE
SELECT show_id, type2,title,
COALESCE(cast_members , 'N/A') AS cast_members,
COALESCE(country , 'N/A') AS country,
COALESCE(TO_CHAR(date_added , 'YYYY-MM-DD') , 'N/A') AS date_added,
COALESCE(rating, 'N/A') AS rating,
COALESCE(duration , 'N/A') AS duration
FROM netflix_titles

--Checking for duplicates in only one possible column
SELECT *
FROM netflix_titles n
WHERE EXISTS (
SELECT title
FROM netflix_titles n2
WHERE n2.title = n.title 
GROUP BY n2.title
HAVING COUNT(*) > 1
);

--Calculating the leading types of content on netflix(either film or tv show)
WITH stats AS (
  SELECT 
    COUNT(*) AS total_titles,
    COUNT(CASE WHEN type2 = 'Movie' THEN 1 END) AS movie_count,
    COUNT(CASE WHEN type2 = 'TV Show' THEN 1 END) AS tv_show_count
  FROM netflix_titles
)
SELECT 
  n.*,
  s.total_titles,
  s.movie_count,
  s.tv_show_count
FROM netflix_titles n
CROSS JOIN stats s;

--Finding what countries the most produce content on netflix
SELECT country , COUNT(*) as content_count
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY content_count DESC;

--Count the amount of content by year on Netflix
SELECT
EXTRACT(YEAR FROM date_added)::INT as year,
COUNT(*) as content_count
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year
ORDER BY year ASC;
--Looking for the most popular genres in data set 
WITH genre_split AS (
SELECT TRIM(genre) as genre
FROM netflix_titles , 
unnest(string_to_array(listed_in, ',')) AS genre
WHERE listed_in IS NOT NULL 
)
SELECT genre , COUNT(*) as content_count FROM genre_split 
GROUP BY genre
ORDER BY content_count DESC
-- Number of films and tv show by genres and rating
WITH genre_split AS (
SELECT TRIM(genre) as genre, rating
FROM netflix_titles , 
unnest(string_to_array(listed_in, ',')) AS genre
WHERE listed_in IS NOT NULL AND rating IS NOT NULL
)
SELECT genre , COUNT(*) as content_count , rating FROM genre_split 
GROUP BY genre, rating
ORDER BY content_count DESC

--Also removing an wrong row which I didn't notice in part 1 
-- DELETE FROM netflix_titles WHERE rating = '66 min'

--Finding an average film duration as well as tv show , minimal duration(in minutes) , minimal duration(in seasons for TV Show) , maximum duration and maximum duration in season for TV show.
SELECT 
'Movie' as type2,
ROUND(AVG(duration),2) AS avg_film_duration,
MIN(duration) AS min_film_duration,
MAX(duration) AS max_fim_duration
FROM (
SELECT CAST(REPLACE(duration , ' min' , '') AS INTEGER) as duration
FROM netflix_titles
WHERE type2 = 'Movie' and duration LIKE '%min%'
) as movie_duration

UNION ALL

SELECT
'TV Show' as type2,
ROUND(AVG(duration) ,2 ) AS avg_tv_show_duration_seasons,
MIN(duration) AS min_tv_show_duration_seasons,
MAX(duration) AS max_tv_show_duration_seasons
FROM (
SELECT CAST(REGEXP_REPLACE(duration , '[^0-9]', '' , 'g') AS INTEGER) AS duration
FROM netflix_titles
WHERE type2 = 'TV Show' and duration LIKE '%Seasons%'
) as tv_show_duration;

--Finding most frequent directors and actors in dataset
WITH director_split  AS (
SELECT 
TRIM(director_name) as director, COUNT(*) AS count_of_appear , 'Director' as role
FROM netflix_titles,
UNNEST(string_to_array(director, ',')) AS director_name
WHERE director IS NOT NULL
GROUP BY TRIM(director_name)

)
,
actors_split  AS (
SELECT 
TRIM(actors) as cast_members, COUNT(*) AS count_of_appear , 'Actor' as role
FROM netflix_titles,
UNNEST(string_to_array(cast_members, ',')) AS actors
WHERE cast_members IS NOT NULL
GROUP BY TRIM(actors)
) 

SELECT *
FROM (
SELECT * FROM director_split
UNION ALL
SELECT * FROM actors_split

) AS combined
ORDER BY count_of_appear DESC;


