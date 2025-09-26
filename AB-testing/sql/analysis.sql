--Control group - old page
--Treatment group - new page


-- Finding a conversion patterns through days of week
SELECT TO_CHAR(timestamp , 'Day') as day_of_week,
group_name as group,
CONCAT(ROUND(SUM(converted) * 100.0 / COUNT(*), 2), '%') as conversion_rate 
FROM ab_testing
GROUP BY day_of_week,group_name
ORDER by conversion_rate DESC;


-- Finding a top-3 hours with highest conversion rate for each group
WITH ranked_hours AS (
SELECT CONCAT(EXTRACT(hour FROM timestamp) ,':00') as hour,
group_name,
CONCAT(ROUND(SUM(converted) * 100.0 / COUNT(*), 2), '%') as conversion_rate,
ROW_NUMBER() OVER (PARTITION BY group_name ORDER BY SUM(converted) * 100.0 / COUNT(*) DESC ) as rnk
FROM ab_testing
GROUP BY EXTRACT(hour FROM timestamp) , group_name

)
SELECT hour, group_name as group, conversion_rate
FROM ranked_hours
WHERE rnk <= 3;

--Finding a conversion patterns through countries
SELECT country ,
group_name as group,
CONCAT(ROUND(SUM(converted) * 100.0 / COUNT(*), 2), '%') as conversion_rate 
FROM ab_testing
GROUP BY country, group_name
ORDER BY group_name;

--Finding KPI's
SELECT 
    MIN(timestamp) as test_start,
    MAX(timestamp) as test_end,
    ROUND(EXTRACT(epoch FROM (MAX(timestamp) - MIN(timestamp)))/86400, 2) as test_duration_days,
    COUNT(DISTINCT user_id) as total_users,
    SUM(converted) as total_conversions,
    CONCAT(ROUND(SUM(converted) * 100.0 / COUNT(*), 2), '%') as overall_conversion_rate
FROM ab_testing;

--Country distribution by users
SELECT group_name , country , COUNT(*) as number_of_users
FROM ab_testing
GROUP BY country, group_name
ORDER BY number_of_users DESC;

--Main A/B test, as in Pandas
SELECT group_name as group,
CONCAT(ROUND(SUM(converted) * 100.0 / COUNT(*), 2), '%') as conversion_rate
FROM ab_testing
GROUP BY group_name;

