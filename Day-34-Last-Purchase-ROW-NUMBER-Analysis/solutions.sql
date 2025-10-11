-- Day 34: Last Purchase Analysis (Most Recent Order per Customer)
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
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Query Solutions

-- Query 1: Get Last Purchase for Each Customer 
-- Show last purchase for each customer with order amount (using ROW_NUMBER)
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    customer_id, 
    order_id, 
    product_name,
    total_amount,
    order_date
FROM ranked_orders
WHERE rn = 1
ORDER BY customer_id;

-- Query 2: Last Purchase with Customer Details 
-- Get last purchase with comprehensive customer and order information
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        status,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    ro.order_id,
    ro.product_name,
    ro.total_amount,
    ro.order_date,
    ro.status,
    DATEDIFF(CURDATE(), ro.order_date) AS days_since_last_purchase
FROM Customers c
JOIN ranked_orders ro ON c.customer_id = ro.customer_id
WHERE ro.rn = 1
ORDER BY ro.order_date DESC;

-- Query 3: Last Purchase by Product Category 
-- Analyze last purchases by product categories
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        CASE 
            WHEN product_name IN ('iPhone 15 Pro', 'MacBook Pro', 'iPad Air', 'AirPods Pro', 'Apple Watch', 'Magic Keyboard', 'HomePod') THEN 'Electronics'
            WHEN product_name IN ('Samsung TV 65"', 'Washing Machine', 'Refrigerator', 'Microwave Oven', 'Kitchen Appliances') THEN 'Appliances'
            WHEN product_name IN ('Dell XPS 15', '4K Monitor', 'Mechanical Keyboard', 'Gaming Mouse', 'Webcam HD', 'Desk Lamp', 'External SSD 1TB', 'USB Hub', 'Gaming Console', 'Controller', 'Games Bundle') THEN 'Computer Accessories'
            WHEN product_name IN ('Cricket Bat', 'Football', 'Tennis Racket', 'Golf Clubs', 'Gym Equipment', 'Bicycle', 'Running Shoes', 'Fitness Tracker', 'Protein Supplements') THEN 'Sports & Fitness'
            WHEN product_name IN ('Sofa Set', 'Dining Table', 'Coffee Table', 'Office Chair', 'Office Desk') THEN 'Furniture'
            WHEN product_name IN ('Book Collection', 'Reading Lamp') THEN 'Books & Accessories'
            WHEN product_name IN ('Smart Watch') THEN 'Wearables'
            ELSE 'Other'
        END AS category,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    category,
    COUNT(*) AS customers_with_category,
    SUM(total_amount) AS total_amount,
    ROUND(AVG(total_amount), 2) AS avg_order_amount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ranked_orders WHERE rn = 1), 2) AS percentage
FROM ranked_orders
WHERE rn = 1
GROUP BY category
ORDER BY total_amount DESC;

-- Query 4: Last Purchase Status and Follow-up 
-- Track last purchase status for follow-up communications
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        status,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    ro.order_id,
    ro.product_name,
    ro.total_amount,
    ro.order_date,
    ro.status,
    DATEDIFF(CURDATE(), ro.order_date) AS days_since_order,
    CASE 
        WHEN ro.status = 'Delivered' AND DATEDIFF(CURDATE(), ro.order_date) <= 7 THEN 'Send Review Request'
        WHEN ro.status = 'Delivered' AND DATEDIFF(CURDATE(), ro.order_date) <= 30 THEN 'Check Satisfaction'
        WHEN ro.status = 'Delivered' AND DATEDIFF(CURDATE(), ro.order_date) <= 60 THEN 'Upsell Opportunity'
        WHEN ro.status = 'In Transit' THEN 'Waiting for Delivery'
        WHEN ro.status = 'Processing' THEN 'Order Processing'
        ELSE 'Re-engagement Campaign'
    END AS action_recommended
FROM Customers c
JOIN ranked_orders ro ON c.customer_id = ro.customer_id
WHERE ro.rn = 1
ORDER BY DATEDIFF(CURDATE(), ro.order_date) DESC;

-- Query 5: Last Purchase Comparison (Previous vs Current) 
-- Compare last two purchases for each customer to identify patterns
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    MAX(CASE WHEN ro.rn = 1 THEN ro.product_name END) AS last_product,
    MAX(CASE WHEN ro.rn = 1 THEN ro.total_amount END) AS last_amount,
    MAX(CASE WHEN ro.rn = 1 THEN ro.order_date END) AS last_date,
    MAX(CASE WHEN ro.rn = 2 THEN ro.product_name END) AS previous_product,
    MAX(CASE WHEN ro.rn = 2 THEN ro.total_amount END) AS previous_amount,
    MAX(CASE WHEN ro.rn = 2 THEN ro.order_date END) AS previous_date,
    CASE 
        WHEN MAX(CASE WHEN ro.rn = 1 THEN ro.total_amount END) > MAX(CASE WHEN ro.rn = 2 THEN ro.total_amount END) THEN 'Increasing Spend'
        WHEN MAX(CASE WHEN ro.rn = 1 THEN ro.total_amount END) < MAX(CASE WHEN ro.rn = 2 THEN ro.total_amount END) THEN 'Decreasing Spend'
        ELSE 'Similar Spend'
    END AS spending_trend,
    COUNT(*) AS total_orders
FROM Customers c
LEFT JOIN ranked_orders ro ON c.customer_id = ro.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(*) >= 2
ORDER BY c.customer_id;
