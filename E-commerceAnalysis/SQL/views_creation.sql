--Total Revenue Card View
CREATE OR REPLACE VIEW total_revenue AS
SELECT 
DATE_TRUNC('month', invoice_date) AS invoice_month,
ROUND(SUM(total_price)) AS total_revenue
FROM ecommerce_table
GROUP BY DATE_TRUNC('month', invoice_date)
ORDER BY invoice_month;


--Top-10 Products by revenue View
CREATE OR REPLACE VIEW top10_products_by_revenue AS
WITH revenue_by_product AS(
SELECT stock_code,
description , 
ROUND(SUM(total_price)) as total_revenue ,
DENSE_RANK() OVER(ORDER BY ROUND(SUM(total_price)) DESC) as rn
FROM ecommerce_table
GROUP BY stock_code, description


)

SELECT * FROM revenue_by_product 
WHERE rn <= 10;

--Top-10 Countries by revenue View
CREATE OR REPLACE VIEW top10_countries_by_revenue AS
WITH revenue_by_country AS(
SELECT country, 
ROUND(SUM(total_price)) as total_revenue ,
DENSE_RANK() OVER(ORDER BY ROUND(SUM(total_price)) DESC) as rn
FROM ecommerce_table
GROUP BY country



)
SELECT * FROM revenue_by_country
WHERE rn <= 10;
--Average Order Value Card
CREATE OR REPLACE VIEW avg_order_value AS
SELECT ROUND(AVG(total_price),2) as average_ordervalue FROM ecommerce_table;

--Top-5 frequent products by Canada View
CREATE OR REPLACE VIEW top5freq_products_canada AS
SELECT  stock_code , description, COUNT(stock_code) as number_of_orders , country
FROM ecommerce_table
WHERE country = 'Canada'
GROUP BY stock_code,  country , description
ORDER BY COUNT(stock_code) DESC
LIMIT 5;

--RFM segmentation View
CREATE OR REPLACE VIEW rfm AS 
WITH rfm_base AS (

SELECT customer_id,
MAX(date) AS last_purchase,
COUNT(DISTINCT invoice_no) AS frequency,
ROUND(SUM(total_price)) AS monetary,
(SELECT MAX(date) FROM ecommerce_table) - MAX(date) as recency
FROM ecommerce_table
WHERE customer_id != 'Guest' AND total_price > 0

GROUP BY customer_id
)
,

rfm_score AS (
SELECT * ,
NTILE(5) OVER (ORDER BY recency ASC) as r_score,
NTILE(5) OVER (ORDER BY frequency ASC) as f_score,
NTILE(5) OVER (ORDER BY monetary ASC) as m_score
FROM rfm_base
),

rfm_segments AS(
SELECT *,
CONCAT(r_score,f_score,m_score) AS rfm_score,
CASE
WHEN r_score >= 4 AND f_score >= 4 THEN 'Chapmions'
WHEN r_score >= 3 and f_score >= 3 THEN 'Loyal Customers'
WHEN r_score >= 4 and f_score <= 2 THEN 'New Customers'
WHEN r_score <= 2 AND f_score >= 3 THEN 'At Risk'
WHEN r_score <= 2 AND f_score <= 2 THEN 'Lost'
ELSE 'Potential Loyalists'
END as segment
FROM rfm_score


)

SELECT * FROM rfm_segments
ORDER BY monetary DESC;

--Retention rate View
CREATE OR REPLACE VIEW rtntion AS
WITH monthly_customers AS (

SELECT customer_id,
DATE_TRUNC('month' , invoice_date) AS month
FROM ecommerce_table
WHERE customer_id != 'Guest'
GROUP BY customer_id , DATE_TRUNC('month' , invoice_date)
),
retention AS (

SELECT a.month,
COUNT(DISTINCT a.customer_id) AS total_customers, 
COUNT(DISTINCT b.customer_id) AS retained_customers,
ROUND(COUNT(DISTINCT b.customer_id) * 100.00 / COUNT(DISTINCT a.customer_id),2) AS retention_rate
FROM monthly_customers a
LEFT JOIN monthly_customers b ON a.customer_id = b.customer_id
AND b.month = a.month + INTERVAL '1 month'
GROUP BY a.month


)

SELECT * FROM retention
ORDER BY month;

--ABC product analysis view 
CREATE OR REPLACE VIEW abc_analysis AS
WITH cumilative_percent AS (

SELECT stock_code,
description,
ROUND(SUM(total_price),2)  as total_revenue,
SUM(SUM(total_price)) OVER(ORDER BY SUM(total_price) DESC),
SUM(SUM(total_price)) OVER(ORDER BY SUM(total_price) DESC) / SUM(SUM(total_price)) OVER() * 100.00 as cumulative_revenue
FROM ecommerce_table
GROUP BY stock_code, description
)
,
abc_analysis AS (
SELECT stock_code,
description,
CASE WHEN cumulative_revenue <= 80 THEN 'A'
WHEN cumulative_revenue > 80  AND cumulative_revenue <= 95  THEN 'B'
ELSE 'C'
END AS abc
FROM cumilative_percent
)

SELECT * FROM abc_analysis

--Cohort view
CREATE OR REPLACE VIEW cohort_analysis AS
WITH first_purchase AS (
    SELECT 
    customer_id,
    MIN(DATE_TRUNC('month', invoice_date)) AS cohort_month
    FROM ecommerce_table
    WHERE customer_id != 'Guest'
    AND total_price > 0
    GROUP BY customer_id
),
all_transactions AS (

SELECT customer_id , 
DATE_TRUNC('month', invoice_date) AS transaction_month
FROM ecommerce_table
WHERE customer_id != 'Guest' and total_price > 0
GROUP BY customer_id , transaction_month

),

cohort AS (
SELECT a.customer_id , a.cohort_month,
EXTRACT(YEAR FROM AGE(b.transaction_month, a.cohort_month)) * 12 +
EXTRACT(MONTH FROM AGE(b.transaction_month, a.cohort_month)) as month_number
FROM first_purchase a
JOIN all_transactions b ON a.customer_id = b.customer_id

)

SELECT 
cohort_month,
month_number,
COUNT(DISTINCT customer_id) AS total_customers
FROM cohort
GROUP BY cohort_month, month_number
ORDER BY cohort_month, month_number;
