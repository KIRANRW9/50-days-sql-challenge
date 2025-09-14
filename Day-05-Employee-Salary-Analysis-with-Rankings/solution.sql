-- Day 05: Employee Salary Analysis with Rankings - Solutions

-- Solution 1: Top 3 Highest Paid Employees
-- Get the top 3 employees by salary across all departments
SELECT 
    employee_name,
    department,
    position,
    salary
FROM Employees
ORDER BY salary DESC
LIMIT 3;

-- Solution 2: Salary Rankings by Department  
-- Rank employees within each department by salary using window functions
SELECT 
    employee_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as rank,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dense_rank,
    ROW_NUMBER() OVER (PARTITION BY department ORDER BY salary DESC) as row_num
FROM Employees
ORDER BY department, salary DESC;

-- Solution 3: Department Salary Statistics
-- Calculate comprehensive salary statistics for each department
SELECT 
    department,
    COUNT(*) as employee_count,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    ROUND(AVG(salary), 2) as avg_salary,
    SUM(salary) as total_salary
FROM Employees
GROUP BY department
ORDER BY total_salary DESC;

-- Solution 4: Employees Above Department Average
-- Find employees earning above their department's average salary
SELECT 
    e.employee_name,
    e.department,
    e.salary,
    ROUND(dept_avg.avg_salary, 2) as dept_avg_salary,
    ROUND(e.salary - dept_avg.avg_salary, 2) as difference
FROM Employees e
JOIN (
    SELECT 
        department, 
        AVG(salary) as avg_salary 
    FROM Employees 
    GROUP BY department
) dept_avg ON e.department = dept_avg.department
WHERE e.salary > dept_avg.avg_salary
ORDER BY difference DESC;

-- Solution 5: Salary Percentiles and Quartiles
-- Calculate salary quartiles and percentile rankings
SELECT 
    employee_name,
    department,
    salary,
    NTILE(4) OVER (ORDER BY salary) as salary_quartile,
    NTILE(10) OVER (ORDER BY salary) as salary_decile,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary) * 100, 2) as percentile_rank
FROM Employees
ORDER BY salary DESC;
