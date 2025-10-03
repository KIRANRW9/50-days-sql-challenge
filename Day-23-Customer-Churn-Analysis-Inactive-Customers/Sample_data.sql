-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    customer_tier VARCHAR(20),
    city VARCHAR(50)
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

-- Insert Customers data
INSERT INTO Customers (customer_id, customer_name, email, registration_date, customer_tier, city) VALUES
(1001, 'Rajesh Kumar', 'rajesh.kumar@email.com', '2022-01-15', 'Premium', 'Mumbai'),
(1002, 'Priya Sharma', 'priya.sharma@email.com', '2022-02-20', 'Gold', 'Delhi'),
(1003, 'Amit Patel', 'amit.patel@email.com', '2022-03-10', 'Silver', 'Bangalore'),
(1004, 'Sneha Reddy', 'sneha.reddy@email.com', '2022-04-05', 'Premium', 'Hyderabad'),
(1005, 'Vikram Singh', 'vikram.singh@email.com', '2022-05-12', 'Gold', 'Jaipur'),
(1006, 'Anita Desai', 'anita.desai@email.com', '2022-06-18', 'Silver', 'Pune'),
(1007, 'Rohit Mehta', 'rohit.mehta@email.com', '2022-07-22', 'Gold', 'Ahmedabad'),
(1008, 'Kavya Pillai', 'kavya.pillai@email.com', '2022-08-30', 'Gold', 'Kochi'),
(1009, 'Arjun Nair', 'arjun.nair@email.com', '2022-09-14', 'Premium', 'Kolkata'),
(1010, 'Deepa Joshi', 'deepa.joshi@email.com', '2022-10-25', 'Silver', 'Chennai');

-- Insert Orders data (Active customers - recent orders)
INSERT INTO Orders (order_id, customer_id, product_name, order_amount, order_date, status) VALUES
(2001, 1001, 'Laptop', 65000.00, '2024-09-25', 'Completed'),
(2002, 1001, 'Mouse', 1500.00, '2024-09-26', 'Completed'),
(2003, 1003, 'Monitor', 18000.00, '2024-09-28', 'Completed'),
(2004, 1005, 'Keyboard', 3500.00, '2024-09-27', 'Completed'),
(2005, 1009, 'Headphones', 8500.00, '2024-08-20', 'Completed'),
(2006, 1007, 'Webcam', 4500.00, '2024-07-15', 'Completed');

-- Insert Orders data (Churned customers - old orders from 6+ months ago)
INSERT INTO Orders (order_id, customer_id, product_name, order_amount, order_date, status) VALUES
(2007, 1002, 'Laptop', 55000.00, '2023-09-15', 'Completed'),
(2008, 1002, 'Tablet', 35000.00, '2023-08-20', 'Completed'),
(2009, 1002, 'Mouse', 2000.00, '2023-07-10', 'Completed'),
(2010, 1004, 'Desktop', 75000.00, '2023-10-20', 'Completed'),
(2011, 1004, 'Monitor', 25000.00, '2023-09-15', 'Completed'),
(2012, 1006, 'Laptop', 48000.00, '2023-11-10', 'Completed'),
(2013, 1006, 'Keyboard', 4000.00, '2023-10-05', 'Completed'),
(2014, 1008, 'Tablet', 32000.00, '2023-10-05', 'Completed'),
(2015, 1008, 'Mouse', 1800.00, '2023-09-12', 'Completed'),
(2016, 1010, 'Monitor', 22000.00, '2023-09-28', 'Completed'),
(2017, 1010, 'Webcam', 5500.00, '2023-08-15', 'Completed');

-- Additional historical orders for better analysis
INSERT INTO Orders (order_id, customer_id, product_name, order_amount, order_date, status) VALUES
(2018, 1001, 'Tablet', 28000.00, '2024-08-15', 'Completed'),
(2019, 1001, 'Headphones', 7500.00, '2024-07-20', 'Completed'),
(2020, 1003, 'Laptop', 62000.00, '2024-08-10', 'Completed'),
(2021, 1005, 'Desktop', 85000.00, '2024-08-05', 'Completed'),
(2022, 1009, 'Monitor', 19000.00, '2024-07-25', 'Completed'),
(2023, 1002, 'Headphones', 8500.00, '2023-06-15', 'Completed'),
(2024, 1004, 'Keyboard', 3800.00, '2023-08-20', 'Completed'),
(2025, 1006, 'Mouse', 2200.00, '2023-09-05', 'Completed'),
(2026, 1008, 'Webcam', 6000.00, '2023-08-10', 'Completed'),
(2027, 1010, 'Keyboard', 3500.00, '2023-07-20', 'Completed');
