-- Day 27: New Customer Revenue Analysis (First-Time Order Revenue)

-- Create Database Schema
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE,
    acquisition_channel VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Query Solutions

-- Query 1: Calculate Total New Customer Revenue 
-- Calculate revenue from first-time orders
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    SUM(o.total_amount) AS new_customer_revenue
FROM Orders o
JOIN first_orders f ON o.customer_id = f.customer_id
WHERE o.order_date = f.first_order_date;

-- Query 2: New Customer Revenue with Count 
-- Get new customer count and average first order value
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    COUNT(DISTINCT o.customer_id) AS new_customers,
    SUM(o.total_amount) AS new_customer_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_first_order_value,
    MIN(o.total_amount) AS min_first_order,
    MAX(o.total_amount) AS max_first_order
FROM Orders o
JOIN first_orders f ON o.customer_id = f.customer_id
WHERE o.order_date = f.first_order_date;

-- Query 3: Monthly New Customer Revenue Trend 
-- Analyze new customer revenue by month
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    DATE_FORMAT(o.order_date, '%M %Y') AS month_name,
    COUNT(DISTINCT o.customer_id) AS new_customers,
    SUM(o.total_amount) AS new_customer_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_first_order_value
FROM Orders o
JOIN first_orders f ON o.customer_id = f.customer_id
WHERE o.order_date = f.first_order_date
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m'), DATE_FORMAT(o.order_date, '%M %Y')
ORDER BY month;

-- Query 4: New vs Repeat Customer Revenue Comparison 
-- Compare revenue from new vs repeat customers
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
),
order_classification AS (
    SELECT 
        o.order_id,
        o.customer_id,
        o.total_amount,
        CASE 
            WHEN o.order_date = f.first_order_date THEN 'New Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM Orders o
    JOIN first_orders f ON o.customer_id = f.customer_id
)
SELECT 
    customer_type,
    COUNT(*) AS order_count,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(total_amount) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    ROUND((SUM(total_amount) / (SELECT SUM(total_amount) FROM Orders) * 100), 2) AS revenue_percentage
FROM order_classification
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Query 5: New Customer Revenue by Acquisition Channel 
-- Analyze new customer revenue by marketing channel
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    c.acquisition_channel,
    COUNT(DISTINCT c.customer_id) AS new_customers,
    SUM(o.total_amount) AS new_customer_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_first_order_value,
    ROUND((SUM(o.total_amount) / (
        SELECT SUM(o2.total_amount) 
        FROM Orders o2 
        JOIN first_orders f2 ON o2.customer_id = f2.customer_id 
        WHERE o2.order_date = f2.first_order_date
    ) * 100), 2) AS revenue_share_pct
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN first_orders f ON o.customer_id = f.customer_id
WHERE o.order_date = f.first_order_date
GROUP BY c.acquisition_channel
ORDER BY new_customer_revenue DESC;
