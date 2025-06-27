--
-- notebooks
--
USE ROLE ACCOUNTADMIN;
USE DATABASE TF_DB;
USE SCHEMA TF_SCHEMA;


-- anomaly-communities.ipynb
CREATE OR REPLACE NOTEBOOK anomaly_communities
    FROM '@tf_db.tf_schema.tf_stage'
    MAIN_FILE = 'anomaly-communities.ipynb'
    QUERY_WAREHOUSE = TF_WH
    WAREHOUSE = TF_WH
    ;

-- structured-kg.ipynb
CREATE OR REPLACE NOTEBOOK structured_kg
    FROM '@tf_db.tf_schema.tf_stage'
    MAIN_FILE = 'structured-kg.ipynb'
    QUERY_WAREHOUSE = TF_WH
    WAREHOUSE = TF_WH
    ;

-- structured-kg.ipynb
CREATE OR REPLACE NOTEBOOK gnn_link_prediction
    FROM '@tf_db.tf_schema.tf_stage'
    MAIN_FILE = 'gnn-link-prediction.ipynb'
    QUERY_WAREHOUSE = TF_WH
    WAREHOUSE = TF_WH
    ;

-- unstructured-graphrag-kg.ipynb
CREATE OR REPLACE NOTEBOOK graphrag_kg_qa
    FROM '@tf_db.tf_schema.tf_stage'
    MAIN_FILE = 'unstructured-graphrag-kg.ipynb'
    QUERY_WAREHOUSE = TF_WH
    WAREHOUSE = TF_WH
    ;
