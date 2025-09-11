-- Day-02-Second-Highest-Salary


-- Create Employee table
CREATE TABLE Employee (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(100),
    department VARCHAR(50),
    salary DECIMAL(10,2)
);

-- Insert sample data
INSERT INTO Employee VALUES
(1, 'Rajesh Sharma', 'Engineering', 120000.00),
(2, 'Priya Patel', 'Marketing', 95000.00),
(3, 'Amit Kumar', 'Engineering', 150000.00),
(4, 'Sneha Reddy', 'HR', 85000.00),
(5, 'Vikram Singh', 'Sales', 110000.00),
(6, 'Anita Joshi', 'Engineering', 135000.00),
(7, 'Rohit Verma', 'Marketing', 88000.00);
