
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CITIBIKE;

SELECT
	v1:id::INT AS city_id,
	v1:NAME::VARCHAR(50) AS city_name,
	v1:country::VARCHAR(2) AS country,
	v1:coord.lat::FLOAT AS city_lat,
	v1:coord.lon::FLOAT AS city_lon
FROM
	JSON_CITY_INGEST;


--- INSERT NEW RECORDS
INSERT INTO CITY
SELECT
	v1:id::INT AS city_id,
	v1:NAME::VARCHAR(50) AS city_name,
	v1:country::VARCHAR(2) AS country
FROM JSON_CITY_INGEST
WHERE city_id NOT IN (SELECT CITY_ID FROM City) LIMIT 500;


INSERT INTO GEOGRAPHY
SELECT
	v1:id::INT AS city_id,
	v1:coord.lat::FLOAT AS city_lat,
	v1:coord.lon::FLOAT AS city_lon
FROM JSON_CITY_INGEST
WHERE
	city_id IN ( SELECT id	FROM CITY) AND 
	city_id NOT IN (SELECT id  FROM GEOGRAPHY );

--- DELETE OLD RECORDS
DELETE FROM  CITY
SELECT
	v1:id::INT AS city_id,
	v1:NAME::VARCHAR(50) AS city_name,
	v1:country::VARCHAR(2) AS country
FROM JSON_CITY_INGEST 
WHERE  CITY.city_id NOT IN city_id
LIMIT 500;

INSERT INTO GEOGRAPHY
SELECT
	v1:id::INT AS city_id,
	v1:coord.lat::FLOAT AS city_lat,
	v1:coord.lon::FLOAT AS city_lon
FROM JSON_CITY_INGEST
WHERE
	city_id IN ( SELECT id	FROM CITY) AND 
	city_id NOT IN (SELECT id  FROM GEOGRAPHY );



--SELECT	*
--FROM	CITY;
--SELECT	*
--FROM	GEOGRAPHY;
