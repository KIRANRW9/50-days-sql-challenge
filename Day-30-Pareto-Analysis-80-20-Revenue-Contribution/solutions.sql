-- Query 1: Products contributing to ~80% of total revenue
WITH sales_cte AS (
    SELECT
        product_id,
        SUM(qty * price) AS revenue
    FROM Sales
    GROUP BY product_id
),
total_revenue AS (
    SELECT SUM(revenue) AS total
    FROM sales_cte
),
running_totals AS (
    SELECT
        s.product_id,
        s.revenue,
        SUM(s.revenue) OVER (
            ORDER BY s.revenue DESC
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
        ) AS running_total,
        t.total AS total_revenue
    FROM sales_cte s
    CROSS JOIN total_revenue t
)
SELECT
    product_id,
    revenue,
    running_total,
    total_revenue,
    ROUND((running_total / total_revenue) * 100, 2) AS cumulative_pct
FROM running_totals
WHERE running_total <= total_revenue * 0.8
ORDER BY revenue DESC;

-- Query 2: Complete Pareto analysis with product info, percentages, and categories
WITH sales_cte AS (
    SELECT
        product_id,
        SUM(qty * price) AS revenue,
        SUM(qty) AS units_sold
    FROM Sales
    GROUP BY product_id
),
total_revenue AS (
    SELECT
        SUM(revenue) AS total,
        SUM(units_sold) AS total_units
    FROM sales_cte
),
pareto_data AS (
    SELECT
        s.product_id,
        p.product_name,
        p.brand,
        p.category,
        s.units_sold,
        s.revenue,
        ROUND((s.revenue / t.total) * 100, 2) AS revenue_pct,
        SUM(s.revenue) OVER (ORDER BY s.revenue DESC) AS running_total,
        ROUND((SUM(s.revenue) OVER (ORDER BY s.revenue DESC) / t.total) * 100, 2) AS cumulative_pct,
        t.total AS total_revenue
    FROM sales_cte s
    JOIN Products p ON s.product_id = p.product_id
    CROSS JOIN total_revenue t
)
SELECT
    product_id,
    product_name,
    brand,
    category,
    units_sold,
    revenue,
    revenue_pct,
    running_total,
    cumulative_pct,
    CASE
        WHEN SUM(revenue) OVER (ORDER BY revenue DESC) <= total_revenue * 0.8 THEN 'Top 80% Contributors'
        ELSE 'Bottom 20% Contributors'
    END AS pareto_category
FROM pareto_data
ORDER BY revenue DESC;

-- Query 3: Brand-level Pareto Analysis
WITH brand_sales AS (
    SELECT
        p.brand,
        SUM(s.qty * s.price) AS brand_revenue,
        COUNT(DISTINCT s.product_id) AS products_sold
    FROM Sales s
    JOIN Products p ON s.product_id = p.product_id
    GROUP BY p.brand
),
total_revenue AS (
    SELECT SUM(brand_revenue) AS total
    FROM brand_sales
)
SELECT
    bs.brand,
    bs.products_sold,
    bs.brand_revenue,
    ROUND((bs.brand_revenue / tr.total) * 100, 2) AS revenue_pct,
    SUM(bs.brand_revenue) OVER (ORDER BY bs.brand_revenue DESC) AS running_total,
    ROUND((SUM(bs.brand_revenue) OVER (ORDER BY bs.brand_revenue DESC) / tr.total) * 100, 2) AS cumulative_pct,
    CASE
        WHEN SUM(bs.brand_revenue) OVER (ORDER BY bs.brand_revenue DESC) <= tr.total * 0.8 THEN 'Focus Brands (80% Rule)'
        ELSE 'Opportunity Brands'
    END AS strategic_category
FROM brand_sales bs
CROSS JOIN total_revenue tr
ORDER BY bs.brand_revenue DESC;

-- Query 4: Product count vs revenue thresholds (50 / 80 / 90%)
WITH sales_cte AS (
    SELECT
        product_id,
        SUM(qty * price) AS revenue
    FROM Sales
    GROUP BY product_id
),
total_revenue AS (
    SELECT SUM(revenue) AS total
    FROM sales_cte
),
revenue_ranked AS (
    SELECT
        product_id,
        revenue,
        SUM(revenue) OVER (ORDER BY revenue DESC) AS running_total,
        ROW_NUMBER() OVER (ORDER BY revenue DESC) AS product_rank,
        total_revenue
    FROM sales_cte
    CROSS JOIN total_revenue
)
SELECT
    'Top 50% Revenue' AS threshold,
    COUNT(*) AS product_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Products)), 1) AS pct_of_products
FROM revenue_ranked
WHERE running_total <= total_revenue * 0.50
UNION ALL
SELECT
    'Top 80% Revenue',
    COUNT(*),
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Products)), 1)
FROM revenue_ranked
WHERE running_total <= total_revenue * 0.80
UNION ALL
SELECT
    'Top 90% Revenue',
    COUNT(*),
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Products)), 1)
FROM revenue_ranked
WHERE running_total <= total_revenue * 0.90;

-- Query 5: Strategic Action Plan (ABC classification)
WITH sales_cte AS (
    SELECT
        product_id,
        SUM(qty * price) AS revenue,
        SUM(qty) AS units_sold
    FROM Sales
    GROUP BY product_id
),
total_revenue AS (
    SELECT SUM(revenue) AS total
    FROM sales_cte
),
pareto_data AS (
    SELECT
        p.product_id,
        p.product_name,
        p.brand,
        s.units_sold,
        s.revenue,
        SUM(s.revenue) OVER (ORDER BY s.revenue DESC) AS running_total,
        total_revenue.total
    FROM sales_cte s
    JOIN Products p
        ON s.product_id = p.product_id
    CROSS JOIN total_revenue
),
final_classification AS (
    SELECT
        product_id,
        product_name,
        brand,
        units_sold,
        revenue,
        ROUND((revenue / total) * 100, 2) AS revenue_contribution_pct,
        ROUND((running_total / total) * 100, 2) AS cumulative_pct,
        CASE
            WHEN (running_total / total) <= 0.50 THEN 'A - Critical Focus'
            WHEN (running_total / total) <= 0.80 THEN 'B - High Priority'
            WHEN (running_total / total) <= 0.95 THEN 'C - Maintain'
            ELSE 'D - Evaluate'
        END AS abc_category,
        CASE
            WHEN (running_total / total) <= 0.50 THEN 'Maximize availability, premium placement, aggressive marketing'
            WHEN (running_total / total) <= 0.80 THEN 'Strong inventory support, regular promotion'
            WHEN (running_total / total) <= 0.95 THEN 'Standard inventory, selective promotion'
            ELSE 'Consider discontinuation or clearance'
        END AS strategic_action
    FROM pareto_data
)
SELECT
    product_name,
    brand,
    units_sold,
    revenue,
    revenue_contribution_pct,
    cumulative_pct,
    abc_category,
    strategic_action
FROM final_classification
ORDER BY revenue DESC;
