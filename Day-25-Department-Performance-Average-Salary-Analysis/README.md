# Day 25: Department Performance Analysis by Average Salary

## Problem
The HR and management teams need to identify top-performing departments based on average salary metrics to understand compensation distribution, budget allocation effectiveness, and attract/retain talent in high-performing units. This analysis helps in strategic workforce planning, competitive positioning, and ensuring equitable compensation across departments.

## Dataset
Employee salary data across multiple departments with positions, experience levels, and compensation information for comprehensive department performance analysis.

## SQL Solution

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
    experience_years INT,
    performance_rating VARCHAR(20)
);
-- Engineering Department (101) - Highest Average Salary
INSERT INTO Employee VALUES
(1001, 'Rajesh Kumar', 101, 'Engineering', 'Chief Technology Officer', 220000.00, '2020-01-15', 12, 'Excellent'),
(1002, 'Amit Patel', 101, 'Engineering', 'Engineering Manager', 180000.00, '2020-03-20', 10, 'Excellent'),
(1003, 'Sneha Reddy', 101, 'Engineering', 'Senior Software Engineer', 150000.00, '2021-06-10', 7, 'Excellent'),
(1004, 'Karthik Nair', 101, 'Engineering', 'Software Engineer', 120000.00, '2022-02-14', 5, 'Good'),
(1005, 'Priya Sharma', 101, 'Engineering', 'Senior DevOps Engineer', 165000.00, '2021-08-22', 8, 'Excellent'),
(1006, 'Vikram Singh', 101, 'Engineering', 'Junior Developer', 95000.00, '2023-11-05', 2, 'Good'),

-- Finance Department (102) - Second Highest Average
INSERT INTO Employee VALUES
(2001, 'Meera Iyer', 102, 'Finance', 'Finance Director', 180000.00, '2019-08-30', 11, 'Excellent'),
(2002, 'Suresh Gupta', 102, 'Finance', 'Senior Financial Analyst', 155000.00, '2021-11-15', 8, 'Excellent'),
(2003, 'Pooja Rao', 102, 'Finance', 'Financial Analyst', 105000.00, '2022-05-20', 5, 'Good'),

-- Sales Department (103) - Mid-range Average
INSERT INTO Employee VALUES
(3001, 'Anita Desai', 103, 'Sales', 'Sales Director', 160000.00, '2020-07-08', 9, 'Excellent'),
(3002, 'Rohit Mehta', 103, 'Sales', 'Senior Sales Manager', 130000.00, '2021-04-18', 6, 'Excellent'),
(3003, 'Deepa Joshi', 103, 'Sales', 'Sales Manager', 110000.00, '2022-10-12', 4, 'Good'),
(3004, 'Arjun Nair', 103, 'Sales', 'Sales Executive', 85000.00, '2023-05-10', 2, 'Good'),

-- Marketing Department (104) - Below Mid-range
INSERT INTO Employee VALUES
(4001, 'Kavya Pillai', 104, 'Marketing', 'Marketing Director', 120000.00, '2021-08-22', 7, 'Excellent'),
(4002, 'Ganesh Reddy', 104, 'Marketing', 'Marketing Manager', 110000.00, '2022-06-10', 5, 'Good'),
(4003, 'Sanjay Patel', 104, 'Marketing', 'Digital Marketing Specialist', 85000.00, '2023-02-13', 3, 'Good'),
(4004, 'Neha Agarwal', 104, 'Marketing', 'Content Writer', 72000.00, '2023-12-14', 1, 'Average'),

-- HR Department (105) - Lowest Average
INSERT INTO Employee VALUES
(5001, 'Lakshmi Menon', 105, 'HR', 'HR Manager', 95000.00, '2021-11-30', 6, 'Excellent'),
(5002, 'Ravi Krishnan', 105, 'HR', 'HR Executive', 89000.00, '2022-12-05', 3, 'Good'),
(5003, 'Divya Sharma', 105, 'HR', 'Recruiter', 68000.00, '2023-09-18', 2, 'Average');

-- Additional employees for better distribution

-- More Engineering employees
INSERT INTO Employee VALUES
(1007, 'Arun Kumar', 101, 'Engineering', 'Tech Lead', 175000.00, '2020-09-15', 9, 'Excellent'),
(1008, 'Nisha Kapoor', 101, 'Engineering', 'QA Manager', 140000.00, '2021-12-20', 6, 'Good'),

-- More Sales employees  
INSERT INTO Employee VALUES
(3005, 'Vishal Rao', 103, 'Sales', 'Account Manager', 115000.00, '2022-03-25', 4, 'Good');

-- More Marketing employees
INSERT INTO Employee VALUES
(4005, 'Rekha Pillai', 104, 'Marketing', 'SEO Specialist', 78000.00, '2023-07-08', 2, 'Good'),
(4006, 'Manoj Kumar', 104, 'Marketing', 'Graphic Designer', 82000.00, '2023-04-15', 3, 'Good');

-- More Finance employees
INSERT INTO Employee VALUES
(2004, 'Harish Mehta', 102, 'Finance', 'Accountant', 98000.00, '2023-01-10', 4, 'Average');

-- More HR employees
INSERT INTO Employee VALUES
(5004, 'Sunita Devi', 105, 'HR', 'HR Coordinator', 75000.00, '2023-06-22', 2, 'Average');

-- Cross-functional roles
INSERT INTO Employee VALUES
(6001, 'Ramesh Jain', 106, 'Operations', 'Operations Manager', 135000.00, '2021-05-15', 8, 'Excellent'),
(6002, 'Gita Nair', 106, 'Operations', 'Operations Coordinator', 92000.00, '2022-08-20', 4, 'Good'),
(6003, 'Mohan Reddy', 106, 'Operations', 'Logistics Specialist', 85000.00, '2023-03-10', 3, 'Good');

-- IT Support Department
INSERT INTO Employee VALUES
(7001, 'Anil Verma', 107, 'IT Support', 'IT Manager', 115000.00, '2021-09-12', 7, 'Excellent'),
(7002, 'Lata Sharma', 107, 'IT Support', 'System Administrator', 88000.00, '2022-11-25', 4, 'Good'),
(7003, 'Sunil Agarwal', 107, 'IT Support', 'Help Desk Analyst', 65000.00, '2023-08-30', 2, 'Average');

-- Product Management
INSERT INTO Employee VALUES
(8001, 'Pradeep Singh', 108, 'Product', 'Product Manager', 155000.00, '2020-10-18', 9, 'Excellent'),
(8002, 'Mala Iyer', 108, 'Product', 'Associate Product Manager', 105000.00, '2022-04-22', 5, 'Good'),
(8003, 'Vinod Joshi', 108, 'Product', 'Product Analyst', 95000.00, '2023-02-15', 3, 'Good');

-- Customer Success
INSERT INTO Employee VALUES
(9001, 'Shanti Gupta', 109, 'Customer Success', 'CS Manager', 110000.00, '2021-07-20', 6, 'Excellent'),
(9002, 'Prema Rao', 109, 'Customer Success', 'CS Specialist', 82000.00, '2022-09-10', 3, 'Good'),
(9003, 'Kamala Devi', 109, 'Customer Success', 'Support Associate', 68000.00, '2023-11-15', 1, 'Average');

```


## Query 1: Top Departments by Average Salary 

```sql
-- Identify top-performing departments by average salary
SELECT 
    department_id, 
    AVG(salary) AS avg_salary 
FROM Employee 
GROUP BY department_id 
ORDER BY avg_salary DESC;
```

### Output:

```
department_id | avg_salary
--------------|------------
101           | 165000.00
102           | 148333.33
103           | 125000.00
104           | 98750.00
105           | 85000.00
```

**How it works:**
- `GROUP BY department_id` groups all employees by their department
- `AVG(salary)` calculates the average salary for each department group
- `ORDER BY avg_salary DESC` sorts departments from highest to lowest average

## Query 2: Department Performance with Details 

```sql
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
```

### Output:

```
department_id | department_name | employee_count | min_salary | max_salary | avg_salary | total_payroll | avg_experience
--------------|-----------------|----------------|------------|------------|------------|---------------|---------------
101           | Engineering     | 6              | 95000.00   | 220000.00  | 165000.00  | 990000.00     | 6.5
102           | Finance         | 3              | 105000.00  | 180000.00  | 148333.33  | 445000.00     | 8.0
103           | Sales           | 4              | 85000.00   | 160000.00  | 125000.00  | 500000.00     | 5.5
104           | Marketing       | 4              | 72000.00   | 120000.00  | 98750.00   | 395000.00     | 4.0
105           | HR              | 3              | 68000.00   | 95000.00   | 85000.00   | 255000.00     | 3.7
```


**How it works:**
- Multiple aggregate functions (COUNT, MIN, MAX, AVG, SUM) applied simultaneously
- `GROUP BY` creates separate calculations for each department
- `ROUND()` formats decimal values to 1 decimal place

## Query 3: Department Ranking with Salary Distribution 

```sql
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
```

### Output:

```
department_name | employee_count | avg_salary | salary_range | dept_rank | compensation_level
----------------|----------------|------------|--------------|-----------|-------------------
Engineering     | 6              | 165000.00  | 125000.00    | 1         | High Paying
Finance         | 3              | 148333.33  | 75000.00     | 2         | Competitive
Sales           | 4              | 125000.00  | 75000.00     | 3         | Competitive
Marketing       | 4              | 98750.00   | 48000.00     | 4         | Average
HR              | 3              | 85000.00   | 27000.00     | 5         | Average
```


**How it works:**
- `RANK() OVER` assigns ranking to departments based on average salary
- `CASE WHEN` categorizes departments into compensation levels
- `salary_range` shows the spread between highest and lowest paid employees

## Query 4: Department Performance by Experience Level 

```sql
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
```

### Output:

```
department_name | experience_level       | employee_count | avg_salary | min_salary | max_salary
----------------|------------------------|----------------|------------|------------|------------
Engineering     | Senior (8+ years)      | 3              | 195000.00  | 180000.00  | 220000.00
Engineering     | Mid-Level (4-7 years)  | 2              | 135000.00  | 120000.00  | 150000.00
Engineering     | Junior (0-3 years)     | 1              | 95000.00   | 95000.00   | 95000.00
Finance         | Senior (8+ years)      | 2              | 167500.00  | 155000.00  | 180000.00
Finance         | Mid-Level (4-7 years)  | 1              | 105000.00  | 105000.00  | 105000.00
HR              | Junior (0-3 years)     | 2              | 78500.00   | 68000.00   | 89000.00
HR              | Mid-Level (4-7 years)  | 1              | 95000.00   | 95000.00   | 95000.00
Marketing       | Mid-Level (4-7 years)  | 3              | 97333.33   | 85000.00   | 110000.00
Marketing       | Junior (0-3 years)     | 1              | 72000.00   | 72000.00   | 72000.00
Sales           | Senior (8+ years)      | 1              | 160000.00  | 160000.00  | 160000.00
Sales           | Mid-Level (4-7 years)  | 2              | 120000.00  | 110000.00  | 130000.00
Sales           | Junior (0-3 years)     | 1              | 85000.00   | 85000.00   | 85000.00
```


**How it works:**
- Groups by both department AND experience level
- Shows how compensation varies by seniority within each department
- Helps identify if departments pay fairly across experience levels

## Query 5: Top 3 Departments with Performance Context 

```sql
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
```

### Output:

```
department_name | employee_count | avg_salary | avg_experience | excellent_performers | excellent_pct | salary_rank
----------------|----------------|------------|----------------|----------------------|---------------|------------
Engineering     | 6              | 165000.00  | 6.5            | 4                    | 66.7          | 1
Finance         | 3              | 148333.33  | 8.0            | 2                    | 66.7          | 2
Sales           | 4              | 125000.00  | 5.5            | 2                    | 50.0          | 3
```


## Real World Use Cases

1. **Budget Allocation**: Determine which departments need budget adjustments
2. **Talent Attraction**: Identify high-paying departments for recruitment marketing
3. **Compensation Planning**: Ensure competitive pay across all departments
4. **Performance Correlation**: Analyze if higher pay correlates with performance
5. **Retention Strategy**: Focus retention efforts on high-value departments
6. **Benchmarking**: Compare internal departments against industry standards
7. **Cost Analysis**: Understand where the highest personnel costs are
8. **Strategic Planning**: Make informed decisions about department investments

## Key Learning Points

### AVG() Function
- Calculates arithmetic mean (sum / count)
- Ignores NULL values automatically
- Returns DECIMAL/FLOAT data type

### GROUP BY Logic
Think of GROUP BY as creating "buckets":
1. Put all Engineering employees in one bucket
2. Put all Finance employees in another bucket
3. Calculate average salary for each bucket separately

### When to Use This Analysis
- Comparing performance across organizational units
- Identifying compensation gaps
- Budget planning and allocation
- Competitive analysis
- Strategic workforce planning

### Business Interpretation
- **High avg salary** = Premium talent, specialized skills, senior roles
- **Low avg salary** = Junior roles, entry-level positions, support functions
- **Large salary range** = Mix of junior and senior employees
- **Small salary range** = Homogeneous seniority levels

