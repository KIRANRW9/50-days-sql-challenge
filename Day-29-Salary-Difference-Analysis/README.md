# Day 29: Department Salary Difference Analysis (MIN/MAX Aggregation)

## Problem
The HR and compensation team needs to analyze salary disparities within departments to ensure fair compensation practices, identify pay equity issues, and understand the salary range spread across different organizational units. This analysis helps in salary benchmarking, compensation planning, and detecting potential pay inequality concerns. This problem tests understanding of MIN/MAX aggregate functions, salary range calculations, and compensation analysis.

## Dataset
Employee data with salary information across multiple departments, enabling calculation of salary differences, ranges, and compensation equity metrics within each department.

## SQL Solution

### Create Tables and Sample Data
```sql
-- Create Employee table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    experience_years INT
);
```

## Query 1: Basic Salary Difference by Department
Calculate the maximum salary difference (range) within each department.

```sql
SELECT 
    department_id, 
    MAX(salary) - MIN(salary) AS salary_diff 
FROM Employee 
GROUP BY department_id
ORDER BY salary_diff DESC;
```

**Output:**
```
department_id | salary_diff
--------------|-------------
101           | 50000.00
102           | 40000.00
103           | 30000.00
104           | 35000.00
105           | 45000.00
```

## Query 2: Detailed Salary Range Analysis by Department
Show comprehensive salary range metrics including min, max, and difference with department names.

```sql
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
```

**Output:**
```
department_id | department_name | employee_count | min_salary | max_salary | salary_difference | avg_salary | salary_range_percent
--------------|-----------------|----------------|------------|------------|-------------------|------------|---------------------
101           | Engineering     | 8              | 70000.00   | 120000.00  | 50000.00          | 95000.00   | 71.43
105           | Finance         | 4              | 65000.00   | 110000.00  | 45000.00          | 87500.00   | 69.23
102           | Sales           | 7              | 55000.00   | 95000.00   | 40000.00          | 72857.14   | 72.73
104           | HR              | 5              | 50000.00   | 85000.00   | 35000.00          | 62000.00   | 70.00
103           | Marketing       | 6              | 60000.00   | 90000.00   | 30000.00          | 68333.33   | 50.00
```

## Query 3: Salary Gap Analysis with Position Details
Identify employees at minimum and maximum salary points in each department.

```sql
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
```

**Output:**
```
department_id | department_name | employee_name    | position              | salary     | salary_position | dept_salary_range
--------------|-----------------|------------------|-----------------------|------------|-----------------|------------------
101           | Engineering     | Priya Sharma     | Tech Lead             | 120000.00  | Highest Paid    | 50000.00
101           | Engineering     | Vikram Singh     | QA Engineer           | 70000.00   | Lowest Paid     | 50000.00
102           | Sales           | Rohit Mehta      | Sales Manager         | 95000.00   | Highest Paid    | 40000.00
102           | Sales           | Nikhil Verma     | Sales Coordinator     | 55000.00   | Lowest Paid     | 40000.00
103           | Marketing       | Anjali Rao       | Marketing Manager     | 90000.00   | Highest Paid    | 30000.00
103           | Marketing       | Aditya Bose      | SEO Specialist        | 60000.00   | Lowest Paid     | 30000.00
```

## Query 4: Salary Quartile Distribution by Department
Analyze how salaries are distributed within each department using quartiles.

```sql
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
```

**Output (MySQL compatible version):**
```
department_id | department_name | total_employees | min_salary | median_salary | max_salary | total_range
--------------|-----------------|-----------------|------------|---------------|------------|-------------
101           | Engineering     | 8               | 70000.00   | 87500.00      | 120000.00  | 50000.00
105           | Finance         | 4               | 65000.00   | 77500.00      | 110000.00  | 45000.00
102           | Sales           | 7               | 55000.00   | 70000.00      | 95000.00   | 40000.00
104           | HR              | 5               | 50000.00   | 60000.00      | 85000.00   | 35000.00
103           | Marketing       | 6               | 60000.00   | 72500.00      | 90000.00   | 30000.00
```

## Query 5: Salary Compression Analysis
Identify departments with potential salary compression issues (small differences between junior and senior roles).

```sql
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
```

**Output:**
```
department_id | department_name | employee_count | min_salary | max_salary | salary_range | avg_salary | avg_increment_per_level | compression_status
--------------|-----------------|----------------|------------|------------|--------------|------------|------------------------|--------------------
103           | Marketing       | 6              | 60000.00   | 90000.00   | 30000.00     | 68333.33   | 5000.00                | High Compression Risk
104           | HR              | 5              | 50000.00   | 85000.00   | 35000.00     | 62000.00   | 7000.00                | Moderate Compression
102           | Sales           | 7              | 55000.00   | 95000.00   | 40000.00     | 72857.14   | 5714.29                | Healthy Range
105           | Finance         | 4              | 65000.00   | 110000.00  | 45000.00     | 87500.00   | 11250.00               | Healthy Range
101           | Engineering     | 8              | 70000.00   | 120000.00  | 50000.00     | 95000.00   | 6250.00                | Healthy Range
```

## How It Works

**MIN/MAX Aggregation:** Using MIN(salary) and MAX(salary) to find the lowest and highest salaries within each department group.

**Salary Difference Calculation:** Subtracting MIN from MAX (`MAX(salary) - MIN(salary)`) provides the total salary range spread within a department.

**GROUP BY Department:** Groups all employees by department_id to calculate aggregate statistics per department.

**Percentage Calculations:** Computing salary range as a percentage of minimum salary shows relative disparity: `(MAX - MIN) * 100 / MIN`.

**CASE Statements:** Categorizing salary positions (highest/lowest paid) and compression risk levels based on calculated ranges.

**Subqueries for Comparison:** Using subqueries to calculate department statistics and then join back to find specific employees at range extremes.

## Real World Use Cases

**Pay Equity Analysis:** Identify departments with excessive salary disparities that may indicate unfair compensation practices or pay discrimination issues.

**Compensation Planning:** Understand salary range spreads to plan budget allocations for raises, promotions, and new hires within each department.

**Salary Benchmarking:** Compare internal salary ranges against industry standards to ensure competitive compensation and retention strategies.

**Career Progression Planning:** Analyze whether salary ranges provide adequate room for career growth and progression within departments.

**Budget Forecasting:** Use salary range data to predict future compensation costs as employees progress through salary bands.

**Compression Detection:** Identify situations where senior and junior employees have similar salaries, which can harm morale and retention.

## Key Learning

**MIN/MAX with GROUP BY** enables range analysis within groups, a fundamental pattern for understanding data distribution and identifying outliers in any dataset.

**Salary Difference Calculations** transform absolute numbers into meaningful metrics that reveal equity issues, showing not just what people earn but how fair the distribution is.

**Multiple Aggregations Together** (MIN, MAX, AVG, COUNT) provide comprehensive insights, with each metric adding context that makes the others more actionable for decision-making.
