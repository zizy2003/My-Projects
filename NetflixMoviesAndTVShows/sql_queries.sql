CREATE DATABASE netflixmoviesdata;

CREATE TABLE IF NOT EXISTS netflix_titles (
show_id VARCHAR(10) PRIMARY KEY,
type VARCHAR(10) NOT NULL,
title TEXT NOT NULL,
director TEXT ,
cast TEXT ,
country TEXT ,
date_added DATE ,
release_year INTEGER NOT NULL,
rating VARCHAR(5),
duration TEXT NOT NULL,
listed_in TEXT NOT NULL,
description TEXT NOT NULL


);