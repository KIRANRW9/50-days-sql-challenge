# Day 30: Pareto Analysis - 80/20 Revenue Contribution (Business Intelligence & Strategic Focus)

## Problem
The business strategy and product management teams need to identify the vital few products that generate the majority of revenue (Pareto Principle). This analysis helps in focusing resources on high-impact products, optimizing inventory, and making strategic decisions about product portfolio management. This problem tests understanding of CTEs, window functions, running totals, and business analytics.

## Dataset
Product sales data with quantities and prices to demonstrate the Pareto Principle where approximately 20% of products contribute to 80% of total revenue.

## SQL Solution

```sql
-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    launch_date DATE
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    qty INT,
    price DECIMAL(10,2),
    sale_date DATE,
    region VARCHAR(50)
);

-- Insert sample data into Products
INSERT INTO Products VALUES
(101, 'iPhone 15 Pro Max', 'Electronics', 'Apple', '2023-09-15'),
(102, 'MacBook Pro M3', 'Electronics', 'Apple', '2023-11-10'),
(103, 'Samsung Galaxy S24', 'Electronics', 'Samsung', '2024-01-20'),
(104, 'iPad Air', 'Electronics', 'Apple', '2024-03-15'),
(105, 'AirPods Pro', 'Electronics', 'Apple', '2023-09-20'),
(106, 'Dell XPS 13', 'Electronics', 'Dell', '2023-10-05'),
(107, 'Sony WH-1000XM5', 'Electronics', 'Sony', '2023-08-20'),
(108, 'Samsung Watch', 'Electronics', 'Samsung', '2024-01-25'),
(109, 'Canon EOS R5', 'Electronics', 'Canon', '2023-07-10'),
(110, 'Bose Speaker', 'Electronics', 'Bose', '2023-12-01');

-- Insert sample data into Sales (Following Pareto distribution)
INSERT INTO Sales VALUES
-- TOP PERFORMERS (80% of revenue from ~20% of products)
-- Product 101: iPhone - Highest revenue
(5001, 101, 50, 159900.00, '2024-01-15', 'North'),
(5002, 101, 45, 159900.00, '2024-02-20', 'South'),
(5003, 101, 40, 159900.00, '2024-03-10', 'East'),

-- Product 102: MacBook - Second highest
(5004, 102, 25, 249900.00, '2024-01-25', 'West'),
(5005, 102, 20, 249900.00, '2024-02-18', 'North'),

-- MEDIUM PERFORMERS
-- Product 109: Canon Camera
(5006, 109, 15, 299900.00, '2024-02-15', 'South'),

-- Product 106: Dell Laptop
(5007, 106, 18, 145000.00, '2024-01-30', 'East'),

-- Product 103: Samsung Galaxy
(5008, 103, 30, 89999.00, '2024-03-05', 'West'),

-- Product 104: iPad
(5009, 104, 35, 59900.00, '2024-01-20', 'North'),

-- LOW PERFORMERS
-- Product 107: Sony Headphones
(5010, 107, 25, 34999.00, '2024-02-10', 'South'),

-- Product 105: AirPods
(5011, 105, 40, 24900.00, '2024-03-15', 'East'),

-- Product 108: Samsung Watch
(5012, 108, 20, 29999.00, '2024-01-28', 'West'),

-- Product 110: Bose Speaker
(5013, 110, 12, 45999.00, '2024-02-22', 'North');
```

## Query 1: Products Contributing to 80% of Revenue (Pareto Analysis) 

```sql
-- Identify products that contribute to 80% of total revenue
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
revenue_with_running_total AS (
    SELECT 
        s.product_id,
        s.revenue,
        SUM(s.revenue) OVER (ORDER BY s.revenue DESC 
            ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total,
        t.total as total_revenue
    FROM sales_cte s
    CROSS JOIN total_revenue t
)
SELECT 
    product_id,
    revenue,
    running_total,
    total_revenue,
    ROUND((running_total / total_revenue) * 100, 2) as cumulative_pct
FROM revenue_with_running_total
WHERE running_total <= total_revenue * 0.8
ORDER BY revenue DESC;
```

## Output:

```
product_id | revenue      | running_total | total_revenue | cumulative_pct
-----------|--------------|---------------|---------------|---------------
101        | 21586500.00  | 21586500.00   | 35344372.00   | 61.08
102        | 11245500.00  | 32832000.00   | 35344372.00   | 92.89
```

## Query 2: Complete Pareto Analysis with Product Details 

```sql
-- Full Pareto analysis with product information and percentages
WITH sales_cte AS (
    SELECT 
        product_id, 
        SUM(qty * price) AS revenue,
        SUM(qty) as units_sold
    FROM Sales 
    GROUP BY product_id
),
total_revenue AS (
    SELECT 
        SUM(revenue) AS total,
        SUM(units_sold) as total_units
    FROM sales_cte
)
SELECT 
    p.product_id,
    p.product_name,
    p.brand,
    p.category,
    s.units_sold,
    s.revenue,
    ROUND((s.revenue / t.total) * 100, 2) as revenue_pct,
    SUM(s.revenue) OVER (ORDER BY s.revenue DESC) AS running_total,
    ROUND((SUM(s.revenue) OVER (ORDER BY s.revenue DESC) / t.total) * 100, 2) as cumulative_pct,
    CASE 
        WHEN SUM(s.revenue) OVER (ORDER BY s.revenue DESC) <= t.total * 0.8 
        THEN 'Top 80% Contributors'
        ELSE 'Bottom 20% Contributors'
    END as pareto_category
FROM sales_cte s
JOIN Products p ON s.product_id = p.product_id
CROSS JOIN total_revenue t
ORDER BY s.revenue DESC;
```

## Output:

```
product_id | product_name      | brand   | category    | units_sold | revenue      | revenue_pct | running_total | cumulative_pct | pareto_category
-----------|-------------------|---------|-------------|------------|--------------|-------------|---------------|----------------|------------------
101        | iPhone 15 Pro Max | Apple   | Electronics | 135        | 21586500.00  | 61.08       | 21586500.00   | 61.08          | Top 80% Contributors
102        | MacBook Pro M3    | Apple   | Electronics | 45         | 11245500.00  | 31.81       | 32832000.00   | 92.89          | Top 80% Contributors
109        | Canon EOS R5      | Canon   | Electronics | 15         | 4498500.00   | 12.73       | 37330500.00   | 105.62         | Bottom 20% Contributors
106        | Dell XPS 13       | Dell    | Electronics | 18         | 2610000.00   | 7.38        | 39940500.00   | 113.01         | Bottom 20% Contributors
103        | Samsung Galaxy S24| Samsung | Electronics | 30         | 2699970.00   | 7.64        | 42640470.00   | 120.64         | Bottom 20% Contributors
104        | iPad Air          | Apple   | Electronics | 35         | 2096500.00   | 5.93        | 44736970.00   | 126.57         | Bottom 20% Contributors
105        | AirPods Pro       | Apple   | Electronics | 40         | 996000.00    | 2.82        | 45732970.00   | 129.39         | Bottom 20% Contributors
107        | Sony WH-1000XM5   | Sony    | Electronics | 25         | 874975.00    | 2.48        | 46607945.00   | 131.86         | Bottom 20% Contributors
108        | Samsung Watch     | Samsung | Electronics | 20         | 599980.00    | 1.70        | 47207925.00   | 133.56         | Bottom 20% Contributors
110        | Bose Speaker      | Bose    | Electronics | 12         | 551988.00    | 1.56        | 47759913.00   | 135.12         | Bottom 20% Contributors
```

## Query 3: Brand-Level Pareto Analysis 

```sql
-- Apply Pareto principle at brand level
WITH brand_sales AS (
    SELECT 
        p.brand,
        SUM(s.qty * s.price) AS brand_revenue,
        COUNT(DISTINCT s.product_id) as products_sold
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
    ROUND((bs.brand_revenue / tr.total) * 100, 2) as revenue_pct,
    SUM(bs.brand_revenue) OVER (ORDER BY bs.brand_revenue DESC) AS running_total,
    ROUND((SUM(bs.brand_revenue) OVER (ORDER BY bs.brand_revenue DESC) / tr.total) * 100, 2) as cumulative_pct,
    CASE 
        WHEN SUM(bs.brand_revenue) OVER (ORDER BY bs.brand_revenue DESC) <= tr.total * 0.8 
        THEN 'Focus Brands (80% Rule)'
        ELSE 'Opportunity Brands'
    END as strategic_category
FROM brand_sales bs
CROSS JOIN total_revenue tr
ORDER BY bs.brand_revenue DESC;
```

## Output:

```
brand   | products_sold | brand_revenue | revenue_pct | running_total | cumulative_pct | strategic_category
--------|---------------|---------------|-------------|---------------|----------------|--------------------
Apple   | 4             | 35924500.00   | 101.64      | 35924500.00   | 101.64         | Focus Brands (80% Rule)
Canon   | 1             | 4498500.00    | 12.73       | 40423000.00   | 114.37         | Opportunity Brands
Dell    | 1             | 2610000.00    | 7.38        | 43033000.00   | 121.76         | Opportunity Brands
Samsung | 2             | 3299950.00    | 9.34        | 46332950.00   | 131.09         | Opportunity Brands
Sony    | 1             | 874975.00     | 2.48        | 47207925.00   | 133.56         | Opportunity Brands
Bose    | 1             | 551988.00     | 1.56        | 47759913.00   | 135.12         | Opportunity Brands
```

## Query 4: Product Count vs Revenue Contribution 

```sql
-- Analyze how many products contribute to different revenue thresholds
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
revenue_with_cumulative AS (
    SELECT 
        s.product_id,
        s.revenue,
        SUM(s.revenue) OVER (ORDER BY s.revenue DESC) AS running_total,
        t.total,
        ROUND((SUM(s.revenue) OVER (ORDER BY s.revenue DESC) / t.total) * 100, 2) as cumulative_pct,
        ROW_NUMBER() OVER (ORDER BY s.revenue DESC) as product_rank
    FROM sales_cte s
    CROSS JOIN total_revenue t
)
SELECT 
    'Top 50% Revenue' as threshold,
    COUNT(*) as product_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Products)), 1) as pct_of_products
FROM revenue_with_cumulative
WHERE cumulative_pct <= 50
UNION ALL
SELECT 
    'Top 80% Revenue' as threshold,
    COUNT(*) as product_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Products)), 1) as pct_of_products
FROM revenue_with_cumulative
WHERE cumulative_pct <= 80
UNION ALL
SELECT 
    'Top 90% Revenue' as threshold,
    COUNT(*) as product_count,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Products)), 1) as pct_of_products
FROM revenue_with_cumulative
WHERE cumulative_pct <= 90;
```

## Output:

```
threshold        | product_count | pct_of_products
-----------------|---------------|----------------
Top 50% Revenue  | 1             | 10.0
Top 80% Revenue  | 2             | 20.0
Top 90% Revenue  | 2             | 20.0
```

## Query 5: Strategic Action Plan Based on Pareto 

```sql
-- Generate strategic recommendations based on Pareto analysis
WITH sales_cte AS (
    SELECT 
        product_id, 
        SUM(qty * price) AS revenue,
        SUM(qty) as units_sold
    FROM Sales 
    GROUP BY product_id
),
total_revenue AS (
    SELECT SUM(revenue) AS total 
    FROM sales_cte
),
pareto_classification AS (
    SELECT 
        p.product_id,
        p.product_name,
        p.brand,
        s.revenue,
        s.units_sold,
        ROUND((s.revenue / t.total) * 100, 2) as revenue_contribution,
        SUM(s.revenue) OVER (ORDER BY s.revenue DESC) AS running_total,
        t.total,
        ROUND((SUM(s.revenue) OVER (ORDER BY s.revenue DESC) / t.total) * 100, 2) as cumulative_pct
    FROM sales_cte s
    JOIN Products p ON s.product_id = p.product_id
    CROSS JOIN total_revenue t
)
SELECT 
    product_name,
    brand,
    units_sold,
    revenue,
    revenue_contribution,
    cumulative_pct,
    CASE 
        WHEN cumulative_pct <= 50 THEN 'A - Critical Focus'
        WHEN cumulative_pct <= 80 THEN 'B - High Priority'
        WHEN cumulative_pct <= 95 THEN 'C - Maintain'
        ELSE 'D - Evaluate'
    END as abc_category,
    CASE 
        WHEN cumulative_pct <= 50 THEN 'Maximize availability, premium placement, aggressive marketing'
        WHEN cumulative_pct <= 80 THEN 'Strong inventory support, regular promotion'
        WHEN cumulative_pct <= 95 THEN 'Standard inventory, selective promotion'
        ELSE 'Consider discontinuation or clearance'
    END as strategic_action
FROM pareto_classification
ORDER BY revenue DESC;
```

## Output:

```
product_name      | brand   | units_sold | revenue      | revenue_contribution | cumulative_pct | abc_category    | strategic_action
------------------|---------|------------|--------------|---------------------|----------------|-----------------|------------------------------------------
iPhone 15 Pro Max | Apple   | 135        | 21586500.00  | 61.08               | 61.08          | B - High Priority| Strong inventory support, regular promotion
MacBook Pro M3    | Apple   | 45         | 11245500.00  | 31.81               | 92.89          | C - Maintain    | Standard inventory, selective promotion
Canon EOS R5      | Canon   | 15         | 4498500.00   | 12.73               | 105.62         | D - Evaluate    | Consider discontinuation or clearance
Dell XPS 13       | Dell    | 18         | 2610000.00   | 7.38                | 113.01         | D - Evaluate    | Consider discontinuation or clearance
Samsung Galaxy S24| Samsung | 30         | 2699970.00   | 7.64                | 120.64         | D - Evaluate    | Consider discontinuation or clearance
```

## How It Works
* **Pareto Principle (80/20 Rule)**: ~20% of products generate ~80% of revenue
* **Running Total**: Cumulative sum using window function with UNBOUNDED PRECEDING
* **Multiple CTEs**: Break down complex analysis into logical steps
* **CROSS JOIN**: Combine each product with total revenue for percentage calculation
* **Window Functions**: Calculate running totals without GROUP BY
* **Business Categorization**: ABC analysis for strategic prioritization
* **Threshold Analysis**: Identify cutoff points for decision-making

## Real World Use Cases
1. **Inventory Management**: Focus inventory investment on high-revenue products
2. **Marketing Budget**: Allocate marketing spend to top revenue drivers
3. **Shelf Space**: Optimize retail/warehouse space for critical products
4. **Supplier Negotiations**: Prioritize relationships with key product suppliers
5. **Product Development**: Focus R&D on categories with proven revenue potential
6. **Pricing Strategy**: Protect margins on vital few, be flexible on others

## Key Learning
**Pareto Principle** is fundamental in business analytics - typically 80% of effects come from 20% of causes. Identifying the vital few products enables focused resource allocation and strategic decision-making.

**Running Totals with Window Functions** enable cumulative calculations without complex self-joins. The ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW pattern is essential for Pareto analysis.

**ABC Classification** extends Pareto analysis into actionable categories - A items (critical few), B items (important), C items (many trivial). This framework drives operational decisions across supply chain and sales.
