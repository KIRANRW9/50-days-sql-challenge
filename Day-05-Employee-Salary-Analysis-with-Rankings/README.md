# Day 05: Employee Salary Analysis with Rankings (Window Functions & Advanced Aggregations)

## Problem
The HR department needs to analyze employee salary data to understand compensation distribution, identify top performers by department, calculate salary rankings, and generate comprehensive salary reports for budget planning and compensation reviews. This problem tests understanding of window functions, advanced GROUP BY operations, and ranking functions.

## Dataset
Employee data with salary information across different departments and positions, including hire dates and performance metrics.

## SQL Solution

```sql
-- Create Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    budget DECIMAL(12,2),
    head_of_department VARCHAR(100)
);

-- Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT
);

-- Insert sample data into Departments
INSERT INTO Departments VALUES
(1, 'Engineering', 5000000.00, 'Rajesh Kumar'),
(2, 'Sales', 3000000.00, 'Priya Sharma'),
(3, 'Marketing', 1500000.00, 'Anita Desai'),
(4, 'HR', 1200000.00, 'Suresh Gupta'),
(5, 'Finance', 2500000.00, 'Meera Iyer');

-- Insert sample data into Employees
INSERT INTO Employees VALUES
(1, 'Rajesh Kumar', 'Engineering', 'Engineering Manager', 350000.00, '2020-01-15', NULL),
(2, 'Amit Patel', 'Engineering', 'Senior Architect', 280000.00, '2020-03-20', 1),
(3, 'Sneha Reddy', 'Engineering', 'Senior Developer', 220000.00, '2021-06-10', 1),
(4, 'Karthik Nair', 'Engineering', 'Developer', 120000.00, '2023-02-14', 2),
(5, 'Priya Sharma', 'Sales', 'Sales Director', 320000.00, '2019-11-05', NULL),
(6, 'Vikram Singh', 'Sales', 'Senior Sales Manager', 180000.00, '2021-01-20', 5),
(7, 'Ritu Agarwal', 'Sales', 'Sales Executive', 85000.00, '2022-09-12', 6),
(8, 'Anita Desai', 'Marketing', 'Marketing Manager', 150000.00, '2020-07-08', NULL),
(9, 'Rohit Mehta', 'Marketing', 'Digital Marketing Specialist', 95000.00, '2022-04-18', 8),
(10, 'Kavya Pillai', 'Marketing', 'Content Writer', 65000.00, '2023-08-22', 8),
(11, 'Suresh Gupta', 'HR', 'HR Manager', 140000.00, '2020-10-12', NULL),
(12, 'Deepa Joshi', 'HR', 'HR Executive', 75000.00, '2022-12-05', 11),
(13, 'Meera Iyer', 'Finance', 'Finance Manager', 200000.00, '2019-08-30', NULL),
(14, 'Arjun Krishnan', 'Finance', 'Senior Accountant', 130000.00, '2021-11-15', 13),
(15, 'Pooja Rao', 'Finance', 'Financial Analyst', 100000.00, '2023-05-20', 13);
```

## Query 1: Top 3 Highest Paid Employees

```sql
SELECT 
    employee_name,
    department,
    position,
    salary
FROM Employees
ORDER BY salary DESC
LIMIT 3;
```

### Output:

```
employee_name        | department  | position           | salary
--------------------|-------------|--------------------|-----------
Rajesh Kumar        | Engineering | Engineering Manager| 350000.00
Priya Sharma        | Sales       | Sales Director     | 320000.00
Amit Patel          | Engineering | Senior Architect   | 280000.00
```

## Query 2: Salary Rankings by Department

```sql
SELECT 
    employee_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) as rank,
    DENSE_RANK() OVER (PARTITION BY department ORDER BY salary DESC) as dense_rank
FROM Employees
ORDER BY department, salary DESC;
```

### Output:

```
employee_name    | department  | salary    | rank | dense_rank
-----------------|-------------|-----------|------|------------
Rajesh Kumar     | Engineering | 350000.00 | 1    | 1
Amit Patel       | Engineering | 280000.00 | 2    | 2
Sneha Reddy      | Engineering | 220000.00 | 3    | 3
Karthik Nair     | Engineering | 120000.00 | 4    | 4
Meera Iyer       | Finance     | 200000.00 | 1    | 1
Arjun Krishnan   | Finance     | 130000.00 | 2    | 2
Pooja Rao        | Finance     | 100000.00 | 3    | 3
Suresh Gupta     | HR          | 140000.00 | 1    | 1
Deepa Joshi      | HR          | 75000.00  | 2    | 2
Anita Desai      | Marketing   | 150000.00 | 1    | 1
Rohit Mehta      | Marketing   | 95000.00  | 2    | 2
Kavya Pillai     | Marketing   | 65000.00  | 3    | 3
Priya Sharma     | Sales       | 320000.00 | 1    | 1
Vikram Singh     | Sales       | 180000.00 | 2    | 2
Ritu Agarwal     | Sales       | 85000.00  | 3    | 3
```

## Query 3: Department Salary Statistics

```sql
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
```

### Output:

```
department  | employee_count | min_salary | max_salary | avg_salary | total_salary
------------|----------------|------------|------------|------------|-------------
Engineering | 4              | 120000.00  | 350000.00  | 242500.00  | 970000.00
Sales       | 3              | 85000.00   | 320000.00  | 195000.00  | 585000.00
Finance     | 3              | 100000.00  | 200000.00  | 143333.33  | 430000.00
Marketing   | 3              | 65000.00   | 150000.00  | 103333.33  | 310000.00
HR          | 2              | 75000.00   | 140000.00  | 107500.00  | 215000.00
```

## Query 4: Employees Above Department Average

```sql
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
```

### Output:

```
employee_name    | department  | salary    | dept_avg_salary | difference
-----------------|-------------|-----------|-----------------|------------
Priya Sharma     | Sales       | 320000.00 | 195000.00       | 125000.00
Rajesh Kumar     | Engineering | 350000.00 | 242500.00       | 107500.00
Meera Iyer       | Finance     | 200000.00 | 143333.33       | 56666.67
Anita Desai      | Marketing   | 150000.00 | 103333.33       | 46666.67
Amit Patel       | Engineering | 280000.00 | 242500.00       | 37500.00
Suresh Gupta     | HR          | 140000.00 | 107500.00       | 32500.00
```

## Query 5: Salary Percentiles and Quartiles

```sql
SELECT 
    employee_name,
    department,
    salary,
    NTILE(4) OVER (ORDER BY salary) as salary_quartile,
    ROUND(PERCENT_RANK() OVER (ORDER BY salary) * 100, 2) as percentile_rank
FROM Employees
ORDER BY salary DESC;
```

### Output:

```
employee_name    | department  | salary    | salary_quartile | percentile_rank
-----------------|-------------|-----------|-----------------|----------------
Rajesh Kumar     | Engineering | 350000.00 | 4               | 100.00
Priya Sharma     | Sales       | 320000.00 | 4               | 92.86
Amit Patel       | Engineering | 280000.00 | 4               | 85.71
Sneha Reddy      | Engineering | 220000.00 | 4               | 78.57
Meera Iyer       | Finance     | 200000.00 | 3               | 71.43
Vikram Singh     | Sales       | 180000.00 | 3               | 64.29
Anita Desai      | Marketing   | 150000.00 | 3               | 57.14
Suresh Gupta     | HR          | 140000.00 | 3               | 50.00
Arjun Krishnan   | Finance     | 130000.00 | 2               | 42.86
Karthik Nair     | Engineering | 120000.00 | 2               | 35.71
Pooja Rao        | Finance     | 100000.00 | 2               | 28.57
Rohit Mehta      | Marketing   | 95000.00  | 2               | 21.43
Ritu Agarwal     | Sales       | 85000.00  | 1               | 14.29
Deepa Joshi      | HR          | 75000.00  | 1               | 7.14
Kavya Pillai     | Marketing   | 65000.00  | 1               | 0.00
```

## Bonus Query 6: Running Salary Totals by Department

```sql
SELECT 
    employee_name,
    department,
    salary,
    SUM(salary) OVER (
        PARTITION BY department 
        ORDER BY salary DESC 
        ROWS UNBOUNDED PRECEDING
    ) as running_total,
    ROUND(
        salary * 100.0 / SUM(salary) OVER (PARTITION BY department), 2
    ) as salary_percentage_of_dept
FROM Employees
ORDER BY department, salary DESC;
```

### Output:

```
employee_name    | department  | salary    | running_total | salary_percentage_of_dept
-----------------|-------------|-----------|---------------|-------------------------
Rajesh Kumar     | Engineering | 350000.00 | 350000.00     | 36.08
Amit Patel       | Engineering | 280000.00 | 630000.00     | 28.87
Sneha Reddy      | Engineering | 220000.00 | 850000.00     | 22.68
Karthik Nair     | Engineering | 120000.00 | 970000.00     | 12.37
Meera Iyer       | Finance     | 200000.00 | 200000.00     | 46.51
Arjun Krishnan   | Finance     | 130000.00 | 330000.00     | 30.23
Pooja Rao        | Finance     | 100000.00 | 430000.00     | 23.26
Suresh Gupta     | HR          | 140000.00 | 140000.00     | 65.12
Deepa Joshi      | HR          | 75000.00  | 215000.00     | 34.88
Anita Desai      | Marketing   | 150000.00 | 150000.00     | 48.39
Rohit Mehta      | Marketing   | 95000.00  | 245000.00     | 30.65
Kavya Pillai     | Marketing   | 65000.00  | 310000.00     | 20.97
Priya Sharma     | Sales       | 320000.00 | 320000.00     | 54.70
Vikram Singh     | Sales       | 180000.00 | 500000.00     | 30.77
Ritu Agarwal     | Sales       | 85000.00  | 585000.00     | 14.53
```

## Bonus Query 7: Salary Comparison with Previous and Next Employee

```sql
SELECT 
    employee_name,
    department,
    salary,
    LAG(salary, 1) OVER (ORDER BY salary DESC) as higher_salary,
    LEAD(salary, 1) OVER (ORDER BY salary DESC) as lower_salary,
    salary - LAG(salary, 1) OVER (ORDER BY salary DESC) as gap_above,
    LEAD(salary, 1) OVER (ORDER BY salary DESC) - salary as gap_below
FROM Employees
ORDER BY salary DESC;
```

### Output:

```
employee_name    | department  | salary    | higher_salary | lower_salary | gap_above  | gap_below
-----------------|-------------|-----------|---------------|--------------|------------|----------
Rajesh Kumar     | Engineering | 350000.00 | NULL          | 320000.00    | NULL       | -30000.00
Priya Sharma     | Sales       | 320000.00 | 350000.00     | 280000.00    | -30000.00  | -40000.00
Amit Patel       | Engineering | 280000.00 | 320000.00     | 220000.00    | -40000.00  | -60000.00
Sneha Reddy      | Engineering | 220000.00 | 280000.00     | 200000.00    | -60000.00  | -20000.00
Meera Iyer       | Finance     | 200000.00 | 220000.00     | 180000.00    | -20000.00  | -20000.00
Vikram Singh     | Sales       | 180000.00 | 200000.00     | 150000.00    | -20000.00  | -30000.00
Anita Desai      | Marketing   | 150000.00 | 180000.00     | 140000.00    | -30000.00  | -10000.00
Suresh Gupta     | HR          | 140000.00 | 150000.00     | 130000.00    | -10000.00  | -10000.00
Arjun Krishnan   | Finance     | 130000.00 | 140000.00     | 120000.00    | -10000.00  | -10000.00
Karthik Nair     | Engineering | 120000.00 | 130000.00     | 100000.00    | -10000.00  | -20000.00
Pooja Rao        | Finance     | 100000.00 | 120000.00     | 95000.00     | -20000.00  | -5000.00
Rohit Mehta      | Marketing   | 95000.00  | 100000.00     | 85000.00     | -5000.00   | -10000.00
Ritu Agarwal     | Sales       | 85000.00  | 95000.00      | 75000.00     | -10000.00  | -10000.00
Deepa Joshi      | HR          | 75000.00  | 85000.00      | 65000.00     | -10000.00  | -10000.00
Kavya Pillai     | Marketing   | 65000.00  | 75000.00      | NULL         | -10000.00  | NULL
```

## How It Works

### Window Functions Explained
* **RANK()**: Assigns ranking with gaps after tied values (1, 2, 2, 4)
* **DENSE_RANK()**: Assigns ranking without gaps after tied values (1, 2, 2, 3)
* **ROW_NUMBER()**: Assigns unique sequential numbers regardless of ties
* **PARTITION BY**: Divides result set into partitions for window function calculations
* **ORDER BY with Window Functions**: Determines the ranking order within each partition
* **NTILE(n)**: Divides rows into n equal groups (quartiles, deciles, etc.)
* **PERCENT_RANK()**: Calculates relative rank as percentage (0 to 1)

### Advanced Window Functions
* **LAG()/LEAD()**: Access previous/next row values in ordered result set
* **SUM() OVER()**: Running totals and cumulative calculations
* **ROWS UNBOUNDED PRECEDING**: Frame clause for running calculations

### Aggregation Techniques
* **GROUP BY**: Groups rows for aggregate calculations
* **Subqueries with JOINs**: Compare individual values with group aggregates
* **Multiple aggregate functions**: MIN, MAX, AVG, SUM, COUNT in single query

## Real World Use Cases

1. **Salary Benchmarking**: Compare employee salaries within departments and across the organization
2. **Budget Planning**: Analyze total compensation costs by department for budget allocation
3. **Performance Reviews**: Identify top performers by compensation and plan salary adjustments
4. **Equity Analysis**: Ensure fair compensation distribution across departments and roles
5. **Promotion Planning**: Identify employees ready for salary increases based on rankings
6. **Department Comparison**: Compare compensation structures across different teams
7. **Compensation Bands**: Create salary bands and quartiles for structured pay scales
8. **Market Analysis**: Compare internal salaries with market rates using percentile rankings

## Key Learning Points

### Window Functions vs GROUP BY
**Window Functions** preserve all rows while adding analytical insights, whereas **GROUP BY** collapses rows into summary groups. Use window functions when you need row-level detail with comparative analysis.

### Understanding Rankings
- **RANK()**: Leaves gaps after ties (1, 2, 2, 4, 5...)
- **DENSE_RANK()**: No gaps after ties (1, 2, 2, 3, 4...)  
- **ROW_NUMBER()**: Always unique (1, 2, 3, 4, 5...)

Choose based on how you want to handle tied values in your business logic.

### Performance Considerations
- Window functions can be resource-intensive on large datasets
- Consider indexing on columns used in PARTITION BY and ORDER BY clauses
- Use LIMIT when you only need top/bottom N records
- Combine multiple analytics in single query rather than multiple separate queries

### Business Intelligence Applications
These queries form the foundation of HR analytics dashboards, enabling data-driven decisions about compensation, budgeting, and organizational structure. The combination of rankings, percentiles, and comparative analysis provides comprehensive salary insights for strategic planning.

## Advanced Extensions

Consider extending this analysis with:
- Time-based salary progression analysis using hire_date
- Manager vs direct report salary comparisons using manager_id
- Cross-departmental mobility analysis
- Salary growth projections and forecasting
- Integration with performance metrics for compensation planning
