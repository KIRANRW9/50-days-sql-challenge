-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50),
    sales_rep_id INT
);

-- Insert sample data into Orders
INSERT INTO Orders VALUES
-- January 2024 - Post-holiday slow period
(1001, 2001, 'iPhone 15 Pro', 'Electronics', 159900.00, '2024-01-15', 'North', 3001),
(1002, 2002, 'Samsung TV 55"', 'Electronics', 65999.00, '2024-01-20', 'South', 3002),
(1003, 2003, 'Nike Shoes', 'Fashion', 12999.00, '2024-01-25', 'East', 3003),

-- February 2024 - Valentine's season boost
(1004, 2004, 'Diamond Ring', 'Jewelry', 89999.00, '2024-02-10', 'West', 3001),
(1005, 2005, 'Perfume Set', 'Beauty', 8999.00, '2024-02-12', 'North', 3002),
(1006, 2006, 'Chocolate Box', 'Food', 2999.00, '2024-02-14', 'South', 3003),
(1007, 2007, 'MacBook Air', 'Electronics', 114900.00, '2024-02-18', 'East', 3001),
(1008, 2008, 'Flowers Bouquet', 'Gifts', 1999.00, '2024-02-14', 'West', 3002),

-- March 2024 - Spring sales momentum
(1009, 2009, 'Canon Camera', 'Electronics', 75999.00, '2024-03-05', 'North', 3003),
(1010, 2010, 'Spring Jacket', 'Fashion', 4999.00, '2024-03-10', 'South', 3001),
(1011, 2011, 'Gaming Laptop', 'Electronics', 125000.00, '2024-03-15', 'East', 3002),
(1012, 2012, 'Sneakers', 'Fashion', 8999.00, '2024-03-20', 'West', 3003),
(1013, 2013, 'Tablet', 'Electronics', 45999.00, '2024-03-25', 'North', 3001),

-- April 2024 - Steady growth period
(1014, 2014, 'Smart Watch', 'Electronics', 25999.00, '2024-04-08', 'South', 3002),
(1015, 2015, 'Summer Dress', 'Fashion', 3999.00, '2024-04-12', 'East', 3003),
(1016, 2016, 'Bluetooth Speaker', 'Electronics', 15999.00, '2024-04-18', 'West', 3001),
(1017, 2017, 'Fitness Tracker', 'Electronics', 12999.00, '2024-04-22', 'North', 3002),
(1018, 2018, 'Handbag', 'Fashion', 18999.00, '2024-04-28', 'South', 3003),

-- May 2024 - Peak sales month
(1019, 2019, 'Refrigerator', 'Appliances', 89999.00, '2024-05-02', 'East', 3001),
(1020, 2020, 'Air Conditioner', 'Appliances', 45999.00, '2024-05-05', 'West', 3002),
(1021, 2021, 'Washing Machine', 'Appliances', 35999.00, '2024-05-10', 'North', 3003),
(1022, 2022, 'Microwave', 'Appliances', 18999.00, '2024-05-15', 'South', 3001),
(1023, 2023, 'Vacuum Cleaner', 'Appliances', 25999.00, '2024-05-18', 'East', 3002),
(1024, 2024, 'Coffee Machine', 'Appliances', 32999.00, '2024-05-22', 'West', 3003),
(1025, 2025, 'Blender', 'Appliances', 8999.00, '2024-05-25', 'North', 3001),
(1026, 2026, 'Toaster', 'Appliances', 4999.00, '2024-05-28', 'South', 3002),

-- June 2024 - Summer season
(1027, 2027, 'Pool Equipment', 'Sports', 45999.00, '2024-06-05', 'East', 3003),
(1028, 2028, 'Sunglasses', 'Fashion', 12999.00, '2024-06-08', 'West', 3001),
(1029, 2029, 'Beach Umbrella', 'Sports', 5999.00, '2024-06-12', 'North', 3002),
(1030, 2030, 'Swimwear', 'Fashion', 3999.00, '2024-06-15', 'South', 3003),

-- July 2024 - Mid-year boost
(1031, 2031, 'Lawn Mower', 'Garden', 35999.00, '2024-07-10', 'East', 3001),
(1032, 2032, 'Garden Tools Set', 'Garden', 8999.00, '2024-07-15', 'West', 3002),
(1033, 2033, 'Outdoor Grill', 'Garden', 25999.00, '2024-07-20', 'North', 3003);
