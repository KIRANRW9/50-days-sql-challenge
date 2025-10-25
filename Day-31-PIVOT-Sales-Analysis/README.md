# Day 31: PIVOT Sales Analysis (Data Transformation)

## Problem
The business analytics team needs to transform row-based sales data into a pivot table format to compare product performance across different months. PIVOT operations convert rows into columns, making it easier to analyze trends, create reports, and perform cross-sectional comparisons of sales data by time periods or categories.

## Dataset
Monthly sales data for multiple products that needs to be transformed from a long format (one row per product per month) into a wide format (one row per product with columns for each month) to facilitate easier comparison and reporting.

## SQL Solution

### Table Structure

```sql
-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sale_month VARCHAR(20),
    sale_amount DECIMAL(10,2),
    sale_date DATE
);
```

---

## Query 1: Basic PIVOT - Sales by Product and Month

**Transform monthly sales data into pivot table format**

```sql
SELECT 
    product_name,
    COALESCE(SUM(CASE WHEN sale_month = 'January' THEN sale_amount END), 0) AS January,
    COALESCE(SUM(CASE WHEN sale_month = 'February' THEN sale_amount END), 0) AS February,
    COALESCE(SUM(CASE WHEN sale_month = 'March' THEN sale_amount END), 0) AS March,
    COALESCE(SUM(CASE WHEN sale_month = 'April' THEN sale_amount END), 0) AS April,
    COALESCE(SUM(CASE WHEN sale_month = 'May' THEN sale_amount END), 0) AS May,
    COALESCE(SUM(CASE WHEN sale_month = 'June' THEN sale_amount END), 0) AS June,
    SUM(sale_amount) AS Total_Sales
FROM Sales
GROUP BY product_name
ORDER BY Total_Sales DESC;
```

**Output:**
```
product_name    | January   | February  | March     | April     | May       | June      | Total_Sales
----------------|-----------|-----------|-----------|-----------|-----------|-----------|-------------
Laptop          | 125000.00 | 135000.00 | 142000.00 | 138000.00 | 145000.00 | 155000.00 | 840000.00
Smartphone      | 95000.00  | 102000.00 | 108000.00 | 105000.00 | 112000.00 | 118000.00 | 640000.00
Tablet          | 65000.00  | 68000.00  | 72000.00  | 70000.00  | 75000.00  | 78000.00  | 428000.00
Headphones      | 35000.00  | 38000.00  | 42000.00  | 40000.00  | 45000.00  | 48000.00  | 248000.00
Smartwatch      | 45000.00  | 48000.00  | 52000.00  | 50000.00  | 55000.00  | 58000.00  | 308000.00
```

**How it works:**
- `CASE WHEN` converts rows into columns by month
- `SUM()` aggregates values for each month
- `COALESCE(..., 0)` replaces NULL with 0 for missing months
- Creates side-by-side comparison of monthly performance
- Easy to spot trends and compare products visually

---

## Query 2: PIVOT with Category Grouping

**Show sales by category and month**

```sql
SELECT 
    category,
    COALESCE(SUM(CASE WHEN sale_month = 'January' THEN sale_amount END), 0) AS January,
    COALESCE(SUM(CASE WHEN sale_month = 'February' THEN sale_amount END), 0) AS February,
    COALESCE(SUM(CASE WHEN sale_month = 'March' THEN sale_amount END), 0) AS March,
    COALESCE(SUM(CASE WHEN sale_month = 'April' THEN sale_amount END), 0) AS April,
    COALESCE(SUM(CASE WHEN sale_month = 'May' THEN sale_amount END), 0) AS May,
    COALESCE(SUM(CASE WHEN sale_month = 'June' THEN sale_amount END), 0) AS June,
    SUM(sale_amount) AS Total_Sales,
    ROUND(AVG(sale_amount), 2) AS Avg_Monthly_Sales
FROM Sales
GROUP BY category
ORDER BY Total_Sales DESC;
```

**Output:**
```
category        | January   | February  | March     | April     | May       | June      | Total_Sales | Avg_Monthly_Sales
----------------|-----------|-----------|-----------|-----------|-----------|-----------|-------------|-------------------
Electronics     | 285000.00 | 305000.00 | 322000.00 | 313000.00 | 332000.00 | 351000.00 | 1908000.00  | 106000.00
Accessories     | 80000.00  | 86000.00  | 94000.00  | 90000.00  | 100000.00 | 106000.00 | 556000.00   | 46333.33
```

**How it works:**
- Groups by category instead of individual products
- Aggregates all products within each category
- Shows category-level trends across months
- Includes average monthly sales for context
- Useful for high-level business reporting

---

## Query 3: PIVOT with Growth Calculation

**Calculate month-over-month growth rates**

```sql
WITH MonthlyTotals AS (
    SELECT 
        product_name,
        SUM(CASE WHEN sale_month = 'January' THEN sale_amount END) AS Jan,
        SUM(CASE WHEN sale_month = 'February' THEN sale_amount END) AS Feb,
        SUM(CASE WHEN sale_month = 'March' THEN sale_amount END) AS Mar,
        SUM(CASE WHEN sale_month = 'April' THEN sale_amount END) AS Apr,
        SUM(CASE WHEN sale_month = 'May' THEN sale_amount END) AS May,
        SUM(CASE WHEN sale_month = 'June' THEN sale_amount END) AS Jun
    FROM Sales
    GROUP BY product_name
)
SELECT 
    product_name,
    Jan AS January,
    Feb AS February,
    ROUND((Feb - Jan) * 100.0 / NULLIF(Jan, 0), 2) AS Feb_Growth_Pct,
    Mar AS March,
    ROUND((Mar - Feb) * 100.0 / NULLIF(Feb, 0), 2) AS Mar_Growth_Pct,
    Apr AS April,
    ROUND((Apr - Mar) * 100.0 / NULLIF(Mar, 0), 2) AS Apr_Growth_Pct,
    May,
    ROUND((May - Apr) * 100.0 / NULLIF(Apr, 0), 2) AS May_Growth_Pct,
    Jun AS June,
    ROUND((Jun - May) * 100.0 / NULLIF(May, 0), 2) AS Jun_Growth_Pct
FROM MonthlyTotals
ORDER BY Jun DESC;
```

**Output:**
```
product_name | January   | February  | Feb_Growth_Pct | March     | Mar_Growth_Pct | April     | Apr_Growth_Pct | May       | May_Growth_Pct | June      | Jun_Growth_Pct
-------------|-----------|-----------|----------------|-----------|----------------|-----------|----------------|-----------|----------------|-----------|----------------
Laptop       | 125000.00 | 135000.00 |      8.00      | 142000.00 |      5.19      | 138000.00 |     -2.82      | 145000.00 |      5.07      | 155000.00 |      6.90
Smartphone   | 95000.00  | 102000.00 |      7.37      | 108000.00 |      5.88      | 105000.00 |     -2.78      | 112000.00 |      6.67      | 118000.00 |      5.36
```

**How it works:**
- CTE creates pivot table with monthly columns
- Calculates month-over-month percentage growth
- `NULLIF(Jan, 0)` prevents division by zero
- Negative percentages show declining months
- Identifies seasonal patterns and trends

---

## Query 4: PIVOT with Ranking

**Rank products by monthly performance**

```sql
WITH MonthlyRanks AS (
    SELECT 
        product_name,
        sale_month,
        sale_amount,
        RANK() OVER (PARTITION BY sale_month ORDER BY sale_amount DESC) AS month_rank
    FROM Sales
)
SELECT 
    product_name,
    MAX(CASE WHEN sale_month = 'January' THEN month_rank END) AS Jan_Rank,
    MAX(CASE WHEN sale_month = 'February' THEN month_rank END) AS Feb_Rank,
    MAX(CASE WHEN sale_month = 'March' THEN month_rank END) AS Mar_Rank,
    MAX(CASE WHEN sale_month = 'April' THEN month_rank END) AS Apr_Rank,
    MAX(CASE WHEN sale_month = 'May' THEN month_rank END) AS May_Rank,
    MAX(CASE WHEN sale_month = 'June' THEN month_rank END) AS Jun_Rank,
    ROUND(AVG(month_rank), 2) AS Avg_Rank
FROM MonthlyRanks
GROUP BY product_name
ORDER BY Avg_Rank;
```

**Output:**
```
product_name | Jan_Rank | Feb_Rank | Mar_Rank | Apr_Rank | May_Rank | Jun_Rank | Avg_Rank
-------------|----------|----------|----------|----------|----------|----------|----------
Laptop       |    1     |    1     |    1     |    1     |    1     |    1     |   1.00
Smartphone   |    2     |    2     |    2     |    2     |    2     |    2     |   2.00
Tablet       |    3     |    3     |    3     |    3     |    3     |    3     |   3.00
Smartwatch   |    4     |    4     |    4     |    4     |    4     |    4     |   4.00
Headphones   |    5     |    5     |    5     |    5     |    5     |    5     |   5.00
```

**How it works:**
- `RANK()` determines position within each month
- Pivot shows rank progression across months
- Average rank shows overall performance consistency
- Identifies products maintaining top positions
- Spots products gaining or losing market share

---

## Query 5: Dynamic PIVOT with Totals and Percentages

**Show sales amounts and percentage contribution**

```sql
WITH MonthlySales AS (
    SELECT 
        product_name,
        SUM(CASE WHEN sale_month = 'January' THEN sale_amount END) AS Jan,
        SUM(CASE WHEN sale_month = 'February' THEN sale_amount END) AS Feb,
        SUM(CASE WHEN sale_month = 'March' THEN sale_amount END) AS Mar,
        SUM(CASE WHEN sale_month = 'April' THEN sale_amount END) AS Apr,
        SUM(CASE WHEN sale_month = 'May' THEN sale_amount END) AS May,
        SUM(CASE WHEN sale_month = 'June' THEN sale_amount END) AS Jun,
        SUM(sale_amount) AS Total
    FROM Sales
    GROUP BY product_name
),
GrandTotal AS (
    SELECT SUM(sale_amount) AS grand_total FROM Sales
)
SELECT 
    product_name,
    Jan AS January,
    Feb AS February,
    Mar AS March,
    Apr AS April,
    May,
    Jun AS June,
    Total AS Total_Sales,
    ROUND(Total * 100.0 / (SELECT grand_total FROM GrandTotal), 2) AS Pct_Of_Total
FROM MonthlySales
ORDER BY Total_Sales DESC;
```

**Output:**
```
product_name | January   | February  | March     | April     | May       | June      | Total_Sales | Pct_Of_Total
-------------|-----------|-----------|-----------|-----------|-----------|-----------|-------------|-------------
Laptop       | 125000.00 | 135000.00 | 142000.00 | 138000.00 | 145000.00 | 155000.00 | 840000.00   |    34.09
Smartphone   | 95000.00  | 102000.00 | 108000.00 | 105000.00 | 112000.00 | 118000.00 | 640000.00   |    25.98
Tablet       | 65000.00  | 68000.00  | 72000.00  | 70000.00  | 75000.00  | 78000.00  | 428000.00   |    17.37
Smartwatch   | 45000.00  | 48000.00  | 52000.00  | 50000.00  | 55000.00  | 58000.00  | 308000.00   |    12.50
Headphones   | 35000.00  | 38000.00  | 42000.00  | 40000.00  | 45000.00  | 48000.00  | 248000.00   |    10.06
```

**How it works:**
- Creates complete pivot table with all months
- Calculates total sales per product
- Computes percentage contribution to grand total
- Shows both absolute and relative performance
- Useful for resource allocation decisions

---

## How It Works

### Key Concepts

**1. PIVOT Operation**
```sql
SUM(CASE WHEN sale_month = 'January' THEN sale_amount END) AS January
```
- Transforms rows into columns
- Uses conditional aggregation
- Each CASE statement creates one output column
- Aggregation function (SUM, AVG, COUNT) combines values

**2. COALESCE for NULL Handling**
```sql
COALESCE(SUM(...), 0)
```
- Replaces NULL with meaningful default (0)
- Ensures all cells have values
- Prevents calculation errors
- Improves readability

**3. Long to Wide Format**
- **Long format**: One row per observation (product-month combination)
- **Wide format**: One row per entity (product), columns for attributes (months)
- PIVOT converts long → wide
- UNPIVOT converts wide → long

**4. MySQL/PostgreSQL Alternative**
```sql
-- MySQL doesn't have native PIVOT, use CASE WHEN instead
SELECT 
    product_name,
    SUM(IF(sale_month = 'January', sale_amount, 0)) AS January
FROM Sales
GROUP BY product_name;
```

---

## Business Interpretation

### PIVOT Use Cases

**When to Use PIVOT:**
- Comparing metrics across time periods (months, quarters, years)
- Cross-tabulation of categories (products vs regions)
- Creating executive dashboards and reports
- Excel-like data presentation
- Comparing performance across dimensions

**PIVOT Benefits:**
- Easy visual comparison
- Compact data representation
- Simplified trend analysis
- Better for presentations
- Reduces scrolling in reports

**PIVOT Limitations:**
- Fixed column count (hard to automate for unknown values)
- Less flexible for filtering
- Can be wide with many categories
- Not ideal for detailed analysis
- Better suited for reporting than querying

---

## Real World Use Cases

1. **Sales Reporting**: Monthly/quarterly revenue by product line
2. **Regional Analysis**: Sales by territory across time periods
3. **Performance Dashboards**: KPIs displayed side-by-side
4. **Budget vs Actual**: Comparing planned vs actual by department
5. **Seasonal Analysis**: Identifying patterns across months/quarters
6. **Product Comparison**: Feature adoption across user segments
7. **Inventory Planning**: Stock levels by warehouse and month
8. **HR Analytics**: Headcount by department across quarters

---

## Key Learning Points

### SQL Techniques
- ✅ Conditional aggregation with CASE WHEN
- ✅ COALESCE for NULL handling
- ✅ GROUP BY with pivoted columns
- ✅ CTEs for complex transformations
- ✅ Window functions with PIVOT
- ✅ Percentage calculations in pivot tables

### Data Transformation
- ✅ Long to wide format conversion
- ✅ Cross-tabulation techniques
- ✅ Matrix-style data presentation
- ✅ Time-series pivoting
- ✅ Multi-dimensional analysis

### Best Practices
- ✅ Use COALESCE to handle missing values
- ✅ Include totals for context
- ✅ Sort by meaningful columns (usually totals)
- ✅ Limit columns for readability (max 8-10)
- ✅ Consider dynamic SQL for unknown columns
- ✅ Use CTEs for complex pivot operations

---

## Performance Tips

1. **Index on pivot columns**
```sql
CREATE INDEX idx_sales_month ON Sales(sale_month, sale_amount);
```

2. **Limit date ranges** to reduce pivot width
3. **Pre-aggregate** before pivoting for large datasets
4. **Use materialized views** for frequently-pivoted queries
5. **Consider partitioning** by time period for large tables

---

## Extension Ideas

- Add year-over-year comparisons
- Include variance analysis (actual vs target)
- Create rolling averages in pivot format
- Build dynamic PIVOT with stored procedures
- Add conditional formatting indicators
- Combine with UNPIVOT for bidirectional transformation
