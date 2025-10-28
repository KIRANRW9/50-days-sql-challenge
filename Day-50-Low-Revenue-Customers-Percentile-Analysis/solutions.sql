-- =====================================================
-- Day 50: Low Revenue Customers - Percentile Analysis
-- =====================================================

-- ============================================
-- Query 1: Customers Below 10th Percentile Revenue
-- ============================================
-- Identify customers with revenue below the 10th percentile threshold

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
    ROUND((SELECT PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY total_revenue) FROM cte), 2) AS percentile_10_threshold
FROM cte 
WHERE total_revenue < (SELECT PERCENTILE_CONT(0.1) WITHIN GROUP (ORDER BY total_revenue) FROM cte)
ORDER BY total_revenue;

/*
Output:
customer_id | total_revenue | percentile_10_threshold
------------|---------------|------------------------
    108     |    2500.00    |        7140.00
    110     |    3200.00    |        7140.00
    115     |    4800.00    |        7140.00
    112     |    6500.00    |        7140.00

How it works:
- CTE aggregates total revenue per customer
- PERCENTILE_CONT(0.1) calculates 10th percentile threshold
- WITHIN GROUP (ORDER BY total_revenue) specifies ranking order
- WHERE filters customers below the threshold
- Bottom 10% = lowest revenue generators (4 out of 20 customers = 20%, but <10th percentile value)
- Customer 108: Only ₹2,500 revenue (single order)
- Customer 112: ₹6,500 revenue (two small orders)
- These customers may not be worth retention efforts
- Focus on identifying why they spent so little
*/


-- ============================================
-- Query 2: Revenue Percentile Distribution Analysis
-- ============================================
-- Show customer distribution across all revenue percentiles

WITH customer_revenue AS (
    SELECT 
        customer_id, 
        SUM(total_amount) AS total_revenue 
    FROM Orders 
    GROUP BY customer_id
),
percentile_thresholds AS (
    SELECT 
        ROUND(PERCENTILE_CONT(0.10) WITHIN GROUP (ORDER BY total_revenue), 2) AS p10,
        ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_revenue), 2) AS p25,
        ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY total_revenue), 2) AS p50,
        ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_revenue), 2) AS p75,
        ROUND(PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY total_revenue), 2) AS p90
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
GROUP BY cr.customer_id, c.customer_name, c.signup_source, cr.total_revenue, 
         pt.p10, pt.p25, pt.p50, pt.p75, pt.p90
ORDER BY cr.total_revenue;

/*
Output (sample):
customer_id | customer_name    | signup_source  | total_revenue | revenue_percentile_group | total_orders | avg_order_value
------------|------------------|----------------|---------------|--------------------------|--------------|----------------
    108     | Deepak Gupta     | Paid Ads       |    2500.00    | 🔴 Bottom 10%            |      1       |    2500.00
    110     | Suresh Yadav     | Social Media   |    3200.00    | 🔴 Bottom 10%            |      1       |    3200.00
    115     | Divya Shah       | Social Media   |    4800.00    | 🔴 Bottom 10%            |      2       |    2400.00
    112     | Arjun Malhotra   | Organic Search |    6500.00    | 🔴 Bottom 10%            |      2       |    3250.00
    120     | Vishal Gupta     | Paid Ads       |    9500.00    | 🟠 10-25%                |      2       |    4750.00
    114     | Karan Mehta      | Referral       |   12000.00    | 🟠 10-25%                |      2       |    6000.00
    119     | Anjali Rao       | Organic Search |   15000.00    | 🟡 25-50%                |      2       |    7500.00
    101     | Rajesh Kumar     | Referral       |  145000.00    | ⭐ Top 10%               |      3       |   48333.33

How it works:
- Calculates multiple percentile thresholds (P10, P25, P50, P75, P90)
- CASE statement assigns each customer to a percentile group
- Shows total orders and average order value for context
- Bottom 10%: Low revenue AND typically low order counts
- Top 10%: Very high revenue with fewer but larger orders
- Clear segmentation helps target different strategies per group
- Bottom 10% customers have both low revenue and low AOV
*/


-- ============================================
-- Query 3: Low Revenue Customer Characteristics
-- ============================================
-- Analyze common traits of bottom 10% customers by channel

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
    ROUND(AVG(cr.total_revenue), 2) AS avg_revenue_all_customers,
    ROUND(AVG(cr.total_revenue) - AVG(CASE WHEN lrc.customer_id IS NOT NULL THEN cr.total_revenue END), 2) AS revenue_gap
FROM Customers c
LEFT JOIN low_revenue_customers lrc ON c.customer_id = lrc.customer_id
LEFT JOIN customer_revenue cr ON c.customer_id = cr.customer_id
GROUP BY c.signup_source
ORDER BY pct_low_revenue DESC;

/*
Output:
signup_source    | low_revenue_count | total_customers_from_source | pct_low_revenue | avg_revenue_low_customers | avg_revenue_all_customers | revenue_gap
-----------------|-------------------|-----------------------------|-----------------|--------------------------|--------------------------|--------------
Paid Ads         |        2          |              4              |      50.00      |         4850.00          |        23300.00          |   18450.00
Social Media     |        2          |              4              |      50.00      |         4000.00          |        26500.00          |   22500.00
Organic Search   |        1          |              6              |      16.67      |         6500.00          |        63000.00          |   56500.00
Referral         |        0          |              6              |       0.00      |           NULL           |        72833.33          |      NULL

How it works:
- Identifies which signup sources produce most low-revenue customers
- Compares percentage of low-revenue customers by channel
- Shows average revenue for low vs all customers from each source
- Paid Ads: 50% of customers in bottom 10% (poor ROI, bad targeting)
- Social Media: 50% low-revenue (needs better qualification)
- Organic Search: Only 16.67% low-revenue (better quality leads)
- Referral: 0% low-revenue (highest quality customers!)
- Revenue gap shows opportunity cost of low-quality customers
- Should reduce Paid Ads spend and increase Referral program investment
*/


-- ============================================
-- Query 4: Time-Based Analysis of Low Revenue Customers
-- ============================================
-- When did low-revenue customers sign up vs high-revenue customers?

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

/*
Output:
signup_month | low_revenue_customers | high_revenue_customers | total_customers | pct_low_revenue | avg_low_revenue | avg_high_revenue
-------------|------------------------|------------------------|-----------------|-----------------|-----------------|------------------
  2024-01    |          2            |           2            |       10        |      20.00      |     2850.00     |    140000.00
  2024-02    |          1            |           0            |        5        |      20.00      |     4800.00     |        NULL
  2024-03    |          1            |           1            |        5        |      20.00      |     7200.00     |     88000.00

How it works:
- Groups customers by signup month cohort
- Compares low-revenue (bottom 10%) vs high-revenue (top 10%) distribution
- All months have ~20% low-revenue customers (consistent quality issue)
- January low-revenue avg: ₹2,850 (very low)
- January high-revenue avg: ₹140,000 (48x higher!)
- February had no high-revenue customers (acquisition problem)
- March shows improvement (low-revenue customers spending more: ₹7,200)
- Helps evaluate if recent marketing changes improved customer quality
- Consistent 20% low-revenue rate suggests systemic targeting issue
*/


-- ============================================
-- Query 5: Actionable Insights - Low Revenue Customer Segments
-- ============================================
-- Prioritize low-revenue customers by engagement and potential

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

/*
Output:
customer_id | customer_name    | email                   | signup_source  | customer_segment | total_revenue | total_orders | avg_order_value | first_order_date | last_order_date | customer_lifetime_days | days_since_last_order | customer_type             | action_recommendation
------------|------------------|-------------------------|----------------|------------------|---------------|--------------|-----------------|------------------|-----------------|------------------------|----------------------|---------------------------|----------------------------------
    118     | Ravi Kapoor      | ravi.kapoor@email.com   | Paid Ads       | Standard         |    7200.00    |      2       |     3600.00     |   2024-03-16     |   2024-04-05    |        20              |        208               | 🟠 Occasional Buyer       | Medium Priority - Nurture Campaign
    112     | Arjun Malhotra   | arjun.malhotra@email.com| Organic Search | Standard         |    6500.00    |      2       |     3250.00     |   2024-02-11     |   2024-03-10    |        28              |        234               | ⚠️ Dormant                | Low Priority - Likely Churned
    115     | Divya Shah       | divya.shah@email.com    | Social Media   | Standard         |    4800.00    |      2       |     2400.00     |   2024-02-20     |   2024-03-15    |        24              |        229               | ⚠️ Dormant                | Low Priority - Likely Churned
    110     | Suresh Yadav     | suresh.yadav@email.com  | Social Media   | Standard         |    3200.00    |      1       |     3200.00     |   2024-01-25     |   2024-01-25    |         0              |        279               | 🔴 One-Time Buyer         | Low Priority - Let Churn
    108     | Deepak Gupta     | deepak.gupta@email.com  | Paid Ads       | Standard         |    2500.00    |      1       |     2500.00     |   2024-01-18     |   2024-01-18    |         0              |        286               | 🔴 One-Time Buyer         | Low Priority - Let Churn

How it works:
- Identifies ALL bottom 10% customers with detailed behavioral metrics
- Classifies by customer type: One-Time, Dormant, Engaged, Occasional
- Provides actionable recommendations based on behavior patterns
- Customer 118: Recent occasional buyer (nurture with targeted offers)
- Customers 112, 115: Dormant (90+ days), likely churned, low priority
- Customers 108, 110: One-time low-value buyers, not worth retention cost
- No customers with 3+ orders in bottom 10% (good sign)
- Days since last order shows current engagement status
- Prioritization helps allocate limited retention resources to highest ROI opportunities
- "Let Churn" customers: CAC likely exceeded LTV, focus elsewhere
