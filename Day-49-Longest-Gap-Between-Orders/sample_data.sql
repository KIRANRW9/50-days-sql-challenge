-- Day 49: Longest Gap Between Orders Analysis

-- Drop tables if exist (for clean slate)
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Customers;

-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    customer_segment VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT NOT NULL,
    product_name VARCHAR(100),
    order_amount DECIMAL(10,2),
    order_date DATE NOT NULL,
    order_status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

-- Insert sample data into Customers
INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', '2023-12-15', 'Premium'),
(102, 'Priya Sharma', 'priya.sharma@email.com', '2023-12-20', 'Standard'),
(103, 'Amit Patel', 'amit.patel@email.com', '2023-12-28', 'Standard'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', '2024-01-05', 'Premium'),
(105, 'Vikram Singh', 'vikram.singh@email.com', '2024-01-08', 'VIP');

-- Insert sample data into Orders
-- Customer 101: Consistent buyer with 30-day max gap
INSERT INTO Orders VALUES
(1, 101, 'Laptop', 85000.00, '2024-01-01', 'Completed'),
(2, 101, 'Mouse', 1200.00, '2024-01-15', 'Completed'),
(3, 101, 'Keyboard', 3500.00, '2024-02-10', 'Completed'),
(4, 101, 'Monitor', 25000.00, '2024-03-12', 'Completed'),
(5, 101, 'Webcam', 5500.00, '2024-04-05', 'Completed'),
(6, 101, 'Headphones', 8000.00, '2024-05-10', 'Completed'),
(7, 101, 'USB Hub', 2500.00, '2024-06-08', 'Completed');

-- Customer 102: Has 60-day gap (high risk)
INSERT INTO Orders VALUES
(8, 102, 'Smartphone', 45000.00, '2024-01-03', 'Completed'),
(9, 102, 'Phone Case', 800.00, '2024-01-25', 'Completed'),
(10, 102, 'Charger', 1500.00, '2024-02-10', 'Completed'),
(11, 102, 'Power Bank', 3200.00, '2024-03-05', 'Completed'),
(12, 102, 'Screen Protector', 500.00, '2024-05-04', 'Completed');

-- Customer 103: Very engaged (15-day max gap)
INSERT INTO Orders VALUES
(13, 103, 'Tablet', 35000.00, '2024-01-05', 'Completed'),
(14, 103, 'Stylus', 2500.00, '2024-01-20', 'Completed'),
(15, 103, 'Tablet Cover', 1800.00, '2024-02-02', 'Completed'),
(16, 103, 'Screen Guard', 600.00, '2024-02-18', 'Completed'),
(17, 103, 'Adapter', 1200.00, '2024-03-05', 'Completed'),
(18, 103, 'USB Cable', 500.00, '2024-03-20', 'Completed'),
(19, 103, 'Memory Card', 2800.00, '2024-04-05', 'Completed'),
(20, 103, 'Card Reader', 800.00, '2024-04-22', 'Completed');

-- Customer 104: Critical risk (90-day gap)
INSERT INTO Orders VALUES
(21, 104, 'Smart TV', 65000.00, '2024-01-08', 'Completed'),
(22, 104, 'Soundbar', 18000.00, '2024-01-15', 'Completed'),
(23, 104, 'HDMI Cable', 800.00, '2024-04-15', 'Completed'),
(24, 104, 'Wall Mount', 3500.00, '2024-06-15', 'Completed');

-- Customer 105: Medium risk (45-day max gap)
INSERT INTO Orders VALUES
(25, 105, 'Gaming Console', 45000.00, '2024-01-10', 'Completed'),
(26, 105, 'Controller', 5500.00, '2024-01-20', 'Completed'),
(27, 105, 'Games Bundle', 12000.00, '2024-02-05', 'Completed'),
(28, 105, 'VR Headset', 35000.00, '2024-03-01', 'Completed'),
(29, 105, 'Gaming Chair', 22000.00, '2024-04-15', 'Completed'),
(30, 105, 'RGB Keyboard', 8000.00, '2024-05-05', 'Completed');
