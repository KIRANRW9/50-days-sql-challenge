
-- Query Solutions

-- Query 1: Customers with Above-Average Orders 
-- Find customers who ordered more than the average (using CTE)
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT * 
FROM customer_orders
WHERE order_count > (SELECT AVG(order_count) FROM customer_orders);

-- Query 2: Above-Average Customers with Details 
-- Get detailed information about high-frequency customers
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    c.customer_tier,
    co.order_count,
    ROUND((SELECT AVG(order_count) FROM customer_orders), 2) as avg_orders,
    co.order_count - ROUND((SELECT AVG(order_count) FROM customer_orders), 2) as orders_above_avg
FROM Customers c
JOIN customer_orders co ON c.customer_id = co.customer_id
WHERE co.order_count > (SELECT AVG(order_count) FROM customer_orders)
ORDER BY co.order_count DESC;

-- Query 3: Customer Segmentation by Order Frequency 
-- Segment customers into frequency tiers
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
),
avg_calc AS (
    SELECT AVG(order_count) as avg_orders FROM customer_orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    co.order_count,
    a.avg_orders,
    CASE 
        WHEN co.order_count >= a.avg_orders * 2 THEN 'Power User'
        WHEN co.order_count > a.avg_orders THEN 'Above Average'
        WHEN co.order_count = ROUND(a.avg_orders) THEN 'Average'
        ELSE 'Below Average'
    END as frequency_segment,
    SUM(o.order_amount) as total_spent
FROM Customers c
JOIN customer_orders co ON c.customer_id = co.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
CROSS JOIN avg_calc a
GROUP BY c.customer_id, c.customer_name, c.customer_tier, co.order_count, a.avg_orders
ORDER BY co.order_count DESC;

-- Query 4: Revenue Impact of Above-Average Customers 
-- Analyze revenue contribution of high-frequency customers
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        co.order_count,
        SUM(o.order_amount) as total_revenue,
        CASE 
            WHEN co.order_count > (SELECT AVG(order_count) FROM customer_orders) 
            THEN 'Above Average'
            ELSE 'Below Average'
        END as frequency_group
    FROM Customers c
    JOIN customer_orders co ON c.customer_id = co.customer_id
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, co.order_count
)
SELECT 
    frequency_group,
    COUNT(*) as customer_count,
    SUM(total_revenue) as total_revenue,
    ROUND(AVG(total_revenue), 2) as avg_revenue_per_customer,
    ROUND(AVG(order_count), 2) as avg_orders,
    ROUND((SUM(total_revenue) / (SELECT SUM(total_revenue) FROM customer_revenue) * 100), 2) as revenue_percentage
FROM customer_revenue
GROUP BY frequency_group
ORDER BY total_revenue DESC;

-- Query 5: Trend Analysis for Above-Average Customers 
-- Identify above-average customers and their ordering trends
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
),
above_avg_customers AS (
    SELECT customer_id, order_count
    FROM customer_orders
    WHERE order_count > (SELECT AVG(order_count) FROM customer_orders)
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    aac.order_count,
    MIN(o.order_date) as first_order,
    MAX(o.order_date) as last_order,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) as customer_lifespan_days,
    ROUND(aac.order_count / (DATEDIFF(MAX(o.order_date), MIN(o.order_date)) + 1) * 30, 2) as orders_per_month,
    SUM(o.order_amount) as lifetime_value,
    ROUND(SUM(o.order_amount) / aac.order_count, 2) as avg_order_value
FROM Customers c
JOIN above_avg_customers aac ON c.customer_id = aac.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_tier, aac.order_count
ORDER BY orders_per_month DESC;
