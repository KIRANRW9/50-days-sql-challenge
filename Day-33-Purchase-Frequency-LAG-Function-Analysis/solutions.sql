-- Day 33: Purchase Frequency Analysis (Average Time Between Orders)
-- Solutions SQL File

-- Create Database Schema
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    order_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Query Solutions

-- Query 1: Average Days Between Purchases per Customer 
-- Calculate average time gap between orders for each customer (MySQL version)
WITH cte AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date
    FROM Orders
)
SELECT 
    customer_id, 
    AVG(DATEDIFF(order_date, prev_date)) AS avg_gap_days
FROM cte
WHERE prev_date IS NOT NULL
GROUP BY customer_id
ORDER BY avg_gap_days;

-- Query 2: Purchase Frequency with Customer Details 
-- Get detailed purchase frequency analysis with customer information
WITH order_gaps AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_gap
    FROM Orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(og.days_gap), 1) AS avg_days_between_orders,
    MIN(og.days_gap) AS min_gap_days,
    MAX(og.days_gap) AS max_gap_days,
    SUM(o.order_amount) AS lifetime_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN order_gaps og ON c.customer_id = og.customer_id AND og.prev_date IS NOT NULL
GROUP BY c.customer_id, c.customer_name, c.city
HAVING COUNT(o.order_id) > 1
ORDER BY avg_days_between_orders;

-- Query 3: Customer Segmentation by Purchase Frequency 
-- Segment customers based on their purchase frequency
WITH order_gaps AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date
    FROM Orders
),
customer_frequency AS (
    SELECT 
        customer_id,
        AVG(DATEDIFF(order_date, prev_date)) AS avg_gap_days
    FROM order_gaps
    WHERE prev_date IS NOT NULL
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(cf.avg_gap_days, 1) AS avg_days_between_orders,
    CASE 
        WHEN cf.avg_gap_days <= 30 THEN 'High Frequency (<=30 days)'
        WHEN cf.avg_gap_days <= 45 THEN 'Medium Frequency (31-45 days)'
        WHEN cf.avg_gap_days <= 60 THEN 'Low Frequency (46-60 days)'
        ELSE 'Infrequent (60+ days)'
    END AS frequency_segment,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS lifetime_value
FROM Customers c
JOIN customer_frequency cf ON c.customer_id = cf.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, cf.avg_gap_days
ORDER BY cf.avg_gap_days;

-- Query 4: Predict Next Purchase Date 
-- Predict when customers are likely to make their next purchase
WITH order_gaps AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date
    FROM Orders
),
customer_pattern AS (
    SELECT 
        customer_id,
        MAX(order_date) AS last_order_date,
        ROUND(AVG(DATEDIFF(order_date, prev_date)), 0) AS avg_gap_days,
        COUNT(*) AS order_count
    FROM order_gaps
    WHERE prev_date IS NOT NULL
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
)
SELECT 
    c.customer_id,
    c.customer_name,
    cp.last_order_date,
    cp.avg_gap_days,
    DATE_ADD(cp.last_order_date, INTERVAL cp.avg_gap_days DAY) AS predicted_next_order,
    DATEDIFF(CURDATE(), cp.last_order_date) AS days_since_last_order,
    CASE 
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) > cp.avg_gap_days * 1.5 THEN 'Overdue - High Risk'
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) > cp.avg_gap_days THEN 'Overdue - At Risk'
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) >= cp.avg_gap_days * 0.8 THEN 'Due Soon'
        ELSE 'On Track'
    END AS purchase_status
FROM Customers c
JOIN customer_pattern cp ON c.customer_id = cp.customer_id
ORDER BY 
    CASE 
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) > cp.avg_gap_days * 1.5 THEN 1
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) > cp.avg_gap_days THEN 2
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) >= cp.avg_gap_days * 0.8 THEN 3
        ELSE 4
    END;

-- Query 5: Purchase Frequency Trend Over Time 
-- Analyze if customers are buying more or less frequently over time
WITH order_gaps AS (
    SELECT 
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_gap,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence
    FROM Orders
),
trend_analysis AS (
    SELECT 
        customer_id,
        AVG(CASE WHEN order_sequence <= 3 THEN days_gap END) AS early_avg_gap,
        AVG(CASE WHEN order_sequence > 3 THEN days_gap END) AS recent_avg_gap,
        COUNT(*) AS total_order_gaps
    FROM order_gaps
    WHERE prev_date IS NOT NULL
    GROUP BY customer_id
    HAVING COUNT(*) >= 3
)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(ta.early_avg_gap, 1) AS early_avg_days,
    ROUND(ta.recent_avg_gap, 1) AS recent_avg_days,
    ROUND(ta.recent_avg_gap - ta.early_avg_gap, 1) AS trend_change,
    CASE 
        WHEN ta.recent_avg_gap < ta.early_avg_gap THEN 'Increasing Frequency ⬆'
        WHEN ta.recent_avg_gap > ta.early_avg_gap THEN 'Decreasing Frequency ⬇'
        ELSE 'Stable Frequency →'
    END AS frequency_trend,
    COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN trend_analysis ta ON c.customer_id = ta.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, ta.early_avg_gap, ta.recent_avg_gap
ORDER BY trend_change DESC;
