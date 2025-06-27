

# 🔗 GNN Engine for Link Prediction: Tokenflow Demo

This repository demonstrates how to use the **RelationalAI GNN Engine** for a link prediction task using the **Tokenflow** dataset.

---

## ✅ Prerequisites

1. **Install the RelationalAI Experimental Application**
   Make sure the RelationalAI experimental application is installed in your Snowflake account.

2. **Preprocess the Tokenflow Dataset**
   Run the `preprocess_tokenflow_data.ipynb` notebook to generate the processed dataset required for this tutorial.

3. **Upload the Preprocessed Data to Snowflake**
   Use the preprocessing notebook to upload the Tokenflow data to the appropriate tables in your Snowflake environment.

4. **Install the RelationalAI GNN Python SDK**
   Follow the setup instructions in [GNN\_SDK\_DOCUMENTATION.md](GNN_SDK_DOCUMENTATION.md) to install the SDK in your environment.

---

## 📁 Repository Contents
* `create_data.sql` - SQL script to prepare tokenflow data in Snowflake
* `preprocess_tokenflow_data.ipynb` — Notebook to preprocess and upload the Tokenflow dataset to Snowflake
* `LinkPrediction_Tokenflow.ipynb` — Notebook demonstrating link prediction using the GNN engine. Notebook shows how you can communicate with the GNN engine localy 
* `LinkPrediction_Tokenflow_SF.ipynb` — Notebook demonstrating link prediction using the GNN engine. This is a Snowflake notebook.
* `load_to_snowflake.py` — Helper functions for uploading data to Snowflake (used in the preprocessing notebook)
* `rai_gnns_experimental-0.1.0-py3-none-any.whl` — Wheel file for the RelationalAI GNN SDK
* `rai_gnns_experimental.zip` — Zip file to upload the python SDK to be installed in Snowflake notebooks. See instructions [here](INSTALLING_SDK_TO_SNOWFLAKE.md)
* `GNN_SDK_DOCUMENTATION.md` — Documentation for installing and using the GNN SDK
* `.env` — Example configuration file for connecting to Snowflake

