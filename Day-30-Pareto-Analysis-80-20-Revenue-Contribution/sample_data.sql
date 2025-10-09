-- Day 30: Pareto Analysis - 80/20 Revenue Contribution - Sample Data

-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    brand VARCHAR(50),
    launch_date DATE
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    qty INT,
    price DECIMAL(10,2),
    sale_date DATE,
    region VARCHAR(50)
);

-- Insert sample data into Products
INSERT INTO Products VALUES
(101, 'iPhone 15 Pro Max', 'Electronics', 'Apple', '2023-09-15'),
(102, 'MacBook Pro M3', 'Electronics', 'Apple', '2023-11-10'),
(103, 'Samsung Galaxy S24', 'Electronics', 'Samsung', '2024-01-20'),
(104, 'iPad Air', 'Electronics', 'Apple', '2024-03-15'),
(105, 'AirPods Pro', 'Electronics', 'Apple', '2023-09-20'),
(106, 'Dell XPS 13', 'Electronics', 'Dell', '2023-10-05'),
(107, 'Sony WH-1000XM5', 'Electronics', 'Sony', '2023-08-20'),
(108, 'Samsung Watch', 'Electronics', 'Samsung', '2024-01-25'),
(109, 'Canon EOS R5', 'Electronics', 'Canon', '2023-07-10'),
(110, 'Bose Speaker', 'Electronics', 'Bose', '2023-12-01');

-- Insert sample data into Sales (Designed to follow Pareto distribution)
INSERT INTO Sales VALUES
-- PRODUCT 101 (iPhone) - TOP REVENUE DRIVER: 135 units × ₹159,900 = ₹2,15,86,500 (61.08%)
(5001, 101, 50, 159900.00, '2024-01-15', 'North'),
(5002, 101, 45, 159900.00, '2024-02-20', 'South'),
(5003, 101, 40, 159900.00, '2024-03-10', 'East'),

-- PRODUCT 102 (MacBook) - SECOND HIGHEST: 45 units × ₹249,900 = ₹1,12,45,500 (31.81%)
-- Combined with iPhone = 92.89% (demonstrates 80/20 rule with just 2 products = 20%)
(5004, 102, 25, 249900.00, '2024-01-25', 'West'),
(5005, 102, 20, 249900.00, '2024-02-18', 'North'),

-- PRODUCT 109 (Canon Camera) - PREMIUM PRODUCT: 15 units × ₹299,900 = ₹44,98,500 (12.73%)
(5006, 109, 15, 299900.00, '2024-02-15', 'South'),

-- PRODUCT 106 (Dell Laptop) - MID-RANGE: 18 units × ₹145,000 = ₹26,10,000 (7.38%)
(5007, 106, 18, 145000.00, '2024-01-30', 'East'),

-- PRODUCT 103 (Samsung Galaxy) - VOLUME SELLER: 30 units × ₹89,999 = ₹26,99,970 (7.64%)
(5008, 103, 30, 89999.00, '2024-03-05', 'West'),

-- PRODUCT 104 (iPad) - TABLET SEGMENT: 35 units × ₹59,900 = ₹20,96,500 (5.93%)
(5009, 104, 35, 59900.00, '2024-01-20', 'North'),

-- PRODUCT 107 (Sony Headphones) - ACCESSORIES: 25 units × ₹34,999 = ₹8,74,975 (2.48%)
(5010, 107, 25, 34999.00, '2024-02-10', 'South'),

-- PRODUCT 105 (AirPods) - HIGH VOLUME LOW PRICE: 40 units × ₹24,900 = ₹9,96,000 (2.82%)
(5011, 105, 40, 24900.00, '2024-03-15', 'East'),

-- PRODUCT 108 (Samsung Watch) - WEARABLES: 20 units × ₹29,999 = ₹5,99,980 (1.70%)
(5012, 108, 20, 29999.00, '2024-01-28', 'West'),

-- PRODUCT 110 (Bose Speaker) - AUDIO: 12 units × ₹45,999 = ₹5,51,988 (1.56%)
(5013, 110, 12, 45999.00, '2024-02-22', 'North');
