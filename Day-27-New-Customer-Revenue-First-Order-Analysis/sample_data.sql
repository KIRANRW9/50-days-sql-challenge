-- Day 27: New Customer Revenue Analysis (First-Time Order Revenue)

-- Insert Sample Data into Customers Table
INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', 'Mumbai', '2024-01-10', 'Google Ads'),
(102, 'Priya Sharma', 'priya.sharma@email.com', 'Delhi', '2024-01-18', 'Social Media'),
(103, 'Amit Patel', 'amit.patel@email.com', 'Bangalore', '2024-02-05', 'Email Campaign'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', 'Hyderabad', '2024-02-15', 'Google Ads'),
(105, 'Vikram Singh', 'vikram.singh@email.com', 'Chennai', '2024-02-28', 'Referral'),
(106, 'Anita Desai', 'anita.desai@email.com', 'Pune', '2024-03-10', 'Social Media'),
(107, 'Rohit Mehta', 'rohit.mehta@email.com', 'Kolkata', '2024-03-22', 'Google Ads'),
(108, 'Kavya Pillai', 'kavya.pillai@email.com', 'Kochi', '2024-04-08', 'Email Campaign'),
(109, 'Arjun Nair', 'arjun.nair@email.com', 'Ahmedabad', '2024-05-15', 'Social Media'),
(110, 'Deepa Joshi', 'deepa.joshi@email.com', 'Jaipur', '2024-06-20', 'Organic Search');

-- Insert Sample Data into Orders Table
-- First orders (higher values typical for first-time purchases)

-- Customer 101 - First order (Jan) + Repeat orders
INSERT INTO Orders VALUES
(1001, 101, 'iPhone 15 Pro Max', 159900.00, '2024-01-15', 'Delivered'),  -- FIRST ORDER
(1002, 101, 'AirPods Pro', 24900.00, '2024-02-20', 'Delivered'),
(1003, 101, 'Apple Watch', 45900.00, '2024-03-25', 'Delivered'),
(1004, 101, 'iPad Air', 59900.00, '2024-04-30', 'Delivered');

-- Customer 102 - First order (Jan) + Repeat orders
INSERT INTO Orders VALUES
(1005, 102, 'MacBook Pro M3', 199900.00, '2024-01-25', 'Delivered'),  -- FIRST ORDER
(1006, 102, 'Magic Keyboard', 12500.00, '2024-03-10', 'Delivered'),
(1007, 102, 'USB-C Hub', 5000.00, '2024-05-15', 'Delivered');

-- Customer 103 - First order (Feb) + Repeat orders
INSERT INTO Orders VALUES
(1008, 103, 'Dell XPS 15', 145000.00, '2024-02-10', 'Delivered'),  -- FIRST ORDER
(1009, 103, '4K Monitor', 35000.00, '2024-03-20', 'Delivered'),
(1010, 103, 'Webcam HD', 15000.00, '2024-05-05', 'Delivered'),
(1011, 103, 'External SSD', 12000.00, '2024-06-18', 'Delivered');

-- Customer 104 - First order (Feb) + Repeat orders
INSERT INTO Orders VALUES
(1012, 104, 'Samsung Galaxy S24', 89999.00, '2024-02-20', 'Delivered'),  -- FIRST ORDER
(1013, 104, 'Galaxy Buds', 12999.00, '2024-04-05', 'Delivered'),
(1014, 104, 'Samsung Watch', 29999.00, '2024-06-10', 'Delivered');

-- Customer 105 - First order (Feb) + Repeat orders
INSERT INTO Orders VALUES
(1015, 105, 'Gaming Console', 45000.00, '2024-02-28', 'Delivered'),  -- FIRST ORDER
(1016, 105, 'Gaming Controller', 5999.00, '2024-04-12', 'Delivered'),
(1017, 105, 'Games Bundle', 12000.00, '2024-06-25', 'Delivered');

-- Customer 106 - First order (Mar) + Repeat orders
INSERT INTO Orders VALUES
(1018, 106, 'Sony Camera', 125000.00, 'Delivered'),  -- FIRST ORDER
(1019, 106, 'Camera Lens', 45000.00, '2024-05-20', 'Delivered'),
(1020, 106, 'Tripod', 8000.00, '2024-07-08', 'Delivered');

-- Customer 107 - First order (Mar) + Repeat orders
INSERT INTO Orders VALUES
(1021, 107, 'Smart TV 55"', 70000.00, '2024-03-25', 'Delivered'),  -- FIRST ORDER
(1022, 107, 'Soundbar', 25000.00, '2024-05-30', 'Delivered'),
(1023, 107, 'HDMI Cables', 2000.00, '2024-07-15', 'Delivered');

-- Customer 108 - First order (Apr) + Repeat orders
INSERT INTO Orders VALUES
(1024, 108, 'Refrigerator', 65999.00, '2024-04-10', 'Delivered'),  -- FIRST ORDER
(1025, 108, 'Microwave', 18000.00, '2024-06-05', 'Delivered'),
(1026, 108, 'Mixer Grinder', 8000.00, '2024-08-12', 'Delivered');

-- Customer 109 - First order (May) + Repeat orders
INSERT INTO Orders VALUES
(1027, 109, 'Gym Equipment Set', 125000.00, '2024-05-20', 'Delivered'),  -- FIRST ORDER
(1028, 109, 'Yoga Mat', 3000.00, '2024-07-10', 'Delivered'),
(1029, 109, 'Protein Supplements', 8000.00, '2024-08-25', 'Delivered');

-- Customer 110 - First order (Jun) + Repeat orders
INSERT INTO Orders VALUES
(1030, 110, 'Office Desk', 45000.00, '2024-06-25', 'Delivered'),  -- FIRST ORDER
(1031, 110, 'Office Chair', 18000.00, '2024-08-05', 'Delivered'),
(1032, 110, 'Desk Lamp', 5000.00, '2024-09-15', 'Delivered');

-- Additional repeat orders for better analysis

INSERT INTO Orders VALUES
-- More repeat orders for customer 101
(1033, 101, 'MacBook Charger', 8000.00, '2024-06-10', 'Delivered'),
(1034, 101, 'iPhone Case', 2500.00, '2024-07-20', 'Delivered'),

-- More repeat orders for customer 102
(1035, 102, 'External Drive', 12000.00, '2024-07-05', 'Delivered'),
(1036, 102, 'Laptop Bag', 5000.00, '2024-08-18', 'Delivered'),

-- More repeat orders for customer 103
(1037, 103, 'Keyboard', 8000.00, '2024-07-22', 'Delivered'),
(1038, 103, 'Mouse Pad', 1500.00, '2024-08-30', 'Delivered'),

-- More repeat orders for customer 104
(1039, 104, 'Phone Stand', 2000.00, '2024-07-15', 'Delivered'),
(1040, 104, 'Screen Protector', 1500.00, '2024-09-05', 'Delivered'),

-- More repeat orders for customer 105
(1041, 105, 'VR Headset', 45000.00, '2024-08-10', 'Delivered'),
(1042, 105, 'Gaming Chair', 25000.00, '2024-09-20', 'Delivered');
