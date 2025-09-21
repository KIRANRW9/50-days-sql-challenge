-- Day 12: Top Selling Products Analysis 

-- Solution 1: Most Selling Product by Quantity 
SELECT 
    product_id, 
    SUM(quantity) AS total_qty 
FROM Sales 
GROUP BY product_id 
ORDER BY total_qty DESC 
LIMIT 1;

-- Solution 2: Top 5 Selling Products with Complete Details
-- Get comprehensive information about top selling products
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    SUM(s.quantity) as total_quantity_sold,
    COUNT(s.sale_id) as number_of_sales,
    ROUND(AVG(s.quantity), 2) as avg_quantity_per_sale,
    ROUND(SUM(s.quantity * p.unit_price), 2) as total_revenue
FROM Products p
JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.brand, p.unit_price
ORDER BY total_quantity_sold DESC
LIMIT 5;

-- Solution 3: Best Selling Product by Category using Window Functions
-- Find the top performer in each category
SELECT 
    category,
    product_name,
    brand,
    total_quantity_sold,
    category_rank
FROM (
    SELECT 
        p.category,
        p.product_name,
        p.brand,
        SUM(s.quantity) as total_quantity_sold,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(s.quantity) DESC) as category_rank
    FROM Products p
    JOIN Sales s ON p.product_id = s.product_id
    GROUP BY p.product_id, p.category, p.product_name, p.brand
) ranked_products
WHERE category_rank = 1
ORDER BY total_quantity_sold DESC;

-- Solution 4: Sales Performance Comparison (Top vs Others)
-- Compare the best performer with all other products
SELECT 
    'Top Performer' as performance_tier,
    p.product_name,
    p.category,
    SUM(s.quantity) as total_sold,
    ROUND(SUM(s.quantity * p.unit_price), 2) as total_revenue,
    COUNT(s.sale_id) as number_of_transactions
FROM Products p
JOIN Sales s ON p.product_id = s.product_id
WHERE p.product_id = (
    SELECT product_id 
    FROM Sales 
    GROUP BY product_id 
    ORDER BY SUM(quantity) DESC 
    LIMIT 1
)
GROUP BY p.product_id, p.product_name, p.category
UNION ALL
SELECT 
    'Average Performer' as performance_tier,
    'All Other Products' as product_name,
    'Mixed' as category,
    SUM(s.quantity) as total_sold,
    ROUND(SUM(s.quantity * p.unit_price), 2) as total_revenue,
    COUNT(s.sale_id) as number_of_transactions
FROM Products p
JOIN Sales s ON p.product_id = s.product_id
WHERE p.product_id != (
    SELECT product_id 
    FROM Sales 
    GROUP BY product_id 
    ORDER BY SUM(quantity) DESC 
    LIMIT 1
);

-- Solution 5: Monthly Top Seller Analysis
-- Identify best selling product for each month
SELECT 
    sale_month,
    product_name,
    category,
    monthly_quantity,
    monthly_revenue,
    monthly_rank
FROM (
    SELECT 
        DATE_FORMAT(s.sale_date, '%Y-%m') as sale_month,
        p.product_name,
        p.category,
        SUM(s.quantity) as monthly_quantity,
        ROUND(SUM(s.quantity * p.unit_price), 2) as monthly_revenue,
        RANK() OVER (PARTITION BY DATE_FORMAT(s.sale_date, '%Y-%m') ORDER BY SUM(s.quantity) DESC) as monthly_rank
    FROM Products p
    JOIN Sales s ON p.product_id = s.product_id
    GROUP BY DATE_FORMAT(s.sale_date, '%Y-%m'), p.product_id, p.product_name, p.category, p.unit_price
) monthly_rankings
WHERE monthly_rank = 1
ORDER BY sale_month;
