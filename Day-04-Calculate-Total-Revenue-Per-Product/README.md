# Day 04: Calculate Total Revenue Per Product (GROUP BY Usage)

## Problem
The sales department needs to analyze revenue performance by product to identify top-selling items, understand product profitability, and make data-driven decisions for inventory management and marketing strategies. This problem tests understanding of GROUP BY clause and aggregate functions.

## Dataset
Sales transaction data with multiple records per product showing quantities sold and prices.

## SQL Solution

```sql
-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    sale_date DATE,
    customer_id INT
);

-- Insert sample data into Products 
INSERT INTO Products VALUES
(1, 'iPhone 16 Pro Max', 'Electronics', 159900.00),
(2, 'Samsung Galaxy S25 Ultra', 'Electronics', 139999.00),
(3, 'MacBook Pro M4', 'Electronics', 249900.00),
(4, 'Dell XPS 15', 'Electronics', 185000.00),
(5, 'Sony WH-1000XM6', 'Electronics', 34999.00),
(6, 'Nike Air Jordan 1 High', 'Fashion', 18999.00),
(7, 'Adidas Yeezy Boost 350 V3', 'Fashion', 25999.00);

-- Insert sample data into Sales 
INSERT INTO Sales VALUES
(1, 1, 2, 159900.00, '2025-07-15', 101),
(2, 1, 1, 159900.00, '2025-07-20', 102),
(3, 2, 3, 139999.00, '2025-07-25', 103),
(4, 3, 1, 249900.00, '2025-08-10', 104),
(5, 1, 1, 159900.00, '2025-08-14', 105),
(6, 4, 2, 185000.00, '2025-08-20', 106),
(7, 5, 4, 34999.00, '2025-08-25', 107),
(8, 2, 1, 139999.00, '2025-09-01', 108),
(9, 6, 3, 18999.00, '2025-09-05', 109),
(10, 7, 2, 25999.00, '2025-09-08', 110),
(11, 3, 1, 249900.00, '2025-09-10', 111),
(12, 1, 1, 159900.00, '2025-09-12', 112);
```

## Query 1: Calculate Total Revenue Per Product (Basic GROUP BY)

```sql
SELECT 
    product_id, 
    SUM(quantity * price) AS total_revenue 
FROM Sales 
GROUP BY product_id 
ORDER BY total_revenue DESC;
```

## Output:

```
product_id | total_revenue
-----------|---------------
1          | 799500.00
2          | 559996.00
3          | 499800.00
4          | 370000.00
5          | 139996.00
6          | 56997.00
7          | 51998.00
```

## Query 2: Revenue Per Product with Product Names

```sql
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    SUM(s.quantity * s.price) AS total_revenue,
    SUM(s.quantity) AS total_units_sold
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name, p.category
ORDER BY total_revenue DESC;
```

## Output:

```
product_id | product_name                 | category    | total_revenue | total_units_sold
-----------|------------------------------|-------------|---------------|------------------
1          | iPhone 16 Pro Max            | Electronics | 799500.00     | 5
2          | Samsung Galaxy S25 Ultra     | Electronics | 559996.00     | 4
3          | MacBook Pro M4               | Electronics | 499800.00     | 2
4          | Dell XPS 15                  | Electronics | 370000.00     | 2
5          | Sony WH-1000XM6              | Electronics | 139996.00     | 4
6          | Nike Air Jordan 1 High       | Fashion     | 56997.00      | 3
7          | Adidas Yeezy Boost 350 V3    | Fashion     | 51998.00      | 2
```

## Query 3: Revenue by Category

```sql
SELECT 
    p.category,
    COUNT(DISTINCT p.product_id) as products_count,
    SUM(s.quantity * s.price) AS category_revenue,
    AVG(s.quantity * s.price) AS avg_transaction_value
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY category_revenue DESC;
```

## Output:

```
category    | products_count | category_revenue | avg_transaction_value
------------|----------------|------------------|----------------------
Electronics | 5              | 2369292.00       | 236929.20
Fashion     | 2              | 108995.00        | 54497.50
```

## Query 4: Top 3 Products by Revenue

```sql
SELECT 
    p.product_name,
    SUM(s.quantity * s.price) AS total_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
LIMIT 3;
```

## Output:

```
product_name                  | total_revenue
------------------------------|---------------
iPhone 16 Pro Max             | 799500.00
Samsung Galaxy S25 Ultra      | 559996.00
MacBook Pro M4                | 499800.00
```

## Query 5: Products with Revenue Above Average

```sql
SELECT 
    p.product_name,
    SUM(s.quantity * s.price) AS total_revenue
FROM Sales s
JOIN Products p ON s.product_id = p.product_id
GROUP BY p.product_id, p.product_name
HAVING SUM(s.quantity * s.price) > (
    SELECT AVG(product_revenue) 
    FROM (
        SELECT SUM(quantity * price) as product_revenue 
        FROM Sales 
        GROUP BY product_id
    ) as avg_calc
)
ORDER BY total_revenue DESC;
```

## Output:

```
product_name                  | total_revenue
------------------------------|---------------
iPhone 16 Pro Max             | 799500.00
Samsung Galaxy S25 Ultra      | 559996.00
MacBook Pro M4                | 499800.00
Dell XPS 15                   | 370000.00
```

## How It Works
* **GROUP BY**: Groups rows by product_id to aggregate sales data per product
* **SUM(quantity * price)**: Calculates total revenue by multiplying quantity sold by price for each transaction
* **Aggregate Functions**: COUNT, SUM, AVG work on grouped data to provide summary statistics
* **HAVING Clause**: Filters groups based on aggregate conditions (unlike WHERE which filters individual rows)
* **ORDER BY**: Sorts results by revenue to identify top performers

## Real World Use Cases
1. **Product Performance Analysis**: Identify best and worst performing products
2. **Inventory Management**: Focus on high-revenue products for stock planning
3. **Marketing Strategy**: Allocate marketing budget based on revenue contribution
4. **Sales Reporting**: Generate executive dashboards with product revenue metrics
5. **Pricing Strategy**: Analyze price points and their impact on total revenue
6. **Category Analysis**: Compare performance across different product categories

## Key Learning
**GROUP BY** is fundamental for data aggregation and analysis. It allows you to transform detailed transaction data into meaningful business insights by grouping related records and applying aggregate functions. The combination of GROUP BY with SUM, COUNT, and AVG enables powerful reporting capabilities.

**HAVING vs WHERE**: Use WHERE to filter individual rows before grouping, and HAVING to filter groups after aggregation. This distinction is crucial for writing effective analytical queries.

**JOIN with GROUP BY**: Combining tables with GROUP BY enables richer analysis by including descriptive information (like product names) alongside aggregated metrics, making reports more readable and actionable.
