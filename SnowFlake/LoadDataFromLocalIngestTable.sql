
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CITYBIKE;

SELECT
	v1:id::INT AS city_id,
	v1:NAME::VARCHAR(50) AS city_name,
	v1:country::VARCHAR(2) AS country,
	v1:coord.lat::FLOAT AS city_lat,
	v1:coord.lon::FLOAT AS city_lon
FROM
	JSON_CITY_INGEST;

SELECT count(v1:id::INT)
FROM JSON_CITY_INGEST
WHERE  v1:id::INT < 2987268 

SELECT city_id, NUM 
FROM 
(
SELECT v1:id::INT AS city_id, ROW_NUMBER() OVER(ORDER BY v1:id::INT  ASC) AS num
FROM JSON_CITY_INGEST
WHERE  v1:id::INT < 2987268) 
WHERE num <50000;

--- INSERT NEW RECORDS
INSERT INTO CITY
SELECT
	v1:id::INT AS city_id,
	v1:NAME::VARCHAR(50) AS city_name,
	v1:country::VARCHAR(2) AS country
FROM JSON_CITY_INGEST
WHERE  /*city_id < 550000 AND*/ NOT city_id IN (SELECT ID FROM City) ;

INSERT INTO GEOGRAPHY
SELECT
	v1:id::INT AS city_id,
	v1:coord.lat::FLOAT AS city_lat,
	v1:coord.lon::FLOAT AS city_lon
FROM JSON_CITY_INGEST
WHERE
	city_id IN ( SELECT id	FROM CITY) AND 
	city_id NOT IN (SELECT city_id  FROM GEOGRAPHY );



--- DELETE OLD RECORDS
/*DELETE FROM  CITY
SELECT i.*
FROM 
(SELECT
	v1:id::INT AS city_id,
	v1:NAME::VARCHAR(50) AS city_name,
	v1:country::VARCHAR(2) AS country
FROM JSON_CITY_INGEST 
WHERE  city_id < 100000)i INNER JOIN CITY c ON c.id = city_id
WHERE c.id IS NULL ;
*/



/*
 *SELECT	*
FROM	CITY;
SELECT	*
FROM	GEOGRAPHY;*/
