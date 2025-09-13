-- Day 04: Calculate Total Revenue Per Product (GROUP BY Usage) - Solutions

-- Solution 1: Calculate Total Revenue Per Product (Basic GROUP BY)
-- Calculate total revenue for each product using GROUP BY
SELECT 
    product_id, 
    SUM(quantity * price) AS total_revenue 
FROM Sales 
GROUP BY product_id 
ORDER BY total_revenue DESC;

-- Solution 2: Revenue Per Product with Product Names (JOIN with GROUP BY)
-- Get product details along with revenue using JOIN and GROUP BY
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(s.quantity * s.price) AS total_revenue,
    SUM(s.quantity) AS total_units_sold
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;

-- Solution 3: Revenue by Category (GROUP BY Category)
-- Analyze revenue performance by product category
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) as products_count,
    SUM(s.quantity * s.price) AS category_revenue,
    AVG(s.quantity * s.price) AS avg_transaction_value
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;

-- Solution 4: Top 3 Products by Revenue (LIMIT with GROUP BY)
-- Find top 3 products by total revenue
SELECT 
    p.product_name,
    SUM(s.quantity * s.price) AS total_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 3;

-- Solution 5: Products with Revenue Above Average (HAVING with Subquery)
-- Find products with revenue above the average product revenue
SELECT 
    p.product_name,
    SUM(s.quantity * s.price) AS total_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(s.quantity * s.price) > (
    SELECT AVG(product_revenue) 
    FROM (
        SELECT SUM(quantity * price) as product_revenue 
        FROM Sales 
        GROUP BY product_id
    ) as avg_calc
)
ORDER BY total_revenue DESC;
