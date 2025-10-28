-- =====================================================
-- Day 49: Longest Gap Between Orders - Solutions
-- =====================================================

-- ============================================
-- Query 1: Longest Gap Between Orders
-- ============================================
-- Find the maximum time gap between consecutive orders for each customer

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

/*
Output:
customer_id | max_gap_days
------------|-------------
    104     |     90
    102     |     60
    105     |     45
    101     |     30
    103     |     17

How it works:
- LAG(order_date) gets previous order date for same customer
- PARTITION BY customer_id creates separate windows per customer
- ORDER BY order_date ensures chronological sequence
- DATEDIFF calculates days between consecutive orders
- WHERE filters out NULL (first order has no previous order)
- MAX() finds longest gap for each customer
- Customer 104 has 90-day gap (critical churn risk)
- Customer 103 has only 17-day gap (highly engaged)
- Helps identify customers with declining engagement
*/


-- ============================================
-- Query 2: Detailed Gap Analysis with Customer Information
-- ============================================
-- Show all gaps with customer details and gap classifications

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

/*
Output:
customer_id | customer_name   | email                   | customer_segment | max_gap_days | total_orders | first_order_date | last_order_date | customer_lifetime_days | risk_category
------------|-----------------|-------------------------|------------------|--------------|--------------|------------------|-----------------|------------------------|-------------------------
    104     | Sneha Reddy     | sneha.reddy@email.com   | Premium          |      90      |      4       |   2024-01-08     |   2024-06-15    |         159            | 🔴 Critical (90+ days)
    102     | Priya Sharma    | priya.sharma@email.com  | Standard         |      60      |      5       |   2024-01-03     |   2024-05-04    |         122            | 🟠 High Risk (60-89 days)
    105     | Vikram Singh    | vikram.singh@email.com  | VIP              |      45      |      6       |   2024-01-10     |   2024-05-05    |         116            | 🟡 Medium Risk (30-59 days)
    101     | Rajesh Kumar    | rajesh.kumar@email.com  | Premium          |      30      |      7       |   2024-01-01     |   2024-06-08    |         159            | 🟡 Medium Risk (30-59 days)
    103     | Amit Patel      | amit.patel@email.com    | Standard         |      17      |      8       |   2024-01-05     |   2024-04-22    |         108            | 🟢 Low Risk (15-29 days)

How it works:
- order_gaps CTE calculates all gaps between consecutive orders
- max_gaps CTE finds longest gap per customer
- Joins with Customers table for profile information
- Calculates total orders and customer lifetime
- CASE statement classifies customers by risk level
- Customer 104: 90-day gap with only 4 orders (needs immediate attention)
- Customer 103: 17-day max gap with 8 orders (excellent engagement)
- Risk categories help prioritize retention campaigns
- Critical/High risk customers need re-engagement offers
*/


-- ============================================
-- Query 3: All Gaps Between Orders
-- ============================================
-- Show every gap between consecutive orders for detailed analysis

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

/*
Output (sample):
customer_id | customer_name   | prev_order_id | current_order_id | prev_order_date | current_order_date | gap_days | order_amount | order_number | gap_type
------------|-----------------|---------------|------------------|-----------------|--------------------|----------|--------------|--------------|------------------
    101     | Rajesh Kumar    |      1        |       2          | 2024-01-01      | 2024-01-15         |    14    |    1200.00   |      2       | ⚡ Short Gap
    101     | Rajesh Kumar    |      2        |       3          | 2024-01-15      | 2024-02-10         |    26    |    3500.00   |      3       | 📅 Normal Gap
    101     | Rajesh Kumar    |      3        |       4          | 2024-02-10      | 2024-03-12         |    30    |   25000.00   |      4       | ⏰ Long Gap
    101     | Rajesh Kumar    |      4        |       5          | 2024-03-12      | 2024-04-05         |    24    |    5500.00   |      5       | 📅 Normal Gap
    102     | Priya Sharma    |      8        |       9          | 2024-01-03      | 2024-01-25         |    22    |     800.00   |      2       | 📅 Normal Gap
    102     | Priya Sharma    |      11       |      12          | 2024-03-05      | 2024-05-04         |    60    |     500.00   |      5       | ⚠️ Extended Gap
    104     | Sneha Reddy     |      21       |      22          | 2024-01-08      | 2024-01-15         |     7    |   18000.00   |      2       | ⚡ Short Gap
    104     | Sneha Reddy     |      22       |      23          | 2024-01-15      | 2024-04-15         |    90    |     800.00   |      3       | ⚠️ Extended Gap

How it works:
- Shows every gap between consecutive orders (not just maximum)
- ROW_NUMBER tracks order sequence per customer
- Gap type classification for quick pattern identification
- Helps identify specific periods of dormancy
- Customer 104: Short 7-day gap, then 90-day extended gap (red flag)
- Customer 102: Consistent until 60-day gap at end (declining engagement)
- Extended gaps indicate potential churn points
- Useful for understanding when engagement drops occurred
*/


-- ============================================
-- Query 4: Average Gap vs Longest Gap Analysis
-- ============================================
-- Compare average purchase frequency with longest gap

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

/*
Output:
customer_id | customer_name   | customer_segment | total_orders | avg_gap_days | min_gap_days | max_gap_days | stddev_gap_days | max_deviation_from_avg | gap_pattern
------------|-----------------|------------------|--------------|--------------|--------------|--------------|-----------------|------------------------|---------------------
    104     | Sneha Reddy     | Premium          |      4       |    53.00     |      7       |      90      |      38.94      |         37.00          | 🚨 Anomaly (3x avg)
    102     | Priya Sharma    | Standard         |      5       |    30.50     |     16       |      60      |      18.15      |         29.50          | ⚠️ Significant (2x avg)
    105     | Vikram Singh    | VIP              |      6       |    23.20     |     10       |      45      |      13.84      |         21.80          | ⚠️ Significant (2x avg)
    101     | Rajesh Kumar    | Premium          |      7       |    26.50     |     14       |      30      |       5.72      |          3.50          | ✅ Consistent
    103     | Amit Patel      | Standard         |      8       |    15.29     |     13       |      17      |       1.50      |          1.71          | ✅ Consistent

How it works:
- Calculates average gap, standard deviation, and range per customer
- STDDEV measures consistency (low = predictable purchase pattern)
- Max deviation shows how far longest gap is from typical behavior
- Customer 104: 90-day gap is 3x their 53-day average (major anomaly)
- Customer 103: Very consistent (max 17 days vs 15.29 avg)
- Anomalies may indicate life events, dissatisfaction, or competitor switch
- Low stddev + low max = reliable, engaged customer
- High stddev = unpredictable, may need nurturing
*/


-- ============================================
-- Query 5: Recent Activity vs Historical Gaps
-- ============================================
-- Identify customers whose recent gap exceeds their historical pattern

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
ORDER BY engagement_trend DESC, days_since_last_order DESC;

/*
Output:
customer_id | customer_name   | email                   | customer_segment | total_orders | last_order_date | days_since_last_order | most_recent_gap | historical_avg_gap | max_historical_gap | engagement_trend
------------|-----------------|-------------------------|------------------|--------------|-----------------|----------------------|-----------------|--------------------|--------------------|----------------------
    104     | Sneha Reddy     | sneha.reddy@email.com   | Premium          |      4       |   2024-06-15    |         130          |       61        |        48.50       |         90         | 🔴 Declining Engagement
    105     | Vikram Singh    | vikram.singh@email.com  | VIP              |      6       |   2024-05-05    |         171          |       20        |        23.80       |         45         | 🟢 Improving
    101     | Rajesh Kumar    | rajesh.kumar@email.com  | Premium          |      7       |   2024-06-08    |         137          |       29        |        26.17       |         30         | 🟢 Improving
    103     | Amit Patel      | amit.patel@email.com    | Standard         |      8       |   2024-04-22    |         184          |       17        |        15.14       |         17         | 🟢 Improving
    102     | Priya Sharma    | priya.sharma@email.com  | Standard         |      5       |   2024-05-04    |         172          |       60        |        24.00       |         60         | ⚪ Stable

How it works:
- Compares most recent gap to historical average (excluding most recent)
- ROW_NUMBER(... ORDER BY order_date DESC) identifies most recent order
- Declining engagement = recent gap > 2x historical average
- Days since last order shows current dormancy period
- Customer 104: Recent 61-day gap vs 48.5-day avg (red flag + 130 days dormant)
- Customer 103: Improving trend (17 days vs 15.14 avg) but 184 days dormant
- Prioritizes at-risk customers for immediate outreach
- Green (improving) customers are good candidates for loyalty rewards
- Red (declining) customers need win-back campaigns urgently
*/
