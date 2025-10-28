# Day 50: Low Revenue Customers - Percentile Analysis (Final Challenge!)

## Problem
The revenue operations and customer success teams need to identify customers generating revenue below the 10th percentile to understand low-value customer characteristics, assess acquisition channel effectiveness, optimize resource allocation, and make data-driven decisions about customer retention vs. acquisition strategies.

## Dataset
Customer purchase data aggregated by total revenue to calculate percentile thresholds, identify low-performing customers, analyze characteristics of bottom-tier spenders, and develop targeted strategies for different customer value segments.

## SQL Solution

### Table Structure

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE,
    signup_source VARCHAR(50),
    customer_segment VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE NOT NULL,
    order_status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);
```

---

## Query 1: Customers Below 10th Percentile Revenue

**Identify customers with revenue below the 10th percentile threshold**

```sql
WITH cte AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS total_revenue 
    FROM Orders 
    GROUP BY customer_id
)
SELECT 
    customer_id, 
    total_revenue,
    (SELECT PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY total_revenue) FROM cte) AS percentile_10_threshold
FROM cte 
WHERE total_revenue < (SELECT PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY total_revenue) FROM cte)
ORDER BY total_revenue;
```

**Output:**
```
customer_id | total_revenue | percentile_10_threshold
------------|---------------|------------------------
    108     |    2500.00    |        8500.00
    110     |    3200.00    |        8500.00
    115     |    4800.00    |        8500.00
    112     |    6500.00    |        8500.00
    118     |    7200.00    |        8500.00
```

**How it works:**
- CTE aggregates total revenue per customer
- PERCENTILE_CONT calculates 10th percentile threshold
- WITHIN GROUP (ORDER BY) specifies ranking order
- WHERE filters customers below the threshold
- Bottom 10% of customers identified for analysis
- These customers may need upselling or may not be worth retaining

---

## Query 2: Revenue Percentile Distribution Analysis

**Show customer distribution across all revenue percentiles**

```sql
WITH customer_revenue AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS total_revenue 
    FROM Orders 
    GROUP BY customer_id
),
percentile_thresholds AS (
    SELECT 
        PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY total_revenue) AS p10,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_revenue) AS p25,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_revenue) AS p50,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_revenue) AS p75,
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY total_revenue) AS p90
    FROM customer_revenue
)
SELECT 
    cr.customer_id,
    c.customer_name,
    c.signup_source,
    cr.total_revenue,
    CASE 
        WHEN cr.total_revenue < pt.p10 THEN '🔴 Bottom 10%'
        WHEN cr.total_revenue < pt.p25 THEN '🟠 10-25%'
        WHEN cr.total_revenue < pt.p50 THEN '🟡 25-50%'
        WHEN cr.total_revenue < pt.p75 THEN '🟢 50-75%'
        WHEN cr.total_revenue < pt.p90 THEN '🔵 75-90%'
        ELSE '⭐ Top 10%'
    END AS revenue_percentile_group,
    COUNT(o.order_id) AS total_orders,
    ROUND(cr.total_revenue / COUNT(o.order_id), 2) AS avg_order_value
FROM customer_revenue cr
JOIN Customers c ON cr.customer_id = c.customer_id
JOIN Orders o ON cr.customer_id = o.customer_id
CROSS JOIN percentile_thresholds pt
GROUP BY cr.customer_id, c.customer_name, c.signup_source, cr.total_revenue, pt.p10, pt.p25, pt.p50, pt.p75, pt.p90
ORDER BY cr.total_revenue;
```

**Output:**
```
customer_id | customer_name    | signup_source  | total_revenue | revenue_percentile_group | total_orders | avg_order_value
------------|------------------|----------------|---------------|--------------------------|--------------|----------------
    108     | Deepak Gupta     | Paid Ads       |    2500.00    | 🔴 Bottom 10%            |      1       |    2500.00
    110     | Suresh Yadav     | Social Media   |    3200.00    | 🔴 Bottom 10%            |      1       |    3200.00
    115     | Divya Shah       | Referral       |    4800.00    | 🔴 Bottom 10%            |      2       |    2400.00
    112     | Arjun Malhotra   | Organic Search |    6500.00    | 🔴 Bottom 10%            |      2       |    3250.00
    118     | Ravi Kapoor      | Paid Ads       |    7200.00    | 🔴 Bottom 10%            |      2       |    3600.00
    114     | Karan Mehta      | Referral       |   12000.00    | 🟠 10-25%                |      3       |    4000.00
    ...
```

**How it works:**
- Calculates multiple percentile thresholds (10th, 25th, 50th, 75th, 90th)
- CASE statement assigns customers to percentile groups
- Shows total orders and average order value
- Bottom 10% customers have low revenue AND low order counts
- Helps segment customers by value for targeted strategies

---

## Query 3: Low Revenue Customer Characteristics

**Analyze common traits of bottom 10% customers**

```sql
WITH customer_revenue AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS total_revenue 
    FROM Orders 
    GROUP BY customer_id
),
percentile_10 AS (
    SELECT PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY total_revenue) AS threshold
    FROM customer_revenue
),
low_revenue_customers AS (
    SELECT cr.customer_id
    FROM customer_revenue cr
    WHERE cr.total_revenue < (SELECT threshold FROM percentile_10)
)
SELECT 
    c.signup_source,
    COUNT(DISTINCT lrc.customer_id) AS low_revenue_count,
    COUNT(DISTINCT c.customer_id) AS total_customers_from_source,
    ROUND(COUNT(DISTINCT lrc.customer_id) * 100.0 / COUNT(DISTINCT c.customer_id), 2) AS pct_low_revenue,
    ROUND(AVG(CASE WHEN lrc.customer_id IS NOT NULL THEN cr.total_revenue END), 2) AS avg_revenue_low_customers,
    ROUND(AVG(cr.total_revenue), 2) AS avg_revenue_all_customers
FROM Customers c
LEFT JOIN low_revenue_customers lrc ON c.customer_id = lrc.customer_id
LEFT JOIN customer_revenue cr ON c.customer_id = cr.customer_id
GROUP BY c.signup_source
ORDER BY pct_low_revenue DESC;
```

**Output:**
```
signup_source    | low_revenue_count | total_customers_from_source | pct_low_revenue | avg_revenue_low_customers | avg_revenue_all_customers
-----------------|-------------------|-----------------------------|-----------------|--------------------------|--------------------------
Paid Ads         |        2          |              4              |      50.00      |         4850.00          |        28450.00
Social Media     |        1          |              3              |      33.33      |         3200.00          |        35733.33
Referral         |        1          |              5              |      20.00      |         4800.00          |        58960.00
Organic Search   |        1          |              6              |      16.67      |         6500.00          |        67833.33
```

**How it works:**
- Identifies which signup sources produce most low-revenue customers
- Compares percentage of low-revenue customers by channel
- Shows average revenue for low vs all customers from each source
- Paid Ads has 50% of customers in bottom 10% (poor targeting)
- Organic Search has only 16.67% in bottom 10% (better quality)
- Helps optimize marketing spend and channel strategy

---

## Query 4: Time-Based Analysis of Low Revenue Customers

**When did low-revenue customers sign up vs high-revenue customers?**

```sql
WITH customer_revenue AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS total_revenue 
    FROM Orders 
    GROUP BY customer_id
),
percentile_thresholds AS (
    SELECT 
        PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY total_revenue) AS p10,
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY total_revenue) AS p90
    FROM customer_revenue
)
SELECT 
    DATE_FORMAT(c.signup_date, '%Y-%m') AS signup_month,
    COUNT(DISTINCT CASE WHEN cr.total_revenue < pt.p10 THEN c.customer_id END) AS low_revenue_customers,
    COUNT(DISTINCT CASE WHEN cr.total_revenue >= pt.p90 THEN c.customer_id END) AS high_revenue_customers,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    ROUND(COUNT(DISTINCT CASE WHEN cr.total_revenue < pt.p10 THEN c.customer_id END) * 100.0 / 
          COUNT(DISTINCT c.customer_id), 2) AS pct_low_revenue,
    ROUND(AVG(CASE WHEN cr.total_revenue < pt.p10 THEN cr.total_revenue END), 2) AS avg_low_revenue,
    ROUND(AVG(CASE WHEN cr.total_revenue >= pt.p90 THEN cr.total_revenue END), 2) AS avg_high_revenue
FROM Customers c
JOIN customer_revenue cr ON c.customer_id = cr.customer_id
CROSS JOIN percentile_thresholds pt
GROUP BY DATE_FORMAT(c.signup_date, '%Y-%m')
ORDER BY signup_month;
```

**Output:**
```
signup_month | low_revenue_customers | high_revenue_customers | total_customers | pct_low_revenue | avg_low_revenue | avg_high_revenue
-------------|------------------------|------------------------|-----------------|-----------------|-----------------|------------------
  2024-01    |          3            |           4            |       8         |      37.50      |     4833.33     |     125000.00
  2024-02    |          1            |           2            |       5         |      20.00      |     3200.00     |     98500.00
  2024-03    |          1            |           2            |       5         |      20.00      |     7200.00     |     112000.00
```

**How it works:**
- Groups customers by signup month
- Compares low-revenue (bottom 10%) vs high-revenue (top 10%) customers
- January had 37.5% low-revenue customers (quality issue?)
- Later months show improvement in customer quality
- Identifies if recent acquisition efforts are bringing better customers
- Helps evaluate marketing campaign effectiveness over time

---

## Query 5: Actionable Insights - Low Revenue Customer Segments

**Prioritize low-revenue customers by engagement and potential**

```sql
WITH customer_revenue AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS total_revenue,
        COUNT(order_id) AS total_orders,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date
    FROM Orders 
    GROUP BY customer_id
),
percentile_10 AS (
    SELECT PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY total_revenue) AS threshold
    FROM customer_revenue
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.signup_source,
    c.customer_segment,
    cr.total_revenue,
    cr.total_orders,
    ROUND(cr.total_revenue / cr.total_orders, 2) AS avg_order_value,
    cr.first_order_date,
    cr.last_order_date,
    DATEDIFF(cr.last_order_date, cr.first_order_date) AS customer_lifetime_days,
    DATEDIFF(CURDATE(), cr.last_order_date) AS days_since_last_order,
    CASE 
        WHEN cr.total_orders = 1 THEN '🔴 One-Time Buyer'
        WHEN DATEDIFF(CURDATE(), cr.last_order_date) > 90 THEN '⚠️ Dormant'
        WHEN cr.total_orders >= 3 THEN '🟡 Engaged Low-Spender'
        ELSE '🟠 Occasional Buyer'
    END AS customer_type,
    CASE 
        WHEN cr.total_orders = 1 AND cr.total_revenue < 5000 THEN 'Low Priority - Let Churn'
        WHEN cr.total_orders = 1 AND cr.total_revenue >= 5000 THEN 'Medium Priority - Reactivation Campaign'
        WHEN cr.total_orders >= 3 THEN 'High Priority - Upsell Opportunity'
        WHEN DATEDIFF(CURDATE(), cr.last_order_date) > 90 THEN 'Low Priority - Likely Churned'
        ELSE 'Medium Priority - Nurture Campaign'
    END AS action_recommendation
FROM Customers c
JOIN customer_revenue cr ON c.customer_id = cr.customer_id
CROSS JOIN percentile_10 p10
WHERE cr.total_revenue < p10.threshold
ORDER BY 
    CASE 
        WHEN cr.total_orders >= 3 THEN 1
        WHEN cr.total_orders = 1 AND cr.total_revenue >= 5000 THEN 2
        ELSE 3
    END,
    cr.total_revenue DESC;
```

**Output:**
```
customer_id | customer_name    | email                   | signup_source  | customer_segment | total_revenue | total_orders | avg_order_value | first_order_date | last_order_date | customer_lifetime_days | days_since_last_order | customer_type             | action_recommendation
------------|------------------|-------------------------|----------------|------------------|---------------|--------------|-----------------|------------------|-----------------|------------------------|----------------------|---------------------------|----------------------------------
    115     | Divya Shah       | divya.shah@email.com    | Referral       | Standard         |    4800.00    |      2       |     2400.00     |   2024-02-20     |   2024-03-15    |        24              |        230               | 🟠 Occasional Buyer       | Medium Priority - Nurture Campaign
    112     | Arjun Malhotra   | arjun.malhotra@email.com| Organic Search | Standard         |    6500.00    |      2       |     3250.00     |   2024-02-05     |   2024-03-10    |        34              |        235               | 🟠 Occasional Buyer       | Medium Priority - Nurture Campaign
    108     | Deepak Gupta     | deepak.gupta@email.com  | Paid Ads       | Standard         |    2500.00    |      1       |     2500.00     |   2024-01-18     |   2024-01-18    |         0              |        287               | 🔴 One-Time Buyer         | Low Priority - Let Churn
    110     | Suresh Yadav     | suresh.yadav@email.com  | Social Media   | Standard         |    3200.00    |      1       |     3200.00     |   2024-01-25     |   2024-01-25    |         0              |        280               | 🔴 One-Time Buyer         | Low Priority - Let Churn
```

**How it works:**
- Identifies ALL bottom 10% customers with detailed metrics
- Classifies by customer type (One-Time, Dormant, Engaged, Occasional)
- Provides actionable recommendations based on behavior
- Prioritizes customers with multiple orders (upsell potential)
- One-time low-value buyers = let churn (not worth retention cost)
- Engaged low-spenders = upsell opportunity (already loyal)
- Days since last order identifies dormant customers
- Helps allocate resources to highest ROI retention efforts

---

## How It Works

### Key Concepts

**1. PERCENTILE_CONT Function**
```sql
PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY revenue)
```
- Calculates continuous percentile (interpolates between values)
- 0.1 = 10th percentile (bottom 10%)
- 0.9 = 90th percentile (top 10%)
- WITHIN GROUP specifies ordering
- Returns single threshold value

**2. Percentile vs Percentage**
- **Percentile**: Position in ranked distribution
- **Percentage**: Portion of total
- 10th percentile = value below which 10% of data falls
- Bottom 10% = lowest 10% by count

**3. Revenue Segmentation**
```
Bottom 10% (<P10) → Low-value customers
10-25% (P10-P25) → Below average
25-50% (P25-P50) → Below median
50-75% (P50-P75) → Above median
75-90% (P75-P90) → Above average
Top 10% (>P90) → High-value customers
```

**4. Action Prioritization**
- Engaged low-spenders → Upsell (high priority)
- One-time high-value → Reactivate (medium)
- One-time low-value → Let churn (low priority)
- Dormant → Depends on historical value

---

## Business Interpretation

### Why Identify Low-Revenue Customers?

**Resource Allocation:**
- Not all customers are worth retaining
- CAC (Customer Acquisition Cost) may exceed LTV
- Focus efforts on customers with growth potential

**Channel Optimization:**
- Identify sources bringing low-quality customers
- Reduce spend on channels with high % low-revenue
- Optimize targeting and messaging

**Product Strategy:**
- Low revenue may indicate poor product-market fit
- Need lower-priced entry products
- Or these customers aren't target market

### Low Revenue Customer Actions

**One-Time Buyers (<$5K):**
- Action: Let churn
- Reason: Retention cost > potential value
- Exception: If referred by high-value customer

**One-Time Buyers ($5K-$10K):**
- Action: Automated email sequence
- Reason: Some upside, minimal cost
- Offer: Discount for second purchase

**Repeat Low-Spenders (3+ orders):**
- Action: Upsell campaign
- Reason: Already engaged, just need higher-value products
- Offer: Premium product recommendations

**Dormant (90+ days):**
- Action: Win-back if >2 orders, else let churn
- Reason: May have found competitor
- Offer: "We miss you" discount

---

## Real World Use Cases

1. **Marketing Budget Optimization**: Cut spend on channels bringing bottom 10%
2. **Customer Success Prioritization**: Focus on customers with growth potential
3. **Churn Prediction**: Bottom 10% likely to churn first
4. **Pricing Strategy**: May need lower-priced products
5. **Sales Territory Assignment**: Don't waste top reps on low-value customers
6. **Product Development**: Understand why some customers don't spend more
7. **Acquisition Strategy**: Profile top 10% and target similar prospects
8. **Retention ROI**: Calculate if retaining bottom 10% is profitable

---

## Key Learning Points

### SQL Techniques
- ✅ PERCENTILE_CONT for threshold calculation
- ✅ WITHIN GROUP for ordering
- ✅ CROSS JOIN for threshold comparison
- ✅ CASE statements for segmentation
- ✅ Multiple CTEs for complex analysis
- ✅ LEFT JOIN for inclusion analysis
- ✅ Aggregate functions with filtering

### Customer Analytics
- ✅ Percentile-based segmentation
- ✅ Customer lifetime value (CLV) proxies
- ✅ Channel quality assessment
- ✅ Cohort analysis by signup period
- ✅ Behavioral segmentation
- ✅ Action prioritization frameworks

### Best Practices
- ✅ Don't treat all customers equally
- ✅ Calculate retention ROI before acting
- ✅ Segment by both value AND engagement
- ✅ Consider customer potential, not just current revenue
- ✅ Automate low-value customer handling
- ✅ Focus human resources on high-value segments
- ✅ Regularly review and update percentile thresholds

---

## Performance Tips

1. **Index on customer_id and total_amount**
```sql
CREATE INDEX idx_orders_customer_amount ON Orders(customer_id, total_amount);
```

2. **Materialized view for customer revenue**
```sql
CREATE MATERIALIZED VIEW customer_revenue_summary AS
SELECT customer_id, SUM(total_amount) AS total_revenue, COUNT(*) AS order_count
FROM Orders
GROUP BY customer_id;
```

3. **Cache percentile thresholds** (recalculate weekly)
4. **Partition Orders table by date** for faster aggregation
5. **Use covering indexes** for common queries

---
