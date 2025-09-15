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

-- Create Returns table
CREATE TABLE Returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    return_reason VARCHAR(100),
    return_amount DECIMAL(10,2),
    return_date DATE,
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
(1001, 101, 'iPhone 15 Pro', 'Electronics', 129900.00, '2024-01-15', 'Delivered'),
(1002, 102, 'Samsung Galaxy S24', 'Electronics', 89999.00, '2024-01-20', 'Delivered'),
(1003, 103, 'MacBook Air M3', 'Electronics', 114900.00, '2024-02-10', 'Delivered'),
(1004, 104, 'Nike Air Max', 'Fashion', 8999.00, '2024-02-15', 'Delivered'),
(1005, 105, 'Adidas Ultraboost', 'Fashion', 12999.00, '2024-03-05', 'Delivered'),
(1006, 106, 'Dell Inspiron Laptop', 'Electronics', 65000.00, '2024-03-12', 'Delivered'),
(1007, 107, 'Sony Headphones', 'Electronics', 15999.00, '2024-04-18', 'Delivered'),
(1008, 108, 'Levi\'s Jeans', 'Fashion', 3499.00, '2024-04-25', 'Delivered'),
(1009, 109, 'Canon DSLR Camera', 'Electronics', 45999.00, '2024-05-10', 'Delivered'),
(1010, 110, 'Puma Running Shoes', 'Fashion', 5999.00, '2024-05-20', 'Delivered'),
(1011, 101, 'iPad Pro', 'Electronics', 89900.00, '2024-06-15', 'Delivered'),
(1012, 103, 'Apple Watch', 'Electronics', 42900.00, '2024-07-08', 'Delivered'),
(1013, 105, 'Samsung TV 55 inch', 'Electronics', 55999.00, '2024-08-12', 'Delivered'),
(1014, 107, 'Boat Earbuds', 'Electronics', 2999.00, '2024-09-05', 'Delivered');

-- Insert sample data into Returns
INSERT INTO Returns VALUES
(2001, 1002, 102, 'Product defective', 89999.00, '2024-01-25', 'Processed'),
(2002, 1004, 104, 'Wrong size', 8999.00, '2024-02-20', 'Processed'),
(2003, 1006, 106, 'Not as described', 65000.00, '2024-03-18', 'Processed'),
(2004, 1008, 108, 'Color not matching', 3499.00, '2024-05-02', 'Processed'),
(2005, 1010, 110, 'Quality issues', 5999.00, '2024-05-28', 'Processed');
