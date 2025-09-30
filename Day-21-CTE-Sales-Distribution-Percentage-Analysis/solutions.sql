
-- Query 1: Product Sales Distribution (Percent of Total Revenue) 
-- Calculate each product's revenue percentage using CTE
WITH TotalRevenue AS (
    SELECT SUM(quantity * price) AS total 
    FROM Sales
)
SELECT 
    s.product_id,
    SUM(s.quantity * s.price) AS revenue,
    ROUND(SUM(s.quantity * s.price) * 100.0 / t.total, 2) AS revenue_pct
FROM Sales s
CROSS JOIN TotalRevenue t
GROUP BY s.product_id, t.total
ORDER BY revenue DESC;

-- Query 2: Product Sales Distribution with Product Names 
-- Enhanced view with product details and category breakdown
WITH TotalRevenue AS (
    SELECT SUM(quantity * price) AS total 
    FROM Sales
)
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    SUM(s.quantity) as units_sold,
    SUM(s.quantity * s.price) AS revenue,
    ROUND(SUM(s.quantity * s.price) * 100.0 / t.total, 2) AS revenue_pct,
    RANK() OVER (ORDER BY SUM(s.quantity * s.price) DESC) as revenue_rank
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
CROSS JOIN TotalRevenue t
GROUP BY p.product_id, p.product_name, p.category, p.brand, t.total
ORDER BY revenue DESC;

-- Query 3: Category Revenue Distribution 
-- Calculate category-level revenue distribution
WITH TotalRevenue AS (
    SELECT SUM(quantity * price) AS total 
    FROM Sales
),
CategoryRevenue AS (
    SELECT 
        p.category,
        SUM(s.quantity * s.price) AS category_revenue
    FROM Sales s
    JOIN Products p ON s.product_id = p.product_id
    GROUP BY p.category
)
SELECT 
    cr.category,
    cr.category_revenue,
    ROUND(cr.category_revenue * 100.0 / tr.total, 2) AS category_pct,
    (SELECT COUNT(DISTINCT product_id) 
     FROM Products 
     WHERE category = cr.category) as products_in_category
FROM CategoryRevenue cr
CROSS JOIN TotalRevenue tr
ORDER BY cr.category_revenue DESC;

-- Query 4: Brand Revenue Distribution with Cumulative Percentage 
-- Analyze brand contribution with Pareto analysis (80/20 rule)
WITH TotalRevenue AS (
    SELECT SUM(quantity * price) AS total 
    FROM Sales
),
BrandRevenue AS (
    SELECT 
        p.brand,
        SUM(s.quantity * s.price) AS brand_revenue,
        COUNT(DISTINCT s.product_id) as products_sold
    FROM Sales s
    JOIN Products p ON s.product_id = p.product_id
    GROUP BY p.brand
)
SELECT 
    br.brand,
    br.products_sold,
    br.brand_revenue,
    ROUND(br.brand_revenue * 100.0 / tr.total, 2) AS revenue_pct,
    ROUND(SUM(br.brand_revenue * 100.0 / tr.total) OVER (
        ORDER BY br.brand_revenue DESC
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ), 2) AS cumulative_pct
FROM BrandRevenue br
CROSS JOIN TotalRevenue tr
ORDER BY br.brand_revenue DESC;

-- Query 5: Top Revenue Contributors (80/20 Rule) 
-- Identify products contributing to 80% of revenue (Pareto principle)
WITH TotalRevenue AS (
    SELECT SUM(quantity * price) AS total 
    FROM Sales
),
ProductRevenue AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.brand,
        SUM(s.quantity * s.price) AS revenue
    FROM Sales s
    JOIN Products p ON s.product_id = p.product_id
    GROUP BY p.product_id, p.product_name, p.brand
),
RevenueWithCumulative AS (
    SELECT 
        pr.product_id,
        pr.product_name,
        pr.brand,
        pr.revenue,
        ROUND(pr.revenue * 100.0 / tr.total, 2) AS revenue_pct,
        ROUND(SUM(pr.revenue * 100.0 / tr.total) OVER (
            ORDER BY pr.revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ), 2) AS cumulative_pct
    FROM ProductRevenue pr
    CROSS JOIN TotalRevenue tr
)
SELECT 
    product_id,
    product_name,
    brand,
    revenue,
    revenue_pct,
    cumulative_pct,
    CASE 
        WHEN cumulative_pct <= 80 THEN 'Top 80% Contributors'
        ELSE 'Bottom 20% Contributors'
    END as pareto_category
FROM RevenueWithCumulative
ORDER BY revenue DESC;
