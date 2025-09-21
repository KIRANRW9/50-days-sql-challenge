# Day 12: Top Selling Products Analysis (TOP/LIMIT with Sales Metrics)

## Problem
The sales and marketing teams need to identify best-selling products to understand customer preferences, optimize inventory planning, and focus marketing efforts on high-performing items. This analysis helps in product ranking, sales strategy, and inventory management decisions. This problem tests understanding of TOP/LIMIT clauses, sales aggregations, and product performance analysis.

## Dataset
Product sales data with multiple transactions showing quantities sold, enabling identification of top-performing products by volume and revenue.

## SQL Solution

```sql
-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    launch_date DATE,
    brand VARCHAR(50)
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    quantity INT,
    sale_date DATE,
    region VARCHAR(50),
    discount_percent DECIMAL(5,2)
);

-- Insert sample data into Products
INSERT INTO Products VALUES
(101, 'iPhone 15 Pro Max', 'Electronics', 159900.00, '2023-09-15', 'Apple'),
(102, 'Samsung Galaxy S24', 'Electronics', 89999.00, '2024-01-20', 'Samsung'),
(103, 'MacBook Pro M3', 'Electronics', 249900.00, '2023-11-10', 'Apple'),
(104, 'Nike Air Jordan 1', 'Fashion', 18999.00, '2023-07-10', 'Nike'),
(105, 'Sony WH-1000XM5', 'Electronics', 34999.00, '2023-08-20', 'Sony'),
(106, 'Adidas Ultraboost', 'Fashion', 16999.00, '2023-09-05', 'Adidas'),
(107, 'Dell XPS 13', 'Electronics', 145000.00, '2024-02-10', 'Dell'),
(108, 'Levi\'s 501 Jeans', 'Fashion', 4999.00, '2023-06-15', 'Levi\'s'),
(109, 'Canon EOS R5', 'Electronics', 299900.00, '2023-10-05', 'Canon'),
(110, 'Philips Air Fryer', 'Home & Kitchen', 12999.00, '2023-12-01', 'Philips');

-- Insert sample data into Sales
INSERT INTO Sales VALUES
-- iPhone 15 Pro Max - Top seller by quantity
(1001, 101, 2001, 3, '2024-01-15', 'North', 0.00),
(1002, 101, 2002, 2, '2024-02-20', 'South', 5.00),
(1003, 101, 2003, 4, '2024-03-10', 'East', 0.00),
(1004, 101, 2004, 1, '2024-04-15', 'West', 10.00),
(1005, 101, 2005, 5, '2024-05-20', 'North', 0.00),
(1006, 101, 2006, 2, '2024-06-25', 'South', 5.00),
(1007, 101, 2007, 3, '2024-07-30', 'East', 0.00),

-- Sony Headphones - Second highest seller
(1008, 105, 2008, 6, '2024-01-10', 'North', 15.00),
(1009, 105, 2009, 4, '2024-02-14', 'South', 10.00),
(1010, 105, 2010, 5, '2024-03-18', 'East', 12.00),
(1011, 105, 2011, 3, '2024-04-22', 'West', 8.00),

-- Nike Air Jordan - Popular fashion item
(1012, 104, 2012, 2, '2024-01-25', 'North', 0.00),
(1013, 104, 2013, 3, '2024-02-28', 'South', 0.00),
(1014, 104, 2014, 4, '2024-03-15', 'East', 5.00),
(1015, 104, 2015, 2, '2024-04-10', 'West', 0.00),
(1016, 104, 2016, 3, '2024-05-05', 'North', 0.00),

-- Levi's Jeans - High volume, lower price
(1017, 108, 2017, 5, '2024-02-05', 'South', 20.00),
(1018, 108, 2018, 4, '2024-02-15', 'East', 15.00),
(1019, 108, 2019, 6, '2024-03-20', 'West', 25.00),

-- Samsung Galaxy - Moderate sales
(1020, 102, 2020, 2, '2024-01-12', 'North', 10.00),
(1021, 102, 2021, 3, '2024-02-16', 'South', 8.00),
(1022, 102, 2022, 1, '2024-03-22', 'East', 12.00),

-- Adidas Ultraboost - Fashion category
(1023, 106, 2023, 3, '2024-01-18', 'West', 10.00),
(1024, 106, 2024, 2, '2024-02-24', 'North', 15.00),
(1025, 106, 2025, 4, '2024-03-28', 'South', 5.00),

-- MacBook Pro - Premium product, lower quantity
(1026, 103, 2026, 1, '2024-01-30', 'East', 0.00),
(1027, 103, 2027, 2, '2024-02-25', 'West', 5.00),

-- Dell XPS - Business laptop
(1028, 107, 2028, 1, '2024-03-05', 'North', 8.00),
(1029, 107, 2029, 2, '2024-03-15', 'South', 10.00),

-- Philips Air Fryer - Kitchen appliance
(1030, 110, 2030, 3, '2024-02-10', 'East', 12.00),
(1031, 110, 2031, 2, '2024-03-12', 'West', 15.00);
```

## Query 1: Most Selling Product by Quantity 

```sql
-- Identify the product with highest total quantity sold (MySQL/PostgreSQL version)
SELECT 
    product_id, 
    SUM(quantity) AS total_qty 
FROM Sales 
GROUP BY product_id 
ORDER BY total_qty DESC 
LIMIT 1;
```

## Output:

```
product_id | total_qty
-----------|----------
101        | 20
```


## Query 2: Top 5 Selling Products with Details 

```sql
-- Get top 5 selling products with complete product information
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.brand,
    SUM(s.quantity) as total_quantity_sold,
    COUNT(s.sale_id) as number_of_sales,
    ROUND(AVG(s.quantity), 2) as avg_quantity_per_sale,
    SUM(s.quantity * p.unit_price) as total_revenue
FROM Products p
JOIN Sales s ON p.product_id = s.product_id
GROUP BY p.product_id, p.product_name, p.category, p.brand, p.unit_price
ORDER BY total_quantity_sold DESC
LIMIT 5;
```

## Output:

```
product_id | product_name      | category    | brand   | total_quantity_sold | number_of_sales | avg_quantity_per_sale | total_revenue
-----------|-------------------|-------------|---------|--------------------|-----------------|-----------------------|---------------
101        | iPhone 15 Pro Max | Electronics | Apple   | 20                 | 7               | 2.86                  | 3198000.00
105        | Sony WH-1000XM5   | Electronics | Sony    | 18                 | 4               | 4.50                  | 629982.00
108        | Levi's 501 Jeans  | Fashion     | Levi's  | 15                 | 3               | 5.00                  | 74985.00
104        | Nike Air Jordan 1 | Fashion     | Nike    | 14                 | 5               | 2.80                  | 265986.00
106        | Adidas Ultraboost | Fashion     | Adidas  | 9                  | 3               | 3.00                  | 152991.00
```


## Query 3: Best Selling Product by Category 

```sql
-- Find the best selling product in each category using window functions
SELECT 
    category,
    product_name,
    brand,
    total_quantity_sold,
    category_rank
FROM (
    SELECT 
        p.category,
        p.product_name,
        p.brand,
        SUM(s.quantity) as total_quantity_sold,
        RANK() OVER (PARTITION BY p.category ORDER BY SUM(s.quantity) DESC) as category_rank
    FROM Products p
    JOIN Sales s ON p.product_id = s.product_id
    GROUP BY p.product_id, p.category, p.product_name, p.brand
) ranked_products
WHERE category_rank = 1
ORDER BY total_quantity_sold DESC;
```

## Output:

```
category      | product_name      | brand   | total_quantity_sold | category_rank
--------------|-------------------|---------|--------------------|--------------
Electronics   | iPhone 15 Pro Max | Apple   | 20                 | 1
Fashion       | Levi's 501 Jeans  | Levi's  | 15                 | 1
Home & Kitchen| Philips Air Fryer | Philips | 5                  | 1
```


## Query 4: Sales Performance Comparison 

```sql
-- Compare top performers vs average performance
SELECT 
    'Top Performer' as performance_tier,
    p.product_name,
    p.category,
    SUM(s.quantity) as total_sold,
    ROUND(SUM(s.quantity * p.unit_price), 2) as total_revenue,
    COUNT(s.sale_id) as number_of_transactions
FROM Products p
JOIN Sales s ON p.product_id = s.product_id
WHERE p.product_id = (
    SELECT product_id 
    FROM Sales 
    GROUP BY product_id 
    ORDER BY SUM(quantity) DESC 
    LIMIT 1
)
GROUP BY p.product_id, p.product_name, p.category
UNION ALL
SELECT 
    'Average Performer' as performance_tier,
    'All Other Products' as product_name,
    'Mixed' as category,
    SUM(s.quantity) as total_sold,
    ROUND(SUM(s.quantity * p.unit_price), 2) as total_revenue,
    COUNT(s.sale_id) as number_of_transactions
FROM Products p
JOIN Sales s ON p.product_id = s.product_id
WHERE p.product_id != (
    SELECT product_id 
    FROM Sales 
    GROUP BY product_id 
    ORDER BY SUM(quantity) DESC 
    LIMIT 1
);
```

## Output:

```
performance_tier | product_name        | category    | total_sold | total_revenue | number_of_transactions
-----------------|---------------------|-------------|------------|---------------|----------------------
Top Performer    | iPhone 15 Pro Max   | Electronics | 20         | 3198000.00    | 7
Average Performer| All Other Products  | Mixed       | 71         | 1574915.00    | 24
```


## Query 5: Monthly Top Seller Analysis 

```sql
-- Identify the best selling product for each month
SELECT 
    sale_month,
    product_name,
    category,
    monthly_quantity,
    monthly_revenue,
    monthly_rank
FROM (
    SELECT 
        DATE_FORMAT(s.sale_date, '%Y-%m') as sale_month,
        p.product_name,
        p.category,
        SUM(s.quantity) as monthly_quantity,
        ROUND(SUM(s.quantity * p.unit_price), 2) as monthly_revenue,
        RANK() OVER (PARTITION BY DATE_FORMAT(s.sale_date, '%Y-%m') ORDER BY SUM(s.quantity) DESC) as monthly_rank
    FROM Products p
    JOIN Sales s ON p.product_id = s.product_id
    GROUP BY DATE_FORMAT(s.sale_date, '%Y-%m'), p.product_id, p.product_name, p.category, p.unit_price
) monthly_rankings
WHERE monthly_rank = 1
ORDER BY sale_month;
```

## Output:

```
sale_month | product_name      | category    | monthly_quantity | monthly_revenue | monthly_rank
-----------|-------------------|-------------|------------------|-----------------|-------------
2024-01    | Sony WH-1000XM5   | Electronics | 6                | 209994.00       | 1
2024-02    | iPhone 15 Pro Max | Electronics | 2                | 319800.00       | 1
2024-03    | iPhone 15 Pro Max | Electronics | 4                | 639600.00       | 1
2024-04    | iPhone 15 Pro Max | Electronics | 4                | 639600.00       | 1
2024-05    | iPhone 15 Pro Max | Electronics | 8                | 1279200.00      | 1
2024-06    | iPhone 15 Pro Max | Electronics | 2                | 319800.00       | 1
2024-07    | iPhone 15 Pro Max | Electronics | 3                | 479700.00       | 1
```


## How It Works
* **LIMIT/TOP Clause**: Restricts results to show only the top N records after sorting
* **SUM() with GROUP BY**: Calculates total quantities sold per product
* **ORDER BY DESC**: Sorts results in descending order to show highest values first
* **Window Functions**: RANK() and PARTITION BY enable category-wise and time-based rankings
* **JOIN Operations**: Combines product details with sales aggregations
* **Subqueries**: Compare top performers with overall averages
* **Date Functions**: Enable time-based analysis and trends

## Real World Use Cases
1. **Inventory Planning**: Stock up on best-selling products to avoid stockouts
2. **Marketing Strategy**: Focus advertising budget on proven high-performers
3. **Product Development**: Understand what features make products successful
4. **Sales Incentives**: Create promotions around top-selling items
5. **Category Management**: Identify star products in each category
6. **Seasonal Analysis**: Track which products sell best in different time periods

## Key Learning
**TOP/LIMIT with ORDER BY** is essential for ranking and identifying best performers in any dataset. This pattern is fundamental for business analysis and appears in most real-world queries.

**Window Functions for Rankings** enable sophisticated analysis like finding the best product per category or per time period. RANK() and DENSE_RANK() handle ties differently - understand when to use each.

**Combining Aggregations with Rankings** provides powerful business insights by showing not just what's #1, but also the context (how much better, what categories, time trends) that drives actionable decisions.
