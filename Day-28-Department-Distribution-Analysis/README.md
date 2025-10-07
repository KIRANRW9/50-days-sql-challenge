# Day 28: Department Distribution Analysis (Percentage Calculations with Subqueries)

## Problem
The HR department needs to analyze the distribution of employees across different departments to understand workforce allocation, identify overstaffed or understaffed departments, and make informed decisions about hiring, resource allocation, and organizational restructuring. This analysis helps in workforce planning, budget allocation, and departmental balance assessment. This problem tests understanding of percentage calculations, subqueries, and workforce distribution analysis.

## Dataset
Employee data with department assignments, enabling calculation of employee distribution percentages across various organizational units.

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
    city VARCHAR(50)
);
```

## Query 1: Basic Employee Percentage by Department
Calculate the percentage of employees in each department relative to total workforce.

```sql
SELECT 
    department_id, 
    COUNT(*) AS emp_count,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee), 2) AS percentage
FROM Employee 
GROUP BY department_id
ORDER BY emp_count DESC;
```

**Output:**
```
department_id | emp_count | percentage
--------------|-----------|------------
101           | 8         | 26.67
102           | 7         | 23.33
103           | 6         | 20.00
104           | 5         | 16.67
105           | 4         | 13.33
```

## Query 2: Detailed Department Distribution with Names
Show comprehensive department distribution including department names and salary information.

```sql
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
```

**Output:**
```
department_id | department_name | employee_count | percentage_of_workforce | avg_department_salary | total_department_salary
--------------|-----------------|----------------|------------------------|----------------------|------------------------
101           | Engineering     | 8              | 26.67                  | 95000.00             | 760000.00
102           | Sales           | 7              | 23.33                  | 72857.14             | 510000.00
103           | Marketing       | 6              | 20.00                  | 68333.33             | 410000.00
104           | HR              | 5              | 16.67                  | 62000.00             | 310000.00
105           | Finance         | 4              | 13.33                  | 87500.00             | 350000.00
```

## Query 3: Department Size Categories
Classify departments by their workforce size and show distribution patterns.

```sql
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
```

**Output:**
```
department_size           | number_of_departments | total_employees | percentage_of_total
--------------------------|----------------------|-----------------|--------------------
Large Department (8+)     | 1                    | 8               | 26.67
Medium Department (6-7)   | 2                    | 13              | 43.33
Small Department (4-5)    | 2                    | 9               | 30.00
```

## Query 4: City-wise Department Distribution
Analyze how employees are distributed across departments in different cities.

```sql
SELECT 
    city,
    department_name,
    COUNT(*) AS employees_in_dept,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (PARTITION BY city), 2) AS pct_in_city,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee), 2) AS pct_of_total_workforce
FROM Employee
GROUP BY city, department_name, department_id
ORDER BY city, employees_in_dept DESC;
```

**Output:**
```
city      | department_name | employees_in_dept | pct_in_city | pct_of_total_workforce
----------|-----------------|-------------------|-------------|----------------------
Bangalore | Engineering     | 3                 | 30.00       | 10.00
Bangalore | Sales           | 2                 | 20.00       | 6.67
Bangalore | Marketing       | 2                 | 20.00       | 6.67
Bangalore | HR              | 2                 | 20.00       | 6.67
Bangalore | Finance         | 1                 | 10.00       | 3.33
Chennai   | Engineering     | 2                 | 40.00       | 6.67
Chennai   | Sales           | 2                 | 40.00       | 6.67
Chennai   | Marketing       | 1                 | 20.00       | 3.33
```

## Query 5: Department Salary Budget Distribution
Calculate what percentage of total salary budget each department consumes.

```sql
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
```

**Output:**
```
department_id | department_name | employee_count | pct_of_headcount | department_budget | pct_of_salary_budget | avg_salary | budget_per_employee
--------------|-----------------|----------------|------------------|-------------------|---------------------|------------|--------------------
101           | Engineering     | 8              | 26.67            | 760000.00         | 32.76               | 95000.00   | 95000.00
102           | Sales           | 7              | 23.33            | 510000.00         | 21.98               | 72857.14   | 72857.14
103           | Marketing       | 6              | 20.00            | 410000.00         | 17.67               | 68333.33   | 68333.33
105           | Finance         | 4              | 13.33            | 350000.00         | 15.09               | 87500.00   | 87500.00
104           | HR              | 5              | 16.67            | 310000.00         | 13.36               | 62000.00   | 62000.00
```

## How It Works

**Percentage Calculations:** Using `COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employee)` to calculate what percentage each department represents of the total workforce.

**Subqueries for Totals:** The subquery `(SELECT COUNT(*) FROM Employee)` calculates total employees once and uses it as denominator for all percentage calculations.

**GROUP BY Aggregation:** Groups employees by department to count and aggregate metrics at the department level.

**Window Functions:** `OVER (PARTITION BY city)` enables percentage calculations within city subgroups for multi-dimensional analysis.

**CASE Statements:** Categorizes departments into size groups based on employee counts for high-level distribution analysis.

**Multiple Aggregates:** Combines COUNT(), SUM(), and AVG() to show both headcount and budget distribution patterns.

## Real World Use Cases

**Workforce Planning:** Identify departments that are growing too large or too small compared to organizational needs and industry benchmarks.

**Budget Allocation:** Ensure salary budgets align with strategic priorities by comparing headcount percentages with budget percentages.

**Recruitment Strategy:** Determine which departments need hiring based on current distribution and business growth plans.

**Organizational Restructuring:** Identify opportunities to rebalance workforce across departments for optimal operational efficiency.

**Capacity Planning:** Understand if department sizes match workload and responsibility distribution across the organization.

**Benchmarking:** Compare internal department distribution against industry standards to identify structural inefficiencies or opportunities.

## Key Learning

**Percentage Calculations with Subqueries** enable relative analysis by comparing part-to-whole relationships, making absolute numbers meaningful through context.

**Multiple Dimensions of Analysis** (headcount vs budget, city vs department) reveal insights that single-dimension analysis misses, such as high-cost small departments.

**Distribution Analysis** helps identify imbalances and opportunities, transforming raw counts into actionable insights about organizational structure and resource allocation.
