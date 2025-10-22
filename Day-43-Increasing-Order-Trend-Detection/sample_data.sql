-- Day 43: Increasing Order Trend Detection
-- Sample Data SQL File

-- Insert Customers
INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', 'Mumbai', '2023-11-15'),
(102, 'Priya Sharma', 'priya.sharma@email.com', 'Delhi', '2023-12-20'),
(103, 'Amit Patel', 'amit.patel@email.com', 'Bangalore', '2024-01-10'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', 'Hyderabad', '2024-01-25'),
(105, 'Vikram Singh', 'vikram.singh@email.com', 'Chennai', '2023-12-05'),
(106, 'Anita Desai', 'anita.desai@email.com', 'Pune', '2024-02-10'),
(107, 'Rohit Mehta', 'rohit.mehta@email.com', 'Kolkata', '2024-02-20'),
(108, 'Kavya Pillai', 'kavya.pillai@email.com', 'Kochi', '2024-03-05'),
(109, 'Arjun Nair', 'arjun.nair@email.com', 'Ahmedabad', '2024-03-15'),
(110, 'Deepa Joshi', 'deepa.joshi@email.com', 'Jaipur', '2024-04-01');

-- Customer 101: INCREASING PATTERN (45K → 55K → 59.9K → 75K)
INSERT INTO Orders VALUES
(1001, 101, 'Mouse', 45000.00, '2024-01-20', 'Delivered'),
(1002, 101, 'Keyboard', 55000.00, '2024-02-15', 'Delivered'),
(1003, 101, 'Monitor', 59900.00, '2024-03-05', 'Delivered'),  -- Pattern 1: 45K < 55K < 59.9K
(1004, 101, 'Laptop', 75000.00, '2024-04-10', 'Delivered'),   -- Pattern 2: 55K < 59.9K < 75K
(1005, 101, 'Desk', 65000.00, '2024-05-10', 'Delivered'),     -- Breaks pattern (75K > 65K)
(1006, 101, 'Chair', 85000.00, '2024-06-15', 'Delivered');

-- Customer 102: MIXED PATTERN (some increasing, some not)
INSERT INTO Orders VALUES
(1007, 102, 'Phone', 89999.00, '2024-01-25', 'Delivered'),
(1008, 102, 'Case', 5000.00, '2024-02-20', 'Delivered'),      -- Decreasing
(1009, 102, 'Charger', 3000.00, '2024-03-15', 'Delivered'),   -- Still decreasing
(1010, 102, 'Tablet', 45000.00, '2024-04-18', 'Delivered');

-- Customer 103: INCREASING PATTERN (35K → 45K → 52K)
INSERT INTO Orders VALUES
(1011, 103, 'Headphones', 35000.00, '2024-02-10', 'Delivered'),
(1012, 103, 'Speaker', 45000.00, '2024-03-12', 'Delivered'),
(1013, 103, 'Webcam', 52000.00, '2024-04-15', 'Delivered'),
