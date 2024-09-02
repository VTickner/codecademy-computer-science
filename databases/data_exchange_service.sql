-- 1. Write a query to determine the name of the superuser
SELECT rolname
FROM pg_roles
WHERE rolsuper = TRUE;

-- 2, Write a query to see all users and their role permissions
SELECT *
FROM pg_roles;

-- 3. Check name of role currently using
SELECT current_role;

-- 4. Create a login role named abc_open_data without superuser permissions
CREATE ROLE abc_open_data
WITH LOGIN NOSUPERUSER;

-- 5. Create a non-superuser group role named publishers and include abc_open_data as a member
CREATE ROLE publishers
WITH NOSUPERUSER ROLE abc_open_data;

-- 6. Grant usage on schema analytics to publishers
GRANT USAGE ON SCHEMA analytics
TO publishers;

-- 7. Grant publishers the ability to select on all existing tables in analytics
GRANT SELECT ON ALL TABLES
IN SCHEMA analytics
TO publishers;

-- 8. Query table_privileges to check whether abc_open_data has select on analytics.downloads
SELECT * FROM information_schema.table_privileges
WHERE grantee = 'publishers';

-- 9. Set role to abc_open_data and create query to confirm abc_open_data has ability to select on analytics.downloads through inheritance from publishers
SET ROLE abc_open_data;

SELECT * FROM analytics.downloads
LIMIT 10;

-- Set role back to ccuser
SET ROLE ccuser;

-- 10. Query from directory.datasets to see a few sample rows
SELECT * FROM directory.datasets
LIMIT 5;

-- 11. Grant usage on directory to publishers
GRANT USAGE ON SCHEMA directory
TO publishers;

-- 12. Grant select on all columns in this table except data_checksum to publishers
GRANT SELECT (id, create_date, hosting_path, publisher, src_size)
ON directory.datasets
TO publishers;

-- 13. Set role to abc_open_data and see what happens if a publisher tries to query all the dataset names and paths
SET ROLE abc_open_data;

-- When had data_checksum in select statement permission error
SELECT id, publisher, hosting_path
FROM directory.datasets;

-- Set role back to ccuser
SET ROLE ccuser;

-- 14. Create and enable policy that says that the current_user must be the publisher of the dataset to select on analytics.downloads rows
CREATE POLICY user_rls_policy ON analytics.downloads
FOR SELECT TO publishers
USING (current_user = owner);

ALTER TABLE analytics.downloads
ENABLE ROW LEVEL SECURITY;

-- 15. Query the first few rows of this table. Then set role to abc_open_data and re-run the same query.
SELECT * FROM analytics.downloads
LIMIT 10;

SET ROLE abc_open_data;

SELECT * FROM analytics.downloads
LIMIT 10;