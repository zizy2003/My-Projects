# A/B Testing Analysis Project

## Overview
Analysis of landing page A/B test comparing old vs new page design to determine which performs better for user conversion rates.

## Dataset Information

- **Source**: [Kaggle A/B Testing Dataset](https://www.kaggle.com/datasets/ttrngquangminh/ab-testing-dataset)
- **Sample Size**: 290,584 users
- **Test Period**: January 2017
- **Geographic Scope**: USA, UK, Canada  
- **Duration**: 22 days
- **Metrics**: Conversion rate

## Key Findings

### Test Results
- **Control Group (old page)**: 12.03% conversion rate
- **Treatment Group (new page)**: 11.88% conversion rate
- **Difference**: 0.15 percentage points favoring old design
- **Statistical Significance**: Not practically significant given large sample size

### Business Recommendation
**Recommendation**: Retain the old page design as the new version did not demonstrate statistically significant improvement in conversion rates.

## Project Structure

```
AB-testing/
├── rawdata/                # Original CSV datasets
├── pandas/                 # Data cleaning and exploration notebook
├── sql/                    # Database analysis queries
├── powerbi-visualization/  # Interactive dashboards
├── final_data/             # Processed dataset for analysis
└── README.md               # Project documentation
```

## Technologies Used

- **Python (pandas)** - Data processing and statistical analysis
- **SQL (PostgreSQL)** - Database queries and data aggregations
- **Power BI** - Data visualization and interactive dashboards
- **Jupyter Notebook** - Exploratory data analysis

## Getting Started

### Prerequisites
- Python 3.8+
- PostgreSQL
- Power BI Desktop
- Jupyter Notebook

### Installation Steps
1. Clone the repository:
   ```bash
   git clone [repository-url]
   cd AB-testing
   ```

2. Install dependencies:
   ```bash
   pip install pandas jupyter
   ```

3. Run Jupyter notebook in `pandas/` folder for data processing

4. Load data into PostgreSQL and execute SQL queries from `sql/` folder

5. Open Power BI file in `powerbi-visualization/` folder for interactive analysis

## Results Interpretation

The analysis revealed that the new landing page design did not lead to a statistically significant improvement in conversion rates. With a sample size of 290,584 users, the 0.15 percentage point difference is not practically significant for business decisions.

### Key Insights
- Large sample size provides high statistical power
- Effect size is minimal and not actionable
- User behavior patterns consistent across both variants
- No significant segment-based differences observed

## Future Recommendations

- Consider testing more radical design changes
- Investigate user feedback qualitative data
- Test different value propositions rather than design elements
- Implement multivariate testing for comprehensive insights

---

**Data Source**: [A/B Testing Dataset](https://www.kaggle.com/datasets/ttrngquangminh/ab-testing-dataset) from Kaggle
