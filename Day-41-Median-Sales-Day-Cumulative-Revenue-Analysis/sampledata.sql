-- Day 41: Median Sales Day Analysis (Cumulative Revenue Breakpoint)
-- Sample Data SQL File

-- January 2024 - Building momentum
INSERT INTO Orders VALUES
(1001, 101, 'Laptop', 85000.00, '2024-01-15', 'Delivered'),
(1002, 102, 'iPhone 15 Pro', 129900.00, '2024-01-20', 'Delivered');

-- February 2024 - Steady growth
INSERT INTO Orders VALUES
(1003, 103, 'Dell XPS 15', 145000.00, '2024-02-10', 'Delivered'),
(1004, 104, 'MacBook Pro', 199900.00, '2024-02-18', 'Delivered');

-- March 2024 - Increasing sales
INSERT INTO Orders VALUES
(1005, 105, 'Gaming Console', 45000.00, '2024-03-05', 'Delivered'),
(1006, 106, 'iPad Air', 59900.00, '2024-03-15', 'Delivered'),
(1007, 107, 'Samsung TV', 89999.00, '2024-03-25', 'Delivered'),
(1008, 108, 'Monitor 4K', 42000.00, '2024-03-30', 'Delivered');

-- April 2024 - Moderate activity
INSERT INTO Orders VALUES
(1009, 109, 'Headphones', 35000.00, '2024-04-08', 'Delivered'),
(1010, 110, 'Keyboard Mechanical', 18000.00, '2024-04-12', 'Delivered'),
(1011, 101, 'Mouse Gaming', 12000.00, '2024-04-20', 'Delivered'),
(1012, 102, 'Webcam HD', 22000.00, '2024-04-28', 'Delivered');

-- May 2024 - Building towards median
INSERT INTO Orders VALUES
(1013, 103, 'Printer', 48000.00, '2024-05-05', 'Delivered'),
(1014, 104, 'Scanner', 35000.00, '2024-05-10', 'Delivered'),
(1015, 105, 'Tablet', 42000.00, '2024-05-15', 'Delivered'),
(1016, 106, 'Smart Watch', 28000.00, '2024-05-20', 'Delivered'),
(1017, 107, 'Speaker Bluetooth', 15000.00, '2024-05-25', 'Delivered'),
(1018, 108, 'Camera DSLR', 85000.00, '2024-05-30', 'Delivered');

-- June 2024 - MEDIAN MONTH (50% threshold crossed here)
INSERT INTO Orders VALUES
(1019, 109, 'Refrigerator', 65000.00, '2024-06-05', 'Delivered'),
(1020, 110, 'Washing Machine', 55000.00, '2024-06-10', 'Delivered'),
(1021, 101, 'Air Conditioner', 95000.00, '2024-06-10', 'Delivered'),
(1022, 102, 'Laptop Gaming', 145000.00, '2024-06-15', 'Delivered'),  -- MEDIAN DAY
(1023, 103, 'Monitor Ultrawide', 75000.00, '2024-06-20', 'Delivered'),
(1024, 104, 'Desk Standing', 35000.00, '2024-06-25', 'Delivered');

-- July 2024 - Post-median acceleration
INSERT INTO Orders VALUES
(1025, 105, 'Phone Samsung', 89999.00, '2024-07-05', 'Delivered'),
(1026, 106, 'Sofa Set', 125000.00, '2024-07-12', 'Delivered'),
(1027, 107, 'Dining Table', 65000.00, '2024-07-18', 'Delivered'),
(1028, 108, 'Bed King Size', 85000.00, '2024-07-25', 'Delivered');

-- August 2024 - Strong sales continue
INSERT INTO Orders VALUES
(1029, 109, 'Microwave', 28000.00, '2024-08-05', 'Delivered'),
(1030, 110, 'Coffee Maker', 18000.00, '2024-08-10', 'Delivered'),
(1031, 101, 'Mixer Grinder', 12000.00, '2024-08-15', 'Delivered'),
(1032, 102, 'Oven', 35000.00, '2024-08-20', 'Delivered'),
(1033, 103, 'Vacuum Cleaner', 22000.00, '2024-08-25', 'Delivered'),
(1034, 104, 'Iron', 5000.00, '2024-08-30',
