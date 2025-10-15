CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE
);

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id)
);

INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', 'Mumbai', '2023-01-15'),
(102, 'Priya Sharma', 'priya.sharma@email.com', 'Delhi', '2023-02-20'),
(103, 'Amit Patel', 'amit.patel@email.com', 'Bangalore', '2023-03-25'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', 'Hyderabad', '2023-04-10'),
(105, 'Vikram Singh', 'vikram.singh@email.com', 'Chennai', '2023-05-12'),
(106, 'Arjun Mehta', 'arjun.mehta@email.com', 'Pune', '2023-06-18'),
(107, 'Neha Verma', 'neha.verma@email.com', 'Jaipur', '2023-07-25'),
(108, 'Manish Rao', 'manish.rao@email.com', 'Kolkata', '2023-08-05'),
(109, 'Pooja Das', 'pooja.das@email.com', 'Guwahati', '2023-09-01'),
(110, 'Sahil Khan', 'sahil.khan@email.com', 'Lucknow', '2023-09-12');

INSERT INTO Orders VALUES
(1001, 101, 'Headphones', 3500.00, '2024-02-01', 'Delivered'),
(1002, 101, 'MacBook Pro', 199900.00, '2024-03-25', 'Delivered'),
(1003, 101, 'Wireless Mouse', 2500.00, '2024-01-10', 'Delivered'),
(1004, 101, 'Keyboard', 4000.00, '2024-04-10', 'Delivered'),
(1005, 101, 'Smartphone', 75000.00, '2024-06-15', 'Delivered'),

(1006, 102, 'Microwave', 25000.00, '2024-01-02', 'Delivered'),
(1007, 102, 'Samsung TV 65"', 89999.00, '2024-01-15', 'Delivered'),
(1008, 102, 'Air Fryer', 19000.00, '2024-03-05', 'Delivered'),
(1009, 102, 'Vacuum Cleaner', 11000.00, '2024-05-11', 'Delivered'),

(1010, 103, 'Monitor', 25000.00, '2024-01-02', 'Delivered'),
(1011, 103, 'Laptop Bag', 3000.00, '2024-01-10', 'Delivered'),
(1012, 103, 'Dell XPS 15', 145000.00, '2024-01-20', 'Delivered'),
(1013, 103, 'Mouse', 2000.00, '2024-03-12', 'Delivered'),
(1014, 103, 'Tablet', 35000.00, '2024-04-18', 'Delivered'),
(1015, 103, 'Bluetooth Speaker', 12000.00, '2024-05-01', 'Delivered'),
(1016, 103, 'SSD 1TB', 9000.00, '2024-06-05', 'Delivered'),
(1017, 103, 'External HDD', 8000.00, '2024-06-25', 'Delivered'),

(1018, 104, 'Dining Table', 45000.00, '2024-01-05', 'Delivered'),
(1019, 104, 'Sofa Set', 89999.00, '2024-02-15', 'Delivered'),
(1020, 104, 'Chair Set', 45000.00, '2024-03-10', 'Delivered'),

(1021, 105, 'Dumbbells', 15000.00, '2024-02-01', 'Delivered'),
(1022, 105, 'Yoga Mat', 3000.00, '2024-03-10', 'Delivered'),
(1023, 105, 'Treadmill', 80000.00, '2024-04-05', 'Delivered'),
(1024, 105, 'Bicycle', 45000.00, '2024-06-05', 'Delivered'),
(1025, 105, 'Gym Equipment', 125000.00, '2024-05-05', 'Delivered'),
(1026, 105, 'Sports Shoes', 7000.00, '2024-07-10', 'Delivered'),
(1027, 105, 'Protein Supplements', 12000.00, '2024-08-15', 'Delivered'),
(1028, 105, 'Fitness Watch', 20000.00, '2024-09-10', 'Delivered'),
(1029, 105, 'Skipping Rope', 800.00, '2024-10-01', 'Delivered'),

(1030, 106, 'Desk Lamp', 2999.00, '2024-06-15', 'Delivered'),
(1031, 106, 'Office Chair', 18999.00, '2024-07-08', 'Delivered'),
(1032, 106, 'Bookshelf', 12999.00, '2024-08-10', 'Delivered'),

(1033, 107, 'Gaming Console', 49999.00, '2024-04-15', 'Delivered'),

(1034, 108, 'Mixer Grinder', 45000.00, '2024-05-10', 'Delivered'),
(1035, 109, 'Smart Watch', 35000.00, '2024-06-05', 'Delivered'),
(1036, 110, 'Office Desk', 45000.00, '2024-07-25', 'Delivered');
