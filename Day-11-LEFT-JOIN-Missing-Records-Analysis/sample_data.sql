-- Day 11: Finding Missing Records with LEFT JOIN - Sample Data

-- Create Products table
CREATE TABLE Products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    unit_price DECIMAL(10,2),
    stock_quantity INT,
    launch_date DATE,
    status VARCHAR(20)
);

-- Create Sales table
CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    customer_id INT,
    quantity INT,
    sale_price DECIMAL(10,2),
    sale_date DATE,
    region VARCHAR(50)
);

-- Insert sample data into Products
INSERT INTO Products VALUES
-- Electronics Category (Mix of sold and never sold)
(101, 'iPhone 15 Pro Max', 'Electronics', 159900.00, 50, '2023-09-15', 'Active'),      -- SOLD
(102, 'Samsung Galaxy S24 Ultra', 'Electronics', 139999.00, 30, '2024-01-20', 'Active'), -- SOLD
(103, 'MacBook Pro M3', 'Electronics', 249900.00, 20, '2023-11-10', 'Active'),         -- SOLD
(104, 'iPad Air M2', 'Electronics', 89900.00, 25, '2024-03-15', 'Active'),             -- NEVER SOLD
(105, 'Sony WH-1000XM5', 'Electronics', 34999.00, 40, '2023-08-20', 'Active'),        -- SOLD
(106, 'Dell XPS 13', 'Electronics', 145000.00, 15, '2024-02-10', 'Active'),            -- NEVER SOLD
(107, 'HP Spectre x360', 'Electronics', 125000.00, 10, '2024-05-20', 'Active'),        -- NEVER SOLD

-- Fashion Category (Mix of sold and never sold)
(201, 'Nike Air Jordan 1', 'Fashion', 18999.00, 60, '2023-07-10', 'Active'),           -- SOLD
(202, 'Adidas Ultraboost 22', 'Fashion', 16999.00, 45, '2023-09-05', 'Active'),        -- SOLD
(203, 'Levi\'s 501 Jeans', 'Fashion', 4999.00, 80, '2023-06-15', 'Active'),            -- SOLD
(204, 'Zara Premium Jacket', 'Fashion', 7999.00, 35, '2024-01-25', 'Active'),          -- NEVER SOLD
(205, 'H&M Designer Dress', 'Fashion', 2999.00, 50, '2024-04-10', 'Active'),           -- NEVER SOLD

-- Home & Kitchen Category (Mostly never sold - slow category)
(301, 'Philips Air Fryer XL', 'Home & Kitchen', 12999.00, 25, '2023-12-01', 'Active'), -- SOLD
(302, 'Samsung Smart Refrigerator', 'Home & Kitchen', 89999.00, 8, '2024-01-15', 'Active'), -- NEVER SOLD
(303, 'Dyson V15 Vacuum', 'Home & Kitchen', 45999.00, 12, '2024-03-20', 'Active'),     -- NEVER SOLD
(304, 'KitchenAid Stand Mixer', 'Home & Kitchen', 35999.00, 15, '2024-06-05', 'Active'), -- NEVER SOLD

-- Books Category (Mix of sold and never sold)
(401, 'The Psychology of Money', 'Books', 599.00, 100, '2023-05-10', 'Active'),        -- SOLD
(402, 'Atomic Habits', 'Books', 699.00, 80, '2023-07-20', 'Active'),                   -- SOLD
(403, 'Think and Grow Rich', 'Books', 399.00, 120, '2023-08-15', 'Active'),            -- SOLD
(404, 'Rich Dad Poor Dad', 'Books', 499.00, 90, '2023-09-10', 'Active');               -- NEVER SOLD

-- Insert sample data into Sales (Intentionally missing some product_ids)
INSERT INTO Sales VALUES
-- Electronics Sales (Notice: 104, 106, 107 are missing)
(1001, 101, 1001, 2, 159900.00, '2024-01-15', 'North'),
(1002, 101, 1002, 1, 159900.00, '2024-02-20', 'South'),
(1003, 102, 1003, 1, 139999.00, '2024-03-10', 'East'),
(1004, 103, 1004, 1, 249900.00, '2024-01-25', 'West'),
(1005, 105, 1005, 3, 34999.00, '2024-04-15', 'North'),

-- Fashion Sales (Notice: 204, 205 are missing)
(1006, 201, 1006, 1, 18999.00, '2024-02-10', 'South'),
(1007, 202, 1007, 2, 16999.00, '2024-03-20', 'East'),
(1008, 203, 1008, 3, 4999.00, '2024-05-15', 'West'),

-- Home & Kitchen Sales (Notice: 302, 303, 304 are missing)
(1009, 301, 1009, 1, 12999.00, '2024-06-20', 'North'),

-- Books Sales (Notice: 404 is missing)
(1010, 401, 1010, 5, 599.00, '2024-07-10', 'South'),
(1011, 402, 1011, 2, 699.00, '2024-08-15', 'East'),
(1012, 403, 1012, 3, 399.00, '2024-09-20', 'West');

-- SUMMARY: Products NEVER SOLD (9 products total):
-- Electronics: 104 (iPad Air M2), 106 (Dell XPS 13), 107 (HP Spectre x360)
-- Fashion: 204 (Zara Premium Jacket), 205 (H&M Designer Dress)
-- Home & Kitchen: 302 (Samsung Smart Refrigerator), 303 (Dyson V15 Vacuum), 304 (KitchenAid Stand Mixer)
-- Books: 404 (Rich Dad Poor Dad)
