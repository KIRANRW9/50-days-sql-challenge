-- Day 13: Regional Sales Analysis - Sample Data

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    region VARCHAR(20),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Insert sample data for regional analysis
INSERT INTO Orders (order_id, customer_id, product_name, category, region, total_amount, order_date, status) VALUES
-- North Region Orders
(1, 101, 'Laptop Pro X1', 'Electronics', 'North', 89999.00, '2024-01-15', 'Completed'),
(2, 102, 'Smartphone Y2', 'Electronics', 'North', 34999.00, '2024-01-18', 'Completed'),
(3, 103, 'Winter Jacket', 'Clothing', 'North', 4499.00, '2024-01-22', 'Completed'),
(4, 104, 'Gaming Chair', 'Furniture', 'North', 12999.00, '2024-02-05', 'Completed'),
(5, 105, 'Coffee Maker', 'Appliances', 'North', 8999.00, '2024-02-10', 'Completed'),

-- South Region Orders
(6, 201, 'Tablet S3', 'Electronics', 'South', 25999.00, '2024-01-20', 'Completed'),
(7, 202, 'Summer Dress', 'Clothing', 'South', 2999.00, '2024-01-25', 'Completed'),
(8, 203, 'Air Conditioner', 'Appliances', 'South', 45999.00, '2024-02-01', 'Completed'),
(9, 204, 'Office Desk', 'Furniture', 'South', 15999.00, '2024-02-08', 'Completed'),
(10, 205, 'Wireless Headphones', 'Electronics', 'South', 7999.00, '2024-02-15', 'Completed'),

-- East Region Orders
(11, 301, 'Smart TV 55"', 'Electronics', 'East', 52999.00, '2024-01-12', 'Completed'),
(12, 302, 'Running Shoes', 'Clothing', 'East', 6999.00, '2024-01-28', 'Completed'),
(13, 303, 'Microwave Oven', 'Appliances', 'East', 18999.00, '2024-02-03', 'Completed'),
(14, 304, 'Bookshelf', 'Furniture', 'East', 9999.00, '2024-02-12', 'Completed'),
(15, 305, 'Camera DSLR', 'Electronics', 'East', 67999.00, '2024-02-20', 'Completed'),

-- West Region Orders
(16, 401, 'MacBook Air', 'Electronics', 'West', 99999.00, '2024-01-08', 'Completed'),
(17, 402, 'Yoga Mat', 'Sports', 'West', 1999.00, '2024-01-30', 'Completed'),
(18, 403, 'Refrigerator', 'Appliances', 'West', 65999.00, '2024-02-06', 'Completed'),
(19, 404, 'Sofa Set', 'Furniture', 'West', 35999.00, '2024-02-14', 'Completed'),
(20, 405, 'Washing Machine', 'Appliances', 'West', 28999.00, '2024-02-22', 'Completed'),

-- Central Region Orders
(21, 501, 'Desktop Computer', 'Electronics', 'Central', 75999.00, '2024-01-05', 'Completed'),
(22, 502, 'Formal Suit', 'Clothing', 'Central', 12999.00, '2024-01-17', 'Completed'),
(23, 503, 'Dishwasher', 'Appliances', 'Central', 32999.00, '2024-01-29', 'Completed'),
(24, 504, 'Dining Table', 'Furniture', 'Central', 22999.00, '2024-02-11', 'Completed'),
(25, 505, 'Fitness Tracker', 'Electronics', 'Central', 8999.00, '2024-02-18', 'Completed'),

-- Additional orders for better analysis
(26, 106, 'Bluetooth Speaker', 'Electronics', 'North', 3999.00, '2024-03-01', 'Completed'),
(27, 206, 'Sandals', 'Clothing', 'South', 1999.00, '2024-03-05', 'Completed'),
(28, 306, 'Blender', 'Appliances', 'East', 4999.00, '2024-03-08', 'Completed'),
(29, 406, 'Exercise Bike', 'Sports', 'West', 25999.00, '2024-03-12', 'Completed'),
(30, 506, 'Monitor 27"', 'Electronics', 'Central', 18999.00, '2024-03-15', 'Completed'),

-- Some pending and cancelled orders for realistic data
(31, 107, 'Smart Watch', 'Electronics', 'North', 15999.00, '2024-03-18', 'Pending'),
(32, 207, 'Handbag', 'Clothing', 'South', 3999.00, '2024-03-20', 'Cancelled'),
(33, 307, 'Iron', 'Appliances', 'East', 2999.00, '2024-03-22', 'Pending'),
(34, 407, 'Dumbbells', 'Sports', 'West', 4999.00, '2024-03-25', 'Completed'),
(35, 507, 'Keyboard', 'Electronics', 'Central', 5999.00, '2024-03-28', 'Completed');
