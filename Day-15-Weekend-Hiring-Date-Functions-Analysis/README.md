# Day 15: Weekend Hiring Analysis with Date Functions (DAYNAME and WEEKDAY Functions)

## Problem
The HR department needs to analyze hiring patterns to understand when employees are being onboarded, identify unusual hiring practices (like weekend hiring), and optimize HR processes. Weekend hiring might indicate emergency recruitment, different hiring practices across regions, or data entry errors. This problem tests understanding of date functions, weekday extraction, and pattern analysis in hiring data.

## Dataset
Employee hiring data with comprehensive information about hire dates, departments, and positions to analyze weekend vs weekday hiring patterns.

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
    region VARCHAR(50),
    employment_type VARCHAR(20)
);

-- Insert sample data into Employees
INSERT INTO Employees VALUES
-- Regular weekday hires
(1001, 'Rajesh Kumar', 'Engineering', 'Software Engineer', 125000.00, '2024-01-15', 2001, 'North', 'Full-time'),      -- Monday
(1002, 'Priya Sharma', 'Sales', 'Sales Executive', 85000.00, '2024-01-16', 2002, 'South', 'Full-time'),            -- Tuesday
(1003, 'Amit Patel', 'Marketing', 'Marketing Specialist', 95000.00, '2024-01-17', 2003, 'East', 'Full-time'),       -- Wednesday
(1004, 'Sneha Reddy', 'Finance', 'Financial Analyst', 110000.00, '2024-01-18', 2004, 'West', 'Full-time'),         -- Thursday
(1005, 'Vikram Singh', 'HR', 'HR Executive', 75000.00, '2024-01-19', 2005, 'North', 'Full-time'),                  -- Friday

-- Weekend hires (Saturday)
(1006, 'Anita Desai', 'Engineering', 'DevOps Engineer', 140000.00, '2024-01-20', 2001, 'South', 'Contract'),       -- Saturday
(1007, 'Rohit Mehta', 'Sales', 'Sales Manager', 150000.00, '2024-01-27', 2002, 'East', 'Contract'),                -- Saturday
(1008, 'Kavya Pillai', 'IT Support', 'System Administrator', 90000.00, '2024-02-03', 2006, 'West', 'Part-time'),   -- Saturday

-- Weekend hires (Sunday)
(1009, 'Arjun Nair', 'Customer Service', 'Support Specialist', 65000.00, '2024-01-21', 2007, 'North', 'Contract'),  -- Sunday
(1010, 'Deepa Joshi', 'Engineering', 'Senior Developer', 180000.00, '2024-01-28', 2001, 'South', 'Full-time'),     -- Sunday
(1011, 'Suresh Gupta', 'Operations', 'Operations Manager', 160000.00, '2024-02-04', 2008, 'East', 'Full-time'),    -- Sunday

-- More regular weekday hires
(1012, 'Meera Iyer', 'Finance', 'Senior Accountant', 130000.00, '2024-02-05', 2004, 'West', 'Full-time'),          -- Monday
(1013, 'Karthik Nair', 'Marketing', 'Digital Marketer', 88000.00, '2024-02-06', 2003, 'North', 'Full-time'),       -- Tuesday
(1014, 'Pooja Rao', 'HR', 'Recruiter', 80000.00, '2024-02-07', 2005, 'South', 'Full-time'),                       -- Wednesday

-- Additional weekend hires
(1015, 'Ravi Krishnan', 'Security', 'Security Officer', 55000.00, '2024-02-10', 2009, 'East', 'Contract'),         -- Saturday
(1016, 'Lakshmi Menon', 'Maintenance', 'Facility Manager', 70000.00, '2024-02-11', 2010, 'West', 'Part-time'),     -- Sunday

-- Recent weekday hires
(1017, 'Ganesh Reddy', 'Engineering', 'Tech Lead', 220000.00, '2024-02-12', 2001, 'North', 'Full-time'),           -- Monday
(1018, 'Sanjay Patel', 'Sales', 'Account Executive', 92000.00, '2024-02-13', 2002, 'South', 'Full-time'),          -- Tuesday
(1019, 'Neha Agarwal', 'Marketing', 'Content Writer', 72000.00, '2024-02-14', 2003, 'East', 'Full-time'),          -- Wednesday
(1020, 'Arun Kumar', 'Finance', 'Financial Controller', 200000.00, '2024-02-15', 2004, 'West', 'Full-time');       -- Thursday
```

## Query 1: Find All Employees Hired on Weekends 

```sql
-- Find employees hired on Saturday or Sunday 
SELECT * 
FROM Employees 
WHERE DAYNAME(hire_date) IN ('Saturday', 'Sunday')
ORDER BY hire_date;
```

## Output:

```
employee_id | employee_name   | department      | position             | salary    | hire_date  | manager_id | region | employment_type
------------|-----------------|-----------------|---------------------|-----------|------------|------------|--------|----------------
1006        | Anita Desai     | Engineering     | DevOps Engineer     | 140000.00 | 2024-01-20 | 2001       | South  | Contract
1009        | Arjun Nair      | Customer Service| Support Specialist  | 65000.00  | 2024-01-21 | 2007       | North  | Contract
1007        | Rohit Mehta     | Sales           | Sales Manager       | 150000.00 | 2024-01-27 | 2002       | East   | Contract
1010        | Deepa Joshi     | Engineering     | Senior Developer    | 180000.00 | 2024-01-28 | 2001       | South  | Full-time
1008        | Kavya Pillai    | IT Support      | System Administrator| 90000.00  | 2024-02-03 | 2006       | West   | Part-time
1011        | Suresh Gupta    | Operations      | Operations Manager  | 160000.00 | 2024-02-04 | 2008       | East   | Full-time
1015        | Ravi Krishnan   | Security        | Security Officer    | 55000.00  | 2024-02-10 | 2009       | East   | Contract
1016        | Lakshmi Menon   | Maintenance     | Facility Manager    | 70000.00  | 2024-02-11 | 2010       | West   | Part-time
```


## Query 2: Weekend vs Weekday Hiring Analysis 

```sql
-- Compare weekend vs weekday hiring patterns
SELECT 
    CASE 
        WHEN DAYNAME(hire_date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END as hiring_period,
    COUNT(*) as total_hires,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(hire_date) as earliest_hire,
    MAX(hire_date) as latest_hire
FROM Employees
GROUP BY 
    CASE 
        WHEN DAYNAME(hire_date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END
ORDER BY hiring_period;
```

## Output:

```
hiring_period | total_hires | avg_salary | earliest_hire | latest_hire
--------------|-------------|------------|---------------|-------------
Weekday       | 12          | 118333.33  | 2024-01-15    | 2024-02-15
Weekend       | 8           | 118750.00  | 2024-01-20    | 2024-02-11
```


## Query 3: Weekend Hiring by Department Analysis 

```sql
-- Analyze which departments hire on weekends most frequently
SELECT 
    department,
    COUNT(*) as weekend_hires,
    ROUND(AVG(salary), 2) as avg_weekend_salary,
    GROUP_CONCAT(DISTINCT employment_type ORDER BY employment_type) as employment_types,
    MIN(hire_date) as first_weekend_hire,
    MAX(hire_date) as last_weekend_hire
FROM Employees
WHERE DAYNAME(hire_date) IN ('Saturday', 'Sunday')
GROUP BY department
ORDER BY weekend_hires DESC, avg_weekend_salary DESC;
```

## Output:

```
department      | weekend_hires | avg_weekend_salary | employment_types    | first_weekend_hire | last_weekend_hire
----------------|---------------|-------------------|---------------------|-------------------|------------------
Engineering     | 2             | 160000.00         | Contract,Full-time  | 2024-01-20        | 2024-01-28
Customer Service| 1             | 65000.00          | Contract            | 2024-01-21        | 2024-01-21
IT Support      | 1             | 90000.00          | Part-time           | 2024-02-03        | 2024-02-03
Maintenance     | 1             | 70000.00          | Part-time           | 2024-02-11        | 2024-02-11
Operations      | 1             | 160000.00         | Full-time           | 2024-02-04        | 2024-02-04
Sales           | 1             | 150000.00         | Contract            | 2024-01-27        | 2024-01-27
Security        | 1             | 55000.00          | Contract            | 2024-02-10        | 2024-02-10
```


## Query 4: Day-wise Hiring Distribution 

```sql
-- Get complete day-wise hiring breakdown
SELECT 
    DAYNAME(hire_date) as day_name,
    DAYOFWEEK(hire_date) as day_number,
    COUNT(*) as hires_count,
    ROUND(AVG(salary), 2) as avg_salary,
    CASE 
        WHEN DAYNAME(hire_date) IN ('Saturday', 'Sunday') THEN 'Weekend'
        ELSE 'Weekday'
    END as day_type
FROM Employees
GROUP BY DAYNAME(hire_date), DAYOFWEEK(hire_date)
ORDER BY day_number;
```

## Output:

```
day_name  | day_number | hires_count | avg_salary | day_type
----------|------------|-------------|------------|----------
Sunday    | 1          | 3           | 135000.00  | Weekend
Monday    | 2          | 3           | 155000.00  | Weekday
Tuesday   | 3          | 3           | 88666.67   | Weekday
Wednesday | 4          | 3           | 85000.00   | Weekday
Thursday  | 5          | 2           | 155000.00  | Weekday
Friday    | 6          | 1           | 75000.00   | Weekday
Saturday  | 7          | 5           | 108600.00  | Weekend
```


## Query 5: Recent Weekend Hires with Employment Type 

```sql
-- Find recent weekend hires and their employment patterns
SELECT 
    employee_name,
    department,
    position,
    salary,
    hire_date,
    DAYNAME(hire_date) as hired_day,
    employment_type,
    region,
    CASE 
        WHEN employment_type = 'Contract' THEN 'Temporary'
        WHEN employment_type = 'Part-time' THEN 'Flexible'
        ELSE 'Regular'
    END as hire_category,
    DATEDIFF(CURDATE(), hire_date) as days_since_hire
FROM Employees
WHERE DAYNAME(hire_date) IN ('Saturday', 'Sunday')
    AND hire_date >= '2024-01-01'
ORDER BY hire_date DESC, salary DESC;
```

## Output:

```
employee_name  | department   | position             | salary    | hire_date  | hired_day | employment_type | region | hire_category | days_since_hire
---------------|--------------|---------------------|-----------|------------|-----------|----------------|--------|---------------|----------------
Lakshmi Menon  | Maintenance  | Facility Manager    | 70000.00  | 2024-02-11 | Sunday    | Part-time      | West   | Flexible      | 257
Ravi Krishnan  | Security     | Security Officer    | 55000.00  | 2024-02-10 | Saturday  | Contract       | East   | Temporary     | 258
Suresh Gupta   | Operations   | Operations Manager  | 160000.00 | 2024-02-04 | Sunday    | Full-time      | East   | Regular       | 264
Kavya Pillai   | IT Support   | System Administrator| 90000.00  | 2024-02-03 | Saturday  | Part-time      | West   | Flexible      | 265
Deepa Joshi    | Engineering  | Senior Developer    | 180000.00 | 2024-01-28 | Sunday    | Full-time      | South  | Regular       | 271
Rohit Mehta    | Sales        | Sales Manager       | 150000.00 | 2024-01-27 | Saturday  | Contract       | East   | Temporary     | 272
Arjun Nair     | Customer Service| Support Specialist| 65000.00  | 2024-01-21 | Sunday    | Contract       | North  | Temporary     | 278
Anita Desai    | Engineering  | DevOps Engineer     | 140000.00 | 2024-01-20 | Saturday  | Contract       | South  | Temporary     | 279
```


## How It Works
* **DAYNAME() Function**: Extracts the day name (Monday, Tuesday, etc.) from a date
* **DAYOFWEEK() Function**: Returns numeric day (1=Sunday, 2=Monday, etc.)
* **IN Clause**: Filters for multiple specific values (Saturday, Sunday)
* **CASE Statements**: Create business logic for categorizing weekend vs weekday
* **Date Filtering**: Combine date functions with WHERE clauses for complex filtering
* **GROUP_CONCAT**: Combines multiple values into a single string (MySQL specific)
* **DATEDIFF**: Calculates days between dates for recency analysis

## Real World Use Cases
1. **HR Process Analysis**: Identify unusual hiring patterns that may need investigation
2. **Compliance Monitoring**: Ensure hiring follows standard business day procedures
3. **Resource Planning**: Understand when HR staff need to be available for onboarding
4. **Data Quality**: Identify potential data entry errors (unexpected weekend dates)
5. **Emergency Hiring**: Track urgent recruitment that happens outside normal hours
6. **Regional Differences**: Compare hiring practices across different locations

## Key Learning
**Date Functions for Day Analysis** are crucial for understanding temporal patterns in business data. DAYNAME() and DAYOFWEEK() enable day-of-week analysis that reveals operational patterns.

**Weekend vs Weekday Analysis** is common in business analytics for understanding when activities occur outside normal business hours. This pattern applies to sales, support tickets, user activity, and more.

**Combining Date Functions with Business Logic** using CASE statements creates meaningful categorizations that drive actionable insights about operational efficiency and process compliance.
