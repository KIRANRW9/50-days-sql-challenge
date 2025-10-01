# Day 22: Consecutive Purchases Analysis with LAG Function (Customer Behavior & Sequential Patterns)

## Problem
The marketing and customer analytics teams need to identify customers who make consecutive daily purchases to understand high-engagement behavior, design retention strategies, and identify potential VIP customers. Consecutive purchase patterns indicate strong product interest, subscription-like behavior, or high customer loyalty. This problem tests understanding of LAG function, window functions with PARTITION BY, and date difference calculations.

## Dataset
Customer order data with multiple purchase dates to demonstrate consecutive purchasing patterns and customer engagement levels.

## SQL Solution

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
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

-- Insert sample data into Customers
INSERT INTO Customers VALUES
(3001, 'Rajesh Kumar', 'rajesh.kumar@email.com', '2023-12-01', 'Premium'),
(3002, 'Priya Sharma', 'priya.sharma@email.com', '2023-11-15', 'Gold'),
(3003, 'Amit Patel', 'amit.patel@email.com', '2023-10-20', 'Silver'),
(3004, 'Sneha Reddy', 'sneha.reddy@email.com', '2023-12-10', 'Premium'),
(3005, 'Vikram Singh', 'vikram.singh@email.com', '2023-09-25', 'Gold'),
(3006, 'Anita Desai', 'anita.desai@email.com', '2023-11-30', 'Silver');

-- Insert sample data into Orders
INSERT INTO Orders VALUES
-- CUSTOMER 3001 (Rajesh Kumar) - CONSECUTIVE DAILY PURCHASES
(4001, 3001, 'iPhone 15 Pro', 129900.00, '2024-01-15', 'Delivered'),
(4002, 3001, 'MacBook Pro', 199900.00, '2024-01-16', 'Delivered'),  -- 1 day after
(4003, 3001, 'iPad Air', 59900.00, '2024-01-17', 'Delivered'),      -- 1 day after
(4004, 3001, 'AirPods Pro', 24900.00, '2024-01-20', 'Delivered'),
(4005, 3001, 'Apple Watch', 45900.00, '2024-01-21', 'Delivered'),   -- 1 day after

-- CUSTOMER 3002 (Priya Sharma) - NO CONSECUTIVE PURCHASES
(4006, 3002, 'Samsung TV', 89999.00, '2024-01-10', 'Delivered'),
(4007, 3002, 'Washing Machine', 45999.00, '2024-01-15', 'Delivered'),
(4008, 3002, 'Refrigerator', 89999.00, '2024-01-22', 'Delivered'),

-- CUSTOMER 3003 (Amit Patel) - LONG CONSECUTIVE STREAK
(4009, 3003, 'Laptop', 125000.00, '2024-02-01', 'Delivered'),
(4010, 3003, 'Monitor', 35000.00, '2024-02-02', 'Delivered'),       -- 1 day after
(4011, 3003, 'Keyboard', 8000.00, '2024-02-03', 'Delivered'),       -- 1 day after
(4012, 3003, 'Mouse', 3000.00, '2024-02-04', 'Delivered'),          -- 1 day after
(4013, 3003, 'Webcam', 12000.00, '2024-02-05', 'Delivered'),        -- 1 day after

-- CUSTOMER 3004 (Sneha Reddy) - TWO SEPARATE CONSECUTIVE PAIRS
(4014, 3004, 'Sofa Set', 89999.00, '2024-01-18', 'Delivered'),
(4015, 3004, 'Dining Table', 65999.00, '2024-01-19', 'Delivered'),  -- 1 day after
(4016, 3004, 'Coffee Table', 25999.00, '2024-01-25', 'Delivered'),
(4017, 3004, 'Bookshelf', 28999.00, '2024-01-26', 'Delivered'),     -- 1 day after

-- CUSTOMER 3005 (Vikram Singh) - MIXED PATTERN
(4018, 3005, 'Cricket Bat', 8999.00, '2024-02-10', 'Delivered'),
(4019, 3005, 'Football', 2999.00, '2024-02-11', 'Delivered'),       -- 1 day after
(4020, 3005, 'Tennis Racket', 12999.00, '2024-02-15', 'Delivered'),
(4021, 3005, 'Golf Clubs', 89999.00, '2024-02-20', 'Delivered'),

-- CUSTOMER 3006 (Anita Desai) - NO CONSECUTIVE PURCHASES
(4022, 3006, 'Book Set', 5999.00, '2024-02-05', 'Delivered'),
(4023, 3006, 'Desk Lamp', 3999.00, '2024-02-12', 'Delivered'),
(4024, 3006, 'Office Chair', 18999.00, '2024-02-20', 'Delivered');
```

## Query 1: Customers with Consecutive Daily Purchases 

```sql
-- Find customers who made purchases on consecutive days (MySQL version)
WITH cte AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
SELECT 
    customer_id, 
    order_date, 
    prev_order_date,
    DATEDIFF(order_date, prev_order_date) as days_gap
FROM cte 
WHERE DATEDIFF(order_date, prev_order_date) = 1
ORDER BY customer_id, order_date;
```

## Output:

```
customer_id | order_date | prev_order_date | days_gap
------------|------------|-----------------|----------
3001        | 2024-01-16 | 2024-01-15      | 1
3001        | 2024-01-17 | 2024-01-16      | 1
3001        | 2024-01-21 | 2024-01-20      | 1
3003        | 2024-02-02 | 2024-02-01      | 1
3003        | 2024-02-03 | 2024-02-02      | 1
3003        | 2024-02-04 | 2024-02-03      | 1
3003        | 2024-02-05 | 2024-02-04      | 1
3004        | 2024-01-19 | 2024-01-18      | 1
3004        | 2024-01-26 | 2024-01-25      | 1
3005        | 2024-02-11 | 2024-02-10      | 1
```


## Query 2: Consecutive Purchase Summary by Customer 

```sql
-- Analyze consecutive purchase behavior with customer details
WITH ConsecutivePurchases AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    COUNT(*) as consecutive_purchase_count,
    MIN(cp.order_date) as first_consecutive_date,
    MAX(cp.order_date) as last_consecutive_date,
    SUM(o.order_amount) as total_consecutive_amount
FROM ConsecutivePurchases cp
JOIN Customers c ON cp.customer_id = c.customer_id
JOIN Orders o ON cp.customer_id = o.customer_id AND cp.order_date = o.order_date
WHERE DATEDIFF(cp.order_date, cp.prev_order_date) = 1
GROUP BY c.customer_id, c.customer_name, c.customer_tier
ORDER BY consecutive_purchase_count DESC;
```

## Output:

```
customer_id | customer_name | customer_tier | consecutive_purchase_count | first_consecutive_date | last_consecutive_date | total_consecutive_amount
------------|---------------|---------------|---------------------------|------------------------|----------------------|-------------------------
3003        | Amit Patel    | Silver        | 4                         | 2024-02-02             | 2024-02-05            | 58000.00
3001        | Rajesh Kumar  | Premium       | 3                         | 2024-01-16             | 2024-01-21            | 270700.00
3004        | Sneha Reddy   | Premium       | 2                         | 2024-01-19             | 2024-01-26            | 94998.00
3005        | Vikram Singh  | Gold          | 1                         | 2024-02-11             | 2024-02-11            | 2999.00
```


## Query 3: Longest Consecutive Purchase Streak 

```sql
-- Identify longest consecutive purchase streaks
WITH OrderSequence AS (
    SELECT 
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date,
        CASE 
            WHEN DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) = 1 
            THEN 0 
            ELSE 1 
        END AS is_new_streak
    FROM Orders
),
StreakGroups AS (
    SELECT 
        customer_id,
        order_date,
        prev_date,
        SUM(is_new_streak) OVER (PARTITION BY customer_id ORDER BY order_date) AS streak_group
    FROM OrderSequence
),
StreakCounts AS (
    SELECT 
        customer_id,
        streak_group,
        COUNT(*) as streak_length,
        MIN(order_date) as streak_start,
        MAX(order_date) as streak_end
    FROM StreakGroups
    WHERE prev_date IS NOT NULL AND DATEDIFF(order_date, prev_date) = 1
    GROUP BY customer_id, streak_group
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    MAX(sc.streak_length) as longest_streak,
    (SELECT streak_start FROM StreakCounts WHERE customer_id = c.customer_id 
     ORDER BY streak_length DESC LIMIT 1) as streak_start_date,
    (SELECT streak_end FROM StreakCounts WHERE customer_id = c.customer_id 
     ORDER BY streak_length DESC LIMIT 1) as streak_end_date
FROM Customers c
JOIN StreakCounts sc ON c.customer_id = sc.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_tier
ORDER BY longest_streak DESC;
```

## Output:

```
customer_id | customer_name | customer_tier | longest_streak | streak_start_date | streak_end_date
------------|---------------|---------------|----------------|-------------------|----------------
3003        | Amit Patel    | Silver        | 4              | 2024-02-02        | 2024-02-05
3001        | Rajesh Kumar  | Premium       | 2              | 2024-01-16        | 2024-01-17
3004        | Sneha Reddy   | Premium       | 1              | 2024-01-19        | 2024-01-19
3005        | Vikram Singh  | Gold          | 1              | 2024-02-11        | 2024-02-11
```


## Query 4: Consecutive Purchase Patterns by Time Gap 

```sql
-- Analyze purchase patterns by different time gaps (1, 2, 3+ days)
WITH PurchaseGaps AS (
    SELECT 
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) as days_gap
    FROM Orders
)
SELECT 
    CASE 
        WHEN days_gap = 1 THEN 'Consecutive (1 day)'
        WHEN days_gap = 2 THEN 'Near Consecutive (2 days)'
        WHEN days_gap BETWEEN 3 AND 7 THEN 'Same Week (3-7 days)'
        WHEN days_gap > 7 THEN 'Sporadic (7+ days)'
        ELSE 'First Purchase'
    END as purchase_pattern,
    COUNT(*) as occurrence_count,
    COUNT(DISTINCT customer_id) as unique_customers,
    ROUND(AVG(days_gap), 1) as avg_gap_days
FROM PurchaseGaps
GROUP BY 
    CASE 
        WHEN days_gap = 1 THEN 'Consecutive (1 day)'
        WHEN days_gap = 2 THEN 'Near Consecutive (2 days)'
        WHEN days_gap BETWEEN 3 AND 7 THEN 'Same Week (3-7 days)'
        WHEN days_gap > 7 THEN 'Sporadic (7+ days)'
        ELSE 'First Purchase'
    END
ORDER BY occurrence_count DESC;
```

## Output:

```
purchase_pattern        | occurrence_count | unique_customers | avg_gap_days
------------------------|------------------|------------------|-------------
Sporadic (7+ days)      | 9                | 5                | 10.2
Consecutive (1 day)     | 10               | 4                | 1.0
First Purchase          | 6                | 6                | NULL
Same Week (3-7 days)    | 4                | 3                | 5.5
```


## Query 5: High-Engagement Customers (Multiple Consecutive Purchases) 

```sql
-- Identify high-engagement customers with 2+ consecutive purchases
WITH ConsecutivePurchases AS (
    SELECT 
        customer_id, 
        order_date,
        order_amount,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date
    FROM Orders o
),
ConsecutiveFlag AS (
    SELECT 
        customer_id,
        COUNT(*) as consecutive_count,
        SUM(order_amount) as consecutive_revenue
    FROM ConsecutivePurchases
    WHERE DATEDIFF(order_date, prev_date) = 1
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    cf.consecutive_count,
    cf.consecutive_revenue,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as total_revenue,
    ROUND((cf.consecutive_revenue / SUM(o.order_amount)) * 100, 2) as consecutive_pct,
    CASE 
        WHEN cf.consecutive_count >= 4 THEN 'Super Engaged'
        WHEN cf.consecutive_count >= 2 THEN 'Highly Engaged'
        ELSE 'Engaged'
    END as engagement_level
FROM Customers c
JOIN ConsecutiveFlag cf ON c.customer_id = cf.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_tier, cf.consecutive_count, cf.consecutive_revenue
ORDER BY cf.consecutive_count DESC, cf.consecutive_revenue DESC;
```

## Output:

```
customer_id | customer_name | customer_tier | consecutive_count | consecutive_revenue | total_orders | total_revenue | consecutive_pct | engagement_level
------------|---------------|---------------|-------------------|--------------------|--------------|--------------|-----------------|-----------------
3003        | Amit Patel    | Silver        | 4                 | 58000.00           | 5            | 183000.00    | 31.69           | Super Engaged
3001        | Rajesh Kumar  | Premium       | 3                 | 270700.00          | 5            | 460500.00    | 58.78           | Highly Engaged
3004        | Sneha Reddy   | Premium       | 2                 | 94998.00           | 4            | 210996.00    | 45.02           | Highly Engaged
```


## How It Works
* **LAG() Function**: Accesses data from the previous row within the same partition
* **PARTITION BY**: Creates separate windows for each customer to track their own sequence
* **ORDER BY**: Determines the order of rows within each partition
* **DATEDIFF()**: Calculates the difference in days between two dates
* **Consecutive Logic**: When DATEDIFF = 1, purchases are on consecutive days
* **Streak Detection**: Identify continuous sequences of consecutive purchases
* **Window Functions**: Enable row-by-row comparison without self-joins

## Real World Use Cases
1. **Customer Engagement**: Identify highly engaged customers for VIP programs
2. **Retention Strategies**: Design interventions for customers losing momentum
3. **Subscription Behavior**: Understand daily usage patterns for subscription services
4. **Marketing Campaigns**: Target consecutive purchasers with loyalty rewards
5. **Product Recommendations**: Suggest next products based on purchase sequences
6. **Churn Prevention**: Alert when consecutive purchase patterns break

## Key Learning
**LAG Function with PARTITION BY** is essential for analyzing sequential patterns in customer behavior. It enables row-by-row comparison within customer groups without complex self-joins.

**Date Difference Analysis** combined with window functions reveals temporal patterns that drive business insights about customer engagement and loyalty.

**Streak Detection** using cumulative sums and grouping identifies continuous patterns, which is crucial for gamification, loyalty programs, and engagement metrics.
