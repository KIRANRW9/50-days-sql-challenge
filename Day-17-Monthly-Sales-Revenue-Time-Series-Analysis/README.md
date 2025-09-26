# Day 17: Monthly Sales Revenue and Order Analytics (Date Formatting & Time-Series Analysis)

## Problem
The sales and finance teams need to analyze business performance trends by tracking monthly revenue and order volumes. This time-series analysis helps in understanding seasonal patterns, growth trends, and business performance over time for strategic planning and forecasting. This problem tests understanding of date formatting functions, GROUP BY with dates, and sales analytics.

## Dataset
Comprehensive sales order data spanning multiple months with varying order amounts and frequencies to demonstrate month-over-month trends and seasonal patterns.

## SQL Solution

```sql
-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50),
    sales_rep_id INT
);

-- Insert sample data into Orders
INSERT INTO Orders VALUES
-- January 2024 - Post-holiday slow period
(1001, 2001, 'iPhone 15 Pro', 'Electronics', 159900.00, '2024-01-15', 'North', 3001),
(1002, 2002, 'Samsung TV 55"', 'Electronics', 65999.00, '2024-01-20', 'South', 3002),
(1003, 2003, 'Nike Shoes', 'Fashion', 12999.00, '2024-01-25', 'East', 3003),

-- February 2024 - Valentine's season boost
(1004, 2004, 'Diamond Ring', 'Jewelry', 89999.00, '2024-02-10', 'West', 3001),
(1005, 2005, 'Perfume Set', 'Beauty', 8999.00, '2024-02-12', 'North', 3002),
(1006, 2006, 'Chocolate Box', 'Food', 2999.00, '2024-02-14', 'South', 3003),
(1007, 2007, 'MacBook Air', 'Electronics', 114900.00, '2024-02-18', 'East', 3001),
(1008, 2008, 'Flowers Bouquet', 'Gifts', 1999.00, '2024-02-14', 'West', 3002),

-- March 2024 - Spring sales momentum
(1009, 2009, 'Canon Camera', 'Electronics', 75999.00, '2024-03-05', 'North', 3003),
(1010, 2010, 'Spring Jacket', 'Fashion', 4999.00, '2024-03-10', 'South', 3001),
(1011, 2011, 'Gaming Laptop', 'Electronics', 125000.00, '2024-03-15', 'East', 3002),
(1012, 2012, 'Sneakers', 'Fashion', 8999.00, '2024-03-20', 'West', 3003),
(1013, 2013, 'Tablet', 'Electronics', 45999.00, '2024-03-25', 'North', 3001),

-- April 2024 - Steady growth period
(1014, 2014, 'Smart Watch', 'Electronics', 25999.00, '2024-04-08', 'South', 3002),
(1015, 2015, 'Summer Dress', 'Fashion', 3999.00, '2024-04-12', 'East', 3003),
(1016, 2016, 'Bluetooth Speaker', 'Electronics', 15999.00, '2024-04-18', 'West', 3001),
(1017, 2017, 'Fitness Tracker', 'Electronics', 12999.00, '2024-04-22', 'North', 3002),
(1018, 2018, 'Handbag', 'Fashion', 18999.00, '2024-04-28', 'South', 3003),

-- May 2024 - Peak sales month
(1019, 2019, 'Refrigerator', 'Appliances', 89999.00, '2024-05-02', 'East', 3001),
(1020, 2020, 'Air Conditioner', 'Appliances', 45999.00, '2024-05-05', 'West', 3002),
(1021, 2021, 'Washing Machine', 'Appliances', 35999.00, '2024-05-10', 'North', 3003),
(1022, 2022, 'Microwave', 'Appliances', 18999.00, '2024-05-15', 'South', 3001),
(1023, 2023, 'Vacuum Cleaner', 'Appliances', 25999.00, '2024-05-18', 'East', 3002),
(1024, 2024, 'Coffee Machine', 'Appliances', 32999.00, '2024-05-22', 'West', 3003),
(1025, 2025, 'Blender', 'Appliances', 8999.00, '2024-05-25', 'North', 3001),
(1026, 2026, 'Toaster', 'Appliances', 4999.00, '2024-05-28', 'South', 3002),

-- June 2024 - Summer season
(1027, 2027, 'Pool Equipment', 'Sports', 45999.00, '2024-06-05', 'East', 3003),
(1028, 2028, 'Sunglasses', 'Fashion', 12999.00, '2024-06-08', 'West', 3001),
(1029, 2029, 'Beach Umbrella', 'Sports', 5999.00, '2024-06-12', 'North', 3002),
(1030, 2030, 'Swimwear', 'Fashion', 3999.00, '2024-06-15', 'South', 3003),

-- July 2024 - Mid-year boost
(1031, 2031, 'Lawn Mower', 'Garden', 35999.00, '2024-07-10', 'East', 3001),
(1032, 2032, 'Garden Tools Set', 'Garden', 8999.00, '2024-07-15', 'West', 3002),
(1033, 2033, 'Outdoor Grill', 'Garden', 25999.00, '2024-07-20', 'North', 3003);
```

## Query 1: Monthly Sales Revenue and Order Count 

```sql
-- Get monthly sales revenue and order count (MySQL version using DATE_FORMAT)
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    SUM(total_amount) AS total_revenue,
    COUNT(order_id) AS order_count
FROM Orders 
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

## Output:

```
month   | total_revenue | order_count
--------|---------------|------------
2024-01 | 238898.00     | 3
2024-02 | 218896.00     | 5
2024-03 | 260996.00     | 5
2024-04 | 77995.00      | 5
2024-05 | 262993.00     | 8
2024-06 | 68996.00      | 4
2024-07 | 70997.00      | 3
```

## Query 2: Monthly Trends with Growth Analysis 

```sql
-- Analyze monthly trends with average order value and growth metrics
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    DATE_FORMAT(order_date, '%M %Y') as month_name,
    COUNT(order_id) as order_count,
    SUM(total_amount) as total_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value,
    MIN(total_amount) as min_order,
    MAX(total_amount) as max_order,
    COUNT(DISTINCT customer_id) as unique_customers
FROM Orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m'), DATE_FORMAT(order_date, '%M %Y')
ORDER BY month;
```

## Output:

```
month   | month_name     | order_count | total_revenue | avg_order_value | min_order | max_order | unique_customers
--------|----------------|-------------|---------------|-----------------|-----------|-----------|------------------
2024-01 | January 2024   | 3           | 238898.00     | 79632.67        | 12999.00  | 159900.00 | 3
2024-02 | February 2024  | 5           | 218896.00     | 43779.20        | 1999.00   | 114900.00 | 5
2024-03 | March 2024     | 5           | 260996.00     | 52199.20        | 4999.00   | 125000.00 | 5
2024-04 | April 2024     | 5           | 77995.00      | 15599.00        | 3999.00   | 25999.00  | 5
2024-05 | May 2024       | 8           | 262993.00     | 32874.13        | 4999.00   | 89999.00  | 8
2024-06 | June 2024      | 4           | 68996.00      | 17249.00        | 3999.00   | 45999.00  | 4
2024-07 | July 2024      | 3           | 70997.00      | 23665.67        | 8999.00   | 35999.00  | 3
```

## Query 3: Category Performance by Month 

```sql
-- Analyze category performance across months
SELECT 
    category,
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(order_id) as orders,
    SUM(total_amount) as category_revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value
FROM Orders
GROUP BY category, DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month, category_revenue DESC;
```

## Output:

```
category    | month   | orders | category_revenue | avg_order_value
------------|---------|--------|------------------|----------------
Electronics | 2024-01 | 2      | 225899.00        | 112949.50
Fashion     | 2024-01 | 1      | 12999.00         | 12999.00
Electronics | 2024-02 | 1      | 114900.00        | 114900.00
Jewelry     | 2024-02 | 1      | 89999.00         | 89999.00
Beauty      | 2024-02 | 1      | 8999.00          | 8999.00
Food        | 2024-02 | 1      | 2999.00          | 2999.00
Gifts       | 2024-02 | 1      | 1999.00          | 1999.00
Electronics | 2024-03 | 3      | 246998.00        | 82332.67
Fashion     | 2024-03 | 2      | 13998.00         | 6999.00
Electronics | 2024-04 | 3      | 54997.00         | 18332.33
Fashion     | 2024-04 | 2      | 22998.00         | 11499.00
Appliances  | 2024-05 | 8      | 262993.00        | 32874.13
Sports      | 2024-06 | 2      | 51998.00         | 25999.00
Fashion     | 2024-06 | 2      | 16998.00         | 8499.00
Garden      | 2024-07 | 3      | 70997.00         | 23665.67
```

## Query 4: Region-wise Monthly Performance 

```sql
-- Compare regional performance across months
SELECT 
    region,
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(order_id) as orders,
    SUM(total_amount) as revenue,
    ROUND(AVG(total_amount), 2) as avg_order_value,
    ROUND((SUM(total_amount) / (SELECT SUM(total_amount) FROM Orders o2 WHERE DATE_FORMAT(o2.order_date, '%Y-%m') = DATE_FORMAT(order_date, '%Y-%m')) * 100), 1) as revenue_share_pct
FROM Orders
GROUP BY region, DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month, revenue DESC;
```

## Output:

```
region | month   | orders | revenue   | avg_order_value | revenue_share_pct
-------|---------|--------|-----------|-----------------|------------------
North  | 2024-01 | 1      | 159900.00 | 159900.00       | 66.9
South  | 2024-01 | 1      | 65999.00  | 65999.00        | 27.6
East   | 2024-01 | 1      | 12999.00  | 12999.00        | 5.4
West   | 2024-02 | 2      | 91998.00  | 45999.00        | 42.0
East   | 2024-02 | 1      | 114900.00 | 114900.00       | 52.5
North  | 2024-02 | 1      | 8999.00   | 8999.00         | 4.1
South  | 2024-02 | 1      | 2999.00   | 2999.00         | 1.4
East   | 2024-03 | 2      | 170999.00 | 85499.50        | 65.5
North  | 2024-03 | 2      | 121998.00 | 60999.00        | 46.8
South  | 2024-03 | 1      | 4999.00   | 4999.00         | 1.9
West   | 2024-03 | 1      | 8999.00   | 8999.00         | 3.4
```

## Query 5: Sales Representative Performance by Month 

```sql
-- Analyze sales representative performance over months
SELECT 
    sales_rep_id,
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(order_id) as orders_closed,
    SUM(total_amount) as total_sales,
    ROUND(AVG(total_amount), 2) as avg_deal_size,
    RANK() OVER (PARTITION BY DATE_FORMAT(order_date, '%Y-%m') ORDER BY SUM(total_amount) DESC) as monthly_rank
FROM Orders
GROUP BY sales_rep_id, DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month, total_sales DESC;
```

## Output:

```
sales_rep_id | month   | orders_closed | total_sales | avg_deal_size | monthly_rank
-------------|---------|---------------|-------------|---------------|-------------
3001         | 2024-01 | 1             | 159900.00   | 159900.00     | 1
3002         | 2024-01 | 1             | 65999.00    | 65999.00      | 2
3003         | 2024-01 | 1             | 12999.00    | 12999.00      | 3
3001         | 2024-02 | 2             | 204899.00   | 102449.50     | 1
3002         | 2024-02 | 2             | 10998.00    | 5499.00       | 3
3003         | 2024-02 | 1             | 2999.00     | 2999.00       | 4
3002         | 2024-03 | 2             | 140999.00   | 70499.50      | 1
3001         | 2024-03 | 2             | 105999.00   | 52999.50      | 2
3003         | 2024-03 | 1             | 8999.00     | 8999.00       | 3
3002         | 2024-04 | 2             | 38998.00    | 19499.00      | 1
3003         | 2024-04 | 2             | 22998.00    | 11499.00      | 2
3001         | 2024-04 | 1             | 15999.00    | 15999.00      | 3
3001         | 2024-05 | 3             | 108997.00   | 36332.33      | 1
3002         | 2024-05 | 3             | 75996.00    | 25332.00      | 2
3003         | 2024-05 | 2             | 57999.00    | 28999.50      | 3
```


## How It Works
* **DATE_FORMAT() Function**: Extracts and formats date parts for grouping (MySQL syntax)
* **Time-Series Grouping**: GROUP BY with formatted dates creates monthly aggregations
* **Multiple Aggregations**: SUM, COUNT, AVG provide comprehensive monthly metrics
* **Window Functions**: RANK() OVER PARTITION BY enables monthly performance rankings
* **Percentage Calculations**: Calculate revenue shares and growth percentages
* **Cross-dimensional Analysis**: Combine time periods with categories, regions, salespeople
* **Trend Analysis**: ORDER BY month shows chronological progression

## Real World Use Cases
1. **Business Performance Tracking**: Monitor monthly revenue and order volume trends
2. **Seasonal Analysis**: Identify peak and slow periods for inventory and staffing planning
3. **Sales Forecasting**: Use historical monthly data to predict future performance
4. **Budget Planning**: Allocate monthly budgets based on historical performance patterns
5. **Sales Team Management**: Track individual and regional performance month-over-month
6. **Category Strategy**: Understand which product categories perform best in different months

## Key Learning
**Date Formatting for Time-Series Analysis** is crucial for business reporting. DATE_FORMAT() (MySQL) or FORMAT() (SQL Server) enables grouping by time periods for trend analysis.

**Monthly Aggregations** are fundamental in business analytics for tracking performance over time. Combining multiple metrics (revenue, orders, averages) provides comprehensive insights.

**Window Functions with Time-Series** enable advanced analytics like month-over-month rankings, moving averages, and comparative performance analysis across time periods.
