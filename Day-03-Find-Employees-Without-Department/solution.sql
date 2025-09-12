-- Day 03: Find Employees Without Department - Solutions

-- Solution 1: Using LEFT JOIN (Primary Solution)
-- Find employees who don't have a matching department
SELECT e.emp_id, e.emp_name, e.department_id, e.salary, e.hire_date
FROM Employee e 
LEFT JOIN Department d ON e.department_id = d.department_id 
WHERE d.department_id IS NULL;

-- Solution 2: Using NOT EXISTS (Alternative Approach)
-- Find employees where no department exists for their department_id
SELECT e.emp_id, e.emp_name, e.department_id, e.salary, e.hire_date
FROM Employee e 
WHERE NOT EXISTS (
    SELECT 1 FROM Department d 
    WHERE d.department_id = e.department_id
);

-- Solution 3: Using NOT IN (with NULL handling)
-- Note: This approach requires careful NULL handling
SELECT e.emp_id, e.emp_name, e.department_id, e.salary, e.hire_date
FROM Employee e 
WHERE e.department_id NOT IN (
    SELECT department_id FROM Department 
    WHERE department_id IS NOT NULL
) OR e.department_id IS NULL;

-- Solution 4: Count of employees without department
-- Get the total count of orphaned employees
SELECT COUNT(*) as employees_without_department
FROM Employee e 
LEFT JOIN Department d ON e.department_id = d.department_id 
WHERE d.department_id IS NULL;



-- Verification Query: Show all employees with their department status
SELECT 
    e.emp_id,
    e.emp_name,
    e.department_id,
    COALESCE(d.department_name, 'NO DEPARTMENT') as department_name,
    e.salary
FROM Employee e 
LEFT JOIN Department d ON e.department_id = d.department_id
ORDER BY e.emp_id;
