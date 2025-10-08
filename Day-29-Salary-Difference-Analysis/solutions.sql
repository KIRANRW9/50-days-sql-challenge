-- Query 1: Basic Salary Difference by Department
SELECT 
    department_id, 
    MAX(salary) - MIN(salary) AS salary_diff 
FROM Employee 
GROUP BY department_id
ORDER BY salary_diff DESC;


-- Query 2: Detailed Salary Range Analysis by Department
SELECT 
    department_id,
    department_name,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    MAX(salary) - MIN(salary) AS salary_difference,
    ROUND(AVG(salary), 2) AS avg_salary,
    ROUND((MAX(salary) - MIN(salary)) * 100.0 / MIN(salary), 2) AS salary_range_percent
FROM Employee 
GROUP BY department_id, department_name
ORDER BY salary_difference DESC;


-- Query 3: Salary Gap Analysis with Position Details
SELECT 
    e.department_id,
    e.department_name,
    e.employee_name,
    e.position,
    e.salary,
    CASE 
        WHEN e.salary = dept_stats.min_salary THEN 'Lowest Paid'
        WHEN e.salary = dept_stats.max_salary THEN 'Highest Paid'
        ELSE 'Mid-Range'
    END AS salary_position,
    dept_stats.salary_difference AS dept_salary_range
FROM Employee e
JOIN (
    SELECT 
        department_id,
        MIN(salary) AS min_salary,
        MAX(salary) AS max_salary,
        MAX(salary) - MIN(salary) AS salary_difference
    FROM Employee
    GROUP BY department_id
) dept_stats ON e.department_id = dept_stats.department_id
WHERE e.salary = dept_stats.min_salary OR e.salary = dept_stats.max_salary
ORDER BY e.department_id, e.salary DESC;


-- Query 4: Salary Quartile Distribution by Department
SELECT 
    department_id,
    department_name,
    COUNT(*) AS total_employees,
    MIN(salary) AS min_salary,
    ROUND(PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary), 2) AS q1_salary,
    ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY salary), 2) AS median_salary,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary), 2) AS q3_salary,
    MAX(salary) AS max_salary,
    MAX(salary) - MIN(salary) AS total_range,
    ROUND(PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY salary) - 
          PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY salary), 2) AS iqr
FROM Employee
GROUP BY department_id, department_name
ORDER BY total_range DESC;


-- Query 5: Salary Compression Analysis
SELECT 
    department_id,
    department_name,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    MAX(salary) - MIN(salary) AS salary_range,
    ROUND(AVG(salary), 2) AS avg_salary,
    ROUND((MAX(salary) - MIN(salary)) / COUNT(*), 2) AS avg_increment_per_level,
    CASE 
        WHEN (MAX(salary) - MIN(salary)) < 30000 THEN 'High Compression Risk'
        WHEN (MAX(salary) - MIN(salary)) < 40000 THEN 'Moderate Compression'
        ELSE 'Healthy Range'
    END AS compression_status
FROM Employee
GROUP BY department_id, department_name
ORDER BY salary_range;
