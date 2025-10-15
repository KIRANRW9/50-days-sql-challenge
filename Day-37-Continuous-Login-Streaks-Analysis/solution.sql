-- Query 1 - Find Users with 3+ Day Login Streaks
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
    DATEDIFF(MAX(login_date), MIN(login_date)) + 1 AS days_in_streak
FROM cte 
GROUP BY user_id, grp 
HAVING COUNT(*) >= 3
ORDER BY streak_length DESC, user_id;

-- Query 2 - User Engagement Summary with Streak Details
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
    COUNT(us.streak_length) AS total_streaks,
    MAX(us.streak_length) AS longest_streak,
    ROUND(AVG(us.streak_length), 1) AS avg_streak_length,
    MIN(us.streak_start) AS first_streak_start,
    MAX(us.streak_end) AS last_streak_end,
    SUM(us.streak_length) AS total_streak_days
FROM Users u
JOIN user_streaks us ON u.user_id = us.user_id
GROUP BY u.user_id, u.username, u.user_tier
ORDER BY longest_streak DESC;

-- Query 3 - Streak Categorization and Engagement Levels
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
        MAX(streak_length) AS max_streak
    FROM user_streaks
    GROUP BY user_id
)
SELECT 
    u.user_id,
    u.username,
    u.user_tier,
    COALESCE(ums.max_streak, 0) AS longest_streak,
    CASE 
        WHEN ums.max_streak >= 10 THEN 'Super Engaged (10+ days)'
        WHEN ums.max_streak >= 7 THEN 'Highly Engaged (7-9 days)'
        WHEN ums.max_streak >= 5 THEN 'Well Engaged (5-6 days)'
        WHEN ums.max_streak >= 3 THEN 'Moderately Engaged (3-4 days)'
        ELSE 'Low Engagement (<3 days)'
    END AS engagement_level,
    COUNT(l.login_id) AS total_logins
FROM Users u
LEFT JOIN user_max_streaks ums ON u.user_id = ums.user_id
LEFT JOIN Logins l ON u.user_id = l.user_id
GROUP BY u.user_id, u.username, u.user_tier, ums.max_streak
ORDER BY COALESCE(ums.max_streak, 0) DESC;

-- Query 4 - Active Streak Identification (Current Streaks)
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
    DATEDIFF(CURDATE(), s.streak_end) AS days_since_streak_end,
    CASE 
        WHEN DATEDIFF(CURDATE(), s.streak_end) = 0 THEN 'Active Today'
        WHEN DATEDIFF(CURDATE(), s.streak_end) = 1 THEN 'At Risk (1 day gap)'
        WHEN DATEDIFF(CURDATE(), s.streak_end) <= 3 THEN 'Recently Broken'
        ELSE 'Inactive'
    END AS streak_status
FROM Users u
JOIN all_streaks s ON u.user_id = s.user_id
WHERE s.streak_length >= 3
  AND s.streak_end = (
        SELECT MAX(streak_end) 
        FROM all_streaks s2 
        WHERE s2.user_id = s.user_id AND s2.streak_length >= 3
    )
ORDER BY s.streak_end DESC;

-- Query 5 - Platform-wise Streak Analysis
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
        COUNT(*) AS platform_logins
    FROM user_streaks us
    JOIN Logins l ON us.user_id = l.user_id 
        AND l.login_date BETWEEN us.streak_start AND us.streak_end
    GROUP BY us.user_id, us.streak_start, us.streak_end, us.streak_length, l.platform
)
SELECT 
    platform,
    COUNT(DISTINCT user_id) AS users_with_streaks,
    COUNT(*) AS total_streak_instances,
    ROUND(AVG(streak_length), 1) AS avg_streak_length,
    MAX(streak_length) AS max_streak_length,
    SUM(platform_logins) AS total_logins_in_streaks
FROM streak_platforms
GROUP BY platform
ORDER BY avg_streak_length DESC;
