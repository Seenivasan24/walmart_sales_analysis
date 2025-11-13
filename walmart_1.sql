#basic operation to analysis data
use walmart_analysis;

SELECT * from walmart_analysis.walmart;

#count

SELECT 
category,count(*) 
from walmart_analysis.walmart
group by category;

SELECT 
count(*) 
from walmart_analysis.walmart;

#DISTINCT

#payment method

select distinct 
payment_method 
from walmart_analysis.walmart;

#count
select  
payment_method,count(*) 
from walmart_analysis.walmart
group by payment_method;

#count important

select 
count(distinct Branch) 
from walmart_analysis.walmart;

#quantity analysis

select 
unit_price,quantity
from walmart_analysis.walmart
where city in
(
  select City
  from walmart_analysis.walmart 
  group by city
);
select max(quantity) from walmart_analysis.walmart;

-- Business Problem Q1: Find different payment methods, number of transactions, and quantity sold by payment method
SELECT 
    payment_method,
    COUNT(*) AS no_payments,
    SUM(quantity) AS no_qty_sold
FROM walmart
GROUP BY payment_method;

-- Project Question #2: Identify the highest-rated category in each branch
-- Display the branch, category, and avg rating
SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating,
        RANK() OVER(PARTITION BY branch ORDER BY AVG(rating) DESC) AS rank_based_on_categorey
    FROM walmart
    GROUP BY branch, category
) AS ranked
WHERE rank_based_on_categorey = 1;

-- Q3: Identify the busiest day for each branch based on the number of transactions
SELECT branch, day_name, no_transactions
FROM (
    SELECT 
        branch,
        DAYNAME(STR_TO_DATE(date, '%d/%m/%Y')) AS day_name,
        COUNT(*) AS no_transactions,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_busy_days
    FROM walmart
    GROUP BY branch, day_name
) AS ranked
WHERE rank_busy_days= 1;

-- Q4: Calculate the total quantity of items sold per payment method
SELECT 
    payment_method,
    SUM(quantity) AS no_qty_sold
FROM walmart
GROUP BY payment_method;

-- Q5: Determine the average, minimum, and maximum rating of categories for each city
SELECT 
    city,
    category,
    MIN(rating) AS min_rating,
    MAX(rating) AS max_rating,
    AVG(rating) AS avg_rating
FROM walmart
GROUP BY city, category;

-- Q6: Calculate the total profit for each category
SELECT 
    category,
    SUM(unit_price * quantity * profit_margin) AS total_profit
FROM walmart
GROUP BY category
ORDER BY total_profit DESC;

-- Q7: Determine the most common payment method for each branch
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank_based_on_payement_method
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rank_based_on_payement_method = 1;

#bussiness question 8 
#catrgorize sales into 3 group MORNING,AFTERNOON,EVENING
#FIND OUT EACH OF THE SHIFT AND NUMBER OF INVOICES

SELECT
    *,
    CASE
        WHEN HOUR(time) < 12 THEN 'MORNING'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS Day_time
FROM walmart_analysis.walmart;

SELECT
    CASE
        WHEN HOUR(time) < 12 THEN 'MORNING'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS Day_time,
    COUNT(*) AS total_transactions
FROM walmart_analysis.walmart
GROUP BY Day_time;

SELECT
	Branch,
    CASE
        WHEN HOUR(time) < 12 THEN 'MORNING'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS Day_time,
    COUNT(*) AS total_transactions
FROM walmart_analysis.walmart
GROUP BY Branch,Day_time
order by Branch,total_transactions;

#9 identify 5 branch with highest decrese ratio in
#revenue compare to last year(current year and last year)

WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(unit_price) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(unit_price) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 
	ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
ORDER BY revenue_decrease_ratio DESC;

#limit
WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(unit_price) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(unit_price) AS revenue
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r2022.branch,
    r2022.revenue AS last_year_revenue,
    r2023.revenue AS current_year_revenue,
    ROUND(((r2022.revenue - r2023.revenue) / r2022.revenue) * 100, 2) AS revenue_decrease_ratio
FROM revenue_2022 AS r2022
JOIN revenue_2023 AS r2023 ON r2022.branch = r2023.branch
WHERE r2022.revenue > r2023.revenue
group by Branch
ORDER BY revenue_decrease_ratio DESC
LIMIT 5;







