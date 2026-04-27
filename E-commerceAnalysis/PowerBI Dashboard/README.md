# Power BI Dashboards

## Overview
Two interactive dashboards built in Power BI analyzing e-commerce sales data (UK Online Retail Dataset).  
Data was preprocessed in Python (Pandas) and analyzed in PostgreSQL before visualization.

---

## Dashboard 1 — Sales Overview
**[View Dashboard](https://app.powerbi.com/links/iQOL-9OUfR?ctid=eb34f74a-58e7-4a8b-9e59-433e4c412757&pbi_source=linkShare)**

Provides a high-level view of business performance:

- **Total Revenue by Month and Year** — revenue trend across the entire period, with a clear peak in November 2011 (Black Friday / holiday season)
- **Top-10 Products by Revenue** — best performing products driving the most sales
- **Top-10 Countries by Revenue** — geographic distribution of revenue across markets
- **Average Order Value** — average transaction value across all orders ($18.15)

---

## Dashboard 2 — Customer Analysis
**[View Dashboard](https://app.powerbi.com/links/PW4N-wFB8b?ctid=eb34f74a-58e7-4a8b-9e59-433e4c412757&pbi_source=linkShare&bookmarkGuid=e15b3ef1-b133-44a2-b5d2-5bdc7b8bfcf6)**

Focuses on customer behavior and segmentation:

- **Number of Customers by Segment** — RFM-based segmentation showing 1,422 At Risk customers as the largest group
- **Revenue by Customer Segment** — At Risk customers generate 6.1M in revenue, highlighting the importance of retention strategy
- **Retention Rate by Month** — monthly retention fluctuates between 33-48%, dropping sharply in November-December
- **ABC Product Analysis** — 19% of products (Category A) drive 80% of revenue
- **Cohort Analysis Matrix** — tracks how many customers from each cohort returned in subsequent months

---

## Key Insights
- Revenue grows significantly in Q4, peaking in November — driven by seasonal demand
- 1,422 customers are At Risk despite generating the highest revenue — retention campaigns recommended
- Only 294 Champions exist — loyalty program could help grow this segment
- Category C products (61%) contribute minimally to revenue — inventory optimization opportunity