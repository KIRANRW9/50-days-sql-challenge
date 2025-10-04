-- Day 25: Department Performance Analysis by Average Salary
-- Solutions SQL File

-- Query Solutions

-- Query 1: Top Departments by Average Salary 
-- Identify top-performing departments by average salary
SELECT 
    department_id, 
    AVG(salary) AS avg_salary 
FROM Employee 
GROUP BY department_id 
ORDER BY avg_salary DESC;

-- Query 2: Department Performance with Details 
-- Get comprehensive department performance metrics
SELECT 
    department_id,
    department_name,
    COUNT(*) as employee_count,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    AVG(salary) as avg_salary,
    SUM(salary) as total_payroll,
    ROUND(AVG(experience_years), 1) as avg_experience
FROM Employee
GROUP BY department_id, department_name
ORDER BY avg_salary DESC;

-- Query 3: Department Ranking with Salary Distribution 
-- Rank departments and show salary distribution
SELECT 
    department_name,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    MAX(salary) - MIN(salary) as salary_range,
    RANK() OVER (ORDER BY AVG(salary) DESC) as dept_rank,
    CASE 
        WHEN AVG(salary) >= 150000 THEN 'High Paying'
        WHEN AVG(salary) >= 100000 THEN 'Competitive'
        WHEN AVG(salary) >= 80000 THEN 'Average'
        ELSE 'Below Average'
    END as compensation_level
FROM Employee
GROUP BY department_id, department_name
ORDER BY avg_salary DESC;

-- Query 4: Department Performance by Experience Level 
-- Analyze average salary by department and experience level
SELECT 
    d.department_name,
    CASE 
        WHEN e.experience_years <= 3 THEN 'Junior (0-3 years)'
        WHEN e.experience_years <= 7 THEN 'Mid-Level (4-7 years)'
        ELSE 'Senior (8+ years)'
    END as experience_level,
    COUNT(*) as employee_count,
    ROUND(AVG(e.salary), 2) as avg_salary,
    MIN(e.salary) as min_salary,
    MAX(e.salary) as max_salary
FROM Employee e
JOIN (SELECT DISTINCT department_id, department_name FROM Employee) d 
    ON e.department_id = d.department_id
GROUP BY d.department_name, 
    CASE 
        WHEN e.experience_years <= 3 THEN 'Junior (0-3 years)'
        WHEN e.experience_years <= 7 THEN 'Mid-Level (4-7 years)'
        ELSE 'Senior (8+ years)'
    END
ORDER BY d.department_name, avg_salary DESC;

-- Query 5: Top 3 Departments with Performance Context 
-- Identify top 3 departments with additional context
WITH DepartmentStats AS (
    SELECT 
        department_id,
        department_name,
        COUNT(*) as employee_count,
        ROUND(AVG(salary), 2) as avg_salary,
        ROUND(AVG(experience_years), 1) as avg_experience,
        COUNT(CASE WHEN performance_rating = 'Excellent' THEN 1 END) as excellent_performers
    FROM Employee
    GROUP BY department_id, department_name
)
SELECT 
    department_name,
    employee_count,
    avg_salary,
    avg_experience,
    excellent_performers,
    ROUND((excellent_performers * 100.0 / employee_count), 1) as excellent_pct,
    RANK() OVER (ORDER BY avg_salary DESC) as salary_rank
FROM DepartmentStats
ORDER BY avg_salary DESC
LIMIT 3;
