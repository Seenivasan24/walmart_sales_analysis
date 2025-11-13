# 🛒 Walmart Sales Data Analysis

A complete **SQL-based data analysis project** to explore Walmart’s sales data and uncover valuable business insights.  
This project demonstrates the use of **SQL queries** for data cleaning, aggregation, and business performance analysis.

---

## 📘 Project Overview

The **Walmart Sales Data Analysis** project focuses on analyzing retail transaction data to understand:
- 📊 Branch-wise revenue performance  
- 💳 Most preferred payment methods  
- ⏰ Sales distribution across different times of the day  
- 📉 Year-over-year revenue changes (2022 vs 2023)

The analysis helps in making **data-driven decisions** to improve sales and operational efficiency.

---

## 🧾 Dataset Description

**Dataset Name:** `walmart-10k-sales-datasets.csv`  
**Source:** Walmart sales data (sample dataset for learning and analysis)

| Column Name | Description |
|--------------|-------------|
| `invoice_id` | Unique ID for each transaction |
| `branch` | Store branch (A, B, or C) |
| `city` | City in which the branch is located |
| `customer_type` | Type of customer (Member or Normal) |
| `gender` | Gender of the customer |
| `product_line` | Category of the product sold |
| `unit_price` | Price per item |
| `quantity` | Number of items purchased |
| `tax` | Tax applied (5% of total) |
| `total` | Total amount paid including tax |
| `date` | Date of transaction |
| `time` | Time of transaction |
| `payment` | Payment method (Cash, Credit Card, Ewallet, etc.) |
| `rating` | Customer satisfaction rating (1–10) |

---

## 🧠 Objectives

1. Identify the **most preferred payment method** for each branch.  
2. Compare **revenue performance between 2022 and 2023**.  
3. Categorize transactions into **Morning, Afternoon, and Evening**.  
4. Discover the **top 5 branches** with the highest revenue drop.  
5. Analyze overall **sales trends** and **customer behavior**.

---

## 🛠️ Tools and Technologies Used

| Tool / Technology | Purpose |
|--------------------|----------|
| **MySQL** | SQL queries and analysis |
| **Excel** | data view purpose afeter cleaned|
| **Python** | Data preprocessing or automation |
| **Git & GitHub** | Version control and project hosting |

---

## ⚙️ SQL Queries Used

### 🔹 1. Preferred Payment Method per Branch
```sql
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

2 revenue
WITH revenue_2022 AS (
    SELECT 
        branch,
        SUM(total) AS revenue_2022
    FROM walmart
    WHERE YEAR(STR_TO_DATE(date, '%d/%m/%Y')) = 2022
    GROUP BY branch
),
revenue_2023 AS (
    SELECT 
        branch,
        SUM(total) AS revenue_2023
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

3. Sales by Time of Day
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
📈 Key Insights
Insight	Observation
🏆 Top Branch	Branch B generated the highest total revenue
💳 Preferred Payment	E-Wallets were most frequently used
🕓 Peak Hours	Majority of transactions occurred during Evening
📉 Revenue Drop	Some branches had lower revenue in 2023 compared to 2022
⭐ Customer Ratings	Average ratings were between 6–8, showing moderate satisfaction

🚀 How to Run the Project
Clone this repository

bash
Copy code
git clone git@github.com:Seenivasan24/walmart_analysis.git
Open MySQL or any SQL tool
Create a database and import the dataset:

sql
Copy code
CREATE DATABASE walmart_analysis;
USE walmart_analysis;
LOAD DATA INFILE 'walmart-10k-sales-datasets.csv'
INTO TABLE walmart
FIELDS TERMINATED BY ','
IGNORE 1 ROWS;
Run the SQL queries provided above.

View outputs directly in SQL or export data to Excel/Power BI for visualization.

📊 Sample Output (Example)
Branch	Preferred Payment	Total Transactions
A	Cash	340
B	Ewallet	520
C	Credit card	460

Branch	2022 Revenue	2023 Revenue	Drop %
B	1,200,000	950,000	20.8%
C	980,000	780,000	20.4%

🧩 Future Improvements
Add Power BI dashboards for visualization

Integrate Python for data cleaning & analytics

Use Machine Learning models to predict future sales trends

📁 Project Structure
bash
Copy code
walmart_analysis/
│
├── walmart-10k-sales-datasets.csv      # Dataset file
├── walmart_analysis.sql                # SQL scripts
├── README.md                           # Project documentation
└── results/                            # Query outputs (optional)
👨‍💻 Author
Seenivasan
Data Analyst | SQL Enthusiast

📧 Email: –
🌐 GitHub: Seenivasan24
