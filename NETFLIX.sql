DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
 show_id VARCHAR(6),
 type VARCHAR(10),
 title VARCHAR(150),
 director VARCHAR(208),
 casts VARCHAR(1000), 
 country VARCHAR(150),
 date_added VARCHAR(50),
 release_year INT,
 rating VARCHAR(10),
 duration VARCHAR(15),
 listed_in VARCHAR(100),
 description VARCHAR(250)
);
SELECT * FROM netflix;

SELECT 
COUNT(*) as total_content
FROM netflix;

----COUNT OF MOVIES VS TV SHOWS

SELECT 
DISTINCT type
FROM netflix;

SELECT 
type,
COUNT(*) as total_content
FROM netflix
GROUP BY TYPE

----COMMON RATINGS FOR MOVIES AND TV SHOWS

SELECT
type,
rating
FROM
(
SELECT 
type,
rating,
COUNT(*),
RANK() OVER(PARTITION BY type ORDER BY COUNT(*)DESC) as ranking
FROM netflix
GROUP BY 1,2
) as t1
WHERE
ranking = 1

----LIST OF MOVIES RELEASED IN THE YEAR OF 2020


SELECT * FROM netflix
WHERE 
type = 'Movie'
AND
release_year = 2020


----TOP 5 COUNTRIES WITH MOST CONTENT

SELECT 

UNNEST(STRING_to_ARRAY(country,','))as new_country,
COUNT(show_id) as total_content
FROM netflix
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5


----LONGEST DURATION MOVIE OR TV SHOW


SELECT * FROM netflix
WHERE
type = 'Movie'
AND
duration = (SELECT MAX(duration) FROM netflix)

----CONTENT ADDED IN THE LAST 5 YEARS

SELECT 
*
FROM netflix
WHERE

TO_DATE(date_added,'Month DD,YYYY') >= CURRENT_DATE - INTERVAL '5 years'

SELECT CURRENT_DATE - INTERVAL '5 years'

----ALL MOVIES/TV SHOWS DIRECTED BY RAJIV CHILAKA

SELECT * FROM netflix
WHERE director LIKE '%Rajiv Chilaka%'

----NUMBER OF CONTENT ITEMS IN EACH GENRE 


SELECT 
UNNEST(STRING_TO_ARRAY(listed_in,',')) as genre,
COUNT(show_id)as total_content
FROM netflix
GROUP BY 1


----AVERAGE RELEASE YEAR FOR CONTENT PRODUCED IN A SPECIFIC COUNTRY


SELECT 
EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) as year,
COUNT(*) as yearly_content,
ROUND(
COUNT(*)::numeric/(SELECT COUNT(*)FROM netflix WHERE country = 'India')::numeric * 100
,2)as avg_content_per_year
FROM netflix
WHERE country = 'India'
GROUP BY 1

----LIST OF ALL DOCUMENTARY MOVIES

SELECT * FROM netflix
WHERE
listed_in ILIKE '%documentaries%'


----CONTENT WITHOUT A DIRECTOR


SELECT * FROM netflix
WHERE
director IS NULL


----LIST OF MOVIES 'SHAH RUKH KHAN' APPEARED IN LAST 10 YEARS


SELECT * FROM netflix
WHERE
casts ILIKE '%Shah Rukh Khan%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10

----TOP 10 INDIAN ACTORS WITH HIGHEST NUMBER OF MOVIES 

SELECT 
UNNEST(STRING_TO_ARRAY(casts,',')) as actors,
COUNT(*) as total_content
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 

----CATEGORISING MOVIES BASED ON KILL OR VIOLENCE


WITH new_table
AS
(
SELECT
*,
CASE
WHEN description ILIKE '%kill%' OR
description ILIKE '%kill%' THEN 'Adult_Content'
ELSE 'Good Content'
END category
FROM netflix
)
SELECT
category,
COUNT(*) as total_content
FROM new_table
GROUP BY 1

----END

