-- Day 05: Employee Salary Analysis with Rankings - Sample Data

-- Create Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    budget DECIMAL(12,2),
    head_of_department VARCHAR(100)
);

-- Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT
);

-- Insert sample data into Departments
INSERT INTO Departments VALUES
(1, 'Engineering', 5000000.00, 'Rajesh Kumar'),
(2, 'Sales', 3000000.00, 'Priya Sharma'),
(3, 'Marketing', 1500000.00, 'Anita Desai'),
(4, 'HR', 1200000.00, 'Suresh Gupta'),
(5, 'Finance', 2500000.00, 'Meera Iyer');

-- Insert sample data into Employees
INSERT INTO Employees VALUES
-- Engineering Department
(1, 'Rajesh Kumar', 'Engineering', 'Engineering Manager', 350000.00, '2020-01-15', NULL),
(2, 'Amit Patel', 'Engineering', 'Senior Architect', 280000.00, '2020-03-20', 1),
(3, 'Sneha Reddy', 'Engineering', 'Senior Developer', 220000.00, '2021-06-10', 1),
(4, 'Karthik Nair', 'Engineering', 'Developer', 120000.00, '2023-02-14', 2),

-- Sales Department  
(5, 'Priya Sharma', 'Sales', 'Sales Director', 320000.00, '2019-11-05', NULL),
(6, 'Vikram Singh', 'Sales', 'Senior Sales Manager', 180000.00, '2021-01-20', 5),
(7, 'Ritu Agarwal', 'Sales', 'Sales Executive', 85000.00, '2022-09-12', 6),

-- Marketing Department
(8, 'Anita Desai', 'Marketing', 'Marketing Manager', 150000.00, '2020-07-08', NULL),
(9, 'Rohit Mehta', 'Marketing', 'Digital Marketing Specialist', 95000.00, '2022-04-18', 8),
(10, 'Kavya Pillai', 'Marketing', 'Content Writer', 65000.00, '2023-08-22', 8),

-- HR Department
(11, 'Suresh Gupta', 'HR', 'HR Manager', 140000.00, '2020-10-12', NULL),
(12, 'Deepa Joshi', 'HR', 'HR Executive', 75000.00, '2022-12-05', 11),

-- Finance Department  
(13, 'Meera Iyer', 'Finance', 'Finance Manager', 200000.00, '2019-08-30', NULL),
(14, 'Arjun Krishnan', 'Finance', 'Senior Accountant', 130000.00, '2021-11-15', 13),
(15, 'Pooja Rao', 'Finance', 'Financial Analyst', 100000.00, '2023-05-20', 13);
