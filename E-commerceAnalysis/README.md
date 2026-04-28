# E-Commerce Sales Analysis

## 📌 Overview
This project analyzes an online retail dataset to uncover sales trends, customer behavior, 
and product performance. The analysis is structured across three stages: 
data preprocessing in Python, SQL-based analysis in PostgreSQL, and interactive 
dashboards in Power BI.

---

## 📂 Dataset
**Source:** [E-commerce Dataset (Kaggle)](https://www.kaggle.com/datasets/carrie1/ecommerce-data)

| Column | Description |
|---|---|
| InvoiceNo | Unique transaction identifier |
| StockCode | Product code |
| Description | Product name |
| Quantity | Number of units per transaction |
| InvoiceDate | Date and time of transaction |
| UnitPrice | Price per unit (GBP) |
| CustomerID | Unique customer identifier |
| Country | Country of the customer |

**Dataset size:** 541,909 rows | **Period:** December 2010 – December 2011

---

## 🛠 Stack
- **Python (Pandas)** — data cleaning and preprocessing
- **PostgreSQL (pgAdmin)** — SQL analysis and views
- **Power BI** — interactive dashboards

---

## 📊 Key Metrics
| Metric | Value |
|---|---|
| Total Revenue | ~£9.7M |
| Average Order Value | $18.15 |
| Unique Customers | 4,338 |
| Avg Retention Rate | ~43% |
| Top Revenue Month | November 2011 |
| Category A Products | 19% of products → 80% of revenue |
| At Risk Customers | 1,422 customers → £6.1M revenue |
| Champions | 294 customers |

---

## 🔍 Analysis Performed
- **Revenue Trend** — monthly and yearly revenue dynamics
- **Top-10 Products by Revenue** — best performing SKUs
- **Top-10 Countries by Revenue** — geographic revenue distribution
- **RFM Segmentation** — customers classified into 6 segments:
  - Champions, Loyal Customers, Potential Loyalists
  - New Customers, At Risk, Lost
- **ABC Product Analysis** — product classification by revenue contribution
- **Retention Rate** — monthly customer retention tracking
- **Cohort Analysis** — returning customer behavior tracked by acquisition month

---

## 📈 Key Findings
- Revenue peaks in **November (+96% vs average month)** — driven by holiday season demand
- **At Risk segment** is the largest group (1,422 customers) generating £6.1M —
  these are formerly active customers who stopped purchasing
- Only **294 Champions** exist — the most valuable but smallest segment
- **19% of products (Category A)** generate 80% of total revenue
- Retention drops sharply from **48% in October to 19% in December** —
  indicating a large volume of one-time holiday buyers
- Average retention of **~43%** suggests moderate but improvable customer loyalty

---

## 💡 Business Recommendations

### Re-engage At Risk Customers → Projected retention rate +5–8%
At Risk customers (r_score ≤ 2, f_score ≥ 3) are formerly active buyers who stopped purchasing.  
Re-engagement tactics:
- Personalized email campaigns ("We miss you" + discount based on purchase history)
- Win-back offers: 15–20% discount on next order
- Product recommendations based on previously purchased categories

### Grow Champions Segment → Projected repeat purchase revenue +10–12%
Growing Champions from 294 to 500+ through a loyalty program:
- Exclusive early access to new products
- Points-based reward system
- VIP tier with free shipping and priority support

### Seasonal Inventory Planning → Projected November revenue +8–10%
Q4 drives the highest revenue — stocking Category A products 4–6 weeks  
before November reduces stockouts during peak demand

### Focus Marketing on Category A Products → Projected AOV +10–15%
19% of SKUs generate 80% of revenue — concentrating marketing budget  
on these products maximizes ROI and increases Average Order Value through  
upsell and cross-sell strategies

### Reduce Post-Holiday Churn → Projected Q1 retention +5–8%
December buyers are largely one-time holiday shoppers.  
Post-holiday engagement campaigns in January can convert them into repeat customers:
- Follow-up emails with personalized offers
- "New Year" discount for second purchase within 30 days

---

## 📁 Project Structure
```
E-commerceAnalysis/
│
├── Data/
│   ├── ecommercedatab4preproc.csv       # Raw dataset
│   └── ecommerce_cleaned.csv            # Cleaned dataset
│
├── EDAData-cleaning(Python)/
│   └── ecommerce_preprocessing.ipynb    # Pandas preprocessing notebook
│
├── SQL/
│   └── initial_setup.sql     # Table creation and inserting values from dataset into the table   
    └── analysis.sql         # All SQL queries 
    └── views_creation.sql   # Views creation
│
└── PowerBI/
├── Dashboard.pbix                   # Power BI file
└── README.md                        # Dashboard documentation
```
---

## 🔗 Links
- 📊 Power BI Dashboards:
  - [1st one:](https://app.powerbi.com/links/PW4N-wFB8b?ctid=eb34f74a-58e7-4a8b-9e59-433e4c412757&pbi_source=linkShare)
  - [2nd one:](https://app.powerbi.com/links/PW4N-wFB8b?ctid=eb34f74a-58e7-4a8b-9e59-433e4c412757&pbi_source=linkShare&bookmarkGuid=04e34a70-94ff-493e-b193-feab12910bd5)
- 📁 [Dataset on Kaggle](https://www.kaggle.com/datasets/carrie1/ecommerce-data)