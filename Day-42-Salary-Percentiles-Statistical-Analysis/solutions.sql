
-- Query 1: Calculate 25th, 50th, and 75th Percentiles
WITH percentile_calc AS (
    SELECT 
        salary,
        NTILE(4) OVER (ORDER BY salary) as quartile
    FROM Employees
)
SELECT 
    MAX(CASE WHEN quartile = 1 THEN salary END) as p25_salary,
    MAX(CASE WHEN quartile = 2 THEN salary END) as p50_salary,
    MAX(CASE WHEN quartile = 3 THEN salary END) as p75_salary
FROM percentile_calc;

-- Query 2: Detailed Percentile Analysis with Employee Distribution
SELECT 
    employee_name,
    department,
    position,
    salary,
    experience_years,
    NTILE(4) OVER (ORDER BY salary) as salary_quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY salary) = 1 THEN '0-25th Percentile (Bottom Quarter)'
        WHEN NTILE(4) OVER (ORDER BY salary) = 2 THEN '25th-50th Percentile (Lower Middle)'
        WHEN NTILE(4) OVER (ORDER BY salary) = 3 THEN '50th-75th Percentile (Upper Middle)'
        ELSE '75th-100th Percentile (Top Quarter)'
    END as percentile_range
FROM Employees
ORDER BY salary;

-- Query 3: Department-wise Percentile Analysis
SELECT 
    department,
    COUNT(*) as employee_count,
    MIN(salary) as min_salary,
    MAX(CASE WHEN quartile = 1 THEN salary END) as p25,
    MAX(CASE WHEN quartile = 2 THEN salary END) as p50_median,
    MAX(CASE WHEN quartile = 3 THEN salary END) as p75,
    MAX(salary) as max_salary,
    ROUND(AVG(salary), 2) as avg_salary
FROM (
    SELECT 
        department,
        salary,
        NTILE(4) OVER (PARTITION BY department ORDER BY salary) as quartile
    FROM Employees
) dept_percentiles
GROUP BY department
ORDER BY avg_salary DESC;

-- Query 4: Salary Band Classification
WITH percentile_ranges AS (
    SELECT 
        employee_id,
        employee_name,
        department,
        salary,
        NTILE(100) OVER (ORDER BY salary) as percentile_rank
    FROM Employees
)
SELECT 
    employee_name,
    department,
    salary,
    percentile_rank,
    CASE 
        WHEN percentile_rank <= 25 THEN 'Entry Level Band'
        WHEN percentile_rank <= 50 THEN 'Mid Level Band'
        WHEN percentile_rank <= 75 THEN 'Senior Level Band'
        ELSE 'Leadership Band'
    END as salary_band,
    CASE 
        WHEN percentile_rank <= 25 THEN 'Below Market'
        WHEN percentile_rank <= 75 THEN 'Market Rate'
        ELSE 'Above Market'
    END as market_position
FROM percentile_ranges
ORDER BY salary DESC;

-- Query 5: Outlier Detection using IQR Method
WITH quartiles AS (
    SELECT 
        MAX(CASE WHEN quartile = 1 THEN salary END) as Q1,
        MAX(CASE WHEN quartile = 3 THEN salary END) as Q3
    FROM (
        SELECT 
            salary,
            NTILE(4) OVER (ORDER BY salary) as quartile
        FROM Employees
    ) q
),
iqr_calc AS (
    SELECT 
        Q1,
        Q3,
        (Q3 - Q1) as IQR,
        Q1 - 1.5 * (Q3 - Q1) as lower_bound,
        Q3 + 1.5 * (Q3 - Q1) as upper_bound
    FROM quartiles
)
SELECT 
    e.employee_name,
    e.department,
    e.position,
    e.salary,
    i.Q1,
    i.Q3,
    i.IQR,
    i.lower_bound,
    i.upper_bound,
    CASE 
        WHEN e.salary < i.lower_bound THEN 'Low Outlier'
        WHEN e.salary > i.upper_bound THEN 'High Outlier'
        ELSE 'Normal Range'
    END as outlier_status
FROM Employees e
CROSS JOIN iqr_calc i
WHERE e.salary < i.lower_bound OR e.salary > i.upper_bound
ORDER BY e.salary DESC;
