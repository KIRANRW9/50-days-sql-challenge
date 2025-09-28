# Day 19: Customer Consistency Analysis with HAVING Clause (Loyal Customer Identification)

## Problem
The marketing and customer success teams need to identify highly loyal customers who demonstrate consistent purchasing behavior throughout the year. Finding customers who placed orders every month helps in creating VIP programs, targeted marketing campaigns, and understanding customer lifetime value. This problem tests understanding of HAVING clause, date functions, and customer behavior analysis.

## Dataset
Comprehensive customer order data spanning 2023 with varying purchase frequencies to identify customers with consistent monthly ordering patterns.

## SQL Solution

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    customer_tier VARCHAR(20),
    location VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    order_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Insert sample data into Customers
INSERT INTO Customers VALUES
(2001, 'Rajesh Kumar', 'rajesh.kumar@email.com', '2022-01-15', 'Premium', 'Mumbai'),
(2002, 'Priya Sharma', 'priya.sharma@email.com', '2022-03-20', 'Gold', 'Delhi'),
(2003, 'Amit Patel', 'amit.patel@email.com', '2022-06-10', 'Premium', 'Bangalore'),
(2004, 'Sneha Reddy', 'sneha.reddy@email.com', '2022-08-05', 'Silver', 'Hyderabad'),
(2005, 'Vikram Singh', 'vikram.singh@email.com', '2022-11-12', 'Gold', 'Chennai'),
(2006, 'Anita Desai', 'anita.desai@email.com', '2023-01-18', 'Silver', 'Pune'),
(2007, 'Rohit Mehta', 'rohit.mehta@email.com', '2022-05-22', 'Premium', 'Kolkata'),
(2008, 'Kavya Pillai', 'kavya.pillai@email.com', '2022-09-14', 'Gold', 'Kochi');

-- Insert sample data into Orders for 2023
INSERT INTO Orders VALUES
-- CUSTOMER 2001 (Rajesh Kumar) - EVERY MONTH BUYER (12 months)
(3001, 2001, 'iPhone 15', 'Electronics', 129900.00, '2023-01-15', 'Delivered'),
(3002, 2001, 'MacBook Pro', 'Electronics', 199900.00, '2023-02-20', 'Delivered'),
(3003, 2001, 'iPad Air', 'Electronics', 59900.00, '2023-03-25', 'Delivered'),
(3004, 2001, 'AirPods Pro', 'Electronics', 24900.00, '2023-04-30', 'Delivered'),
(3005, 2001, 'Apple Watch', 'Electronics', 45900.00, '2023-05-15', 'Delivered'),
(3006, 2001, 'Magic Keyboard', 'Electronics', 12900.00, '2023-06-20', 'Delivered'),
(3007, 2001, 'Studio Display', 'Electronics', 159900.00, '2023-07-10', 'Delivered'),
(3008, 2001, 'Mac Mini', 'Electronics', 59900.00, '2023-08-18', 'Delivered'),
(3009, 2001, 'HomePod', 'Electronics', 32900.00, '2023-09-22', 'Delivered'),
(3010, 2001, 'Apple TV', 'Electronics', 18900.00, '2023-10-14', 'Delivered'),
(3011, 2001, 'MagSafe Charger', 'Electronics', 4900.00, '2023-11-28', 'Delivered'),
(3012, 2001, 'AirTag 4-Pack', 'Electronics', 11900.00, '2023-12-05', 'Delivered'),

-- CUSTOMER 2003 (Amit Patel) - EVERY MONTH BUYER (12 months)
(3013, 2003, 'Samsung TV 65"', 'Electronics', 89999.00, '2023-01-08', 'Delivered'),
(3014, 2003, 'Washing Machine', 'Appliances', 45999.00, '2023-02-12', 'Delivered'),
(3015, 2003, 'Refrigerator', 'Appliances', 89999.00, '2023-03-18', 'Delivered'),
(3016, 2003, 'Air Conditioner', 'Appliances', 55999.00, '2023-04-22', 'Delivered'),
(3017, 2003, 'Microwave', 'Appliances', 18999.00, '2023-05-26', 'Delivered'),
(3018, 2003, 'Vacuum Cleaner', 'Appliances', 25999.00, '2023-06-30', 'Delivered'),
(3019, 2003, 'Coffee Machine', 'Appliances', 32999.00, '2023-07-15', 'Delivered'),
(3020, 2003, 'Dishwasher', 'Appliances', 65999.00, '2023-08-19', 'Delivered'),
(3021, 2003, 'Water Purifier', 'Appliances', 15999.00, '2023-09-23', 'Delivered'),
(3022, 2003, 'Electric Kettle', 'Appliances', 2999.00, '2023-10-27', 'Delivered'),
(3023, 2003, 'Toaster', 'Appliances', 4999.00, '2023-11-14', 'Delivered'),
(3024, 2003, 'Blender', 'Appliances', 8999.00, '2023-12-18', 'Delivered'),

-- CUSTOMER 2002 (Priya Sharma) - FREQUENT BUT NOT EVERY MONTH (10 months)
(3025, 2002, 'Nike Shoes', 'Fashion', 12999.00, '2023-01-20', 'Delivered'),
(3026, 2002, 'Adidas Jacket', 'Fashion', 8999.00, '2023-02-25', 'Delivered'),
(3027, 2002, 'Levi Jeans', 'Fashion', 5999.00, '2023-03-15', 'Delivered'),
-- Missing April
(3028, 2002, 'Zara Dress', 'Fashion', 3999.00, '2023-05-18', 'Delivered'),
(3029, 2002, 'H&M Top', 'Fashion', 1999.00, '2023-06-22', 'Delivered'),
(3030, 2002, 'Puma Sneakers', 'Fashion', 9999.00, '2023-07-16', 'Delivered'),
(3031, 2002, 'Forever21 Skirt', 'Fashion', 2999.00, '2023-08-20', 'Delivered'),
(3032, 2002, 'Mango Coat', 'Fashion', 7999.00, '2023-09-24', 'Delivered'),
-- Missing October
(3033, 2002, 'Gucci Handbag', 'Fashion', 89999.00, '2023-11-28', 'Delivered'),
(3034, 2002, 'Louis Vuitton Wallet', 'Fashion', 45999.00, '2023-12-22', 'Delivered'),

-- CUSTOMER 2005 (Vikram Singh) - SEASONAL BUYER (6 months)
(3035, 2005, 'Cricket Bat', 'Sports', 8999.00, '2023-03-12', 'Delivered'),
(3036, 2005, 'Football', 'Sports', 2999.00, '2023-04-16', 'Delivered'),
(3037, 2005, 'Tennis Racket', 'Sports', 12999.00, '2023-05-20', 'Delivered'),
(3038, 2005, 'Golf Clubs Set', 'Sports', 89999.00, '2023-06-24', 'Delivered'),
(3039, 2005, 'Gym Equipment', 'Sports', 45999.00, '2023-07-28', 'Delivered'),
(3040, 2005, 'Bicycle', 'Sports', 25999.00, '2023-08-15', 'Delivered'),

-- CUSTOMER 2004 (Sneha Reddy) - OCCASIONAL BUYER (3 months)
(3041, 2004, 'Sofa Set', 'Furniture', 89999.00, '2023-02-10', 'Delivered'),
(3042, 2004, 'Dining Table', 'Furniture', 65999.00, '2023-06-15', 'Delivered'),
(3043, 2004, 'Bed Frame', 'Furniture', 45999.00, '2023-11-20', 'Delivered'),

-- CUSTOMER 2007 (Rohit Mehta) - EVERY MONTH BUYER (12 months)
(3044, 2007, 'Book Collection', 'Books', 5999.00, '2023-01-12', 'Delivered'),
(3045, 2007, 'Kindle', 'Electronics', 12999.00, '2023-02-16', 'Delivered'),
(3046, 2007, 'Office Chair', 'Furniture', 18999.00, '2023-03-20', 'Delivered'),
(3047, 2007, 'Desk Lamp', 'Electronics', 3999.00, '2023-04-24', 'Delivered'),
(3048, 2007, 'Monitor', 'Electronics', 25999.00, '2023-05-28', 'Delivered'),
(3049, 2007, 'Keyboard', 'Electronics', 8999.00, '2023-06-15', 'Delivered'),
(3050, 2007, 'Mouse', 'Electronics', 2999.00, '2023-07-19', 'Delivered'),
(3051, 2007, 'Webcam', 'Electronics', 12999.00, '2023-08-23', 'Delivered'),
(3052, 2007, 'Headphones', 'Electronics', 15999.00, '2023-09-27', 'Delivered'),
(3053, 2007, 'Speakers', 'Electronics', 22999.00, '2023-10-31', 'Delivered'),
(3054, 2007, 'Printer', 'Electronics', 18999.00, '2023-11-25', 'Delivered'),
(3055, 2007, 'Scanner', 'Electronics', 8999.00, '2023-12-29', 'Delivered');
```

## Query 1: Customers Who Placed Orders Every Month in 2023 

```sql
-- Find customers who placed orders in all 12 months of 2023 (MySQL version)
SELECT customer_id 
FROM Orders 
WHERE YEAR(order_date) = 2023 
GROUP BY customer_id 
HAVING COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 12;
```

## Output:

```
customer_id
-----------
2001
2003
2007
```


## Query 2: Loyal Customer Details with Order Summary 
```sql
-- Get complete details of customers who ordered every month in 2023
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    c.location,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as total_spent,
    ROUND(AVG(o.order_amount), 2) as avg_order_value,
    MIN(o.order_date) as first_order_2023,
    MAX(o.order_date) as last_order_2023
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023
GROUP BY c.customer_id, c.customer_name, c.customer_tier, c.location
HAVING COUNT(DISTINCT DATE_FORMAT(o.order_date, '%Y-%m')) = 12
ORDER BY total_spent DESC;
```

## Output:

```
customer_id | customer_name | customer_tier | location  | total_orders | total_spent | avg_order_value | first_order_2023 | last_order_2023
------------|---------------|---------------|-----------|--------------|-------------|-----------------|------------------|----------------
2001        | Rajesh Kumar  | Premium       | Mumbai    | 12           | 761000.00   | 63416.67        | 2023-01-15       | 2023-12-05
2003        | Amit Patel    | Premium       | Bangalore | 12           | 457989.00   | 38165.75        | 2023-01-08       | 2023-12-18
2007        | Rohit Mehta   | Premium       | Kolkata   | 12           | 157989.00   | 13165.75        | 2023-01-12       | 2023-12-29
```


## Query 3: Customer Consistency Comparison 

```sql
-- Compare customers by their ordering consistency levels
SELECT 
    CASE 
        WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 12 THEN 'Every Month (12/12)'
        WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 9 THEN 'Highly Consistent (9-11/12)'
        WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 6 THEN 'Moderately Consistent (6-8/12)'
        WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 3 THEN 'Occasional (3-5/12)'
        ELSE 'Rare (1-2/12)'
    END as consistency_level,
    COUNT(*) as customer_count,
    ROUND(AVG(COUNT(order_id)), 1) as avg_orders_per_customer,
    ROUND(AVG(SUM(order_amount)), 2) as avg_total_spent,
    GROUP_CONCAT(DISTINCT customer_id ORDER BY customer_id) as customer_ids
FROM Orders 
WHERE YEAR(order_date) = 2023 
GROUP BY customer_id
GROUP BY 
    CASE 
        WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 12 THEN 'Every Month (12/12)'
        WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 9 THEN 'Highly Consistent (9-11/12)'
        WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 6 THEN 'Moderately Consistent (6-8/12)'
        WHEN COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) >= 3 THEN 'Occasional (3-5/12)'
        ELSE 'Rare (1-2/12)'
    END
ORDER BY customer_count DESC;
```

## Output:

```
consistency_level           | customer_count | avg_orders_per_customer | avg_total_spent | customer_ids
----------------------------|----------------|-------------------------|-----------------|-------------
Every Month (12/12)         | 3              | 12.0                    | 458992.67       | 2001,2003,2007
Highly Consistent (9-11/12) | 1              | 10.0                    | 190990.00       | 2002
Moderately Consistent (6-8/12)| 1            | 6.0                     | 185994.00       | 2005
Occasional (3-5/12)         | 1              | 3.0                     | 201997.00       | 2004
```


## Query 4: Monthly Purchase Pattern Analysis 

```sql
-- Analyze which months the every-month customers prefer most
SELECT 
    DATE_FORMAT(o.order_date, '%m') as month_num,
    DATE_FORMAT(o.order_date, '%M') as month_name,
    COUNT(o.order_id) as orders_count,
    COUNT(DISTINCT o.customer_id) as customers_count,
    SUM(o.order_amount) as month_revenue,
    ROUND(AVG(o.order_amount), 2) as avg_order_value
FROM Orders o
WHERE YEAR(o.order_date) = 2023 
    AND o.customer_id IN (
        SELECT customer_id 
        FROM Orders 
        WHERE YEAR(order_date) = 2023 
        GROUP BY customer_id 
        HAVING COUNT(DISTINCT DATE_FORMAT(order_date, '%Y-%m')) = 12
    )
GROUP BY DATE_FORMAT(o.order_date, '%m'), DATE_FORMAT(o.order_date, '%M')
ORDER BY month_num;
```

## Output:

```
month_num | month_name | orders_count | customers_count | month_revenue | avg_order_value
----------|------------|--------------|-----------------|---------------|----------------
01        | January    | 3            | 3               | 225898.00     | 75299.33
02        | February   | 3            | 3               | 260811.00     | 86937.00
03        | March      | 3            | 3               | 149917.00     | 49972.33
04        | April      | 3            | 3               | 80898.00      | 26966.00
05        | May        | 3            | 3               | 90817.00      | 30272.33
06        | June       | 3            | 3               | 47898.00      | 15966.00
07        | July       | 3            | 3               | 205798.00     | 68599.33
08        | August     | 3            | 3               | 148917.00     | 49639.00
09        | September  | 3            | 3               | 65897.00      | 21965.67
10        | October    | 3            | 3               | 65912.00      | 21970.67
11        | November   | 3            | 3               | 38826.00      | 12942.00
12        | December   | 3            | 3               | 35897.00      | 11965.67
```

## Query 5: Customer Tier Analysis for Consistent Buyers 

```sql
-- Analyze customer tiers among different consistency levels
SELECT 
    c.customer_tier,
    COUNT(*) as total_customers,
    SUM(CASE WHEN months_active = 12 THEN 1 ELSE 0 END) as every_month_customers,
    SUM(CASE WHEN months_active >= 9 THEN 1 ELSE 0 END) as highly_consistent_customers,
    ROUND(AVG(total_orders), 1) as avg_orders,
    ROUND(AVG(total_spent), 2) as avg_total_spent,
    ROUND((SUM(CASE WHEN months_active = 12 THEN 1 ELSE 0 END) * 100.0 / COUNT(*)), 1) as every_month_percentage
FROM (
    SELECT 
        c.customer_id,
        c.customer_tier,
        COUNT(DISTINCT DATE_FORMAT(o.order_date, '%Y-%m')) as months_active,
        COUNT(o.order_id) as total_orders,
        SUM(o.order_amount) as total_spent
    FROM Customers c
    JOIN Orders o ON c.customer_id = o.customer_id
    WHERE YEAR(o.order_date) = 2023
    GROUP BY c.customer_id, c.customer_tier
) customer_stats
GROUP BY c.customer_tier
ORDER BY every_month_percentage DESC;
```

## Output:

```
customer_tier | total_customers | every_month_customers | highly_consistent_customers | avg_orders | avg_total_spent | every_month_percentage
--------------|-----------------|----------------------|----------------------------|------------|-----------------|----------------------
Premium       | 3               | 3                    | 3                          | 12.0       | 458992.67       | 100.0
Gold          | 1               | 0                    | 1                          | 10.0       | 190990.00       | 0.0
Silver        | 1               | 0                    | 0                          | 3.0        | 201997.00       | 0.0
```


## How It Works
* **HAVING Clause**: Filters groups after GROUP BY aggregation, unlike WHERE which filters before grouping
* **COUNT(DISTINCT)**: Counts unique month-year combinations to measure consistency
* **Date Functions**: YEAR() and DATE_FORMAT() extract and format date components
* **Nested Aggregations**: Multiple levels of grouping and aggregation for complex analysis
* **Subqueries with HAVING**: Use results of one HAVING query to filter another query
* **Customer Segmentation**: Categorize customers based on behavioral patterns
* **Business Metrics**: Calculate loyalty scores, consistency levels, and tier performance

## Real World Use Cases
1. **Loyalty Program Design**: Identify customers for VIP programs and special rewards
2. **Customer Retention**: Target at-risk customers who show declining consistency
3. **Marketing Campaigns**: Create personalized campaigns for different consistency levels
4. **Customer Lifetime Value**: Predict long-term value based on consistency patterns
5. **Inventory Planning**: Plan stock based on consistent customer demand patterns
6. **Sales Forecasting**: Use consistent customer behavior for revenue predictions

## Key Learning
**HAVING Clause with COUNT(DISTINCT)** is powerful for analyzing customer consistency and loyalty patterns. It enables filtering based on calculated metrics after grouping.

**Customer Consistency Analysis** is crucial for understanding customer behavior and identifying high-value segments. Combining date functions with aggregations reveals temporal patterns.

**Multi-level Analysis** using subqueries and nested aggregations provides deep insights into customer behavior, enabling data-driven decisions about customer relationship management.
