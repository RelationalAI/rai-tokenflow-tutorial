# Installation Instructions

## Basics

In the following you will find installation instructions for the code of the different [Token Flow](https://tokenflow.live) use cases.

Here are some basic requirements before installing:

* You will need an account on Snowflake. If you need to create (and have permissions to do so) a new account, you can run the [create_account.sql](setup/0_create_account.sql) script, but you can also use an existing account.

> [!NOTE]
> You do not need to create a new account if you have one.

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

* You will also need a user on the account. This user can be an existing user or you can create a new one (you can check out the [create_users.sql](setup/1_create_users.sql) script). Please ensure that you have logged into the account you will be using (e.g. with the `ADMIN_NAME` user specified above).

> [!NOTE]
> You do not need to create a new user if you have one.

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



