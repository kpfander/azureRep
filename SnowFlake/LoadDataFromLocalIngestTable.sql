
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CITIBIKE;


DROP TABLE JSON_CITY_INGEST;

CREATE TABLE JSON_CITY_INGEST(v1 VARIANT);
--list @AZURE_KP;
--Select v1 from @AZURE_KP/OW.City.ndjson.gz;
COPY
INTO
	JSON_CITY_INGEST
FROM
	@AZURE_KP/OW.City.ndjson.gz file_format = (TYPE = json);

SELECT	*
FROM
	JSON_CITY_INGEST
LIMIT 10 ;

DROP TABLE CITY;

DROP TABLE GEOGRAPHY;

CREATE TABLE CITY (id INT,
NAME VARCHAR(50),
country VARCHAR(2));

CREATE TABLE GEOGRAPHY(city_id INT,
lon FLOAT,
lat FLOAT);

SELECT
	v1:id::INT AS city_id,
	v1:NAME::VARCHAR(50) AS city_name,
	v1:country::VARCHAR(2) AS country,
	v1:coord.lat::FLOAT AS city_lat,
	v1:coord.lon::FLOAT AS city_lon
FROM
	JSON_CITY_INGEST;

INSERT INTO
	CITY
SELECT
	v1:id::INT AS city_id,
	v1:NAME::VARCHAR(50) AS city_name,
	v1:country::VARCHAR(2) AS country
FROM JSON_CITY_INGEST
LIMIT 3;

SELECT	*
FROM	CITY;

INSERT INTO GEOGRAPHY
SELECT
	v1:id::INT AS city_id,
	v1:coord.lat::FLOAT AS city_lat,
	v1:coord.lon::FLOAT AS city_lon
FROM JSON_CITY_INGEST
WHERE
	city_id IN (
	SELECT id
	FROM CITY);

MERGE INTO GEOGRAPHY
	USING (
	SELECT
		v1:id::INT AS city_id,
		v1:coord.lat::FLOAT AS city_lat,
		v1:coord.lon::FLOAT AS city_lon
	FROM JSON_CITY_INGEST	LIMIT 10) AS src 
	ON	GEOGRAPHY.city_id = src.city_id
	WHEN MATCHED THEN
		UPDATE
		SET
			GEOGRAPHY.lat = src.city_lat,
			GEOGRAPHY.lon = src.city_lon			
	WHEN NOT MATCHED THEN
		INSERT (city_id, lat, lon)
		VALUES (src.city_id, src.city_lat, src.city_lon);

SELECT	*
FROM	GEOGRAPHY;

DROP TABLE JSON_CITY_INGEST;