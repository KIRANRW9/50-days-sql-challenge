-- Day 28: Department Distribution Analysis - Sample Data

-- Create Employee table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    city VARCHAR(50)
);

-- Insert sample data for department distribution analysis
INSERT INTO Employee (employee_id, employee_name, department_id, department_name, position, salary, hire_date, city) VALUES
-- Engineering Department (Largest - 8 employees)
(1, 'Rajesh Kumar', 101, 'Engineering', 'Senior Developer', 95000.00, '2020-03-15', 'Bangalore'),
(2, 'Priya Sharma', 101, 'Engineering', 'Tech Lead', 120000.00, '2019-07-22', 'Bangalore'),
(3, 'Amit Patel', 101, 'Engineering', 'Software Engineer', 75000.00, '2021-01-10', 'Mumbai'),
(4, 'Sneha Reddy', 101, 'Engineering', 'DevOps Engineer', 85000.00, '2020-09-05', 'Hyderabad'),
(5, 'Vikram Singh', 101, 'Engineering', 'QA Engineer', 70000.00, '2021-06-18', 'Delhi'),
(6, 'Ananya Iyer', 101, 'Engineering', 'Frontend Developer', 80000.00, '2020-11-30', 'Chennai'),
(7, 'Karthik Menon', 101, 'Engineering', 'Backend Developer', 90000.00, '2019-12-12', 'Bangalore'),
(8, 'Deepa Nair', 101, 'Engineering', 'Full Stack Developer', 105000.00, '2020-04-25', 'Pune'),

-- Sales Department (7 employees)
(9, 'Rohit Mehta', 102, 'Sales', 'Sales Manager', 95000.00, '2019-05-20', 'Mumbai'),
(10, 'Kavya Desai', 102, 'Sales', 'Senior Sales Executive', 75000.00, '2020-08-14', 'Delhi'),
(11, 'Arjun Kapoor', 102, 'Sales', 'Sales Executive', 60000.00, '2021-02-28', 'Bangalore'),
(12, 'Meera Joshi', 102, 'Sales', 'Sales Executive', 65000.00, '2021-07-19', 'Chennai'),
(13, 'Sanjay Gupta', 102, 'Sales', 'Business Development', 80000.00, '2020-10-05', 'Hyderabad'),
(14, 'Pooja Agarwal', 102, 'Sales', 'Account Manager', 70000.00, '2021-03-12', 'Pune'),
(15, 'Nikhil Verma', 102, 'Sales', 'Sales Coordinator', 55000.00, '2022-01-08', 'Bangalore'),

-- Marketing Department (6 employees)
(16, 'Anjali Rao', 103, 'Marketing', 'Marketing Manager', 90000.00, '2019-09-15', 'Mumbai'),
(17, 'Rahul Chopra', 103, 'Marketing', 'Digital Marketing Lead', 75000.00, '2020-06-22', 'Delhi'),
(18, 'Divya Malhotra', 103, 'Marketing', 'Content Strategist', 65000.00, '2021-04-18', 'Bangalore'),
(19, 'Aditya Bose', 103, 'Marketing', 'SEO Specialist', 60000.00, '2021-08-30', 'Kolkata'),
(20, 'Shreya Kulkarni', 103, 'Marketing', 'Social Media Manager', 70000.00, '2020-12-10', 'Pune'),
(21, 'Varun Saxena', 103, 'Marketing', 'Brand Manager', 80000.00, '2020-02-25', 'Bangalore'),

-- HR Department (5 employees)
(22, 'Sunita Pillai', 104, 'HR', 'HR Manager', 85000.00, '2019-03-10', 'Bangalore'),
(23, 'Manish Tiwari', 104, 'HR', 'Talent Acquisition Lead', 70000.00, '2020-07-15', 'Mumbai'),
(24, 'Ritu Bansal', 104, 'HR', 'HR Executive', 55000.00, '2021-09-20', 'Delhi'),
(25, 'Arun Kumar', 104, 'HR', 'Training Coordinator', 50000.00, '2021-11-05', 'Chennai'),
(26, 'Neha Sinha', 104, 'HR', 'Payroll Specialist', 60000.00, '2020-05-28', 'Bangalore'),

-- Finance Department (4 employees)
(27, 'Suresh Krishnan', 105, 'Finance', 'Finance Manager', 110000.00, '2018-08-12', 'Mumbai'),
(28, 'Lakshmi Narayan', 105, 'Finance', 'Senior Accountant', 80000.00, '2019-11-20', 'Chennai'),
(29, 'Prakash Reddy', 105, 'Finance', 'Financial Analyst', 75000.00, '2020-04-15', 'Hyderabad'),
(30, 'Swati Bhatt', 105, 'Finance', 'Accounts Executive', 65000.00, '2021-06-10', 'Bangalore');
