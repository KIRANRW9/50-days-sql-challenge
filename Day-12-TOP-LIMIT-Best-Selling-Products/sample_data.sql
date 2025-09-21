-- Day 12: Top Selling Products Analysis - Sample Data

-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    launch_date DATE,
    brand VARCHAR(50)
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    quantity INT,
    sale_date DATE,
    region VARCHAR(50),
    discount_percent DECIMAL(5,2)
);

-- Insert sample data into Products
INSERT INTO Products VALUES
(101, 'iPhone 15 Pro Max', 'Electronics', 159900.00, '2023-09-15', 'Apple'),
(102, 'Samsung Galaxy S24', 'Electronics', 89999.00, '2024-01-20', 'Samsung'),
(103, 'MacBook Pro M3', 'Electronics', 249900.00, '2023-11-10', 'Apple'),
(104, 'Nike Air Jordan 1', 'Fashion', 18999.00, '2023-07-10', 'Nike'),
(105, 'Sony WH-1000XM5', 'Electronics', 34999.00, '2023-08-20', 'Sony'),
(106, 'Adidas Ultraboost', 'Fashion', 16999.00, '2023-09-05', 'Adidas'),
(107, 'Dell XPS 13', 'Electronics', 145000.00, '2024-02-10', 'Dell'),
(108, 'Levi\'s 501 Jeans', 'Fashion', 4999.00, '2023-06-15', 'Levi\'s'),
(109, 'Canon EOS R5', 'Electronics', 299900.00, '2023-10-05', 'Canon'),
(110, 'Philips Air Fryer', 'Home & Kitchen', 12999.00, '2023-12-01', 'Philips');

-- Insert sample data into Sales
INSERT INTO Sales VALUES
-- iPhone 15 Pro Max - TOP SELLER (Total: 20 units)
(1001, 101, 2001, 3, '2024-01-15', 'North', 0.00),
(1002, 101, 2002, 2, '2024-02-20', 'South', 5.00),
(1003, 101, 2003, 4, '2024-03-10', 'East', 0.00),
(1004, 101, 2004, 1, '2024-04-15', 'West', 10.00),
(1005, 101, 2005, 5, '2024-05-20', 'North', 0.00),
(1006, 101, 2006, 2, '2024-06-25', 'South', 5.00),
(1007, 101, 2007, 3, '2024-07-30', 'East', 0.00),

-- Sony WH-1000XM5 - SECOND BEST (Total: 18 units)
(1008, 105, 2008, 6, '2024-01-10', 'North', 15.00),
(1009, 105, 2009, 4, '2024-02-14', 'South', 10.00),
(1010, 105, 2010, 5, '2024-03-18', 'East', 12.00),
(1011, 105, 2011, 3, '2024-04-22', 'West', 8.00),

-- Levi's 501 Jeans - THIRD BEST (Total: 15 units)
(1017, 108, 2017, 5, '2024-02-05', 'South', 20.00),
(1018, 108, 2018, 4, '2024-02-15', 'East', 15.00),
(1019, 108, 2019, 6, '2024-03-20', 'West', 25.00),

-- Nike Air Jordan 1 - FOURTH (Total: 14 units)
(1012, 104, 2012, 2, '2024-01-25', 'North', 0.00),
(1013, 104, 2013, 3, '2024-02-28', 'South', 0.00),
(1014, 104, 2014, 4, '2024-03-15', 'East', 5.00),
(1015, 104, 2015, 2, '2024-04-10', 'West', 0.00),
(1016, 104, 2016, 3, '2024-05-05', 'North', 0.00),

-- Adidas Ultraboost - FIFTH (Total: 9 units)
(1023, 106, 2023, 3, '2024-01-18', 'West', 10.00),
(1024, 106, 2024, 2, '2024-02-24', 'North', 15.00),
(1025, 106, 2025, 4, '2024-03-28', 'South', 5.00),

-- Samsung Galaxy S24 - Moderate sales (Total: 6 units)
(1020, 102, 2020, 2, '2024-01-12', 'North', 10.00),
(1021, 102, 2021, 3, '2024-02-16', 'South', 8.00),
(1022, 102, 2022, 1, '2024-03-22', 'East', 12.00),

-- Philips Air Fryer - Kitchen category leader (Total: 5 units)
(1030, 110, 2030, 3, '2024-02-10', 'East', 12.00),
(1031, 110, 2031, 2, '2024-03-12', 'West', 15.00),

-- MacBook Pro M3 - Premium, lower quantity (Total: 3 units)
(1026, 103, 2026, 1, '2024-01-30', 'East', 0.00),
(1027, 103, 2027, 2, '2024-02-25', 'West', 5.00),

-- Dell XPS 13 - Business laptop (Total: 3 units)
(1028, 107, 2028, 1, '2024-03-05', 'North', 8.00),
(1029, 107, 2029, 2, '2024-03-15', 'South', 10.00);

-- RANKING SUMMARY:
-- 1. iPhone 15 Pro Max (101): 20 units
-- 2. Sony WH-1000XM5 (105): 18 units  
-- 3. Levi's 501 Jeans (108): 15 units
-- 4. Nike Air Jordan 1 (104): 14 units
-- 5. Adidas Ultraboost (106): 9 units
