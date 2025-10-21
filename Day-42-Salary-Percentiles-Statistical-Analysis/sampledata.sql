-- Day 42: Salary Percentiles Analysis - Sample Data

-- Create Employees table
CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(100),
    department VARCHAR(50),
    position VARCHAR(50),
    salary DECIMAL(10,2),
    experience_years INT,
    hire_date DATE,
    location VARCHAR(50)
);

-- Insert sample data into Employees (20 employees with distributed salaries)
INSERT INTO Employees VALUES
-- BOTTOM QUARTILE (0-25th Percentile): Entry Level - ₹35K to ₹48K
(1001, 'Ravi Kumar', 'Support', 'Junior Support', 35000.00, 1, '2023-01-15', 'Chennai'),
(1002, 'Anjali Sharma', 'Admin', 'Admin Assistant', 42000.00, 2, '2023-02-20', 'Mumbai'),
(1003, 'Suresh Patel', 'Sales', 'Sales Trainee', 38000.00, 1, '2023-03-10', 'Pune'),
(1004, 'Meera Reddy', 'Marketing', 'Content Writer', 45000.00, 2, '2023-04-05', 'Bangalore'),
(1005, 'Kiran Singh', 'IT', 'Junior Developer', 48000.00, 1, '2023-05-12', 'Delhi'),

-- SECOND QUARTILE (25th-50th Percentile): Mid Level - ₹65K to ₹95K
(1006, 'Rajesh Kumar', 'HR', 'HR Executive', 65000.00, 3, '2023-06-18', 'Mumbai'),
(1007, 'Priya Sharma', 'Sales', 'Sales Executive', 75000.00, 4, '2023-07-22', 'Delhi'),
(1008, 'Amit Patel', 'Marketing', 'Marketing Specialist', 82000.00, 5, '2023-08-14', 'Bangalore'),
(1009, 'Sneha Reddy', 'Finance', 'Accountant', 70000.00, 3, '2023-09-08', 'Hyderabad'),
(1010, 'Vikram Singh', 'IT', 'Software Engineer', 95000.00, 4, '2023-10-25', 'Pune'),

-- THIRD QUARTILE (50th-75th Percentile): Senior Level - ₹110K to ₹150K
(1011, 'Kavya Pillai', 'Operations', 'Operations Manager', 110000.00, 6, '2023-11-30', 'Chennai'),
(1012, 'Arjun Nair', 'IT', 'Senior Developer', 125000.00, 7, '2023-12-18', 'Mumbai'),
(1013, 'Deepa Joshi', 'Finance', 'Senior Accountant', 130000.00, 6, '2024-01-08', 'Delhi'),
(1014, 'Rohit Mehta', 'Sales', 'Sales Manager', 140000.00, 8, '2024-02-22', 'Bangalore'),
(1015, 'Anita Desai', 'Marketing', 'Marketing Manager', 150000.00, 7, '2024-03-14', 'Hyderabad'),

-- TOP QUARTILE (75th-100th Percentile): Leadership - ₹180K to ₹300K
(1016, 'Suresh Gupta', 'IT', 'IT Manager', 180000.00, 10, '2024-04-05', 'Pune'),
(1017, 'Lakshmi Menon', 'Finance', 'Finance Manager', 200000.00, 12, '2024-05-28', 'Chennai'),
(1018, 'Ganesh Reddy', 'Engineering', 'Engineering Manager', 220000.00, 11, '2024-06-15', 'Mumbai'),
(1019, 'Karthik Nair', 'Sales', 'Sales Director', 250000.00, 13, '2024-07-20', 'Delhi'),
(1020, 'Pooja Rao', 'Operations', 'VP Operations', 300000.00, 15, '2024-08-12', 'Bangalore');
