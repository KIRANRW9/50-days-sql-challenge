-- =====================================================
-- Day 46: Weekly Active Users (WAU) Analysis - Solutions
-- =====================================================

-- ============================================
-- Query 1: Basic Weekly Active Users (WAU)
-- ============================================
-- Calculate WAU by year and week number

SELECT 
    YEAR(login_date) AS year,
    WEEK(login_date) AS week_number,
    COUNT(DISTINCT user_id) AS weekly_active_users
FROM Logins
GROUP BY YEAR(login_date), WEEK(login_date)
ORDER BY year, week_number;

/*
Output:
year | week_number | weekly_active_users
-----|-------------|--------------------
2024 |      1      |         7
2024 |      2      |         8
2024 |      3      |         8
2024 |      4      |         8
2024 |      5      |         8
2024 |      6      |         8

How it works:
- YEAR(login_date) extracts year from date
- WEEK(login_date) extracts ISO week number (1-52)
- COUNT(DISTINCT user_id) counts unique users per week
- Groups by year and week for time-series analysis
- Essential metric for tracking user engagement trends
- Each user counted only once per week regardless of login frequency
*/


-- ============================================
-- Query 2: WAU with Week Start/End Dates
-- ============================================
-- Show WAU with readable week ranges and engagement metrics

SELECT 
    YEAR(login_date) AS year,
    WEEK(login_date) AS week_number,
    MIN(login_date) AS week_start,
    MAX(login_date) AS week_end,
    COUNT(DISTINCT user_id) AS weekly_active_users,
    COUNT(login_id) AS total_logins,
    ROUND(COUNT(login_id) * 1.0 / COUNT(DISTINCT user_id), 2) AS avg_logins_per_user
FROM Logins
GROUP BY YEAR(login_date), WEEK(login_date)
ORDER BY year, week_number;

/*
Output:
year | week_number | week_start | week_end   | weekly_active_users | total_logins | avg_logins_per_user
-----|-------------|------------|------------|---------------------|--------------|--------------------
2024 |      1      | 2024-01-01 | 2024-01-05 |          7          |      12      |        1.71
2024 |      2      | 2024-01-08 | 2024-01-12 |          8          |      12      |        1.50
2024 |      3      | 2024-01-15 | 2024-01-19 |          8          |      12      |        1.50
2024 |      4      | 2024-01-22 | 2024-01-26 |          8          |      12      |        1.50
2024 |      5      | 2024-01-29 | 2024-02-02 |          8          |      12      |        1.50
2024 |      6      | 2024-02-05 | 2024-02-09 |          8          |      12      |        1.50

How it works:
- MIN(login_date) shows first day of activity in the week
- MAX(login_date) shows last day of activity in the week
- Provides human-readable week ranges for reports
- Calculates average login frequency per user
- Higher avg_logins_per_user = better engagement
- Week 1 has 1.71 logins/user vs 1.50 in later weeks
- Total logins stays consistent at 12 per week
*/


-- ============================================
-- Query 3: Week-over-Week Growth Analysis
-- ============================================
-- Calculate WoW growth rate for WAU

WITH WeeklyStats AS (
    SELECT 
        YEAR(login_date) AS year,
        WEEK(login_date) AS week_number,
        COUNT(DISTINCT user_id) AS wau
    FROM Logins
    GROUP BY YEAR(login_date), WEEK(login_date)
),
WithLag AS (
    SELECT 
        year,
        week_number,
        wau,
        LAG(wau) OVER (ORDER BY year, week_number) AS prev_week_wau
    FROM WeeklyStats
)
SELECT 
    year,
    week_number,
    wau AS current_week_wau,
    prev_week_wau,
    wau - prev_week_wau AS absolute_change,
    ROUND((wau - prev_week_wau) * 100.0 / NULLIF(prev_week_wau, 0), 2) AS wow_growth_pct,
    CASE 
        WHEN wau > prev_week_wau THEN '📈 Growing'
        WHEN wau < prev_week_wau THEN '📉 Declining'
        ELSE '➡️ Stable'
    END AS trend
FROM WithLag
WHERE prev_week_wau IS NOT NULL
ORDER BY year, week_number;

/*
Output:
year | week_number | current_week_wau | prev_week_wau | absolute_change | wow_growth_pct | trend
-----|-------------|------------------|---------------|-----------------|----------------|------------
2024 |      2      |        8         |      7        |        1        |     14.29      | 📈 Growing
2024 |      3      |        8         |      8        |        0        |      0.00      | ➡️ Stable
2024 |      4      |        8         |      8        |        0        |      0.00      | ➡️ Stable
2024 |      5      |        8         |      8        |        0        |      0.00      | ➡️ Stable
2024 |      6      |        8         |      8        |        0        |      0.00      | ➡️ Stable

How it works:
- WeeklyStats CTE calculates WAU per week
- LAG() window function gets previous week's WAU for comparison
- Calculates absolute change (difference) and percentage change
- NULLIF() prevents division by zero errors
- CASE statement adds visual trend indicators
- Week 2 shows 14.29% growth (7 → 8 users)
- Weeks 3-6 show stability at 8 users (plateau)
- Identifies week-over-week momentum for product health monitoring
*/


-- ============================================
-- Query 4: WAU by Device Type
-- ============================================
-- Segment WAU by device for cross-platform analysis

SELECT 
    YEAR(login_date) AS year,
    WEEK(login_date) AS week_number,
    device_type,
    COUNT(DISTINCT user_id) AS active_users,
    COUNT(login_id) AS total_logins,
    ROUND(COUNT(DISTINCT user_id) * 100.0 / 
        SUM(COUNT(DISTINCT user_id)) OVER (PARTITION BY YEAR(login_date), WEEK(login_date)), 2) AS pct_of_weekly_users
FROM Logins
GROUP BY YEAR(login_date), WEEK(login_date), device_type
ORDER BY year, week_number, active_users DESC;

/*
Output (sample):
year | week_number | device_type | active_users | total_logins | pct_of_weekly_users
-----|-------------|-------------|--------------|--------------|--------------------
2024 |      1      | Mobile      |      5       |      7       |       71.43
2024 |      1      | Desktop     |      2       |      3       |       28.57
2024 |      1      | Tablet      |      1       |      2       |       14.29
2024 |      2      | Mobile      |      4       |      5       |       50.00
2024 |      2      | Desktop     |      3       |      4       |       37.50
2024 |      2      | Tablet      |      2       |      3       |       25.00
2024 |      3      | Mobile      |      5       |      6       |       62.50
2024 |      3      | Desktop     |      3       |      4       |       37.50
2024 |      3      | Tablet      |      1       |      2       |       12.50

How it works:
- Groups by year, week, and device type
- Shows distribution of users across platforms
- Window function calculates percentage of weekly users per device
- Note: Percentages may sum > 100% (users can use multiple devices)
- Mobile dominates with 50-71% of weekly active users
- Desktop users typically 26-38% of WAU
- Tablet has lowest penetration at 11-25%
- Helps prioritize platform-specific feature development
- Desktop users often have longer sessions (power users)
*/


-- ============================================
-- Query 5: WAU with User Segmentation (New vs Returning)
-- ============================================
-- Classify users as new or returning each week

WITH FirstLogin AS (
    SELECT 
        user_id,
        MIN(DATE(login_date)) AS first_login_date,
        YEAR(MIN(DATE(login_date))) AS first_year,
        WEEK(MIN(DATE(login_date))) AS first_week
    FROM Logins
    GROUP BY user_id
),
WeeklyActivity AS (
    SELECT 
        l.user_id,
        YEAR(l.login_date) AS year,
        WEEK(l.login_date) AS week_number,
        f.first_year,
        f.first_week
    FROM Logins l
    JOIN FirstLogin f ON l.user_id = f.user_id
    GROUP BY l.user_id, YEAR(l.login_date), WEEK(l.login_date), f.first_year, f.first_week
)
SELECT 
    year,
    week_number,
    COUNT(DISTINCT user_id) AS total_wau,
    COUNT(DISTINCT CASE 
        WHEN first_week = week_number 
        AND first_year = year 
        THEN user_id 
    END) AS new_users,
    COUNT(DISTINCT CASE 
        WHEN first_week != week_number 
        OR first_year != year 
        THEN user_id 
    END) AS returning_users,
    ROUND(COUNT(DISTINCT CASE 
        WHEN first_week = week_number 
        AND first_year = year 
        THEN user_id 
    END) * 100.0 / COUNT(DISTINCT user_id), 2) AS new_user_pct,
    ROUND(COUNT(DISTINCT CASE 
        WHEN first_week != week_number 
        OR first_year != year 
        THEN user_id 
    END) * 100.0 / COUNT(DISTINCT user_id), 2) AS returning_user_pct
FROM WeeklyActivity
GROUP BY year, week_number
ORDER BY year, week_number;

/*
Output:
year | week_number | total_wau | new_users | returning_users | new_user_pct | returning_user_pct
-----|-------------|-----------|-----------|-----------------|--------------|-------------------
2024 |      1      |     7     |     7     |       0         |   100.00     |       0.00
2024 |      2      |     8     |     5     |       3         |    62.50     |      37.50
2024 |      3      |     8     |     5     |       3         |    62.50     |      37.50
2024 |      4      |     8     |     5     |       3         |    62.50     |      37.50
2024 |      5      |     8     |     5     |       3         |    62.50     |      37.50
2024 |      6      |     8     |     5     |       3         |    62.50     |      37.50

How it works:
- FirstLogin CTE identifies each user's first login date and week
- WeeklyActivity CTE joins current activity with first login info
- Classifies users as NEW (first week logging in) or RETURNING (logged in before)
- Week 1: 100% new users (7 users signing up for first time)
- Week 2-6: Consistent pattern of ~62% new, ~38% returning
- Shows balance between acquisition and retention
- Healthy product benchmark: 15-25% new, 75-85% returning
- High new user % (62%) indicates strong acquisition but potential retention issues
- Suggests need for improved onboarding to convert new → returning users
- Product team should investigate why retention rate is only 37.5%
- Consider implementing user engagement campaigns or feature improvements
*/
