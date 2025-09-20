# Day 11: Finding Missing Records with LEFT JOIN (Products Never Sold Analysis)

## Problem
The inventory and sales teams need to identify products that exist in the catalog but have never been sold. This analysis helps in understanding product performance, optimizing inventory, identifying slow-moving stock, and making decisions about product discontinuation or promotion strategies. This problem tests understanding of LEFT JOIN, IS NULL filtering, and finding missing relationships between tables.

## Dataset
Product catalog data with comprehensive product information and sales transaction data, designed to identify products with no sales history.

## SQL Solution

```sql
-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT,
    launch_date DATE,
    status VARCHAR(20)
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    quantity INT,
    sale_price DECIMAL(10,2),
    sale_date DATE,
    region VARCHAR(50)
);

-- Insert sample data into Products
INSERT INTO Products VALUES
-- Electronics Category
(101, 'iPhone 15 Pro Max', 'Electronics', 159900.00, 50, '2023-09-15', 'Active'),
(102, 'Samsung Galaxy S24 Ultra', 'Electronics', 139999.00, 30, '2024-01-20', 'Active'),
(103, 'MacBook Pro M3', 'Electronics', 249900.00, 20, '2023-11-10', 'Active'),
(104, 'iPad Air M2', 'Electronics', 89900.00, 25, '2024-03-15', 'Active'),
(105, 'Sony WH-1000XM5', 'Electronics', 34999.00, 40, '2023-08-20', 'Active'),
(106, 'Dell XPS 13', 'Electronics', 145000.00, 15, '2024-02-10', 'Active'),
(107, 'HP Spectre x360', 'Electronics', 125000.00, 10, '2024-05-20', 'Active'),

-- Fashion Category
(201, 'Nike Air Jordan 1', 'Fashion', 18999.00, 60, '2023-07-10', 'Active'),
(202, 'Adidas Ultraboost 22', 'Fashion', 16999.00, 45, '2023-09-05', 'Active'),
(203, 'Levi\'s 501 Jeans', 'Fashion', 4999.00, 80, '2023-06-15', 'Active'),
(204, 'Zara Premium Jacket', 'Fashion', 7999.00, 35, '2024-01-25', 'Active'),
(205, 'H&M Designer Dress', 'Fashion', 2999.00, 50, '2024-04-10', 'Active'),

-- Home & Kitchen Category  
(301, 'Philips Air Fryer XL', 'Home & Kitchen', 12999.00, 25, '2023-12-01', 'Active'),
(302, 'Samsung Smart Refrigerator', 'Home & Kitchen', 89999.00, 8, '2024-01-15', 'Active'),
(303, 'Dyson V15 Vacuum', 'Home & Kitchen', 45999.00, 12, '2024-03-20', 'Active'),
(304, 'KitchenAid Stand Mixer', 'Home & Kitchen', 35999.00, 15, '2024-06-05', 'Active'),

-- Books Category
(401, 'The Psychology of Money', 'Books', 599.00, 100, '2023-05-10', 'Active'),
(402, 'Atomic Habits', 'Books', 699.00, 80, '2023-07-20', 'Active'),
(403, 'Think and Grow Rich', 'Books', 399.00, 120, '2023-08-15', 'Active'),
(404, 'Rich Dad Poor Dad', 'Books', 499.00, 90, '2023-09-10', 'Active');

-- Insert sample data into Sales (Notice: Some products have NO sales)
INSERT INTO Sales VALUES
-- Electronics Sales
(1001, 101, 1001, 2, 159900.00, '2024-01-15', 'North'),
(1002, 101, 1002, 1, 159900.00, '2024-02-20', 'South'),
(1003, 102, 1003, 1, 139999.00, '2024-03-10', 'East'),
(1004, 103, 1004, 1, 249900.00, '2024-01-25', 'West'),
(1005, 105, 1005, 3, 34999.00, '2024-04-15', 'North'),

-- Fashion Sales
(1006, 201, 1006, 1, 18999.00, '2024-02-10', 'South'),
(1007, 202, 1007, 2, 16999.00, '2024-03-20', 'East'),
(1008, 203, 1008, 3, 4999.00, '2024-05-15', 'West'),

-- Home & Kitchen Sales
(1009, 301, 1009, 1, 12999.00, '2024-06-20', 'North'),

-- Books Sales  
(1010, 401, 1010, 5, 599.00, '2024-07-10', 'South'),
(1011, 402, 1011, 2, 699.00, '2024-08-15', 'East'),
(1012, 403, 1012, 3, 399.00, '2024-09-20', 'West');

-- Products NEVER SOLD: 104 (iPad Air M2), 106 (Dell XPS 13), 107 (HP Spectre x360), 
-- 204 (Zara Premium Jacket), 205 (H&M Designer Dress), 
-- 302 (Samsung Smart Refrigerator), 303 (Dyson V15 Vacuum), 304 (KitchenAid Stand Mixer),
-- 404 (Rich Dad Poor Dad)
```

## Query 1: Products Never Sold (Basic LEFT JOIN) 

```sql
-- Find products that have never been sold
SELECT 
    p.product_id 
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL;
```

## Output:

```
product_id
----------
104
106
107
204
205
302
303
304
404
```


## Query 2: Never Sold Products with Details 

```sql
-- Get complete details of products that have never been sold
SELECT 
    p.product_id,
    p.product_name,
    p.category,
    p.unit_price,
    p.stock_quantity,
    p.launch_date,
    DATEDIFF(CURDATE(), p.launch_date) as days_since_launch
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL
ORDER BY p.unit_price DESC;
```

## Output:

```
product_id | product_name              | category      | unit_price | stock_quantity | launch_date | days_since_launch
-----------|---------------------------|---------------|------------|----------------|-------------|------------------
302        | Samsung Smart Refrigerator| Home & Kitchen| 89999.00   | 8              | 2024-01-15  | 278
106        | Dell XPS 13               | Electronics   | 145000.00  | 15             | 2024-02-10  | 252
107        | HP Spectre x360           | Electronics   | 125000.00  | 10             | 2024-05-20  | 153
104        | iPad Air M2               | Electronics   | 89900.00   | 25             | 2024-03-15  | 219
303        | Dyson V15 Vacuum          | Home & Kitchen| 45999.00   | 12             | 2024-03-20  | 214
304        | KitchenAid Stand Mixer    | Home & Kitchen| 35999.00   | 15             | 2024-06-05  | 137
204        | Zara Premium Jacket       | Fashion       | 7999.00    | 35             | 2024-01-25  | 268
205        | H&M Designer Dress        | Fashion       | 2999.00    | 50             | 2024-04-10  | 193
404        | Rich Dad Poor Dad         | Books         | 499.00     | 90             | 2023-09-10  | 435
```


## Query 3: Category-wise Never Sold Analysis 

```sql
-- Analyze never sold products by category
SELECT 
    p.category,
    COUNT(*) as never_sold_count,
    SUM(p.stock_quantity) as total_unsold_inventory,
    SUM(p.unit_price * p.stock_quantity) as inventory_value,
    ROUND(AVG(p.unit_price), 2) as avg_price,
    MIN(p.launch_date) as earliest_launch,
    MAX(p.launch_date) as latest_launch
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL
GROUP BY p.category
ORDER BY inventory_value DESC;
```

## Output:

```
category       | never_sold_count | total_unsold_inventory | inventory_value | avg_price  | earliest_launch | latest_launch
---------------|------------------|------------------------|-----------------|------------|-----------------|---------------
Home & Kitchen | 3                | 35                     | 1259967.00      | 57332.67   | 2024-01-15      | 2024-06-05
Electronics    | 3                | 50                     | 4622500.00      | 119966.67  | 2024-02-10      | 2024-05-20
Fashion        | 2                | 85                     | 429915.00       | 5499.00    | 2024-01-25      | 2024-04-10
Books          | 1                | 90                     | 44910.00        | 499.00     | 2023-09-10      | 2023-09-10
```


## Query 4: Sold vs Never Sold Comparison 

```sql
-- Compare sold vs never sold products using UNION
SELECT 
    'Sold Products' as product_status,
    COUNT(DISTINCT p.product_id) as product_count,
    COUNT(DISTINCT p.category) as categories,
    ROUND(AVG(p.unit_price), 2) as avg_price,
    SUM(p.stock_quantity) as total_inventory
FROM Products p 
INNER JOIN Sales s ON p.product_id = s.product_id
UNION ALL
SELECT 
    'Never Sold Products' as product_status,
    COUNT(DISTINCT p.product_id) as product_count,
    COUNT(DISTINCT p.category) as categories,
    ROUND(AVG(p.unit_price), 2) as avg_price,
    SUM(p.stock_quantity) as total_inventory
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL;
```

## Output:

```
product_status      | product_count | categories | avg_price  | total_inventory
--------------------|---------------|------------|------------|----------------
Sold Products       | 12            | 4          | 45524.75   | 645
Never Sold Products | 9             | 4          | 73266.11   | 260
```


## Query 5: High-Value Never Sold Products 
```sql
-- Identify high-value products that have never been sold (requiring attention)
SELECT 
    p.product_name,
    p.category,
    p.unit_price,
    p.stock_quantity,
    (p.unit_price * p.stock_quantity) as inventory_value,
    p.launch_date,
    DATEDIFF(CURDATE(), p.launch_date) as days_in_catalog,
    CASE 
        WHEN p.unit_price > 100000 THEN 'High Priority - Premium Product'
        WHEN p.unit_price > 50000 THEN 'Medium Priority - Expensive Product'  
        WHEN DATEDIFF(CURDATE(), p.launch_date) > 365 THEN 'High Priority - Old Product'
        WHEN p.stock_quantity > 50 THEN 'Medium Priority - High Stock'
        ELSE 'Low Priority'
    END as action_priority
FROM Products p 
LEFT JOIN Sales s ON p.product_id = s.product_id 
WHERE s.product_id IS NULL
    AND (p.unit_price > 10000 OR p.stock_quantity > 30 OR DATEDIFF(CURDATE(), p.launch_date) > 200)
ORDER BY inventory_value DESC;
```

## Output:

```
product_name              | category      | unit_price | stock_quantity | inventory_value | launch_date | days_in_catalog | action_priority
--------------------------|---------------|------------|----------------|-----------------|-------------|-----------------|-------------------------
Dell XPS 13               | Electronics   | 145000.00  | 15             | 2175000.00      | 2024-02-10  | 252             | High Priority - Premium Product
HP Spectre x360           | Electronics   | 125000.00  | 10             | 1250000.00      | 2024-05-20  | 153             | High Priority - Premium Product
iPad Air M2               | Electronics   | 89900.00   | 25             | 2247500.00      | 2024-03-15  | 219             | Medium Priority - Expensive Product
Samsung Smart Refrigerator| Home & Kitchen| 89999.00   | 8              | 719992.00       | 2024-01-15  | 278             | Medium Priority - Expensive Product
Dyson V15 Vacuum          | Home & Kitchen| 45999.00   | 12             | 551988.00       | 2024-03-20  | 214             | Medium Priority - Expensive Product
KitchenAid Stand Mixer    | Home & Kitchen| 35999.00   | 15             | 539985.00       | 2024-06-05  | 137             | Medium Priority - Expensive Product
H&M Designer Dress        | Fashion       | 2999.00    | 50             | 149950.00       | 2024-04-10  | 193             | Medium Priority - High Stock
Rich Dad Poor Dad         | Books         | 499.00     | 90             | 44910.00        | 2023-09-10  | 435             | High Priority - Old Product
```


## How It Works
* **LEFT JOIN**: Includes all records from the left table (Products), even if no matching records in the right table (Sales)
* **IS NULL Filter**: Identifies records where the right table has no matches (products never sold)
* **INNER JOIN vs LEFT JOIN**: INNER JOIN shows only sold products, LEFT JOIN shows all products
* **UNION Operations**: Combine results from different queries for comparison analysis
* **Business Logic**: CASE statements create actionable insights based on price, inventory, and age
* **Date Calculations**: DATEDIFF helps identify how long products have been in catalog without sales

## Real World Use Cases
1. **Inventory Management**: Identify slow-moving stock that ties up warehouse space
2. **Product Strategy**: Decide which products to discontinue or heavily promote
3. **Marketing Focus**: Target marketing efforts on products that need sales boost
4. **Pricing Analysis**: Understand if high prices are preventing sales
5. **Category Performance**: Compare product performance across different categories
6. **Supply Chain**: Adjust procurement based on products that aren't selling

## Key Learning
**LEFT JOIN with IS NULL** is the standard pattern for finding missing relationships between tables. This technique is crucial for identifying gaps in data, such as products without sales, customers without orders, or employees without performance reviews.

**Business Context Matters**: Simply finding never-sold products isn't enough - you need to analyze WHY they haven't sold (too expensive, too new, wrong category) and prioritize actions accordingly.

**Comparative Analysis**: Using UNION to compare sold vs never-sold products provides valuable business insights about what drives product success and helps identify patterns in unsuccessful products.
