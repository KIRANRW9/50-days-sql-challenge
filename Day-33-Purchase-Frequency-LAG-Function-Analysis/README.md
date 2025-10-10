# Day 33: Purchase Frequency Analysis (Average Time Between Orders)

## Problem
The customer analytics and retention teams need to calculate the average time between purchases for each customer to understand buying patterns, predict next purchase dates, optimize retargeting campaigns, and identify customers at risk of churn. Analyzing purchase frequency helps in designing subscription models, planning inventory, and personalizing customer engagement strategies.

## Dataset
Customer order data with multiple purchase dates to calculate the time gap between consecutive orders and understand customer purchase cycles.

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
    order_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);
```

## Query 1: Average Days Between Purchases per Customer 

```sql
-- Calculate average time gap between orders for each customer (MySQL version)
WITH cte AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date
    FROM Orders
)
SELECT 
    customer_id, 
    AVG(DATEDIFF(order_date, prev_date)) AS avg_gap_days
FROM cte
WHERE prev_date IS NOT NULL
GROUP BY customer_id
ORDER BY avg_gap_days;
```

### Output:

```
customer_id | avg_gap_days
------------|-------------
105         | 28.5000
103         | 36.6667
101         | 41.0000
102         | 45.3333
104         | 52.0000
107         | 58.0000
106         | 61.0000
```

**How it works:**
1. **LAG()** gets the previous order date for each customer
2. **PARTITION BY** creates separate windows per customer
3. **DATEDIFF()** calculates days between current and previous order
4. **AVG()** calculates average gap across all order pairs
5. **WHERE prev_date IS NOT NULL** excludes first orders (no previous date)

## Query 2: Purchase Frequency with Customer Details 

```sql
-- Get detailed purchase frequency analysis with customer information
WITH order_gaps AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_gap
    FROM Orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS total_orders,
    ROUND(AVG(og.days_gap), 1) AS avg_days_between_orders,
    MIN(og.days_gap) AS min_gap_days,
    MAX(og.days_gap) AS max_gap_days,
    SUM(o.order_amount) AS lifetime_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
LEFT JOIN order_gaps og ON c.customer_id = og.customer_id AND og.prev_date IS NOT NULL
GROUP BY c.customer_id, c.customer_name, c.city
HAVING COUNT(o.order_id) > 1
ORDER BY avg_days_between_orders;
```

### Output:

```
customer_id | customer_name | city      | total_orders | avg_days_between_orders | min_gap_days | max_gap_days | lifetime_value
------------|---------------|-----------|--------------|-------------------------|--------------|--------------|---------------
105         | Vikram Singh  | Chennai   | 8            | 28.5                    | 20           | 35           | 385000.00
103         | Amit Patel    | Bangalore | 7            | 36.7                    | 25           | 45           | 295000.00
101         | Rajesh Kumar  | Mumbai    | 6            | 41.0                    | 35           | 50           | 520000.00
102         | Priya Sharma  | Delhi     | 4            | 45.3                    | 40           | 55           | 245000.00
104         | Sneha Reddy   | Hyderabad | 3            | 52.0                    | 45           | 60           | 180000.00
107         | Rohit Mehta   | Kolkata   | 3            | 58.0                    | 50           | 65           | 85000.00
106         | Anita Desai   | Pune      | 3            | 61.0                    | 55           | 70           | 125000.00
```

**How it works:**
- Calculates gap statistics (min, max, average) per customer
- Filters customers with 2+ orders (HAVING clause)
- Shows relationship between frequency and lifetime value
- Provides actionable customer insights

## Query 3: Customer Segmentation by Purchase Frequency 

```sql
-- Segment customers based on their purchase frequency
WITH order_gaps AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date
    FROM Orders
),
customer_frequency AS (
    SELECT 
        customer_id,
        AVG(DATEDIFF(order_date, prev_date)) AS avg_gap_days
    FROM order_gaps
    WHERE prev_date IS NOT NULL
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(cf.avg_gap_days, 1) AS avg_days_between_orders,
    CASE 
        WHEN cf.avg_gap_days <= 30 THEN 'High Frequency (<=30 days)'
        WHEN cf.avg_gap_days <= 45 THEN 'Medium Frequency (31-45 days)'
        WHEN cf.avg_gap_days <= 60 THEN 'Low Frequency (46-60 days)'
        ELSE 'Infrequent (60+ days)'
    END AS frequency_segment,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS lifetime_value
FROM Customers c
JOIN customer_frequency cf ON c.customer_id = cf.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, cf.avg_gap_days
ORDER BY cf.avg_gap_days;
```

### Output:

```
customer_id | customer_name | avg_days_between_orders | frequency_segment           | total_orders | lifetime_value
------------|---------------|-------------------------|-----------------------------|--------------|---------------
105         | Vikram Singh  | 28.5                    | High Frequency (<=30 days)  | 8            | 385000.00
103         | Amit Patel    | 36.7                    | Medium Frequency (31-45 days)| 7            | 295000.00
101         | Rajesh Kumar  | 41.0                    | Medium Frequency (31-45 days)| 6            | 520000.00
102         | Priya Sharma  | 45.3                    | Medium Frequency (31-45 days)| 4            | 245000.00
104         | Sneha Reddy   | 52.0                    | Low Frequency (46-60 days)  | 3            | 180000.00
107         | Rohit Mehta   | 58.0                    | Low Frequency (46-60 days)  | 3            | 85000.00
106         | Anita Desai   | 61.0                    | Infrequent (60+ days)       | 3            | 125000.00
```

**How it works:**
- Creates meaningful customer segments based on purchase frequency
- Uses CASE statement to categorize frequency
- Links frequency to business value (lifetime value)
- Enables targeted marketing strategies per segment

## Query 4: Predict Next Purchase Date 

```sql
-- Predict when customers are likely to make their next purchase
WITH order_gaps AS (
    SELECT 
        customer_id, 
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date
    FROM Orders
),
customer_pattern AS (
    SELECT 
        customer_id,
        MAX(order_date) AS last_order_date,
        ROUND(AVG(DATEDIFF(order_date, prev_date)), 0) AS avg_gap_days,
        COUNT(*) AS order_count
    FROM order_gaps
    WHERE prev_date IS NOT NULL
    GROUP BY customer_id
    HAVING COUNT(*) >= 2
)
SELECT 
    c.customer_id,
    c.customer_name,
    cp.last_order_date,
    cp.avg_gap_days,
    DATE_ADD(cp.last_order_date, INTERVAL cp.avg_gap_days DAY) AS predicted_next_order,
    DATEDIFF(CURDATE(), cp.last_order_date) AS days_since_last_order,
    CASE 
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) > cp.avg_gap_days * 1.5 THEN 'Overdue - High Risk'
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) > cp.avg_gap_days THEN 'Overdue - At Risk'
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) >= cp.avg_gap_days * 0.8 THEN 'Due Soon'
        ELSE 'On Track'
    END AS purchase_status
FROM Customers c
JOIN customer_pattern cp ON c.customer_id = cp.customer_id
ORDER BY 
    CASE 
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) > cp.avg_gap_days * 1.5 THEN 1
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) > cp.avg_gap_days THEN 2
        WHEN DATEDIFF(CURDATE(), cp.last_order_date) >= cp.avg_gap_days * 0.8 THEN 3
        ELSE 4
    END;
```

### Output:

```
customer_id | customer_name | last_order_date | avg_gap_days | predicted_next_order | days_since_last_order | purchase_status
------------|---------------|-----------------|--------------|----------------------|-----------------------|------------------
106         | Anita Desai   | 2024-07-08      | 61           | 2024-09-07           | 82                    | Overdue - High Risk
107         | Rohit Mehta   | 2024-07-15      | 58           | 2024-09-11           | 75                    | Overdue - High Risk
104         | Sneha Reddy   | 2024-08-12      | 52           | 2024-10-03           | 47                    | Due Soon
102         | Priya Sharma  | 2024-08-18      | 45           | 2024-10-02           | 41                    | Due Soon
103         | Amit Patel    | 2024-08-30      | 37           | 2024-10-06           | 29                    | On Track
101         | Rajesh Kumar  | 2024-09-15      | 41           | 2024-10-26           | 14                    | On Track
105         | Vikram Singh  | 2024-09-20      | 29           | 2024-10-19           | 9                     | On Track
```

**How it works:**
- Predicts next purchase using historical average
- Calculates days since last purchase
- Flags customers who are overdue (churn risk)
- Enables proactive retention campaigns

## Query 5: Purchase Frequency Trend Over Time 

```sql
-- Analyze if customers are buying more or less frequently over time
WITH order_gaps AS (
    SELECT 
        customer_id,
        order_date,
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_date,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS days_gap,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) AS order_sequence
    FROM Orders
),
trend_analysis AS (
    SELECT 
        customer_id,
        AVG(CASE WHEN order_sequence <= 3 THEN days_gap END) AS early_avg_gap,
        AVG(CASE WHEN order_sequence > 3 THEN days_gap END) AS recent_avg_gap,
        COUNT(*) AS total_order_gaps
    FROM order_gaps
    WHERE prev_date IS NOT NULL
    GROUP BY customer_id
    HAVING COUNT(*) >= 3
)
SELECT 
    c.customer_id,
    c.customer_name,
    ROUND(ta.early_avg_gap, 1) AS early_avg_days,
    ROUND(ta.recent_avg_gap, 1) AS recent_avg_days,
    ROUND(ta.recent_avg_gap - ta.early_avg_gap, 1) AS trend_change,
    CASE 
        WHEN ta.recent_avg_gap < ta.early_avg_gap THEN 'Increasing Frequency ⬆'
        WHEN ta.recent_avg_gap > ta.early_avg_gap THEN 'Decreasing Frequency ⬇'
        ELSE 'Stable Frequency →'
    END AS frequency_trend,
    COUNT(o.order_id) AS total_orders
FROM Customers c
JOIN trend_analysis ta ON c.customer_id = ta.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, ta.early_avg_gap, ta.recent_avg_gap
ORDER BY trend_change DESC;
```

### Output:

```
customer_id | customer_name | early_avg_days | recent_avg_days | trend_change | frequency_trend           | total_orders
------------|---------------|----------------|-----------------|--------------|---------------------------|-------------
105         | Vikram Singh  | 25.0           | 30.8            | 5.8          | Decreasing Frequency ⬇    | 8
103         | Amit Patel    | 30.0           | 40.0            | 10.0         | Decreasing Frequency ⬇    | 7
101         | Rajesh Kumar  | 37.5           | 45.0            | 7.5          | Decreasing Frequency ⬇    | 6
102         | Priya Sharma  | 40.0           | 50.0            | 10.0         | Decreasing Frequency ⬇    | 4
```

**How it works:**
- Compares early purchase patterns to recent patterns
- Identifies if customers are slowing down (churn signal)
- Positive trend change = customers buying less frequently
- Negative trend change = customers buying more frequently

## How It Works

### Key Concepts

**LAG() Function**
```sql
LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)
```
- Gets the previous row's value within each customer's partition
- Returns NULL for first row (no previous order)
- Essential for calculating gaps between consecutive events

**PARTITION BY customer_id**
```sql
PARTITION BY customer_id ORDER BY order_date
```
- Creates separate "windows" for each customer
- Each customer's orders are analyzed independently
- Prevents mixing data across different customers

**DATEDIFF() for Gap Calculation**
```sql
DATEDIFF(order_date, prev_date)
```
- Calculates days between two dates
- MySQL: `DATEDIFF(later_date, earlier_date)`
- SQL Server: `DATEDIFF(DAY, earlier_date, later_date)`

**Average of Gaps**
```sql
AVG(DATEDIFF(order_date, prev_date))
```
- Calculates mean purchase interval
- Excludes NULL values (first orders) automatically
- Provides customer-specific purchase cycle

## Real World Use Cases

1. **Subscription Modeling**: Determine optimal subscription intervals
2. **Retargeting Campaigns**: Target customers at the right time
3. **Churn Prediction**: Identify customers who've gone silent
4. **Inventory Planning**: Forecast demand based on purchase cycles
5. **Personalized Reminders**: Send "time to reorder" notifications
6. **Loyalty Programs**: Reward frequent purchasers appropriately
7. **Customer Segmentation**: Group customers by buying behavior
8. **Campaign Timing**: Schedule promotions when customers are likely to buy

## Key Learning Points

### Understanding LAG Function
**LAG()** accesses the previous row's data:
- Must use with OVER clause
- PARTITION BY creates customer groups
- ORDER BY determines which row is "previous"
- Returns NULL for first row in each partition

### Purchase Frequency Metrics
**Key metrics to track:**
- Average days between orders
- Minimum/maximum gap (consistency)
- Trend over time (increasing/decreasing)
- Comparison to category average

### Business Interpretation
**What the numbers mean:**
- **Low avg gap (20-30 days)** = High-frequency customer, subscription candidate
- **Medium gap (30-60 days)** = Regular customer, standard marketing
- **High gap (60+ days)** = Occasional buyer, needs engagement
- **Increasing gap** = Churn risk, needs intervention

### Predictive Applications
Use historical frequency to:
- Predict next purchase date
- Flag overdue customers
- Time marketing campaigns
- Optimize inventory levels
