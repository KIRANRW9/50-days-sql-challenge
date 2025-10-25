-- Day 45: Top Customers Revenue Contribution Analysis

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Insert sample data into Customers
INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', 'Mumbai', '2024-01-20'),
(102, 'Priya Sharma', 'priya.sharma@email.com', 'Delhi', '2024-01-25'),
(103, 'Amit Patel', 'amit.patel@email.com', 'Bangalore', '2024-02-10'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', 'Hyderabad', '2024-02-15'),
(105, 'Vikram Singh', 'vikram.singh@email.com', 'Chennai', '2024-01-15'),
(106, 'Anita Joshi', 'anita.joshi@email.com', 'Pune', '2024-03-05'),
(107, 'Neha Desai', 'neha.desai@email.com', 'Pune', '2024-03-01'),
(108, 'Rohit Verma', 'rohit.verma@email.com', 'Kolkata', '2024-03-10'),
(109, 'Deepak Gupta', 'deepak.gupta@email.com', 'Jaipur', '2024-03-15'),
(110, 'Karan Mehta', 'karan.mehta@email.com', 'Hyderabad', '2024-02-20'),
(111, 'Kavita Nair', 'kavita.nair@email.com', 'Kochi', '2024-04-01'),
(112, 'Suresh Yadav', 'suresh.yadav@email.com', 'Lucknow', '2024-04-05'),
(113, 'Meera Iyer', 'meera.iyer@email.com', 'Chennai', '2024-04-10'),
(114, 'Arjun Malhotra', 'arjun.malhotra@email.com', 'Mumbai', '2024-04-15'),
(115, 'Pooja Kulkarni', 'pooja.kulkarni@email.com', 'Bangalore', '2024-04-20');

-- Insert sample data into Orders
-- Top tier customers (Platinum - Top 10%)
INSERT INTO Orders VALUES
-- Customer 105: Highest revenue (525000) - 8 orders
(1001, 105, 'Enterprise Software License', 85000.00, '2024-01-15', 'Completed'),
(1002, 105, 'Cloud Infrastructure', 72000.00, '2024-02-20', 'Completed'),
(1003, 105, 'Security Suite', 55000.00, '2024-03-10', 'Completed'),
(1004, 105, 'Analytics Platform', 95000.00, '2024-04-05', 'Completed'),
(1005, 105, 'AI/ML Tools', 68000.00, '2024-04-25', 'Completed'),
(1006, 105, 'Database Systems', 78000.00, '2024-05-15', 'Completed'),
(1007, 105, 'DevOps Tools', 45000.00, '2024-06-01', 'Completed'),
(1008, 105, 'Monitoring Suite', 27000.00, '2024-06-25', 'Completed'),

-- Customer 101: Second highest (385000) - 6 orders
(1009, 101, 'ERP System', 85000.00, '2024-01-20', 'Completed'),
(1010, 101, 'CRM Platform', 65000.00, '2024-02-15', 'Completed'),
(1011, 101, 'Business Intelligence', 75000.00, '2024-03-10', 'Completed'),
(1012, 101, 'Data Warehouse', 55000.00, '2024-04-05', 'Completed'),
(1013, 101, 'Marketing Automation', 58000.00, '2024-04-25', 'Completed'),
(1014, 101, 'Customer Portal', 47000.00, '2024-05-10', 'Completed');

-- Mid-High tier customers (Gold - Next 15%)
INSERT INTO Orders VALUES
-- Customer 103: (245000) - 5 orders
(1015, 103, 'Project Management Suite', 65000.00, '2024-02-10', 'Completed'),
(1016, 103, 'Collaboration Tools', 45000.00, '2024-03-01', 'Completed'),
(1017, 103, 'Time Tracking System', 35000.00, '2024-03-20', 'Completed'),
(1018, 103, 'Resource Planning', 52000.00, '2024-04-15', 'Completed'),
(1019, 103, 'Reporting Dashboard', 48000.00, '2024-05-10', 'Completed'),

-- Customer 107: (180000) - 4 orders
(1020, 107, 'E-commerce Platform', 55000.00, '2024-03-01', 'Completed'),
(1021, 107, 'Payment Gateway', 42000.00, '2024-03-25', 'Completed'),
(1022, 107, 'Inventory System', 38000.00, '2024-05-01', 'Completed'),
(1023, 107, 'Logistics Software', 45000.00, '2024-06-10', 'Completed'),

-- Customer 110: (165000) - 5 orders
(1024, 110, 'HR Management System', 38000.00, '2024-02-20', 'Completed'),
(1025, 110, 'Payroll Software', 32000.00, '2024-03-15', 'Completed'),
(1026, 110, 'Recruitment Platform', 35000.00, '2024-04-10', 'Completed'),
(1027, 110, 'Learning Management', 28000.00, '2024-05-05', 'Completed'),
(1028, 110, 'Performance Management', 32000.00, '2024-06-15', 'Completed');

-- Mid tier customers (Silver - Next 25%)
INSERT INTO Orders VALUES
-- Customer 102: 85000 - 3 orders
(1029, 102, 'Accounting Software', 32000.00, '2024-01-25', 'Completed'),
(1030, 102, 'Tax Compliance Tool', 28000.00, '2024-03-15', 'Completed'),
(1031, 102, 'Financial Reporting', 25000.00, '2024-05-20', 'Completed'),

-- Customer 106: 75000 - 3 orders
(1032, 106, 'Supply Chain Software', 28000.00, '2024-03-05', 'Completed'),
(1033, 106, 'Procurement System', 25000.00, '2024-04-20', 'Completed'),
(1034, 106, 'Vendor Management', 22000.00, '2024-06-05', 'Completed'),

-- Customer 108: 68000 - 4 orders
(1035, 108, 'Sales Automation', 22000.00, '2024-03-10', 'Completed'),
(1036, 108, 'Lead Management', 18000.00, '2024-04-05', 'Completed'),
(1037, 108, 'Quote Generator', 15000.00, '2024-05-01', 'Completed'),
(1038, 108, 'Sales Analytics', 13000.00, '2024-06-10', 'Completed'),

-- Customer 104: 42000 - 2 orders
(1039, 104, 'Document Management', 22000.00, '2024-02-15', 'Completed'),
(1040, 104, 'Workflow Automation', 20000.00, '2024-04-20', 'Completed');

-- Lower tier customers (Bronze - Bottom 50%)
INSERT INTO Orders VALUES
-- Customer 109: 35000 - 2 orders
(1041, 109, 'Customer Support Software', 18000.00, '2024-03-15', 'Completed'),
(1042, 109, 'Ticketing System', 17000.00, '2024-05-25', 'Completed'),

-- Customer 111: 28000 - 2 orders
(1043, 111, 'Email Marketing Tool', 15000.00, '2024-04-01', 'Completed'),
(1044, 111, 'Social Media Manager', 13000.00, '2024-05-15', 'Completed'),

-- Customer 112: 22000 - 2 orders
(1045, 112, 'Website Builder', 12000.00, '2024-04-05', 'Completed'),
(1046, 112, 'SEO Tools', 10000.00, '2024-06-01', 'Completed'),

-- Customer 113: 18000 - 2 orders
(1047, 113, 'Appointment Scheduler', 10000.00, '2024-04-10', 'Completed'),
(1048, 113, 'Calendar Integration', 8000.00, '2024-05-20', 'Completed'),

-- Customer 114: 12000 - 2 orders
(1049, 114, 'Survey Tool', 7000.00, '2024-04-15', 'Completed'),
(1050, 114, 'Feedback System', 5000.00, '2024-06-10', 'Completed'),

-- Customer 115: 8000 - 2 orders
(1051, 115, 'Note Taking App', 5000.00, '2024-04-20', 'Completed'),
(1052, 115, 'Task Manager', 3000.00, '2024-06-15', 'Completed');
