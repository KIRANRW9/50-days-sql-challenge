-- Day 14: Advanced Customer Order Analysis
-- Sample Data SQL File

-- Insert Sample Data into Customers Table
INSERT INTO Customers VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', '9876543210', 'Mumbai', '2023-01-15', 'Active'),
(102, 'Priya Sharma', 'priya.sharma@email.com', '9876543211', 'Delhi', '2023-02-20', 'Active'),
(103, 'Amit Patel', 'amit.patel@email.com', '9876543212', 'Bangalore', '2023-03-10', 'Active'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', '9876543213', 'Hyderabad', '2023-04-05', 'Active'),
(105, 'Vikram Singh', 'vikram.singh@email.com', '9876543214', 'Chennai', '2023-05-12', 'Active'),
(106, 'Anita Desai', 'anita.desai@email.com', '9876543215', 'Pune', '2023-06-18', 'Active'),
(107, 'Rohit Mehta', 'rohit.mehta@email.com', '9876543216', 'Kolkata', '2023-07-22', 'Active'),
(108, 'Kavya Pillai', 'kavya.pillai@email.com', '9876543217', 'Kochi', '2023-08-14', 'Active'),
(109, 'Arjun Nair', 'arjun.nair@email.com', '9876543218', 'Ahmedabad', '2023-09-08', 'Active'),
(110, 'Deepa Joshi', 'deepa.joshi@email.com', '9876543219', 'Jaipur', '2023-10-25', 'Active'),
(111, 'Suresh Gupta', 'suresh.gupta@email.com', '9876543220', 'Lucknow', '2023-11-12', 'Active'),
(112, 'Meera Iyer', 'meera.iyer@email.com', '9876543221', 'Coimbatore', '2023-12-05', 'Active'),
(113, 'Karthik Nair', 'karthik.nair@email.com', '9876543222', 'Thiruvananthapuram', '2024-01-10', 'Active'),
(114, 'Ritu Agarwal', 'ritu.agarwal@email.com', '9876543223', 'Indore', '2024-02-14', 'Active'),
(115, 'Vishal Rao', 'vishal.rao@email.com', '9876543224', 'Nashik', '2024-03-20', 'Active'),
(116, 'Pooja Malhotra', 'pooja.malhotra@email.com', '9876543225', 'Chandigarh', '2024-04-08', 'Active'),
(117, 'Rakesh Jain', 'rakesh.jain@email.com', '9876543226', 'Jodhpur', '2024-05-15', 'Active'),
(118, 'Nisha Kapoor', 'nisha.kapoor@email.com', '9876543227', 'Gurgaon', '2024-06-22', 'Active'),
(119, 'Anil Verma', 'anil.verma@email.com', '9876543228', 'Bhopal', '2024-07-18', 'Active'),
(120, 'Sunita Devi', 'sunita.devi@email.com', '9876543229', 'Patna', '2024-08-25', 'Active');

-- Insert Sample Data into Orders Table
-- High Volume Customers (More than 5 orders)

-- Customer 101 - Rajesh Kumar (8 orders)
INSERT INTO Orders VALUES
(1001, 101, 'Laptop', 'Electronics', 75000.00, '2024-01-15', 'Completed'),
(1002, 101, 'Smartphone', 'Electronics', 45000.00, '2024-02-20', 'Completed'),
(1003, 101, 'Tablet', 'Electronics', 35000.00, '2024-03-25', 'Completed'),
(1004, 101, 'Headphones', 'Electronics', 15000.00, '2024-04-18', 'Completed'),
(1005, 101, 'Smart Watch', 'Electronics', 25000.00, '2024-05-22', 'Completed'),
(1006, 101, 'Bluetooth Speaker', 'Electronics', 8000.00, '2024-06-15', 'Completed'),
(1007, 101, 'Wireless Charger', 'Electronics', 5000.00, '2024-07-20', 'Completed'),
(1008, 101, 'Power Bank', 'Electronics', 3000.00, '2024-08-22', 'Completed');

-- Customer 102 - Priya Sharma (7 orders)
INSERT INTO Orders VALUES
(1009, 102, 'Camera', 'Electronics', 85000.00, '2024-01-20', 'Completed'),
(1010, 102, 'Lens', 'Electronics', 35000.00, '
