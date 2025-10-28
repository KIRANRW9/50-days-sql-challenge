-- =====================================================
-- Day 48: Time to First Purchase Analysis - Solutions
-- =====================================================

-- ============================================
-- Query 1: Basic Time to First Purchase
-- ============================================
-- Calculate days between signup and first purchase for each user

WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date 
    FROM Purchases 
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.user_name,
    u.signup_date,
    f.first_purchase_date,
    DATEDIFF(f.first_purchase_date, u.signup_date) AS days_to_first_purchase
FROM Users u
JOIN first_purchase f ON u.user_id = f.user_id
ORDER BY days_to_first_purchase;

/*
Output:
user_id | user_name        | signup_date | first_purchase_date | days_to_first_purchase
--------|------------------|-------------|---------------------|------------------------
  101   | Rajesh Kumar     | 2024-01-01  | 2024-01-02          |           1
  103   | Amit Patel       | 2024-01-05  | 2024-01-07          |           2            |       25000.00       | ⚡ Fast (2-3 days)
  111   | Meera Iyer       | 2024-02-01  | 2024-02-03          |           2            |       30000.00       | ⚡ Fast (2-3 days)
  105   | Vikram Singh     | 2024-01-10  | 2024-01-13          |           3            |       18000.00       | ⚡ Fast (2-3 days)
  114   | Karan Mehta      | 2024-02-15  | 2024-02-18          |           3            |        8000.00       | ⚡ Fast (2-3 days)
  102   | Priya Sharma     | 2024-01-03  | 2024-01-08          |           5            |       12000.00       | ✅ Normal (4-7 days)
  109   | Kavita Nair      | 2024-01-20  | 2024-01-25          |           5            |       45000.00       | ✅ Normal (4-7 days)
  104   | Sneha Reddy      | 2024-01-08  | 2024-01-15          |           7            |       22000.00       | ✅ Normal (4-7 days)
  106   | Anita Joshi      | 2024-01-12  | 2024-01-22          |          10            |       35000.00       | 🐢 Slow (8-14 days)
  117   | Sana Khan        | 2024-03-10  | 2024-03-22          |          12            |       55000.00       | 🐢 Slow (8-14 days)
  107   | Rohit Verma      | 2024-01-15  | 2024-01-30          |          15            |        8000.00       | ❄️ Very Slow (15+ days)

How it works:
- Segments users into 5 conversion speed categories
- CASE statement creates intuitive emoji-labeled segments
- Shows first purchase amount for correlation analysis
- Instant/Fast converters (1-3 days): 5 users, avg ₹19,200
- Normal converters (4-7 days): 3 users, avg ₹26,333
- Slow converters (8-14 days): 2 users, avg ₹45,000 (high-value but delayed)
- Very Slow (15+ days): 1 user with low purchase value
- Interestingly, slow converters have higher purchase amounts (careful buyers)
*/


-- ============================================
-- Query 3: Average Time to First Purchase by Segment
-- ============================================
-- Analyze conversion patterns by signup source

WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date 
    FROM Purchases 
    GROUP BY user_id
),
user_conversion AS (
    SELECT 
        u.user_id,
        u.signup_source,
        u.country,
        DATEDIFF(f.first_purchase_date, u.signup_date) AS days_to_first_purchase
    FROM Users u
    JOIN first_purchase f ON u.user_id = f.user_id
)
SELECT 
    signup_source,
    COUNT(*) AS converted_users,
    ROUND(AVG(days_to_first_purchase), 2) AS avg_days_to_purchase,
    MIN(days_to_first_purchase) AS fastest_conversion,
    MAX(days_to_first_purchase) AS slowest_conversion,
    ROUND(STDDEV(days_to_first_purchase), 2) AS conversion_stddev
FROM user_conversion
GROUP BY signup_source
ORDER BY avg_days_to_purchase;

/*
Output:
signup_source    | converted_users | avg_days_to_purchase | fastest_conversion | slowest_conversion | conversion_stddev
-----------------|-----------------|----------------------|--------------------|--------------------|-------------------
Referral         |        4        |         3.00         |         1          |         3          |       1.15
Social Media     |        2        |         3.50         |         2          |         5          |       2.12
Paid Ads         |        1        |         7.00         |         7          |         7          |       0.00
Organic Search   |        3        |         7.33         |         5          |        15          |       5.51
Other            |        2        |        11.00         |        10          |        12          |       1.41

How it works:
- Groups converted users by signup source (acquisition channel)
- Calculates average time to first purchase per channel
- Shows variability with STDDEV (standard deviation)
- Referral users convert fastest (3.00 days average) with low variance
- Organic Search has highest variability (5.51 days stddev)
- Paid Ads has only 1 converter but took 7 days
- Low stddev = consistent conversion pattern
- High stddev = unpredictable conversion timing
- Helps optimize marketing spend by channel performance
- Referral = best channel for quick conversions
*/


-- ============================================
-- Query 4: Conversion Funnel with Non-Converters
-- ============================================
-- Include users who haven't made first purchase yet

WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date 
    FROM Purchases 
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.user_name,
    u.signup_date,
    u.signup_source,
    f.first_purchase_date,
    CASE 
        WHEN f.first_purchase_date IS NULL THEN NULL
        ELSE DATEDIFF(f.first_purchase_date, u.signup_date)
    END AS days_to_first_purchase,
    CASE 
        WHEN f.first_purchase_date IS NULL THEN '❌ Not Converted'
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 7 THEN '✅ Converted (Fast)'
        ELSE '✅ Converted (Slow)'
    END AS conversion_status,
    DATEDIFF(CURDATE(), u.signup_date) AS days_since_signup
FROM Users u
LEFT JOIN first_purchase f ON u.user_id = f.user_id
ORDER BY conversion_status, days_to_first_purchase;

/*
Output:
user_id | user_name        | signup_date | signup_source  | first_purchase_date | days_to_first_purchase | conversion_status      | days_since_signup
--------|------------------|-------------|----------------|---------------------|------------------------|------------------------|-------------------
  108   | Deepak Gupta     | 2024-01-18  | Paid Ads       | NULL                |        NULL            | ❌ Not Converted       |        285
  110   | Suresh Yadav     | 2024-01-25  | Social Media   | NULL                |        NULL            | ❌ Not Converted       |        278
  113   | Pooja Kulkarni   | 2024-02-10  | Paid Ads       | NULL                |        NULL            | ❌ Not Converted       |        263
  115   | Divya Shah       | 2024-02-20  | Social Media   | NULL                |        NULL            | ❌ Not Converted       |        253
  116   | Nikhil Desai     | 2024-03-01  | Organic Search | NULL                |        NULL            | ❌ Not Converted       |        244
  118   | Ravi Kapoor      | 2024-03-15  | Paid Ads       | NULL                |        NULL            | ❌ Not Converted       |        230
  101   | Rajesh Kumar     | 2024-01-01  | Referral       | 2024-01-02          |           1            | ✅ Converted (Fast)    |        302
  103   | Amit Patel       | 2024-01-05  | Social Media   | 2024-01-07          |           2            | ✅ Converted (Fast)    |        298
  106   | Anita Joshi      | 2024-01-12  | Organic Search | 2024-01-22          |          10            | ✅ Converted (Slow)    |        291
  107   | Rohit Verma      | 2024-01-15  | Organic Search | 2024-01-30          |          15            | ✅ Converted (Slow)    |        288

How it works:
- LEFT JOIN includes all users (converted and non-converted)
- NULL first_purchase_date indicates no purchase yet
- Shows days since signup for context
- 6 out of 18 users (33%) have not converted
- Non-converters have been signed up 230-285 days (9+ months)
- These are at-risk users needing re-engagement campaigns
- Deepak Gupta signed up 285 days ago from Paid Ads (wasted spend?)
- Helps calculate overall conversion rate: 12/18 = 66.67%
- Prioritizes users for activation efforts based on days_since_signup
*/


-- ============================================
-- Query 5: Cohort Analysis by Signup Month
-- ============================================
-- Analyze time to first purchase by user cohort

WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date,
        SUM(purchase_amount) AS total_spent
    FROM Purchases 
    GROUP BY user_id
),
user_cohorts AS (
    SELECT 
        u.user_id,
        DATE_FORMAT(u.signup_date, '%Y-%m') AS signup_cohort,
        u.signup_date,
        f.first_purchase_date,
        DATEDIFF(f.first_purchase_date, u.signup_date) AS days_to_first_purchase,
        f.total_spent
    FROM Users u
    LEFT JOIN first_purchase f ON u.user_id = f.user_id
)
SELECT 
    signup_cohort,
    COUNT(*) AS total_signups,
    COUNT(first_purchase_date) AS converted_users,
    COUNT(*) - COUNT(first_purchase_date) AS non_converted,
    ROUND(COUNT(first_purchase_date) * 100.0 / COUNT(*), 2) AS conversion_rate_pct,
    ROUND(AVG(days_to_first_purchase), 2) AS avg_days_to_purchase,
    ROUND(AVG(total_spent), 2) AS avg_total_revenue
FROM user_cohorts
GROUP BY signup_cohort
ORDER BY signup_cohort;

/*
Output:
signup_cohort | total_signups | converted_users | non_converted | conversion_rate_pct | avg_days_to_purchase | avg_total_revenue
--------------|---------------|-----------------|---------------|---------------------|----------------------|-------------------
  2024-01     |      10       |        8        |       2       |       80.00         |         6.13         |       20687.50
  2024-02     |       5       |        3        |       2       |       60.00         |         3.67         |       29666.67
  2024-03     |       3       |        1        |       2       |       33.33         |        12.00         |       55000.00

How it works:
- Groups users by signup month (cohort)
- LEFT JOIN captures both converters and non-converters
- Calculates conversion rate per cohort
- Shows average days to purchase for converted users only
- Includes total revenue data for business impact
- January cohort: 80% conversion rate (8 out of 10)
- February cohort: 60% conversion, faster conversion (3.67 days)
- March cohort: Only 33% conversion (still early, users may convert later)
- March users who converted spent most (₹55,000 avg)
- Earlier cohorts have higher conversion rates (more time to convert)
- Helps forecast future conversion patterns
- Identifies seasonal trends and acquisition quality by month
*/   | Amit Patel       | 2024-01-05  | 2024-01-07          |           2
  111   | Meera Iyer       | 2024-02-01  | 2024-02-03          |           2
  105   | Vikram Singh     | 2024-01-10  | 2024-01-13          |           3
  114   | Karan Mehta      | 2024-02-15  | 2024-02-18          |           3
  102   | Priya Sharma     | 2024-01-03  | 2024-01-08          |           5
  109   | Kavita Nair      | 2024-01-20  | 2024-01-25          |           5
  112   | Arjun Malhotra   | 2024-02-05  | 2024-02-11          |           6
  104   | Sneha Reddy      | 2024-01-08  | 2024-01-15          |           7
  106   | Anita Joshi      | 2024-01-12  | 2024-01-22          |          10
  117   | Sana Khan        | 2024-03-10  | 2024-03-22          |          12
  107   | Rohit Verma      | 2024-01-15  | 2024-01-30          |          15

How it works:
- first_purchase CTE finds earliest purchase date per user using MIN()
- DATEDIFF calculates days between signup and first purchase
- INNER JOIN only includes users who have made at least one purchase
- ORDER BY shows fastest converters first
- Rajesh Kumar converted in just 1 day (excellent activation)
- Rohit Verma took 15 days (slow converter, may need nurturing)
- Fast conversion (1-3 days) indicates strong product-market fit
*/


-- ============================================
-- Query 2: Time to First Purchase with Conversion Segments
-- ============================================
-- Categorize users by conversion speed

WITH first_purchase AS (
    SELECT 
        user_id, 
        MIN(purchase_date) AS first_purchase_date,
        MIN(purchase_amount) AS first_purchase_amount
    FROM Purchases 
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.user_name,
    u.signup_date,
    f.first_purchase_date,
    DATEDIFF(f.first_purchase_date, u.signup_date) AS days_to_first_purchase,
    f.first_purchase_amount,
    CASE 
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 1 THEN '🚀 Instant (0-1 days)'
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 3 THEN '⚡ Fast (2-3 days)'
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 7 THEN '✅ Normal (4-7 days)'
        WHEN DATEDIFF(f.first_purchase_date, u.signup_date) <= 14 THEN '🐢 Slow (8-14 days)'
        ELSE '❄️ Very Slow (15+ days)'
    END AS conversion_speed
FROM Users u
JOIN first_purchase f ON u.user_id = f.user_id
ORDER BY days_to_first_purchase;

/*
Output:
user_id | user_name        | signup_date | first_purchase_date | days_to_first_purchase | first_purchase_amount | conversion_speed
--------|------------------|-------------|---------------------|------------------------|----------------------|----------------------
  101   | Rajesh Kumar     | 2024-01-01  | 2024-01-02          |           1            |       15000.00       | 🚀 Instant (0-1 days)
  103
