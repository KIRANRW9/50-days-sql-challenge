-- Day 07: Order Frequency Analysis (GROUP BY & Aggregation Functions)
-- Solutions SQL File

-- Create Database Schema
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50),
    registration_date DATE
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    order_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);

-- Insert Sample Data
-- Insert sample data into Customers
INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', '9876543210', 'Mumbai', '2023-01-15'),
(102, 'Priya Sharma', 'priya.sharma@email.com', '9876543211', 'Delhi', '2023-02-20'),
(103, 'Amit Patel', 'amit.patel@email.com', '9876543212', 'Bangalore', '2023-03-10'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', '9876543213', 'Hyderabad', '2023-04-05'),
(105, 'Vikram Singh', 'vikram.singh@email.com', '9876543214', 'Chennai', '2023-05-12'),
(106, 'Anita Desai', 'anita.desai@email.com', '9876543215', 'Pune', '2023-06-18'),
(107, 'Rohit Mehta', 'rohit.mehta@email.com', '9876543216', 'Kolkata', '2023-07-22'),
(108, 'Kavya Pillai', 'kavya.pillai@email.com', '9876543217', 'Kochi', '2023-08-14'),
(109, 'Arjun Nair', 'arjun.nair@email.com', '9876543218', 'Ahmedabad', '2023-09-08'),
(110, 'Deepa Joshi', 'deepa.joshi@email.com', '9876543219', 'Jaipur', '2023-10-25');

-- Insert sample data into Orders
INSERT INTO Orders VALUES
(1001, 101, 'Laptop', 'Electronics', 75000.00, '2024-01-15', 'Completed'),
(1002, 101, 'Mouse', 'Electronics', 1500.00, '2024-02-20', 'Completed'),
(1003, 101, 'Keyboard', 'Electronics', 3500.00, '2024-03-10', 'Completed'),
(1004, 102, 'Smartphone', 'Electronics', 45000.00, '2024-01-25', 'Completed'),
(1005, 103, 'Tablet', 'Electronics', 25000.00, '2024-02-14', 'Completed'),
(1006, 103, 'Headphones', 'Electronics', 8000.00, '2024-04-18', 'Completed'),
(1007, 104, 'Monitor', 'Electronics', 18000.00, '2024-03-22', 'Completed'),
(1008, 105, 'Printer', 'Electronics', 12000.00, '2024-05-16', 'Completed'),
(1009, 105, 'Scanner', 'Electronics', 8500.00, '2024-06-20', 'Completed'),
(1010, 106, 'Camera', 'Electronics', 35000.00, '2024-07-12', 'Completed'),
(1011, 107, 'Smart Watch', 'Electronics', 15000.00, '2024-08-05', 'Completed'),
(1012, 107, 'Fitness Tracker', 'Electronics', 5000.00, '2024-09-10', 'Completed'),
(1013, 108, 'Bluetooth Speaker', 'Electronics', 4500.00, '2024-10-15', 'Completed'),
(1014, 109, 'Power Bank', 'Electronics', 2500.00, '2024-11-08', 'Completed'),
(1015, 110, 'Wireless Charger', 'Electronics', 3000.00, '2024-12-02', 'Completed');

-- Query Solutions

-- Query 1: Count of Orders per Customer
SELECT 
    customer_id, 
    COUNT(*) AS order_count 
FROM Orders 
GROUP BY customer_id
ORDER BY order_count DESC;

-- Query 2: Customer Order Frequency with Names
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS order_count,
    ROUND(AVG(o.order_amount), 2) AS avg_order_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY order_count DESC, avg_order_value DESC;

-- Query 3: Customer Segmentation by Order Frequency
SELECT 
    CASE 
        WHEN COUNT(o.order_id) >= 3 THEN 'High Frequency'
        WHEN COUNT(o.order_id) = 2 THEN 'Medium Frequency'
        WHEN COUNT(o.order_id) = 1 THEN 'Low Frequency'
        ELSE 'No Orders'
    END AS customer_segment,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    ROUND(AVG(COUNT(o.order_id)), 2) AS avg_orders_per_customer
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY 
    CASE 
        WHEN COUNT(o.order_id) >= 3 THEN 'High Frequency'
        WHEN COUNT(o.order_id) = 2 THEN 'Medium Frequency'
        WHEN COUNT(o.order_id) = 1 THEN 'Low Frequency'
        ELSE 'No Orders'
    END
ORDER BY customer_count DESC;

-- Query 4: Monthly Order Distribution
SELECT 
    MONTHNAME(order_date) AS order_month,
    MONTH(order_date) AS month_number,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(order_amount) AS monthly_revenue
FROM Orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month_number;

-- Query 5: Top Customers by Order Count and Value
SELECT 
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS order_count,
    SUM(o.order_amount) AS total_spent,
    ROUND(AVG(o.order_amount), 2) AS avg_order_value,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_order
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING COUNT(o.order_id) >= 1
ORDER BY order_count DESC, total_spent DESC
LIMIT 5;

-- Bonus Query 6: Customer Order Patterns with Rankings
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS order_count,
    SUM(o.order_amount) AS total_spent,
    RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS frequency_rank,
    RANK() OVER (ORDER BY SUM(o.order_amount) DESC) AS spending_rank,
    CASE 
        WHEN COUNT(o.order_id) >= 3 AND SUM(o.order_amount) >= 50000 THEN 'VIP'
        WHEN COUNT(o.order_id) >= 2 OR SUM(o.order_amount) >= 30000 THEN 'Premium'
        WHEN COUNT(o.order_id) >= 1 AND SUM(o.order_amount) >= 10000 THEN 'Regular'
        ELSE 'New'
    END AS customer_tier
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY frequency_rank, spending_rank;

-- Additional Practice Queries

-- Query 7: Customers with No Orders
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    c.registration_date
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

-- Query 8: Average Orders per City
SELECT 
    c.city,
    COUNT(DISTINCT c.customer_id) AS total_customers,
    COUNT(o.order_id) AS total_orders,
    ROUND(COUNT(o.order_id) / COUNT(DISTINCT c.customer_id), 2) AS avg_orders_per_customer
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.city
ORDER BY avg_orders_per_customer DESC;

-- Query 9: Order Value Distribution
SELECT 
    CASE 
        WHEN order_amount >= 50000 THEN 'High Value (50K+)'
        WHEN order_amount >= 20000 THEN 'Medium Value (20K-50K)'
        WHEN order_amount >= 5000 THEN 'Low Value (5K-20K)'
        ELSE 'Very Low Value (<5K)'
    END AS order_value_category,
    COUNT(*) AS order_count,
    ROUND(AVG(order_amount), 2) AS avg_amount,
    SUM(order_amount) AS total_amount
FROM Orders
GROUP BY 
    CASE 
        WHEN order_amount >= 50000 THEN 'High Value (50K+)'
        WHEN order_amount >= 20000 THEN 'Medium Value (20K-50K)'
        WHEN order_amount >= 5000 THEN 'Low Value (5K-20K)'
        ELSE 'Very Low Value (<5K)'
    END
ORDER BY avg_amount DESC;

-- Query 10: Customer Registration vs First Order Analysis
SELECT 
    c.customer_name,
    c.registration_date,
    MIN(o.order_date) AS first_order_date,
    DATEDIFF(MIN(o.order_date), c.registration_date) AS days_to_first_order,
    COUNT(o.order_id) AS total_orders
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.registration_date
ORDER BY days_to_first_order;
