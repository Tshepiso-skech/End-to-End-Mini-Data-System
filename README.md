## End-to-End Data & ML System for Small Businesses

## PROBLEM STATEMENT: 
Many small service businesses struggle to track customer spending patterns and repeat behavior, monitor bookings and revenue performance, understand customer value distribution and plan resources. This system captures most business operations, analyze data, and provides actionable insights.

## SOLUTION OVERVIEW:
This project is a complete data system that simulates realistic business data, stores structured data in PostgreSQL, performs data engineering and feature creation, computes KPIs and segmentation logic and visualizes insights in a Streamlit dashboard.

## PROJECT FEATURES: 
Data simulation layer
Relational database storage (PostgreSQL)
Data engineering pipeline (Python)
Analytics & visualization (IPython)

## PROJECT STRUCTURE:
Data Simulation → PostgreSQL → Data Engineering → Analytics & ML → Streamlit Dashboard
data-intelligence/
│
├── data_simulation/
│   ├── analytics/
|   ├── processed/
│   ├── raw/
|
├── db/
│   ├── schema.sql
│   └── queries.sql
├── src/
│   ├── data_engineering.ipynb
│   └── database.py
|   ├── simulate_data.py

├── notebooks/
│   └── analysis.ipynb
│
├── streamlit/
│   ├── dashboard.py
│   └── style.css
│
├── requirements.txt
├── README.md
└── .gitignore

## Deployment
Hosted on Streamlit Cloud