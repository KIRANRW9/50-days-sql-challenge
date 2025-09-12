-- Day 03: Find Employees Without Department 
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
(6, 'Anita Joshi', 6, 135000.00, '2023-04-12'),  
(7, 'Rohit Verma', 2, 88000.00, '2023-02-28'),
(8, 'Deepak Gupta', 7, 92000.00, '2023-05-18'),  
(9, 'Kavita Nair', NULL, 78000.00, '2023-06-01'), 
(10, 'Suresh Yadav', 8, 105000.00, '2023-07-10');
