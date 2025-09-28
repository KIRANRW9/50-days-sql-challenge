# Day 18: Employee Salary Ranking with Window Functions (RANK and PARTITION BY)

## Problem
The HR department needs to rank employees by salary within each department to identify top performers, plan promotions, and ensure equitable compensation structures. This analysis helps in performance evaluation, budget allocation, and talent retention strategies. This problem tests understanding of window functions, RANK() OVER clause, and PARTITION BY for departmental analysis.

## Dataset
Employee salary data across multiple departments with comprehensive information for ranking and comparative analysis within organizational units.

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
    manager_id INT
);

-- Create Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    budget DECIMAL(12,2),
    head_count INT
);
```

## Query 1: Basic Salary Ranking by Department

```sql
SELECT
    employee_id, 
    employee_name,
    department_id, 
    department_name,
    salary,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
FROM Employee
ORDER BY department_id, salary_rank;
```

### Output:

```
employee_id | employee_name | department_id | department_name | salary    | salary_rank
------------|---------------|---------------|-----------------|-----------|------------
101         | Rajesh Kumar  | 1             | Engineering     | 180000.00 | 1
102         | Amit Patel    | 1             | Engineering     | 150000.00 | 2
103         | Sneha Reddy   | 1             | Engineering     | 120000.00 | 3
104         | Karthik Nair  | 1             | Engineering     | 95000.00  | 4
201         | Priya Sharma  | 2             | Sales           | 140000.00 | 1
202         | Vikram Singh  | 2             | Sales           | 110000.00 | 2
203         | Anita Desai   | 2             | Sales           | 85000.00  | 3
204         | Rohit Mehta   | 2             | Sales           | 75000.00  | 4
301         | Deepa Joshi   | 3             | Marketing       | 130000.00 | 1
302         | Arjun Nair    | 3             | Marketing       | 100000.00 | 2
303         | Kavya Pillai  | 3             | Marketing       | 88000.00  | 3
401         | Suresh Gupta  | 4             | Finance         | 160000.00 | 1
402         | Meera Iyer    | 4             | Finance         | 125000.00 | 2
403         | Pooja Rao     | 4             | Finance         | 105000.00 | 3
```

## Query 2: Top 3 Highest Paid Employees per Department

```sql
SELECT 
    employee_id,
    employee_name,
    department_name,
    position,
    salary,
    salary_rank
FROM (
    SELECT
        employee_id,
        employee_name,
        department_name,
        position,
        salary,
        RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM Employee
) ranked_employees
WHERE salary_rank <= 3
ORDER BY department_name, salary_rank;
```

### Output:

```
employee_id | employee_name | department_name | position           | salary    | salary_rank
------------|---------------|-----------------|-------------------|-----------|------------
101         | Rajesh Kumar  | Engineering     | Tech Lead         | 180000.00 | 1
102         | Amit Patel    | Engineering     | Senior Developer  | 150000.00 | 2
103         | Sneha Reddy   | Engineering     | Software Engineer | 120000.00 | 3
401         | Suresh Gupta  | Finance         | Finance Manager   | 160000.00 | 1
402         | Meera Iyer    | Finance         | Senior Analyst    | 125000.00 | 2
403         | Pooja Rao     | Finance         | Financial Analyst | 105000.00 | 3
301         | Deepa Joshi   | Marketing       | Marketing Manager | 130000.00 | 1
302         | Arjun Nair    | Marketing       | Marketing Exec    | 100000.00 | 2
303         | Kavya Pillai  | Marketing       | Content Specialist| 88000.00  | 3
201         | Priya Sharma  | Sales           | Sales Manager     | 140000.00 | 1
202         | Vikram Singh  | Sales           | Senior Sales Rep  | 110000.00 | 2
203         | Anita Desai   | Sales           | Sales Executive   | 85000.00  | 3
```

## Query 3: Salary Ranking with Percentile Analysis

```sql
SELECT 
    employee_id,
    employee_name,
    department_name,
    salary,
    RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) as salary_rank,
    DENSE_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) as dense_rank,
    ROUND(PERCENT_RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) * 100, 1) as percentile_rank,
    NTILE(4) OVER (PARTITION BY department_id ORDER BY salary DESC) as salary_quartile
FROM Employee
ORDER BY department_name, salary DESC;
```

### Output:

```
employee_id | employee_name | department_name | salary    | salary_rank | dense_rank | percentile_rank | salary_quartile
------------|---------------|-----------------|-----------|-------------|------------|-----------------|----------------
101         | Rajesh Kumar  | Engineering     | 180000.00 | 1           | 1          | 0.0             | 1
102         | Amit Patel    | Engineering     | 150000.00 | 2           | 2          | 33.3            | 1
103         | Sneha Reddy   | Engineering     | 120000.00 | 3           | 3          | 66.7            | 2
104         | Karthik Nair  | Engineering     | 95000.00  | 4           | 4          | 100.0           | 2
401         | Suresh Gupta  | Finance         | 160000.00 | 1           | 1          | 0.0             | 1
402         | Meera Iyer    | Finance         | 125000.00 | 2           | 2          | 50.0            | 2
403         | Pooja Rao     | Finance         | 105000.00 | 3           | 3          | 100.0           | 2
301         | Deepa Joshi   | Marketing       | 130000.00 | 1           | 1          | 0.0             | 1
302         | Arjun Nair    | Marketing       | 100000.00 | 2           | 2          | 50.0            | 2
303         | Kavya Pillai  | Marketing       | 88000.00  | 3           | 3          | 100.0           | 2
201         | Priya Sharma  | Sales           | 140000.00 | 1           | 1          | 0.0             | 1
202         | Vikram Singh  | Sales           | 110000.00 | 2           | 2          | 33.3            | 1
203         | Anita Desai   | Sales           | 85000.00  | 3           | 3          | 66.7            | 2
204         | Rohit Mehta   | Sales           | 75000.00  | 4           | 4          | 100.0           | 2
```

## Query 4: Department Salary Statistics with Rankings

```sql
SELECT 
    d.department_name,
    COUNT(e.employee_id) as total_employees,
    ROUND(AVG(e.salary), 2) as avg_salary,
    MIN(e.salary) as min_salary,
    MAX(e.salary) as max_salary,
    (MAX(e.salary) - MIN(e.salary)) as salary_range,
    RANK() OVER (ORDER BY AVG(e.salary) DESC) as dept_avg_salary_rank,
    RANK() OVER (ORDER BY COUNT(e.employee_id) DESC) as dept_size_rank
FROM Departments d
LEFT JOIN Employee e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
ORDER BY avg_salary DESC;
```

### Output:

```
department_name | total_employees | avg_salary | min_salary | max_salary | salary_range | dept_avg_salary_rank | dept_size_rank
----------------|-----------------|------------|------------|------------|--------------|---------------------|----------------
Engineering     | 4               | 136250.00  | 95000.00   | 180000.00  | 85000.00     | 1                   | 1
Finance         | 3               | 130000.00  | 105000.00  | 160000.00  | 55000.00     | 2                   | 2
Marketing       | 3               | 106000.00  | 88000.00   | 130000.00  | 42000.00     | 3                   | 2
Sales           | 4               | 102500.00  | 75000.00   | 140000.00  | 65000.00     | 4                   | 1
```

## Query 5: Employee Performance Tiers and Salary Gap Analysis

```sql
SELECT 
    employee_id,
    employee_name,
    department_name,
    salary,
    salary_rank,
    CASE 
        WHEN salary_rank = 1 THEN 'Top Performer'
        WHEN salary_rank <= 3 THEN 'High Performer'
        WHEN salary_rank <= 5 THEN 'Average Performer'
        ELSE 'Below Average'
    END as performance_tier,
    salary - LAG(salary) OVER (PARTITION BY department_id ORDER BY salary DESC) as salary_gap_above,
    LEAD(salary) OVER (PARTITION BY department_id ORDER BY salary DESC) - salary as salary_gap_below,
    salary - AVG(salary) OVER (PARTITION BY department_id) as salary_vs_dept_avg
FROM (
    SELECT
        employee_id,
        employee_name,
        department_id,
        department_name,
        salary,
        RANK() OVER (PARTITION BY department_id ORDER BY salary DESC) AS salary_rank
    FROM Employee
) ranked_emp
ORDER BY department_name, salary DESC;
```

### Output:

```
employee_id | employee_name | department_name | salary    | salary_rank | performance_tier | salary_gap_above | salary_gap_below | salary_vs_dept_avg
------------|---------------|-----------------|-----------|-------------|------------------|------------------|------------------|-------------------
101         | Rajesh Kumar  | Engineering     | 180000.00 | 1           | Top Performer    | NULL             | -30000.00        | 43750.00
102         | Amit Patel    | Engineering     | 150000.00 | 2           | High Performer   | -30000.00        | -30000.00        | 13750.00
103         | Sneha Reddy   | Engineering     | 120000.00 | 3           | High Performer   | -30000.00        | -25000.00        | -16250.00
104         | Karthik Nair  | Engineering     | 95000.00  | 4           | Average Performer| -25000.00        | NULL             | -41250.00
401         | Suresh Gupta  | Finance         | 160000.00 | 1           | Top Performer    | NULL             | -35000.00        | 30000.00
402         | Meera Iyer    | Finance         | 125000.00 | 2           | High Performer   | -35000.00        | -20000.00        | -5000.00
403         | Pooja Rao     | Finance         | 105000.00 | 3           | High Performer   | -20000.00        | NULL             | -25000.00
301         | Deepa Joshi   | Marketing       | 130000.00 | 1           | Top Performer    | NULL             | -30000.00        | 24000.00
302         | Arjun Nair    | Marketing       | 100000.00 | 2           | High Performer   | -30000.00        | -12000.00        | -6000.00
303         | Kavya Pillai  | Marketing       | 88000.00  | 3           | High Performer   | -12000.00        | NULL             | -18000.00
201         | Priya Sharma  | Sales           | 140000.00 | 1           | Top Performer    | NULL             | -30000.00        | 37500.00
202         | Vikram Singh  | Sales           | 110000.00 | 2           | High Performer   | -30000.00        | -25000.00        | 7500.00
203         | Anita Desai   | Sales           | 85000.00  | 3           | High Performer   | -25000.00        | -10000.00        | -17500.00
204         | Rohit Mehta   | Sales           | 75000.00  | 4           | Average Performer| -10000.00        | NULL             | -27500.00
```

## How It Works

### Window Functions Explained
* **RANK() OVER()**: Assigns ranking with gaps after tied values (1, 2, 2, 4)
* **DENSE_RANK() OVER()**: Assigns ranking without gaps after tied values (1, 2, 2, 3)  
* **PARTITION BY**: Divides result set into groups for separate ranking calculations
* **ORDER BY in Window Functions**: Determines the ranking criteria (DESC for highest first)
* **PERCENT_RANK()**: Calculates relative rank as percentage (0 to 1, multiplied by 100)
* **NTILE(n)**: Divides rows into n equal groups (quartiles, deciles, etc.)

### Advanced Window Functions
* **LAG()/LEAD()**: Access previous/next row values for gap analysis
* **AVG() OVER()**: Calculate department averages for comparison
* **Subqueries with Window Functions**: Use ranking results for further filtering

## Real World Use Cases

1. **Performance Reviews**: Identify top performers within each department
2. **Promotion Planning**: Find employees ready for advancement based on rankings
3. **Salary Benchmarking**: Compare individual salaries against department peers
4. **Budget Planning**: Analyze salary distribution for compensation planning
5. **Talent Retention**: Identify high performers who might need retention incentives
6. **Pay Equity Analysis**: Ensure fair compensation within departments
7. **Succession Planning**: Identify potential leaders in each department
8. **Department Comparison**: Compare salary structures across organizational units

## Key Learning Points

### Understanding Window Functions vs GROUP BY
**Window Functions** preserve all rows while adding analytical insights, whereas **GROUP BY** collapses rows into summary groups. Use window functions when you need row-level detail with comparative analysis.

### RANK vs DENSE_RANK
- **RANK()**: Leaves gaps after ties (1, 2, 2, 4, 5...)
- **DENSE_RANK()**: No gaps after ties (1, 2, 2, 3, 4...)
- Choose based on how you want to handle tied salaries in business logic

### PARTITION BY Benefits
- Creates separate ranking groups for each department
- Enables fair comparison within organizational units
- Prevents cross-department ranking distortions
- Essential for departmental performance analysis

## Business Applications

These salary ranking queries enable HR departments to make data-driven decisions about compensation, promotions, and organizational structure. The combination of rankings, percentiles, and gap analysis provides comprehensive insights for strategic talent management and equitable compensation practices.

