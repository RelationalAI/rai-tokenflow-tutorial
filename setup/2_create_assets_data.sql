--
-- NOTE: run this script after you log into the account e.g. using the _ADMIN user
-- NOTE: everything is DROPPED and re-created
--
USE ROLE ACCOUNTADMIN;

-- set up of constants, change the names in this section of what assets you'd like to create,
-- no need to touch the rest of the code

SET db_name='tf_db';
SET schema_name= $db_name||'.tf_schema'; -- fully-qualified
SET wh_name='tf_wh';
SET wh_size='X-SMALL';
SET role_name='SYSADMIN';   -- what role will have access to the db/warehouse/schema etc.


--
-- assets
--
-- cleanup
DROP DATABASE IF EXISTS identifier($db_name);
DROP WAREHOUSE IF EXISTS identifier($wh_name);

-- create role
CREATE ROLE IF NOT EXISTS identifier($role_name);

-- create a database
CREATE DATABASE IF NOT EXISTS identifier($db_name);
GRANT OWNERSHIP ON DATABASE identifier($db_name) TO ROLE identifier($role_name) COPY CURRENT GRANTS;

-- create warehouse
CREATE OR REPLACE WAREHOUSE identifier($wh_name) WITH WAREHOUSE_SIZE=$wh_size;
GRANT USAGE ON WAREHOUSE identifier($wh_name) TO ROLE identifier($role_name);

-- create a schema
CREATE SCHEMA IF NOT EXISTS identifier($schema_name);
GRANT USAGE ON SCHEMA identifier($schema_name) TO ROLE identifier($role_name);

-- privilege for notebook
GRANT CREATE NOTEBOOK ON SCHEMA identifier($schema_name) TO ROLE identifier($role_name);


--
-- data
--
