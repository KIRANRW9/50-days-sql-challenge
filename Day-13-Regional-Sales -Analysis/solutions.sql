-- Day 13: Regional Sales Analysis - Solutions

-- Solution 1: Total Revenue and Order Count by Region
-- Get basic regional performance metrics
SELECT 
    region, 
    SUM(total_amount) AS total_revenue, 
    COUNT(*) AS order_count
FROM Orders 
WHERE status = 'Completed'
GROUP BY region
ORDER BY total_revenue DESC;

-- Solution 2: Average Order Value by Region
-- Calculate comprehensive regional spending metrics
SELECT 
    region,
    COUNT(*) as total_orders,
    SUM(total_amount) as total_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value,
    MIN(total_amount) as min_order,
    MAX(total_amount) as max_order
FROM Orders 
WHERE status = 'Completed'
GROUP BY region
ORDER BY avg_order_value DESC;

-- Solution 3: Category Performance Across Regions
-- Analyze product category preferences by region
SELECT 
    region,
    category,
    COUNT(*) as orders_in_category,
    SUM(total_amount) as category_revenue,
    ROUND(AVG(total_amount), 2) as avg_category_order
FROM Orders 
WHERE status = 'Completed'
GROUP BY region, category
ORDER BY region, category_revenue DESC;

-- Solution 4: Regional Performance Comparison
-- Compare regional performance against overall averages
SELECT 
    region,
    total_revenue,
    order_count,
    avg_order_value,
    ROUND(((total_revenue - overall_avg.avg_regional_revenue) / overall_avg.avg_regional_revenue) * 100, 2) as revenue_vs_avg_percent
FROM (
    SELECT 
        region,
        SUM(total_amount) as total_revenue,
        COUNT(*) as order_count,
        ROUND(AVG(total_amount), 2) as avg_order_value
    FROM Orders 
    WHERE status = 'Completed'
    GROUP BY region
) regional_stats
CROSS JOIN (
    SELECT AVG(regional_revenue) as avg_regional_revenue
    FROM (
        SELECT SUM(total_amount) as regional_revenue
        FROM Orders 
        WHERE status = 'Completed'
        GROUP BY region
    ) sub
) overall_avg
ORDER BY revenue_vs_avg_percent DESC;

-- Solution 5: Monthly Regional Trends
-- Track monthly revenue patterns by region
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as order_month,
    region,
    COUNT(*) as monthly_orders,
    SUM(total_amount) as monthly_revenue,
    ROUND(AVG(total_amount), 2) as avg_monthly_order_value
FROM Orders 
WHERE status = 'Completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m'), region
ORDER BY order_month, monthly_revenue DESC;
