-- Day 15: Weekend Hiring Analysis with Date Functions (DAYNAME and WEEKDAY Functions)
-- Solutions SQL File

-- Query Solutions

-- Query 1: Find All Employees Hired on Weekends 
-- Find employees hired on Saturday or Sunday 
SELECT * 
FROM Employees 
WHERE DAYNAME(hire_date) IN ('Saturday', 'Sunday')
ORDER BY hire_date;

-- Query 2: Weekend vs Weekday Hiring Analysis 
-- Compare weekend vs weekday hiring patterns
SELECT 
    CASE 
        WHEN DAYNAME(hire_date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END as hiring_period,
    COUNT(*) as total_hires,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(hire_date) as earliest_hire,
    MAX(hire_date) as latest_hire
FROM Employees
GROUP BY 
    CASE 
        WHEN DAYNAME(hire_date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY hiring_period;

-- Query 3: Weekend Hiring by Department Analysis 
-- Analyze which departments hire on weekends most frequently
SELECT 
    department,
    COUNT(*) as weekend_hires,
    ROUND(AVG(salary), 2) as avg_weekend_salary,
    GROUP_CONCAT(DISTINCT employment_type ORDER BY employment_type) as employment_types,
    MIN(hire_date) as first_weekend_hire,
    MAX(hire_date) as last_weekend_hire
FROM Employees
WHERE DAYNAME(hire_date) IN ('Saturday', 'Sunday')
GROUP BY department
ORDER BY weekend_hires DESC, avg_weekend_salary DESC;

-- Query 4: Day-wise Hiring Distribution 
-- Get complete day-wise hiring breakdown
SELECT 
    DAYNAME(hire_date) as day_name,
    DAYOFWEEK(hire_date) as day_number,
    COUNT(*) as hires_count,
    ROUND(AVG(salary), 2) as avg_salary,
    CASE 
        WHEN DAYNAME(hire_date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END as day_type
FROM Employees
GROUP BY DAYNAME(hire_date), DAYOFWEEK(hire_date)
ORDER BY day_number;

-- Query 5: Recent Weekend Hires with Employment Type 
-- Find recent weekend hires and their employment patterns
SELECT 
    employee_name,
    department,
    position,
    salary,
    hire_date,
    DAYNAME(hire_date) as hired_day,
    employment_type,
    region,
    CASE 
        WHEN employment_type = 'Contract' THEN 'Temporary'
        WHEN employment_type = 'Part-time' THEN 'Flexible'
        ELSE 'Regular'
    END as hire_category,
    DATEDIFF(CURDATE(), hire_date) as days_since_hire
FROM Employees
WHERE DAYNAME(hire_date) IN ('Saturday', 'Sunday')
    AND hire_date >= '2024-01-01'
ORDER BY hire_date DESC, salary DESC;

ORDER BY hire_date;
*/
