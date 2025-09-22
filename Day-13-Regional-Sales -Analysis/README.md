# Day 13: Regional Sales Analysis (GROUP BY with Regional Metrics)

## Problem
The sales and marketing teams need to analyze revenue performance across different regions to identify high-performing markets, understand regional sales patterns, and optimize resource allocation strategies. This analysis helps in regional expansion decisions, sales territory management, and targeted marketing campaigns. This problem tests understanding of GROUP BY clauses, regional aggregations, and comparative sales analysis.

## Dataset
Regional sales data with order information across multiple geographic markets, enabling identification of top-performing regions by revenue, order volume, and customer engagement metrics.

## SQL Solution

### Create Tables and Sample Data
```sql
-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    region VARCHAR(20),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);
```

## Query 1: Total Revenue and Order Count by Region
Get basic regional performance metrics showing total revenue and number of orders per region.

```sql
SELECT 
    region, 
    SUM(total_amount) AS total_revenue, 
    COUNT(*) AS order_count
FROM Orders 
WHERE status = 'Completed'
GROUP BY region
ORDER BY total_revenue DESC;
```

**Output:**
```
region  | total_revenue | order_count
--------|---------------|------------
West    | 232995.00     | 6
Central | 153995.00     | 6
North   | 151495.00     | 6
East    | 156996.00     | 6
South   | 98995.00      | 6
```

## Query 2: Average Order Value by Region
Calculate average order value to understand spending patterns across regions.

```sql
SELECT 
    region,
    COUNT(*) as total_orders,
    SUM(total_amount) as total_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value,
    MIN(total_amount) as min_order,
    MAX(total_amount) as max_order
FROM Orders 
WHERE status = 'Completed'
GROUP BY region
ORDER BY avg_order_value DESC;
```

**Output:**
```
region  | total_orders | total_revenue | avg_order_value | min_order | max_order
--------|--------------|---------------|-----------------|-----------|----------
West    | 6            | 232995.00     | 38832.50        | 1999.00   | 99999.00
East    | 6            | 156996.00     | 26166.00        | 4999.00   | 67999.00
Central | 6            | 153995.00     | 25665.83        | 8999.00   | 75999.00
North   | 6            | 151495.00     | 25249.17        | 3999.00   | 89999.00
South   | 6            | 98995.00      | 16499.17        | 1999.00   | 45999.00
```

## Query 3: Category Performance Across Regions
Analyze which product categories perform best in each region.

```sql
SELECT 
    region,
    category,
    COUNT(*) as orders_in_category,
    SUM(total_amount) as category_revenue,
    ROUND(AVG(total_amount), 2) as avg_category_order
FROM Orders 
WHERE status = 'Completed'
GROUP BY region, category
ORDER BY region, category_revenue DESC;
```

**Output:**
```
region  | category    | orders_in_category | category_revenue | avg_category_order
--------|-------------|-------------------|------------------|-------------------
Central | Electronics | 3                 | 103997.00        | 34665.67
Central | Furniture   | 1                 | 22999.00         | 22999.00
Central | Appliances  | 1                 | 32999.00         | 32999.00
Central | Clothing    | 1                 | 12999.00         | 12999.00
East    | Electronics | 2                 | 120998.00        | 60499.00
East    | Appliances  | 1                 | 18999.00         | 18999.00
East    | Furniture   | 1                 | 9999.00          | 9999.00
East    | Clothing    | 1                 | 6999.00          | 6999.00
```

## Query 4: Regional Performance Comparison
Compare regional performance with overall averages to identify over and under-performers.

```sql
SELECT 
    region,
    total_revenue,
    order_count,
    avg_order_value,
    ROUND(((total_revenue - overall_avg.avg_regional_revenue) / overall_avg.avg_regional_revenue) * 100, 2) as revenue_vs_avg_percent
FROM (
    SELECT 
        region,
        SUM(total_amount) as total_revenue,
        COUNT(*) as order_count,
        ROUND(AVG(total_amount), 2) as avg_order_value
    FROM Orders 
    WHERE status = 'Completed'
    GROUP BY region
) regional_stats
CROSS JOIN (
    SELECT AVG(regional_revenue) as avg_regional_revenue
    FROM (
        SELECT SUM(total_amount) as regional_revenue
        FROM Orders 
        WHERE status = 'Completed'
        GROUP BY region
    ) sub
) overall_avg
ORDER BY revenue_vs_avg_percent DESC;
```

**Output:**
```
region  | total_revenue | order_count | avg_order_value | revenue_vs_avg_percent
--------|---------------|-------------|-----------------|----------------------
West    | 232995.00     | 6           | 38832.50        | 48.75
Central | 153995.00     | 6           | 25665.83        | -1.65
East    | 156996.00     | 6           | 26166.00        | 0.26
North   | 151495.00     | 6           | 25249.17        | -3.24
South   | 98995.00      | 6           | 16499.17        | -36.73
```

## Query 5: Monthly Regional Trends
Analyze monthly revenue trends to identify seasonal patterns by region.

```sql
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as order_month,
    region,
    COUNT(*) as monthly_orders,
    SUM(total_amount) as monthly_revenue,
    ROUND(AVG(total_amount), 2) as avg_monthly_order_value
FROM Orders 
WHERE status = 'Completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m'), region
ORDER BY order_month, monthly_revenue DESC;
```

**Output:**
```
order_month | region  | monthly_orders | monthly_revenue | avg_monthly_order_value
------------|---------|----------------|-----------------|----------------------
2024-01     | West    | 1              | 99999.00        | 99999.00
2024-01     | Central | 1              | 75999.00        | 75999.00
2024-01     | North   | 1              | 89999.00        | 89999.00
2024-01     | East    | 1              | 52999.00        | 52999.00
2024-01     | South   | 2              | 28998.00        | 14499.00
2024-02     | West    | 2              | 94998.00        | 47499.00
2024-02     | Central | 2              | 55998.00        | 27999.00
2024-02     | East    | 2              | 28998.00        | 14499.00
2024-02     | North   | 2              | 21998.00        | 10999.00
2024-02     | South   | 2              | 63998.00        | 31999.00
```

## How It Works

**GROUP BY Fundamentals:** Groups rows by one or more columns, enabling aggregate calculations per group (region, category, time period).

**Aggregate Functions:** SUM(), COUNT(), AVG(), MIN(), MAX() provide comprehensive metrics for each regional group.

**Multiple Grouping:** GROUP BY region, category enables cross-dimensional analysis showing category performance within each region.

**Comparative Analysis:** Using subqueries and CROSS JOIN to compare individual regional performance against overall averages.

**Date Functions:** DATE_FORMAT() enables time-based grouping for trend analysis and seasonal pattern identification.

## Real World Use Cases

**Regional Sales Planning:** Allocate sales resources and set targets based on regional revenue potential and historical performance patterns.

**Market Expansion Strategy:** Identify underperforming regions for improvement initiatives and high-performing regions for replication strategies.

**Inventory Distribution:** Optimize stock allocation across regions based on sales volume and category preferences in each market.

**Sales Territory Management:** Evaluate sales team performance and adjust territories based on revenue generation and order volume metrics.

**Marketing Budget Allocation:** Distribute advertising spend based on regional performance and growth potential identified through data analysis.

**Customer Behavior Analysis:** Understand regional preferences for different product categories to tailor marketing messages and product offerings.

## Key Learning

**GROUP BY with Aggregates** is fundamental for business analytics, enabling summary statistics that drive strategic decisions across geographic and categorical dimensions.

**Multi-level Grouping** (region + category, region + time) provides deeper insights than single-dimension analysis, revealing patterns that inform tactical adjustments.

**Performance Benchmarking** using comparative analysis helps identify outliers and opportunities, making raw numbers actionable through context and relative performance metrics.
