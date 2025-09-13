-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2)
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2),
    sale_date DATE,
    customer_id INT
);

-- Insert sample data into Products
INSERT INTO Products VALUES
(1, 'iPhone 16 Pro Max', 'Electronics', 159900.00),
(2, 'Samsung Galaxy S25 Ultra', 'Electronics', 139999.00),
(3, 'MacBook Pro M4', 'Electronics', 249900.00),
(4, 'Dell XPS 15', 'Electronics', 185000.00),
(5, 'Sony WH-1000XM6', 'Electronics', 34999.00),
(6, 'Nike Air Jordan 1 High', 'Fashion', 18999.00),
(7, 'Adidas Yeezy Boost 350 V3', 'Fashion', 25999.00);

-- Insert sample data into Sales 
INSERT INTO Sales VALUES
(1, 1, 2, 159900.00, '2025-07-15', 101),
(2, 1, 1, 159900.00, '2025-07-20', 102),
(3, 2, 3, 139999.00, '2025-07-25', 103),
(4, 3, 1, 249900.00, '2025-08-10', 104),
(5, 1, 1, 159900.00, '2025-08-14', 105),
(6, 4, 2, 185000.00, '2025-08-20', 106),
(7, 5, 4, 34999.00, '2025-08-25', 107),
(8, 2, 1, 139999.00, '2025-09-01', 108),
(9, 6, 3, 18999.00, '2025-09-05', 109),
(10, 7, 2, 25999.00, '2025-09-08', 110),
(11, 3, 1, 249900.00, '2025-09-10', 111),
(12, 1, 1, 159900.00, '2025-09-12', 112);
