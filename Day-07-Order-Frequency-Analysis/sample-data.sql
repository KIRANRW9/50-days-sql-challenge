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

-- Insert sample data
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
