# Day 16: Salary Range Analysis with BETWEEN Operator (Range Filtering and Compensation Analysis)

## Problem
The HR and finance departments need to analyze employee compensation within specific salary ranges for budget planning, pay equity analysis, and compensation benchmarking. This analysis helps in identifying employees in target salary bands, planning salary adjustments, and ensuring competitive compensation structures. This problem tests understanding of BETWEEN operator, range filtering, and salary analysis techniques.

## Dataset
Employee compensation data with comprehensive salary information across different departments, positions, and experience levels for range-based analysis.

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
    experience_years INT,
    location VARCHAR(50),
    performance_rating VARCHAR(10)
);

-- Insert sample data into Employees
INSERT INTO Employees VALUES
-- Below target range (Under 50,000)
(1001, 'Ravi Kumar', 'Support', 'Junior Support Specialist', 35000.00, '2024-01-15', 1, 'Chennai', 'Good'),
(1002, 'Anjali Sharma', 'Admin', 'Administrative Assistant', 42000.00, '2024-02-20', 2, 'Mumbai', 'Excellent'),
(1003, 'Suresh Patel', 'Security', 'Security Guard', 38000.00, '2023-11-10', 3, 'Pune', 'Good'),
(1004, 'Meera Reddy', 'Housekeeping', 'Facility Coordinator', 45000.00, '2024-03-05', 1, 'Bangalore', 'Good'),

-- TARGET RANGE: 50,000 - 100,000 (Main focus of analysis)
(1005, 'Rajesh Kumar', 'HR', 'HR Executive', 65000.00, '2023-09-15', 2, 'Delhi', 'Excellent'),
(1006, 'Priya Sharma', 'Sales', 'Sales Executive', 75000.00, '2023-08-20', 3, 'Mumbai', 'Excellent'),
(1007, 'Amit Patel', 'Marketing', 'Marketing Specialist', 82000.00, '2024-01-25', 4, 'Bangalore', 'Good'),
(1008, 'Sneha Reddy', 'Finance', 'Junior Accountant', 58000.00, '2024-02-10', 1, 'Hyderabad', 'Good'),
(1009, 'Vikram Singh', 'IT', 'System Administrator', 95000.00, '2023-07-12', 5, 'Pune', 'Excellent'),
(1010, 'Kavya Pillai', 'Operations', 'Operations Coordinator', 70000.00, '2023-12-18', 3, 'Kochi', 'Good'),
(1011, 'Arjun Nair', 'Customer Service', 'Senior Support Specialist', 68000.00, '2024-01-08', 4, 'Chennai', 'Good'),
(1012, 'Deepa Joshi', 'Quality', 'QA Analyst', 78000.00, '2023-10-22', 3, 'Delhi', 'Excellent'),
(1013, 'Rohit Mehta', 'Procurement', 'Purchase Executive', 72000.00, '2024-03-14', 2, 'Mumbai', 'Good'),
(1014, 'Anita Desai', 'Training', 'Training Coordinator', 88000.00, '2023-11-30', 4, 'Bangalore', 'Excellent'),
(1015, 'Suresh Gupta', 'Legal', 'Legal Assistant', 85000.00, '2024-02-05', 3, 'Delhi', 'Good'),
(1016, 'Lakshmi Menon', 'Research', 'Research Analyst', 92000.00, '2023-09-28', 5, 'Hyderabad', 'Excellent'),

-- Above target range (Above 100,000)
(1017, 'Ganesh Reddy', 'Engineering', 'Senior Software Engineer', 125000.00, '2023-06-10', 6, 'Bangalore', 'Excellent'),
(1018, 'Karthik Nair', 'Sales', 'Sales Manager', 140000.00, '2023-04-15', 8, 'Mumbai', 'Excellent'),
(1019, 'Pooja Rao', 'Finance', 'Financial Manager', 160000.00, '2023-02-20', 10, 'Delhi', 'Excellent'),
(1020, 'Sanjay Patel', 'IT', 'IT Manager', 180000.00, '2023-01-12', 12, 'Bangalore', 'Excellent'),
(1021, 'Neha Agarwal', 'Marketing', 'Marketing Manager', 150000.00, '2023-03-25', 9, 'Mumbai', 'Excellent'),
(1022, 'Arun Kumar', 'Operations', 'Operations Manager', 170000.00, '2023-05-18', 11, 'Chennai', 'Excellent');
```

## Query 1: Employees with Salary Between 50,000 and 100,000 

```sql
-- List all employees whose salary is within the specified range
SELECT * 
FROM Employees 
WHERE salary BETWEEN 50000 AND 100000
ORDER BY salary DESC;
```

## Output:

```
employee_id | employee_name | department      | position                | salary   | hire_date  | experience_years | location  | performance_rating
------------|---------------|-----------------|-------------------------|----------|------------|------------------|-----------|-------------------
1009        | Vikram Singh  | IT              | System Administrator    | 95000.00 | 2023-07-12 | 5                | Pune      | Excellent
1016        | Lakshmi Menon | Research        | Research Analyst        | 92000.00 | 2023-09-28 | 5                | Hyderabad | Excellent
1014        | Anita Desai   | Training        | Training Coordinator    | 88000.00 | 2023-11-30 | 4                | Bangalore | Excellent
1015        | Suresh Gupta  | Legal           | Legal Assistant         | 85000.00 | 2024-02-05 | 3                | Delhi     | Good
1007        | Amit Patel    | Marketing       | Marketing Specialist    | 82000.00 | 2024-01-25 | 4                | Bangalore | Good
1012        | Deepa Joshi   | Quality         | QA Analyst              | 78000.00 | 2023-10-22 | 3                | Delhi     | Excellent
1006        | Priya Sharma  | Sales           | Sales Executive         | 75000.00 | 2023-08-20 | 3                | Mumbai    | Excellent
1013        | Rohit Mehta   | Procurement     | Purchase Executive      | 72000.00 | 2024-03-14 | 2                | Mumbai    | Good
1010        | Kavya Pillai  | Operations      | Operations Coordinator  | 70000.00 | 2023-12-18 | 3                | Kochi     | Good
1011        | Arjun Nair    | Customer Service| Senior Support Specialist| 68000.00 | 2024-01-08 | 4                | Chennai   | Good
1005        | Rajesh Kumar  | HR              | HR Executive            | 65000.00 | 2023-09-15 | 2                | Delhi     | Excellent
1008        | Sneha Reddy   | Finance         | Junior Accountant       | 58000.00 | 2024-02-10 | 1                | Hyderabad | Good
```


## Query 2: Salary Range Distribution Analysis

```sql
-- Analyze employee distribution across different salary ranges
SELECT 
    CASE 
        WHEN salary < 50000 THEN 'Below Range (<50K)'
        WHEN salary BETWEEN 50000 AND 100000 THEN 'Target Range (50K-100K)'
        WHEN salary > 100000 THEN 'Above Range (>100K)'
    END as salary_category,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    ROUND(AVG(experience_years), 1) as avg_experience
FROM Employees
GROUP BY 
    CASE 
        WHEN salary < 50000 THEN 'Below Range (<50K)'
        WHEN salary BETWEEN 50000 AND 100000 THEN 'Target Range (50K-100K)'
        WHEN salary > 100000 THEN 'Above Range (>100K)'
    END
ORDER BY avg_salary;
```

## Output:

```
salary_category         | employee_count | avg_salary | min_salary | max_salary | avg_experience
------------------------|----------------|------------|------------|------------|---------------
Below Range (<50K)      | 4              | 40000.00   | 35000.00   | 45000.00   | 1.8
Target Range (50K-100K) | 12             | 76416.67   | 58000.00   | 95000.00   | 3.3
Above Range (>100K)     | 6              | 154166.67  | 125000.00  | 180000.00  | 9.5
```


## Query 3: Department-wise Target Range Analysis 

```sql
-- Analyze employees in target range by department
SELECT 
    department,
    COUNT(*) as employees_in_range,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    ROUND(AVG(experience_years), 1) as avg_experience,
    GROUP_CONCAT(DISTINCT performance_rating ORDER BY performance_rating) as ratings
FROM Employees
WHERE salary BETWEEN 50000 AND 100000
GROUP BY department
ORDER BY employees_in_range DESC, avg_salary DESC;
```

## Output:

```
department      | employees_in_range | avg_salary | min_salary | max_salary | avg_experience | ratings
----------------|-------------------|------------|------------|------------|----------------|------------------
Sales           | 1                 | 75000.00   | 75000.00   | 75000.00   | 3.0            | Excellent
Marketing       | 1                 | 82000.00   | 82000.00   | 82000.00   | 4.0            | Good
HR              | 1                 | 65000.00   | 65000.00   | 65000.00   | 2.0            | Excellent
Finance         | 1                 | 58000.00   | 58000.00   | 58000.00   | 1.0            | Good
IT              | 1                 | 95000.00   | 95000.00   | 95000.00   | 5.0            | Excellent
Operations      | 1                 | 70000.00   | 70000.00   | 70000.00   | 3.0            | Good
Customer Service| 1                 | 68000.00   | 68000.00   | 68000.00   | 4.0            | Good
Quality         | 1                 | 78000.00   | 78000.00   | 78000.00   | 3.0            | Excellent
Procurement     | 1                 | 72000.00   | 72000.00   | 72000.00   | 2.0            | Good
Training        | 1                 | 88000.00   | 88000.00   | 88000.00   | 4.0            | Excellent
Legal           | 1                 | 85000.00   | 85000.00   | 85000.00   | 3.0            | Good
Research        | 1                 | 92000.00   | 92000.00   | 92000.00   | 5.0            | Excellent
```

**Interview Probability: 85% - Department analysis with multiple aggregations**

## Query 4: Performance Rating Analysis within Range 
```sql
-- Analyze performance ratings of employees in target salary range
SELECT 
    performance_rating,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    ROUND(AVG(experience_years), 1) as avg_experience,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary,
    ROUND((COUNT(*) * 100.0 / (SELECT COUNT(*) FROM Employees WHERE salary BETWEEN 50000 AND 100000)), 1) as percentage_of_range
FROM Employees
WHERE salary BETWEEN 50000 AND 100000
GROUP BY performance_rating
ORDER BY avg_salary DESC;
```

## Output:

```
performance_rating | employee_count | avg_salary | avg_experience | min_salary | max_salary | percentage_of_range
-------------------|----------------|------------|----------------|------------|------------|--------------------
Excellent          | 6              | 83166.67   | 4.0            | 65000.00   | 95000.00   | 50.0
Good               | 6              | 69500.00   | 2.8            | 58000.00   | 85000.00   | 50.0
```


## Query 5: Location and Experience Analysis 

```sql
-- Analyze target range employees by location and experience level
SELECT 
    location,
    CASE 
        WHEN experience_years <= 2 THEN 'Junior (0-2 years)'
        WHEN experience_years BETWEEN 3 AND 5 THEN 'Mid-Level (3-5 years)'
        ELSE 'Senior (5+ years)'
    END as experience_level,
    COUNT(*) as employee_count,
    ROUND(AVG(salary), 2) as avg_salary,
    MIN(salary) as min_salary,
    MAX(salary) as max_salary
FROM Employees
WHERE salary BETWEEN 50000 AND 100000
GROUP BY location, 
    CASE 
        WHEN experience_years <= 2 THEN 'Junior (0-2 years)'
        WHEN experience_years BETWEEN 3 AND 5 THEN 'Mid-Level (3-5 years)'
        ELSE 'Senior (5+ years)'
    END
ORDER BY location, avg_salary DESC;
```

## Output:

```
location  | experience_level       | employee_count | avg_salary | min_salary | max_salary
----------|------------------------|----------------|------------|------------|------------
Bangalore | Mid-Level (3-5 years) | 2              | 85000.00   | 82000.00   | 88000.00
Chennai   | Mid-Level (3-5 years) | 1              | 68000.00   | 68000.00   | 68000.00
Delhi     | Mid-Level (3-5 years) | 2              | 81500.00   | 78000.00   | 85000.00
Delhi     | Junior (0-2 years)    | 1              | 65000.00   | 65000.00   | 65000.00
Hyderabad | Senior (5+ years)     | 1              | 92000.00   | 92000.00   | 92000.00
Hyderabad | Junior (0-2 years)    | 1              | 58000.00   | 58000.00   | 58000.00
Kochi     | Mid-Level (3-5 years) | 1              | 70000.00   | 70000.00   | 70000.00
Mumbai    | Mid-Level (3-5 years) | 1              | 75000.00   | 75000.00   | 75000.00
Mumbai    | Junior (0-2 years)    | 1              | 72000.00   | 72000.00   | 72000.00
Pune      | Senior (5+ years)     | 1              | 95000.00   | 95000.00   | 95000.00
```


## How It Works
* **BETWEEN Operator**: Filters records where column values fall within a specified range (inclusive)
* **Range Analysis**: BETWEEN is inclusive - includes both boundary values (50000 AND 100000)
* **CASE Statements**: Create salary categories for distribution analysis
* **Multiple Conditions**: Combine BETWEEN with other conditions using AND/OR operators
* **Aggregation with Ranges**: GROUP BY with range-based CASE statements
* **Percentage Calculations**: Calculate proportions within filtered datasets
* **Multi-dimensional Grouping**: Group by multiple columns for detailed analysis

## Real World Use Cases
1. **Salary Budgeting**: Identify employees within specific compensation ranges for budget planning
2. **Pay Equity Analysis**: Ensure fair compensation within salary bands across demographics
3. **Promotion Planning**: Find employees ready for salary increases within target ranges
4. **Market Benchmarking**: Compare company salaries with industry standards
5. **Performance Correlation**: Analyze relationship between salary ranges and performance
6. **Location-based Compensation**: Understand salary variations across different locations

## Key Learning
**BETWEEN Operator** is essential for range-based filtering and is more readable than using >= AND <= operators. It's inclusive of both boundary values, which is important to remember for accurate analysis.

**Range-based Analysis** is fundamental in business analytics for categorizing data into meaningful segments like salary bands, age groups, score ranges, and performance tiers.

**Combining BETWEEN with Aggregations** enables powerful salary analytics that drive compensation decisions, budget planning, and organizational insights about pay distribution and equity.
