# Day 08: Date Functions and Time-Based Analysis (Date Filtering & Time Queries)

## Problem
The HR department needs to analyze employee data based on hiring dates, tenure calculations, and time-based patterns to understand recruitment trends, employee retention, and workforce planning. This problem tests understanding of date functions, time-based filtering, and temporal data analysis.

## Dataset
Employee hiring data with join dates, department information, and salary details across multiple years for trend analysis.

## SQL Solution

```sql
-- Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT,
    status VARCHAR(20)
);

-- Insert sample data into Employees
INSERT INTO Employees VALUES
-- 2023 Hires
(1, 'Rajesh Kumar', 'Engineering', 'Software Engineer', 125000.00, '2023-01-15', 10, 'Active'),
(2, 'Priya Sharma', 'Sales', 'Sales Executive', 85000.00, '2023-02-20', 11, 'Active'),
(3, 'Amit Patel', 'Engineering', 'Senior Developer', 180000.00, '2023-03-10', 10, 'Active'),
(4, 'Sneha Reddy', 'Marketing', 'Marketing Specialist', 95000.00, '2023-04-05', 12, 'Active'),
(5, 'Vikram Singh', 'Finance', 'Financial Analyst', 110000.00, '2023-05-12', 13, 'Active'),
(6, 'Anita Desai', 'HR', 'HR Executive', 75000.00, '2023-06-18', 14, 'Active'),
(7, 'Rohit Mehta', 'Engineering', 'DevOps Engineer', 150000.00, '2023-07-22', 10, 'Active'),
(8, 'Kavya Pillai', 'Sales', 'Account Manager', 120000.00, '2023-08-14', 11, 'Active'),
(9, 'Arjun Nair', 'Marketing', 'Digital Marketer', 88000.00, '2023-09-08', 12, 'Active'),
(10, 'Deepa Joshi', 'Finance', 'Senior Analyst', 135000.00, '2023-10-25', 13, 'Active'),

-- 2022 Hires
(11, 'Suresh Gupta', 'Engineering', 'Tech Lead', 220000.00, '2022-01-10', NULL, 'Active'),
(12, 'Meera Iyer', 'Sales', 'Sales Manager', 200000.00, '2022-03-15', NULL, 'Active'),
(13, 'Karthik Nair', 'Marketing', 'Marketing Manager', 175000.00, '2022-06-20', NULL, 'Active'),
(14, 'Pooja Rao', 'Finance', 'Finance Manager', 190000.00, '2022-08-12', NULL, 'Active'),
(15, 'Ravi Krishnan', 'HR', 'HR Manager', 160000.00, '2022-11-05', NULL, 'Active'),

-- 2024 Hires
(16, 'Sanjay Patel', 'Engineering', 'Junior Developer', 95000.00, '2024-01-08', 11, 'Active'),
(17, 'Neha Agarwal', 'Sales', 'Sales Trainee', 65000.00, '2024-02-14', 12, 'Active'),
(18, 'Arun Kumar', 'Marketing', 'Content Writer', 70000.00, '2024-03-20', 13, 'Active'),

-- 2021 Hires
(19, 'Lakshmi Menon', 'Engineering', 'Senior Architect', 280000.00, '2021-05-10', NULL, 'Active'),
(20, 'Ganesh Reddy', 'Finance', 'CFO', 350000.00, '2021-09-15', NULL, 'Active');
```

## Query 1: Employees Who Joined in 2023 

```sql
-- Retrieve all employees who joined in 2023
SELECT * 
FROM Employees 
WHERE YEAR(hire_date) = 2023;
```

## Output:

```
employee_id | employee_name | department  | position           | salary    | hire_date  | manager_id | status
------------|---------------|-------------|--------------------|-----------|------------|------------|--------
1           | Rajesh Kumar  | Engineering | Software Engineer  | 125000.00 | 2023-01-15 | 10         | Active
2           | Priya Sharma  | Sales       | Sales Executive    | 85000.00  | 2023-02-20 | 11         | Active
3           | Amit Patel    | Engineering | Senior Developer   | 180000.00 | 2023-03-10 | 10         | Active
4           | Sneha Reddy   | Marketing   | Marketing Specialist| 95000.00  | 2023-04-05 | 12         | Active
5           | Vikram Singh  | Finance     | Financial Analyst  | 110000.00 | 2023-05-12 | 13         | Active
6           | Anita Desai   | HR          | HR Executive       | 75000.00  | 2023-06-18 | 14         | Active
7           | Rohit Mehta   | Engineering | DevOps Engineer    | 150000.00 | 2023-07-22 | 10         | Active
8           | Kavya Pillai  | Sales       | Account Manager    | 120000.00 | 2023-08-14 | 11         | Active
9           | Arjun Nair    | Marketing   | Digital Marketer   | 88000.00  | 2023-09-08 | 12         | Active
10          | Deepa Joshi   | Finance     | Senior Analyst     | 135000.00 | 2023-10-25 | 13         | Active
```


## Query 2: Alternative Date Range Filtering 

```sql
-- Same result using date range (shows multiple approaches)
SELECT employee_name, department, position, hire_date, salary
FROM Employees 
WHERE hire_date >= '2023-01-01' 
  AND hire_date <= '2023-12-31'
ORDER BY hire_date;
```

## Output:

```
employee_name | department  | position           | hire_date  | salary
--------------|-------------|--------------------|------------|----------
Rajesh Kumar  | Engineering | Software Engineer  | 2023-01-15 | 125000.00
Priya Sharma  | Sales       | Sales Executive    | 2023-02-20 | 85000.00
Amit Patel    | Engineering | Senior Developer   | 2023-03-10 | 180000.00
Sneha Reddy   | Marketing   | Marketing Specialist| 2023-04-05 | 95000.00
Vikram Singh  | Finance     | Financial Analyst  | 2023-05-12 | 110000.00
Anita Desai   | HR          | HR Executive       | 2023-06-18 | 75000.00
Rohit Mehta   | Engineering | DevOps Engineer    | 2023-07-22 | 150000.00
Kavya Pillai  | Sales       | Account Manager    | 2023-08-14 | 120000.00
Arjun Nair    | Marketing   | Digital Marketer   | 2023-09-08 | 88000.00
Deepa Joshi   | Finance     | Senior Analyst     | 2023-10-25 | 135000.00
```


## Query 3: Monthly Hiring Analysis 

```sql
-- Analyze hiring patterns by month in 2023
SELECT 
    MONTH(hire_date) as hire_month,
    MONTHNAME(hire_date) as month_name,
    COUNT(*) as employees_hired,
    AVG(salary) as avg_salary_hired,
    SUM(salary) as total_salary_cost
FROM Employees 
WHERE YEAR(hire_date) = 2023
GROUP BY MONTH(hire_date), MONTHNAME(hire_date)
ORDER BY hire_month;
```

## Output:

```
hire_month | month_name | employees_hired | avg_salary_hired | total_salary_cost
-----------|------------|-----------------|------------------|------------------
1          | January    | 1               | 125000.00        | 125000.00
2          | February   | 1               | 85000.00         | 85000.00
3          | March      | 1               | 180000.00        | 180000.00
4          | April      | 1               | 95000.00         | 95000.00
5          | May        | 1               | 110000.00        | 110000.00
6          | June       | 1               | 75000.00         | 75000.00
7          | July       | 1               | 150000.00        | 150000.00
8          | August     | 1               | 120000.00        | 120000.00
9          | September  | 1               | 88000.00         | 88000.00
10         | October    | 1               | 135000.00        | 135000.00
```


## Query 4: Employee Tenure Calculation 

```sql
-- Calculate employee tenure and experience levels
SELECT 
    employee_name,
    department,
    hire_date,
    DATEDIFF(CURDATE(), hire_date) as days_employed,
    ROUND(DATEDIFF(CURDATE(), hire_date) / 365.25, 1) as years_employed,
    CASE 
        WHEN DATEDIFF(CURDATE(), hire_date) / 365.25 >= 3 THEN 'Senior'
        WHEN DATEDIFF(CURDATE(), hire_date) / 365.25 >= 1 THEN 'Mid-Level'
        ELSE 'Junior'
    END as experience_level
FROM Employees 
WHERE YEAR(hire_date) = 2023
ORDER BY hire_date;
```

## Output:

```
employee_name | department  | hire_date  | days_employed | years_employed | experience_level
--------------|-------------|------------|---------------|----------------|------------------
Rajesh Kumar  | Engineering | 2023-01-15 | 612           | 1.7            | Mid-Level
Priya Sharma  | Sales       | 2023-02-20 | 576           | 1.6            | Mid-Level
Amit Patel    | Engineering | 2023-03-10 | 558           | 1.5            | Mid-Level
Sneha Reddy   | Marketing   | 2023-04-05 | 532           | 1.5            | Mid-Level
Vikram Singh  | Finance     | 2023-05-12 | 495           | 1.4            | Mid-Level
Anita Desai   | HR          | 2023-06-18 | 458           | 1.3            | Mid-Level
Rohit Mehta   | Engineering | 2023-07-22 | 424           | 1.2            | Mid-Level
Kavya Pillai  | Sales       | 2023-08-14 | 401           | 1.1            | Mid-Level
Arjun Nair    | Marketing   | 2023-09-08 | 376           | 1.0            | Mid-Level
Deepa Joshi   | Finance     | 2023-10-25 | 329           | 0.9            | Junior
```


## Query 5: Yearly Hiring Comparison 

```sql
-- Compare hiring across different years
SELECT 
    YEAR(hire_date) as hire_year,
    COUNT(*) as employees_hired,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    ROUND(AVG(salary), 2) as avg_salary,
    SUM(salary) as total_salary_cost
FROM Employees 
GROUP BY YEAR(hire_date)
ORDER BY hire_year DESC;
```

## Output:

```
hire_year | employees_hired | min_salary | max_salary | avg_salary | total_salary_cost
----------|-----------------|------------|------------|------------|------------------
2024      | 3               | 65000.00   | 95000.00   | 76666.67   | 230000.00
2023      | 10              | 75000.00   | 180000.00  | 116800.00  | 1168000.00
2022      | 5               | 160000.00  | 220000.00  | 189000.00  | 945000.00
2021      | 2               | 280000.00  | 350000.00  | 315000.00  | 630000.00
```


## How It Works
* **YEAR() Function**: Extracts the year from a date column for filtering and grouping
* **Date Range Filtering**: Using >= and <= operators for date ranges
* **MONTH() and MONTHNAME()**: Extract month number and name for temporal analysis
* **DATEDIFF()**: Calculate differences between dates in days
* **Date Arithmetic**: Convert days to years for tenure calculations
* **CURDATE()**: Get current date for dynamic calculations
* **GROUP BY with Date Functions**: Aggregate data by time periods

## Real World Use Cases
1. **Recruitment Analysis**: Track hiring patterns and seasonal trends
2. **Employee Retention**: Calculate tenure and identify retention patterns
3. **Budget Planning**: Analyze salary costs by hiring periods
4. **Performance Reviews**: Schedule reviews based on hiring anniversaries
5. **Workforce Planning**: Predict future hiring needs based on historical data
6. **Compliance Reporting**: Generate reports for specific time periods

## Key Learning
**Date Functions** are essential for time-based analysis in business data. YEAR(), MONTH(), and DATEDIFF() are the most commonly used functions that allow you to filter, group, and calculate temporal metrics.

**Multiple Filtering Approaches**: YEAR(hire_date) = 2023 and date range filtering (hire_date BETWEEN '2023-01-01' AND '2023-12-31') achieve the same result. Knowing both approaches shows SQL flexibility.

**Temporal Business Logic**: Combining date calculations with CASE statements enables business rules like experience levels, tenure categories, and time-based classifications that drive HR decisions.
