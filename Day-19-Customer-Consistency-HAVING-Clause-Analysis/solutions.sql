-- Day 19: Customer Consistency Analysis with HAVING Clause - Solutions

-- Solution 1: Customers Who Placed Orders Every Month in 2023
SELECT customer_id 
FROM Orders 
WHERE YEAR(order_date) = 2023 
GROUP BY customer_id 
HAVING COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 12;

-- Solution 2: Loyal Customer Details with Complete Order Summary
-- Get comprehensive information about customers who ordered every month
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    c.location,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as total_spent,
    ROUND(AVG(o.order_amount), 2) as avg_order_value,
    MIN(o.order_amount) as min_order,
    MAX(o.order_amount) as max_order,
    MIN(o.order_date) as first_order_2023,
    MAX(o.order_date) as last_order_2023
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023
GROUP BY c.customer_id, c.customer_name, c.customer_tier, c.location
HAVING COUNT(DISTINCT DATE_FORMAT(o.order_date, '%Y-%m')) = 12
ORDER BY total_spent DESC;

-- Solution 3: Customer Consistency Levels Comparison
-- Categorize all customers by their ordering consistency
SELECT 
    consistency_level,
    COUNT(*) as customer_count,
    ROUND(AVG(total_orders), 1) as avg_orders_per_customer,
    ROUND(AVG(total_spent), 2) as avg_total_spent,
    GROUP_CONCAT(customer_id ORDER BY customer_id) as customer_ids
FROM (
    SELECT 
        customer_id,
        COUNT(order_id) as total_orders,
        SUM(order_amount) as total_spent,
        CASE 
            WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 12 THEN 'Every Month (12/12)'
            WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 9 THEN 'Highly Consistent (9-11/12)'
            WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 6 THEN 'Moderately Consistent (6-8/12)'
            WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 3 THEN 'Occasional (3-5/12)'
            ELSE 'Rare (1-2/12)'
        END as consistency_level
    FROM Orders 
    WHERE YEAR(order_date) = 2023 
    GROUP BY customer_id
) customer_analysis
GROUP BY consistency_level
ORDER BY customer_count DESC;

-- Solution 4: Monthly Purchase Pattern Analysis for Loyal Customers
-- Analyze purchasing patterns of customers who bought every month
SELECT 
    DATE_FORMAT(o.order_date, '%m') as month_num,
    DATE_FORMAT(o.order_date, '%M') as month_name,
    COUNT(o.order_id) as orders_count,
    COUNT(DISTINCT o.customer_id) as customers_count,
    SUM(o.order_amount) as month_revenue,
    ROUND(AVG(o.order_amount), 2) as avg_order_value,
    MIN(o.order_amount) as min_order,
    MAX(o.order_amount) as max_order
FROM Orders o
WHERE YEAR(o.order_date) = 2023 
    AND o.customer_id IN (
        SELECT customer_id 
        FROM Orders 
        WHERE YEAR(order_date) = 2023 
        GROUP BY customer_id 
        HAVING COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 12
    )
GROUP BY DATE_FORMAT(o.order_date, '%m'), DATE_FORMAT(o.order_date, '%M')
ORDER BY month_num;

-- Solution 5: Customer Tier Analysis for Different Consistency Levels
-- Analyze relationship between customer tier and purchasing consistency
SELECT 
    c.customer_tier,
    COUNT(*) as total_customers,
    SUM(CASE WHEN months_active = 12 THEN 1 ELSE 0 END) as every_month_customers,
    SUM(CASE WHEN months_active >= 9 THEN 1 ELSE 0 END) as highly_consistent_customers,
    ROUND(AVG(total_orders), 1) as avg_orders,
    ROUND(AVG(total_spent), 2) as avg_total_spent,
    ROUND((SUM(CASE WHEN months_active = 12 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 1) as every_month_percentage
FROM (
    SELECT 
        c.customer_id,
        c.customer_tier,
        COUNT(DISTINCT DATE_FORMAT(o.order_date, '%Y-%m')) as months_active,
        COUNT(o.order_id) as total_orders,
        SUM(o.order_amount) as total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY c.customer_id, c.customer_tier
) customer_stats
GROUP BY c.customer_tier
ORDER BY every_month_percentage DESC;
