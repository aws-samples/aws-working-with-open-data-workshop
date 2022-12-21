/*converting data to Parquet and storing it in a private bucket*/
CREATE table opendata_db.tblallyears_qa
WITH (
  format='PARQUET', external_location='s3://[your-bucket-name]/allyearsqa/'
) AS SELECT * FROM opendata_db.tblallyears
WHERE q_flag = '';

/*Query #1: the total number of observations since 1763*/
SELECT count(*) AS Total_Number_of_Observations
FROM opendata_db.tblallyears_qa;

/*Query #2: the number of stations since 1763*/
SELECT count(*) AS Total_Number_of_Stations
FROM opendata_db.tblghcnd_stations_qa;

/*Query #3: calculates the average maximum temperature (Celsius), average minimum temperature (Celsius), and average rainfall (mm) for the Earth since 1763*/
SELECT element,
         round(avg(CAST(data_value AS real)/10),2) AS value
FROM opendata_db.tblallyears_qa
WHERE element IN ('TMIN', 'TMAX', 'PRCP')
GROUP BY  element;