-- Day 14: Advanced Customer Order Analysis (Subqueries & HAVING Clause)
-- Query Solutions

-- Query 1: Count Customers with More Than 5 Orders
SELECT COUNT(*) AS customer_count
FROM (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) > 5
) AS subquery;

-- Query 2: Identify High-Volume Customers (More Than 5 Orders)
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_spent,
    ROUND(AVG(o.order_amount), 2) AS avg_order_value,
    MIN(o.order_date) AS first_order,
    MAX(o.order_date) AS last_order
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC, total_spent DESC;

-- Query 3: Customer Order Distribution Analysis
SELECT 
    CASE 
        WHEN order_count > 10 THEN 'Super Active (10+)'
        WHEN order_count > 5 THEN 'High Volume (6-10)'
        WHEN order_count > 2 THEN 'Medium Volume (3-5)'
        WHEN order_count > 0 THEN 'Low Volume (1-2)'
        ELSE 'No Orders'
    END AS customer_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(order_count), 2) AS avg_orders,
    ROUND(AVG(total_spent), 2) AS avg_spent
FROM (
    SELECT 
        c.customer_id,
        COUNT(o.order_id) AS order_count,
        COALESCE(SUM(o.order_amount), 0) AS total_spent
    FROM Customers c
    LEFT JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) AS customer_stats
GROUP BY 
    CASE 
        WHEN order_count > 10 THEN 'Super Active (10+)'
        WHEN order_count > 5 THEN 'High Volume (6-10)'
        WHEN order_count > 2 THEN 'Medium Volume (3-5)'
        WHEN order_count > 0 THEN 'Low Volume (1-2)'
        ELSE 'No Orders'
    END
ORDER BY avg_orders DESC;

-- Query 4: Monthly High-Volume Customer Analysis
SELECT 
    MONTHNAME(o.order_date) AS order_month,
    MONTH(o.order_date) AS month_number,
    COUNT(DISTINCT CASE WHEN monthly_orders.order_count > 5 THEN o.customer_id END) AS high_volume_customers,
    COUNT(DISTINCT o.customer_id) AS total_active_customers,
    ROUND(
        COUNT(DISTINCT CASE WHEN monthly_orders.order_count > 5 THEN o.customer_id END) * 100.0 / 
        COUNT(DISTINCT o.customer_id), 2
    ) AS high_volume_percentage
FROM Orders o
INNER JOIN (
    SELECT 
        customer_id, 
        MONTH(order_date) AS order_month,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id, MONTH(order_date)
) AS monthly_orders ON o.customer_id = monthly_orders.customer_id 
    AND MONTH(o.order_date) = monthly_orders.order_month
GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY month_number;

-- Query 5: Comparative Analysis - High Volume vs Regular Customers
SELECT 
    'High Volume (5+ orders)' AS customer_type,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    SUM(order_stats.total_orders) AS total_orders,
    ROUND(AVG(order_stats.total_orders), 2) AS avg_orders_per_customer,
    SUM(order_stats.total_spent) AS total_revenue,
    ROUND(AVG(order_stats.total_spent), 2) AS avg_spent_per_customer
FROM Customers c
INNER JOIN (
    SELECT 
        customer_id,
        COUNT(*) AS total_orders,
        SUM(order_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) > 5
) AS order_stats ON c.customer_id = order_stats.customer_id

UNION ALL

SELECT 
    'Regular (1-5 orders)' AS customer_type,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    SUM(order_stats.total_orders) AS total_orders,
    ROUND(AVG(order_stats.total_orders), 2) AS avg_orders_per_customer,
    SUM(order_stats.total_spent) AS total_revenue,
    ROUND(AVG(order_stats.total_spent), 2) AS avg_spent_per_customer
FROM Customers c
INNER JOIN (
    SELECT 
        customer_id,
        COUNT(*) AS total_orders,
        SUM(order_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) <= 5
) AS order_stats ON c.customer_id = order_stats.customer_id;
