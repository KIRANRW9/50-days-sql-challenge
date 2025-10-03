-- QUERY 1: Basic Cumulative Revenue by Day
-- Calculate cumulative revenue by day
SELECT 
    order_date,
    SUM(order_amount) AS daily_revenue,
    SUM(SUM(order_amount)) OVER (ORDER BY order_date) AS cumulative_revenue
FROM Orders
WHERE status = 'Completed'
GROUP BY order_date
ORDER BY order_date;

-- QUERY 2: Cumulative Revenue with Daily Growth
-- Cumulative revenue with daily growth metrics
SELECT 
    order_date,
    SUM(order_amount) AS daily_revenue,
    SUM(SUM(order_amount)) OVER (ORDER BY order_date) AS cumulative_revenue,
    ROUND(SUM(order_amount) / SUM(SUM(order_amount)) OVER (ORDER BY order_date) * 100, 2) AS daily_contribution_pct,
    LAG(SUM(SUM(order_amount)) OVER (ORDER BY order_date), 1) 
        OVER (ORDER BY order_date) AS previous_cumulative
FROM Orders
WHERE status = 'Completed'
GROUP BY order_date
ORDER BY order_date;

-- QUERY 3: Monthly Cumulative Revenue Analysis
-- Cumulative revenue by month with comparisons
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS monthly_revenue,
    SUM(SUM(order_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) AS cumulative_revenue,
    ROUND(AVG(order_amount), 2) AS avg_order_value,
    MIN(order_amount) AS min_order,
    MAX(order_amount) AS max_order
FROM Orders
WHERE status = 'Completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;

-- QUERY 4: Cumulative Revenue by Payment Method
-- Cumulative revenue breakdown by payment method
SELECT 
    order_date,
    payment_method,
    SUM(order_amount) AS daily_amount,
    SUM(SUM(order_amount)) OVER (
        PARTITION BY payment_method 
        ORDER BY order_date
    ) AS cumulative_by_method,
    SUM(SUM(order_amount)) OVER (ORDER BY order_date) AS overall_cumulative
FROM Orders
WHERE status = 'Completed'
GROUP BY order_date, payment_method
ORDER BY order_date, payment_method;

-- QUERY 5: Cumulative Revenue with Target Tracking
-- Track cumulative revenue against monthly targets
WITH DailyRevenue AS (
    SELECT 
        order_date,
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(order_amount) AS daily_revenue
    FROM Orders
    WHERE status = 'Completed'
    GROUP BY order_date, DATE_FORMAT(order_date, '%Y-%m')
),
MonthlyTargets AS (
    SELECT '2024-01' AS month, 250000 AS target
    UNION ALL SELECT '2024-02', 280000
    UNION ALL SELECT '2024-03', 310000
)
SELECT 
    d.order_date,
    d.month,
    d.daily_revenue,
    SUM(d.daily_revenue) OVER (
        PARTITION BY d.month 
        ORDER BY d.order_date
    ) AS month_cumulative_revenue,
    t.target AS monthly_target,
    ROUND(SUM(d.daily_revenue) OVER (
        PARTITION BY d.month 
        ORDER BY d.order_date
    ) / t.target * 100, 2) AS target_achievement_pct
FROM DailyRevenue d
LEFT JOIN MonthlyTargets t ON d.month = t.month
ORDER BY d.order_date;
