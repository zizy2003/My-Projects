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