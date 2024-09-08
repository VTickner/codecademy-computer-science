-- 1. Find the total size of the table (excluding indexes)
SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size;
-- table_size = 1192kB

-- 2. Find the size of the indexes on the table. What's the name of the largest index?
SELECT 
  pg_size_pretty(pg_total_relation_size('sensors.observations_pkey')) AS pkey_idx_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations_location_id_datetime_idx')) AS location_id_datetime_idx_size;
-- pkey_idx_size = 712kB
-- location_id_datetime_idx_size = 448kB

-- 3. Write a query that returns the size of the table's data, indexes and the total relation size as three separate colums
SELECT
  pg_size_pretty(pg_table_size('sensors.observations')) AS table_size,
  pg_size_pretty(pg_indexes_size('sensors.observations')) AS idx_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations')) AS total_size;
-- table_size = 1192kB, idx_size = 1160kB, total_size = 2352kB

-- 4. Write a query that updates the value of distance to feet (from meters), m * 3.281 = feet
UPDATE sensors.observations
SET distance = (distance * 3.281)
WHERE TRUE;

-- 5. Check the size of the tables and indexes, are they significantly ;arger after the update?
SELECT
  pg_size_pretty(pg_table_size('sensors.observations')) AS table_size,
  pg_size_pretty(pg_indexes_size('sensors.observations')) AS idx_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations')) AS total_size;
-- table_size = 2344kB, idx_size = 2232kB, total_size = 4576kB, yes approx 50% larger

-- 6. Run a vacuum on the table and check the table's size after
VACUUM sensors.observations;

SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size;
-- table_size = 2353kB

-- 7. Add additional data to the table
\COPY sensors.observations (id, datetime, location_id, duration, distance, category) FROM './additional_obs_types.csv' WITH DELIMITER ',' CSV HEADER;

-- 8. Check the table size.
SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size;
-- table_size = 2352kB

-- 9. Run a vacuum full on the table. Check the table size.
VACUUM FULL sensors.observations;

SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size;
-- table_size = 1272kB

-- 10. Write a query that deletes all cameras at location_id > 24
DELETE FROM sensors.observations
WHERE location_id > 24;

-- 11. Check the size of the table's data
SELECT pg_size_pretty(pg_table_size('sensors.observations')) AS table_size;
-- table_size = 1272kB

-- 12. Using truncate, clear all the values from sensors.observations
TRUNCATE sensors.observations;

-- 13. Load the following data
\COPY sensors.observations (id, datetime, location_id, duration, distance, category) FROM './original_obs_types.csv' WITH DELIMITER ',' CSV HEADER;

\COPY sensors.observations (id, datetime, location_id, duration, distance, category) FROM './additional_obs_types.csv' WITH DELIMITER ',' CSV HEADER;

-- 14. Check the total table, index and combined size of the table now. How does the size of the table compare to when vacuum full was used?
SELECT
  pg_size_pretty(pg_table_size('sensors.observations')) AS table_size,
  pg_size_pretty(pg_indexes_size('sensors.observations')) AS idx_size,
  pg_size_pretty(pg_total_relation_size('sensors.observations')) AS total_size;
-- table_size = 1296kB, idx_size = 1296kB, total_size = 2592kB, compared to table_size = 1272kB very similar