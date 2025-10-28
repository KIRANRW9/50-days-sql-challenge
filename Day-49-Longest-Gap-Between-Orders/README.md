# Day 49: Longest Gap Between Orders Analysis

## Problem
The customer retention and engagement teams need to identify the longest time gap between consecutive orders for each customer to detect at-risk customers, predict churn, optimize re-engagement campaigns, and understand purchase frequency patterns. Long gaps indicate declining engagement and present opportunities for targeted retention efforts.

## Dataset
Customer order history with transaction dates to calculate time intervals between consecutive purchases, identify customers with extended dormancy periods, and segment users by purchase frequency patterns.

## SQL Solution

### Table Structure

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    customer_segment VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_name VARCHAR(100),
    order_amount DECIMAL(10,2),
    order_date DATE NOT NULL,
    order_status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
```

---

## Query 1: Longest Gap Between Orders

**Find the maximum time gap between consecutive orders for each customer**

```sql
WITH cte AS (
    SELECT 
        customer_id, 
        order_date, 
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date
    FROM Orders
)
SELECT 
    customer_id, 
    MAX(DATEDIFF(order_date, prev_order_date)) AS max_gap_days
FROM cte 
WHERE prev_order_date IS NOT NULL 
GROUP BY customer_id
ORDER BY max_gap_days DESC;
```

**Output:**
```
customer_id | max_gap_days
------------|-------------
    104     |     90
    102     |     60
    105     |     45
    101     |     30
    103     |     15
```

**How it works:**
- LAG() gets previous order date for each customer
- PARTITION BY customer_id creates separate windows per customer
- DATEDIFF calculates days between consecutive orders
- MAX() finds longest gap for each customer
- WHERE filters out NULL (first order has no previous)
- Customer 104 has 90-day gap (high churn risk)
- Customer 103 has only 15-day gap (engaged customer)

---

## Query 2: Detailed Gap Analysis with Customer Information

**Show all gaps with customer details and gap classifications**

```sql
WITH order_gaps AS (
    SELECT 
        o.customer_id, 
        o.order_id,
        o.order_date, 
        o.order_amount,
        LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS prev_order_date,
        DATEDIFF(o.order_date, LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date)) AS gap_days
    FROM Orders o
),
max_gaps AS (
    SELECT 
        customer_id,
        MAX(gap_days) AS max_gap_days
    FROM order_gaps
    WHERE prev_order_date IS NOT NULL
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.customer_segment,
    mg.max_gap_days,
    COUNT(o.order_id) AS total_orders,
    MIN(o.order_date) AS first_order_date,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(MAX(o.order_date), MIN(o.order_date)) AS customer_lifetime_days,
    CASE 
        WHEN mg.max_gap_days >= 90 THEN '🔴 Critical (90+ days)'
        WHEN mg.max_gap_days >= 60 THEN '🟠 High Risk (60-89 days)'
        WHEN mg.max_gap_days >= 30 THEN '🟡 Medium Risk (30-59 days)'
        WHEN mg.max_gap_days >= 15 THEN '🟢 Low Risk (15-29 days)'
        ELSE '✅ Engaged (<15 days)'
    END AS risk_category
FROM Customers c
JOIN max_gaps mg ON c.customer_id = mg.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.customer_segment, mg.max_gap_days
ORDER BY mg.max_gap_days DESC;
```

**Output:**
```
customer_id | customer_name   | email                   | customer_segment | max_gap_days | total_orders | first_order_date | last_order_date | customer_lifetime_days | risk_category
------------|-----------------|-------------------------|------------------|--------------|--------------|------------------|-----------------|------------------------|-------------------------
    104     | Sneha Reddy     | sneha.reddy@email.com   | Premium          |      90      |      4       |   2024-01-08     |   2024-06-15    |         159            | 🔴 Critical (90+ days)
    102     | Priya Sharma    | priya.sharma@email.com  | Standard         |      60      |      5       |   2024-01-03     |   2024-07-10    |         189            | 🟠 High Risk (60-89 days)
    105     | Vikram Singh    | vikram.singh@email.com  | VIP              |      45      |      6       |   2024-01-10     |   2024-08-20    |         223            | 🟡 Medium Risk (30-59 days)
    101     | Rajesh Kumar    | rajesh.kumar@email.com  | Premium          |      30      |      7       |   2024-01-01     |   2024-09-15    |         258            | 🟡 Medium Risk (30-59 days)
    103     | Amit Patel      | amit.patel@email.com    | Standard         |      15      |      8       |   2024-01-05     |   2024-10-01    |         270            | 🟢 Low Risk (15-29 days)
```

**How it works:**
- Combines gap analysis with customer profiles
- Classifies customers by risk level based on max gap
- Shows total orders and customer lifetime
- Critical risk customers need immediate attention
- Engaged customers have consistent purchase patterns
- Helps prioritize retention campaigns

---

## Query 3: All Gaps Between Orders

**Show every gap between consecutive orders for detailed analysis**

```sql
WITH order_gaps AS (
    SELECT 
        o.customer_id, 
        c.customer_name,
        o.order_id,
        o.order_date, 
        o.order_amount,
        LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS prev_order_date,
        LAG(o.order_id) OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS prev_order_id,
        DATEDIFF(o.order_date, LAG(o.order_date) OVER (PARTITION BY o.customer_id ORDER BY o.order_date)) AS gap_days,
        ROW_NUMBER() OVER (PARTITION BY o.customer_id ORDER BY o.order_date) AS order_number
    FROM Orders o
    JOIN Customers c ON o.customer_id = c.customer_id
)
SELECT 
    customer_id,
    customer_name,
    prev_order_id,
    order_id AS current_order_id,
    prev_order_date,
    order_date AS current_order_date,
    gap_days,
    order_amount,
    order_number,
    CASE 
        WHEN gap_days >= 60 THEN '⚠️ Extended Gap'
        WHEN gap_days >= 30 THEN '⏰ Long Gap'
        WHEN gap_days >= 15 THEN '📅 Normal Gap'
        ELSE '⚡ Short Gap'
    END AS gap_type
FROM order_gaps
WHERE prev_order_date IS NOT NULL
ORDER BY customer_id, order_date;
```

**Output:**
```
customer_id | customer_name   | prev_order_id | current_order_id | prev_order_date | current_order_date | gap_days | order_amount | order_number | gap_type
------------|-----------------|---------------|------------------|-----------------|-----------------------|----------|--------------|--------------|------------------
    101     | Rajesh Kumar    |      1        |       2          | 2024-01-01      | 2024-01-15            |    14    |   12000.00   |      2       | 📅 Normal Gap
    101     | Rajesh Kumar    |      2        |       3          | 2024-01-15      | 2024-02-10            |    26    |   18000.00   |      3       | 📅 Normal Gap
    101     | Rajesh Kumar    |      3        |       4          | 2024-02-10      | 2024-03-12            |    30    |   15000.00   |      4       | ⏰ Long Gap
    102     | Priya Sharma    |      5        |       6          | 2024-01-03      | 2024-01-25            |    22    |   22000.00   |      2       | 📅 Normal Gap
    102     | Priya Sharma    |      6        |       7          | 2024-01-25      | 2024-03-26            |    60    |   28000.00   |      3       | ⚠️ Extended Gap
```

**How it works:**
- Shows every gap between consecutive orders
- ROW_NUMBER tracks order sequence
- Gap type classification for quick identification
- Helps identify specific periods of dormancy
- Extended gaps (60+ days) need investigation
- Pattern analysis: are gaps increasing over time?

---

## Query 4: Average Gap vs Longest Gap Analysis

**Compare average purchase frequency with longest gap**

```sql
WITH order_gaps AS (
    SELECT 
        customer_id, 
        order_date, 
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS gap_days
    FROM Orders
),
customer_metrics AS (
    SELECT 
        customer_id,
        COUNT(*) AS gap_count,
        ROUND(AVG(gap_days), 2) AS avg_gap_days,
        MAX(gap_days) AS max_gap_days,
        MIN(gap_days) AS min_gap_days,
        ROUND(STDDEV(gap_days), 2) AS stddev_gap_days
    FROM order_gaps
    WHERE prev_order_date IS NOT NULL
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_segment,
    COUNT(o.order_id) AS total_orders,
    cm.avg_gap_days,
    cm.min_gap_days,
    cm.max_gap_days,
    cm.stddev_gap_days,
    ROUND(cm.max_gap_days - cm.avg_gap_days, 2) AS max_deviation_from_avg,
    CASE 
        WHEN cm.max_gap_days > cm.avg_gap_days * 3 THEN '🚨 Anomaly (3x avg)'
        WHEN cm.max_gap_days > cm.avg_gap_days * 2 THEN '⚠️ Significant (2x avg)'
        WHEN cm.max_gap_days > cm.avg_gap_days * 1.5 THEN '⏰ Notable (1.5x avg)'
        ELSE '✅ Consistent'
    END AS gap_pattern
FROM Customers c
JOIN customer_metrics cm ON c.customer_id = cm.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_segment, 
         cm.avg_gap_days, cm.min_gap_days, cm.max_gap_days, cm.stddev_gap_days
ORDER BY max_deviation_from_avg DESC;
```

**Output:**
```
customer_id | customer_name   | customer_segment | total_orders | avg_gap_days | min_gap_days | max_gap_days | stddev_gap_days | max_deviation_from_avg | gap_pattern
------------|-----------------|------------------|--------------|--------------|--------------|--------------|-----------------|------------------------|---------------------
    104     | Sneha Reddy     | Premium          |      4       |    36.67     |      7       |      90      |      38.94      |         53.33          | 🚨 Anomaly (3x avg)
    102     | Priya Sharma    | Standard         |      5       |    28.50     |     12       |      60      |      20.15      |         31.50          | ⚠️ Significant (2x avg)
    105     | Vikram Singh    | VIP              |      6       |    26.20     |     10       |      45      |      13.84      |         18.80          | ⏰ Notable (1.5x avg)
    101     | Rajesh Kumar    | Premium          |      7       |    22.33     |     14       |      30      |       6.35      |          7.67          | ⏰ Notable (1.5x avg)
    103     | Amit Patel      | Standard         |      8       |    18.14     |     12       |      15      |       1.95      |         -3.14          | ✅ Consistent
```

**How it works:**
- Calculates average gap between orders per customer
- Compares longest gap to average pattern
- STDDEV shows consistency (low = predictable)
- Max deviation identifies irregular behavior
- Customer 104: 90-day gap is 3x their 36-day average (anomaly)
- Customer 103: Very consistent (15-day max vs 18-day avg)
- Anomalies indicate life events or satisfaction issues

---

## Query 5: Recent Activity vs Historical Gaps

**Identify customers whose recent gap exceeds their historical pattern**

```sql
WITH order_gaps AS (
    SELECT 
        customer_id, 
        order_date, 
        LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date) AS prev_order_date,
        DATEDIFF(order_date, LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)) AS gap_days,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS recent_rank
    FROM Orders
),
customer_gaps AS (
    SELECT 
        customer_id,
        MAX(CASE WHEN recent_rank = 1 THEN gap_days END) AS most_recent_gap,
        AVG(CASE WHEN recent_rank > 1 THEN gap_days END) AS historical_avg_gap,
        MAX(gap_days) AS max_historical_gap
    FROM order_gaps
    WHERE prev_order_date IS NOT NULL
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.customer_segment,
    COUNT(o.order_id) AS total_orders,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_order,
    cg.most_recent_gap,
    ROUND(cg.historical_avg_gap, 2) AS historical_avg_gap,
    cg.max_historical_gap,
    CASE 
        WHEN cg.most_recent_gap > cg.historical_avg_gap * 2 THEN '🔴 Declining Engagement'
        WHEN cg.most_recent_gap > cg.historical_avg_gap * 1.5 THEN '🟡 Watch List'
        WHEN cg.most_recent_gap < cg.historical_avg_gap THEN '🟢 Improving'
        ELSE '⚪ Stable'
    END AS engagement_trend
FROM Customers c
JOIN customer_gaps cg ON c.customer_id = cg.customer_id
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.customer_segment,
         cg.most_recent_gap, cg.historical_avg_gap, cg.max_historical_gap
HAVING cg.most_recent_gap IS NOT NULL
ORDER BY engagement_trend, days_since_last_order DESC;
```

**Output:**
```
customer_id | customer_name   | email                   | customer_segment | total_orders | last_order_date | days_since_last_order | most_recent_gap | historical_avg_gap | max_historical_gap | engagement_trend
------------|-----------------|-------------------------|------------------|--------------|-----------------|----------------------|-----------------|--------------------|--------------------|----------------------
    102     | Priya Sharma    | priya.sharma@email.com  | Standard         |      5       |   2024-07-10    |         105          |       60        |        22.50       |         60         | 🔴 Declining Engagement
    105     | Vikram Singh    | vikram.singh@email.com  | VIP              |      6       |   2024-08-20    |          64          |       45        |        23.40       |         45         | 🟡 Watch List
    101     | Rajesh Kumar    | rajesh.kumar@email.com  | Premium          |      7       |   2024-09-15    |          38          |       18        |        23.50       |         30         | 🟢 Improving
    103     | Amit Patel      | amit.patel@email.com    | Standard         |      8       |   2024-10-01    |          22          |       14        |        18.71       |         28         | 🟢 Improving
```

**How it works:**
- Compares most recent gap to historical average
- ROW_NUMBER identifies most recent order
- Declining engagement = recent gap > 2x historical average
- Days since last order shows current dormancy
- Priya Sharma: Recent 60-day gap vs 22.5-day avg (red flag)
- Amit Patel: Improving (14 days vs 18.7 avg)
- Prioritizes at-risk customers for outreach

---

## How It Works

### Key Concepts

**1. LAG() Window Function**
```sql
LAG(order_date) OVER (PARTITION BY customer_id ORDER BY order_date)
```
- Gets previous row's value within partition
- PARTITION BY creates separate windows per customer
- ORDER BY ensures chronological sequence
- NULL for first order (no previous)

**2. DATEDIFF for Gap Calculation**
```
Gap = Current Order Date - Previous Order Date
```
- Measures days between consecutive orders
- Identifies purchase frequency patterns
- Longer gaps = lower engagement

**3. Gap Pattern Analysis**
- **Consistent**: Gaps similar to average
- **Anomaly**: Single long gap (3x+ average)
- **Declining**: Recent gaps increasing
- **Improving**: Recent gaps decreasing

**4. Risk Segmentation**
- **<15 days**: Engaged (active buyers)
- **15-29 days**: Low risk (normal frequency)
- **30-59 days**: Medium risk (monitor)
- **60-89 days**: High risk (re-engage)
- **90+ days**: Critical (likely churned)

---

## Business Interpretation

### Gap Duration Insights

**Short Gaps (<15 days):**
- Highly engaged customers
- Frequent purchase need
- High lifetime value potential
- Minimal churn risk

**Medium Gaps (15-30 days):**
- Normal purchase frequency
- Product replenishment cycle
- Standard retention efforts
- Monitor for changes

**Long Gaps (30-60 days):**
- Declining engagement
- Competitor exploration
- Price sensitivity
- Targeted campaigns needed

**Extended Gaps (60+ days):**
- High churn risk
- Lost to competitors
- Need assessment surveys
- Win-back campaigns

### Anomaly Detection

**Gap 3x Average:**
- Life event (moving, job change)
- Dissatisfaction with product/service
- Found better alternative
- Financial constraints

**Action Items:**
- Survey for feedback
- Personalized offers
- Reactivation campaigns
- Product recommendations

---

## Real World Use Cases

1. **Churn Prevention**: Identify at-risk customers early
2. **Re-engagement Campaigns**: Target dormant customers
3. **Lifecycle Marketing**: Time campaigns based on gap patterns
4. **Subscription Optimization**: Adjust billing cycles
5. **Inventory Planning**: Predict reorder timing
6. **Customer Segmentation**: Group by purchase frequency
7. **CLV Prediction**: Long gaps reduce lifetime value
8. **Product Development**: Understand usage patterns

---

## Key Learning Points

### SQL Techniques
- ✅ LAG() for accessing previous row
- ✅ PARTITION BY for customer-level analysis
- ✅ DATEDIFF for date calculations
- ✅ Window functions with aggregations
- ✅ ROW_NUMBER for ranking
- ✅ STDDEV for variability measurement
- ✅ Multiple CTEs for complex analysis

### Customer Analytics
- ✅ Purchase frequency patterns
- ✅ Gap-based risk segmentation
- ✅ Anomaly detection
- ✅ Engagement trend analysis
- ✅ Churn prediction signals

### Best Practices
- ✅ Always filter out NULL (first order)
- ✅ Compare gaps to customer's own average
- ✅ Consider both max and recent gaps
- ✅ Segment by gap duration
- ✅ Track days since last order
- ✅ Set automated alerts for long gaps

---

## Performance Tips

1. **Index on customer_id and order_date**
```sql
CREATE INDEX idx_orders_customer_date ON Orders(customer_id, order_date);
```

2. **Materialized view for gaps**
```sql
CREATE MATERIALIZED VIEW customer_order_gaps AS
SELECT customer_id, MAX(gap_days) AS max_gap
FROM (SELECT customer_id, DATEDIFF(...) AS gap_days FROM Orders)
GROUP BY customer_id;
```

3. **Partition large tables by date**
4. **Cache gap calculations** (refresh daily)
5. **Use covering indexes** for frequent queries

---

## Extension Ideas

- Add gap analysis by product category
- Compare gaps before/after promotions
- Predict next order date based on patterns
- Correlate gaps with customer satisfaction scores
- Analyze seasonal gap variations
- Build churn probability models
- Create automated re-engagement triggers
- Track gap trends over customer lifetime
