🛒 Walmart Sales Data Analysis
📊 Project Overview
This project performs data analysis on Walmart sales data to uncover business insights such as:

Revenue performance by branch and year

Most popular payment methods

Sales trends by time of day (morning, afternoon, evening)

Year-over-year revenue comparison

The goal is to understand customer behavior and branch performance using SQL queries and basic data analysis.

🗂️ Dataset
File name: walmart-10k-sales-datasets.csv
Description: Contains transaction-level data for multiple Walmart branches.

Key columns include:

Column	Description
invoice_id	Unique ID for each transaction
branch	Store branch (A, B, or C)
city	Location of the branch
customer_type	Member or normal customer
gender	Gender of the customer
product_line	Category of the product sold
unit_price	Price per item
quantity	Number of items purchased
tax	5% of the total cost
total	Total amount paid
date	Date of transaction
time	Time of transaction
payment	Payment method used
rating	Customer satisfaction rating

🧮 Tools & Technologies
SQL – For data querying and aggregation

MySQL / PostgreSQL – Database engine

Python – For visualization or preprocessing

Excel / Power BI (optional) – For charts and dashboards

⚙️ Key SQL Analyses
Preferred Payment Method per Branch

sql
Copy code
WITH cte AS (
    SELECT 
        branch,
        payment_method,
        COUNT(*) AS total_trans,
        RANK() OVER(PARTITION BY branch ORDER BY COUNT(*) DESC) AS rank
    FROM walmart
    GROUP BY branch, payment_method
)
SELECT branch, payment_method AS preferred_payment_method
FROM cte
WHERE rank = 1;
Revenue Drop from 2022 to 2023

sql
Copy code
WITH revenue_2022 AS (
    SELECT branch, SUM(total) AS revenue_2022
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT branch, SUM(total) AS revenue_2023
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2023
    GROUP BY branch
)
SELECT 
    r22.branch,
    r22.revenue_2022,
    r23.revenue_2023,
    ROUND(((r22.revenue_2022 - r23.revenue_2023) / r22.revenue_2022) * 100, 2) AS revenue_drop_percent
FROM revenue_2022 AS r22
JOIN revenue_2023 AS r23 ON r22.branch = r23.branch
WHERE r22.revenue_2022 > r23.revenue_2023
ORDER BY revenue_drop_percent DESC
LIMIT 5;
Sales by Time of Day

sql
Copy code
SELECT
    CASE
        WHEN HOUR(time) < 12 THEN 'MORNING'
        WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'AFTERNOON'
        ELSE 'EVENING'
    END AS day_time,
    COUNT(*) AS total_transactions
FROM walmart
GROUP BY day_time;
📈 Insights
Branch B had the highest total sales.

E-wallets were the most used payment method across branches.

Most purchases happened in the evening.

Revenue declined in some branches in 2023 compared to 2022.

🚀 How to Run
Import dataset into your SQL environment:

sql
Copy code
CREATE DATABASE walmart_analysis;
USE walmart_analysis;
LOAD DATA INFILE 'walmart-10k-sales-datasets.csv'
INTO TABLE walmart
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
Run the SQL queries from this project.

Review outputs or visualize results in Power BI / Excel.

🧠 Future Enhancements
Build interactive Power BI dashboards.

Add Python notebooks for deeper trend analysis.

Predict future revenue using machine learning.

👨‍💻 Author
Seenivasan
Data & SQL Enthusiast
