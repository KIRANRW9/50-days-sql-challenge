# Day 03: Find Employees Without Department (Left Join Usage)

## Problem
The HR department needs to identify employees who are not assigned to any department. This could happen due to data inconsistencies, new hires pending department assignment, or employees whose departments have been dissolved. This problem tests understanding of LEFT JOIN and NULL value handling.

## Dataset
Employee and Department data with some employees having invalid or missing department assignments.

## SQL Solution

```sql
-- Create Department table
CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100)
);

-- Create Employee table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
);

-- Insert sample data into Department
INSERT INTO Department VALUES
(1, 'Engineering', 'Bangalore'),
(2, 'Marketing', 'Mumbai'),
(3, 'HR', 'Delhi'),
(4, 'Sales', 'Pune'),
(5, 'Finance', 'Chennai');

-- Insert sample data into Employee (some with invalid department_id)
INSERT INTO Employee VALUES
(1, 'Rajesh Sharma', 1, 120000.00, '2023-01-15'),
(2, 'Priya Patel', 2, 95000.00, '2023-02-20'),
(3, 'Amit Kumar', 1, 150000.00, '2022-11-10'),
(4, 'Sneha Reddy', 3, 85000.00, '2023-03-05'),
(5, 'Vikram Singh', 4, 110000.00, '2023-01-30'),
(6, 'Anita Joshi', 6, 135000.00, '2023-04-12'),  -- department_id 6 doesn't exist
(7, 'Rohit Verma', 2, 88000.00, '2023-02-28'),
(8, 'Deepak Gupta', 7, 92000.00, '2023-05-18'),  -- department_id 7 doesn't exist
(9, 'Kavita Nair', NULL, 78000.00, '2023-06-01'), -- NULL department_id
(10, 'Suresh Yadav', 8, 105000.00, '2023-07-10'); -- department_id 8 doesn't exist
```

## Query 1: Find Employees Without Department (LEFT JOIN)

```sql
SELECT e.emp_id, e.emp_name, e.department_id, e.salary, e.hire_date
FROM Employee e 
LEFT JOIN Department d ON e.department_id = d.department_id 
WHERE d.department_id IS NULL;
```

## Output:

```
emp_id | emp_name      | department_id | salary    | hire_date
-------|---------------|---------------|-----------|----------
6      | Anita Joshi   | 6            | 135000.00 | 2023-04-12
8      | Deepak Gupta  | 7            | 92000.00  | 2023-05-18
9      | Kavita Nair   | NULL         | 78000.00  | 2023-06-01
10     | Suresh Yadav  | 8            | 105000.00 | 2023-07-10
```

## Query 2: Alternative Using NOT EXISTS

```sql
SELECT e.emp_id, e.emp_name, e.department_id, e.salary, e.hire_date
FROM Employee e 
WHERE NOT EXISTS (
    SELECT 1 FROM Department d 
    WHERE d.department_id = e.department_id
);
```

## Output:

```
emp_id | emp_name      | department_id | salary    | hire_date
-------|---------------|---------------|-----------|----------
6      | Anita Joshi   | 6            | 135000.00 | 2023-04-12
8      | Deepak Gupta  | 7            | 92000.00  | 2023-05-18
9      | Kavita Nair   | NULL         | 78000.00  | 2023-06-01
10     | Suresh Yadav  | 8            | 105000.00 | 2023-07-10
```

## Query 3: Count of Employees Without Department

```sql
SELECT COUNT(*) as employees_without_department
FROM Employee e 
LEFT JOIN Department d ON e.department_id = d.department_id 
WHERE d.department_id IS NULL;
```

## Output:

```
employees_without_department
----------------------------
4
```

## Query 4: Verification Query - Show All Employees with Department Status

```sql
SELECT 
    e.emp_id, 
    e.emp_name, 
    e.department_id, 
    COALESCE(d.department_name, 'NO DEPARTMENT') as department_name, 
    e.salary
FROM Employee e 
LEFT JOIN Department d ON e.department_id = d.department_id 
ORDER BY e.emp_id;
```

## Output:

```
emp_id | emp_name      | department_id | department_name | salary
-------|---------------|---------------|-----------------|----------
1      | Rajesh Sharma | 1            | Engineering     | 120000.00
2      | Priya Patel   | 2            | Marketing       | 95000.00
3      | Amit Kumar    | 1            | Engineering     | 150000.00
4      | Sneha Reddy   | 3            | HR              | 85000.00
5      | Vikram Singh  | 4            | Sales           | 110000.00
6      | Anita Joshi   | 6            | NO DEPARTMENT   | 135000.00
7      | Rohit Verma   | 2            | Marketing       | 88000.00
8      | Deepak Gupta  | 7            | NO DEPARTMENT   | 92000.00
9      | Kavita Nair   | NULL         | NO DEPARTMENT   | 78000.00
10     | Suresh Yadav  | 8            | NO DEPARTMENT   | 105000.00
```

## How It Works
* **LEFT JOIN**: Returns all records from Employee table and matched records from Department table
* **WHERE d.department_id IS NULL**: Filters only those employees where no matching department was found
* **NULL Handling**: Catches both NULL department_id values and non-existent department_id references
* **Data Integrity Check**: Identifies orphaned records that violate referential integrity

## Real World Use Cases
1. **Data Quality Auditing**: Identifying data inconsistencies in HR systems
2. **Employee Onboarding**: Finding new hires pending department assignment
3. **Organizational Restructuring**: Locating employees from dissolved departments
4. **Database Cleanup**: Detecting orphaned records for data maintenance
5. **Compliance Reporting**: Ensuring all employees are properly assigned for regulatory requirements

## Key Learning
LEFT JOIN is essential for finding missing relationships between tables. The pattern `LEFT JOIN ... WHERE right_table.key IS NULL` is a fundamental technique for identifying orphaned records and data quality issues. Understanding NULL handling is crucial for accurate data analysis and maintaining referential integrity.

COALESCE Function: COALESCE provides an elegant way to handle NULL values by returning the first non-NULL value from a list of expressions. It's particularly useful in reporting scenarios where you need to display meaningful labels instead of NULL values (e.g., COALESCE(department_name, 'NO DEPARTMENT')). This function improves data presentation and makes query results more user-friendly, especially when dealing with optional or missing relationships in joined tables.
