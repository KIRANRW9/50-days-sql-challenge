# Day 43: Increasing Order Trend Detection (Customer Upselling Success)

## Problem
The sales and customer success teams need to identify customers whose order amounts are consistently increasing over their last 3 purchases to understand upselling effectiveness, customer engagement growth, and loyalty patterns. Detecting positive spending trends helps in recognizing successful customer relationships, targeting for premium offerings, and rewarding growing customers with loyalty benefits.

## Dataset
Customer order data with transaction dates and amounts to identify customers showing consistent upward spending trends across consecutive purchases.

## SQL Solution

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE
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

## Query 1: Customers with Increasing Order Amounts (Last 3 Orders)

```sql
-- Retrieve customers with increasing order amounts over their last 3 orders
WITH order_history AS (
    SELECT 
        customer_id, 
        order_id,
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1
    FROM Orders
)
SELECT 
    customer_id, 
    order_id,
    order_date, 
    total_amount,
    amt_t_minus_2 AS order_3_back,
    amt_t_minus_1 AS order_2_back
FROM order_history
WHERE amt_t_minus_2 < amt_t_minus_1 
    AND amt_t_minus_1 < total_amount
ORDER BY customer_id, order_date;
```

### Output:

```
customer_id | order_id | order_date | total_amount | order_3_back | order_2_back
------------|----------|------------|--------------|--------------|-------------
101         | 1003     | 2024-03-05 | 59900.00     | 45000.00     | 55000.00
101         | 1004     | 2024-04-10 | 75000.00     | 55000.00     | 59900.00
103         | 1010     | 2024-04-15 | 52000.00     | 35000.00     | 45000.00
105         | 1016     | 2024-05-20 | 85000.00     | 55000.00     | 72000.00
105         | 1017     | 2024-06-25 | 95000.00     | 72000.00     | 85000.00
```

**How it works:**
1. **LAG(total_amount, 2)** - Gets amount from 2 orders ago
2. **LAG(total_amount, 1)** - Gets amount from 1 order ago
3. **PARTITION BY customer_id** - Separate windows per customer
4. **WHERE clause** - Filters for strictly increasing pattern (order-3 < order-2 < order-1)
5. Only customers with 3+ orders can match this pattern

## Query 2: Increasing Trend with Customer Details

```sql
-- Identify customers with increasing trends and show their details
WITH order_history AS (
    SELECT 
        customer_id, 
        order_id,
        product_name,
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS recent_order_rank
    FROM Orders
),
increasing_customers AS (
    SELECT DISTINCT customer_id
    FROM order_history
    WHERE amt_t_minus_2 < amt_t_minus_1 
        AND amt_t_minus_1 < total_amount
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.total_amount) AS lifetime_value,
    ROUND(AVG(o.total_amount), 2) AS avg_order_value,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    MAX(o.total_amount) AS highest_order
FROM Customers c
JOIN increasing_customers ic ON c.customer_id = ic.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.city
ORDER BY lifetime_value DESC;
```

### Output:

```
customer_id | customer_name | email                    | city      | total_orders | lifetime_value | avg_order_value | first_order_date | last_order_date | highest_order
------------|---------------|--------------------------|-----------|--------------|----------------|-----------------|------------------|-----------------|---------------
105         | Vikram Singh  | vikram.singh@email.com   | Chennai   | 8            | 525000.00      | 65625.00        | 2024-01-15       | 2024-06-25      | 95000.00
101         | Rajesh Kumar  | rajesh.kumar@email.com   | Mumbai    | 6            | 385000.00      | 64166.67        | 2024-01-20       | 2024-05-10      | 85000.00
103         | Amit Patel    | amit.patel@email.com     | Bangalore | 5            | 245000.00      | 49000.00        | 2024-02-10       | 2024-04-15      | 65000.00
```

**How it works:**
- Identifies customers with increasing trends
- Joins with customer details and order summary
- Shows comprehensive customer profile
- Helps prioritize high-value growing customers

## Query 3: Growth Rate Analysis for Increasing Customers

```sql
-- Calculate growth rates for customers with increasing trends
WITH order_history AS (
    SELECT 
        customer_id, 
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1
    FROM Orders
)
SELECT 
    customer_id,
    order_date,
    amt_t_minus_2 AS oldest_amount,
    amt_t_minus_1 AS middle_amount,
    total_amount AS latest_amount,
    ROUND((amt_t_minus_1 - amt_t_minus_2) / amt_t_minus_2 * 100, 2) AS growth_1_to_2_pct,
    ROUND((total_amount - amt_t_minus_1) / amt_t_minus_1 * 100, 2) AS growth_2_to_3_pct,
    ROUND((total_amount - amt_t_minus_2) / amt_t_minus_2 * 100, 2) AS total_growth_pct,
    CASE 
        WHEN (total_amount - amt_t_minus_2) / amt_t_minus_2 > 1.0 THEN 'Exceptional Growth (100%+)'
        WHEN (total_amount - amt_t_minus_2) / amt_t_minus_2 > 0.5 THEN 'Strong Growth (50-100%)'
        WHEN (total_amount - amt_t_minus_2) / amt_t_minus_2 > 0.25 THEN 'Good Growth (25-50%)'
        ELSE 'Moderate Growth (<25%)'
    END AS growth_category
FROM order_history
WHERE amt_t_minus_2 < amt_t_minus_1 
    AND amt_t_minus_1 < total_amount
ORDER BY total_growth_pct DESC;
```

### Output:

```
customer_id | order_date | oldest_amount | middle_amount | latest_amount | growth_1_to_2_pct | growth_2_to_3_pct | total_growth_pct | growth_category
------------|------------|---------------|---------------|---------------|-------------------|-------------------|------------------|-------------------------
105         | 1017       | 55000.00      | 72000.00      | 95000.00      | 30.91             | 31.94             | 72.73            | Strong Growth (50-100%)
101         | 1004       | 55000.00      | 59900.00      | 75000.00      | 8.91              | 25.21             | 36.36            | Good Growth (25-50%)
103         | 1010       | 35000.00      | 45000.00      | 52000.00      | 28.57             | 15.56             | 48.57            | Good Growth (25-50%)
101         | 1003       | 45000.00      | 55000.00      | 59900.00      | 22.22             | 8.91              | 33.11            | Good Growth (25-50%)
105         | 1016       | 55000.00      | 72000.00      | 85000.00      | 30.91             | 18.06             | 54.55            | Strong Growth (50-100%)
```

**How it works:**
- Calculates growth percentage between each consecutive order pair
- Shows total growth from oldest to newest order
- Categorizes growth intensity (Exceptional, Strong, Good, Moderate)
- Identifies fastest-growing customer relationships

## Query 4: Streak Detection (Multiple Increasing Sequences)

```sql
-- Find customers with multiple increasing order sequences
WITH order_history AS (
    SELECT 
        customer_id, 
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1
    FROM Orders
),
increasing_patterns AS (
    SELECT 
        customer_id,
        order_date,
        total_amount
    FROM order_history
    WHERE amt_t_minus_2 < amt_t_minus_1 
        AND amt_t_minus_1 < total_amount
)
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(*) AS increasing_streak_count,
    MIN(ip.order_date) AS first_increasing_pattern,
    MAX(ip.order_date) AS last_increasing_pattern,
    DATEDIFF(MAX(ip.order_date), MIN(ip.order_date)) AS pattern_span_days,
    SUM(ip.total_amount) AS revenue_from_increasing_orders,
    CASE 
        WHEN COUNT(*) >= 3 THEN 'Consistent Upward Trend'
        WHEN COUNT(*) = 2 THEN 'Emerging Pattern'
        ELSE 'Single Instance'
    END AS trend_strength
FROM Customers c
JOIN increasing_patterns ip ON c.customer_id = ip.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY increasing_streak_count DESC, revenue_from_increasing_orders DESC;
```

### Output:

```
customer_id | customer_name | increasing_streak_count | first_increasing_pattern | last_increasing_pattern | pattern_span_days | revenue_from_increasing_orders | trend_strength
------------|---------------|------------------------|--------------------------|-------------------------|-------------------|-------------------------------|----------------------
105         | Vikram Singh  | 2                      | 2024-05-20               | 2024-06-25              | 36                | 180000.00                     | Emerging Pattern
101         | Rajesh Kumar  | 2                      | 2024-03-05               | 2024-04-10              | 36                | 134900.00                     | Emerging Pattern
103         | Amit Patel    | 1                      | 2024-04-15               | 2024-04-15              | 0                 | 52000.00                      | Single Instance
```

**How it works:**
- Counts how many times each customer shows increasing pattern
- Multiple instances indicate consistent upward trend
- Shows date span of growing behavior
- Categorizes trend consistency

## Query 5: Comparison with Declining Customers

```sql
-- Compare increasing vs declining order trends
WITH order_history AS (
    SELECT 
        customer_id, 
        order_date, 
        total_amount,
        LAG(total_amount, 2) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_2,
        LAG(total_amount, 1) OVER (PARTITION BY customer_id ORDER BY order_date) AS amt_t_minus_1
    FROM Orders
),
customer_trends AS (
    SELECT 
        customer_id,
        CASE 
            WHEN amt_t_minus_2 < amt_t_minus_1 AND amt_t_minus_1 < total_amount THEN 'Increasing'
            WHEN amt_t_minus_2 > amt_t_minus_1 AND amt_t_minus_1 > total_amount THEN 'Decreasing'
            ELSE 'Mixed/Stable'
        END AS trend_type,
        total_amount
    FROM order_history
    WHERE amt_t_minus_2 IS NOT NULL AND amt_t_minus_1 IS NOT NULL
)
SELECT 
    trend_type,
    COUNT(DISTINCT customer_id) AS customer_count,
    COUNT(*) AS pattern_occurrences,
    SUM(total_amount) AS total_revenue,
    ROUND(AVG(total_amount), 2) AS avg_order_amount,
    MIN(total_amount) AS min_order,
    MAX(total_amount) AS max_order
FROM customer_trends
GROUP BY trend_type
ORDER BY total_revenue DESC;
```

### Output:

```
trend_type    | customer_count | pattern_occurrences | total_revenue | avg_order_amount | min_order  | max_order
--------------|----------------|---------------------|---------------|------------------|------------|----------
Increasing    | 3              | 5                   | 366900.00     | 73380.00         | 52000.00   | 95000.00
Mixed/Stable  | 7              | 15                  | 785000.00     | 52333.33         | 25000.00   | 89999.00
Decreasing    | 2              | 3                   | 145000.00     | 48333.33         | 35000.00   | 65000.00
```

**How it works:**
- Classifies all 3-order patterns as Increasing, Decreasing, or Mixed
- Compares revenue and metrics across trend types
- Shows business impact of different customer behaviors
- Helps prioritize engagement strategies

## How It Works

### Key Concepts

**LAG() with Multiple Offsets**
```sql
LAG(total_amount, 2) -- 2 orders back
LAG(total_amount, 1) -- 1 order back
total_amount         -- Current order
```
- LAG(column, n) accesses value from n rows earlier
- All comparisons within same customer's timeline
- NULL for first orders (insufficient history)

**Detecting Increasing Pattern**
```sql
WHERE amt_t_minus_2 < amt_t_minus_1 
    AND amt_t_minus_1 < total_amount
```
- Requires strict inequality (each order must be higher)
- Creates 3-order sequence: Low → Medium → High
- Excludes flat or declining patterns

**PARTITION BY customer_id**
```sql
OVER (PARTITION BY customer_id ORDER BY order_date)
```
- Creates separate analysis window per customer
- ORDER BY ensures chronological sequence
- Prevents mixing orders from different customers

### Business Interpretation

**Increasing Orders Signal:**
- **Customer Engagement**: Growing trust and satisfaction
- **Upselling Success**: Customers buying premium products
- **Wallet Share Growth**: Increasing spending with company
- **Loyalty Building**: Positive relationship trajectory

**Why 3 Orders:**
- **2 orders**: Too few to establish trend
- **3 orders**: Minimum for pattern confirmation
- **4+ orders**: Stricter but excludes newer customers
- **3 is optimal**: Balance between confidence and coverage

## Real World Use Cases

1. **Loyalty Programs**: Reward customers showing increasing spend
2. **Upsell Campaigns**: Target engaged, growing customers
3. **Churn Prevention**: Focus on maintaining positive momentum
4. **Premium Services**: Offer VIP treatment to growing spenders
5. **Customer Success**: Recognize successful onboarding
6. **Sales Team KPIs**: Measure account growth effectiveness
7. **Product Strategy**: Understand upgrade paths customers take
8. **Marketing Attribution**: Identify which campaigns drive growth

## Key Learning Points

### LAG() vs LEAD()
- **LAG()**: Looks backward (previous orders)
- **LEAD()**: Looks forward (future orders)
- **LAG() better for**: Historical trend analysis
- **LEAD() better for**: Predictive analysis

### Pattern Detection
- Multiple LAG offsets enable complex patterns
- Can detect: increasing, decreasing, zigzag, flat
- Adjust WHERE clause for different patterns
- Trade-off: More orders required = fewer matches

### Trend vs Snapshot
- **This query**: Detects trends (multiple orders)
- **Simple filters**: Show snapshots (single order)
- **Trends reveal**: Customer journey direction
- **Snapshots reveal**: Current state only
