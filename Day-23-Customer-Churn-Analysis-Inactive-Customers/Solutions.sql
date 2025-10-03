
-- QUERY 1: Find Churned Customers (No Orders in Last 6 Months)
-- Find customers with no orders in last 6 months
SELECT customer_id
FROM Orders
GROUP BY customer_id
HAVING MAX(order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);

-- QUERY 2: Churned Customers with Details
-- Get detailed information about churned customers
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.customer_tier,
    c.city,
    MAX(o.order_date) as last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_since_last_order,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as lifetime_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.customer_tier, c.city
HAVING MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY lifetime_value DESC;

-- QUERY 3: Customer Status Classification
-- Classify all customers by activity status
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    MAX(o.order_date) as last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_inactive,
    CASE 
        WHEN MAX(o.order_date) >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) THEN 'Active'
        WHEN MAX(o.order_date) >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH) THEN 'At Risk'
        WHEN MAX(o.order_date) >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) THEN 'Dormant'
        ELSE 'Churned'
    END as customer_status,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as lifetime_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_tier
ORDER BY days_inactive DESC;

-- QUERY 4: Churn Rate Analysis by Customer Tier
-- Calculate churn rate by customer tier
WITH CustomerStatus AS (
    SELECT 
        c.customer_id,
        c.customer_tier,
        CASE 
            WHEN MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH) THEN 1
            ELSE 0
        END as is_churned
    FROM Customers c
    LEFT JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_tier
)
SELECT 
    customer_tier,
    COUNT(*) as total_customers,
    SUM(is_churned) as churned_customers,
    COUNT(*) - SUM(is_churned) as active_customers,
    ROUND((SUM(is_churned) * 100.0 / COUNT(*)), 2) as churn_rate_pct
FROM CustomerStatus
GROUP BY customer_tier
ORDER BY churn_rate_pct DESC;

-- QUERY 5: High-Value Churned Customers for Win-Back Campaign
-- Identify high-value churned customers for targeted campaigns
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.customer_tier,
    c.city,
    MAX(o.order_date) as last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_since_last_order,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as lifetime_value,
    ROUND(SUM(o.order_amount) / COUNT(o.order_id), 2) as avg_order_value,
    CASE 
        WHEN SUM(o.order_amount) >= 300000 THEN 'High Priority'
        WHEN SUM(o.order_amount) >= 150000 THEN 'Medium Priority'
        ELSE 'Low Priority'
    END as winback_priority
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.customer_tier, c.city
HAVING MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    AND SUM(o.order_amount) >= 150000
ORDER BY lifetime_value DESC, days_since_last_order;
