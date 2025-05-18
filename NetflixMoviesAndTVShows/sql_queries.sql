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



