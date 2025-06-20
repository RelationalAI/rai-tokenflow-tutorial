--
-- notebooks
--
USE ROLE ACCOUNTADMIN;

-- anomaly-communities.ipynb
CREATE OR REPLACE NOTEBOOK anomaly_communities
    FROM '@tf_db.tf_schema.tf_stage'
    MAIN_FILE = 'anomaly-communities.ipynb'
    QUERY_WAREHOUSE = $wh_name
    WAREHOUSE = $wh_name
    ;

-- structured-kg.ipynb
CREATE OR REPLACE NOTEBOOK structured_kg
    FROM '@tf_db.tf_schema.tf_stage'
    MAIN_FILE = 'structured-kg.ipynb'
    QUERY_WAREHOUSE = $wh_name
    WAREHOUSE = $wh_name
    ;
