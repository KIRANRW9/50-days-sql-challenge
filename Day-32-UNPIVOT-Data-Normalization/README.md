# Day 32: UNPIVOT Data Normalization (Wide to Long Format)

## Problem
The data engineering team needs to transform wide-format data (one row with multiple month columns) into long-format data (multiple rows with a single value column) for easier analysis, data warehouse loading, and time-series modeling. UNPIVOT operations convert columns into rows, normalizing data for analytical databases and reporting tools.

## Dataset
Product sales data stored in wide format with separate columns for each month that needs to be converted into a normalized long format where each month-product combination is a separate row, enabling time-series analysis and simpler querying.

## SQL Solution

### Table Structure

```sql
-- Create ProductSales table (Wide format)
CREATE TABLE ProductSales (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    january DECIMAL(10,2),
    february DECIMAL(10,2),
    march DECIMAL(10,2),
    april DECIMAL(10,2),
    may DECIMAL(10,2),
    june DECIMAL(10,2)
);
```

---

## Query 1: Basic UNPIVOT - Convert Months to Rows

**Transform wide format (month columns) to long format (month rows)**

```sql
SELECT 
    product_id,
    product_name,
    category,
    'January' AS sale_month,
    january AS sale_amount
FROM ProductSales
WHERE january IS NOT NULL

UNION ALL

SELECT 
    product_id,
    product_name,
    category,
    'February' AS sale_month,
    february AS sale_amount
FROM ProductSales
WHERE february IS NOT NULL

UNION ALL

SELECT 
    product_id,
    product_name,
    category,
    'March' AS sale_month,
    march AS sale_amount
FROM ProductSales
WHERE march IS NOT NULL

UNION ALL

SELECT 
    product_id,
    product_name,
    category,
    'April' AS sale_month,
    april AS sale_amount
FROM ProductSales
WHERE april IS NOT NULL

UNION ALL

SELECT 
    product_id,
    product_name,
    category,
    'May' AS sale_month,
    may AS sale_amount
FROM ProductSales
WHERE may IS NOT NULL

UNION ALL

SELECT 
    product_id,
    product_name,
    category,
    'June' AS sale_month,
    june AS sale_amount
FROM ProductSales
WHERE june IS NOT NULL

ORDER BY product_id, 
    CASE sale_month
        WHEN 'January' THEN 1
        WHEN 'February' THEN 2
        WHEN 'March' THEN 3
        WHEN 'April' THEN 4
        WHEN 'May' THEN 5
        WHEN 'June' THEN 6
    END;
```

**Output:**
```
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
    ...
```

**How it works:**
- Each UNION ALL creates rows for one month
- Converts column name to row value (month name)
- Column value becomes sale_amount
- WHERE clause filters out NULL values
- CASE in ORDER BY ensures chronological ordering
- Transforms 5 rows × 6 columns → 30 rows × 1 value column

---

## Query 2: UNPIVOT with Date Conversion

**Create proper date values from month names**

```sql
WITH UnpivotedData AS (
    SELECT 
        product_id,
        product_name,
        category,
        'January' AS sale_month,
        january AS sale_amount,
        1 AS month_num
    FROM ProductSales
    WHERE january IS NOT NULL
    
    UNION ALL
    
    SELECT 
        product_id,
        product_name,
        category,
        'February' AS sale_month,
        february AS sale_amount,
        2 AS month_num
    FROM ProductSales
    WHERE february IS NOT NULL
    
    UNION ALL
    
    SELECT 
        product_id,
        product_name,
        category,
        'March' AS sale_month,
        march AS sale_amount,
        3 AS month_num
    FROM ProductSales
    WHERE march IS NOT NULL
    
    UNION ALL
    
    SELECT 
        product_id,
        product_name,
        category,
        'April' AS sale_month,
        april AS sale_amount,
        4 AS month_num
    FROM ProductSales
    WHERE april IS NOT NULL
    
    UNION ALL
    
    SELECT 
        product_id,
        product_name,
        category,
        'May' AS sale_month,
        may AS sale_amount,
        5 AS month_num
    FROM ProductSales
    WHERE may IS NOT NULL
    
    UNION ALL
    
    SELECT 
        product_id,
        product_name,
        category,
        'June' AS sale_month,
        june AS sale_amount,
        6 AS month_num
    FROM ProductSales
    WHERE june IS NOT NULL
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
```

**Output:**
```
product_id | product_name | category     | sale_month | sale_date  | sale_amount
-----------|--------------|--------------|------------|------------|-------------
    101    | Laptop       | Electronics  | January    | 2024-01-01 | 125000.00
    101    | Laptop       | Electronics  | February   | 2024-02-01 | 135000.00
    101    | Laptop       | Electronics  | March      | 2024-03-01 | 142000.00
    101    | Laptop       | Electronics  | April      | 2024-04-01 | 138000.00
    101    | Laptop       | Electronics  | May        | 2024-05-01 | 145000.00
    101    | Laptop       | Electronics  | June       | 2024-06-01 | 155000.00
```

**How it works:**
- Adds month_num for date construction
- `STR_TO_DATE` converts to proper DATE type
- Creates first day of each month as sale_date
- Enables time-series analysis with proper dates
- Ready for date-based filtering and calculations

---

## Query 3: UNPIVOT with Aggregations

**Analyze unpivoted data with monthly statistics**

```sql
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
```

**Output:**
```
sale_month | products_sold | total_revenue | avg_product_revenue | min_sale  | max_sale
-----------|---------------|---------------|---------------------|-----------|----------
January    |       5       |   365000.00   |      73000.00       | 35000.00  | 125000.00
February   |       5       |   391000.00   |      78200.00       | 38000.00  | 135000.00
March      |       5       |   416000.00   |      83200.00       | 42000.00  | 142000.00
April      |       5       |   403000.00   |      80600.00       | 40000.00  | 138000.00
May        |       5       |   432000.00   |      86400.00       | 45000.00  | 145000.00
June       |       5       |   457000.00   |      91400.00       | 48000.00  | 155000.00
```

**How it works:**
- Unpivots data first
- Then aggregates across all products by month
- Shows monthly trends across product portfolio
- Identifies growth patterns (steady increase)
- Revenue grows from 365K (Jan) to 457K (June)

---

## Query 4: UNPIVOT with Growth Analysis

**Calculate month-over-month growth after unpivoting**

```sql
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
```

**Output:**
```
product_id | product_name | sale_month | current_month | previous_month | absolute_change | growth_pct
-----------|--------------|------------|---------------|----------------|-----------------|------------
    101    | Laptop       | February   | 135000.00     | 125000.00      |   10000.00      |    8.00
    101    | Laptop       | March      | 142000.00     | 135000.00      |    7000.00      |    5.19
    101    | Laptop       | April      | 138000.00     | 142000.00      |   -4000.00      |   -2.82
    101    | Laptop       | May        | 145000.00     | 138000.00      |    7000.00      |    5.07
    101    | Laptop       | June       | 155000.00     | 145000.00      |   10000.00      |    6.90
```

**How it works:**
- Unpivots to long format first
- Uses LAG() to get previous month's value
- Calculates absolute and percentage change
- Identifies growth/decline patterns
- April shows decline across products (seasonal dip)

---

## Query 5: UNPIVOT for Data Warehouse Loading

**Create normalized table ready for ETL/data warehouse**

```sql
CREATE TABLE SalesNormalized AS
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
```

**Output:**
```
sale_id | product_id | product_name | category    | sale_month | sale_date  | month_number | quarter | sale_amount | created_at
--------|------------|--------------|-------------|------------|------------|--------------|---------|-------------|--------------------
   1    |    101     | Laptop       | Electronics | January    | 2024-01-01 |      1       |    1    | 125000.00   | 2024-10-25 14:30:00
   2    |    101     | Laptop       | Electronics | February   | 2024-02-01 |      2       |    1    | 135000.00   | 2024-10-25 14:30:00
   3    |    101     | Laptop       | Electronics | March      | 2024-03-01 |      3       |    1    | 142000.00   | 2024-10-25 14:30:00
   4    |    101     | Laptop       | Electronics | April      | 2024-04-01 |      4       |    2    | 138000.00   | 2024-10-25 14:30:00
   5    |    101     | Laptop       | Electronics | May        | 2024-05-01 |      5       |    2    | 145000.00   | 2024-10-25 14:30:00
   6    |    101     | Laptop       | Electronics | June       | 2024-06-01 |      6       |    2    | 155000.00   | 2024-10-25 14:30:00
```

**How it works:**
- Creates new normalized table from wide format
- Adds surrogate key (sale_id) using ROW_NUMBER()
- Converts months to proper DATE types
- Adds quarter calculation for reporting
- Includes audit timestamp (created_at)
- Ready for data warehouse star schema
- Enables efficient time-series queries

---

## How It Works

### Key Concepts

**1. UNPIVOT Operation**
```sql
UNION ALL SELECT ..., 'January' AS month, january AS value
UNION ALL SELECT ..., 'February' AS month, february AS value
```
- Converts columns into rows
- Each UNION ALL creates rows for one column
- Column name becomes a value (month)
- Column value becomes the measure (amount)

**2. Wide vs Long Format**
- **Wide format**: One row per entity, multiple value columns
  - Example: `product_id | jan | feb | mar`
- **Long format**: Multiple rows per entity, single value column
  - Example: `product_id | month | amount`
- Wide = easier for humans to read
- Long = better for analysis and databases

**3. UNION ALL vs UNION**
- `UNION ALL`: Faster, keeps all rows (including duplicates)
- `UNION`: Slower, removes duplicates
- For UNPIVOT, always use UNION ALL (no duplicates possible)

**4. NULL Handling**
```sql
WHERE january IS NOT NULL
```
- Filters out NULL values during unpivot
- Prevents creating rows with missing data
- Keeps output clean and meaningful

---

## Business Interpretation

### When to Use UNPIVOT

**Use UNPIVOT when:**
- Loading data into analytical databases
- Performing time-series analysis
- Creating normalized data models
- Integrating with BI tools
- Calculating growth rates or trends
- Joining with date dimensions

**Benefits of Long Format:**
- Easier to filter by time period
- Simpler aggregations
- Better for visualizations
- Scalable (add new months without schema changes)
- Normalized database design
- Efficient indexing

**UNPIVOT Use Cases:**
- ETL processes (Excel → Database)
- Data warehouse fact table loading
- Time-series forecasting
- Trend analysis
- Reporting and dashboards
- Data normalization

---

## Real World Use Cases

1. **ETL Pipelines**: Transform Excel/CSV wide data to database format
2. **Data Warehousing**: Load fact tables with time dimensions
3. **Time-Series Analysis**: Forecasting, trend detection
4. **Reporting Tools**: Power BI, Tableau prefer long format
5. **Statistical Analysis**: R, Python analytics libraries
6. **Database Normalization**: Convert legacy wide tables
7. **API Data**: Transform nested JSON to relational format
8. **Financial Reporting**: Budget vs actual by period

---

## Key Learning Points

### SQL Techniques
- ✅ UNION ALL for row concatenation
- ✅ NULL filtering during unpivot
- ✅ Date construction from month numbers
- ✅ CTEs for multi-step transformations
- ✅ ROW_NUMBER() for surrogate keys
- ✅ LAG() for trend analysis
- ✅ CREATE TABLE AS for materialization

### Data Transformation
- ✅ Wide to long format conversion
- ✅ Column names to row values
- ✅ Data normalization principles
- ✅ Date dimension creation
- ✅ Audit column addition

### Best Practices
- ✅ Filter NULLs to avoid empty rows
- ✅ Add month_num for proper ordering
- ✅ Convert to proper DATE types
- ✅ Include audit timestamps
- ✅ Create surrogate keys
- ✅ Document column mappings
- ✅ Test with sample data first

---

## Performance Tips

1. **Use UNION ALL, not UNION** (much faster)
2. **Filter NULLs early** to reduce row count
3. **Create indexes** on normalized table:
```sql
CREATE INDEX idx_sales_norm_date ON SalesNormalized(sale_date);
CREATE INDEX idx_sales_norm_product ON SalesNormalized(product_id);
```
4. **Consider partitioning** by month for large datasets
5. **Materialize as table** vs view for frequent queries

---

## Extension Ideas

- Add data quality checks during unpivot
- Handle multiple measure columns (sales, quantity, profit)
- Create dynamic unpivot with metadata tables
- Build reverse PIVOT operation
- Add slowly changing dimension (SCD) logic
- Include data lineage tracking
- Implement incremental unpivot for new data
