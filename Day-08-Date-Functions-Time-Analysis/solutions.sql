-- Day 08: Date Functions and Time-Based Analysis - Solutions

-- Solution 1: Employees Who Joined in 2023 (Basic YEAR function)
-- Retrieve all employees who joined in 2023
SELECT * 
FROM Employees 
WHERE YEAR(hire_date) = 2023;

-- Solution 2: Alternative Date Range Filtering
-- Same result using date range (shows multiple approaches)
SELECT employee_name, department, position, hire_date, salary
FROM Employees 
WHERE hire_date >= '2023-01-01' 
  AND hire_date <= '2023-12-31'
ORDER BY hire_date;

-- Solution 3: Using BETWEEN for Date Range
-- Another alternative using BETWEEN operator
SELECT employee_name, department, hire_date, salary
FROM Employees 
WHERE hire_date BETWEEN '2023-01-01' AND '2023-12-31'
ORDER BY department, hire_date;

-- Solution 4: Monthly Hiring Analysis
-- Analyze hiring patterns by month in 2023
SELECT 
    MONTH(hire_date) as hire_month,
    MONTHNAME(hire_date) as month_name,
    COUNT(*) as employees_hired,
    ROUND(AVG(salary), 2) as avg_salary_hired,
    SUM(salary) as total_salary_cost
FROM Employees 
WHERE YEAR(hire_date) = 2023
GROUP BY MONTH(hire_date), MONTHNAME(hire_date)
ORDER BY hire_month;

-- Solution 5: Employee Tenure Calculation
-- Calculate employee tenure and experience levels
SELECT 
    employee_name,
    department,
    hire_date,
    DATEDIFF(CURDATE(), hire_date) as days_employed,
    ROUND(DATEDIFF(CURDATE(), hire_date) / 365.25, 1) as years_employed,
    CASE 
        WHEN DATEDIFF(CURDATE(), hire_date) / 365.25 >= 3 THEN 'Senior'
        WHEN DATEDIFF(CURDATE(), hire_date) / 365.25 >= 1 THEN 'Mid-Level'
        ELSE 'Junior'
    END as experience_level
FROM Employees 
WHERE YEAR(hire_date) = 2023
ORDER BY hire_date;

-- Solution 6: Yearly Hiring Comparison
-- Compare hiring across different years
SELECT 
    YEAR(hire_date) as hire_year,
    COUNT(*) as employees_hired,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    ROUND(AVG(salary), 2) as avg_salary,
    SUM(salary) as total_salary_cost
FROM Employees 
GROUP BY YEAR(hire_date)
ORDER BY hire_year DESC;

