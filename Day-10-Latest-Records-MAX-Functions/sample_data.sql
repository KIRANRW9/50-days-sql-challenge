-- Day 10: Latest Records and MAX Functions - Sample Data

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
-- Customer 101: Multiple orders across months (Latest: Aug 2024)
(1001, 101, 'iPhone 15 Pro', 'Electronics', 129900.00, '2024-01-15', 'Delivered'),
(1002, 101, 'MacBook Air M3', 'Electronics', 114900.00, '2024-05-20', 'Delivered'),
(1003, 101, 'AirPods Pro', 'Electronics', 24900.00, '2024-08-10', 'Delivered'),

-- Customer 102: Regular customer (Latest: July 2024)
(1004, 102, 'Samsung Galaxy S24', 'Electronics', 89999.00, '2024-02-25', 'Delivered'),
(1005, 102, 'Samsung Watch', 'Electronics', 29999.00, '2024-07-15', 'Delivered'),

-- Customer 103: Frequent shopper (Latest: Sep 2024)
(1006, 103, 'Nike Shoes', 'Fashion', 8999.00, '2024-01-10', 'Delivered'),
(1007, 103, 'Adidas T-Shirt', 'Fashion', 2499.00, '2024-03-05', 'Delivered'),
(1008, 103, 'Puma Jacket', 'Fashion', 4999.00, '2024-06-20', 'Delivered'),
(1009, 103, 'Reebok Cap', 'Fashion', 1299.00, '2024-09-15', 'Delivered'),

-- Customer 104: Single recent order (Latest: April 2024)
(1010, 104, 'Dell XPS Laptop', 'Electronics', 125000.00, '2024-04-28', 'Delivered'),

-- Customer 105: Recent active customer (Latest: Aug 2024)
(1011, 105, 'Sony Headphones', 'Electronics', 15999.00, '2024-03-15', 'Delivered'),
(1012, 105, 'Canon Camera', 'Electronics', 45999.00, '2024-08-22', 'Delivered'),

-- Customer 106: Inactive customer - older orders (Latest: Feb 2024)
(1013, 106, 'Levis Jeans', 'Fashion', 4999.00, '2024-01-10', 'Delivered'),
(1014, 106, 'Zara Dress', 'Fashion', 3499.00, '2024-02-14', 'Delivered'),

-- Customer 107: Very recent order (Latest: Oct 2024)
(1015, 107, 'JBL Speaker', 'Electronics', 8999.00, '2024-10-15', 'Delivered'),

-- Customer 108: Mid-year activity (Latest: June 2024)
(1016, 108, 'Samsung 55" TV', 'Electronics', 65999.00, '2024-06-05', 'Delivered'),

-- Customer 109: Recent small purchases (Latest: Oct 2024)
(1017, 109, 'Phone Case', 'Accessories', 999.00, '2024-09-10', 'Delivered'),
(1018, 109, 'Charging Cable', 'Accessories', 599.00, '2024-10-01', 'Delivered');

-- Customer 110: No orders (registered but never purchased)
-- This customer will not appear in order-based queries but will show in LEFT JOIN results
