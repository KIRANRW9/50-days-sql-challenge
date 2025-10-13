-- Day 35: Year-Over-Year Revenue Growth Analysis
-- Goal: Analyze revenue trends, calculate growth, and identify performance patterns across years.

------------------------------------------------------------
-- Create Orders table
------------------------------------------------------------
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

------------------------------------------------------------
-- Query 1: Calculate Year-Over-Year Revenue Growth
-- Interview Probability: 95%
------------------------------------------------------------
SELECT 
    YEAR(order_date) AS year,
    SUM(total_amount) AS revenue,
    LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) AS previous_year_revenue,
    SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) AS yoy_growth
FROM Orders
GROUP BY YEAR(order_date)
ORDER BY year;

------------------------------------------------------------
-- Query 2: YoY Growth with Percentage and Growth Category
-- Interview Probability: 90%
------------------------------------------------------------
SELECT 
    YEAR(order_date) AS year,
    SUM(total_amount) AS revenue,
    LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) AS previous_year_revenue,
    SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) AS yoy_growth,
    ROUND(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
        LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) * 100, 2
    ) AS yoy_growth_pct,
    CASE 
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) > 0.25 THEN 'Excellent (25%+)'
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) > 0.15 THEN 'Strong (15-25%)'
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) > 0.05 THEN 'Moderate (5-15%)'
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) > 0 THEN 'Low (0-5%)'
        WHEN (SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date))) / 
             LAG(SUM(total_amount)) OVER (ORDER BY YEAR(order_date)) < 0 THEN 'Decline'
        ELSE 'Flat'
    END AS growth_category
FROM Orders
GROUP BY YEAR(order_date)
ORDER BY year;

------------------------------------------------------------
-- Query 3: Monthly YoY Comparison
-- Interview Probability: 85%
------------------------------------------------------------
SELECT 
    MONTH(order_date) AS month,
    MONTHNAME(order_date) AS month_name,
    YEAR(order_date) AS year,
    SUM(total_amount) AS revenue
FROM Orders
GROUP BY YEAR(order_date), MONTH(order_date), MONTHNAME(order_date)
ORDER BY month, year;

------------------------------------------------------------
-- Query 4: Quarter-wise YoY Growth
-- Interview Probability: 80%
------------------------------------------------------------
SELECT 
    YEAR(order_date) AS year,
    QUARTER(order_date) AS quarter,
    CONCAT('Q', QUARTER(order_date), '-', YEAR(order_date)) AS quarter_label,
    SUM(total_amount) AS revenue,
    LAG(SUM(total_amount)) OVER (PARTITION BY QUARTER(order_date) ORDER BY YEAR(order_date)) AS previous_year_q_revenue,
    SUM(total_amount) - LAG(SUM(total_amount)) OVER (PARTITION BY QUARTER(order_date) ORDER BY YEAR(order_date)) AS q_yoy_growth,
    ROUND(
        (SUM(total_amount) - LAG(SUM(total_amount)) OVER (PARTITION BY QUARTER(order_date) ORDER BY YEAR(order_date))) / 
        LAG(SUM(total_amount)) OVER (PARTITION BY QUARTER(order_date) ORDER BY YEAR(order_date)) * 100, 2
    ) AS q_yoy_growth_pct
FROM Orders
GROUP BY YEAR(order_date), QUARTER(order_date)
ORDER BY quarter, year;

------------------------------------------------------------
-- Query 5: Cumulative YoY Analysis
-- Interview Probability: 75%
------------------------------------------------------------
WITH yearly_revenue AS (
    SELECT 
        YEAR(order_date) AS year,
        SUM(total_amount) AS annual_revenue,
        COUNT(DISTINCT DATE(order_date)) AS business_days,
        COUNT(*) AS total_orders
    FROM Orders
    GROUP BY YEAR(order_date)
)
SELECT 
    year,
    annual_revenue,
    business_days,
    total_orders,
    LAG(annual_revenue) OVER (ORDER BY year) AS previous_year_revenue,
    annual_revenue - LAG(annual_revenue) OVER (ORDER BY year) AS yoy_growth,
    ROUND(
        (annual_revenue - LAG(annual_revenue) OVER (ORDER BY year)) / 
        LAG(annual_revenue) OVER (ORDER BY year) * 100, 2
    ) AS yoy_growth_pct,
    ROUND(annual_revenue / business_days, 2) AS avg_daily_revenue,
    ROUND(annual_revenue / total_orders, 2) AS avg_order_value,
    CASE 
        WHEN year = (SELECT MAX(year) FROM yearly_revenue) THEN 'Current Year'
        WHEN year = (SELECT MAX(year) - 1 FROM yearly_revenue) THEN 'Previous Year'
        ELSE 'Historical'
    END AS year_category
FROM yearly_revenue
ORDER BY year DESC;

