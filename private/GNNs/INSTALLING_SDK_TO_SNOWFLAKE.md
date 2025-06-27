# Running the SDK in a Snowflake Notebook

This guide explains how to run the GNN SDK inside a Snowflake notebook. Follow the steps below to reproduce the setup.
Notebook example: https://app.snowflake.com/us-east-1/zgc45332/#/notebooks/GNN_TOKENFLOW.PUBLIC.GNN_LINK_PREDICTION
---

## ✅ Step 1: Package the SDK

First, zip the main SDK folder:

```bash
zip -r rai_gnns_experimental rai_gnns_experimental
````

---

## ✅ Step 2: Create a Snowflake Stage for Upload

In Snowflake, create a stage where you'll upload the zip file:

```sql
USE DATABASE GNN_TOKENFLOW;
USE SCHEMA PUBLIC;

CREATE STAGE IF NOT EXISTS ILIAS_TEST_UPLOAD_PACKAGE;

ALTER SESSION SET query_tag = '{
    "origin": "sf_sit-is",
    "name": "notebook_demo_pack",
    "version": { "major": 1, "minor": 0 },
    "attributes": {
        "is_quickstart": 0,
        "source": "sql",
        "vignette": "import_package_stage"
    }
}';
```

---

## ✅ Step 3: Upload the SDK Zip File to the Stage

### Step 3.1: Configure Snowflake Connection (CLI)

Create a Snowflake connection with warehouse, database, schema, and (optionally) a role (e.g., `ACCOUNTADMIN`):

```bash
snow connection add
```

Follow the CLI prompts to configure your connection.

---

### Step 3.2: Upload the `.zip` File

Use the Snowflake CLI to upload the SDK zip file to the stage:

```bash
snow snowpark package upload \
    --file rai_gnns_experimental.zip \
    --stage ILIAS_TEST_UPLOAD_PACKAGE \
    --overwrite \
    -c tokenflow
```

> **Note:**
> Here we assume your connection name is `tokenflow`.

---

## ✅ Step 4: Create and Configure the Snowflake Notebook

Log in to Snowflake and from the left sidebar, create a new **Notebook**.

**Notebook settings:**

* **Database:** Same as where you uploaded the SDK (`GNN_TOKENFLOW`)
* **Schema:** Same as the stage location (`PUBLIC`)
* **Runtime Version:** Snowflake Warehouse Runtime 2.0 (this is required for Python 3.10)

---

## ✅ Step 5: Install Required Packages

Inside the notebook:

1. Click on the **Packages** dropdown (top-right).
2. Use both tabs:

   * **Anaconda Packages**
   * **Stage Packages**

---

### Step 5.1: Install Anaconda Packages

From the **Anaconda Packages** tab, install the following:

* `certifi`
* `cryptography`
* `pydantic`
* `python-dotenv`
* `pydot`
* `sqlalchemy`
* `tabulate`
* `python-graphviz`

> Select version = **Latest** for each package.

---

### Step 5.2: Install the SDK from the Stage

Switch to the **Stage Packages** tab.

For the package path, use:

```
@GNN_TOKENFLOW.PUBLIC.ILIAS_TEST_UPLOAD_PACKAGE/rai_gnns_experimental.zip
```

Click **Import**.

> **Note:**
> If everything works, the status will stay at *"Pending"* for 10–20 minutes, and then show as *"Installed"*.

---

⚠️ Warning: To reinstall the package make sure you end the session first.


