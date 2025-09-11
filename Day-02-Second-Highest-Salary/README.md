# Day 02: Second Highest Salary
## Problem
HR department needs to find the second highest salary for budget planning and promotion decisions. This is a classic SQL question that tests understanding of subqueries and aggregate functions.
## Dataset
Employee salary data with various departments and salary ranges.
## SQL Solution
```sql
-- Create Employee table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO Employee VALUES
(1, 'Rajesh Sharma', 'Engineering', 120000.00),
(2, 'Priya Patel', 'Marketing', 95000.00),
(3, 'Amit Kumar', 'Engineering', 150000.00),
(4, 'Sneha Reddy', 'HR', 85000.00),
(5, 'Vikram Singh', 'Sales', 110000.00),
(6, 'Anita Joshi', 'Engineering', 135000.00),
(7, 'Rohit Verma', 'Marketing', 88000.00);
```
### Query 1: Find Second Highest Salary 
```sql
SELECT MAX(salary) AS SecondHighestSalary 
FROM Employee 
WHERE salary < (SELECT MAX(salary) FROM Employee);
```
**Output:**
```
SecondHighestSalary
-------------------
135000.00
```
### Query 2: using Window Function
```sql
SELECT salary AS SecondHighestSalary
FROM (
    SELECT salary,
           ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num
    FROM Employee
) ranked_salaries
WHERE row_num = 2;
```
**Output:**
```
SecondHighestSalary
-------------------
135000.00
```
## How It Works
- **Subquery Approach**: Find MAX salary that is less than the overall maximum
- **WHERE salary <**: Filters out the highest salary
- **MAX()**: Gets the highest value from remaining salaries
- **Window Function**: Assigns row numbers based on salary ranking, then picks row 2
## Real World Use Cases
1. **HR Analytics**: Salary benchmarking and compensation planning
2. **Performance Reviews**: Identifying top performers for promotions
3. **Budget Planning**: Understanding salary distribution for next fiscal year
4. **Recruitment**: Setting competitive salary offers for new hires
## Key Learning
Finding the second highest value is a fundamental SQL pattern. The subquery approach using `MAX()` with a condition is the most intuitive method, while window functions offer more flexibility for complex ranking scenarios.
