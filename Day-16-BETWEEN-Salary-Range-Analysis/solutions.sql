-- Day 16: Salary Range Analysis with BETWEEN Operator (Range Filtering and Compensation Analysis)
-- Solutions SQL File

-- Create Database Schema
-- Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    experience_years INT,
    location VARCHAR(50),
    performance_rating VARCHAR(10)
);

-- Query Solutions

-- Query 1: Employees with Salary Between 50,000 and 100,000 
-- List all employees whose salary is within the specified range
SELECT * 
FROM Employees 
WHERE salary BETWEEN 50000 AND 100000
ORDER BY salary DESC;

-- Query 2: Salary Range Distribution Analysis 
-- Analyze employee distribution across different salary ranges
SELECT 
    CASE 
        WHEN salary < 50000 THEN 'Below Range (<50K)'
        WHEN salary BETWEEN 50000 AND 100000 THEN 'Target Range (50K-100K)'
        WHEN salary > 100000 THEN 'Above Range (>100K)'
    END as salary_category,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    ROUND(AVG(experience_years), 1) as avg_experience
FROM Employees
GROUP BY 
    CASE 
        WHEN salary < 50000 THEN 'Below Range (<50K)'
        WHEN salary BETWEEN 50000 AND 100000 THEN 'Target Range (50K-100K)'
        WHEN salary > 100000 THEN 'Above Range (>100K)'
    END
ORDER BY avg_salary;

-- Query 3: Department-wise Target Range Analysis 
-- Analyze employees in target range by department
SELECT 
    department,
    COUNT(*) as employees_in_range,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    ROUND(AVG(experience_years), 1) as avg_experience,
    GROUP_CONCAT(DISTINCT performance_rating ORDER BY performance_rating) as ratings
FROM Employees
WHERE salary BETWEEN 50000 AND 100000
GROUP BY department
ORDER BY employees_in_range DESC, avg_salary DESC;

-- Query 4: Performance Rating Analysis within Range 
-- Analyze performance ratings of employees in target salary range
SELECT 
    performance_rating,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    ROUND(AVG(experience_years), 1) as avg_experience,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employees WHERE salary BETWEEN 50000 AND 100000)), 1) as percentage_of_range
FROM Employees
WHERE salary BETWEEN 50000 AND 100000
GROUP BY performance_rating
ORDER BY avg_salary DESC;

-- Query 5: Location and Experience Analysis 
-- Analyze target range employees by location and experience level
SELECT 
    location,
    CASE 
        WHEN experience_years <= 2 THEN 'Junior (0-2 years)'
        WHEN experience_years BETWEEN 3 AND 5 THEN 'Mid-Level (3-5 years)'
        ELSE 'Senior (5+ years)'
    END as experience_level,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM Employees
WHERE salary BETWEEN 50000 AND 100000
GROUP BY location, 
    CASE 
        WHEN experience_years <= 2 THEN 'Junior (0-2 years)'
        WHEN experience_years BETWEEN 3 AND 5 THEN 'Mid-Level (3-5 years)'
        ELSE 'Senior (5+ years)'
    END
ORDER BY location, avg_salary DESC;
