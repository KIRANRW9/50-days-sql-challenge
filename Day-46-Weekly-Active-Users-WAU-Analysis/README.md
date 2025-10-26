# Day 46: Weekly Active Users (WAU) Analysis

## Problem
The product and growth teams need to track Weekly Active Users (WAU) to measure user engagement, identify growth trends, and monitor product health. WAU is a critical metric for understanding user retention, identifying seasonal patterns, and making data-driven decisions about product features and marketing campaigns.

## Dataset
User login activity data with timestamps to calculate weekly active users, track engagement trends over time, and compare week-over-week performance across different time periods.

## SQL Solution

### Table Structure

```sql
-- Create Logins table
CREATE TABLE Logins (
    login_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    login_date DATE NOT NULL,
    login_time TIME,
    device_type VARCHAR(50),
    session_duration INT
);
```

---

## Query 1: Basic Weekly Active Users (WAU)

**Calculate WAU by year and week number**

```sql
SELECT 
    YEAR(login_date) AS year,
    WEEK(login_date) AS week_number,
    COUNT(DISTINCT user_id) AS weekly_active_users
FROM Logins
GROUP BY YEAR(login_date), WEEK(login_date)
ORDER BY year, week_number;
```

**Output:**
```
year | week_number | weekly_active_users
-----|-------------|--------------------
2024 |      1      |         45
2024 |      2      |         52
2024 |      3      |         48
2024 |      4      |         55
2024 |      5      |         58
2024 |      6      |         62
```

**How it works:**
- `YEAR(login_date)` extracts year from date
- `WEEK(login_date)` extracts ISO week number (1-52)
- `COUNT(DISTINCT user_id)` counts unique users per week
- Groups by year and week for time-series analysis
- Essential metric for tracking user engagement trends

---

## Query 2: WAU with Week Start/End Dates

**Show WAU with readable week ranges**

```sql
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
```

**Output:**
```
year | week_number | week_start | week_end   | weekly_active_users | total_logins | avg_logins_per_user
-----|-------------|------------|------------|---------------------|--------------|--------------------
2024 |      1      | 2024-01-01 | 2024-01-07 |         45          |      135     |        3.00
2024 |      2      | 2024-01-08 | 2024-01-14 |         52          |      168     |        3.23
2024 |      3      | 2024-01-15 | 2024-01-21 |         48          |      156     |        3.25
2024 |      4      | 2024-01-22 | 2024-01-28 |         55          |      187     |        3.40
2024 |      5      | 2024-01-29 | 2024-02-04 |         58          |      198     |        3.41
2024 |      6      | 2024-02-05 | 2024-02-11 |         62          |      217     |        3.50
```

**How it works:**
- `MIN(login_date)` shows first day of the week
- `MAX(login_date)` shows last day of the week
- Provides human-readable week ranges
- Calculates average session frequency per user
- Shows both unique users and total engagement

---

## Query 3: Week-over-Week Growth Analysis

**Calculate WoW growth rate for WAU**

```sql
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
```

**Output:**
```
year | week_number | current_week_wau | prev_week_wau | absolute_change | wow_growth_pct | trend
-----|-------------|------------------|---------------|-----------------|----------------|------------
2024 |      2      |        52        |      45       |        7        |     15.56      | 📈 Growing
2024 |      3      |        48        |      52       |       -4        |     -7.69      | 📉 Declining
2024 |      4      |        55        |      48       |        7        |     14.58      | 📈 Growing
2024 |      5      |        58        |      55       |        3        |      5.45      | 📈 Growing
2024 |      6      |        62        |      58       |        4        |      6.90      | 📈 Growing
```

**How it works:**
- `LAG()` gets previous week's WAU
- Calculates absolute and percentage change
- `NULLIF()` prevents division by zero
- Trend indicator shows growth direction
- Identifies week-over-week momentum

---

## Query 4: WAU by Device Type

**Segment WAU by device for cross-platform analysis**

```sql
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
```

**Output:**
```
year | week_number | device_type | active_users | total_logins | pct_of_weekly_users
-----|-------------|-------------|--------------|--------------|--------------------
2024 |      1      | Mobile      |      28      |      85      |       62.22
2024 |      1      | Desktop     |      12      |      35      |       26.67
2024 |      1      | Tablet      |       5      |      15      |       11.11
2024 |      2      | Mobile      |      32      |     102      |       61.54
2024 |      2      | Desktop     |      14      |      46      |       26.92
2024 |      2      | Tablet      |       6      |      20      |       11.54
```

**How it works:**
- Groups by week and device type
- Shows distribution across platforms
- Window function calculates percentage per week
- Mobile typically dominates (60%+)
- Helps prioritize platform-specific features

---

## Query 5: WAU with User Segmentation (New vs Returning)

**Classify users as new or returning each week**

```sql
WITH FirstLogin AS (
    SELECT 
        user_id,
        MIN(DATE(login_date)) AS first_login_date
    FROM Logins
    GROUP BY user_id
),
WeeklyActivity AS (
    SELECT 
        l.user_id,
        YEAR(l.login_date) AS year,
        WEEK(l.login_date) AS week_number,
        MIN(l.login_date) AS user_week_start,
        f.first_login_date
    FROM Logins l
    JOIN FirstLogin f ON l.user_id = f.user_id
    GROUP BY l.user_id, YEAR(l.login_date), WEEK(l.login_date), f.first_login_date
)
SELECT 
    year,
    week_number,
    COUNT(DISTINCT user_id) AS total_wau,
    COUNT(DISTINCT CASE 
        WHEN WEEK(first_login_date) = week_number 
        AND YEAR(first_login_date) = year 
        THEN user_id 
    END) AS new_users,
    COUNT(DISTINCT CASE 
        WHEN WEEK(first_login_date) != week_number 
        OR YEAR(first_login_date) != year 
        THEN user_id 
    END) AS returning_users,
    ROUND(COUNT(DISTINCT CASE 
        WHEN WEEK(first_login_date) = week_number 
        AND YEAR(first_login_date) = year 
        THEN user_id 
    END) * 100.0 / COUNT(DISTINCT user_id), 2) AS new_user_pct,
    ROUND(COUNT(DISTINCT CASE 
        WHEN WEEK(first_login_date) != week_number 
        OR YEAR(first_login_date) != year 
        THEN user_id 
    END) * 100.0 / COUNT(DISTINCT user_id), 2) AS returning_user_pct
FROM WeeklyActivity
GROUP BY year, week_number
ORDER BY year, week_number;
```

**Output:**
```
year | week_number | total_wau | new_users | returning_users | new_user_pct | returning_user_pct
-----|-------------|-----------|-----------|-----------------|--------------|-------------------
2024 |      1      |     45    |    15     |       30        |    33.33     |       66.67
2024 |      2      |     52    |    12     |       40        |    23.08     |       76.92
2024 |      3      |     48    |     8     |       40        |    16.67     |       83.33
2024 |      4      |     55    |    10     |       45        |    18.18     |       81.82
2024 |      5      |     58    |     9     |       49        |    15.52     |       84.48
2024 |      6      |     62    |    11     |       51        |    17.74     |       82.26
```

**How it works:**
- Identifies each user's first login date
- Classifies users as new (first week) or returning
- Shows acquisition vs retention balance
- Healthy products: 15-25% new, 75-85% returning
- Critical for growth vs retention strategy

---
