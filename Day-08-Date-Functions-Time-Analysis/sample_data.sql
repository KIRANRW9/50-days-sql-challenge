-- Day 08: Date Functions and Time-Based Analysis - Sample Data

-- Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    manager_id INT,
    status VARCHAR(20)
);

-- Insert sample data into Employees
INSERT INTO Employees VALUES
-- 2023 Hires (Main focus of Day 8)
(1, 'Rajesh Kumar', 'Engineering', 'Software Engineer', 125000.00, '2023-01-15', 10, 'Active'),
(2, 'Priya Sharma', 'Sales', 'Sales Executive', 85000.00, '2023-02-20', 11, 'Active'),
(3, 'Amit Patel', 'Engineering', 'Senior Developer', 180000.00, '2023-03-10', 10, 'Active'),
(4, 'Sneha Reddy', 'Marketing', 'Marketing Specialist', 95000.00, '2023-04-05', 12, 'Active'),
(5, 'Vikram Singh', 'Finance', 'Financial Analyst', 110000.00, '2023-05-12', 13, 'Active'),
(6, 'Anita Desai', 'HR', 'HR Executive', 75000.00, '2023-06-18', 14, 'Active'),
(7, 'Rohit Mehta', 'Engineering', 'DevOps Engineer', 150000.00, '2023-07-22', 10, 'Active'),
(8, 'Kavya Pillai', 'Sales', 'Account Manager', 120000.00, '2023-08-14', 11, 'Active'),
(9, 'Arjun Nair', 'Marketing', 'Digital Marketer', 88000.00, '2023-09-08', 12, 'Active'),
(10, 'Deepa Joshi', 'Finance', 'Senior Analyst', 135000.00, '2023-10-25', 13, 'Active'),

-- 2022 Hires (For comparison analysis)
(11, 'Suresh Gupta', 'Engineering', 'Tech Lead', 220000.00, '2022-01-10', NULL, 'Active'),
(12, 'Meera Iyer', 'Sales', 'Sales Manager', 200000.00, '2022-03-15', NULL, 'Active'),
(13, 'Karthik Nair', 'Marketing', 'Marketing Manager', 175000.00, '2022-06-20', NULL, 'Active'),
(14, 'Pooja Rao', 'Finance', 'Finance Manager', 190000.00, '2022-08-12', NULL, 'Active'),
(15, 'Ravi Krishnan', 'HR', 'HR Manager', 160000.00, '2022-11-05', NULL, 'Active'),

-- 2024 Hires (Recent hires)
(16, 'Sanjay Patel', 'Engineering', 'Junior Developer', 95000.00, '2024-01-08', 11, 'Active'),
(17, 'Neha Agarwal', 'Sales', 'Sales Trainee', 65000.00, '2024-02-14', 12, 'Active'),
(18, 'Arun Kumar', 'Marketing', 'Content Writer', 70000.00, '2024-03-20', 13, 'Active'),

-- 2021 Hires (Senior employees)
(19, 'Lakshmi Menon', 'Engineering', 'Senior Architect', 280000.00, '2021-05-10', NULL, 'Active'),
(20, 'Ganesh Reddy', 'Finance', 'CFO', 350000.00, '2021-09-15', NULL, 'Active');
