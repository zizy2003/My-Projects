# Netflix Movies and TV Shows Data Analysis
### About
---
The project aims to understand which movies and TV shows Netflix most frequently adds to the platform, which countries lead in content production, and how content changes over time.
This analysis could help streaming platforms, media researchers, and regular users understand Netflix's content preferences. The dataset was obtained from the [Kaggle Netflix Movies and TV Shows dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download) .
"Netflix is one of the most popular media and video streaming platforms. They have over 8000 movies or tv shows available on their platform, as of mid-2021, they have over 200M Subscribers globally. This tabular dataset consists of listings of all the movies and tv shows available on Netflix, along with details such as - cast, directors, ratings, release year, duration, etc." [source](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
### Purposes Of The Project
---
_The goal of the project is to analyze data from the Netflix data set to identify key patterns and trends, such as:_

- Distribution of films and series by genre and country,

- Analysis of content duration and ratings,

- Studying the dynamics of content release by year,

- Identifying popular categories and audience preferences.

### About Data
---
The dataset was obtained from the [Kaggle Netflix Movies and TV Shows dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download) . This dataset contains data from various countries and covers different types of content such as movies and series. The data contains __11 columns__ and __8800 rows__ :
| Column | Description | Data type |
|-------------|-------------|-------------|
| show_id | Unique ID for each Show/Movie in the dataset | VARCHAR(10) |
| type |  Either a movie or tv show | VARCHAR(10) |
| title |  Title of a movie or tv show | TEXT |
| director | Producer of a movie or tv show | TEXT |
| cast_members |  Actors who were involved in the movie/TV show | TEXT |
| country | Country(-ies) where the movie/tv show was filmed | TEXT |
| date_added | Date when film/tv show was added (`Month-day-year`) | DATE |
| release_year | Year when the movie/tv show was released | INTEGER |
| rating | Rating of each movie/tv show | VARCHAR(5) |
| duration | Duration of each movie/tv show `IN MINUTES OR SEASONS` | TEXT |
| listed_in | Genre(-s) of each movie/tv show (Documentaries, TV Dramas, Crimes etc.) | TEXT |
| description | Description of each movie/tv show | TEXT |

### Analysis List
---
1. Content Type Analysis🎬
> Analyze the distribution between Movies and TV Shows. Determine which type is more dominant on the platform and how their proportions vary by country or over time.
2. Country & Regional Trends🌍
> Explore the geographical distribution of content. Identify which countries produce the most content, and what genres or types are popular in different regions.
3. Release & Addition Date Analysis📆
> Compare the release year of content vs. the year it was added to Netflix. Determine trends in how recent or old the content on Netflix tends to be.
4. Genre & Category Analysis⭐
> Investigate which genres (e.g., Drama, Comedy, Documentary) are most common. Identify which genres dominate movies vs. TV shows and how they have evolved over time.
5. Rating Distribution🔞
> Analyze the distribution of content ratings (e.g., TV-MA, PG, R). This can help understand the age-targeted strategy of Netflix in different regions or years.
6. Duration Analysis⏱️
> Study the length of movies and the number of seasons for TV shows. Understand average durations and find any outliers (very long or very short content).
7. Cast & Director Frequency🎭🎬
> Examine which actors and directors appear most frequently in Netflix content. This can help identify key figures or partnerships in Netflix's content strategy.

### Approach used
---
1. Data cleaning : 
This is the first step where inspection of data is done to make sure NULL values and missing values are detected and data replacement methods are used to replace, missing or NULL values.
> 1. Build a database(netflix_titles)
> 2. Create a table
> 3. Insert a data to this table
> 4. Finding a NULL values , filling them with N/A. Also search for duplicates(when deleting them I leave the very first ID)

2. Feature Engineering : Creating a new columns from existing.

> 1. Created a cte with columns `movie_count` , `tv_show_count` , `total_titles` :
This will help to understand how many lines are in movies and how many are in TV shows, for further analysis. Also join cte with main table `netflix_titles`
   
> 2. Created a new column named `duration_minutes`(including max duration,min duration, avg duration).
For Movies, this extracts the duration in minutes (e.g., "90 min" → 90). For TV Shows, a different logic is applied (e.g., "2 Seasons" is handled separately).
This helps analyze the average length of content on Netflix and understand typical viewing times. 

> 3. Created a new column named `content_category`:
Categorizes titles based on their listed genres (Action, Comedy, Documentary , etc.).
This helps group and analyze what types of content dominate Netflix’s library.

> 4. Combine `genres` and `rating` CTE's to create view
 This SQL view was created to analyze how different genres of content on Netflix are distributed across various age ratings. 

> 4. Actor/Director Splitting: The `cast` and ` director` fields were split into individual entries (`actors_split` and `director_split`), then combined into a unified column to analyze frequency and prominence of people involved in the content. A count of appearances was calculated to identify the most frequent actors and directors on the platform.

> 5. Extract `year` from from the `date_added` field:
These help analyze trends over time, like what years Netflix added the most content.

3. Exploratory Data Analysis (EDA): Exploratory data analysis is done to answer the listed questions and aims of this project.

4. Visualization : The visualization allows for a deeper understanding of the distribution of content by genre, ratings, type (movies/shows), duration, and the dynamics of new titles.

📄 [Check visualiazation (PDF)](NetflixMoviesAndTVShows/reports/visualization.pdf)

4. Conclusion:

### Business Questions To Answer
---
- What type of content (Movies vs TV Shows) dominates Netflix's catalog?

- Which countries produce the most content available on Netflix?

- How has the amount of content added to Netflix changed over the years?

- What are the most common genres/categories on Netflix?

- How is content rated by age category (e.g., TV-MA, PG, etc.), and what does this suggest about Netflix's target audience?

- What is the typical duration of movies and number of seasons for TV shows?

- Who are the most frequently appearing actors and directors on Netflix?

### Code
---

For the rest of a code , follow the [sql_queries.sql](sql_queries.sql)

```sql
-- Creating a database 
-- CREATE DATABASE netflixmoviesdata;

-- Creating a table
CREATE TABLE IF NOT EXISTS netflix_titles (
    show_id VARCHAR(10) PRIMARY KEY,
    "type" VARCHAR(10) NOT NULL,
    title TEXT NOT NULL,
    director TEXT,
    cast_members TEXT,
    country TEXT,
    date_added DATE,
    release_year INTEGER NOT NULL,
    rating VARCHAR(5),
    duration TEXT NOT NULL,
    listed_in TEXT NOT NULL,
    description TEXT NOT NULL
);
```
