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


--Query 1: Count Duplicates
SELECT 
    customer_email,
    product_name,
    COUNT(*) as duplicate_count
FROM customer_orders
GROUP BY customer_email, product_name
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


--Query 2: Show All Duplicate Records
SELECT * 
FROM customer_orders 
WHERE (customer_email, product_name) IN (
    SELECT customer_email, product_name
    FROM customer_orders
    GROUP BY customer_email, product_name
    HAVING COUNT(*) > 1
)
ORDER BY customer_email, product_name;
