-- Day 33: Purchase Frequency Analysis (Average Time Between Orders)
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
-- Creating different purchase patterns for each customer

-- Customer 101 (Rajesh Kumar) - Medium frequency, consistent pattern (avg ~41 days)
INSERT INTO Orders VALUES
(1001, 101, 'iPhone 15 Pro', 129900.00, '2024-02-10', 'Delivered'),    -- Start
(1002, 101, 'MacBook Pro', 199900.00, '2024-03-25', 'Delivered'),      -- +44 days
(1003, 101, 'iPad Air', 59900.00, '2024-05-05', 'Delivered'),          -- +41 days
(1004, 101, 'AirPods Pro', 24900.00, '2024-06-10', 'Delivered'),       -- +36 days
(1005, 101, 'Apple Watch', 45900.00, '2024-07-30', 'Delivered'),       -- +50 days
(1006, 101, 'Magic Keyboard', 12500.00, '2024-09-15', 'Delivered');    -- +47 days

-- Customer 102 (Priya Sharma) - Medium-low frequency (avg ~45 days)
INSERT INTO Orders VALUES
(1007, 102, 'Samsung TV 65"', 89999.00, '2024-01-15', 'Delivered'),    -- Start
(1008, 102, 'Washing Machine', 45999.00, '2024-03-05', 'Delivered'),   -- +50 days
(1009, 102, 'Refrigerator', 65999.00, '2024-04-20', 'Delivered'),      -- +46 days
(1010, 102, 'Microwave Oven', 43002.00, '2024-08-18', 'Delivered');    -- +120 days (slowing down)

-- Customer 103 (Amit Patel) - Medium frequency, fairly consistent (avg ~37 days)
INSERT INTO Orders VALUES
(1011, 103, 'Dell XPS 15', 145000.00, '2024-01-20', 'Delivered'),      -- Start
(1012, 103, '4K Monitor', 35000.00, '2024-02-25', 'Delivered'),        -- +36 days
(1013, 103, 'Mechanical Keyboard', 12000.00, '2024-03-30', 'Delivered'),-- +34 days
(1014, 103, 'Gaming Mouse', 8000.00, '2024-05-10', 'Delivered'),       -- +41 days
(1015, 103, 'Webcam HD', 15000.00, '2024-06-15', 'Delivered'),         -- +36 days
(1016, 103, 'Desk Lamp', 5000.00, '2024-07-30', 'Delivered'),          -- +45 days
(1017, 103, 'External SSD 1TB', 12000.00, '2024-08-30', 'Delivered');  -- +31 days

-- Customer 104 (Sneha Reddy) - Low frequency (avg ~52 days)
INSERT INTO Orders VALUES
(1018, 104, 'Sofa Set', 89999.00, '2024-02-15', 'Delivered'),          -- Start
(1019, 104, 'Dining Table', 45999.00, '2024-04-10', 'Delivered'),      -- +55 days
(1020, 104, 'Coffee Table', 44002.00, '2024-08-12', 'Delivered');      -- +124 days (slowing down)

-- Customer 105 (Vikram Singh) - HIGH FREQUENCY (avg ~29 days) - Most active customer
INSERT INTO Orders VALUES
(1021, 105, 'Cricket Bat', 12999.00, '2024-01-15', 'Delivered'),       -- Start
(1022, 105, 'Football', 3999.00, '2024-02-10', 'Delivered'),           -- +26 days
(1023, 105, 'Tennis Racket', 18999.00, '2024-03-05', 'Delivered'),     -- +24 days
(1024, 105, 'Golf Clubs', 89999.00, '2024-04-10', 'Delivered'),        -- +36 days
(1025, 105, 'Gym Equipment', 125000.00, '2024-05-05', 'Delivered'),    -- +25 days
(1026, 105, 'Bicycle', 45000.00, '2024-06-05', 'Delivered'),           -- +31 days
(1027, 105, 'Running Shoes', 12000.00, '2024-07-10', 'Delivered'),     -- +35 days
(1028, 105, 'Fitness Tracker', 8999.00, '2024-09-20', 'Delivered');    -- +72 days (recent slowdown)

-- Customer 106 (Anita Desai) - Infrequent (avg ~61 days)
INSERT INTO Orders VALUES
(1029, 106, 'Book Collection', 8999.00, '2024-03-20', 'Delivered'),    -- Start
(1030, 106, 'Reading Lamp', 4999.00, '2024-05-25', 'Delivered'),       -- +66 days
(1031, 106, 'Office Chair', 18999.00, '2024-07-08', 'Delivered');      -- +44 days

-- Customer 107 (Rohit Mehta) - Low frequency (avg ~58 days)
INSERT INTO Orders VALUES
(1032, 107, 'Gaming Console', 49999.00, '2024-04-15', 'Delivered'),    -- Start
(1033, 107, 'Controller', 5999.00, '2024-06-20', 'Delivered'),         -- +66 days
(1034, 107, 'Games Bundle', 29002.00, '2024-07-15', 'Delivered');      -- +25 days

-- Customer 108 (Kavya Pillai) - Only 1 order (no frequency to calculate)
INSERT INTO Orders VALUES
(1035, 108, 'Kitchen Appliances', 45000.00, '2024-05-10', 'Delivered');

-- Customer 109 (Arjun Nair) - Only 1 order (no frequency to calculate)
INSERT INTO Orders VALUES
(1036, 109, 'Smart Watch', 35000.00, '2024-06-05', 'Delivered');

-- Customer 110 (Deepa Joshi) - Only 1 order (no frequency to calculate)
INSERT INTO Orders VALUES
(1037, 110, 'Office Desk', 45000.00, '2024-07-25', 'Delivered');

-- Additional orders to create richer patterns

-- More orders for customer 101 (testing trend analysis)
INSERT INTO Orders VALUES
(1038, 101, 'HomePod', 32000.00, '2024-10-20', 'Delivered');            -- +35 days

-- More orders for customer 103 (testing trend analysis)
INSERT INTO Orders VALUES
(1039, 103, 'USB Hub', 8000.00, '2024-10-05', 'Delivered');             -- +36 days

-- More orders for customer 105 (testing trend analysis)
INSERT INTO Orders VALUES
(1040, 105, 'Protein Supplements', 8000.00, '2024-10-15', 'Delivered'); -- +25 days
