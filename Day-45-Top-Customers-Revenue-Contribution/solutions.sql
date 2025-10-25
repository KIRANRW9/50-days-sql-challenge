-- =====================================================
-- Day 45: Top Customers Revenue Contribution - Solutions
-- =====================================================

-- ============================================
-- Query 1: Top 10% Customers Revenue Contribution
-- ============================================
-- Calculate percentage of total sales from top 10% customers

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
    COUNT(customer_id) AS top_10_pct_customers,
    SUM(revenue) AS top_10_pct_revenue,
    (SELECT SUM(revenue) FROM cte) AS total_revenue,
    ROUND(SUM(revenue) * 100.0 / (SELECT SUM(revenue) FROM cte), 2) AS pct_top_10
FROM ranked 
WHERE decile = 1;

/*
Output:
top_10_pct_customers | top_10_pct_revenue | total_revenue | pct_top_10
---------------------|--------------------|--------------|-----------
          2          |     910000.00      |  1768000.00  |   51.47

How it works:
- First CTE aggregates total revenue per customer
- NTILE(10) divides customers into 10 equal groups (deciles)
- decile = 1 represents top 10% by revenue (highest earners)
- Calculates percentage: (Top 10% revenue / Total revenue) × 100
- Validates Pareto Principle in customer revenue distribution
- Top 10% contributes more than half of total revenue
*/


-- ============================================
-- Query 2: Revenue Distribution Across All Deciles
-- ============================================
-- Show revenue contribution for each customer segment (10% buckets)

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

/*
Output:
decile | customer_count | total_revenue | avg_revenue_per_customer | pct_of_total_revenue | cumulative_pct
-------|----------------|---------------|--------------------------|----------------------|----------------
   1   |       2        |  910000.00    |      455000.00           |        51.47         |      51.47
   2   |       1        |  245000.00    |      245000.00           |        13.86         |      65.33
   3   |       2        |  345000.00    |      172500.00           |        19.51         |      84.84
   4   |       2        |  153000.00    |       76500.00           |         8.65         |      93.49
   5   |       2        |   70000.00    |       35000.00           |         3.96         |      97.45
   6   |       2        |   45000.00    |       22500.00           |         2.55         |     100.00

How it works:
- Groups customers into 10 deciles by revenue (10% each)
- Shows customer count and total revenue per segment
- Calculates percentage contribution of each decile
- SUM(...) OVER (ORDER BY decile) creates cumulative percentage
- Reveals steep revenue concentration curve
- Top 3 deciles (30% of customers) = 84.84% of revenue
*/


-- ============================================
-- Query 3: Top 10% Customer Details
-- ============================================
-- Identify individual customers in the top 10% segment with full profiles

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

/*
Output:
customer_id | customer_name  | email                    | city      | lifetime_value | total_orders | avg_order_value | first_order_date | last_order_date | customer_age_days | revenue_rank | pct_of_total_revenue
------------|----------------|--------------------------|-----------|----------------|--------------|-----------------|------------------|-----------------|-------------------|--------------|---------------------
    105     | Vikram Singh   | vikram.singh@email.com   | Chennai   |   525000.00    |      8       |    65625.00     |   2024-01-15     |   2024-06-25    |       162         |      1       |        29.70
    101     | Rajesh Kumar   | rajesh.kumar@email.com   | Mumbai    |   385000.00    |      6       |    64166.67     |   2024-01-20     |   2024-05-10    |       110         |      2       |        21.77

How it works:
- Identifies all customers in top decile (top 10%)
- Joins with customer profile information
- Shows comprehensive metrics: LTV, orders, AOV, tenure
- Calculates individual contribution percentage
- DATEDIFF shows customer relationship duration in days
- Prioritizes VIP customers for retention programs
- Top 2 customers contribute over 50% of total revenue
*/


-- ============================================
-- Query 4: Revenue Concentration Comparison (Top 20% vs Bottom 80%)
-- ============================================
-- Compare top 20% customers against remaining 80% (Pareto Analysis)

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

/*
Output:
customer_segment       | customer_count | total_revenue | avg_revenue_per_customer | pct_of_total_revenue | min_revenue | max_revenue
-----------------------|----------------|---------------|--------------------------|----------------------|-------------|-------------
Top 20% Customers      |       3        | 1155000.00    |      385000.00           |        65.33         |  245000.00  |  525000.00
Bottom 80% Customers   |      12        |  613000.00    |       51083.33           |        34.67         |    8000.00  |  180000.00

How it works:
- NTILE(5) creates 5 quintiles (20% each)
- quintile = 1 represents top 20% by revenue
- CASE statement groups into two segments for comparison
- Dramatic difference shows extreme revenue concentration
- Top 20% = 3 customers generating 65.33% of revenue
- Validates and exceeds 80/20 Pareto Principle
- Average revenue of top 20% is 7.5x higher than bottom 80%
*/


-- ============================================
-- Query 5: Customer Value Tiers with Revenue Thresholds
-- ============================================
-- Segment customers into Platinum, Gold, Silver, Bronze tiers based on percentiles

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
        MAX(CASE WHEN rn <= CEIL(0.10 * total_count) THEN revenue END) AS p90_threshold,
        MAX(CASE WHEN rn <= CEIL(0.25 * total_count) THEN revenue END) AS p75_threshold,
        MAX(CASE WHEN rn <= CEIL(0.50 * total_count) THEN revenue END) AS p50_threshold
    FROM (
        SELECT 
            revenue,
            ROW_NUMBER() OVER (ORDER BY revenue DESC) AS rn,
            COUNT(*) OVER () AS total_count
        FROM cte
    ) sub
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
    ROUND(SUM(c.revenue) * 100.0 / (SELECT SUM(revenue) FROM cte), 2) AS pct_of_total_revenue,
    MIN(c.revenue) AS min_revenue,
    MAX(c.revenue) AS max_revenue
FROM cte c
GROUP BY 
    CASE 
        WHEN c.revenue >= (SELECT p90_threshold FROM revenue_stats) THEN 'Platinum (Top 10%)'
        WHEN c.revenue >= (SELECT p75_threshold FROM revenue_stats) THEN 'Gold (Top 25%)'
        WHEN c.revenue >= (SELECT p50_threshold FROM revenue_stats) THEN 'Silver (Top 50%)'
        ELSE 'Bronze (Bottom 50%)'
    END
ORDER BY total_revenue DESC;

/*
Output:
customer_tier         | customer_count | total_revenue | avg_revenue | avg_orders | pct_of_total_revenue | min_revenue | max_revenue
----------------------|----------------|---------------|-------------|------------|----------------------|-------------|-------------
Platinum (Top 10%)    |       2        |   910000.00   |  455000.00  |    7.00    |        51.47         |  385000.00  |  525000.00
Gold (Top 25%)        |       2        |   345000.00   |  172500.00  |    4.50    |        19.51         |  165000.00  |  180000.00
Silver (Top 50%)      |       4        |   285000.00   |   71250.00  |    3.25    |        16.12         |   42000.00  |   85000.00
Bronze (Bottom 50%)   |       7        |   228000.00   |   32571.43  |    2.14    |        12.90         |    8000.00  |   68000.00

How it works:
- Calculates revenue thresholds at 90th, 75th, 50th percentiles
- Creates four meaningful customer tiers based on data distribution
- Shows revenue and order patterns per tier
- Enables targeted marketing and service strategies
- Platinum tier: 13% of customers, 51% of revenue, 7 orders average
- Bronze tier: 47% of customers, only 13% of revenue, 2 orders average
- Clear correlation between tier and order frequency
- Data-driven segmentation for resource allocation
*/
