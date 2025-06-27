# GenAI for the AI Engineer: Tokenflow Use Case

## Introduction

[Token Flow](https://tokenflow.live) is a company specializing in advanced blockchain data analytics, particularly for decentralized finance. Their platform provides semantically enriched and contextualized data to help users understand complex on-chain activities across various protocols and chains.

In this tutorial we will use a sample dataset provided by [Token Flow](https://tokenflow.live) to showcase [Relational AI's](https://relational.ai) GenAI services available through [Snowflake](http://www.snowflake.com).

We will work with four different use cases, all geared towards typical AI Engineer or Data Scientist workloads. More specifically, we will study the following use cases:

* **Building a Knowledge Graph over Structured Data.** A knowledge graph over structured data is important because it enables richer, more flexible, and context-aware understanding, integration, and reasoning over data than traditional databases or flat tables can provide. Structured data (e.g., rows in a database) often lacks explicit meaning beyond column names. A knowledge graph adds semantic relationships—e.g., that "Paris" is not just a string in a "City" column, but a specific instance of a geographic location in France. This helps machines and humans understand the meaning of the data more deeply.

You can find the details in the [structured-kg.ipynb](/for_stage/structured-kg.ipynb) Python Notebook.

* **Building a Knowledge Graph over Unstructured Data.** Building a knowledge graph over unstructured (textual) data is important because it transforms raw, messy text into structured, connected knowledge that machines can understand, query, and reason over. Most of the world’s data—emails, documents, articles, reports—is unstructured, and hard to use directly for analysis or automation. A knowledge graph helps unlock the value hidden in text by extracting and linking entities, relationships, and facts. It also enables the users to get answers easily and efficiently by asking natural language questions.

You can find the details in the [unstructured-graphrag-kg.ipynb](/for_stage/unstructured-graphrag-kg.ipynb) Python Notebook.


* **Predicting Transfer Transactions.** Predicting tasks is important for a data scientist because it lies at the heart of what data science is designed to do: extract actionable insights and drive decisions through forecasting, classification, or estimation. Predictive tasks turn raw data into forward-looking value—helping businesses, researchers, and policymakers anticipate what’s likely to happen and act accordingly. Predictive tasks involve using historical data to forecast future outcomes or classify unknown instances. Common examples include predicting customer churn, forecasting sales, classifying whether an email is spam, estimating time to delivery, detecting potential fraud. In our use case we will predict future transfer transactions using blockchain data from [Tokenflow](https://tokenflow.live).

You can find the details in the [gnn-link-prediction.ipynb](/for_stage/gnn-link-prediction.ipynb) Python Notebook.


* **Detecting Anomalies.** Detecting anomalies is important because anomalies often indicate critical, unexpected, or risky events that require attention. These events may signal fraud, failures, security breaches, quality issues, or operational problems—and catching them early can prevent major consequences. Anomaly detection is the process of identifying data points or patterns that deviate significantly from expected behavior. These anomalies can be point anomalies (a single outlier, e.g., a sudden spike in temperature), contextual anomalies (unusual in a given context, e.g. a login at 3 AM), and,
collective anomalies (a group of data behaving abnormally, e.g., anomalous communites of traders that may be colluding). In our use case, we will detect anomalous communities with the blockchain data from [Tokenflow](https://tokenflow.live).

You can find the details in the [anomaly-communities.ipynb](/for_stage/anomaly-communities.ipynb) Python Notebook.



## Tokenflow Dataset

Here is a description of the data files from [Tokenflow](https://tokenflow.live) containing blockhain data. You can find all the data under the `data/` directory.

### agents.csv
Stores metadata on AI-driven blockchain-based agents with agent data, use this to lookup information about agents. It contains the following columns:

| Field Name       | Type              | Description                                                                   |
| ---------------- | ----------------- | ----------------------------------------------------------------------------- |
| LAUNCHPAD        | string            | The platform where the agent was deployed                                     |
| AGENT_ID         | string            | Unique identifier of the agent                                                |
| NAME             | string            | Name of the agent                                                             |
| SYMBOL           | string            | Token symbol associated with the agent                                        |
| DESCRIPTION      | string            | Detailed description of the agent's purpose and features                      |
| CREATED_AT       | timestamp         | Date and time when the agent was created                                      |
| CREATION_TX_HASH | string (66 chars) | Transaction hash of the agent's creation event                                |
| FACTORY_ADDRESS  | string (42 chars) | Contract address of the factory that created the agent                        |
| CATEGORY         | string            | The general category of the agent (e.g., AI analysis, trading, entertainment) |
| ROLE             | string            | Agent's function within the ecosystem                                         |
| DAO              | string (42 chars) | Address of the DAO governing the agent, if applicable                         |
| LP               | string (42 chars) | Liquidity pool contract related to the agent's token                          |
| TBA              | string (42 chars) | Token-bound account, if relevant                                              |
| TOKEN            | string (42 chars) | Contract address of the agent's main token                                    |
| VE_TOKEN         | string (42 chars) | Contract address of the agent's governance token                              |
| PRE_TOKEN        | string (42 chars) | Address of any pre-token used before full deployment                          |
| TOKENS_LOCKED    | number            | Amount of tokens locked in the agent's contract                               |
| WALLETS          | array             | List of associated wallets with the agent                                     |
| STATUS           | string            | Current operational status of the agent (e.g., AVAILABLE, ACTIVATING)         |
| IS_PUBLIC        | boolean           | Whether the agent is publicly accessible                                      |
| IS_PREMIUM       | boolean           | Whether the agent is part of a premium service                                |
| CONFIG_URL       | string            | Link to the agent's JSON configuration                                        |
| IMAGE_URL        | string            | Link to the agent's avatar/image                                              |
| X_USERNAME       | string            | The agent's Twitter/X handle                                                  |
| LANGUAGE         | string            | Language(s) the agent interacts in                                            |
| EXTRA_DATA       | variant           | Additional metadata stored in JSON format                                     |

### token-transfers.csv
Records token transfers between blockchain addresses, use this to answer questions about token transfers. It contains the following columns:

| Field Name      | Type              | Description                                         |
| --------------- | ----------------- | --------------------------------------------------- |
| LAUNCHPAD       | string            | Platform where the transfer occurred                |
| TOKEN           | string (42 chars) | Contract address of the transferred token           |
| SYMBOL          | string            | Symbol of the transferred token (e.g., BRO, AIYP)   |
| NAME            | string            | Name of the transferred token                       |
| BLOCK_NUMBER    | number            | Block height when the transfer was recorded         |
| BLOCK_TIMESTAMP | timestamp         | Timestamp of when the transfer was confirmed        |
| TX_HASH         | string            | Unique transaction ID                               |
| FROM_ADDRESS    | string            | Address that initiated the transfer                 |
| L1_FEE          | number            | Transaction fee paid on Layer 1 (L1) blockchain     |
| L2_FEE          | number            | Transaction fee paid on Layer 2 (L2) blockchain     |
| SENDER          | string            | Address sending the tokens                          |
| RECEIVER        | string            | Address receiving the tokens                        |
| AMOUNT          | number            | Amount of tokens transferred (raw blockchain units) |

### token-trades.csv
Records token swap transactions on blockchain-based liquidity pools. It contains the following columns:

| Field Name         | Type              | Description                                                                    |
| ------------------ | ----------------- | ------------------------------------------------------------------------------ |
| LAUNCHPAD          | string            | Platform where the trade occurred (e.g., CREATOR_BID, VIRTUALS)                |
| BLOCK_TIMESTAMP    | timestamp         | Timestamp when the transaction was confirmed on-chain                          |
| TX_HASH            | string (66 chars) | Unique transaction identifier                                                  |
| TX_SENDER_ADDRESS  | string (42 chars) | Address that initiated the trade                                               |
| POOL               | string (42 chars) | Liquidity pool where the swap took place                                       |
| SENDER             | string (42 chars) | Address selling the tokens                                                     |
| TAKER              | string (42 chars) | Address receiving the bought tokens                                            |
| BUY_TOKEN_ADDRESS  | string (42 chars) | Contract address of the token being bought                                     |
| BUY_TOKEN_SYMBOL   | string            | Symbol of the bought token (e.g., WETH, AIDAOS)                                |
| BUY_TOKEN_NAME     | string            | Full name of the bought token                                                  |
| BUY_AMOUNT         | number            | Amount of the bought token in raw blockchain units (not adjusted for decimals) |
| SELL_TOKEN_ADDRESS | string (42 chars) | Contract address of the token being sold                                       |
| SELL_TOKEN_SYMBOL  | string            | Symbol of the sold token                                                       |
| SELL_TOKEN_NAME    | string            | Full name of the sold token                                                    |
| SELL_AMOUNT        | number            | Amount of the sold token in raw blockchain units                               |


### token-prices.csv
Stores historical token price and TVL data. It contains the following columns:

| Field Name | Type              | Description                                           |
| ---------- | ----------------- | ----------------------------------------------------- |
| LAUNCHPAD  | string            | The trading platform where the token is listed        |
| PRICE_TIME | timestamp         | The timestamp of the recorded price snapshot          |
| TOKEN      | string (42 chars) | The contract address of the token                     |
| SYMBOL     | string            | The symbol representing the token                     |
| NAME       | string            | The full name of the token                            |
| USD_PRICE  | float             | The price of the token in USD                         |
| TVL        | float             | The total value locked (TVL) in the token's ecosystem |

### virtuals-agents.csv
Stores metadata on virtual agents derived from blockchain data. This view combines various agent attributes for further lookup.

| Field Name          | Type              | Description                                                               |
| ------------------- | ----------------- | ------------------------------------------------------------------------- |
| AGENT_TOKEN_ADDRESS | string (42 chars) | The contract address of the agent’s token, serving as a unique identifier |
| NAME                | string            | Name of the virtual agent                                                 |
| SYMBOL              | string            | Token symbol associated with the virtual agent                            |
| DESCRIPTION         | string            | Detailed description of the agent's purpose and features                  |
| CREATED_AT          | timestamp         | Date and time when the agent was created                                  |
| LP                  | string (42 chars) | Address of the liquidity pool associated with the agent                   |
| TBA                 | string (42 chars) | Wallet controlled by the agent                                            |
| WALLETS             | array             | List of wallet addresses associated with the creator of the agent         |
| IS_PUBLIC           | boolean           | Indicates whether the agent is publicly accessible                        |
| IS_PREMIUM          | boolean           | Indicates whether the agent is part of a premium service                  |
| X_USERNAME          | string            | The agent's Twitter/X handle                                              |
| STATUS              | string            | Current operational status of the agent                                   |
| EXTRA_DATA          | variant           | Additional unmapped metadata stored in JSON format                        |
| ADDED_AT            | timestamp         | Timestamp when the agent was added to the system                          |

### token-snapshot.csv
Captures a snapshot of various token metrics and statistics at a specific moment in time.

| Field Name      | Type              | Description                                            |
| --------------- | ----------------- | ------------------------------------------------------ |
| NAME            | string            | Name of the token                                      |
| TOKEN_ADDRESS   | string (42 chars) | Contract address of the token                          |
| SNAPSHOT_TIME   | timestamp         | Date and time when the snapshot was taken              |
| TRANSFER_COUNT  | number            | Number of token transfers recorded during the snapshot |
| TRANSFER_AMOUNT | float             | Total amount of tokens transferred                     |
| BUY_COUNT       | number            | Number of buy transactions recorded                    |
| BUY_AMOUNT      | float             | Total amount of tokens bought                          |
| SELL_COUNT      | number            | Number of sell transactions recorded                   |
| SELL_AMOUNT     | float             | Total amount of tokens sold                            |
| MINT_COUNT      | number            | Number of mint transactions recorded                   |
| MINT_AMOUNT     | float             | Total amount of tokens minted                          |
| BURN_COUNT      | number            | Number of burn transactions recorded                   |
| BURN_AMOUNT     | float             | Total amount of tokens burned                          |
| TOTAL_SUPPLY    | float             | Total token supply                                     |
| HOLDER_COUNT    | number            | Number of unique token holders                         |
| USD_PRICE       | float             | Current price of the token in USD                      |
| TVL             | float             | Total value locked in the token's ecosystem            |
(All the numbers in this table are referred to the snapshot_time hour).

### running-token-balances.csv
Tracks the ongoing balance changes for each token by recording when a balance change occurs.

| Field Name          | Type              | Description                                      |
| ------------------- | ----------------- | ------------------------------------------------ |
| TOKEN_ADDRESS       | string (42 chars) | The contract address of the token                |
| HOLDER              | string            | Identifier or address of the token holder        |
| BALANCE_CHANGE_TIME | timestamp         | Date and time when the balance change occurred   |
| RUNNING_BALANCE     | number            | The updated token balance after the change event |



## Conclusion

This tutorial used a sample dataset from Token Flow, combined with Relational AI's GenAI services through Snowflake, to explore four typical use cases relevant to AI Engineers and Data Scientists:

* Building a Knowledge Graph over Structured Data: Creates a semantic layer over structured data, turning basic data points into more meaningful, interconnected entities, improving both human and machine understanding.
* Building a Knowledge Graph over Unstructured Data: Transforms raw, unstructured text (like emails or reports) into structured, connected knowledge. This makes the data more usable for analysis and automation and allows users to query the data using natural language.
* Predicting Transfer Transactions: Utilizes historical blockchain data to predict future transaction behaviors. This is crucial for making proactive, data-driven decisions in various applications like forecasting sales or detecting fraud.
* Detecting Anomalies: Identifies abnormal patterns (e.g., fraud, failures, or collusion) within blockchain data. Early detection can prevent costly problems by highlighting suspicious activities, like anomalous communities of traders.

Each use case demonstrated how Relational AI's GenAI capabilities can leverage blockchain data to drive actionable insights in Decentralized Finance (DeFi) and beyond.


## Further Information

You can view a live presentation of these four use cases in the following [RelationaAI GenAI video](https://relationalai.zoom.us/rec/share/lb_5ljy61m5W1S1AoIKNGkNAtWf3lmP9tjm3mbSPbH_3bHEw-o7Uk-dSktCJjJMi.RTygbG-HAQMbsDzo
). Please contact a RelationalAI representative for the passcode.

You can also view the slides of this presentation in the [/pdf](/pdf) folder.