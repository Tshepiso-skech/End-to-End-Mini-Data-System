# End-to-End Data Infrastructure & ML System for Small Businesses

Small service businesses struggle to track customer spending patterns, monitor revenue performance, analyze value distribution, and accurately plan resources. 
This Minimum Viable Product bridges the gap. It serves as an operational system that pipelines the data, and delivers the precise analytics required to optimize revenue.

---

## Project Overview

This project acts as an MVP pipeline that performs data orchestration. It simulates almost realistic business data and stores it in predefined tables via PostgreSQL, performs minimal data engineering and feature creation, computes KPIs and segmentation logic and visualizes insights in a **Streamlit dashboard.**

Each layer is strictly isolate, handles separated structural responsibilities:

| **Architectural Layer** | **Structural Responsibility** |
|---|---|
| [Simulate Layer](./src/simulate_data.py) | Serves as the data generation engine; it generates, structures and formats Pandas DataFrames relative to their target schemas. |
| [Data Orchestration](./src/database.py) | Data Pipeline that moves the simulated data to native defined database tables in Postgres |
| [Data Engineering](./src/data_engineering.py) | Data is pulled from the schema layer (PostgreSQL) into the engineering layer. The pipeline ensures necessary feature engineering measures as well as detecting and dealing with inconsistencuies. Necessary transformation measures are also taken and loaded in csv formats. |
| [Analysis](./src/analysis.py) | This layer centralizes standard KPIs, ensuring consistent and  governed metrics; it prepares the data for interactive dashboards and reports.|


## Getting Started

Follow these steps to initialize the PostgreSQL database schema and populate it with simulated operational data.

### Prerequisites
* **PostgreSQL** installed and running locally.
* **Python 3.x** installed with required dependencies (`pip install -r requirements.txt`).

### Database Initialization & Setup
1. **Create an Empty Database** and name it **CARWASH**
2. **Deploy the Database**: run ``` psql -U postgres -d CARWASH -f db/schema.sql```
3. **Populate Seed Data**: 
Run the data generation pipeline to seed the newly created database tables with simulated car wash operational workflows, transactions, and customer patterns following the [Simulate_data.py](src/simulate_data.py) and [database.py](src/database.py)


## Deployment
Hosted on Streamlit Cloud