-- Day 25: Department Performance Analysis by Average Salary
-- Sample Data SQL File

-- Insert Sample Data into Employee Table

-- Engineering Department (101) - Highest Average Salary
INSERT INTO Employee VALUES
(1001, 'Rajesh Kumar', 101, 'Engineering', 'Chief Technology Officer', 220000.00, '2020-01-15', 12, 'Excellent'),
(1002, 'Amit Patel', 101, 'Engineering', 'Engineering Manager', 180000.00, '2020-03-20', 10, 'Excellent'),
(1003, 'Sneha Reddy', 101, 'Engineering', 'Senior Software Engineer', 150000.00, '2021-06-10', 7, 'Excellent'),
(1004, 'Karthik Nair', 101, 'Engineering', 'Software Engineer', 120000.00, '2022-02-14', 5, 'Good'),
(1005, 'Priya Sharma', 101, 'Engineering', 'Senior DevOps Engineer', 165000.00, '2021-08-22', 8, 'Excellent'),
(1006, 'Vikram Singh', 101, 'Engineering', 'Junior Developer', 95000.00, '2023-11-05', 2, 'Good'),

-- Finance Department (102) - Second Highest Average
INSERT INTO Employee VALUES
(2001, 'Meera Iyer', 102, 'Finance', 'Finance Director', 180000.00, '2019-08-30', 11, 'Excellent'),
(2002, 'Suresh Gupta', 102, 'Finance', 'Senior Financial Analyst', 155000.00, '2021-11-15', 8, 'Excellent'),
(2003, 'Pooja Rao', 102, 'Finance', 'Financial Analyst', 105000.00, '2022-05-20', 5, 'Good'),

-- Sales Department (103) - Mid-range Average
INSERT INTO Employee VALUES
(3001, 'Anita Desai', 103, 'Sales', 'Sales Director', 160000.00, '2020-07-08', 9, 'Excellent'),
(3002, 'Rohit Mehta', 103, 'Sales', 'Senior Sales Manager', 130000.00, '2021-04-18', 6, 'Excellent'),
(3003, 'Deepa Joshi', 103, 'Sales', 'Sales Manager', 110000.00, '2022-10-12', 4, 'Good'),
(3004, 'Arjun Nair', 103, 'Sales', 'Sales Executive', 85000.00, '2023-05-10', 2, 'Good'),

-- Marketing Department (104) - Below Mid-range
INSERT INTO Employee VALUES
(4001, 'Kavya Pillai', 104, 'Marketing', 'Marketing Director', 120000.00, '2021-08-22', 7, 'Excellent'),
(4002, 'Ganesh Reddy', 104, 'Marketing', 'Marketing Manager', 110000.00, '2022-06-10', 5, 'Good'),
(4003, 'Sanjay Patel', 104, 'Marketing', 'Digital Marketing Specialist', 85000.00, '2023-02-13', 3, 'Good'),
(4004, 'Neha Agarwal', 104, 'Marketing', 'Content Writer', 72000.00, '2023-12-14', 1, 'Average'),

-- HR Department (105) - Lowest Average
INSERT INTO Employee VALUES
(5001, 'Lakshmi Menon', 105, 'HR', 'HR Manager', 95000.00, '2021-11-30', 6, 'Excellent'),
(5002, 'Ravi Krishnan', 105, 'HR', 'HR Executive', 89000.00, '2022-12-05', 3, 'Good'),
(5003, 'Divya Sharma', 105, 'HR', 'Recruiter', 68000.00, '2023-09-18', 2, 'Average');

-- Additional employees for better distribution

-- More Engineering employees
INSERT INTO Employee VALUES
(1007, 'Arun Kumar', 101, 'Engineering', 'Tech Lead', 175000.00, '2020-09-15', 9, 'Excellent'),
(1008, 'Nisha Kapoor', 101, 'Engineering', 'QA Manager', 140000.00, '2021-12-20', 6, 'Good'),

-- More Sales employees  
INSERT INTO Employee VALUES
(3005, 'Vishal Rao', 103, 'Sales', 'Account Manager', 115000.00, '2022-03-25', 4, 'Good');

-- More Marketing employees
INSERT INTO Employee VALUES
(4005, 'Rekha Pillai', 104, 'Marketing', 'SEO Specialist', 78000.00, '2023-07-08', 2, 'Good'),
(4006, 'Manoj Kumar', 104, 'Marketing', 'Graphic Designer', 82000.00, '2023-04-15', 3, 'Good');

-- More Finance employees
INSERT INTO Employee VALUES
(2004, 'Harish Mehta', 102, 'Finance', 'Accountant', 98000.00, '2023-01-10', 4, 'Average');

-- More HR employees
INSERT INTO Employee VALUES
(5004, 'Sunita Devi', 105, 'HR', 'HR Coordinator', 75000.00, '2023-06-22', 2, 'Average');

-- Cross-functional roles
INSERT INTO Employee VALUES
(6001, 'Ramesh Jain', 106, 'Operations', 'Operations Manager', 135000.00, '2021-05-15', 8, 'Excellent'),
(6002, 'Gita Nair', 106, 'Operations', 'Operations Coordinator', 92000.00, '2022-08-20', 4, 'Good'),
(6003, 'Mohan Reddy', 106, 'Operations', 'Logistics Specialist', 85000.00, '2023-03-10', 3, 'Good');

-- IT Support Department
INSERT INTO Employee VALUES
(7001, 'Anil Verma', 107, 'IT Support', 'IT Manager', 115000.00, '2021-09-12', 7, 'Excellent'),
(7002, 'Lata Sharma', 107, 'IT Support', 'System Administrator', 88000.00, '2022-11-25', 4, 'Good'),
(7003, 'Sunil Agarwal', 107, 'IT Support', 'Help Desk Analyst', 65000.00, '2023-08-30', 2, 'Average');

-- Product Management
INSERT INTO Employee VALUES
(8001, 'Pradeep Singh', 108, 'Product', 'Product Manager', 155000.00, '2020-10-18', 9, 'Excellent'),
(8002, 'Mala Iyer', 108, 'Product', 'Associate Product Manager', 105000.00, '2022-04-22', 5, 'Good'),
(8003, 'Vinod Joshi', 108, 'Product', 'Product Analyst', 95000.00, '2023-02-15', 3, 'Good');

-- Customer Success
INSERT INTO Employee VALUES
(9001, 'Shanti Gupta', 109, 'Customer Success', 'CS Manager', 110000.00, '2021-07-20', 6, 'Excellent'),
(9002, 'Prema Rao', 109, 'Customer Success', 'CS Specialist', 82000.00, '2022-09-10', 3, 'Good'),
(9003, 'Kamala Devi', 109, 'Customer Success', 'Support Associate', 68000.00, '2023-11-15', 1, 'Average');
