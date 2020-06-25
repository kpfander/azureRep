
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CITYBIKE;


/*SELECT
	v1:id::INT AS city_id,
	v1:NAME::VARCHAR(50) AS city_name,
	v1:country::VARCHAR(2) AS country,
	v1:coord.lat::FLOAT AS city_lat,
	v1:coord.lon::FLOAT AS city_lon
FROM
	JSON_CITY_INGEST
WHERE city_id>150000 AND city_id<251332
ORDER BY city_id;
*/
--- MERGE INTO CITY ---

MERGE INTO CITY
	USING (	
	SELECT
		v1:id::INT AS city_id,
		v1:NAME::VARCHAR(50) AS city_name,
		v1:country::VARCHAR(2) AS country 
	FROM JSON_CITY_INGEST 
	WHERE city_id>150000 AND city_id<251332
	) AS src 
	ON	CITY.id = src.city_id	
	WHEN MATCHED THEN
		UPDATE
		SET
			CITY.name = src.city_name,
			CITY.country = src.country		
	/*WHEN NOT MATCHED and src.city_id is null THEN DELETE*/
	WHEN NOT MATCHED THEN
		INSERT (id, name, country)
		VALUES (src.city_id, src.city_name, src.country);

--- MERGE INTO GEOGRAPHY ---
MERGE INTO GEOGRAPHY
	USING (
	SELECT
		v1:id::INT AS city_id,
		v1:coord.lat::FLOAT AS city_lat,
		v1:coord.lon::FLOAT AS city_lon
	FROM JSON_CITY_INGEST 
	WHERE city_id>150000 AND city_id<251332
	) AS src 
	ON	GEOGRAPHY.city_id = src.city_id	
	WHEN MATCHED THEN
		UPDATE
		SET
			GEOGRAPHY.lat = src.city_lat,
			GEOGRAPHY.lon = src.city_lon		
	/*WHEN NOT MATCHED and src.city_id is null THEN DELETE*/
	WHEN NOT MATCHED THEN
		INSERT (city_id, lat, lon)
		VALUES (src.city_id, src.city_lat, src.city_lon);

	
/*SELECT	*
FROM	CITY;	
	
SELECT	*
FROM	GEOGRAPHY;*/
