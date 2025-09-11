-- Query 1: Find Second Highest Salary (Main Solution)
SELECT MAX(salary) AS SecondHighestSalary 
FROM Employee 
WHERE salary < (SELECT MAX(salary) FROM Employee);

-- Query 2: Alternative using Window Function
SELECT salary AS SecondHighestSalary
FROM (
    SELECT salary,
           ROW_NUMBER() OVER (ORDER BY salary DESC) as row_num
    FROM Employee
) ranked_salaries
WHERE row_num = 2;

-- Verification: View all salaries in descending order
SELECT emp_name, salary
FROM Employee
ORDER BY salary DESC;
