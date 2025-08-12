DROP DATABASE IF EXISTS disney_plus_db;
CREATE DATABASE disney_plus_db;
USE disney_plus_db;

-- Simple table structure matching your CSV exactly
CREATE TABLE disney_content (
    show_id VARCHAR(10) PRIMARY KEY,
    type VARCHAR(20),
    title VARCHAR(500),
    director TEXT,
    cast TEXT,
    country VARCHAR(200),
    date_added VARCHAR(50),
    release_year INT,
    rating VARCHAR(15),
    duration VARCHAR(20),
    listed_in TEXT,
    description TEXT
);

-- Query 1: Check if data imported correctly
SELECT COUNT(*) as total_records FROM disney_content;

-- Query 2: See sample data
SELECT * FROM disney_content LIMIT 5;

-- Query 3: Content type distribution
SELECT 
    type,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM disney_content), 1) as percentage
FROM disney_content
GROUP BY type;

-- Query 4: Top 10 ratings
SELECT 
    rating,
    COUNT(*) as count
FROM disney_content
WHERE rating IS NOT NULL AND rating != ''
GROUP BY rating
ORDER BY count DESC
LIMIT 10;

-- Query 5: Content by decade
SELECT 
    CONCAT(FLOOR(release_year/10)*10, 's') as decade,
    COUNT(*) as content_count
FROM disney_content
WHERE release_year IS NOT NULL
GROUP BY decade
ORDER BY decade;

-- Query 6: Top 10 countries
SELECT 
    country,
    COUNT(*) as content_count
FROM disney_content
WHERE country IS NOT NULL AND country != ''
GROUP BY country
ORDER BY content_count DESC
LIMIT 10;

-- Query 7: Most common genres (first genre listed)
SELECT 
    TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) as primary_genre,
    COUNT(*) as count
FROM disney_content
WHERE listed_in IS NOT NULL AND listed_in != ''
GROUP BY primary_genre
ORDER BY count DESC
LIMIT 15;

-- Query 8: Directors with most content
SELECT 
    director,
    COUNT(*) as titles_directed,
    GROUP_CONCAT(DISTINCT type) as content_types
FROM disney_content
WHERE director IS NOT NULL 
  AND director != ''
  AND director NOT LIKE '%,%'  -- Single directors only
GROUP BY director
HAVING COUNT(*) >= 2
ORDER BY titles_directed DESC
LIMIT 15;

-- Query 9: Release year trends
SELECT 
    release_year,
    COUNT(*) as titles_released,
    COUNT(CASE WHEN type = 'Movie' THEN 1 END) as movies,
    COUNT(CASE WHEN type = 'TV Show' THEN 1 END) as tv_shows
FROM disney_content
WHERE release_year >= 2010  -- Last decade
GROUP BY release_year
ORDER BY release_year DESC;

-- Query 10: Content addition by year (when added to Disney+)
SELECT 
    YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) as year_added,
    COUNT(*) as titles_added
FROM disney_content
WHERE date_added IS NOT NULL AND date_added != ''
GROUP BY year_added
ORDER BY year_added;

-- Query 11: Family vs Adult content analysis
SELECT 
    CASE 
        WHEN rating IN ('G', 'TV-G', 'TV-Y', 'TV-Y7', 'TV-Y7-FV') THEN 'Family/Kids'
        WHEN rating IN ('PG', 'TV-PG') THEN 'General Audience'
        WHEN rating IN ('PG-13', 'TV-14') THEN 'Teen/Adult'
        ELSE 'Other/Unrated'
    END as audience_category,
    COUNT(*) as content_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM disney_content), 1) as percentage
FROM disney_content
GROUP BY audience_category
ORDER BY content_count DESC;

-- Query 12: Movie duration analysis (extract minutes from duration)
SELECT 
    'Movies' as content_type,
    COUNT(*) as total_count,
    AVG(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) as avg_duration_minutes,
    MIN(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) as min_duration,
    MAX(CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED)) as max_duration
FROM disney_content
WHERE type = 'Movie' 
  AND duration LIKE '%min%'
  AND CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) > 0;
  
  -- Query 13: Content age when added to Disney+ (how old was content when added)
SELECT 
    CASE 
        WHEN (YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) - release_year) <= 2 THEN 'Very Recent (0-2 years)'
        WHEN (YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) - release_year) <= 5 THEN 'Recent (3-5 years)'
        WHEN (YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) - release_year) <= 10 THEN 'Moderate (6-10 years)'
        WHEN (YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) - release_year) <= 20 THEN 'Older (11-20 years)'
        ELSE 'Classic (20+ years)'
    END as content_age_category,
    COUNT(*) as count,
    ROUND(AVG(YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) - release_year), 1) as avg_age_years
FROM disney_content
WHERE date_added IS NOT NULL 
  AND date_added != ''
  AND release_year IS NOT NULL
  AND YEAR(STR_TO_DATE(date_added, '%M %d, %Y')) >= release_year
GROUP BY content_age_category
ORDER BY avg_age_years;

-- Query 14: Genre diversity by content type
SELECT 
    type,
    COUNT(DISTINCT TRIM(SUBSTRING_INDEX(listed_in, ',', 1))) as unique_primary_genres,
    COUNT(*) as total_content
FROM disney_content
WHERE listed_in IS NOT NULL AND listed_in != ''
GROUP BY type;

-- Query 15: International vs Domestic content
SELECT 
    CASE 
        WHEN country LIKE '%United States%' OR country LIKE '%USA%' THEN 'US Content'
        WHEN country IS NULL OR country = '' THEN 'Unknown Origin'
        ELSE 'International Content'
    END as origin_category,
    COUNT(*) as content_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM disney_content), 1) as percentage
FROM disney_content
GROUP BY origin_category
ORDER BY content_count DESC;

-- Drop views if they already exist
DROP VIEW IF EXISTS content_summary;
DROP VIEW IF EXISTS movies_analysis;
DROP VIEW IF EXISTS tv_shows_analysis;

-- View 1: Content summary with basic info
CREATE VIEW content_summary AS
SELECT 
    show_id,
    title,
    type,
    release_year,
    rating,
    duration,  -- Include duration field
    TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) as primary_genre,
    CASE 
        WHEN country LIKE '%United States%' THEN 'United States'
        WHEN country IS NULL OR country = '' THEN 'Unknown'
        ELSE TRIM(SUBSTRING_INDEX(country, ',', 1))
    END as primary_country,
    director,
    description
FROM disney_content;

-- View 2: Movies only with duration in minutes
CREATE VIEW movies_analysis AS
SELECT 
    show_id,
    title,
    type,
    release_year,
    rating,
    duration,
    primary_genre,
    primary_country,
    director,
    description,
    CAST(SUBSTRING_INDEX(duration, ' ', 1) AS UNSIGNED) as duration_minutes
FROM content_summary
WHERE type = 'Movie';

-- View 3: TV Shows only
CREATE VIEW tv_shows_analysis AS
SELECT 
    show_id,
    title,
    type,
    release_year,
    rating,
    duration,
    primary_genre,
    primary_country,
    director,
    description
FROM content_summary
WHERE type = 'TV Show';

-- Business Question 1: What's Disney+'s content strategy focus?
SELECT 
    'Content Strategy Analysis' as analysis,
    '' as metric,
    '' as value
UNION ALL
SELECT 
    'Total Content' as analysis,
    'All Titles' as metric,
    CAST(COUNT(*) AS CHAR) as value
FROM disney_content
UNION ALL
SELECT 
    'Content Mix' as analysis,
    type as metric,
    CONCAT(COUNT(*), ' (', ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM disney_content), 1), '%)') as value
FROM disney_content
GROUP BY type
ORDER BY analysis, value DESC;

-- Business Question 2: How family-friendly is Disney+?
SELECT 
    'Family Content Analysis' as analysis_type,
    CASE 
        WHEN rating IN ('G', 'TV-G', 'TV-Y', 'TV-Y7', 'TV-Y7-FV') THEN 'Family Safe'
        WHEN rating IN ('PG', 'TV-PG') THEN 'Parental Guidance'
        ELSE 'Teen/Adult'
    END as content_category,
    COUNT(*) as count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM disney_content), 1) as percentage
FROM disney_content
WHERE rating IS NOT NULL AND rating != ''
GROUP BY content_category
ORDER BY count DESC;

-- Business Question 3: What are the most popular content categories?
SELECT 
    TRIM(SUBSTRING_INDEX(listed_in, ',', 1)) as genre,
    COUNT(*) as total_titles,
    COUNT(CASE WHEN type = 'Movie' THEN 1 END) as movies,
    COUNT(CASE WHEN type = 'TV Show' THEN 1 END) as tv_shows,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM disney_content WHERE listed_in IS NOT NULL), 1) as percentage_of_catalog
FROM disney_content
WHERE listed_in IS NOT NULL AND listed_in != ''
GROUP BY genre
HAVING COUNT(*) >= 10  -- Only significant genres
ORDER BY total_titles DESC
LIMIT 10;

-- Final data validation
SELECT 
    'Data Quality Report' as report_type,
    'Total Records' as metric,
    CAST(COUNT(*) AS CHAR) as value
FROM disney_content
UNION ALL
SELECT 
    'Data Completeness' as report_type,
    'Records with Title' as metric,
    CONCAT(COUNT(CASE WHEN title IS NOT NULL AND title != '' THEN 1 END), ' / ', COUNT(*))
FROM disney_content
UNION ALL
SELECT 
    'Data Completeness' as report_type,
    'Records with Release Year' as metric,
    CONCAT(COUNT(CASE WHEN release_year IS NOT NULL THEN 1 END), ' / ', COUNT(*))
FROM disney_content
UNION ALL
SELECT 
    'Data Completeness' as report_type,
    'Records with Rating' as metric,
    CONCAT(COUNT(CASE WHEN rating IS NOT NULL AND rating != '' THEN 1 END), ' / ', COUNT(*))
FROM disney_content;