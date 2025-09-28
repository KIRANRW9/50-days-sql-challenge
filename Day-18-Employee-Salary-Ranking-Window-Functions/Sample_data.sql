-- Create Employee table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT
);

-- Create Departments table
CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    budget DECIMAL(12,2),
    head_count INT
);

-- Insert Sample Data
-- Insert Departments
INSERT INTO Departments VALUES
(1, 'Engineering', 5000000.00, 4),
(2, 'Sales', 3000000.00, 4),
(3, 'Marketing', 2000000.00, 3),
(4, 'Finance', 2500000.00, 3);

-- Insert Employees
INSERT INTO Employee VALUES
-- Engineering Department
(101, 'Rajesh Kumar', 1, 'Engineering', 'Tech Lead', 180000.00, '2022-01-15', NULL),
(102, 'Amit Patel', 1, 'Engineering', 'Senior Developer', 150000.00, '2022-03-20', 101),
(103, 'Sneha Reddy', 1, 'Engineering', 'Software Engineer', 120000.00, '2023-06-10', 101),
(104, 'Karthik Nair', 1, 'Engineering', 'Junior Developer', 95000.00, '2024-02-14', 102),

-- Sales Department
(201, 'Priya Sharma', 2, 'Sales', 'Sales Manager', 140000.00, '2021-11-05', NULL),
(202, 'Vikram Singh', 2, 'Sales', 'Senior Sales Rep', 110000.00, '2022-01-20', 201),
(203, 'Anita Desai', 2, 'Sales', 'Sales Executive', 85000.00, '2023-09-12', 201),
(204, 'Rohit Mehta', 2, 'Sales', 'Sales Associate', 75000.00, '2024-04-18', 202),

-- Marketing Department
(301, 'Deepa Joshi', 3, 'Marketing', 'Marketing Manager', 130000.00, '2022-10-12', NULL),
(302, 'Arjun Nair', 3, 'Marketing', 'Marketing Executive', 100000.00, '2023-05-10', 301),
(303, 'Kavya Pillai', 3, 'Marketing', 'Content Specialist', 88000.00, '2023-08-22', 301),

-- Finance Department
(401, 'Suresh Gupta', 4, 'Finance', 'Finance Manager', 160000.00, '2021-08-30', NULL),
(402, 'Meera Iyer', 4, 'Finance', 'Senior Analyst', 125000.00, '2022-11-15', 401),
(403, 'Pooja Rao', 4, 'Finance', 'Financial Analyst', 105000.00, '2023-05-20', 401);u
