-- Day 26: Above-Average Customer Analysis
-- Sample Data SQL File
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
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

-- Insert Sample Data into Customers Table
INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', 'Mumbai', '2023-11-15', 'Premium'),
(102, 'Priya Sharma', 'priya.sharma@email.com', 'Delhi', '2023-12-20', 'Gold'),
(103, 'Amit Patel', 'amit.patel@email.com', 'Bangalore', '2023-10-10', 'Silver'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', 'Hyderabad', '2024-01-05', 'Premium'),
(105, 'Vikram Singh', 'vikram.singh@email.com', 'Chennai', '2023-11-30', 'Gold'),
(106, 'Anita Desai', 'anita.desai@email.com', 'Pune', '2024-02-14', 'Silver'),
(107, 'Rohit Mehta', 'rohit.mehta@email.com', 'Kolkata', '2024-03-10', 'Gold'),
(108, 'Kavya Pillai', 'kavya.pillai@email.com', 'Kochi', '2024-01-20', 'Silver'),
(109, 'Arjun Nair', 'arjun.nair@email.com', 'Ahmedabad', '2024-04-05', 'Premium'),
(110, 'Deepa Joshi', 'deepa.joshi@email.com', 'Jaipur', '2024-05-15', 'Silver');

-- Insert Sample Data into Orders Table
-- Average will be approximately 4.2 orders per customer

-- Customer 101 (Rajesh Kumar) - 8 orders (ABOVE AVERAGE - Power User)
INSERT INTO Orders VALUES
(1001, 101, 'iPhone 15 Pro', 129900.00, '2024-02-10', 'Delivered'),
(1002, 101, 'MacBook Pro M3', 199900.00, '2024-03-15', 'Delivered'),
(1003, 101, 'iPad Air', 59900.00, '2024-04-20', 'Delivered'),
(1004, 101, 'AirPods Pro', 24900.00, '2024-05-10', 'Delivered'),
(1005, 101, 'Apple Watch', 45900.00, '2024-06-05', 'Delivered'),
(1006, 101, 'Magic Keyboard', 12500.00, '2024-07-12', 'Delivered'),
(1007, 101, 'HomePod', 32000.00, '2024-08-18', 'Delivered'),
(1008, 101, 'Apple TV', 15000.00, '2024-09-15', 'Delivered');

-- Customer 102 (Priya Sharma) - 6 orders (ABOVE AVERAGE)
INSERT INTO Orders VALUES
(1009, 102, 'Samsung TV 65"', 89999.00, '2024-03-05', 'Delivered'),
(1010, 102, 'Washing Machine', 45999.00, '2024-04-10', 'Delivered'),
(1011, 102, 'Refrigerator', 65999.00, '2024-05-15', 'Delivered'),
(1012, 102, 'Microwave Oven', 18999.00, '2024-06-20', 'Delivered'),
(1013, 102, 'Air Conditioner', 42000.00, '2024-08-05', 'Delivered'),
(1014, 102, 'Vacuum Cleaner', 12000.00, '2024-09-10', 'Delivered');

-- Customer 103 (Amit Patel) - 7 orders (ABOVE AVERAGE)
INSERT INTO Orders VALUES
(1015, 103, 'Dell XPS 15', 145000.00, '2024-01-20', 'Delivered'),
(1016, 103, '4K Monitor', 35000.00, '2024-02-25', 'Delivered'),
(1017, 103, 'Mechanical Keyboard', 12000.00, '2024-03-30', 'Delivered'),
(1018, 103, 'Gaming Mouse', 8000.00, '2024-05-05', 'Delivered'),
(1019, 103, 'Webcam HD', 15000.00, '2024-06-15', 'Delivered'),
(1020, 103, 'Desk Lamp', 5000.00, '2024-07-20', 'Delivered'),
(1021, 103, 'External SSD 1TB', 12000.00, '2024-08-30', 'Delivered');

-- Customer 104 (Sneha Reddy) - 4 orders (AVERAGE)
INSERT INTO Orders VALUES
(1022, 104, 'Sofa Set', 89999.00, '2024-02-15', 'Delivered'),
(1023, 104, 'Dining Table', 45999.00, '2024-04-10', 'Delivered'),
(1024, 104, 'Coffee Table', 25999.00, '2024-06-05', 'Delivered'),
(1025, 104, 'Bookshelf', 18999.00, '2024-08-12', 'Delivered');

-- Customer 105 (Vikram Singh) - 9 orders (ABOVE AVERAGE - Power User)
INSERT INTO Orders VALUES
(1026, 105, 'Cricket Bat', 12999.00, '2024-01-15', 'Delivered'),
(1027, 105, 'Football', 3999.00, '2024-02-10', 'Delivered'),
(1028, 105, 'Tennis Racket', 18999.00, '2024-03-05', 'Delivered'),
(1029, 105, 'Golf Clubs', 89999.00, '2024-04-12', 'Delivered'),
(1030, 105, 'Gym Equipment', 125000.00, '2024-05-18', 'Delivered'),
(1031, 105, 'Bicycle', 45000.00, '2024-06-22', 'Delivered'),
(1032, 105, 'Running Shoes', 12000.00, '2024-07-28', 'Delivered'),
(1033, 105, 'Fitness Tracker', 8999.00, '2024-08-15', 'Delivered'),
(1034, 105, 'Yoga Mat', 2999.00, '2024-09-20', 'Delivered');

-- Customer 106 (Anita Desai) - 3 orders (BELOW AVERAGE)
INSERT INTO Orders VALUES
(1035, 106, 'Book Collection', 8999.00, '2024-03-20', 'Delivered'),
(1036, 106, 'Reading Lamp', 4999.00, '2024-05-25', 'Delivered'),
(1037, 106, 'Office Chair', 18999.00, '2024-07-30', 'Delivered');

-- Customer 107 (Rohit Mehta) - 2 orders (BELOW AVERAGE)
INSERT INTO Orders VALUES
(1038, 107, 'Gaming Console', 49999.00, '2024-04-15', 'Delivered'),
(1039, 107, 'Controller', 5999.00, '2024-06-20', 'Delivered');

-- Customer 108 (Kavya Pillai) - 3 orders (BELOW AVERAGE)
INSERT INTO Orders VALUES
(1040, 108, 'Kitchen Appliances', 45000.00, '2024-02-28', 'Delivered'),
(1041, 108, 'Cookware Set', 12999.00, '2024-05-10', 'Delivered'),
(1042, 108, 'Dinner Set', 8999.00, '2024-07-15', 'Delivered');

-- Customer 109 (Arjun Nair) - 2 orders (BELOW AVERAGE)
INSERT INTO Orders VALUES
(1043, 109, 'Smart Watch', 35000.00, '2024-05-05', 'Delivered'),
(1044, 109, 'Headphones', 15000.00, '2024-07-20', '
