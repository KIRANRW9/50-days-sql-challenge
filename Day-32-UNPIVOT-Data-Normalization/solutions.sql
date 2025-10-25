-- =====================================================
-- Day 32: UNPIVOT Data Normalization - Solutions
-- =====================================================

-- ============================================
-- Query 1: Basic UNPIVOT - Convert Months to Rows
-- ============================================
-- Transform wide format (month columns) to long format (month rows)

SELECT 
    product_id,
    product_name,
    category,
    'January' AS sale_month,
    january AS sale_amount
FROM ProductSales
WHERE january IS NOT NULL

UNION ALL

SELECT product_id, product_name, category, 'February', february FROM ProductSales WHERE february IS NOT NULL
UNION ALL
SELECT product_id, product_name, category, 'March', march FROM ProductSales WHERE march IS NOT NULL
UNION ALL
SELECT product_id, product_name, category, 'April', april FROM ProductSales WHERE april IS NOT NULL
UNION ALL
SELECT product_id, product_name, category, 'May', may FROM ProductSales WHERE may IS NOT NULL
UNION ALL
SELECT product_id, product_name, category, 'June', june FROM ProductSales WHERE june IS NOT NULL

ORDER BY product_id, 
    CASE sale_month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
    END;

/*
Output (first 10 rows):
product_id | product_name | category     | sale_month | sale_amount
-----------|--------------|--------------|------------|-------------
    101    | Laptop       | Electronics  | January    | 125000.00
    101    | Laptop       | Electronics  | February   | 135000.00
    101    | Laptop       | Electronics  | March      | 142000.00
    101    | Laptop       | Electronics  | April      | 138000.00
    101    | Laptop       | Electronics  | May        | 145000.00
    101    | Laptop       | Electronics  | June       | 155000.00
    102    | Smartphone   | Electronics  | January    | 95000.00
    102    | Smartphone   | Electronics  | February   | 102000.00
    102    | Smartphone   | Electronics  | March      | 108000.00
    102    | Smartphone   | Electronics  | April      | 105000.00

How it works:
- Each UNION ALL creates rows for one month column
- Converts column name to row value (month name)
- Column value becomes sale_amount
- WHERE clause filters out NULL values
- CASE in ORDER BY ensures chronological ordering
- Transforms 5 rows × 6 columns → 30 rows total
*/


-- ============================================
-- Query 2: UNPIVOT with Date Conversion
-- ============================================
-- Create proper date values from month names

WITH UnpivotedData AS (
    SELECT product_id, product_name, category, 'January' AS sale_month, january AS sale_amount, 1 AS month_num FROM ProductSales WHERE january IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'February' AS sale_month, february AS sale_amount, 2 AS month_num FROM ProductSales WHERE february IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'March' AS sale_month, march AS sale_amount, 3 AS month_num FROM ProductSales WHERE march IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'April' AS sale_month, april AS sale_amount, 4 AS month_num FROM ProductSales WHERE april IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'May' AS sale_month, may AS sale_amount, 5 AS month_num FROM ProductSales WHERE may IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'June' AS sale_month, june AS sale_amount, 6 AS month_num FROM ProductSales WHERE june IS NOT NULL
)
SELECT 
    product_id,
    product_name,
    category,
    sale_month,
    DATE_FORMAT(STR_TO_DATE(CONCAT('2024-', month_num, '-01'), '%Y-%m-%d'), '%Y-%m-%d') AS sale_date,
    sale_amount
FROM UnpivotedData
ORDER BY product_id, month_num;

/*
Output (first 8 rows):
product_id | product_name | category     | sale_month | sale_date  | sale_amount
-----------|--------------|--------------|------------|------------|-------------
    101    | Laptop       | Electronics  | January    | 2024-01-01 | 125000.00
    101    | Laptop       | Electronics  | February   | 2024-02-01 | 135000.00
    101    | Laptop       | Electronics  | March      | 2024-03-01 | 142000.00
    101    | Laptop       | Electronics  | April      | 2024-04-01 | 138000.00
    101    | Laptop       | Electronics  | May        | 2024-05-01 | 145000.00
    101    | Laptop       | Electronics  | June       | 2024-06-01 | 155000.00
    102    | Smartphone   | Electronics  | January    | 2024-01-01 | 95000.00
    102    | Smartphone   | Electronics  | February   | 2024-02-01 | 102000.00

How it works:
- Adds month_num for date construction
- STR_TO_DATE converts to proper DATE type
- CONCAT builds date string (YYYY-MM-01)
- Creates first day of each month as sale_date
- Enables time-series analysis with proper dates
- Ready for date-based filtering and calculations
*/


-- ============================================
-- Query 3: UNPIVOT with Aggregations
-- ============================================
-- Analyze unpivoted data with monthly statistics

WITH UnpivotedData AS (
    SELECT product_id, product_name, category, 'January' AS sale_month, january AS sale_amount, 1 AS month_num FROM ProductSales WHERE january IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'February' AS sale_month, february AS sale_amount, 2 AS month_num FROM ProductSales WHERE february IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'March' AS sale_month, march AS sale_amount, 3 AS month_num FROM ProductSales WHERE march IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'April' AS sale_month, april AS sale_amount, 4 AS month_num FROM ProductSales WHERE april IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'May' AS sale_month, may AS sale_amount, 5 AS month_num FROM ProductSales WHERE may IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'June' AS sale_month, june AS sale_amount, 6 AS month_num FROM ProductSales WHERE june IS NOT NULL
)
SELECT 
    sale_month,
    COUNT(DISTINCT product_id) AS products_sold,
    SUM(sale_amount) AS total_revenue,
    ROUND(AVG(sale_amount), 2) AS avg_product_revenue,
    MIN(sale_amount) AS min_sale,
    MAX(sale_amount) AS max_sale
FROM UnpivotedData
GROUP BY sale_month, month_num
ORDER BY month_num;

/*
Output:
sale_month | products_sold | total_revenue | avg_product_revenue | min_sale  | max_sale
-----------|---------------|---------------|---------------------|-----------|----------
January    |       5       |   365000.00   |      73000.00       | 35000.00  | 125000.00
February   |       5       |   391000.00   |      78200.00       | 38000.00  | 135000.00
March      |       5       |   416000.00   |      83200.00       | 42000.00  | 142000.00
April      |       5       |   403000.00   |      80600.00       | 40000.00  | 138000.00
May        |       5       |   432000.00   |      86400.00       | 45000.00  | 145000.00
June       |       5       |   457000.00   |      91400.00       | 48000.00  | 155000.00

How it works:
- Unpivots data first
- Then aggregates across all products by month
- Shows monthly trends across product portfolio
- Identifies growth patterns (steady increase)
- Revenue grows from 365K (Jan) to 457K (June) = 25% growth
- Average product revenue increases 25% over 6 months
*/


-- ============================================
-- Query 4: UNPIVOT with Growth Analysis
-- ============================================
-- Calculate month-over-month growth after unpivoting

WITH UnpivotedData AS (
    SELECT product_id, product_name, category, 'January' AS sale_month, january AS sale_amount, 1 AS month_num FROM ProductSales WHERE january IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'February' AS sale_month, february AS sale_amount, 2 AS month_num FROM ProductSales WHERE february IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'March' AS sale_month, march AS sale_amount, 3 AS month_num FROM ProductSales WHERE march IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'April' AS sale_month, april AS sale_amount, 4 AS month_num FROM ProductSales WHERE april IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'May' AS sale_month, may AS sale_amount, 5 AS month_num FROM ProductSales WHERE may IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'June' AS sale_month, june AS sale_amount, 6 AS month_num FROM ProductSales WHERE june IS NOT NULL
),
WithLag AS (
    SELECT 
        product_id,
        product_name,
        sale_month,
        month_num,
        sale_amount,
        LAG(sale_amount) OVER (PARTITION BY product_id ORDER BY month_num) AS prev_month_amount
    FROM UnpivotedData
)
SELECT 
    product_id,
    product_name,
    sale_month,
    sale_amount AS current_month,
    prev_month_amount AS previous_month,
    sale_amount - prev_month_amount AS absolute_change,
    ROUND((sale_amount - prev_month_amount) * 100.0 / NULLIF(prev_month_amount, 0), 2) AS growth_pct
FROM WithLag
WHERE prev_month_amount IS NOT NULL
ORDER BY product_id, month_num;

/*
Output (first 10 rows):
product_id | product_name | sale_month | current_month | previous_month | absolute_change | growth_pct
-----------|--------------|------------|---------------|----------------|-----------------|------------
    101    | Laptop       | February   | 135000.00     | 125000.00      |   10000.00      |    8.00
    101    | Laptop       | March      | 142000.00     | 135000.00      |    7000.00      |    5.19
    101    | Laptop       | April      | 138000.00     | 142000.00      |   -4000.00      |   -2.82
    101    | Laptop       | May        | 145000.00     | 138000.00      |    7000.00      |    5.07
    101    | Laptop       | June       | 155000.00     | 145000.00      |   10000.00      |    6.90
    102    | Smartphone   | February   | 102000.00     | 95000.00       |    7000.00      |    7.37
    102    | Smartphone   | March      | 108000.00     | 102000.00      |    6000.00      |    5.88
    102    | Smartphone   | April      | 105000.00     | 108000.00      |   -3000.00      |   -2.78
    102    | Smartphone   | May        | 112000.00     | 105000.00      |    7000.00      |    6.67
    102    | Smartphone   | June       | 118000.00     | 112000.00      |    6000.00      |    5.36

How it works:
- Unpivots to long format first
- Uses LAG() to get previous month's value
- Calculates absolute and percentage change
- Identifies growth/decline patterns
- April shows decline across products (seasonal dip)
- Most products recover strongly in May-June
*/


-- ============================================
-- Query 5: UNPIVOT for Data Warehouse Loading
-- ============================================
-- Create normalized table ready for ETL/data warehouse

CREATE TABLE IF NOT EXISTS SalesNormalized AS
WITH UnpivotedData AS (
    SELECT product_id, product_name, category, 'January' AS sale_month, january AS sale_amount, 1 AS month_num FROM ProductSales WHERE january IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'February' AS sale_month, february AS sale_amount, 2 AS month_num FROM ProductSales WHERE february IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'March' AS sale_month, march AS sale_amount, 3 AS month_num FROM ProductSales WHERE march IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'April' AS sale_month, april AS sale_amount, 4 AS month_num FROM ProductSales WHERE april IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'May' AS sale_month, may AS sale_amount, 5 AS month_num FROM ProductSales WHERE may IS NOT NULL
    UNION ALL
    SELECT product_id, product_name, category, 'June' AS sale_month, june AS sale_amount, 6 AS month_num FROM ProductSales WHERE june IS NOT NULL
)
SELECT 
    ROW_NUMBER() OVER (ORDER BY product_id, month_num) AS sale_id,
    product_id,
    product_name,
    category,
    sale_month,
    DATE_FORMAT(STR_TO_DATE(CONCAT('2024-', month_num, '-01'), '%Y-%m-%d'), '%Y-%m-%d') AS sale_date,
    month_num AS month_number,
    QUARTER(STR_TO_DATE(CONCAT('2024-', month_num, '-01'), '%Y-%m-%d')) AS quarter,
    sale_amount,
    CURRENT_TIMESTAMP AS created_at
FROM UnpivotedData
ORDER BY product_id, month_num;

-- Verify the normalized table
SELECT * FROM SalesNormalized LIMIT 10;

/*
Output:
sale_id | product_id | product_name | category    | sale_month | sale_date  | month_number | quarter | sale_amount | created_at
--------|------------|--------------|-------------|------------|------------|--------------|---------|-------------|--------------------
   1    |    101     | Laptop       | Electronics | January    | 2024-01-01 |      1       |    1    | 125000.00   | 2024-10-25 14:30:00
   2    |    101     | Laptop       | Electronics | February   | 2024-02-01 |      2       |    1    | 135000.00   | 2024-10-25 14:30:00
   3    |    101     | Laptop       | Electronics | March      | 2024-03-01 |      3       |    1    | 142000.00   | 2024-10-25 14:30:00
   4    |    101     | Laptop       | Electronics | April      | 2024-04-01 |      4       |    2    | 138000.00   | 2024-10-25 14:30:00
   5    |    101     | Laptop       | Electronics | May        | 2024-05-01 |      5       |    2    | 145000.00   | 2024-10-25 14:30:00
   6    |    101     | Laptop       | Electronics | June       | 2024-06-01 |      6       |    2    | 155000.00   | 2024-10-25 14:30:00
   7    |    102     | Smartphone   | Electronics | January    | 2024-01-01 |      1       |    1    | 95000.00    | 2024-10-25 14:30:00
   8    |    102     | Smartphone   | Electronics | February   | 2024-02-01 |      2       |    1    | 102000.00   | 2024-10-25 14:30:00
   9    |    102     | Smartphone   | Electronics | March      | 2024-03-01 |      3       |    1    | 108000.00   | 2024-10-25 14:30:00
  10    |    102     | Smartphone   | Electronics | April      | 2024-04-01 |      4       |    2    | 105000.00   | 2024-10-25 14:30:00

How it works:
- Creates new normalized table from wide format
- Adds surrogate key (sale_id) using ROW_NUMBER()
- Converts months to proper DATE types
- Adds quarter calculation for reporting (Q1 = Jan-Mar, Q2 = Apr-Jun)
- Includes audit timestamp (created_at)
- Ready for data warehouse star schema
- Enables efficient time-series queries
- Total 30 rows created (5 products × 6 months)
*/
