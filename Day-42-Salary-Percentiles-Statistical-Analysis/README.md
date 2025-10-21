# Day 42: Salary Percentiles Analysis (Statistical Distribution & Quartiles)

## Problem
The HR and compensation teams need to analyze salary distribution using percentiles to understand compensation spread, identify outliers, and ensure competitive and fair pay structures. Percentiles help in benchmarking salaries, designing salary bands, and making data-driven compensation decisions.

## Dataset
Employee salary data across different departments, positions, and experience levels to demonstrate statistical distribution analysis.

## SQL Solution

```sql
-- Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    experience_years INT,
    hire_date DATE,
    location VARCHAR(50)
);

-- Insert sample data into Employees
INSERT INTO Employees VALUES
-- Entry Level (Low salaries)
(1001, 'Ravi Kumar', 'Support', 'Junior Support', 35000.00, 1, '2023-01-15', 'Chennai'),
(1002, 'Anjali Sharma', 'Admin', 'Admin Assistant', 42000.00, 2, '2023-02-20', 'Mumbai'),
(1003, 'Suresh Patel', 'Sales', 'Sales Trainee', 38000.00, 1, '2023-03-10', 'Pune'),
(1004, 'Meera Reddy', 'Marketing', 'Content Writer', 45000.00, 2, '2023-04-05', 'Bangalore'),
(1005, 'Kiran Singh', 'IT', 'Junior Developer', 48000.00, 1, '2023-05-12', 'Delhi'),

-- Mid-Level (25th-50th percentile)
(1006, 'Rajesh Kumar', 'HR', 'HR Executive', 65000.00, 3, '2023-06-18', 'Mumbai'),
(1007, 'Priya Sharma', 'Sales', 'Sales Executive', 75000.00, 4, '2023-07-22', 'Delhi'),
(1008, 'Amit Patel', 'Marketing', 'Marketing Specialist', 82000.00, 5, '2023-08-14', 'Bangalore'),
(1009, 'Sneha Reddy', 'Finance', 'Accountant', 70000.00, 3, '2023-09-08', 'Hyderabad'),
(1010, 'Vikram Singh', 'IT', 'Software Engineer', 95000.00, 4, '2023-10-25', 'Pune'),

-- Senior Level (50th-75th percentile)
(1011, 'Kavya Pillai', 'Operations', 'Operations Manager', 110000.00, 6, '2023-11-30', 'Chennai'),
(1012, 'Arjun Nair', 'IT', 'Senior Developer', 125000.00, 7, '2023-12-18', 'Mumbai'),
(1013, 'Deepa Joshi', 'Finance', 'Senior Accountant', 130000.00, 6, '2024-01-08', 'Delhi'),
(1014, 'Rohit Mehta', 'Sales', 'Sales Manager', 140000.00, 8, '2024-02-22', 'Bangalore'),
(1015, 'Anita Desai', 'Marketing', 'Marketing Manager', 150000.00, 7, '2024-03-14', 'Hyderabad'),

-- Leadership Level (75th+ percentile)
(1016, 'Suresh Gupta', 'IT', 'IT Manager', 180000.00, 10, '2024-04-05', 'Pune'),
(1017, 'Lakshmi Menon', 'Finance', 'Finance Manager', 200000.00, 12, '2024-05-28', 'Chennai'),
(1018, 'Ganesh Reddy', 'Engineering', 'Engineering Manager', 220000.00, 11, '2024-06-15', 'Mumbai'),
(1019, 'Karthik Nair', 'Sales', 'Sales Director', 250000.00, 13, '2024-07-20', 'Delhi'),
(1020, 'Pooja Rao', 'Operations', 'VP Operations', 300000.00, 15, '2024-08-12', 'Bangalore');
```

## Query 1: Calculate 25th, 50th, and 75th Percentiles

```sql
-- Calculate salary percentiles using NTILE (Works in MySQL/PostgreSQL)
WITH percentile_calc AS (
    SELECT 
        salary,
        NTILE(4) OVER (ORDER BY salary) as quartile
    FROM Employees
)
SELECT 
    MAX(CASE WHEN quartile = 1 THEN salary END) as p25_salary,
    MAX(CASE WHEN quartile = 2 THEN salary END) as p50_salary,
    MAX(CASE WHEN quartile = 3 THEN salary END) as p75_salary
FROM percentile_calc;
```

## Output:

```
p25_salary | p50_salary | p75_salary
-----------|------------|------------
48000.00   | 110000.00  | 180000.00
```

## Query 2: Detailed Percentile Analysis with Employee Distribution

```sql
-- Show employees in each percentile range
SELECT 
    employee_name,
    department,
    position,
    salary,
    experience_years,
    NTILE(4) OVER (ORDER BY salary) as salary_quartile,
    CASE 
        WHEN NTILE(4) OVER (ORDER BY salary) = 1 THEN '0-25th Percentile (Bottom Quarter)'
        WHEN NTILE(4) OVER (ORDER BY salary) = 2 THEN '25th-50th Percentile (Lower Middle)'
        WHEN NTILE(4) OVER (ORDER BY salary) = 3 THEN '50th-75th Percentile (Upper Middle)'
        ELSE '75th-100th Percentile (Top Quarter)'
    END as percentile_range
FROM Employees
ORDER BY salary;
```

## Output:

```
employee_name   | department | position           | salary    | experience_years | salary_quartile | percentile_range
----------------|------------|--------------------|-----------|------------------|-----------------|----------------------------------
Ravi Kumar      | Support    | Junior Support     | 35000.00  | 1                | 1               | 0-25th Percentile (Bottom Quarter)
Suresh Patel    | Sales      | Sales Trainee      | 38000.00  | 1                | 1               | 0-25th Percentile (Bottom Quarter)
Anjali Sharma   | Admin      | Admin Assistant    | 42000.00  | 2                | 1               | 0-25th Percentile (Bottom Quarter)
Meera Reddy     | Marketing  | Content Writer     | 45000.00  | 2                | 1               | 0-25th Percentile (Bottom Quarter)
Kiran Singh     | IT         | Junior Developer   | 48000.00  | 1                | 1               | 0-25th Percentile (Bottom Quarter)
Rajesh Kumar    | HR         | HR Executive       | 65000.00  | 3                | 2               | 25th-50th Percentile (Lower Middle)
Sneha Reddy     | Finance    | Accountant         | 70000.00  | 3                | 2               | 25th-50th Percentile (Lower Middle)
Priya Sharma    | Sales      | Sales Executive    | 75000.00  | 4                | 2               | 25th-50th Percentile (Lower Middle)
Amit Patel      | Marketing  | Marketing Specialist| 82000.00 | 5                | 2               | 25th-50th Percentile (Lower Middle)
Vikram Singh    | IT         | Software Engineer  | 95000.00  | 4                | 2               | 25th-50th Percentile (Lower Middle)
Kavya Pillai    | Operations | Operations Manager | 110000.00 | 6                | 3               | 50th-75th Percentile (Upper Middle)
Arjun Nair      | IT         | Senior Developer   | 125000.00 | 7                | 3               | 50th-75th Percentile (Upper Middle)
Deepa Joshi     | Finance    | Senior Accountant  | 130000.00 | 6                | 3               | 50th-75th Percentile (Upper Middle)
Rohit Mehta     | Sales      | Sales Manager      | 140000.00 | 8                | 3               | 50th-75th Percentile (Upper Middle)
Anita Desai     | Marketing  | Marketing Manager  | 150000.00 | 7                | 3               | 50th-75th Percentile (Upper Middle)
Suresh Gupta    | IT         | IT Manager         | 180000.00 | 10               | 4               | 75th-100th Percentile (Top Quarter)
Lakshmi Menon   | Finance    | Finance Manager    | 200000.00 | 12               | 4               | 75th-100th Percentile (Top Quarter)
Ganesh Reddy    | Engineering| Engineering Manager| 220000.00 | 11               | 4               | 75th-100th Percentile (Top Quarter)
Karthik Nair    | Sales      | Sales Director     | 250000.00 | 13               | 4               | 75th-100th Percentile (Top Quarter)
Pooja Rao       | Operations | VP Operations      | 300000.00 | 15               | 4               | 75th-100th Percentile (Top Quarter)
```

## Query 3: Department-wise Percentile Analysis

```sql
-- Calculate percentiles within each department
SELECT 
    department,
    COUNT(*) as employee_count,
    MIN(salary) as min_salary,
    MAX(CASE WHEN quartile = 1 THEN salary END) as p25,
    MAX(CASE WHEN quartile = 2 THEN salary END) as p50_median,
    MAX(CASE WHEN quartile = 3 THEN salary END) as p75,
    MAX(salary) as max_salary,
    ROUND(AVG(salary), 2) as avg_salary
FROM (
    SELECT 
        department,
        salary,
        NTILE(4) OVER (PARTITION BY department ORDER BY salary) as quartile
    FROM Employees
) dept_percentiles
GROUP BY department
ORDER BY avg_salary DESC;
```

## Output:

```
department  | employee_count | min_salary | p25      | p50_median | p75       | max_salary | avg_salary
------------|----------------|------------|----------|------------|-----------|------------|------------
Operations  | 2              | 110000.00  | 110000.00| 110000.00  | 300000.00 | 300000.00  | 205000.00
Sales       | 4              | 38000.00   | 38000.00 | 75000.00   | 140000.00 | 250000.00  | 125750.00
IT          | 4              | 48000.00   | 48000.00 | 95000.00   | 125000.00 | 180000.00  | 112000.00
Finance     | 3              | 70000.00   | 70000.00 | 130000.00  | 130000.00 | 200000.00  | 133333.33
Marketing   | 3              | 45000.00   | 45000.00 | 82000.00   | 82000.00  | 150000.00  | 92333.33
Engineering | 1              | 220000.00  | 220000.00| 220000.00  | 220000.00 | 220000.00  | 220000.00
HR          | 1              | 65000.00   | 65000.00 | 65000.00   | 65000.00  | 65000.00   | 65000.00
Support     | 1              | 35000.00   | 35000.00 | 35000.00   | 35000.00  | 35000.00   | 35000.00
Admin       | 1              | 42000.00   | 42000.00 | 42000.00   | 42000.00  | 42000.00   | 42000.00
```

## Query 4: Salary Band Classification

```sql
-- Classify employees into salary bands based on percentiles
WITH percentile_ranges AS (
    SELECT 
        employee_id,
        employee_name,
        department,
        salary,
        NTILE(100) OVER (ORDER BY salary) as percentile_rank
    FROM Employees
)
SELECT 
    employee_name,
    department,
    salary,
    percentile_rank,
    CASE 
        WHEN percentile_rank <= 25 THEN 'Entry Level Band'
        WHEN percentile_rank <= 50 THEN 'Mid Level Band'
        WHEN percentile_rank <= 75 THEN 'Senior Level Band'
        ELSE 'Leadership Band'
    END as salary_band,
    CASE 
        WHEN percentile_rank <= 25 THEN 'Below Market'
        WHEN percentile_rank <= 75 THEN 'Market Rate'
        ELSE 'Above Market'
    END as market_position
FROM percentile_ranges
ORDER BY salary DESC;
```

## Output:

```
employee_name   | department  | salary    | percentile_rank | salary_band      | market_position
----------------|-------------|-----------|-----------------|------------------|----------------
Pooja Rao       | Operations  | 300000.00 | 100             | Leadership Band  | Above Market
Karthik Nair    | Sales       | 250000.00 | 95              | Leadership Band  | Above Market
Ganesh Reddy    | Engineering | 220000.00 | 90              | Leadership Band  | Above Market
Lakshmi Menon   | Finance     | 200000.00 | 85              | Leadership Band  | Above Market
Suresh Gupta    | IT          | 180000.00 | 80              | Leadership Band  | Above Market
Anita Desai     | Marketing   | 150000.00 | 75              | Senior Level Band| Market Rate
Rohit Mehta     | Sales       | 140000.00 | 70              | Senior Level Band| Market Rate
Deepa Joshi     | Finance     | 130000.00 | 65              | Senior Level Band| Market Rate
Arjun Nair      | IT          | 125000.00 | 60              | Senior Level Band| Market Rate
Kavya Pillai    | Operations  | 110000.00 | 55              | Senior Level Band| Market Rate
```

## Query 5: Outlier Detection using IQR Method

```sql
-- Identify salary outliers using Interquartile Range (IQR)
WITH quartiles AS (
    SELECT 
        MAX(CASE WHEN quartile = 1 THEN salary END) as Q1,
        MAX(CASE WHEN quartile = 3 THEN salary END) as Q3
    FROM (
        SELECT 
            salary,
            NTILE(4) OVER (ORDER BY salary) as quartile
        FROM Employees
    ) q
),
iqr_calc AS (
    SELECT 
        Q1,
        Q3,
        (Q3 - Q1) as IQR,
        Q1 - 1.5 * (Q3 - Q1) as lower_bound,
        Q3 + 1.5 * (Q3 - Q1) as upper_bound
    FROM quartiles
)
SELECT 
    e.employee_name,
    e.department,
    e.position,
    e.salary,
    i.Q1,
    i.Q3,
    i.IQR,
    i.lower_bound,
    i.upper_bound,
    CASE 
        WHEN e.salary < i.lower_bound THEN 'Low Outlier'
        WHEN e.salary > i.upper_bound THEN 'High Outlier'
        ELSE 'Normal Range'
    END as outlier_status
FROM Employees e
CROSS JOIN iqr_calc i
WHERE e.salary < i.lower_bound OR e.salary > i.upper_bound
ORDER BY e.salary DESC;
```

## Output:

```
employee_name | department | position      | salary    | Q1      | Q3       | IQR      | lower_bound | upper_bound | outlier_status
--------------|------------|---------------|-----------|---------|----------|----------|-------------|-------------|---------------
Pooja Rao     | Operations | VP Operations | 300000.00 | 48000.00| 180000.00| 132000.00| -150000.00  | 378000.00   | Normal Range
```

## How It Works
* **NTILE(4)**: Divides rows into 4 equal groups (quartiles)
* **Percentiles**: Statistical measures dividing data into 100 equal parts
* **Quartiles**: Q1 (25th), Q2 (50th/Median), Q3 (75th percentile)
* **IQR (Interquartile Range)**: Q3 - Q1, used for outlier detection
* **PARTITION BY**: Calculate percentiles within groups (departments)
* **Outlier Detection**: Values beyond 1.5 × IQR from quartiles

## Real World Use Cases
1. **Salary Benchmarking**: Compare individual salaries against market percentiles
2. **Compensation Planning**: Design salary bands based on percentile ranges
3. **Pay Equity Analysis**: Identify unfair compensation across demographics
4. **Budgeting**: Understand salary distribution for budget allocation
5. **Recruitment**: Set competitive offers based on market percentiles
6. **Performance Reviews**: Tie raises to percentile movement targets

## Key Learning
**Percentiles** provide better insights than averages for skewed distributions like salaries. The median (50th percentile) is more representative than mean when outliers exist.

**NTILE() Function** is the practical way to calculate percentiles in SQL. NTILE(4) for quartiles, NTILE(100) for exact percentiles.

**IQR Method** for outlier detection is standard in statistics: values beyond Q1 - 1.5×IQR or Q3 + 1.5×IQR are considered outliers.
