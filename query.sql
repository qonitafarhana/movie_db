--top 10 movie
SELECT 
    film_id, 
    original_title, 
    popularity, 
    release_date 
FROM 
    movie 
ORDER BY 
    popularity DESC 
LIMIT 
    10;
	
--top movie per-year
SELECT DISTINCT ON (EXTRACT(YEAR FROM release_date))
    EXTRACT(YEAR FROM release_date) AS year,
    original_title AS movie_title,
    popularity
FROM
    movie
WHERE
    original_language = 'en'
	AND release_date >= NOW() - INTERVAL '5 years'
ORDER BY
    EXTRACT(YEAR FROM release_date) DESC,
    popularity DESC
LIMIT 5;

--total genre per-year
SELECT year, name, count
FROM (
    SELECT DISTINCT EXTRACT(YEAR FROM mo.release_date) AS year, gr.name, COUNT(mg.movie_id) AS count,
        ROW_NUMBER() OVER (PARTITION BY EXTRACT(YEAR FROM mo.release_date) ORDER BY COUNT(mg.movie_id) DESC) AS rank
    FROM movie_genre AS mg
    JOIN movie AS mo ON mg.movie_id = mo.film_id
    JOIN genre AS gr ON mg.genre_id = gr.id
    WHERE release_date >= NOW() - INTERVAL '5 year'
    GROUP BY year, gr.name
) AS subquery
WHERE rank = 1
ORDER BY year DESC;


--top language
SELECT original_language, COUNT(original_language) AS total
FROM movie
GROUP BY original_language
ORDER BY total DESC;


--avg runtime per-movie
SELECT AVG(runtime) AS "rata-rata durasi film"
FROM movie;

--total words of tagline
SELECT original_title, tagline, (LENGTH(tagline) - LENGTH(REPLACE(tagline, ' ', ''))+1) AS words
FROM movie
WHERE tagline IS NOT NULL
GROUP BY original_title, tagline;

--avg tagline 
SELECT AVG(LENGTH(tagline) - LENGTH(REPLACE(tagline, ' ', ''))+1) AS avg_words
FROM movie
WHERE tagline IS NOT NULL;





