--Total revenue by month
SELECT invoice_month , ROUND(SUM(total_price)) as total_revenue
FROM ecommerce_table
GROUP BY invoice_month
ORDER BY total_revenue DESC
;

--Top-10 products by revenue
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

--Top-10 countries by revenue
WITH revenue_by_country AS(
SELECT country, 
ROUND(SUM(total_price)) as total_revenue ,
DENSE_RANK() OVER(ORDER BY ROUND(SUM(total_price)) DESC) as rn
FROM ecommerce_table
GROUP BY country



)
SELECT * FROM revenue_by_country
WHERE rn <= 10;

--Average order value
SELECT ROUND(AVG(total_price),2) as average_ordervalue FROM ecommerce_table;


--Top-5 frequent products by Canada
SELECT  stock_code , description, COUNT(stock_code) as number_of_orders , country
FROM ecommerce_table
WHERE country = 'Canada'
GROUP BY stock_code,  country , description
LIMIT 5;


--RFM clients segmentation

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

