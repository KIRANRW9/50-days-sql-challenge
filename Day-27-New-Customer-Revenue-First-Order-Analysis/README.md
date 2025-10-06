# Day 27: New Customer Revenue Analysis (First-Time Order Revenue)

## Problem
The sales and marketing teams need to calculate revenue generated from new customer acquisitions to measure the effectiveness of customer acquisition campaigns, understand initial purchase behavior, and optimize marketing spend. Tracking first-time order revenue helps in calculating Customer Acquisition Cost (CAC), evaluating campaign ROI, and forecasting future revenue from new customer cohorts.

## Dataset
Customer order data with transaction dates to identify first-time purchases and calculate total revenue generated from new customer acquisitions during specific periods.

## SQL Solution

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE,
    acquisition_channel VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);
```

## Query 1: Calculate Total New Customer Revenue 

```sql
-- Calculate revenue from first-time orders
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    SUM(o.total_amount) AS new_customer_revenue
FROM Orders o
JOIN first_orders f ON o.customer_id = f.customer_id
WHERE o.order_date = f.first_order_date;
```

### Output:

```
new_customer_revenue
--------------------
1285000.00
```

**How it works:**
1. **CTE `first_orders`** finds each customer's first order date
2. **JOIN** connects orders with first order dates
3. **WHERE** filters only orders that match first order date
4. **SUM** adds up revenue from all first-time purchases

## Query 2: New Customer Revenue with Count 

```sql
-- Get new customer count and average first order value
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    COUNT(DISTINCT o.customer_id) AS new_customers,
    SUM(o.total_amount) AS new_customer_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_first_order_value,
    MIN(o.total_amount) AS min_first_order,
    MAX(o.total_amount) AS max_first_order
FROM Orders o
JOIN first_orders f ON o.customer_id = f.customer_id
WHERE o.order_date = f.first_order_date;
```

### Output:

```
new_customers | new_customer_revenue | avg_first_order_value | min_first_order | max_first_order
--------------|----------------------|-----------------------|-----------------|----------------
10            | 1285000.00           | 128500.00             | 45000.00        | 199900.00
```

**How it works:**
- Counts unique new customers
- Calculates total and average first purchase value
- Shows range of first-time order values
- Useful for understanding acquisition quality

## Query 3: Monthly New Customer Revenue Trend 

```sql
-- Analyze new customer revenue by month
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    DATE_FORMAT(o.order_date, '%Y-%m') AS month,
    DATE_FORMAT(o.order_date, '%M %Y') AS month_name,
    COUNT(DISTINCT o.customer_id) AS new_customers,
    SUM(o.total_amount) AS new_customer_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_first_order_value
FROM Orders o
JOIN first_orders f ON o.customer_id = f.customer_id
WHERE o.order_date = f.first_order_date
GROUP BY DATE_FORMAT(o.order_date, '%Y-%m'), DATE_FORMAT(o.order_date, '%M %Y')
ORDER BY month;
```

### Output:

```
month   | month_name     | new_customers | new_customer_revenue | avg_first_order_value
--------|----------------|---------------|----------------------|----------------------
2024-01 | January 2024   | 2             | 234900.00            | 117450.00
2024-02 | February 2024  | 3             | 280898.00            | 93632.67
2024-03 | March 2024     | 2             | 194999.00            | 97499.50
2024-04 | April 2024     | 1             | 89999.00             | 89999.00
2024-05 | May 2024       | 1             | 125000.00            | 125000.00
2024-06 | June 2024      | 1             | 45000.00             | 45000.00
```

**How it works:**
- Groups first-time orders by month
- Tracks acquisition trends over time
- Shows seasonal patterns in customer acquisition
- Helps evaluate marketing campaign timing

## Query 4: New vs Repeat Customer Revenue Comparison 
```sql
-- Compare revenue from new vs repeat customers
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
),
order_classification AS (
    SELECT 
        o.order_id,
        o.customer_id,
        o.total_amount,
        CASE 
            WHEN o.order_date = f.first_order_date THEN 'New Customer'
            ELSE 'Repeat Customer'
        END AS customer_type
    FROM Orders o
    JOIN first_orders f ON o.customer_id = f.customer_id
)
SELECT 
    customer_type,
    COUNT(*) AS order_count,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(total_amount) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_value,
    ROUND((SUM(total_amount) / (SELECT SUM(total_amount) FROM Orders) * 100), 2) AS revenue_percentage
FROM order_classification
GROUP BY customer_type
ORDER BY total_revenue DESC;
```

### Output:

```
customer_type    | order_count | unique_customers | total_revenue | avg_order_value | revenue_percentage
-----------------|-------------|------------------|---------------|-----------------|-------------------
Repeat Customer  | 32          | 10               | 1765000.00    | 55156.25        | 57.87
New Customer     | 10          | 10               | 1285000.00    | 128500.00       | 42.13
```

**How it works:**
- Classifies each order as new or repeat
- Compares revenue contribution
- Shows that repeat customers have more orders but lower avg value
- First orders tend to be larger (trial/bundle purchases)

## Query 5: New Customer Revenue by Acquisition Channel 

```sql
-- Analyze new customer revenue by marketing channel
WITH first_orders AS (
    SELECT 
        customer_id, 
        MIN(order_date) AS first_order_date
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    c.acquisition_channel,
    COUNT(DISTINCT c.customer_id) AS new_customers,
    SUM(o.total_amount) AS new_customer_revenue,
    ROUND(AVG(o.total_amount), 2) AS avg_first_order_value,
    ROUND((SUM(o.total_amount) / (
        SELECT SUM(o2.total_amount) 
        FROM Orders o2 
        JOIN first_orders f2 ON o2.customer_id = f2.customer_id 
        WHERE o2.order_date = f2.first_order_date
    ) * 100), 2) AS revenue_share_pct
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN first_orders f ON o.customer_id = f.customer_id
WHERE o.order_date = f.first_order_date
GROUP BY c.acquisition_channel
ORDER BY new_customer_revenue DESC;
```

### Output:

```
acquisition_channel | new_customers | new_customer_revenue | avg_first_order_value | revenue_share_pct
--------------------|---------------|----------------------|-----------------------|------------------
Google Ads          | 3             | 449899.00            | 149966.33             | 35.01
Social Media        | 3             | 369999.00            | 123333.00             | 28.79
Email Campaign      | 2             | 270000.00            | 135000.00             | 21.01
Referral            | 1             | 125000.00            | 125000.00             | 9.73
Organic Search      | 1             | 70000.00             | 70000.00              | 5.45
```

**How it works:**
- Links customer acquisition source to first order revenue
- Identifies most valuable acquisition channels
- Calculates ROI potential for each channel
- Guides marketing budget allocation decisions

## How It Works

### Key Concepts

**MIN() for First Order**
```sql
MIN(order_date) AS first_order_date
```
- Finds earliest order date per customer
- Identifies the "first-time purchase" moment
- Groups by customer_id to get individual first dates

**Date Matching Logic**
```sql
WHERE o.order_date = f.first_order_date
```
- Filters only orders that match first order date
- Ensures we count only initial purchases
- Excludes all repeat/subsequent orders

**CTE Pattern**
```sql
WITH first_orders AS (...)
SELECT ... FROM Orders o JOIN first_orders f
```
- Step 1: Identify first order dates (CTE)
- Step 2: Join back to get first order details
- Step 3: Calculate revenue from those orders

### Understanding New vs Repeat Revenue

**Why This Matters:**
- **New customer revenue** = Acquisition success
- **Repeat customer revenue** = Retention success
- Different strategies for each segment
- CAC (Customer Acquisition Cost) calculated against new revenue

**Business Logic:**
```
New Customer Revenue = Sum of all first-time orders
Customer Acquisition Cost (CAC) = Marketing Spend / New Customers
CAC Payback Period = CAC / Average First Order Value
```

## Real World Use Cases

1. **Marketing ROI**: Calculate if acquisition costs are justified by first order revenue
2. **Campaign Effectiveness**: Compare new customer revenue across different campaigns
3. **Budget Allocation**: Invest more in channels with higher first-order values
4. **Sales Forecasting**: Project future revenue based on new customer acquisition
5. **Pricing Strategy**: Understand if discounts for first-time buyers are worth it
6. **Product Strategy**: Identify which products attract new customers
7. **Channel Optimization**: Focus on channels bringing high-value first orders
8. **Customer Segmentation**: Profile valuable new customers for targeting

## Key Learning Points

### First-Time vs Repeat Analysis
Understanding the difference is crucial:
- **First order** = Acquisition success metric
- **All orders** = Total customer value
- **Repeat orders** = Retention and loyalty metric

### MIN() Function Usage
`MIN(order_date)` is the key to finding first orders:
- Works with GROUP BY to find per-customer minimum
- Alternative to complex date ranking
- Simple and performant for most databases

### Business Metrics
**Key metrics to track:**
- New customer count
- New customer revenue
- Average first order value
- New customer revenue percentage
- Acquisition cost vs first order value ratio

### Why Channel Attribution Matters
Different channels attract different customer types:
- Premium channels → Higher first order values
- Budget channels → Lower first order values but more volume
- Optimize mix based on business goals
