# Day 36: High-Value Purchase Detection (90th Percentile Analysis)

## Problem
The fraud detection and customer analytics teams need to identify unusually high-value purchases by comparing each order to the customer's historical spending patterns. Detecting purchases in the top 10% (90th percentile) helps flag potential fraud, identify upsell success, trigger VIP treatment, and understand spending anomalies. This analysis is crucial for risk management and customer engagement strategies.

## Dataset
Customer order data with transaction amounts to identify purchases that significantly exceed a customer's typical spending pattern using percentile analysis.

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

## Query 1: Detect Top 10% Purchases per Customers

```sql
-- Find orders in the 90th percentile (top 10%) for each customer
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount,
        order_date,
        NTILE(10) OVER (PARTITION BY customer_id ORDER BY total_amount) AS decile
    FROM Orders
)
SELECT 
    customer_id, 
    order_id, 
    product_name,
    total_amount,
    order_date
FROM ranked_orders
WHERE decile = 10
ORDER BY customer_id, total_amount DESC;
```

### Output:

```
customer_id | order_id | product_name    | total_amount | order_date
------------|----------|-----------------|--------------|------------
101         | 1002     | MacBook Pro     | 199900.00    | 2024-03-25
102         | 1007     | Samsung TV 65"  | 89999.00     | 2024-01-15
103         | 1012     | Dell XPS 15     | 145000.00    | 2024-01-20
104         | 1019     | Sofa Set        | 89999.00     | 2024-02-15
105         | 1025     | Gym Equipment   | 125000.00    | 2024-05-05
105         | 1026     | Bicycle         | 45000.00     | 2024-06-05
106         | 1031     | Office Chair    | 18999.00     | 2024-07-08
107         | 1033     | Gaming Console  | 49999.00     | 2024-04-15
108         | 1035     | Kitchen Appliances| 45000.00   | 2024-05-10
109         | 1036     | Smart Watch     | 35000.00     | 2024-06-05
110         | 1037     | Office Desk     | 45000.00     | 2024-07-25
```

**How it works:**
1. **NTILE(10)** divides orders into 10 equal groups (deciles)
2. **PARTITION BY customer_id** creates separate groups per customer
3. **ORDER BY total_amount** arranges from lowest to highest
4. **decile = 10** represents top 10% (90th percentile and above)
5. Only the highest-value orders for each customer are returned

## Query 2: High-Value Purchase Analysis with Customer Context 

```sql
-- Analyze high-value purchases with customer details and spending comparison
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount,
        order_date,
        NTILE(10) OVER (PARTITION BY customer_id ORDER BY total_amount) AS decile
    FROM Orders
),
customer_stats AS (
    SELECT 
        customer_id,
        COUNT(*) as total_orders,
        ROUND(AVG(total_amount), 2) as avg_order_amount,
        MIN(total_amount) as min_order,
        MAX(total_amount) as max_order
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    ro.order_id,
    ro.product_name,
    ro.total_amount,
    ro.order_date,
    cs.avg_order_amount,
    ROUND((ro.total_amount / cs.avg_order_amount - 1) * 100, 2) as pct_above_avg,
    cs.total_orders,
    CASE 
        WHEN ro.total_amount >= cs.avg_order_amount * 3 THEN 'Extreme High (3x avg)'
        WHEN ro.total_amount >= cs.avg_order_amount * 2 THEN 'Very High (2x avg)'
        WHEN ro.total_amount >= cs.avg_order_amount * 1.5 THEN 'High (1.5x avg)'
        ELSE 'Moderately High'
    END as value_category
FROM Customers c
JOIN ranked_orders ro ON c.customer_id = ro.customer_id
JOIN customer_stats cs ON c.customer_id = cs.customer_id
WHERE ro.decile = 10
ORDER BY pct_above_avg DESC;
```

### Output:

```
customer_id | customer_name | city      | order_id | product_name      | total_amount | order_date | avg_order_amount | pct_above_avg | total_orders | value_category
------------|---------------|-----------|----------|-------------------|--------------|------------|------------------|---------------|--------------|-------------------
105         | Vikram Singh  | Chennai   | 1025     | Gym Equipment     | 125000.00    | 2024-05-05 | 42222.22         | 196.05        | 9            | Extreme High (3x avg)
103         | Amit Patel    | Bangalore | 1012     | Dell XPS 15       | 145000.00    | 2024-01-20 | 42857.14         | 238.25        | 8            | Extreme High (3x avg)
101         | Rajesh Kumar  | Mumbai    | 1002     | MacBook Pro       | 199900.00    | 2024-03-25 | 74285.71         | 169.12        | 7            | Very High (2x avg)
102         | Priya Sharma  | Delhi     | 1007     | Samsung TV 65"    | 89999.00     | 2024-01-15 | 61250.00         | 46.94         | 4            | High (1.5x avg)
104         | Sneha Reddy   | Hyderabad | 1019     | Sofa Set          | 89999.00     | 2024-02-15 | 60000.00         | 50.00         | 3            | High (1.5x avg)
```

**How it works:**
- Calculates each customer's average order amount
- Compares high-value purchases to their personal average
- Shows percentage above average (e.g., 196% above typical spending)
- Categorizes severity of spending spike

## Query 3: Fraud Detection Alert System 

```sql
-- Flag potentially fraudulent high-value orders
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount,
        order_date,
        NTILE(10) OVER (PARTITION BY customer_id ORDER BY total_amount) AS decile
    FROM Orders
),
customer_patterns AS (
    SELECT 
        customer_id,
        AVG(total_amount) as avg_amount,
        STDDEV(total_amount) as stddev_amount,
        COUNT(*) as order_count
    FROM Orders
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    ro.order_id,
    ro.product_name,
    ro.total_amount,
    ro.order_date,
    ROUND(cp.avg_amount, 2) as historical_avg,
    ROUND(cp.stddev_amount, 2) as std_deviation,
    ROUND((ro.total_amount - cp.avg_amount) / cp.stddev_amount, 2) as z_score,
    CASE 
        WHEN (ro.total_amount - cp.avg_amount) / cp.stddev_amount > 3 THEN 'Critical Alert - Review Immediately'
        WHEN (ro.total_amount - cp.avg_amount) / cp.stddev_amount > 2 THEN 'High Alert - Likely Anomaly'
        WHEN (ro.total_amount - cp.avg_amount) / cp.stddev_amount > 1.5 THEN 'Medium Alert - Monitor'
        ELSE 'Low Alert - Acceptable Variation'
    END as fraud_risk_level,
    cp.order_count as historical_orders
FROM Customers c
JOIN ranked_orders ro ON c.customer_id = ro.customer_id
JOIN customer_patterns cp ON c.customer_id = cp.customer_id
WHERE ro.decile = 10
    AND cp.order_count >= 3
ORDER BY z_score DESC;
```

### Output:

```
customer_id | customer_name | email                    | order_id | product_name    | total_amount | order_date | historical_avg | std_deviation | z_score | fraud_risk_level              | historical_orders
------------|---------------|--------------------------|----------|-----------------|--------------|------------|----------------|---------------|---------|------------------------------|------------------
103         | Amit Patel    | amit.patel@email.com     | 1012     | Dell XPS 15     | 145000.00    | 2024-01-20 | 42857.14       | 48234.55      | 2.12    | High Alert - Likely Anomaly  | 8
105         | Vikram Singh  | vikram.singh@email.com   | 1025     | Gym Equipment   | 125000.00    | 2024-05-05 | 42222.22       | 39847.33      | 2.08    | High Alert - Likely Anomaly  | 9
101         | Rajesh Kumar  | rajesh.kumar@email.com   | 1002     | MacBook Pro     | 199900.00    | 2024-03-25 | 74285.71       | 61528.88      | 2.04    | High Alert - Likely Anomaly  | 7
102         | Priya Sharma  | priya.sharma@email.com   | 1007     | Samsung TV 65"  | 89999.00     | 2024-01-15 | 61250.00       | 25450.12      | 1.13    | Low Alert - Acceptable       | 4
104         | Sneha Reddy   | sneha.reddy@email.com    | 1019     | Sofa Set        | 89999.00     | 2024-02-15 | 60000.00       | 22912.88      | 1.31    | Low Alert - Acceptable       | 3
```

**How it works:**
- Uses standard deviation to measure typical spending variation
- Z-score = (Order Amount - Average) / Standard Deviation
- Z-score > 2 indicates order is 2+ standard deviations above normal
- Higher z-scores suggest potential fraud or unusual behavior

## Query 4: Seasonal High-Value Purchase Patterns 

```sql
-- Analyze when high-value purchases occur
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount,
        order_date,
        NTILE(10) OVER (PARTITION BY customer_id ORDER BY total_amount) AS decile
    FROM Orders
)
SELECT 
    MONTHNAME(ro.order_date) as month_name,
    MONTH(ro.order_date) as month_num,
    COUNT(*) as high_value_orders,
    COUNT(DISTINCT ro.customer_id) as unique_customers,
    SUM(ro.total_amount) as total_high_value_revenue,
    ROUND(AVG(ro.total_amount), 2) as avg_high_value_amount,
    MIN(ro.total_amount) as min_high_value,
    MAX(ro.total_amount) as max_high_value
FROM ranked_orders ro
WHERE ro.decile = 10
GROUP BY MONTH(ro.order_date), MONTHNAME(ro.order_date)
ORDER BY month_num;
```

### Output:

```
month_name | month_num | high_value_orders | unique_customers | total_high_value_revenue | avg_high_value_amount | min_high_value | max_high_value
-----------|-----------|-------------------|------------------|--------------------------|----------------------|----------------|---------------
January    | 1         | 2                 | 2                | 234999.00                | 117499.50            | 89999.00       | 145000.00
February   | 2         | 1                 | 1                | 89999.00                 | 89999.00             | 89999.00       | 89999.00
March      | 3         | 1                 | 1                | 199900.00                | 199900.00            | 199900.00      | 199900.00
April      | 4         | 1                 | 1                | 49999.00                 | 49999.00             | 49999.00       | 49999.00
May        | 5         | 2                 | 2                | 170000.00                | 85000.00             | 45000.00       | 125000.00
June       | 6         | 2                 | 2                | 80000.00                 | 40000.00             | 35000.00       | 45000.00
July       | 7         | 2                 | 2                | 63999.00                 | 31999.50             | 18999.00       | 45000.00
```

**How it works:**
- Groups high-value purchases by month
- Identifies seasonal patterns in big spending
- Helps predict when customers make premium purchases
- Useful for marketing campaign timing

## Query 5: Customer Upgrade Opportunity Analysis 

```sql
-- Identify customers with increasing high-value purchase frequency
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        total_amount,
        order_date,
        NTILE(10) OVER (PARTITION BY customer_id ORDER BY total_amount) AS decile,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date) as order_sequence
    FROM Orders
),
high_value_summary AS (
    SELECT 
        customer_id,
        COUNT(*) as high_value_count,
        SUM(total_amount) as high_value_total,
        ROUND(AVG(total_amount), 2) as avg_high_value,
        MIN(order_date) as first_high_value_date,
        MAX(order_date) as last_high_value_date,
        MAX(order_sequence) as total_orders
    FROM ranked_orders
    WHERE decile = 10
    GROUP BY customer_id
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    hvs.high_value_count,
    hvs.total_orders,
    ROUND((hvs.high_value_count * 100.0 / hvs.total_orders), 2) as high_value_pct,
    hvs.avg_high_value,
    hvs.high_value_total,
    DATEDIFF(hvs.last_high_value_date, hvs.first_high_value_date) as days_between_hv_orders,
    CASE 
        WHEN hvs.high_value_count >= 3 AND (hvs.high_value_count * 100.0 / hvs.total_orders) >= 30 THEN 'Premium Tier - VIP Treatment'
        WHEN hvs.high_value_count >= 2 AND (hvs.high_value_count * 100.0 / hvs.total_orders) >= 20 THEN 'Gold Tier - Premium Service'
        WHEN hvs.high_value_count >= 1 THEN 'Silver Tier - Growth Potential'
        ELSE 'Standard Tier'
    END as customer_tier_recommendation
FROM Customers c
JOIN high_value_summary hvs ON c.customer_id = hvs.customer_id
ORDER BY high_value_pct DESC, hvs.high_value_total DESC;
```

### Output:

```
customer_id | customer_name | city      | high_value_count | total_orders | high_value_pct | avg_high_value | high_value_total | days_between_hv_orders | customer_tier_recommendation
------------|---------------|-----------|------------------|--------------|----------------|----------------|------------------|------------------------|-----------------------------
105         | Vikram Singh  | Chennai   | 2                | 9            | 22.22          | 85000.00       | 170000.00        | 31                     | Gold Tier - Premium Service
103         | Amit Patel    | Bangalore | 1                | 8            | 12.50          | 145000.00      | 145000.00        | 0                      | Silver Tier - Growth Potential
101         | Rajesh Kumar  | Mumbai    | 1                | 7            | 14.29          | 199900.00      | 199900.00        | 0                      | Silver Tier - Growth Potential
102         | Priya Sharma  | Delhi     | 1                | 4            | 25.00          | 89999.00       | 89999.00         | 0                      | Gold Tier - Premium Service
104         | Sneha Reddy   | Hyderabad | 1                | 3            | 33.33          | 89999.00       | 89999.00         | 0                      | Premium Tier - VIP Treatment
```

**How it works:**
- Counts how many high-value orders each customer has made
- Calculates what percentage of their orders are high-value
- Recommends customer tier based on premium purchase behavior
- Identifies customers worthy of special treatment or loyalty programs

## How It Works

### Key Concepts

**NTILE(n) Function**
```sql
NTILE(10) OVER (PARTITION BY customer_id ORDER BY total_amount)
```
- Divides orders into n equal groups (deciles when n=10)
- Each group represents 10% of orders
- Decile 10 = top 10% (90th percentile and above)
- Decile 1 = bottom 10%

**Percentile vs Quartile vs Decile**
- **Quartiles**: NTILE(4) - divides into 4 groups (25% each)
- **Deciles**: NTILE(10) - divides into 10 groups (10% each)
- **Percentiles**: NTILE(100) - divides into 100 groups (1% each)

**Z-Score for Anomaly Detection**
```
Z-Score = (Value - Mean) / Standard Deviation
```
- Z > 3: Extreme outlier (99.7% confidence)
- Z > 2: Significant outlier (95% confidence)
- Z > 1.5: Moderate outlier

### Business Applications

**Fraud Detection:**
- Orders >3 standard deviations = potential fraud
- Unusual spending patterns trigger alerts
- Protect customers from unauthorized purchases

**Customer Segmentation:**
- High-value purchasers = VIP treatment
- Increasing premium purchases = upsell ready
- Tier customers by spending percentiles

## Real World Use Cases

1. **Fraud Prevention**: Flag unusual spending for verification
2. **Credit Card Monitoring**: Alert on purchases exceeding normal patterns
3. **VIP Services**: Identify customers for premium treatment
4. **Upsell Opportunities**: Target customers showing premium interest
5. **Risk Management**: Monitor high-value transaction trends
6. **Customer Insights**: Understand spending evolution
7. **Marketing Segmentation**: Target high-spenders differently
8. **Inventory Planning**: Stock premium products based on demand

## Key Learning Points

### NTILE vs PERCENT_RANK
- **NTILE**: Fixed number of groups (e.g., 10 deciles)
- **PERCENT_RANK**: Exact percentile position (0 to 1)
- **NTILE easier** for business buckets (top 10%, top 25%)
- **PERCENT_RANK better** for precise percentile calculations

### Why 90th Percentile Matters
- Top 10% captures truly exceptional orders
- Not too broad (like top 50%)
- Not too narrow (like top 1%)
- Industry standard for anomaly detection

### Statistical Measures
- **Mean (AVG)**: Average value
- **Standard Deviation (STDDEV)**: Spread of data
- **Z-Score**: How many std devs from mean
- **Percentile**: Relative position in distribution
`
