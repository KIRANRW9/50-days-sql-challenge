# Day 37: Continuous Login Streaks Analysis (User Engagement & Gamification)

## Problem
The product and engagement teams need to identify users with continuous login streaks to understand user engagement, design gamification features, and reward loyal users. Login streaks are powerful indicators of user habit formation and platform stickiness. This problem tests understanding of window functions, date arithmetic, streak detection algorithms, and behavioral analytics.

## Dataset
User login data with daily login timestamps to demonstrate continuous engagement patterns and streak identification techniques.



## Query 1: Find Users with 3+ Day Login Streaks 

```sql
-- Identify continuous login streaks of 3 or more days (MySQL version)
WITH cte AS (
    SELECT 
        user_id, 
        login_date,
        DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) DAY) AS grp
    FROM Logins
)
SELECT 
    user_id, 
    MIN(login_date) AS streak_start, 
    MAX(login_date) AS streak_end, 
    COUNT(*) AS streak_length,
    DATEDIFF(MAX(login_date), MIN(login_date)) + 1 as days_in_streak
FROM cte 
GROUP BY user_id, grp 
HAVING COUNT(*) >= 3
ORDER BY streak_length DESC, user_id;
```

## Output:

```
user_id | streak_start | streak_end | streak_length | days_in_streak
--------|--------------|------------|---------------|---------------
1003    | 2024-02-01   | 2024-02-10 | 10            | 10
1001    | 2024-01-01   | 2024-01-07 | 7             | 7
1001    | 2024-01-10   | 2024-01-14 | 5             | 5
1002    | 2024-01-15   | 2024-01-18 | 4             | 4
1004    | 2024-01-20   | 2024-01-22 | 3             | 3
```

## Query 2: User Engagement Summary with Streak Details 

```sql
-- Analyze user engagement with complete streak information
WITH streak_detection AS (
    SELECT 
        user_id, 
        login_date,
        DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) DAY) AS grp
    FROM Logins
),
user_streaks AS (
    SELECT 
        user_id, 
        MIN(login_date) AS streak_start, 
        MAX(login_date) AS streak_end, 
        COUNT(*) AS streak_length
    FROM streak_detection
    GROUP BY user_id, grp 
    HAVING COUNT(*) >= 3
)
SELECT 
    u.user_id,
    u.username,
    u.user_tier,
    COUNT(us.streak_length) as total_streaks,
    MAX(us.streak_length) as longest_streak,
    ROUND(AVG(us.streak_length), 1) as avg_streak_length,
    MIN(us.streak_start) as first_streak_start,
    MAX(us.streak_end) as last_streak_end,
    SUM(us.streak_length) as total_streak_days
FROM Users u
JOIN user_streaks us ON u.user_id = us.user_id
GROUP BY u.user_id, u.username, u.user_tier
ORDER BY longest_streak DESC;
```

## Output:

```
user_id | username      | user_tier | total_streaks | longest_streak | avg_streak_length | first_streak_start | last_streak_end | total_streak_days
--------|---------------|-----------|---------------|----------------|-------------------|-------------------|-----------------|------------------
1003    | amit_patel    | Silver    | 1             | 10             | 10.0              | 2024-02-01        | 2024-02-10      | 10
1001    | rajesh_kumar  | Premium   | 2             | 7              | 6.0               | 2024-01-01        | 2024-01-14      | 12
1002    | priya_sharma  | Gold      | 1             | 4              | 4.0               | 2024-01-15        | 2024-01-18      | 4
1004    | sneha_reddy   | Premium   | 1             | 3              | 3.0               | 2024-01-20        | 2024-01-22      | 3
```

## Query 3: Streak Categorization and Engagement Levels 

```sql
-- Categorize users by their streak engagement levels
WITH streak_detection AS (
    SELECT 
        user_id, 
        login_date,
        DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) DAY) AS grp
    FROM Logins
),
user_streaks AS (
    SELECT 
        user_id, 
        COUNT(*) AS streak_length
    FROM streak_detection
    GROUP BY user_id, grp 
    HAVING COUNT(*) >= 3
),
user_max_streaks AS (
    SELECT 
        user_id,
        MAX(streak_length) as max_streak
    FROM user_streaks
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.username,
    u.user_tier,
    COALESCE(ums.max_streak, 0) as longest_streak,
    CASE 
        WHEN ums.max_streak >= 10 THEN 'Super Engaged (10+ days)'
        WHEN ums.max_streak >= 7 THEN 'Highly Engaged (7-9 days)'
        WHEN ums.max_streak >= 5 THEN 'Well Engaged (5-6 days)'
        WHEN ums.max_streak >= 3 THEN 'Moderately Engaged (3-4 days)'
        ELSE 'Low Engagement (<3 days)'
    END as engagement_level,
    COUNT(l.login_id) as total_logins
FROM Users u
LEFT JOIN user_max_streaks ums ON u.user_id = ums.user_id
LEFT JOIN Logins l ON u.user_id = l.user_id
GROUP BY u.user_id, u.username, u.user_tier, ums.max_streak
ORDER BY COALESCE(ums.max_streak, 0) DESC;
```

## Output:

```
user_id | username      | user_tier | longest_streak | engagement_level           | total_logins
--------|---------------|-----------|----------------|---------------------------|-------------
1003    | amit_patel    | Silver    | 10             | Super Engaged (10+ days)   | 10
1001    | rajesh_kumar  | Premium   | 7              | Highly Engaged (7-9 days)  | 12
1002    | priya_sharma  | Gold      | 4              | Moderately Engaged (3-4 days)| 5
1004    | sneha_reddy   | Premium   | 3              | Moderately Engaged (3-4 days)| 4
1005    | vikram_singh  | Gold      | 0              | Low Engagement (<3 days)   | 4
```

## Query 4: Active Streak Identification (Current Streaks) 

```sql
-- Identify users with currently active streaks
WITH streak_detection AS (
    SELECT 
        user_id, 
        login_date,
        DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) DAY) AS grp
    FROM Logins
),
all_streaks AS (
    SELECT 
        user_id, 
        MIN(login_date) AS streak_start, 
        MAX(login_date) AS streak_end, 
        COUNT(*) AS streak_length
    FROM streak_detection
    GROUP BY user_id, grp
)
SELECT 
    u.user_id,
    u.username,
    s.streak_start,
    s.streak_end,
    s.streak_length,
    DATEDIFF(CURDATE(), s.streak_end) as days_since_streak_end,
    CASE 
        WHEN DATEDIFF(CURDATE(), s.streak_end) = 0 THEN 'Active Today'
        WHEN DATEDIFF(CURDATE(), s.streak_end) = 1 THEN 'At Risk (1 day gap)'
        WHEN DATEDIFF(CURDATE(), s.streak_end) <= 3 THEN 'Recently Broken'
        ELSE 'Inactive'
    END as streak_status
FROM Users u
JOIN all_streaks s ON u.user_id = s.user_id
WHERE s.streak_length >= 3
    AND s.streak_end = (
        SELECT MAX(streak_end) 
        FROM all_streaks s2 
        WHERE s2.user_id = s.user_id AND s2.streak_length >= 3
    )
ORDER BY s.streak_end DESC;
```

## Output:

```
user_id | username      | streak_start | streak_end | streak_length | days_since_streak_end | streak_status
--------|---------------|--------------|------------|---------------|----------------------|------------------
1003    | amit_patel    | 2024-02-01   | 2024-02-10 | 10            | 278                  | Inactive
1004    | sneha_reddy   | 2024-01-20   | 2024-01-22 | 3             | 297                  | Inactive
1002    | priya_sharma  | 2024-01-15   | 2024-01-18 | 4             | 301                  | Inactive
1001    | rajesh_kumar  | 2024-01-10   | 2024-01-14 | 5             | 304                  | Inactive
```

## Query 5: Platform-wise Streak Analysis 

```sql
-- Analyze which platforms drive longer streaks
WITH streak_detection AS (
    SELECT 
        user_id, 
        login_date,
        DATE_SUB(login_date, INTERVAL ROW_NUMBER() OVER (PARTITION BY user_id ORDER BY login_date) DAY) AS grp
    FROM Logins
),
user_streaks AS (
    SELECT 
        user_id, 
        MIN(login_date) AS streak_start, 
        MAX(login_date) AS streak_end, 
        COUNT(*) AS streak_length
    FROM streak_detection
    GROUP BY user_id, grp 
    HAVING COUNT(*) >= 3
),
streak_platforms AS (
    SELECT 
        us.user_id,
        us.streak_start,
        us.streak_end,
        us.streak_length,
        l.platform,
        COUNT(*) as platform_logins
    FROM user_streaks us
    JOIN Logins l ON us.user_id = l.user_id 
        AND l.login_date BETWEEN us.streak_start AND us.streak_end
    GROUP BY us.user_id, us.streak_start, us.streak_end, us.streak_length, l.platform
)
SELECT 
    platform,
    COUNT(DISTINCT user_id) as users_with_streaks,
    COUNT(*) as total_streak_instances,
    ROUND(AVG(streak_length), 1) as avg_streak_length,
    MAX(streak_length) as max_streak_length,
    SUM(platform_logins) as total_logins_in_streaks
FROM streak_platforms
GROUP BY platform
ORDER BY avg_streak_length DESC;
```

## Output:

```
platform | users_with_streaks | total_streak_instances | avg_streak_length | max_streak_length | total_logins_in_streaks
---------|-------------------|------------------------|-------------------|-------------------|------------------------
Mobile   | 4                 | 5                      | 6.8               | 10                | 27
Web      | 3                 | 4                      | 5.5               | 7                 | 15
```

## How It Works
* **Streak Detection Algorithm**: Subtract ROW_NUMBER from date to create constant value for consecutive dates
* **ROW_NUMBER() OVER**: Assigns sequential numbers within user partitions
* **Date Arithmetic**: Consecutive dates minus sequential numbers = same date (group identifier)
* **GROUP BY with grp**: Groups consecutive login dates together
* **HAVING COUNT() >= 3**: Filters only streaks of 3+ days
* **Window Functions**: Enable row-by-row analysis without self-joins
* **Engagement Scoring**: Business logic to categorize user behavior

## Real World Use Cases
1. **Gamification**: Reward users for maintaining login streaks
2. **User Retention**: Identify and engage users whose streaks are breaking
3. **Push Notifications**: Send reminders to maintain streaks
4. **Premium Features**: Unlock features based on streak milestones
5. **Analytics Dashboard**: Track overall platform engagement trends
6. **Churn Prevention**: Alert when high-value users break long streaks

## Key Learning
**Streak Detection Pattern** using DATE_SUB and ROW_NUMBER is a classic algorithm interview question. Understanding that consecutive dates minus sequential numbers produces constant values is key to identifying continuous patterns.

**Window Functions with PARTITION BY** enable per-user analysis without complex self-joins. This pattern applies to many behavioral analytics use cases beyond login streaks.

**Engagement Metrics** transform raw behavioral data into actionable business insights. Categorizing users by streak length enables targeted retention strategies and gamification features.
