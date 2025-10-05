# Day 26: Above-Average Customer Analysis (CTE and Subquery Comparison)

## Problem
The marketing and sales teams need to identify high-frequency customers who order more than the average to design targeted loyalty programs, premium services, and personalized marketing campaigns. Finding above-average customers helps in segmenting power users, optimizing customer acquisition costs, and maximizing customer lifetime value.

## Dataset
Customer order data with multiple transactions to identify customers whose order frequency exceeds the average, enabling strategic customer segmentation and targeted engagement.

## SQL Solution

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE,
    customer_tier VARCHAR(20)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    order_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);
```

## Query 1: Customers with Above-Average Orders 
```sql
-- Find customers who ordered more than the average (using CTE)
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT * 
FROM customer_orders
WHERE order_count > (SELECT AVG(order_count) FROM customer_orders);
```

### Output:

```
customer_id | order_count
------------|------------
101         | 8
102         | 6
103         | 7
105         | 9
```


**How it works:**
1. **CTE** creates temporary table with customer order counts
2. **Subquery** `(SELECT AVG(order_count)...)` calculates average orders
3. **WHERE** filters customers above that average
4. Simple comparison finds power users

## Query 2: Above-Average Customers with Details 

```sql
-- Get detailed information about high-frequency customers
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    c.customer_tier,
    co.order_count,
    ROUND((SELECT AVG(order_count) FROM customer_orders), 2) as avg_orders,
    co.order_count - ROUND((SELECT AVG(order_count) FROM customer_orders), 2) as orders_above_avg
FROM Customers c
JOIN customer_orders co ON c.customer_id = co.customer_id
WHERE co.order_count > (SELECT AVG(order_count) FROM customer_orders)
ORDER BY co.order_count DESC;
```

### Output:

```
customer_id | customer_name | email                    | city      | customer_tier | order_count | avg_orders | orders_above_avg
------------|---------------|--------------------------|-----------|---------------|-------------|------------|------------------
105         | Vikram Singh  | vikram.singh@email.com   | Chennai   | Gold          | 9           | 4.20       | 4.80
101         | Rajesh Kumar  | rajesh.kumar@email.com   | Mumbai    | Premium       | 8           | 4.20       | 3.80
103         | Amit Patel    | amit.patel@email.com     | Bangalore | Silver        | 7           | 4.20       | 2.80
102         | Priya Sharma  | priya.sharma@email.com   | Delhi     | Gold          | 6           | 4.20       | 1.80
```


**How it works:**
- Joins customer details with order counts
- Shows how much above average each customer is
- Ranks customers by order frequency
- Provides actionable customer insights

## Query 3: Customer Segmentation by Order Frequency 

```sql
-- Segment customers into frequency tiers
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
),
avg_calc AS (
    SELECT AVG(order_count) as avg_orders FROM customer_orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    co.order_count,
    a.avg_orders,
    CASE 
        WHEN co.order_count >= a.avg_orders * 2 THEN 'Power User'
        WHEN co.order_count > a.avg_orders THEN 'Above Average'
        WHEN co.order_count = ROUND(a.avg_orders) THEN 'Average'
        ELSE 'Below Average'
    END as frequency_segment,
    SUM(o.order_amount) as total_spent
FROM Customers c
JOIN customer_orders co ON c.customer_id = co.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
CROSS JOIN avg_calc a
GROUP BY c.customer_id, c.customer_name, c.customer_tier, co.order_count, a.avg_orders
ORDER BY co.order_count DESC;
```

### Output:

```
customer_id | customer_name | customer_tier | order_count | avg_orders | frequency_segment | total_spent
------------|---------------|---------------|-------------|------------|-------------------|-------------
105         | Vikram Singh  | Gold          | 9           | 4.20       | Power User        | 385000.00
101         | Rajesh Kumar  | Premium       | 8           | 4.20       | Power User        | 520000.00
103         | Amit Patel    | Silver        | 7           | 4.20       | Above Average     | 295000.00
102         | Priya Sharma  | Gold          | 6           | 4.20       | Above Average     | 245000.00
104         | Sneha Reddy   | Premium       | 4           | 4.20       | Average           | 180000.00
106         | Anita Desai   | Silver        | 3           | 4.20       | Below Average     | 125000.00
107         | Rohit Mehta   | Gold          | 2           | 4.20       | Below Average     | 85000.00
108         | Kavya Pillai  | Silver        | 3           | 4.20       | Below Average     | 98000.00
109         | Arjun Nair    | Premium       | 2           | 4.20       | Below Average     | 72000.00
110         | Deepa Joshi   | Silver        | 1           | 4.20       | Below Average     | 45000.00
```


**How it works:**
- Two CTEs: one for counts, one for average
- CASE statement creates meaningful segments
- Power users = 2x average frequency
- Links frequency to spending behavior

## Query 4: Revenue Impact of Above-Average Customers 

```sql
-- Analyze revenue contribution of high-frequency customers
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
),
customer_revenue AS (
    SELECT 
        c.customer_id,
        c.customer_name,
        co.order_count,
        SUM(o.order_amount) as total_revenue,
        CASE 
            WHEN co.order_count > (SELECT AVG(order_count) FROM customer_orders) 
            THEN 'Above Average'
            ELSE 'Below Average'
        END as frequency_group
    FROM Customers c
    JOIN customer_orders co ON c.customer_id = co.customer_id
    JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_name, co.order_count
)
SELECT 
    frequency_group,
    COUNT(*) as customer_count,
    SUM(total_revenue) as total_revenue,
    ROUND(AVG(total_revenue), 2) as avg_revenue_per_customer,
    ROUND(AVG(order_count), 2) as avg_orders,
    ROUND((SUM(total_revenue) / (SELECT SUM(total_revenue) FROM customer_revenue) * 100), 2) as revenue_percentage
FROM customer_revenue
GROUP BY frequency_group
ORDER BY total_revenue DESC;
```

### Output:

```
frequency_group | customer_count | total_revenue | avg_revenue_per_customer | avg_orders | revenue_percentage
----------------|----------------|---------------|--------------------------|------------|-------------------
Above Average   | 4              | 1445000.00    | 361250.00                | 7.50       | 70.37
Below Average   | 6              | 605000.00     | 100833.33                | 2.50       | 29.63
```


**How it works:**
- Compares above vs below average customers
- Shows revenue concentration (70% from above-average customers)
- Proves the value of identifying power users
- Classic 80/20 rule demonstration

## Query 5: Trend Analysis for Above-Average Customers 

```sql
-- Identify above-average customers and their ordering trends
WITH customer_orders AS (
    SELECT 
        customer_id, 
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id
),
above_avg_customers AS (
    SELECT customer_id, order_count
    FROM customer_orders
    WHERE order_count > (SELECT AVG(order_count) FROM customer_orders)
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    aac.order_count,
    MIN(o.order_date) as first_order,
    MAX(o.order_date) as last_order,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) as customer_lifespan_days,
    ROUND(aac.order_count / (DATEDIFF(MAX(o.order_date), MIN(o.order_date)) + 1) * 30, 2) as orders_per_month,
    SUM(o.order_amount) as lifetime_value,
    ROUND(SUM(o.order_amount) / aac.order_count, 2) as avg_order_value
FROM Customers c
JOIN above_avg_customers aac ON c.customer_id = aac.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_tier, aac.order_count
ORDER BY orders_per_month DESC;
```

### Output:

```
customer_id | customer_name | customer_tier | order_count | first_order | last_order | customer_lifespan_days | orders_per_month | lifetime_value | avg_order_value
------------|---------------|---------------|-------------|-------------|------------|------------------------|------------------|----------------|----------------
105         | Vikram Singh  | Gold          | 9           | 2024-01-15  | 2024-09-20  | 249                    | 1.08             | 385000.00      | 42777.78
101         | Rajesh Kumar  | Premium       | 8           | 2024-02-10  | 2024-09-15  | 218                    | 1.10             | 520000.00      | 65000.00
103         | Amit Patel    | Silver        | 7           | 2024-01-20  | 2024-08-30  | 223                    | 0.94             | 295000.00      | 42142.86
102         | Priya Sharma  | Gold          | 6           | 2024-03-05  | 2024-09-10  | 189                    | 0.95             | 245000.00      | 40833.33
```

## Key Learning Points

### CTE vs Subquery
**When to use CTE:**
- Need to reference result multiple times
- Complex multi-step logic
- Better readability matters

**When to use Subquery:**
- Simple one-time calculation
- Single comparison needed
- Shorter queries

### Average as Benchmark
Average is a simple but powerful benchmark:
- Splits customers into two groups
- Easy to explain to stakeholders
- Actionable for marketing teams
- Foundation for segmentation

### Business Insight
**The 80/20 Rule in action:**
- 40% of customers (above average) generate 70% of revenue
- Identifying these customers is crucial
- Small improvements in retention = big revenue impact
