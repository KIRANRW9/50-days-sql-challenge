-- Day 28: Department Distribution Analysis - Solutions

-- Solution 1: Basic Employee Percentage by Department
-- Calculate the percentage of employees in each department
SELECT 
    department_id, 
    COUNT(*) AS emp_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee), 2) AS percentage
FROM Employee 
GROUP BY department_id
ORDER BY emp_count DESC;

-- Solution 2: Detailed Department Distribution with Names
-- Show comprehensive department distribution with salary information
SELECT 
    department_id,
    department_name,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee), 2) AS percentage_of_workforce,
    ROUND(AVG(salary), 2) AS avg_department_salary,
    SUM(salary) AS total_department_salary
FROM Employee 
GROUP BY department_id, department_name
ORDER BY employee_count DESC;


-- Solution 3: Department Size Categories
-- Classify departments by workforce size
SELECT 
    CASE 
        WHEN emp_count >= 8 THEN 'Large Department (8+)'
        WHEN emp_count >= 6 THEN 'Medium Department (6-7)'
        WHEN emp_count >= 4 THEN 'Small Department (4-5)'
        ELSE 'Micro Department (<4)'
    END AS department_size,
    COUNT(*) AS number_of_departments,
    SUM(emp_count) AS total_employees,
    ROUND(SUM(emp_count) * 100.0 / (SELECT COUNT(*) FROM Employee), 2) AS percentage_of_total
FROM (
    SELECT 
        department_id,
        COUNT(*) AS emp_count
    FROM Employee
    GROUP BY department_id
) dept_counts
GROUP BY 
    CASE 
        WHEN emp_count >= 8 THEN 'Large Department (8+)'
        WHEN emp_count >= 6 THEN 'Medium Department (6-7)'
        WHEN emp_count >= 4 THEN 'Small Department (4-5)'
        ELSE 'Micro Department (<4)'
    END
ORDER BY total_employees DESC;

-- Solution 4: City-wise Department Distribution
-- Analyze employee distribution across departments in different cities
SELECT 
    city,
    department_name,
    COUNT(*) AS employees_in_dept,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY city), 2) AS pct_in_city,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee), 2) AS pct_of_total_workforce
FROM Employee
GROUP BY city, department_name, department_id
ORDER BY city, employees_in_dept DESC;


-- Solution 5: Department Salary Budget Distribution
-- Calculate percentage of total salary budget each department consumes
SELECT 
    department_id,
    department_name,
    COUNT(*) AS employee_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee), 2) AS pct_of_headcount,
    SUM(salary) AS department_budget,
    ROUND(SUM(salary) * 100.0 / (SELECT SUM(salary) FROM Employee), 2) AS pct_of_salary_budget,
    ROUND(AVG(salary), 2) AS avg_salary,
    ROUND(SUM(salary) / COUNT(*), 2) AS budget_per_employee
FROM Employee
GROUP BY department_id, department_name
ORDER BY pct_of_salary_budget DESC;
