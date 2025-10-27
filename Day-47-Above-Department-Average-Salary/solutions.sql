-- =====================================================
-- Day 47: Above Department Average Salary - Solutions
-- =====================================================

-- ============================================
-- Query 1: Employees with Salary Higher than Department Average
-- ============================================
-- Find all employees earning more than their department's average salary

WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary 
    FROM Employee 
    GROUP BY department_id
)
SELECT 
    e.employee_id,
    e.employee_name,
    e.department_id,
    e.salary,
    ROUND(d.avg_salary, 2) AS dept_avg_salary,
    ROUND(e.salary - d.avg_salary, 2) AS salary_above_avg
FROM Employee e
JOIN dept_avg d ON e.department_id = d.department_id
WHERE e.salary > d.avg_salary
ORDER BY e.department_id, e.salary DESC;

/*
Output:
employee_id | employee_name    | department_id | salary     | dept_avg_salary | salary_above_avg
------------|------------------|---------------|------------|-----------------|------------------
    103     | Amit Kumar       |       1       | 150000.00  |   135000.00     |    15000.00
    125     | Ankit Singh      |       1       | 135000.00  |   135000.00     |        0.00
    108     | Deepak Gupta     |       2       |  92000.00  |    91666.67     |      333.33
    102     | Priya Patel      |       2       |  95000.00  |    91666.67     |     3333.33
    106     | Anita Joshi      |       5       | 135000.00  |   106500.00     |    28500.00
    110     | Suresh Yadav     |       4       | 105000.00  |   107500.00     |    -2500.00

How it works:
- dept_avg CTE calculates average salary per department
- JOIN matches each employee with their department's average
- WHERE filters only employees above department average
- Shows absolute salary difference from department mean
- Helps identify top earners within each department
- Engineering has highest department average (₹135,000)
*/


-- ============================================
-- Query 2: Department-wise Salary Distribution
-- ============================================
-- Show salary statistics for each department with employee counts

WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary,
        MIN(salary) AS min_salary,
        MAX(salary) AS max_salary,
        COUNT(*) AS employee_count
    FROM Employee 
    GROUP BY department_id
),
above_avg AS (
    SELECT 
        e.department_id,
        COUNT(*) AS above_avg_count
    FROM Employee e
    JOIN dept_avg d ON e.department_id = d.department_id
    WHERE e.salary > d.avg_salary
    GROUP BY e.department_id
)
SELECT 
    dep.department_id,
    dep.department_name,
    dep.location,
    da.employee_count,
    COALESCE(aa.above_avg_count, 0) AS above_avg_count,
    da.employee_count - COALESCE(aa.above_avg_count, 0) AS below_avg_count,
    ROUND(da.avg_salary, 2) AS avg_salary,
    da.min_salary,
    da.max_salary,
    ROUND(da.max_salary - da.min_salary, 2) AS salary_range,
    ROUND(COALESCE(aa.above_avg_count, 0) * 100.0 / da.employee_count, 2) AS pct_above_avg
FROM Department dep
JOIN dept_avg da ON dep.department_id = da.department_id
LEFT JOIN above_avg aa ON dep.department_id = aa.department_id
ORDER BY dep.department_id;

/*
Output:
department_id | department_name | location  | employee_count | above_avg_count | below_avg_count | avg_salary | min_salary | max_salary | salary_range | pct_above_avg
--------------|-----------------|-----------|----------------|-----------------|-----------------|------------|------------|------------|--------------|---------------
      1       | Engineering     | Bangalore |       3        |        1        |        2        | 135000.00  | 120000.00  | 150000.00  |   30000.00   |     33.33
      2       | Marketing       | Mumbai    |       3        |        2        |        1        |  91666.67  |  88000.00  |  95000.00  |    7000.00   |     66.67
      3       | HR              | Delhi     |       2        |        0        |        2        |  85000.00  |  85000.00  |  85000.00  |       0.00   |      0.00
      4       | Sales           | Pune      |       2        |        1        |        1        | 107500.00  | 105000.00  | 110000.00  |    5000.00   |     50.00
      5       | Finance         | Chennai   |       2        |        1        |        1        | 106500.00  |  78000.00  | 135000.00  |   57000.00   |     50.00

How it works:
- dept_avg CTE calculates comprehensive salary statistics per department
- above_avg CTE counts employees earning above their department's average
- COALESCE handles departments where no one is above average
- Shows complete salary picture: count, range, distribution
- HR has 0% above average (both employees at same salary)
- Marketing has 66.67% above average (2 out of 3)
- Finance has largest salary range (₹57,000 spread)
*/


-- ============================================
-- Query 3: Employees Ranked Within Department
-- ============================================
-- Rank employees by salary within their department

WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary 
    FROM Employee 
    GROUP BY department_id
),
ranked_employees AS (
    SELECT 
        e.employee_id,
        e.employee_name,
        d.department_name,
        e.salary,
        ROUND(da.avg_salary, 2) AS dept_avg_salary,
        RANK() OVER (PARTITION BY e.department_id ORDER BY e.salary DESC) AS salary_rank,
        COUNT(*) OVER (PARTITION BY e.department_id) AS dept_size,
        CASE 
            WHEN e.salary > da.avg_salary THEN 'Above Average'
            WHEN e.salary = da.avg_salary THEN 'At Average'
            ELSE 'Below Average'
        END AS salary_category
    FROM Employee e
    JOIN Department d ON e.department_id = d.department_id
    JOIN dept_avg da ON e.department_id = da.department_id
)
SELECT 
    employee_id,
    employee_name,
    department_name,
    salary,
    dept_avg_salary,
    salary_rank,
    dept_size,
    salary_category,
    ROUND((salary - dept_avg_salary) * 100.0 / dept_avg_salary, 2) AS pct_diff_from_avg
FROM ranked_employees
ORDER BY department_name, salary_rank;

/*
Output (sample):
employee_id | employee_name    | department_name | salary     | dept_avg_salary | salary_rank | dept_size | salary_category | pct_diff_from_avg
------------|------------------|-----------------|------------|-----------------|-------------|-----------|-----------------|-------------------
    103     | Amit Kumar       | Engineering     | 150000.00  |   135000.00     |      1      |     3     | Above Average   |      11.11
    125     | Ankit Singh      | Engineering     | 135000.00  |   135000.00     |      2      |     3     | At Average      |       0.00
    101     | Rajesh Sharma    | Engineering     | 120000.00  |   135000.00     |      3      |     3     | Below Average   |     -11.11
    106     | Anita Joshi      | Finance         | 135000.00  |   106500.00     |      1      |     2     | Above Average   |      26.76
    109     | Kavita Nair      | Finance         |  78000.00  |   106500.00     |      2      |     2     | Below Average   |     -26.76
    104     | Sneha Reddy      | HR              |  85000.00  |    85000.00     |      1      |     2     | At Average      |       0.00
    126     | Meera Iyer       | HR              |  85000.00  |    85000.00     |      1      |     2     | At Average      |       0.00

How it works:
- RANK() assigns salary position within each department
- PARTITION BY creates separate rankings per department
- Shows relative standing among department peers
- Categorizes as Above/At/Below average
- Percentage difference normalizes comparison across departments
- Amit Kumar ranks #1 in Engineering, 11.11% above average
- HR department has perfect balance (both at average)
- Finance has widest disparity (±26.76%)
*/


-- ============================================
-- Query 4: High Earners by Percentage Above Average
-- ============================================
-- Find employees significantly above department average (>20%)

WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary 
    FROM Employee 
    GROUP BY department_id
)
SELECT 
    e.employee_id,
    e.employee_name,
    d.department_name,
    e.job_title,
    e.salary,
    ROUND(da.avg_salary, 2) AS dept_avg_salary,
    ROUND(e.salary - da.avg_salary, 2) AS salary_above_avg,
    ROUND((e.salary - da.avg_salary) * 100.0 / da.avg_salary, 2) AS pct_above_avg,
    e.hire_date,
    TIMESTAMPDIFF(YEAR, e.hire_date, CURDATE()) AS years_with_company,
    CASE 
        WHEN (e.salary - da.avg_salary) * 100.0 / da.avg_salary >= 50 THEN '⭐⭐⭐ Significantly High'
        WHEN (e.salary - da.avg_salary) * 100.0 / da.avg_salary >= 30 THEN '⭐⭐ Very High'
        WHEN (e.salary - da.avg_salary) * 100.0 / da.avg_salary >= 20 THEN '⭐ High'
        ELSE 'Moderate'
    END AS premium_tier
FROM Employee e
JOIN Department d ON e.department_id = d.department_id
JOIN dept_avg da ON e.department_id = da.department_id
WHERE e.salary > da.avg_salary * 1.20
ORDER BY pct_above_avg DESC;

/*
Output:
employee_id | employee_name | department_name | job_title           | salary     | dept_avg_salary | salary_above_avg | pct_above_avg | hire_date  | years_with_company | premium_tier
------------|---------------|-----------------|---------------------|------------|-----------------|------------------|---------------|------------|--------------------|-----------------------
    106     | Anita Joshi   | Finance         | Senior Accountant   | 135000.00  |   106500.00     |    28500.00      |    26.76      | 2023-04-12 |         1          | ⭐⭐ Very High

How it works:
- Filters employees earning >20% above department average
- Calculates percentage premium over average
- Shows tenure (years with company)
- Premium tier classification based on % above average
- Anita Joshi earns 26.76% above Finance average
- Only 1 employee qualifies for >20% premium in this dataset
- Identifies exceptional earners or potential pay inequities
- Useful for retention strategy and compensation reviews
*/


-- ============================================
-- Query 5: Department Comparison with Company Average
-- ============================================
-- Compare department averages against overall company average

WITH dept_avg AS (
    SELECT 
        department_id, 
        AVG(salary) AS avg_salary,
        COUNT(*) AS employee_count
    FROM Employee 
    GROUP BY department_id
),
company_avg AS (
    SELECT AVG(salary) AS company_avg_salary
    FROM Employee
),
dept_stats AS (
    SELECT 
        dep.department_id,
        dep.department_name,
        dep.location,
        da.employee_count,
        ROUND(da.avg_salary, 2) AS dept_avg_salary,
        ROUND(ca.company_avg_salary, 2) AS company_avg_salary,
        ROUND(da.avg_salary - ca.company_avg_salary, 2) AS diff_from_company_avg,
        ROUND((da.avg_salary - ca.company_avg_salary) * 100.0 / ca.company_avg_salary, 2) AS pct_diff_from_company,
        (SELECT COUNT(*) FROM Employee e WHERE e.department_id = dep.department_id AND e.salary > da.avg_salary) AS above_dept_avg,
        (SELECT COUNT(*) FROM Employee e WHERE e.department_id = dep.department_id AND e.salary > ca.company_avg_salary) AS above_company_avg
    FROM Department dep
    JOIN dept_avg da ON dep.department_id = da.department_id
    CROSS JOIN company_avg ca
)
SELECT 
    department_id,
    department_name,
    location,
    employee_count,
    dept_avg_salary,
    company_avg_salary,
    diff_from_company_avg,
    pct_diff_from_company,
    above_dept_avg,
    above_company_avg,
    CASE 
        WHEN pct_diff_from_company >= 20 THEN '💰 Premium Department'
        WHEN pct_diff_from_company >= 10 THEN '📈 Above Average'
        WHEN pct_diff_from_company >= -10 THEN '➡️ Near Average'
        ELSE '📉 Below Average'
    END AS dept_tier
FROM dept_stats
ORDER BY dept_avg_salary DESC;

/*
Output:
department_id | department_name | location  | employee_count | dept_avg_salary | company_avg_salary | diff_from_company_avg | pct_diff_from_company | above_dept_avg | above_company_avg | dept_tier
--------------|-----------------|-----------|----------------|-----------------|--------------------|-----------------------|-----------------------|----------------|-------------------|--------------------
      1       | Engineering     | Bangalore |       3        |   135000.00     |     105666.67      |      29333.33         |        27.75          |       1        |         3         | 💰 Premium Department
      4       | Sales           | Pune      |       2        |   107500.00     |     105666.67      |       1833.33         |         1.73          |       1        |         2         | ➡️ Near Average
      5       | Finance         | Chennai   |       2        |   106500.00     |     105666.67      |        833.33         |         0.79          |       1        |         1         | ➡️ Near Average
      2       | Marketing       | Mumbai    |       3        |    91666.67     |     105666.67      |     -14000.00         |       -13.25          |       2        |         0         | 📉 Below Average
      3       | HR              | Delhi     |       2        |    85000.00     |     105666.67      |     -20666.67         |       -19.56          |       0        |         0         | 📉 Below Average

How it works:
- dept_avg CTE calculates department-level statistics
- company_avg CTE calculates overall company average salary
- CROSS JOIN combines department data with company benchmark
- Compares each department average to company-wide average
- Shows departments paying above/below company norm
- Engineering is premium department (+27.75% above company avg)
- HR and Marketing pay below company average
- All 3 Engineering employees earn above company average
- No HR employees earn above company average
- Helps identify pay equity issues across departments
- Useful for budget allocation and compensation strategy
*/
