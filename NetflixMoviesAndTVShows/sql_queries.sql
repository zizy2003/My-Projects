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
CREATE OR REPLACE VIEW netflix_content_stats AS
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
CREATE OR REPLACE VIEW distribution_by_countries AS
SELECT country , COUNT(*) as content_count
FROM netflix_titles
WHERE country IS NOT NULL
GROUP BY country
ORDER BY content_count DESC;

--Count the amount of content by year on Netflix
CREATE OR REPLACE VIEW distribution_by_year AS
SELECT
EXTRACT(YEAR FROM date_added)::INT as year,
COUNT(*) as content_count
FROM netflix_titles
WHERE date_added IS NOT NULL
GROUP BY year
ORDER BY year ASC;
--Looking for the most popular genres in data set 
CREATE OR REPLACE VIEW distribution_by_genres AS
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
CREATE OR REPLACE VIEW distribution_by_genres_and_rating AS
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
CREATE OR REPLACE VIEW film_tvshow__duration AS
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
CREATE OR REPLACE VIEW directors_and_artists_count AS
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


--Where Netflix invests the most
SELECT genre, 
ROUND(content_count * 100.00 / SUM(content_count) OVER() , 2) || '%' as portfolio_percentage
FROM distribution_by_genres
ORDER BY content_count DESC;


--Number 5 genres where netflix invests the most
SELECT 
genre, content_count,
CASE 
WHEN content_count > 1000 THEN 'High Investment'
WHEN content_count > 500 THEN 'Medium Investment'
ELSE 'Low Investment'
END as investment_level

FROM distribution_by_genres
ORDER BY content_count DESC
LIMIT 10;

--Where netflix has a gap in content
SELECT genre, content_count
FROM distribution_by_genres
WHERE content_count < 100
ORDER BY content_count DESC;




SELECT * from distribution_by_year
ORDER by content_count DESC;


SELECT * from distribution_by_genres_and_rating
ORDER by content_count DESC
;


SELECT * from netflix_content_stats



UPDATE netflix_titles 
SET rating = NULL 
WHERE rating LIKE '% min';


--Where Netflix invests the most
SELECT country, content_count,
       ROUND(content_count * 100.00 / SUM(content_count) OVER(), 2) || '%' as market_share
FROM distribution_by_countries
WHERE country NOT LIKE '%,%'    
ORDER BY content_count DESC;

--Checking for which audition Netflix targets the most
SELECT COUNT(*) as titles_count , rating,
ROUND(COUNT(*) * 100.00 / SUM(COUNT(*)) OVER() , 2) || '%' as rating_percent

from NETFLIX_content_stats
WHERE rating IS NOT null
GROUP BY rating
ORDER BY COUNT(*) DESC
;


--Directors/Actors who brings more content 
WITH collaboration_analysis AS (
    SELECT director, role, count_of_appear,
           CASE 
               WHEN count_of_appear > 10 THEN 'Strategic Partner'
               WHEN count_of_appear > 5 THEN 'Regular Collaborator'
               ELSE 'One-Off Project'
           END as partnership_level,
           ROW_NUMBER() OVER (PARTITION BY role ORDER BY count_of_appear DESC) as rank_in_role
    FROM directors_and_artists_count
)
SELECT 
    role,
    director,
    count_of_appear,
    partnership_level,
    rank_in_role
FROM collaboration_analysis
WHERE rank_in_role <= 10 
ORDER BY role, count_of_appear DESC;


--Current portfolio balance

SELECT movie_count, tv_show_count, total_titles,
ROUND(movie_count * 100.00 / total_titles , 1 ) || '%' as movie_percentage,
ROUND(tv_show_count * 100.00 / total_titles , 1 ) || '%' as tvshow_percentage
from netflix_content_stats
Limit 1
;


--Type analysis
SELECT 
    type2,
    CASE 
        WHEN type2 = 'TV Show' THEN avg_film_duration || ' seasons'
        ELSE avg_film_duration || ' minutes'
    END as avg_duration_with_unit,
    
    CASE 
        WHEN type2 = 'TV Show' THEN min_film_duration || ' seasons'
        ELSE min_film_duration || ' minutes'  
    END as min_duration_with_unit,
    
    CASE 
        WHEN type2 = 'TV Show' THEN max_fim_duration || ' seasons'
        ELSE max_fim_duration || ' minutes'
    END as max_duration_with_unit,
    
    (max_fim_duration - min_film_duration) as duration_range 
FROM film_tvshow__duration
ORDER BY avg_film_duration DESC;

--Investment Analysis
SELECT type2, avg_film_duration,
CASE WHEN type2 = 'Movie' THEN 'Per Movie'
ELSE 'Per Season/Episode'


END as duration_unit,

CASE
WHEN type2 = 'Movie' AND avg_film_duration > 120 THEN 'High Production Cost'
WHEN  type2 = 'Movie' AND avg_film_duration > 90 THEN 'Medium Production Cost'
WHEN  type2 = 'Movie' AND avg_film_duration < 90 THEN 'Low Production Cost(<1.5h)'

WHEN type2 = 'TV Show' AND avg_film_duration > 5 THEN 'High Production Cost'
WHEN type2 = 'TV Show' AND avg_film_duration > 2 THEN 'Medium Production Cost'
ELSE 'Low Production Cost (1-2 seasons)'


END as production_info
FROM film_tvshow__duration;

--Time Strategy Analysis

SELECT  year, content_count,
CASE WHEN year >= 2020 THEN 'Post-Pandemic Strategy'
WHEN year >= 2017 THEN 'Expansion Era'
ELSE 'Early Netflix'
END as business_phase

from distribution_by_year
WHERE year >= 2012
ORDER by content_count DESC;


--Cross-Analysis

SELECT genre,rating, content_count,
ROUND(content_count * 100.00 / SUM(content_count) OVER() , 2) as market_share

from distribution_by_genres_and_rating

Where content_count > 50
ORDER BY content_count DESC
LIMIT 15
;
