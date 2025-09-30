-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    brand VARCHAR(50)
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    sale_date DATE,
    region VARCHAR(50)
);

-- Insert sample data into Products
INSERT INTO Products VALUES
(101, 'iPhone 15 Pro Max', 'Electronics', 159900.00, 'Apple'),
(102, 'Samsung Galaxy S24', 'Electronics', 89999.00, 'Samsung'),
(103, 'MacBook Pro M3', 'Electronics', 249900.00, 'Apple'),
(104, 'iPad Air', 'Electronics', 59900.00, 'Apple'),
(105, 'Sony WH-1000XM5', 'Electronics', 34999.00, 'Sony'),
(106, 'Dell XPS 13', 'Electronics', 145000.00, 'Dell'),
(107, 'AirPods Pro', 'Electronics', 24900.00, 'Apple'),
(108, 'Samsung Watch', 'Electronics', 29999.00, 'Samsung'),
(109, 'Canon EOS R5', 'Electronics', 299900.00, 'Canon'),
(110, 'Bose Speaker', 'Electronics', 45999.00, 'Bose');

-- Insert sample data into Sales
INSERT INTO Sales VALUES
-- High revenue products
(1001, 101, 15, 159900.00, '2024-01-15', 'North'),
(1002, 101, 12, 159900.00, '2024-02-20', 'South'),
(1003, 101, 10, 159900.00, '2024-03-10', 'East'),
(1004, 103, 8, 249900.00, '2024-01-25', 'West'),
(1005, 103, 6, 249900.00, '2024-02-18', 'North'),

-- Medium revenue products
(1006, 106, 5, 145000.00, '2024-01-30', 'South'),
(1007, 109, 3, 299900.00, '2024-02-15', 'East'),
(1008, 102, 10, 89999.00, '2024-03-05', 'West'),
(1009, 104, 12, 59900.00, '2024-01-20', 'North'),

-- Lower revenue products
(1010, 105, 20, 34999.00, '2024-02-10', 'South'),
(1011, 107, 25, 24900.00, '2024-03-15', 'East'),
(1012, 108, 15, 29999.00, '2024-01-28', 'West'),
(1013, 110, 8, 45999.00, '2024-02-22', 'North'),

-- Additional sales for distribution
(1014, 101, 8, 159900.00, '2024-03-20', 'South'),
(1015, 102, 7, 89999.00, '2024-03-25', 'East'),
(1016, 105, 15, 34999.00, '2024-03-18', 'West'),
(1017, 107, 18, 24900.00, '2024-03-12', 'North'),
(1018, 104, 10, 59900.00, '2024-03-28', 'South');
