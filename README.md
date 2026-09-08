# End-to-End Data Infrastructure & ML System for Small Businesses 
![Python](https://img.shields.io/badge/Python-3.9-blue)
![R](https://img.shields.io/badge/R-4.3.2-blue)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18-blue)
![License](https://img.shields.io/badge/License-MIT-green)

### Problem Definition
Small Service businesses struggle to:
- Track customer spending patterns
- Monitor Revenue Performance
- Analyze value distribution
- Plan resources accurately

**This MVP bridges that gap** It simulates almost realistic business data and stores it in predefined tables via PostgreSQL, performs minimal data engineering and feature creation, computes exploaratory analytics, KPIs and segmentation logic. This project leverages R, ![Python](https://img.shields.io/badge/Python-3.9-blue) for rigorous statistical analysis and Python, ![R](https://img.shields.io/badge/R-4.3.2-blue) for scalable data engineering; a dual-language approach that ensures both analytical depth and production readiness, bridging the gap between academic rigor and business execution.

**Architecture** 
- The [Simulation](./src/simulate_data.py) layer serves as the data generation engine; it generates, structures and formats Pandas DataFrames relative to their target schemas
- [Data Orchestration](./src/database.py) layer moves the simulated data to native defined database tables in PostgreSQL. 
- Data is pulled from the schema layer (PostgreSQL) into the [Data Engineering](./src/data_engineering.py) layer which ensures necessary feature engineering measures as well as detecting and dealing with inconsistencies. Necessary transformation measures are also taken and sttored in csv formats. 
-  This layer, [Analysis](./src/analysis.py) centralizes standard KPIs, ensuring consistent and  governed metrics; it prepares the data for interactive dashboards and reports.
- [Statistical Analysis](./statistics/) layer performs relevant statistical computations to understand distributions of the data better and perform tests to increase our confidence in analytics.

### Analytics Modules
- Customer Intelligence
- Revenue Analytics
- Service Performance
- Payment Intelligence
- Statistical Analysis: Confidence Intervals, Hypothesis Tests, distribution fitting
- Risk & Anomaly Detection\
  
*View the full interactive statistical report here:*
*[Statistical Report](https://tshepiso-skech.github.io/End-to-End-Mini-Data-System/End-to-End-Mini-Data-System/statistical-report.html)*
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


