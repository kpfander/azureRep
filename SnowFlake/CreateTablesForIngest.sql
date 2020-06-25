
USE WAREHOUSE COMPUTE_WH;
USE DATABASE CITYBIKE;




CREATE OR REPLACE  TABLE JSON_CITY_INGEST(v1 VARIANT);
CREATE OR REPLACE  TABLE JSON_CITYTEMP_INGEST(v1 VARIANT);

CREATE OR REPLACE STREAM my_citystream ON TABLE JSON_CITY_INGEST;
CREATE OR REPLACE STREAM my_citystream ON TABLE JSON_CITYTEMP_INGEST;
--list @AZURE_KP;
--Select v1 from @AZURE_KP/OW.City.ndjson.gz;
COPY INTO JSON_CITY_INGEST
FROM @AZURE_KP/OW.City.ndjson.gz file_format = (TYPE = json);

COPY INTO JSON_CITYTEMP_INGEST
FROM @AZURE_KP/climate.json file_format = JSON;


--SELECT *
--FROM JSON_CITY_INGEST
--LIMIT 10;

CREATE OR REPLACE TABLE CITY (id INT, NAME VARCHAR(50), country VARCHAR(2));
CREATE OR REPLACE TABLE GEOGRAPHY(city_id INT, lon FLOAT, lat FLOAT);


create or replace table city_population  
(	
	Country string,
  	City string,
  	AccentCity string,
  	Region integer,
  	Population float,
  	latitude float,
  	longitude float
);
 
create or replace table city_temp  
(	
	Region string,
	Country string,
	State string,
	City string,
	MONTH integer,
	DAY integer,
	YEAR integer,
	AvgTemperature float	
);

COPY INTO city_population
FROM @AZURE_KP/2015_3689_compressed_worldcitiespop.csv.zip file_format =  CSV2;

COPY INTO city_temp
FROM @AZURE_KP/694560_1215964_compressed_city_temperature.csv.zip file_format =  CSV2;

Select *, 
FROM "CITYBIKE"."PUBLIC"."JSON_CITY_INGEST" limit 100