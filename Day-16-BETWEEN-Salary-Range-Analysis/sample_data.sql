-- Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    hire_date DATE,
    experience_years INT,
    location VARCHAR(50),
    performance_rating VARCHAR(10)
);

-- Insert sample data into Employees
INSERT INTO Employees VALUES
-- Below target range (Under 50,000)
(1001, 'Ravi Kumar', 'Support', 'Junior Support Specialist', 35000.00, '2024-01-15', 1, 'Chennai', 'Good'),
(1002, 'Anjali Sharma', 'Admin', 'Administrative Assistant', 42000.00, '2024-02-20', 2, 'Mumbai', 'Excellent'),
(1003, 'Suresh Patel', 'Security', 'Security Guard', 38000.00, '2023-11-10', 3, 'Pune', 'Good'),
(1004, 'Meera Reddy', 'Housekeeping', 'Facility Coordinator', 45000.00, '2024-03-05', 1, 'Bangalore', 'Good'),

-- TARGET RANGE: 50,000 - 100,000 (Main focus of analysis)
(1005, 'Rajesh Kumar', 'HR', 'HR Executive', 65000.00, '2023-09-15', 2, 'Delhi', 'Excellent'),
(1006, 'Priya Sharma', 'Sales', 'Sales Executive', 75000.00, '2023-08-20', 3, 'Mumbai', 'Excellent'),
(1007, 'Amit Patel', 'Marketing', 'Marketing Specialist', 82000.00, '2024-01-25', 4, 'Bangalore', 'Good'),
(1008, 'Sneha Reddy', 'Finance', 'Junior Accountant', 58000.00, '2024-02-10', 1, 'Hyderabad', 'Good'),
(1009, 'Vikram Singh', 'IT', 'System Administrator', 95000.00, '2023-07-12', 5, 'Pune', 'Excellent'),
(1010, 'Kavya Pillai', 'Operations', 'Operations Coordinator', 70000.00, '2023-12-18', 3, 'Kochi', 'Good'),
(1011, 'Arjun Nair', 'Customer Service', 'Senior Support Specialist', 68000.00, '2024-01-08', 4, 'Chennai', 'Good'),
(1012, 'Deepa Joshi', 'Quality', 'QA Analyst', 78000.00, '2023-10-22', 3, 'Delhi', 'Excellent'),
(1013, 'Rohit Mehta', 'Procurement', 'Purchase Executive', 72000.00, '2024-03-14', 2, 'Mumbai', 'Good'),
(1014, 'Anita Desai', 'Training', 'Training Coordinator', 88000.00, '2023-11-30', 4, 'Bangalore', 'Excellent'),
(1015, 'Suresh Gupta', 'Legal', 'Legal Assistant', 85000.00, '2024-02-05', 3, 'Delhi', 'Good'),
(1016, 'Lakshmi Menon', 'Research', 'Research Analyst', 92000.00, '2023-09-28', 5, 'Hyderabad', 'Excellent'),

-- Above target range (Above 100,000)
(1017, 'Ganesh Reddy', 'Engineering', 'Senior Software Engineer', 125000.00, '2023-06-10', 6, 'Bangalore', 'Excellent'),
(1018, 'Karthik Nair', 'Sales', 'Sales Manager', 140000.00, '2023-04-15', 8, 'Mumbai', 'Excellent'),
(1019, 'Pooja Rao', 'Finance', 'Financial Manager', 160000.00, '2023-02-20', 10, 'Delhi', 'Excellent'),
(1020, 'Sanjay Patel', 'IT', 'IT Manager', 180000.00, '2023-01-12', 12, 'Bangalore', 'Excellent'),
(1021, 'Neha Agarwal', 'Marketing', 'Marketing Manager', 150000.00, '2023-03-25', 9, 'Mumbai', 'Excellent'),
(1022, 'Arun Kumar', 'Operations', 'Operations Manager', 170000.00, '2023-05-18', 11, 'Chennai', 'Excellent');
