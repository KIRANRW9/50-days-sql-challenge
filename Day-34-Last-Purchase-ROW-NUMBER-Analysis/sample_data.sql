-- Day 34: Last Purchase Analysis (Most Recent Order per Customer)
-- Sample Data SQL File

-- Insert Sample Data into Customers Table
INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', 'Mumbai', '2023-11-15'),
(102, 'Priya Sharma', 'priya.sharma@email.com', 'Delhi', '2023-12-20'),
(103, 'Amit Patel', 'amit.patel@email.com', 'Bangalore', '2023-10-10'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', 'Hyderabad', '2024-01-05'),
(105, 'Vikram Singh', 'vikram.singh@email.com', 'Chennai', '2023-11-30'),
(106, 'Anita Desai', 'anita.desai@email.com', 'Pune', '2024-02-14'),
(107, 'Rohit Mehta', 'rohit.mehta@email.com', 'Kolkata', '2024-03-10'),
(108, 'Kavya Pillai', 'kavya.pillai@email.com', 'Kochi', '2024-04-20'),
(109, 'Arjun Nair', 'arjun.nair@email.com', 'Ahmedabad', '2024-05-05'),
(110, 'Deepa Joshi', 'deepa.joshi@email.com', 'Jaipur', '2024-06-15');

-- Insert Sample Data into Orders Table
-- Creating multiple orders per customer with varying dates

-- Customer 101 - Rajesh Kumar (6 orders)
INSERT INTO Orders VALUES
(1001, 101, 'iPhone 15 Pro', 129900.00, '2024-02-10', 'Delivered'),
(1002, 101, 'MacBook Pro', 199900.00, '2024-03-25', 'Delivered'),
(1003, 101, 'iPad Air', 59900.00, '2024-05-05', 'Delivered'),
(1004, 101, 'AirPods Pro', 24900.00, '2024-06-10', 'Delivered'),
(1005, 101, 'Apple Watch', 45900.00, '2024-07-30', 'Delivered'),
(1006, 101, 'HomePod', 32000.00, '2024-10-20', 'Delivered'),
(1008, 101, 'Magic Keyboard', 12500.00, '2024-09-15', 'Delivered');

-- Customer 102 - Priya Sharma (4 orders)
INSERT INTO Orders VALUES
(1007, 102, 'Samsung TV 65"', 89999.00, '2024-01-15', 'Delivered'),
(1009, 102, 'Washing Machine', 45999.00, '2024-03-05', 'Delivered'),
(1011, 102, 'Refrigerator', 65999.00, '2024-04-20', 'Delivered'),
(1010, 102, 'Microwave Oven', 43002.00, '2024-08-18', 'Delivered');

-- Customer 103 - Amit Patel (8 orders)
INSERT INTO Orders VALUES
(1012, 103, 'Dell XPS 15', 145000.00, '2024-01-20', 'Delivered'),
(1013, 103, '4K Monitor', 35000.00, '2024-02-25', 'Delivered'),
(1014, 103, 'Mechanical Keyboard', 12000.00, '2024-03-30', 'Delivered'),
(1015, 103, 'Gaming Mouse', 8000.00, '2024-05-10', 'Delivered'),
(1016, 103, 'Webcam HD', 15000.00, '2024-06-15', 'Delivered'),
(1039, 103, 'USB Hub', 8000.00, '2024-10-05', 'Delivered'),
(1018, 103, 'Desk Lamp', 5000.00, '2024-07-30', 'Delivered'),
(1017, 103, 'External SSD 1TB', 12000.00, '2024-08-30', 'Delivered');

-- Customer 104 - Sneha Reddy (3 orders)
INSERT INTO Orders VALUES
(1019, 104, 'Sofa Set', 89999.00, '2024-02-15', 'Delivered'),
(1020, 104, 'Dining Table', 45999.00, '2024-04-10', 'Delivered'),
(1021, 104, 'Coffee Table', 44002.00, '2024-08-12', 'Delivered');

-- Customer 105 - Vikram Singh (9 orders) - Most active
INSERT INTO Orders VALUES
(1022, 105, 'Cricket Bat', 12999.00, '2024-01-15', 'Delivered'),
(1023, 105, 'Football', 3999.00, '2024-02-10', 'Delivered'),
(1024, 105, 'Tennis Racket', 18999.00, '2024-03-05', 'Delivered'),
(1025, 105, 'Golf Clubs', 89999.00, '2024-04-10', 'Delivered'),
(1026, 105, 'Gym Equipment', 125000.00, '2024-05-05', 'Delivered'),
(1027, 105, 'Bicycle', 45000.00, '2024-06-05', 'Delivered'),
(1028, 105, 'Running Shoes', 12000.00, '2024-07-10', 'Delivered'),
(1029, 105, 'Fitness Tracker', 12000.00, '2024-08-10', 'Delivered'),
(1040, 105, 'Protein Supplements', 8000.00, '2024-10-15', 'Delivered');

-- Customer 106 - Anita Desai (3 orders)
INSERT INTO Orders VALUES
(1030, 106, 'Book Collection', 8999.00, '2024-03-20', 'Delivered'),
(1032, 106, 'Reading Lamp', 4999.00, '2024-05-25', 'Delivered'),
(1031, 106, 'Office Chair', 18999.00, '2024-07-08', 'Delivered');

-- Customer 107 - Rohit Mehta (3 orders)
INSERT INTO Orders VALUES
(1033, 107, 'Gaming Console', 49999.00, '2024-04-15', 'Delivered'),
(1037, 107, 'Controller', 5999.00, '2024-06-20', 'Delivered'),
(1034, 107, 'Games Bundle', 29002.00, '2024-07-15', 'Delivered');

-- Customer 108 - Kavya Pillai (1 order)
INSERT INTO Orders VALUES
(1035, 108, 'Kitchen Appliances', 45000.00, '2024-05-10', 'Delivered');

-- Customer 109 - Arjun Nair (1 order)
INSERT INTO Orders VALUES
(1036, 109, 'Smart Watch', 35000.00, '2024-06-05', 'Delivered');

-- Customer 110 - Deepa Joshi (1 order)
INSERT INTO Orders VALUES
(1037, 110, 'Office Desk', 45000.00, '2024-07-25', 'Delivered');
