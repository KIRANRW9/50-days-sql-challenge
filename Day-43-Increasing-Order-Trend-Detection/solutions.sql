-- Day 43: Increasing Order Trend Detection (Customer Upselling Success)
-- Solutions SQL File

-- Create Database Schema
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Query 1: Customers with Increasing Order Amounts (Last 3 Orders)
WITH order_history AS (
    SELECT 
        customer_id, 
        order_id,
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1
    FROM Orders
)
SELECT 
    customer_id, 
    order_id,
    order_date, 
    total_amount,
    amt_t_minus_2 AS order_3_back,
    amt_t_minus_1 AS order_2_back
FROM order_history
WHERE amt_t_minus_2 < amt_t_minus_1 
    AND amt_t_minus_1 < total_amount
ORDER BY customer_id, order_date;

-- Query 2: Increasing Trend with Customer Details
WITH order_history AS (
    SELECT 
        customer_id, 
        order_id,
        product_name,
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS recent_order_rank
    FROM Orders
),
increasing_customers AS (
    SELECT DISTINCT customer_id
    FROM order_history
    WHERE amt_t_minus_2 < amt_t_minus_1 
        AND amt_t_minus_1 < total_amount
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS lifetime_value,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    MAX(o.total_amount) AS highest_order
FROM Customers c
JOIN increasing_customers ic ON c.customer_id = ic.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.city
ORDER BY lifetime_value DESC;

-- Query 3: Growth Rate Analysis for Increasing Customers
WITH order_history AS (
    SELECT 
        customer_id, 
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1
    FROM Orders
)
SELECT 
    customer_id,
    order_date,
    amt_t_minus_2 AS oldest_amount,
    amt_t_minus_1 AS middle_amount,
    total_amount AS latest_amount,
    ROUND((amt_t_minus_1 - amt_t_minus_2) / amt_t_minus_2 * 100, 2) AS growth_1_to_2_pct,
    ROUND((total_amount - amt_t_minus_1) / amt_t_minus_1 * 100, 2) AS growth_2_to_3_pct,
    ROUND((total_amount - amt_t_minus_2) / amt_t_minus_2 * 100, 2) AS total_growth_pct,
    CASE 
        WHEN (total_amount - amt_t_minus_2) / amt_t_minus_2 > 1.0 THEN 'Exceptional Growth (100%+)'
        WHEN (total_amount - amt_t_minus_2) / amt_t_minus_2 > 0.5 THEN 'Strong Growth (50-100%)'
        WHEN (total_amount - amt_t_minus_2) / amt_t_minus_2 > 0.25 THEN 'Good Growth (25-50%)'
        ELSE 'Moderate Growth (<25%)'
    END AS growth_category
FROM order_history
WHERE amt_t_minus_2 < amt_t_minus_1 
    AND amt_t_minus_1 < total_amount
ORDER BY total_growth_pct DESC;

-- Query 4: Streak Detection (Multiple Increasing Sequences)
WITH order_history AS (
    SELECT 
        customer_id, 
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1
    FROM Orders
),
increasing_patterns AS (
    SELECT 
        customer_id,
        order_date,
        total_amount
    FROM order_history
    WHERE amt_t_minus_2 < amt_t_minus_1 
        AND amt_t_minus_1 < total_amount
)
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(*) AS increasing_streak_count,
    MIN(ip.order_date) AS first_increasing_pattern,
    MAX(ip.order_date) AS last_increasing_pattern,
    DATEDIFF(MAX(ip.order_date), MIN(ip.order_date)) AS pattern_span_days,
    SUM(ip.total_amount) AS revenue_from_increasing_orders,
    CASE 
        WHEN COUNT(*) >= 3 THEN 'Consistent Upward Trend'
        WHEN COUNT(*) = 2 THEN 'Emerging Pattern'
        ELSE 'Single Instance'
    END AS trend_strength
FROM Customers c
JOIN increasing_patterns ip ON c.customer_id = ip.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY increasing_streak_count DESC, revenue_from_increasing_orders DESC;

-- Query 5: Comparison with Declining Customers
WITH order_history AS (
    SELECT 
        customer_id, 
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1
    FROM Orders
),
customer_trends AS (
    SELECT 
        customer_id,
        CASE 
            WHEN amt_t_minus_2 < amt_t_minus_1 AND amt_t_minus_1 < total_amount THEN 'Increasing'
            WHEN amt_t_minus_2 > amt_t_minus_1 AND amt_t_minus_1 > total_amount THEN 'Decreasing'
            ELSE 'Mixed/Stable'
        END AS trend_type,
        total_amount
    FROM order_history
    WHERE amt_t_minus_2 IS NOT NULL AND amt_t_minus_1 IS NOT NULL
)
SELECT 
    trend_type,
    COUNT(DISTINCT customer_id) AS customer_count,
    COUNT(*) AS pattern_occurrences,
    SUM(total_amount) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_amount,
    MIN(total_amount) AS min_order,
    MAX(total_amount) AS max_order
FROM customer_trends
GROUP BY trend_type
ORDER BY total_revenue DESC;
