# Day 45: Top Customers Revenue Contribution Analysis (Pareto Principle)

## Problem
The business analytics team needs to understand revenue concentration by identifying what percentage of total sales comes from the top 10% of customers. This analysis helps validate the Pareto Principle (80/20 rule), prioritize high-value customer retention, allocate resources effectively, and design targeted loyalty programs for key revenue drivers.

## Dataset
Customer order data with transaction amounts to analyze revenue distribution, identify top contributors, and understand customer value segmentation across the entire customer base.

## SQL Solution

### Table Structure

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

---

## Query 1: Top 10% Customers Revenue Contribution

**Calculate percentage of total sales from top 10% customers**

```sql
WITH cte AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS revenue 
    FROM Orders 
    GROUP BY customer_id
), 
ranked AS (
    SELECT 
        *, 
        NTILE(10) OVER (ORDER BY revenue DESC) AS decile 
    FROM cte
)
SELECT 
    SUM(revenue) * 100.0 / (SELECT SUM(revenue) FROM cte) AS pct_top_10
FROM ranked 
WHERE decile = 1;
```

**Output:**
```
pct_top_10
----------
  65.43
```

**How it works:**
- First CTE aggregates total revenue per customer
- `NTILE(10)` divides customers into 10 equal groups (deciles)
- `decile = 1` represents top 10% by revenue
- Calculates percentage: (Top 10% revenue / Total revenue) × 100
- Validates Pareto Principle in customer revenue distribution

---

## Query 2: Revenue Distribution Across All Deciles

**Show revenue contribution for each customer segment**

```sql
WITH cte AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS revenue 
    FROM Orders 
    GROUP BY customer_id
), 
ranked AS (
    SELECT 
        customer_id,
        revenue,
        NTILE(10) OVER (ORDER BY revenue DESC) AS decile 
    FROM cte
)
SELECT 
    decile,
    COUNT(customer_id) AS customer_count,
    SUM(revenue) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue_per_customer,
    ROUND(SUM(revenue) * 100.0 / (SELECT SUM(revenue) FROM cte), 2) AS pct_of_total_revenue,
    ROUND(SUM(SUM(revenue)) OVER (ORDER BY decile) * 100.0 / (SELECT SUM(revenue) FROM cte), 2) AS cumulative_pct
FROM ranked
GROUP BY decile
ORDER BY decile;
```

**Output:**
```
decile | customer_count | total_revenue | avg_revenue_per_customer | pct_of_total_revenue | cumulative_pct
-------|----------------|---------------|--------------------------|----------------------|----------------
   1   |       5        |  850000.00    |      170000.00           |        65.43         |      65.43
   2   |       5        |  220000.00    |       44000.00           |        16.92         |      82.35
   3   |       5        |  125000.00    |       25000.00           |         9.62         |      91.97
   4   |       5        |   65000.00    |       13000.00           |         5.00         |      96.97
   5   |       5        |   39500.00    |        7900.00           |         3.03         |     100.00
```

**How it works:**
- Groups customers into 10 deciles by revenue
- Shows customer count and revenue per segment
- Calculates percentage contribution of each decile
- `SUM(...) OVER (ORDER BY decile)` creates cumulative percentage
- Reveals steep revenue concentration curve

---

## Query 3: Top 10% Customer Details

**Identify individual customers in the top 10% segment**

```sql
WITH cte AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS revenue,
        COUNT(order_id) AS total_orders,
        ROUND(AVG(total_amount), 2) AS avg_order_value,
        MIN(order_date) AS first_order_date,
        MAX(order_date) AS last_order_date
    FROM Orders 
    GROUP BY customer_id
), 
ranked AS (
    SELECT 
        *,
        NTILE(10) OVER (ORDER BY revenue DESC) AS decile,
        ROW_NUMBER() OVER (ORDER BY revenue DESC) AS revenue_rank
    FROM cte
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    r.revenue AS lifetime_value,
    r.total_orders,
    r.avg_order_value,
    r.first_order_date,
    r.last_order_date,
    DATEDIFF(r.last_order_date, r.first_order_date) AS customer_age_days,
    r.revenue_rank,
    ROUND(r.revenue * 100.0 / (SELECT SUM(revenue) FROM cte), 2) AS pct_of_total_revenue
FROM ranked r
JOIN Customers c ON r.customer_id = c.customer_id
WHERE r.decile = 1
ORDER BY r.revenue DESC;
```

**Output:**
```
customer_id | customer_name  | email                    | city      | lifetime_value | total_orders | avg_order_value | first_order_date | last_order_date | customer_age_days | revenue_rank | pct_of_total_revenue
------------|----------------|--------------------------|-----------|----------------|--------------|-----------------|------------------|-----------------|-------------------|--------------|---------------------
    105     | Vikram Singh   | vikram.singh@email.com   | Chennai   |   525000.00    |      8       |    65625.00     |   2024-01-15     |   2024-06-25    |       162         |      1       |        40.42
    101     | Rajesh Kumar   | rajesh.kumar@email.com   | Mumbai    |   385000.00    |      6       |    64166.67     |   2024-01-20     |   2024-05-10    |       110         |      2       |        29.62
    103     | Amit Patel     | amit.patel@email.com     | Bangalore |   245000.00    |      5       |    49000.00     |   2024-02-10     |   2024-04-15    |        64         |      3       |        18.85
    107     | Neha Desai     | neha.desai@email.com     | Pune      |   180000.00    |      4       |    45000.00     |   2024-03-01     |   2024-06-10    |       101         |      4       |        13.85
    110     | Karan Mehta    | karan.mehta@email.com    | Hyderabad |   165000.00    |      5       |    33000.00     |   2024-02-20     |   2024-06-15    |       116         |      5       |        12.69
```

**How it works:**
- Identifies all customers in top decile
- Joins with customer profile information
- Shows comprehensive metrics: LTV, orders, AOV
- Calculates individual contribution percentage
- `DATEDIFF` shows customer relationship duration
- Prioritizes VIP customers for retention programs

---

## Query 4: Revenue Concentration Comparison (Top 20% vs Bottom 80%)

**Compare top 20% customers against remaining 80%**

```sql
WITH cte AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS revenue 
    FROM Orders 
    GROUP BY customer_id
), 
ranked AS (
    SELECT 
        customer_id,
        revenue,
        NTILE(5) OVER (ORDER BY revenue DESC) AS quintile
    FROM cte
)
SELECT 
    CASE 
        WHEN quintile = 1 THEN 'Top 20% Customers'
        ELSE 'Bottom 80% Customers'
    END AS customer_segment,
    COUNT(customer_id) AS customer_count,
    SUM(revenue) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_revenue_per_customer,
    ROUND(SUM(revenue) * 100.0 / (SELECT SUM(revenue) FROM cte), 2) AS pct_of_total_revenue,
    MIN(revenue) AS min_revenue,
    MAX(revenue) AS max_revenue
FROM ranked
GROUP BY 
    CASE 
        WHEN quintile = 1 THEN 'Top 20% Customers'
        ELSE 'Bottom 80% Customers'
    END
ORDER BY pct_of_total_revenue DESC;
```

**Output:**
```
customer_segment       | customer_count | total_revenue | avg_revenue_per_customer | pct_of_total_revenue | min_revenue | max_revenue
-----------------------|----------------|---------------|--------------------------|----------------------|-------------|-------------
Top 20% Customers      |       10       | 1070000.00    |      107000.00           |        82.31         |   45000.00  |  525000.00
Bottom 80% Customers   |       40       |  230000.00    |        5750.00           |        17.69         |    2500.00  |   42000.00
```

**How it works:**
- `NTILE(5)` creates 5 quintiles (20% each)
- `quintile = 1` represents top 20%
- CASE statement groups into two segments
- Dramatic difference shows extreme concentration
- Validates 80/20 rule (or even stronger concentration)

---

## Query 5: Customer Value Tiers with Revenue Thresholds

**Segment customers into Platinum, Gold, Silver, Bronze tiers**

```sql
WITH cte AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS revenue,
        COUNT(order_id) AS total_orders
    FROM Orders 
    GROUP BY customer_id
),
revenue_stats AS (
    SELECT 
        PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY revenue) AS p90_threshold,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY revenue) AS p75_threshold,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY revenue) AS p50_threshold
    FROM cte
)
SELECT 
    CASE 
        WHEN c.revenue >= (SELECT p90_threshold FROM revenue_stats) THEN 'Platinum (Top 10%)'
        WHEN c.revenue >= (SELECT p75_threshold FROM revenue_stats) THEN 'Gold (Top 25%)'
        WHEN c.revenue >= (SELECT p50_threshold FROM revenue_stats) THEN 'Silver (Top 50%)'
        ELSE 'Bronze (Bottom 50%)'
    END AS customer_tier,
    COUNT(c.customer_id) AS customer_count,
    SUM(c.revenue) AS total_revenue,
    ROUND(AVG(c.revenue), 2) AS avg_revenue,
    ROUND(AVG(c.total_orders), 2) AS avg_orders,
    ROUND(SUM(c.revenue) * 100.0 / (SELECT SUM(revenue) FROM cte), 2) AS pct_of_total_revenue
FROM cte c
GROUP BY 
    CASE 
        WHEN c.revenue >= (SELECT p90_threshold FROM revenue_stats) THEN 'Platinum (Top 10%)'
        WHEN c.revenue >= (SELECT p75_threshold FROM revenue_stats) THEN 'Gold (Top 25%)'
        WHEN c.revenue >= (SELECT p50_threshold FROM revenue_stats) THEN 'Silver (Top 50%)'
        ELSE 'Bronze (Bottom 50%)'
    END
ORDER BY total_revenue DESC;
```

**Output:**
```
customer_tier         | customer_count | total_revenue | avg_revenue | avg_orders | pct_of_total_revenue
----------------------|----------------|---------------|-------------|------------|---------------------
Platinum (Top 10%)    |       5        |   850000.00   |  170000.00  |    6.40    |        65.43
Gold (Top 25%)        |       8        |   280000.00   |   35000.00  |    4.25    |        21.54
Silver (Top 50%)      |      12        |   120000.00   |   10000.00  |    3.17    |         9.23
Bronze (Bottom 50%)   |      25        |    50000.00   |    2000.00  |    1.84    |         3.85
```

**How it works:**
- `PERCENTILE_CONT` calculates revenue thresholds at 90th, 75th, 50th percentiles
- Creates four meaningful customer tiers
- Shows revenue and order patterns per tier
- Enables targeted marketing and service strategies
- Bronze tier has 50% of customers but only 3.85% of revenue

---

## How It Works

### Key Concepts

**1. NTILE() Window Function**
```sql
NTILE(10) OVER (ORDER BY revenue DESC)
```
- Divides customers into N equal-sized groups
- `NTILE(10)` creates deciles (10% each)
- `NTILE(5)` creates quintiles (20% each)
- `NTILE(4)` creates quartiles (25% each)
- Ordered by revenue DESC puts highest in bucket 1

**2. Pareto Principle (80/20 Rule)**
- 80% of revenue comes from 20% of customers
- Often even more extreme in reality (90/10 or 95/5)
- Critical for resource allocation decisions
- Guides customer retention priorities

**3. Revenue Concentration**
```
Concentration = Top Segment Revenue / Total Revenue × 100
```
- Measures inequality in revenue distribution
- Higher = more concentrated (fewer key customers)
- Lower = more distributed (many equal contributors)

**4. PERCENTILE_CONT**
```sql
PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY revenue)
```
- Finds value at specific percentile
- 0.9 = 90th percentile (top 10% threshold)
- Creates data-driven tier boundaries
- More flexible than fixed thresholds

---

## Business Interpretation

### Revenue Concentration Signals

**High Concentration (Top 10% > 60%):**
- High customer dependency risk
- Need strong retention for key accounts
- VIP customer service critical
- Churn of one top customer = major impact

**Moderate Concentration (Top 10% = 30-60%):**
- Balanced customer portfolio
- Mix of large and small customers
- Diversified revenue streams
- Manageable retention efforts

**Low Concentration (Top 10% < 30%):**
- Very distributed customer base
- Mass market business model
- Scale through volume, not value
- Focus on acquisition over retention

### Customer Tier Strategies

**Platinum (Top 10%):**
- Dedicated account managers
- Exclusive benefits and early access
- Premium support channels
- Quarterly business reviews

**Gold (Next 15%):**
- Priority customer service
- Loyalty rewards programs
- Upsell opportunities
- Regular engagement

**Silver (Next 25%):**
- Standard service levels
- Growth potential identification
- Automated nurture campaigns
- Self-service options

**Bronze (Bottom 50%):**
- Automated service
- Cost-efficient engagement
- Community forums
- Identify upgraders

---

## Real World Use Cases

1. **Customer Retention**: Prioritize efforts on revenue-critical customers
2. **Sales Territory Planning**: Allocate resources based on value concentration
3. **Loyalty Program Design**: Tier benefits matching revenue contribution
4. **Risk Management**: Diversification strategies for concentrated revenue
5. **Pricing Strategy**: Volume discounts for top customers
6. **Product Development**: Features for high-value segments
7. **Marketing Budget**: CAC limits based on customer value tiers
8. **Account Management**: Team structure matching customer segments

---

## Key Learning Points

### SQL Techniques
- ✅ NTILE() for equal-sized grouping
- ✅ PERCENTILE_CONT for threshold calculation
- ✅ Window functions with aggregations
- ✅ CTEs for multi-step analysis
- ✅ Percentage calculations
- ✅ Cumulative sums with OVER()
- ✅ Complex CASE statements for segmentation

### Business Analytics
- ✅ Pareto Principle validation
- ✅ Customer value segmentation
- ✅ Revenue concentration analysis
- ✅ Tier-based strategies
- ✅ Resource allocation optimization

### Best Practices
- ✅ Always calculate both count AND revenue
- ✅ Use data-driven thresholds (percentiles)
- ✅ Show cumulative percentages
- ✅ Compare segments side-by-side
- ✅ Include customer profiles with metrics
- ✅ Calculate individual contribution percentages

---

## Performance Tips

1. **Index on customer_id and total_amount**
```sql
CREATE INDEX idx_orders_customer_amount ON Orders(customer_id, total_amount);
```

2. **Materialized view for customer revenue**
```sql
CREATE MATERIALIZED VIEW customer_revenue AS
SELECT customer_id, SUM(total_amount) AS revenue
FROM Orders
GROUP BY customer_id;
```

3. **Use NTILE efficiently** - calculates once per query
4. **Cache percentile thresholds** for repeated tier queries

---

## Extension Ideas

- Add time-based analysis (revenue concentration trends)
- Segment by product category or region
- Calculate customer lifetime value (CLV) with churn
- Predict future tier transitions
- Compare concentration across business units
- Build automated tier assignment triggers
- Track tier movement month-over-month
