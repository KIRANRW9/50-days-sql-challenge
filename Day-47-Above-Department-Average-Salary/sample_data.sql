-- Day 47: Above Department Average Salary Analysis

-- Drop tables if exist (for clean slate)
DROP TABLE IF EXISTS Employee;
DROP TABLE IF EXISTS Department;

-- Create Department table
CREATE TABLE Department (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(100),
    location VARCHAR(100),
    budget DECIMAL(12,2)
);

-- Create Employee table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE,
    job_title VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES Department(department_id)
);

-- Insert sample data into Department
INSERT INTO Department VALUES
(1, 'Engineering', 'Bangalore', 5000000.00),
(2, 'Marketing', 'Mumbai', 2000000.00),
(3, 'HR', 'Delhi', 1500000.00),
(4, 'Sales', 'Pune', 3000000.00),
(5, 'Finance', 'Chennai', 2500000.00);

-- Insert sample data into Employee
-- Engineering Department (3 employees - High salaries)
INSERT INTO Employee VALUES
(101, 'Rajesh Sharma', 1, 120000.00, '2023-01-15', 'Senior Software Engineer'),
(102, 'Priya Patel', 2, 95000.00, '2023-02-20', 'Marketing Manager'),
(103, 'Amit Kumar', 1, 150000.00, '2022-11-10', 'Lead Engineer'),
(104, 'Sneha Reddy', 3, 85000.00, '2023-03-05', 'HR Manager'),
(105, 'Vikram Singh', 4, 110000.00, '2023-01-30', 'Sales Manager'),
(106, 'Anita Joshi', 5, 135000.00, '2023-04-12', 'Senior Accountant'),
(107, 'Rohit Verma', 2, 88000.00, '2023-02-28', 'Digital Marketing Specialist'),
(108, 'Deepak Gupta', 2, 92000.00, '2023-05-18', 'Brand Manager'),
(109, 'Kavita Nair', 5, 78000.00, '2023-06-01', 'Financial Analyst'),
(110, 'Suresh Yadav', 4, 105000.00, '2023-07-10', 'Sales Director'),
(125, 'Ankit Singh', 1, 135000.00, '2022-09-20', 'DevOps Engineer'),
(126, 'Meera Iyer', 3, 85000.00, '2023-08-15', 'Recruitment Specialist');
