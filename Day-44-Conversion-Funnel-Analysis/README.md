# Day 44: Conversion Funnel Analysis

## Problem
The marketing and product teams need to analyze user conversion rates across different stages of the customer journey to identify bottlenecks, optimize user experience, and improve overall conversion. Understanding where users drop off in the funnel helps prioritize optimization efforts and measure the effectiveness of marketing campaigns and product changes.

## Dataset
User interaction data tracking their progression through key funnel stages (visits, sign-ups, purchases) to measure conversion rates and identify opportunities for improvement.

## SQL Solution

### Table Structure

```sql
-- Create Funnel table
CREATE TABLE Funnel (
    user_id INT NOT NULL,
    stage VARCHAR(50) NOT NULL,
    timestamp DATETIME NOT NULL,
    PRIMARY KEY (user_id, stage)
);
```

---

## Query 1: Basic Funnel Counts

**Retrieve total counts at each funnel stage**

```sql
SELECT 
    SUM(CASE WHEN stage = 'visit' THEN 1 ELSE 0 END) AS visits,
    SUM(CASE WHEN stage = 'sign_up' THEN 1 ELSE 0 END) AS sign_ups,
    SUM(CASE WHEN stage = 'purchase' THEN 1 ELSE 0 END) AS purchases
FROM Funnel;
```

**Output:**
```
visits | sign_ups | purchases
-------|----------|----------
  20   |    7     |    5
```

**How it works:**
- `SUM(CASE WHEN...)` performs conditional aggregation
- Counts events at each specific funnel stage
- Single query retrieves all stage counts efficiently
- CASE returns 1 for matches, 0 otherwise

---

## Query 2: Funnel with Conversion Rates

**Calculate conversion rates between consecutive funnel stages**

```sql
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
```

**Output:**
```
visits | sign_ups | purchases | visit_to_signup_rate | signup_to_purchase_rate | visit_to_purchase_rate
-------|----------|-----------|----------------------|-------------------------|------------------------
  20   |    7     |    5      |       35.00          |         71.43           |         25.00
```

**How it works:**
- Subquery calculates stage counts
- Outer query computes conversion percentages
- `* 100.0` ensures decimal division (avoids integer truncation)
- `ROUND(..., 2)` formats to 2 decimal places
- Shows stage-to-stage conversion and overall funnel efficiency

---

## Query 3: Unique User Funnel Analysis

**Count distinct users at each stage (not total events)**

```sql
SELECT 
    COUNT(DISTINCT CASE WHEN stage = 'visit' THEN user_id END) AS unique_visitors,
    COUNT(DISTINCT CASE WHEN stage = 'sign_up' THEN user_id END) AS unique_signups,
    COUNT(DISTINCT CASE WHEN stage = 'purchase' THEN user_id END) AS unique_purchases,
    ROUND(
        COUNT(DISTINCT CASE WHEN stage = 'sign_up' THEN user_id END) * 100.0 / 
        COUNT(DISTINCT CASE WHEN stage = 'visit' THEN user_id END), 
        2
    ) AS visitor_signup_conversion_rate,
    ROUND(
        COUNT(DISTINCT CASE WHEN stage = 'purchase' THEN user_id END) * 100.0 / 
        COUNT(DISTINCT CASE WHEN stage = 'sign_up' THEN user_id END), 
        2
    ) AS signup_purchase_conversion_rate
FROM Funnel;
```

**Output:**
```
unique_visitors | unique_signups | unique_purchases | visitor_signup_conversion_rate | signup_purchase_conversion_rate
----------------|----------------|------------------|--------------------------------|--------------------------------
      20        |       7        |        5         |            35.00               |            71.43
```

**How it works:**
- `COUNT(DISTINCT user_id)` ensures each user counted once
- Prevents double-counting if users have multiple events per stage
- More accurate for user-level analysis
- Better reflects actual user behavior vs event counts

---

## Query 4: Daily Funnel Trends

**Analyze funnel performance by date**

```sql
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
```

**Output:**
```
funnel_date | visits | sign_ups | purchases | signup_conversion_rate | purchase_conversion_rate
------------|--------|----------|-----------|------------------------|-------------------------
2024-01-01  |   5    |    3     |     2     |        60.00           |         66.67
2024-01-02  |   6    |    2     |     1     |        33.33           |         50.00
2024-01-03  |   6    |    1     |     1     |        16.67           |        100.00
2024-01-04  |   3    |    1     |     1     |        33.33           |        100.00
```

**How it works:**
- `DATE(timestamp)` extracts date portion for grouping
- CTE calculates daily stage counts
- `NULLIF(visits, 0)` prevents division by zero (returns NULL instead)
- Shows daily conversion trends
- Identifies high/low performing days

---

## Query 5: Time Between Funnel Stages

**Measure how long users take to progress through funnel**

```sql
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
WHERE purchase_time IS NOT NULL  -- Only completed funnels
ORDER BY total_funnel_minutes;
```

**Output:**
```
user_id | visit_time          | signup_time         | purchase_time       | minutes_to_signup | minutes_to_purchase | total_funnel_minutes
--------|---------------------|---------------------|---------------------|-------------------|---------------------|---------------------
   11   | 2024-01-03 08:00:00 | 2024-01-03 08:02:00 | 2024-01-03 08:10:00 |        2          |          8          |         10
    1   | 2024-01-01 10:00:00 | 2024-01-01 10:05:00 | 2024-01-01 10:15:00 |        5          |         10          |         15
    4   | 2024-01-01 13:00:00 | 2024-01-01 13:05:00 | 2024-01-01 13:20:00 |        5          |         15          |         20
```

**How it works:**
- Pivots stages into columns per user
- `TIMESTAMPDIFF(MINUTE, start, end)` calculates time difference
- `WHERE purchase_time IS NOT NULL` filters for completed conversions
- Identifies fast vs slow converters
- Helps optimize user experience timing

---
