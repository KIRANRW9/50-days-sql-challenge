-- =====================================================
-- Day 44: Conversion Funnel Analysis - Solutions
-- =====================================================

-- ============================================
-- Query 1: Basic Funnel Counts
-- ============================================
-- Retrieve total counts at each funnel stage

SELECT 
    SUM(CASE WHEN stage = 'visit' THEN 1 ELSE 0 END) AS visits,
    SUM(CASE WHEN stage = 'sign_up' THEN 1 ELSE 0 END) AS sign_ups,
    SUM(CASE WHEN stage = 'purchase' THEN 1 ELSE 0 END) AS purchases
FROM Funnel;

/*
Output:
visits | sign_ups | purchases
-------|----------|----------
  20   |    9     |    5

How it works:
- SUM(CASE WHEN...) performs conditional aggregation
- Counts events at each specific funnel stage
- Single query retrieves all stage counts efficiently
*/


-- ============================================
-- Query 2: Funnel with Conversion Rates
-- ============================================
-- Calculate conversion rates between consecutive funnel stages

SELECT 
    visits,
    sign_ups,
    purchases,
    ROUND((sign_ups * 100.0 / visits), 2) AS visit_to_signup_rate,
    ROUND((purchases * 100.0 / sign_ups), 2) AS signup_to_purchase_rate,
    ROUND((purchases * 100.0 / visits), 2) AS visit_to_purchase_rate
FROM (
    SELECT 
        SUM(CASE WHEN stage = 'visit' THEN 1 ELSE 0 END) AS visits,
        SUM(CASE WHEN stage = 'sign_up' THEN 1 ELSE 0 END) AS sign_ups,
        SUM(CASE WHEN stage = 'purchase' THEN 1 ELSE 0 END) AS purchases
    FROM Funnel
) AS funnel_counts;

/*
Output:
visits | sign_ups | purchases | visit_to_signup_rate | signup_to_purchase_rate | visit_to_purchase_rate
-------|----------|-----------|----------------------|-------------------------|------------------------
  20   |    9     |    5      |       45.00          |         55.56           |         25.00

How it works:
- Subquery calculates stage counts
- Outer query computes conversion percentages
- * 100.0 ensures decimal division
- ROUND(..., 2) formats to 2 decimal places
*/


-- ============================================
-- Query 3: Daily Funnel Trends
-- ============================================
-- Analyze funnel performance by date

WITH DailyFunnel AS (
    SELECT 
        DATE(timestamp) AS funnel_date,
        SUM(CASE WHEN stage = 'visit' THEN 1 ELSE 0 END) AS visits,
        SUM(CASE WHEN stage = 'sign_up' THEN 1 ELSE 0 END) AS sign_ups,
        SUM(CASE WHEN stage = 'purchase' THEN 1 ELSE 0 END) AS purchases
    FROM Funnel
    GROUP BY DATE(timestamp)
)
SELECT 
    funnel_date,
    visits,
    sign_ups,
    purchases,
    ROUND((sign_ups * 100.0 / NULLIF(visits, 0)), 2) AS signup_conversion_rate,
    ROUND((purchases * 100.0 / NULLIF(sign_ups, 0)), 2) AS purchase_conversion_rate
FROM DailyFunnel
ORDER BY funnel_date;

/*
Output:
funnel_date | visits | sign_ups | purchases | signup_conversion_rate | purchase_conversion_rate
------------|--------|----------|-----------|------------------------|-------------------------
2024-01-01  |   5    |    3     |     2     |        60.00           |         66.67
2024-01-02  |   6    |    3     |     1     |        50.00           |         33.33
2024-01-03  |   6    |    2     |     2     |        33.33           |        100.00
2024-01-04  |   3    |    1     |     0     |        33.33           |          0.00

How it works:
- DATE(timestamp) extracts date portion for grouping
- CTE calculates daily stage counts
- NULLIF(visits, 0) prevents division by zero
- Shows daily conversion trends
*/


-- ============================================
-- Query 4: Time Between Funnel Stages
-- ============================================
-- Measure how long users take to progress through funnel

WITH UserStages AS (
    SELECT 
        user_id,
        MAX(CASE WHEN stage = 'visit' THEN timestamp END) AS visit_time,
        MAX(CASE WHEN stage = 'sign_up' THEN timestamp END) AS signup_time,
        MAX(CASE WHEN stage = 'purchase' THEN timestamp END) AS purchase_time
    FROM Funnel
    GROUP BY user_id
)
SELECT 
    user_id,
    visit_time,
    signup_time,
    purchase_time,
    TIMESTAMPDIFF(MINUTE, visit_time, signup_time) AS minutes_to_signup,
    TIMESTAMPDIFF(MINUTE, signup_time, purchase_time) AS minutes_to_purchase,
    TIMESTAMPDIFF(MINUTE, visit_time, purchase_time) AS total_funnel_minutes
FROM UserStages
WHERE purchase_time IS NOT NULL
ORDER BY total_funnel_minutes;

/*
Output:
user_id | visit_time          | signup_time         | purchase_time       | minutes_to_signup | minutes_to_purchase | total_funnel_minutes
--------|---------------------|---------------------|---------------------|-------------------|---------------------|---------------------
   11   | 2024-01-03 08:00:00 | 2024-01-03 08:02:00 | 2024-01-03 08:10:00 |        2          |          8          |         10
    1   | 2024-01-01 10:00:00 | 2024-01-01 10:05:00 | 2024-01-01 10:15:00 |        5          |         10          |         15
   17   | 2024-01-03 14:00:00 | 2024-01-03 14:10:00 | 2024-01-03 14:25:00 |       10          |         15          |         25
    4   | 2024-01-01 13:00:00 | 2024-01-01 13:05:00 | 2024-01-01 13:20:00 |        5          |         15          |         20
    8   | 2024-01-02 11:00:00 | 2024-01-02 11:45:00 | 2024-01-02 12:30:00 |       45          |         45          |         90

How it works:
- Pivots stages into columns per user
- TIMESTAMPDIFF calculates time differences in minutes
- WHERE purchase_time IS NOT NULL filters completed funnels
- Identifies fast vs slow converters
*/


-- ============================================
-- Query 5: Drop-off Analysis by Stage
-- ============================================
-- Identify where users exit the funnel

WITH FunnelStages AS (
    SELECT 
        user_id,
        MAX(CASE WHEN stage = 'visit' THEN 1 ELSE 0 END) AS has_visit,
        MAX(CASE WHEN stage = 'sign_up' THEN 1 ELSE 0 END) AS has_signup,
        MAX(CASE WHEN stage = 'purchase' THEN 1 ELSE 0 END) AS has_purchase
    FROM Funnel
    GROUP BY user_id
)
SELECT 
    'Visit Only' AS user_segment,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT user_id) FROM Funnel), 2) AS percentage
FROM FunnelStages
WHERE has_visit = 1 AND has_signup = 0 AND has_purchase = 0

UNION ALL

SELECT 
    'Visit + Signup' AS user_segment,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT user_id) FROM Funnel), 2) AS percentage
FROM FunnelStages
WHERE has_visit = 1 AND has_signup = 1 AND has_purchase = 0

UNION ALL

SELECT 
    'Complete Funnel' AS user_segment,
    COUNT(*) AS user_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(DISTINCT user_id) FROM Funnel), 2) AS percentage
FROM FunnelStages
WHERE has_visit = 1 AND has_signup = 1 AND has_purchase = 1

ORDER BY user_count DESC;

/*
Output:
user_segment     | user_count | percentage
-----------------|------------|------------
Visit Only       |     11     |   55.00
Visit + Signup   |      4     |   20.00
Complete Funnel  |      5     |   25.00

How it works:
- Classifies each user into exit point category
- UNION ALL combines results from different segments
- Shows distribution of drop-off points
- 55% drop after visit = biggest optimization opportunity
- Helps prioritize UX improvements
*/
