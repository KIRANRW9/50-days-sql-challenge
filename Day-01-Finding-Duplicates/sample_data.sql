-- Create table and insert sample data
CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY,
    customer_email VARCHAR(100),
    product_name VARCHAR(100),
    order_amount DECIMAL(10,2),
    order_date DATE,
    payment_status VARCHAR(20)
);

INSERT INTO customer_orders VALUES
(101, 'rohit.kumar@gmail.com', 'iPhone 15', 79999.00, '2024-03-01', 'Completed'),
(102, 'priya.nair@yahoo.com', 'Samsung TV', 45000.00, '2024-03-01', 'Completed'),
(103, 'rajesh.krishnan@hotmail.com', 'Dell Laptop', 65000.00, '2024-03-02', 'Completed'),
(104, 'rohit.kumar@gmail.com', 'iPhone 15', 79999.00, '2024-03-01', 'Pending'),
(105, 'rohit.kumar@gmail.com', 'iPhone 15', 79999.00, '2024-03-01', 'Failed'),
(106, 'sneha.iyer@gmail.com', 'Nike Shoes', 8999.00, '2024-03-02', 'Completed'),
(107, 'vikram.rao@outlook.com', 'Book Set', 2500.00, '2024-03-03', 'Completed'),
(108, 'priya.nair@yahoo.com', 'Samsung TV', 45000.00, '2024-03-01', 'Failed'),
(109, 'sneha.iyer@gmail.com', 'Nike Shoes', 8999.00, '2024-03-02', 'Pending'),
(110, 'arjun.pillai@gmail.com', 'Washing Machine', 35000.00, '2024-03-04', 'Completed');

