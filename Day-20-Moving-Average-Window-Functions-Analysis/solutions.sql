-- Query 1: 3-Day Moving Average of Sales

SELECT 
    order_date,
    SUM(total_amount) as daily_sales,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3_days
FROM Orders
GROUP BY order_date
ORDER BY order_date;

-- Query 2: Multiple Window Sizes Moving Average

SELECT 
    order_date,
    SUM(total_amount) as daily_sales,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS ma_3_days,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ), 2) AS ma_5_days,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS ma_7_days
FROM Orders
GROUP BY order_date
ORDER BY order_date;


-- Query 3: Moving Average with Running Total

SELECT 
    order_date,
    SUM(total_amount) as daily_sales,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3_days,
    SUM(SUM(total_amount)) OVER (
        ORDER BY order_date
    ) AS cumulative_total,
    ROUND((SUM(total_amount) / SUM(SUM(total_amount)) OVER (ORDER BY order_date)) * 100, 2) as pct_of_cumulative
FROM Orders
GROUP BY order_date
ORDER BY order_date;


-- Query 4: Sales Trend Analysis with LAG

SELECT 
    order_date,
    SUM(total_amount) as daily_sales,
    LAG(SUM(total_amount)) OVER (ORDER BY order_date) as previous_day_sales,
    SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY order_date) as day_over_day_change,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3_days,
    CASE 
        WHEN SUM(total_amount) > AVG(SUM(total_amount)) OVER (
            ORDER BY order_date 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) THEN 'Above MA'
        ELSE 'Below MA'
    END as trend_indicator
FROM Orders
GROUP BY order_date
ORDER BY order_date;


-- Query 5: Region-wise Moving Average

SELECT 
    order_date,
    region,
    SUM(total_amount) as regional_daily_sales,
    ROUND(AVG(SUM(total_amount)) OVER (
        PARTITION BY region
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS region_moving_avg_3_days,
    RANK() OVER (PARTITION BY order_date ORDER BY SUM(total_amount) DESC) as daily_rank
FROM Orders
GROUP BY order_date, region
ORDER BY order_date, regional_daily_sales DESC;
