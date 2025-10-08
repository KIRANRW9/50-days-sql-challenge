-- Day 29: Department Salary Difference Analysis - Sample Data

-- Create Employee table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department_id INT,
    department_name VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    experience_years INT
);

-- Insert sample data for salary difference analysis
INSERT INTO Employee (employee_id, employee_name, department_id, department_name, position, salary, hire_date, experience_years) VALUES
-- Engineering Department (Salary Range: 70000 - 120000 = 50000 difference)
(1, 'Priya Sharma', 101, 'Engineering', 'Tech Lead', 120000.00, '2019-07-22', 5),
(2, 'Deepa Nair', 101, 'Engineering', 'Full Stack Developer', 105000.00, '2020-04-25', 4),
(3, 'Rajesh Kumar', 101, 'Engineering', 'Senior Developer', 95000.00, '2020-03-15', 4),
(4, 'Karthik Menon', 101, 'Engineering', 'Backend Developer', 90000.00, '2019-12-12', 5),
(5, 'Sneha Reddy', 101, 'Engineering', 'DevOps Engineer', 85000.00, '2020-09-05', 3),
(6, 'Ananya Iyer', 101, 'Engineering', 'Frontend Developer', 80000.00, '2020-11-30', 3),
(7, 'Amit Patel', 101, 'Engineering', 'Software Engineer', 75000.00, '2021-01-10', 3),
(8, 'Vikram Singh', 101, 'Engineering', 'QA Engineer', 70000.00, '2021-06-18', 2),

-- Sales Department (Salary Range: 55000 - 95000 = 40000 difference)
(9, 'Rohit Mehta', 102, 'Sales', 'Sales Manager', 95000.00, '2019-05-20', 5),
(10, 'Sanjay Gupta', 102, 'Sales', 'Business Development', 80000.00, '2020-10-05', 3),
(11, 'Kavya Desai', 102, 'Sales', 'Senior Sales Executive', 75000.00, '2020-08-14', 3),
(12, 'Pooja Agarwal', 102, 'Sales', 'Account Manager', 70000.00, '2021-03-12', 2),
(13, 'Meera Joshi', 102, 'Sales', 'Sales Executive', 65000.00, '2021-07-19', 2),
(14, 'Arjun Kapoor', 102, 'Sales', 'Sales Executive', 60000.00, '2021-02-28', 2),
(15, 'Nikhil Verma', 102, 'Sales', 'Sales Coordinator', 55000.00, '2022-01-08', 1),

-- Marketing Department (Salary Range: 60000 - 90000 = 30000 difference)
(16, 'Anjali Rao', 103, 'Marketing', 'Marketing Manager', 90000.00, '2019-09-15', 5),
(17, 'Varun Saxena', 103, 'Marketing', 'Brand Manager', 80000.00, '2020-02-25', 4),
(18, 'Rahul Chopra', 103, 'Marketing', 'Digital Marketing Lead', 75000.00, '2020-06-22', 3),
(19, 'Shreya Kulkarni', 103, 'Marketing', 'Social Media Manager', 70000.00, '2020-12-10', 3),
(20, 'Divya Malhotra', 103, 'Marketing', 'Content Strategist', 65000.00, '2021-04-18', 2),
(21, 'Aditya Bose', 103, 'Marketing', 'SEO Specialist', 60000.00, '2021-08-30', 2),

-- HR Department (Salary Range: 50000 - 85000 = 35000 difference)
(22, 'Sunita Pillai', 104, 'HR', 'HR Manager', 85000.00, '2019-03-10', 5),
(23, 'Manish Tiwari', 104, 'HR', 'Talent Acquisition Lead', 70000.00, '2020-07-15', 3),
(24, 'Neha Sinha', 104, 'HR', 'Payroll Specialist', 60000.00, '2020-05-28', 3),
(25, 'Ritu Bansal', 104, 'HR', 'HR Executive', 55000.00, '2021-09-20', 2),
(26, 'Arun Kumar', 104, 'HR', 'Training Coordinator', 50000.00, '2021-11-05', 1),

-- Finance Department (Salary Range: 65000 - 110000 = 45000 difference)
(27, 'Suresh Krishnan', 105, 'Finance', 'Finance Manager', 110000.00, '2018-08-12', 6),
(28, 'Lakshmi Narayan', 105, 'Finance', 'Senior Accountant', 80000.00, '2019-11-20', 4),
(29, 'Prakash Reddy', 105, 'Finance', 'Financial Analyst', 75000.00, '2020-04-15', 3),
(30, 'Swati Bhatt', 105, 'Finance', 'Accounts Executive', 65000.00, '2021-06-10', 2);
