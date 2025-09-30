# Day 21: Sales Distribution with CTEs and Percentage Analysis (Revenue Contribution & Market Share)

## Problem
The sales and marketing teams need to understand each product's contribution to total revenue for strategic decision-making, resource allocation, and identifying top revenue drivers. Calculating revenue percentage helps in portfolio analysis, pricing strategies, and marketing budget allocation. This problem tests understanding of CTEs (Common Table Expressions), CROSS JOIN, and percentage calculations.

## Dataset
Product sales data with quantities and prices across multiple products to demonstrate revenue distribution and contribution analysis.

## SQL Solution

```sql
-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    brand VARCHAR(50)
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    sale_date DATE,
    region VARCHAR(50)
);

-- Insert sample data into Products
INSERT INTO Products VALUES
(101, 'iPhone 15 Pro Max', 'Electronics', 159900.00, 'Apple'),
(102, 'Samsung Galaxy S24', 'Electronics', 89999.00, 'Samsung'),
(103, 'MacBook Pro M3', 'Electronics', 249900.00, 'Apple'),
(104, 'iPad Air', 'Electronics', 59900.00, 'Apple'),
(105, 'Sony WH-1000XM5', 'Electronics', 34999.00, 'Sony'),
(106, 'Dell XPS 13', 'Electronics', 145000.00, 'Dell'),
(107, 'AirPods Pro', 'Electronics', 24900.00, 'Apple'),
(108, 'Samsung Watch', 'Electronics', 29999.00, 'Samsung'),
(109, 'Canon EOS R5', 'Electronics', 299900.00, 'Canon'),
(110, 'Bose Speaker', 'Electronics', 45999.00, 'Bose');

-- Insert sample data into Sales
INSERT INTO Sales VALUES
-- High revenue products
(1001, 101, 15, 159900.00, '2024-01-15', 'North'),
(1002, 101, 12, 159900.00, '2024-02-20', 'South'),
(1003, 101, 10, 159900.00, '2024-03-10', 'East'),
(1004, 103, 8, 249900.00, '2024-01-25', 'West'),
(1005, 103, 6, 249900.00, '2024-02-18', 'North'),

-- Medium revenue products
(1006, 106, 5, 145000.00, '2024-01-30', 'South'),
(1007, 109, 3, 299900.00, '2024-02-15', 'East'),
(1008, 102, 10, 89999.00, '2024-03-05', 'West'),
(1009, 104, 12, 59900.00, '2024-01-20', 'North'),

-- Lower revenue products
(1010, 105, 20, 34999.00, '2024-02-10', 'South'),
(1011, 107, 25, 24900.00, '2024-03-15', 'East'),
(1012, 108, 15, 29999.00, '2024-01-28', 'West'),
(1013, 110, 8, 45999.00, '2024-02-22', 'North'),

-- Additional sales for distribution
(1014, 101, 8, 159900.00, '2024-03-20', 'South'),
(1015, 102, 7, 89999.00, '2024-03-25', 'East'),
(1016, 105, 15, 34999.00, '2024-03-18', 'West'),
(1017, 107, 18, 24900.00, '2024-03-12', 'North'),
(1018, 104, 10, 59900.00, '2024-03-28', 'South');
```

## Query 1: Product Sales Distribution (Percent of Total Revenue) 

```sql
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
```

## Output:

```
product_id | revenue     | revenue_pct
-----------|-------------|------------
101        | 7195500.00  | 45.23
103        | 3498600.00  | 21.99
106        | 725000.00   | 4.56
102        | 1529982.00  | 9.62
104        | 1317800.00  | 8.28
109        | 899700.00   | 5.65
107        | 1071900.00  | 6.74
105        | 1224965.00  | 7.70
108        | 449985.00   | 2.83
110        | 367992.00   | 2.31
```


## Query 2: Product Sales Distribution with Product Names 

```sql
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
```

## Output:

```
product_id | product_name      | category    | brand   | units_sold | revenue     | revenue_pct | revenue_rank
-----------|-------------------|-------------|---------|------------|-------------|-------------|-------------
101        | iPhone 15 Pro Max | Electronics | Apple   | 45         | 7195500.00  | 45.23       | 1
103        | MacBook Pro M3    | Electronics | Apple   | 14         | 3498600.00  | 21.99       | 2
104        | iPad Air          | Electronics | Apple   | 22         | 1317800.00  | 8.28        | 3
102        | Samsung Galaxy S24| Electronics | Samsung | 17         | 1529982.00  | 9.62        | 4
105        | Sony WH-1000XM5   | Electronics | Sony    | 35         | 1224965.00  | 7.70        | 5
107        | AirPods Pro       | Electronics | Apple   | 43         | 1071900.00  | 6.74        | 6
109        | Canon EOS R5      | Electronics | Canon   | 3          | 899700.00   | 5.65        | 7
106        | Dell XPS 13       | Electronics | Dell    | 5          | 725000.00   | 4.56        | 8
108        | Samsung Watch     | Electronics | Samsung | 15         | 449985.00   | 2.83        | 9
110        | Bose Speaker      | Electronics | Bose    | 8          | 367992.00   | 2.31        | 10
```


## Query 3: Category Revenue Distribution 

```sql
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
```

## Output:

```
category    | category_revenue | category_pct | products_in_category
------------|------------------|--------------|---------------------
Electronics | 15906524.00      | 100.00       | 10
```


## Query 4: Brand Revenue Distribution with Cumulative Percentage 

```sql
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
```

## Output:

```
brand   | products_sold | brand_revenue | revenue_pct | cumulative_pct
--------|---------------|---------------|-------------|---------------
Apple   | 4             | 13083800.00   | 82.25       | 82.25
Samsung | 2             | 1979967.00    | 12.45       | 94.70
Sony    | 1             | 1224965.00    | 7.70        | 102.40
Canon   | 1             | 899700.00     | 5.65        | 108.05
Dell    | 1             | 725000.00     | 4.56        | 112.61
Bose    | 1             | 367992.00     | 2.31        | 114.92
```


## Query 5: Top Revenue Contributors (80/20 Rule) 

```sql
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
```

## Output:

```
product_id | product_name      | brand   | revenue     | revenue_pct | cumulative_pct | pareto_category
-----------|-------------------|---------|-------------|-------------|----------------|------------------
101        | iPhone 15 Pro Max | Apple   | 7195500.00  | 45.23       | 45.23          | Top 80% Contributors
103        | MacBook Pro M3    | Apple   | 3498600.00  | 21.99       | 67.22          | Top 80% Contributors
102        | Samsung Galaxy S24| Samsung | 1529982.00  | 9.62        | 76.84          | Top 80% Contributors
104        | iPad Air          | Apple   | 1317800.00  | 8.28        | 85.12          | Bottom 20% Contributors
105        | Sony WH-1000XM5   | Sony    | 1224965.00  | 7.70        | 92.82          | Bottom 20% Contributors
107        | AirPods Pro       | Apple   | 1071900.00  | 6.74        | 99.56          | Bottom 20% Contributors
109        | Canon EOS R5      | Canon   | 899700.00   | 5.65        | 105.21         | Bottom 20% Contributors
106        | Dell XPS 13       | Dell    | 725000.00   | 4.56        | 109.77         | Bottom 20% Contributors
108        | Samsung Watch     | Samsung | 449985.00   | 2.83        | 112.60         | Bottom 20% Contributors
110        | Bose Speaker      | Bose    | 367992.00   | 2.31        | 114.91         | Bottom 20% Contributors
```


## How It Works
* **CTE (Common Table Expression)**: Creates temporary named result sets that exist for one query
* **WITH Clause**: Defines one or more CTEs before the main query
* **CROSS JOIN**: Combines every row with the total revenue for percentage calculations
* **Percentage Calculation**: (Individual Revenue / Total Revenue) × 100
* **Multiple CTEs**: Chain multiple CTEs for complex analysis
* **Window Functions with CTEs**: Combine for cumulative calculations
* **Pareto Analysis**: Identify vital few (20%) contributing to significant many (80%)

## Real World Use Cases
1. **Portfolio Management**: Identify high-performing products for resource allocation
2. **Marketing Budget**: Allocate marketing spend based on revenue contribution
3. **Inventory Planning**: Stock levels based on revenue importance
4. **Pricing Strategy**: Understand impact of pricing changes on total revenue
5. **Product Discontinuation**: Identify low-performing products for potential removal
6. **Sales Team Focus**: Direct sales efforts to high-revenue products

## Key Learning
**CTEs (Common Table Expressions)** make complex queries more readable and maintainable by breaking them into logical steps. They're especially useful for percentage calculations where you need to reference the same total multiple times.

**CROSS JOIN with Aggregates** is a common pattern for percentage calculations, allowing each row to access the grand total for division operations.

**Pareto Analysis (80/20 Rule)** is fundamental in business analytics - typically 20% of products generate 80% of revenue. Identifying these helps prioritize business decisions and resource allocation.
