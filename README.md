# End-to-End Data Infrastructure & ML System for Small Businesses

Small service businesses struggle to track customer spending patterns, monitor revenue performance, analyze value distribution, and accurately plan resources. 
This Minimum Viable Product bridges the gap. It serves as an operational system that pipelines the data, and delivers the precise analytics required to optimize revenue.


## SOLUTION OVERVIEW:
This project is a complete data system that simulates realistic business data, stores structured data in PostgreSQL, performs data engineering and feature creation, computes KPIs and segmentation logic and visualizes insights in a Streamlit dashboard.

## PROJECT FEATURES: 
Data simulation layer
Relational database storage (PostgreSQL)
Data engineering pipeline (Python)
Analytics & visualization (IPython)


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