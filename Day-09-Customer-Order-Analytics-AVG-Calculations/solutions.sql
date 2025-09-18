-- Day 09: Customer Order Analytics and Average Calculations - Solutions

-- Solution 1: Average Order Value Per Customer (Basic AVG with GROUP BY)
SELECT 
    customer_id, 
    AVG(total_amount) AS avg_order_value 
FROM Orders 
GROUP BY customer_id
ORDER BY avg_order_value DESC;

-- Solution 2: Customer Order Summary with Names
-- Get customer names with their complete order statistics
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    MIN(o.total_amount) as min_order,
    MAX(o.total_amount) as max_order
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY avg_order_value DESC;

-- Solution 3: Customer Segmentation by Average Order Value
-- Segment customers based on their average order value using CASE
SELECT 
    c.customer_name,
    c.city,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    COUNT(o.order_id) as total_orders,
    CASE 
        WHEN AVG(o.total_amount) >= 100000 THEN 'Premium'
        WHEN AVG(o.total_amount) >= 25000 THEN 'Gold'
        WHEN AVG(o.total_amount) >= 5000 THEN 'Silver'
        ELSE 'Bronze'
    END as customer_segment
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY avg_order_value DESC;

-- Solution 4: Category-wise Average Order Analysis
-- Analyze average order values by product category
SELECT 
    o.category,
    COUNT(o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    SUM(o.total_amount) as total_revenue,
    MIN(o.total_amount) as min_order,
    MAX(o.total_amount) as max_order
FROM Orders o
GROUP BY o.category
ORDER BY avg_order_value DESC;

-- Solution 5: High-Value Customer Analysis
-- Find customers with above-average order values using HAVING and subquery
SELECT 
    c.customer_name,
    c.city,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING AVG(o.total_amount) > (
    SELECT AVG(total_amount) 
    FROM Orders
)
ORDER BY avg_order_value DESC;
