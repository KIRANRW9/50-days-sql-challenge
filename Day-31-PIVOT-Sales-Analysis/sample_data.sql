-- Day 31: PIVOT Sales Analysis

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    sale_month VARCHAR(20),
    sale_amount DECIMAL(10,2),
    sale_date DATE
);

-- Insert sample data into Sales
-- Laptop sales across 6 months
INSERT INTO Sales VALUES
(1, 'Laptop', 'Electronics', 'January', 125000.00, '2024-01-15'),
(2, 'Laptop', 'Electronics', 'February', 135000.00, '2024-02-15'),
(3, 'Laptop', 'Electronics', 'March', 142000.00, '2024-03-15'),
(4, 'Laptop', 'Electronics', 'April', 138000.00, '2024-04-15'),
(5, 'Laptop', 'Electronics', 'May', 145000.00, '2024-05-15'),
(6, 'Laptop', 'Electronics', 'June', 155000.00, '2024-06-15');

-- Smartphone sales across 6 months
INSERT INTO Sales VALUES
(7, 'Smartphone', 'Electronics', 'January', 95000.00, '2024-01-20'),
(8, 'Smartphone', 'Electronics', 'February', 102000.00, '2024-02-20'),
(9, 'Smartphone', 'Electronics', 'March', 108000.00, '2024-03-20'),
(10, 'Smartphone', 'Electronics', 'April', 105000.00, '2024-04-20'),
(11, 'Smartphone', 'Electronics', 'May', 112000.00, '2024-05-20'),
(12, 'Smartphone', 'Electronics', 'June', 118000.00, '2024-06-20');

-- Tablet sales across 6 months
INSERT INTO Sales VALUES
(13, 'Tablet', 'Electronics', 'January', 65000.00, '2024-01-25'),
(14, 'Tablet', 'Electronics', 'February', 68000.00, '2024-02-25'),
(15, 'Tablet', 'Electronics', 'March', 72000.00, '2024-03-25'),
(16, 'Tablet', 'Electronics', 'April', 70000.00, '2024-04-25'),
(17, 'Tablet', 'Electronics', 'May', 75000.00, '2024-05-25'),
(18, 'Tablet', 'Electronics', 'June', 78000.00, '2024-06-25');

-- Smartwatch sales across 6 months
INSERT INTO Sales VALUES
(19, 'Smartwatch', 'Accessories', 'January', 45000.00, '2024-01-10'),
(20, 'Smartwatch', 'Accessories', 'February', 48000.00, '2024-02-10'),
(21, 'Smartwatch', 'Accessories', 'March', 52000.00, '2024-03-10'),
(22, 'Smartwatch', 'Accessories', 'April', 50000.00, '2024-04-10'),
(23, 'Smartwatch', 'Accessories', 'May', 55000.00, '2024-05-10'),
(24, 'Smartwatch', 'Accessories', 'June', 58000.00, '2024-06-10');

-- Headphones sales across 6 months
INSERT INTO Sales VALUES
(25, 'Headphones', 'Accessories', 'January', 35000.00, '2024-01-12'),
(26, 'Headphones', 'Accessories', 'February', 38000.00, '2024-02-12'),
(27, 'Headphones', 'Accessories', 'March', 42000.00, '2024-03-12'),
(28, 'Headphones', 'Accessories', 'April', 40000.00, '2024-04-12'),
(29, 'Headphones', 'Accessories', 'May', 45000.00, '2024-05-12'),
(30, 'Headphones', 'Accessories', 'June', 48000.00, '2024-06-12');
