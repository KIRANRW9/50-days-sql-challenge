-- Day 50: Low Revenue Customers - Percentile Analysis (Final Challenge!)

-- Drop tables if exist (for clean slate)
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE,
    signup_source VARCHAR(50),
    customer_segment VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE NOT NULL,
    order_status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert sample data into Customers (20 customers for percentile analysis)
INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', '2024-01-01', 'Referral', 'VIP'),
(102, 'Priya Sharma', 'priya.sharma@email.com', '2024-01-03', 'Organic Search', 'Premium'),
(103, 'Amit Patel', 'amit.patel@email.com', '2024-01-05', 'Social Media', 'Premium'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', '2024-01-08', 'Referral', 'Premium'),
(105, 'Vikram Singh', 'vikram.singh@email.com', '2024-01-10', 'Organic Search', 'VIP'),
(106, 'Anita Joshi', 'anita.joshi@email.com', '2024-01-12', 'Referral', 'Premium'),
(107, 'Rohit Verma', 'rohit.verma@email.com', '2024-01-15', 'Organic Search', 'Premium'),
(108, 'Deepak Gupta', 'deepak.gupta@email.com', '2024-01-18', 'Paid Ads', 'Standard'),
(109, 'Kavita Nair', 'kavita.nair@email.com', '2024-01-20', 'Social Media', 'Premium'),
(110, 'Suresh Yadav', 'suresh.yadav@email.com', '2024-01-25', 'Social Media', 'Standard'),
(111, 'Meera Iyer', 'meera.iyer@email.com', '2024-02-01', 'Referral', 'Premium'),
(112, 'Arjun Malhotra', 'arjun.malhotra@email.com', '2024-02-05', 'Organic Search', 'Standard'),
(113, 'Pooja Kulkarni', 'pooja.kulkarni@email.com', '2024-02-10', 'Paid Ads', 'Premium'),
(114, 'Karan Mehta', 'karan.mehta@email.com', '2024-02-15', 'Referral', 'Standard'),
(115, 'Divya Shah', 'divya.shah@email.com', '2024-02-20', 'Social Media', 'Standard'),
(116, 'Nikhil Desai', 'nikhil.desai@email.com', '2024-03-01', 'Organic Search', 'Premium'),
(117, 'Sana Khan', 'sana.khan@email.com', '2024-03-10', 'Referral', 'VIP'),
(118, 'Ravi Kapoor', 'ravi.kapoor@email.com', '2024-03-15', 'Paid Ads', 'Standard'),
(119, 'Anjali Rao', 'anjali.rao@email.com', '2024-03-20', 'Organic Search', 'Premium'),
(120, 'Vishal Gupta', 'vishal.gupta@email.com', '2024-03-25', 'Paid Ads', 'Standard');

-- Insert sample data into Orders
-- Top 10% customers (High revenue: >100K)
-- Customer 101: VIP - 145K
INSERT INTO Orders VALUES
(1, 101, 'Enterprise Software', 85000.00, '2024-01-02', 'Completed'),
(2, 101, 'Cloud Services', 35000.00, '2024-02-15', 'Completed'),
(3, 101, 'Premium Support', 25000.00, '2024-03-20', 'Completed');

-- Customer 105: VIP - 135K
INSERT INTO Orders VALUES
(4, 105, 'Data Analytics Suite', 75000.00, '2024-01-13', 'Completed'),
(5, 105, 'AI Platform', 60000.00, '2024-02-28', 'Completed');

-- 75-90% percentile (75K-100K)
-- Customer 102: 95K
INSERT INTO Orders VALUES
(6, 102, 'Marketing Automation', 45000.00, '2024-01-08', 'Completed'),
(7, 102, 'CRM System', 35000.00, '2024-02-10', 'Completed'),
(8, 102, 'Analytics Tool', 15000.00, '2024-03-15', 'Completed');

-- Customer 117: 88K
INSERT INTO Orders VALUES
(9, 117, 'Security Suite', 55000.00, '2024-03-22', 'Completed'),
(10, 117, 'Compliance Tools', 33000.00, '2024-04-10', 'Completed');

-- 50-75% percentile (35K-75K)
-- Customer 103: 68K
INSERT INTO Orders VALUES
(11, 103, 'E-commerce Platform', 42000.00, '2024-01-07', 'Completed'),
(12, 103, 'Payment Gateway', 26000.00, '2024-02-20', 'Completed');

-- Customer 107: 55K
INSERT INTO Orders VALUES
(13, 107, 'Project Management', 35000.00, '2024-01-30', 'Completed'),
(14, 107, 'Collaboration Tools', 20000.00, '2024-03-05', 'Completed');

-- Customer 111: 48K
INSERT INTO Orders VALUES
(15, 111, 'HR Management System', 28000.00, '2024-02-03', 'Completed'),
(16, 111, 'Payroll Software', 20000.00, '2024-03-12', 'Completed');

-- 25-50% percentile (15K-35K)
-- Customer 104: 32K
INSERT INTO Orders VALUES
(17, 104, 'Inventory System', 18000.00, '2024-01-15', 'Completed'),
(18, 104, 'POS Software', 14000.00, '2024-02-25', 'Completed');

-- Customer 109: 28K
INSERT INTO Orders VALUES
(19, 109, 'Booking System', 16000.00, '2024-01-25', 'Completed'),
(20, 109, 'Customer Portal', 12000.00, '2024-03-08', 'Completed');

-- Customer 113: 25K
INSERT INTO Orders VALUES
(21, 113, 'Email Marketing', 15000.00, '2024-02-11', 'Completed'),
(22, 113, 'Social Media Tools', 10000.00, '2024-03-18', 'Completed');

-- Customer 106: 22K
INSERT INTO Orders VALUES
(23, 106, 'Website Builder', 12000.00, '2024-01-22', 'Completed'),
(24, 106, 'SEO Tools', 10000.00, '2024-03-01', 'Completed');
