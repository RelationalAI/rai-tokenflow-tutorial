# Installation Instructions


In the following you will find installation instructions for the code of the different [Token Flow](https://tokenflow.live) use cases.



## Account (optional)

You will need an account on Snowflake. If you need to create (and have permissions to do so) a new account, you can run the [create_account.sql](setup/0_create_account.sql) script specifying the specific admin name, password, etc.

> [!NOTE]
> You do not need to create a new account if you already have one.

Here is an example of creating an account called `TOKENFLOW_DEV`:

```sql
CREATE ACCOUNT TOKENFLOW_DEV
    ADMIN_NAME = <EXISTING_USER_HERE>
    ADMIN_PASSWORD = '<PASSWORD_HERE>'
    EMAIL = '<EMAIL_HERE>'
    MUST_CHANGE_PASSWORD = FALSE
    EDITION = ENTERPRISE
    ;
```



## User (optional)

You will also need a user on the account. This user can be an existing user or you can create a new one (you can check out the [create_users.sql](setup/1_create_users.sql) script). Please ensure that you have logged into the account you will be using (e.g. with the `ADMIN_NAME` user specified above).



Here is an example of creating a new user `TOKENFLOW_ADMIN`.

```sql
USE ROLE ACCOUNTADMIN;

CREATE USER TOKENFLOW_ADMIN
    PASSWORD='<PASSWORD_HERE>'
    DEFAULT_ROLE = SYSADMIN
    DEFAULT_SECONDARY_ROLES = ('ALL')
    MUST_CHANGE_PASSWORD = FALSE
    LOGIN_NAME = TOKENFLOW_ADMIN
    DISPLAY_NAME = TOKENFLOW_ADMIN
    FIRST_NAME = TOKENFLOW_ADMIN
    LAST_NAME = TOKENFLOW_ADMIN
    ;

-- grant roles
GRANT ROLE ACCOUNTADMIN, SYSADMIN TO USER TOKENFLOW_ADMIN;

-- set default role to sysadmin
ALTER USER TOKENFLOW_ADMIN SET DEFAULT_ROLE=SYSADMIN;
```

## Getting Access to the Native Apps

For the use cases you will need to have access to two different RelationalAI Native Apps.
For both apps you can contact Nikolaos Vasiloglou `nik.vasiloglou@relational.ai` if you need assistance.

### RelationalAI Native App

You will need your account to have the [RAI Native App for Snowflake](https://docs.relational.ai/manage/install) installed. The link provides detailed instructions on how to install the App. Note that you will need to be a user with either `ORGADMIN` or `ACCOUNTADMIN` privileges and it requires notification from Relational AI as to when your access is enabled for your account. Please ensure to specify that you need access to the experimental version of the RelationalAI Native App which has both the `GNN` features available and the `PyRel` features.

### RelationalAI GraphRAG Native App

You will also need your account to have the RAI GraphRAG App for Snowflake installed. For this please contact your administrator or, send an email to the account above.


## Building the `relationalai.zip` Python Package

For certain use cases you will be working through a Snowflake Notebook. To this end, you will need a Python package that allows for interfacing between the Snowflake Notebooks. We will show you how and where to upload this package at a later step together with the code and the data.

For now, you can build this package following the steps below in a shell. You will need `Python >= 3.9` and `pip` installed for the following to work.

> [!NOTE]
> You may ask a Relational AI representative to give you this file if you don't have access to the source code.

```sh
# clone the code
git clone https://github.com/RelationalAI/relationalai-python

cd relationalai-python

# create a virtual environment
python -m venv .venv
source .venv/bin/activate  # On Windows use `.venv\Scripts\activate`

pip install --upgrade pip
pip install -r requirements.lock

rai-dev build        # Build the package (creates wheel and sdist)
rai-dev build:zip    # Build the Snowflake notebook zip file

deactivate
```

Once the building completes you will now have a file called `relationalai.zip` in the current folder. Keep this file as we will upload it later on to a Snowflake stage.



## Set up Database Objects

In the following steps you will be creating Snowflake Database Objects such as a warehouse, schema, stage, etc.

### Specify Object Names

You can decide on the names that you'd like to use and set them up in variables in the beginning, so that the rest of the code below can create the objects.

> [!NOTE]
> You will need to run the following in a Snowflake SQL worksheet. You can find all the code in one place in the [create_assets.sql](setup/2_create_assets.sql) file.

Here is an example of the configuration of names for database, warehouse, stage, etc

```sql
USE ROLE ACCOUNTADMIN;

-- set up of constants, change the names in this section of what assets you'd like to create,
-- no need to touch the rest of the code

SET db_name = 'tf_db';
SET schema_name = 'tf_schema';
SET schema_full_name = $db_name||'.'||$schema_name; -- fully-qualified
SET stage_name = 'tf_stage'; -- fully-qualified
SET stage_full_name = $schema_full_name||'.'||$stage_name;
SET wh_name = 'tf_wh';
SET wh_size = 'X-SMALL';
SET role_name = 'SYSADMIN';   -- what role will have access to the db/warehouse/schema etc.
SET net_rule_name='tf_network_rule';
SET ext_integration_name='tf_external_integration';
```



### Cleanup and Create Role
The following cleans up by removing the database and warehouse for a fresh installation.

```sql
--
-- NOTE: in the following everything is DROPPED and re-created
--

-- cleanup
DROP DATABASE IF EXISTS identifier($db_name);
DROP WAREHOUSE IF EXISTS identifier($wh_name);

-- create role if needed
CREATE ROLE IF NOT EXISTS identifier($role_name);
```



### Create a Database

Next, you will create a database:

```sql
-- create a database
CREATE DATABASE IF NOT EXISTS identifier($db_name);
GRANT OWNERSHIP ON DATABASE identifier($db_name) TO ROLE identifier($role_name) COPY CURRENT GRANTS;
USE DATABASE identifier($db_name);
```



### Create a Warehouse

Next, you will create a warehouse:

```sql
-- create warehouse
CREATE OR REPLACE WAREHOUSE identifier($wh_name) WITH WAREHOUSE_SIZE = $wh_size;
GRANT USAGE ON WAREHOUSE identifier($wh_name) TO ROLE identifier($role_name);
```



### Create a Schema

You can create a schema as follows:

```sql
-- create a schema
CREATE SCHEMA IF NOT EXISTS identifier($schema_full_name);
GRANT USAGE ON SCHEMA identifier($schema_full_name) TO ROLE identifier($role_name);
USE SCHEMA identifier($schema_full_name);
```



### Create a Stage

You will need the stage to upload the Python Notebooks as well as the raw csv data that will then imported into Snowflake Tables. You can create a stage as follows:

```sql
-- create a stage
CREATE STAGE IF NOT EXISTS identifier($stage_full_name) DIRECTORY = ( ENABLE = true );
GRANT READ ON STAGE identifier($stage_full_name) TO ROLE identifier($role_name);
```



### Enable User to Create Notebooks

Depending on the role used for accessing the database, you may need to grant the user certain privileges to allow creation of notebooks. You can grant the privilege as follows:

```sql
-- privilege for notebook
GRANT CREATE NOTEBOOK ON SCHEMA identifier($schema_full_name) TO ROLE identifier($role_name);
```



## Upload Code and Data to the Stage

Once you have created the database, schema and stage you will now need to upload the necessary files to the stage that we can insert the data into Snowflake tables for further processing and create the notebooks for the use cases.

For this you need to login into Snowsight, and, on the left, click on `Data > Databases`.
After that, find the database that you have just created, and select the schema, stages and then the stage that you created. In our example you would be clicking on `TF_DB > TF_SCHEMA > Stages > TF_STAGE` as shown in the picture:



<picture>
  <img src="assets/0-stage.jpeg" alt="stage" style="width:350px;">
</picture>

## Load the Data into Snowflake Tables



## Create Notebooks

```sql
CREATE OR REPLACE NOTEBOOK anomaly_communities
    FROM '@tf_db.tf_schema.tf_stage'
    MAIN_FILE = 'anomaly-communities.ipynb'
    QUERY_WAREHOUSE = $wh_name
    WAREHOUSE = $wh_name
    ;
```

>>>> EXTERNAL ACCESS! S3_RAI_INTERNAL_BUCKET_EGRESS_INTEGRATION


## Load `relationalai.zip` Python Package




