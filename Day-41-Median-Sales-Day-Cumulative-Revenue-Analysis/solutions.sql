-- Day 41: Median Sales Day Analysis (Cumulative Revenue Breakpoint)
-- Solutions SQL File

-- Create Database Schema
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Query 1: Find Median Sales Day (50% Cumulative Revenue)
WITH daily_revenue AS (
    SELECT 
        order_date, 
        SUM(total_amount) AS daily_rev
    FROM Orders
    GROUP BY order_date
),
cumulative_revenue AS (
    SELECT 
        order_date, 
        daily_rev,
        SUM(daily_rev) OVER (ORDER BY order_date) AS cum_rev,
        SUM(daily_rev) OVER() AS total_rev
    FROM daily_revenue
)
SELECT 
    order_date,
    daily_rev,
    cum_rev,
    total_rev,
    ROUND((cum_rev / total_rev * 100), 2) AS cumulative_pct
FROM cumulative_revenue
WHERE cum_rev >= total_rev / 2
ORDER BY order_date
LIMIT 1;

-- Query 2: Complete Cumulative Revenue Timeline
WITH daily_revenue AS (
    SELECT 
        order_date, 
        SUM(total_amount) AS daily_rev
    FROM Orders
    GROUP BY order_date
),
cumulative_revenue AS (
    SELECT 
        order_date, 
        daily_rev,
        SUM(daily_rev) OVER (ORDER BY order_date) AS cum_rev,
        SUM(daily_rev) OVER() AS total_rev
    FROM daily_revenue
)
SELECT 
    order_date,
    daily_rev,
    cum_rev,
    total_rev,
    ROUND((cum_rev / total_rev * 100), 2) AS cumulative_pct,
    CASE 
        WHEN cum_rev >= total_rev * 0.9 THEN '90%+ Milestone'
        WHEN cum_rev >= total_rev * 0.75 THEN '75-90% Range'
        WHEN cum_rev >= total_rev * 0.5 THEN '50-75% Range (Median Reached)'
        WHEN cum_rev >= total_rev * 0.25 THEN '25-50% Range'
        ELSE 'Below 25%'
    END AS revenue_milestone
FROM cumulative_revenue
ORDER BY order_date;

-- Query 3: Revenue Distribution Analysis
WITH daily_revenue AS (
    SELECT 
        order_date, 
        SUM(total_amount) AS daily_rev
    FROM Orders
    GROUP BY order_date
),
cumulative_revenue AS (
    SELECT 
        order_date, 
        daily_rev,
        SUM(daily_rev) OVER (ORDER BY order_date) AS cum_rev,
        SUM(daily_rev) OVER() AS total_rev
    FROM daily_revenue
),
median_day AS (
    SELECT MIN(order_date) as median_date
    FROM cumulative_revenue
    WHERE cum_rev >= total_rev / 2
)
SELECT 
    CASE 
        WHEN cr.order_date < md.median_date THEN 'Before Median Day'
        WHEN cr.order_date = md.median_date THEN 'Median Day'
        ELSE 'After Median Day'
    END AS period,
    COUNT(DISTINCT cr.order_date) AS business_days,
    COUNT(*) AS order_count,
    SUM(cr.daily_rev) AS total_revenue,
    ROUND(AVG(cr.daily_rev), 2) AS avg_daily_revenue,
    ROUND((SUM(cr.daily_rev) / cr.total_rev * 100), 2) AS pct_of_total
FROM cumulative_revenue cr
CROSS JOIN median_day md
GROUP BY 
    CASE 
        WHEN cr.order_date < md.median_date THEN 'Before Median Day'
        WHEN cr.order_date = md.median_date THEN 'Median Day'
        ELSE 'After Median Day'
    END,
    cr.total_rev
ORDER BY 
    CASE 
        WHEN period = 'Before Median Day' THEN 1
        WHEN period = 'Median Day' THEN 2
        ELSE 3
    END;

-- Query 4: Monthly Median Day Comparison
WITH daily_revenue AS (
    SELECT 
        order_date,
        YEAR(order_date) AS year,
        MONTH(order_date) AS month,
        MONTHNAME(order_date) AS month_name,
        SUM(total_amount) AS daily_rev
    FROM Orders
    GROUP BY order_date, YEAR(order_date), MONTH(order_date), MONTHNAME(order_date)
),
monthly_cumulative AS (
    SELECT 
        year,
        month,
        month_name,
        order_date,
        daily_rev,
        SUM(daily_rev) OVER (PARTITION BY year, month ORDER BY order_date) AS cum_rev,
        SUM(daily_rev) OVER (PARTITION BY year, month) AS monthly_total
    FROM daily_revenue
),
median_days AS (
    SELECT 
        year,
        month,
        month_name,
        MIN(order_date) AS median_date,
        MAX(cum_rev) AS month_revenue
    FROM monthly_cumulative
    WHERE cum_rev >= monthly_total / 2
    GROUP BY year, month, month_name
)
SELECT 
    month,
    month_name,
    median_date,
    DAY(median_date) AS median_day_of_month,
    month_revenue,
    CASE 
        WHEN DAY(median_date) <= 10 THEN 'Early Month (1-10)'
        WHEN DAY(median_date) <= 20 THEN 'Mid Month (11-20)'
        ELSE 'Late Month (21-31)'
    END AS month_period
FROM median_days
ORDER BY month;

-- Query 5: Median Day with Business Insights
WITH daily_revenue AS (
    SELECT 
        order_date, 
        SUM(total_amount) AS daily_rev,
        COUNT(*) AS daily_orders
    FROM Orders
    GROUP BY order_date
),
cumulative_revenue AS (
    SELECT 
        order_date, 
        daily_rev,
        daily_orders,
        SUM(daily_rev) OVER (ORDER BY order_date) AS cum_rev,
        SUM(daily_orders) OVER (ORDER BY order_date) AS cum_orders,
        SUM(daily_rev) OVER() AS total_rev,
        SUM(daily_orders) OVER() AS total_orders,
        ROW_NUMBER() OVER (ORDER BY order_date) AS day_number
    FROM daily_revenue
),
median_info AS (
    SELECT 
        order_date AS median_date,
        daily_rev,
        cum_rev,
        total_rev,
        cum_orders,
        total_orders,
        day_number,
        COUNT(*) OVER() AS total_business_days
    FROM cumulative_revenue
    WHERE cum_rev >= total_rev / 2
    ORDER BY order_date
    LIMIT 1
)
SELECT 
    median_date,
    day_number AS days_to_reach_50pct,
    total_business_days,
    ROUND((day_number * 100.0 / total_business_days), 2) AS pct_of_timeline,
    daily_rev AS revenue_on_median_day,
    cum_rev AS cumulative_revenue,
    total_rev AS total_revenue,
    ROUND((cum_rev / total_rev * 100), 2) AS cumulative_pct,
    cum_orders AS orders_processed,
    total_orders,
    ROUND((cum_orders * 100.0 / total_orders), 2) AS pct_orders_completed,
    ROUND((cum_rev / day_number), 2) AS avg_daily_rev_to_median,
    ROUND(((total_rev - cum_rev) / (total_business_days - day_number)), 2) AS avg_daily_rev_after_median
FROM median_info;
