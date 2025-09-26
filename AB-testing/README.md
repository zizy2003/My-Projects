# A/B Testing Analysis Project

## Overview
Analysis of landing page A/B test comparing old vs new page design to determine which performs better for user conversion.

## Data Source

- **Dataset**: Kaggle A/B Testing Dataset
- **Sample size**: 290,584 users
- **Test period**: January 2017 
- **Geographic scope**: US, UK, Canada
- **Test duration**: 22 days
[View Dataset on Kaggle](https://www.kaggle.com/datasets/ttrngquangminh/ab-testing-dataset)

Source: [A/B Testing Dataset](https://www.kaggle.com/datasets/ttrngquangminh/ab-testing-dataset) from Kaggle

## Key Findings
- **Control group (old page)**: 12.03% conversion rate
- **Treatment group (new page)**: 11.88% conversion rate  
- **Difference**: 0.15 percentage points in favor of old design
- **Statistical significance**: Not practically significant given large sample size
- **Business recommendation**: Retain old page design

## Project Structure
AB-testing/
├── rawdata/           # Original CSV datasets
├── pandas/            # Data cleaning and exploration notebook
├── sql/               # Database analysis queries
├── powerbi-visualization/  # Interactive dashboards
├── final_data/        # Processed dataset for analysis
└── README.md

## Technologies Used
- **Python** (pandas) - Data processing and analysis
- **SQL** (PostgreSQL) - Database queries and aggregations  
- **Power BI** - Data visualization and dashboards

## How to Reproduce
1. Clone this repository
2. Run Jupyter notebook in `pandas/` folder for data processing
3. Load data and execute SQL queries from `sql/` folder  
4. Open Power BI file in `powerbi-visualization/` for interactive analysis
