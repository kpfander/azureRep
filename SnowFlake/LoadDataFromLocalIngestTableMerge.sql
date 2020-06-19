
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
