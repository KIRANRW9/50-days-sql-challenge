-- Day 10: Latest Records and MAX Functions - Solutions

-- Solution 1: Latest Order Date Per Customer (Basic MAX with GROUP BY)
-- Get the latest order date for each customer
SELECT 
    customer_id, 
    MAX(order_date) AS latest_order_date 
FROM Orders 
GROUP BY customer_id
ORDER BY latest_order_date DESC;

-- Solution 2: Latest Order Details with Customer Names
-- Get complete latest order details with customer information using correlated subquery
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.product_name,
    o.order_amount,
    o.order_date as latest_order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date = (
    SELECT MAX(order_date) 
    FROM Orders o2 
    WHERE o2.customer_id = c.customer_id
)
ORDER BY o.order_date DESC;

-- Solution 3: Customer Activity Analysis
-- Analyze customer activity based on latest order date with business segmentation
SELECT 
    c.customer_name,
    c.city,
    MAX(o.order_date) as latest_order_date,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as total_spent,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_since_last_order,
    CASE 
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 30 THEN 'Active'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 90 THEN 'Recent'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 180 THEN 'Inactive'
        ELSE 'Dormant'
    END as customer_status
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NOT NULL
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY latest_order_date DESC;

-- Solution 4: Monthly Latest Order Trends
-- Analyze when customers placed their latest orders by month
SELECT 
    DATE_FORMAT(latest_order_date, '%Y-%m') as latest_order_month,
    DATE_FORMAT(latest_order_date, '%M %Y') as month_name,
    COUNT(*) as customers_with_latest_orders,
    ROUND(AVG(latest_order_amount), 2) as avg_latest_order_amount
FROM (
    SELECT 
        customer_id,
        MAX(order_date) as latest_order_date,
        (SELECT order_amount 
         FROM Orders o2 
         WHERE o2.customer_id = o1.customer_id 
         AND o2.order_date = MAX(o1.order_date)) as latest_order_amount
    FROM Orders o1
    GROUP BY customer_id
) latest_orders
GROUP BY DATE_FORMAT(latest_order_date, '%Y-%m'), DATE_FORMAT(latest_order_date, '%M %Y')
ORDER BY latest_order_month DESC;

-- Solution 5: Customers with No Recent Activity
-- Find customers who haven't ordered in the last 60 days or never ordered
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    c.registration_date,
    COALESCE(DATE_FORMAT(MAX(o.order_date), '%Y-%m-%d'), 'Never Ordered') as latest_order_date,
    CASE 
        WHEN MAX(o.order_date) IS NULL THEN 'Never Ordered'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 60 THEN 'Needs Re-engagement'
        ELSE 'Recent Customer'
    END as engagement_status,
    COALESCE(COUNT(o.order_id), 0) as total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city, c.registration_date
HAVING MAX(o.order_date) IS NULL 
    OR DATEDIFF(CURDATE(), MAX(o.order_date)) > 60
ORDER BY latest_order_date DESC;
