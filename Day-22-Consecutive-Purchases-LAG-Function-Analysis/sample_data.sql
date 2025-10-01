-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    customer_tier VARCHAR(20)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    order_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Insert sample data into Customers
INSERT INTO Customers VALUES
(3001, 'Rajesh Kumar', 'rajesh.kumar@email.com', '2023-12-01', 'Premium'),
(3002, 'Priya Sharma', 'priya.sharma@email.com', '2023-11-15', 'Gold'),
(3003, 'Amit Patel', 'amit.patel@email.com', '2023-10-20', 'Silver'),
(3004, 'Sneha Reddy', 'sneha.reddy@email.com', '2023-12-10', 'Premium'),
(3005, 'Vikram Singh', 'vikram.singh@email.com', '2023-09-25', 'Gold'),
(3006, 'Anita Desai', 'anita.desai@email.com', '2023-11-30', 'Silver');

-- Insert sample data into Orders
INSERT INTO Orders VALUES
-- CUSTOMER 3001 (Rajesh Kumar) - CONSECUTIVE DAILY PURCHASES
(4001, 3001, 'iPhone 15 Pro', 129900.00, '2024-01-15', 'Delivered'),
(4002, 3001, 'MacBook Pro', 199900.00, '2024-01-16', 'Delivered'),  -- 1 day after
(4003, 3001, 'iPad Air', 59900.00, '2024-01-17', 'Delivered'),      -- 1 day after
(4004, 3001, 'AirPods Pro', 24900.00, '2024-01-20', 'Delivered'),
(4005, 3001, 'Apple Watch', 45900.00, '2024-01-21', 'Delivered'),   -- 1 day after

-- CUSTOMER 3002 (Priya Sharma) - NO CONSECUTIVE PURCHASES
(4006, 3002, 'Samsung TV', 89999.00, '2024-01-10', 'Delivered'),
(4007, 3002, 'Washing Machine', 45999.00, '2024-01-15', 'Delivered'),
(4008, 3002, 'Refrigerator', 89999.00, '2024-01-22', 'Delivered'),

-- CUSTOMER 3003 (Amit Patel) - LONG CONSECUTIVE STREAK
(4009, 3003, 'Laptop', 125000.00, '2024-02-01', 'Delivered'),
(4010, 3003, 'Monitor', 35000.00, '2024-02-02', 'Delivered'),       -- 1 day after
(4011, 3003, 'Keyboard', 8000.00, '2024-02-03', 'Delivered'),       -- 1 day after
(4012, 3003, 'Mouse', 3000.00, '2024-02-04', 'Delivered'),          -- 1 day after
(4013, 3003, 'Webcam', 12000.00, '2024-02-05', 'Delivered'),        -- 1 day after

-- CUSTOMER 3004 (Sneha Reddy) - TWO SEPARATE CONSECUTIVE PAIRS
(4014, 3004, 'Sofa Set', 89999.00, '2024-01-18', 'Delivered'),
(4015, 3004, 'Dining Table', 65999.00, '2024-01-19', 'Delivered'),  -- 1 day after
(4016, 3004, 'Coffee Table', 25999.00, '2024-01-25', 'Delivered'),
(4017, 3004, 'Bookshelf', 28999.00, '2024-01-26', 'Delivered'),     -- 1 day after

-- CUSTOMER 3005 (Vikram Singh) - MIXED PATTERN
(4018, 3005, 'Cricket Bat', 8999.00, '2024-02-10', 'Delivered'),
(4019, 3005, 'Football', 2999.00, '2024-02-11', 'Delivered'),       -- 1 day after
(4020, 3005, 'Tennis Racket', 12999.00, '2024-02-15', 'Delivered'),
(4021, 3005, 'Golf Clubs', 89999.00, '2024-02-20', 'Delivered'),

-- CUSTOMER 3006 (Anita Desai) - NO CONSECUTIVE PURCHASES
(4022, 3006, 'Book Set', 5999.00, '2024-02-05', 'Delivered'),
(4023, 3006, 'Desk Lamp', 3999.00, '2024-02-12', 'Delivered'),
(4024, 3006, 'Office Chair', 18999.00, '2024-02-20', 'Delivered');
