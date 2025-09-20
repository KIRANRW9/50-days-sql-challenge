-- Day 11: Finding Missing Records with LEFT JOIN - Solutions

-- Solution 1: Products Never Sold (Basic LEFT JOIN with IS NULL)
-- Your original query - Find products that have never been sold
SELECT 
    p.product_id 
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL;

-- Solution 2: Never Sold Products with Complete Details
-- Get comprehensive information about products that have never been sold
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    p.stock_quantity,
    p.launch_date,
    DATEDIFF(CURDATE(), p.launch_date) as days_since_launch,
    (p.unit_price * p.stock_quantity) as inventory_value
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL
ORDER BY p.unit_price DESC;

-- Solution 3: Category-wise Never Sold Analysis
-- Analyze never sold products by category with aggregations
SELECT 
    p.category,
    COUNT(*) as never_sold_count,
    SUM(p.stock_quantity) as total_unsold_inventory,
    SUM(p.unit_price * p.stock_quantity) as inventory_value,
    ROUND(AVG(p.unit_price), 2) as avg_price,
    MIN(p.launch_date) as earliest_launch,
    MAX(p.launch_date) as latest_launch
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL
GROUP BY p.category
ORDER BY inventory_value DESC;

-- Solution 4: Sold vs Never Sold Comparison using UNION
-- Compare characteristics of sold vs never sold products
SELECT 
    'Sold Products' as product_status,
    COUNT(DISTINCT p.product_id) as product_count,
    COUNT(DISTINCT p.category) as categories,
    ROUND(AVG(p.unit_price), 2) as avg_price,
    SUM(p.stock_quantity) as total_inventory,
    ROUND(AVG(p.unit_price * p.stock_quantity), 2) as avg_inventory_value
FROM Products p 
INNER JOIN Sales s ON p.product_id = s.product_id
UNION ALL
SELECT 
    'Never Sold Products' as product_status,
    COUNT(DISTINCT p.product_id) as product_count,
    COUNT(DISTINCT p.category) as categories,
    ROUND(AVG(p.unit_price), 2) as avg_price,
    SUM(p.stock_quantity) as total_inventory,
    ROUND(AVG(p.unit_price * p.stock_quantity), 2) as avg_inventory_value
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL;

-- Solution 5: High-Value Never Sold Products with Business Priority
-- Identify high-value products requiring immediate attention
SELECT 
    p.product_name,
    p.category,
    p.unit_price,
    p.stock_quantity,
    (p.unit_price * p.stock_quantity) as inventory_value,
    p.launch_date,
    DATEDIFF(CURDATE(), p.launch_date) as days_in_catalog,
    CASE 
        WHEN p.unit_price > 100000 THEN 'High Priority - Premium Product'
        WHEN p.unit_price > 50000 THEN 'Medium Priority - Expensive Product'  
        WHEN DATEDIFF(CURDATE(), p.launch_date) > 365 THEN 'High Priority - Old Product'
        WHEN p.stock_quantity > 50 THEN 'Medium Priority - High Stock'
        ELSE 'Low Priority'
    END as action_priority
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL
    AND (p.unit_price > 10000 OR p.stock_quantity > 30 OR DATEDIFF(CURDATE(), p.launch_date) > 200)
ORDER BY inventory_value DESC;
