
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CITIBIKE;


DROP TABLE JSON_CITY_INGEST;
DROP TABLE CITY;
DROP TABLE GEOGRAPHY;


CREATE TABLE JSON_CITY_INGEST(v1 VARIANT);
--list @AZURE_KP;
--Select v1 from @AZURE_KP/OW.City.ndjson.gz;
COPY INTO JSON_CITY_INGEST
FROM @AZURE_KP/OW.City.ndjson.gz file_format = (TYPE = json);

--SELECT *
--FROM JSON_CITY_INGEST
--LIMIT 10;

CREATE TABLE CITY (id INT, NAME VARCHAR(50), country VARCHAR(2));
CREATE TABLE GEOGRAPHY(city_id INT, lon FLOAT, lat FLOAT);