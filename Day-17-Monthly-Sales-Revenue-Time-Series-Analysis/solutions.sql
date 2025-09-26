-- Monthly Sales Analysis with DATE_FORMAT Functions
-- Solutions SQL File

-- Create Database Schema
-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10,2),
    category VARCHAR(50),
    region VARCHAR(20),
    sales_rep_id INT
);

-- Query Solutions

-- Query 1: Monthly Sales Revenue and Order Count 
-- Get monthly sales revenue and order count 
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS total_revenue,
    COUNT(order_id) AS order_count
FROM Orders 
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- Query 2: Monthly Trends with Growth Analysis 
-- Analyze monthly trends with average order value and growth metrics
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    DATE_FORMAT(order_date, '%M %Y') as month_name,
    COUNT(order_id) as order_count,
    SUM(total_amount) as total_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value,
    MIN(total_amount) as min_order,
    MAX(total_amount) as max_order,
    COUNT(DISTINCT customer_id) as unique_customers
FROM Orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m'), DATE_FORMAT(order_date, '%M %Y')
ORDER BY month;

-- Query 3: Category Performance by Month 
-- Analyze category performance across months
SELECT 
    category,
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(order_id) as orders,
    SUM(total_amount) as category_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value
FROM Orders
GROUP BY category, DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month, category_revenue DESC;

-- Query 4: Region-wise Monthly Performance 
-- Compare regional performance across months
SELECT 
    region,
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(order_id) as orders,
    SUM(total_amount) as revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value,
    ROUND((SUM(total_amount) / (SELECT SUM(total_amount) FROM Orders o2 WHERE DATE_FORMAT(o2.order_date, '%Y-%m') = DATE_FORMAT(order_date, '%Y-%m')) * 100), 1) as revenue_share_pct
FROM Orders
GROUP BY region, DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month, revenue DESC;

-- Query 5: Sales Representative Performance by Month 
-- Analyze sales representative performance over months
SELECT 
    sales_rep_id,
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(order_id) as orders_closed,
    SUM(total_amount) as total_sales,
    ROUND(AVG(total_amount), 2) as avg_deal_size,
    RANK() OVER (PARTITION BY DATE_FORMAT(order_date, '%Y-%m') ORDER BY SUM(total_amount) DESC) as monthly_rank
FROM Orders
GROUP BY sales_rep_id, DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month, total_sales DESC;
