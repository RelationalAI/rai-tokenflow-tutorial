import argparse
import sys
from typing import Optional,List
from pathlib import Path

import pandas as pd
from snowflake.snowpark import Session
from yaml import safe_load

def create_session(connection_dict):
    """Create Snowflake session from the connection profile in ~/.snowflake/connections.toml file."""
    try:
        return Session.builder.configs(connection_dict).create()
    except Exception as e:
        print(f"Error creating Snowflake session: {e}")
        sys.exit(1)




def load_to_snowflake(session: Session, df: pd.DataFrame, database: str, schema: str, table_name: str):
    """Load DataFrame into Snowflake table."""
    try:
        table_name = table_name.upper()
        # Create database and schema and set context
        session.sql(f"CREATE DATABASE IF NOT EXISTS {database}").collect()
        session.sql(f"USE DATABASE {database}").collect()
        session.sql(f"CREATE SCHEMA IF NOT EXISTS {schema}").collect()
        session.sql(f"USE SCHEMA {schema}").collect()
        # Write data to Snowflake
        session.write_pandas(df, table_name=table_name, auto_create_table=True, overwrite=True, use_logical_type=True)
        print(f"Wrote data to {database}.{schema}.{table_name}")        
    except Exception as e:
        print(f"Error loading data to Snowflake: {e}")
        sys.exit(1)

