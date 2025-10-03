-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    order_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20),
    payment_method VARCHAR(50)
);

-- Insert Orders data spanning multiple days
INSERT INTO Orders (order_id, customer_id, product_name, order_amount, order_date, status, payment_method) VALUES
-- January 2024 orders
(3001, 1001, 'Laptop', 65000.00, '2024-01-05', 'Completed', 'Credit Card'),
(3002, 1002, 'Mouse', 1500.00, '2024-01-05', 'Completed', 'UPI'),
(3003, 1003, 'Keyboard', 3500.00, '2024-01-05', 'Completed', 'Debit Card'),
(3004, 1004, 'Monitor', 18000.00, '2024-01-08', 'Completed', 'Credit Card'),
(3005, 1005, 'Headphones', 8500.00, '2024-01-08', 'Completed', 'UPI'),
(3006, 1006, 'Webcam', 4500.00, '2024-01-10', 'Completed', 'Net Banking'),
(3007, 1007, 'Tablet', 35000.00, '2024-01-10', 'Completed', 'Credit Card'),
(3008, 1001, 'Desktop', 85000.00, '2024-01-12', 'Completed', 'Credit Card'),
(3009, 1008, 'Printer', 15000.00, '2024-01-12', 'Completed', 'UPI'),
(3010, 1009, 'Scanner', 12000.00, '2024-01-15', 'Completed', 'Debit Card'),

-- February 2024 orders
(3011, 1002, 'Laptop', 72000.00, '2024-02-02', 'Completed', 'Credit Card'),
(3012, 1010, 'Mouse', 2000.00, '2024-02-02', 'Completed', 'UPI'),
(3013, 1003, 'Monitor', 22000.00, '2024-02-05', 'Completed', 'Net Banking'),
(3014, 1011, 'Keyboard', 4200.00, '2024-02-05', 'Completed', 'Debit Card'),
(3015, 1004, 'Headphones', 9500.00, '2024-02-08', 'Completed', 'UPI'),
(3016, 1012, 'Webcam', 5500.00, '2024-02-08', 'Completed', 'Credit Card'),
(3017, 1005, 'Tablet', 38000.00, '2024-02-10', 'Completed', 'Credit Card'),
(3018, 1013, 'Desktop', 95000.00, '2024-02-12', 'Completed', 'Net Banking'),
(3019, 1006, 'Printer', 18000.00, '2024-02-12', 'Completed', 'UPI'),
(3020, 1014, 'Router', 3500.00, '2024-02-15', 'Completed', 'Debit Card'),

-- March 2024 orders
(3021, 1007, 'Laptop', 78000.00, '2024-03-01', 'Completed', 'Credit Card'),
(3022, 1015, 'Mouse', 2500.00, '2024-03-01', 'Completed', 'UPI'),
(3023, 1008, 'Monitor', 25000.00, '2024-03-05', 'Completed', 'Credit Card'),
(3024, 1016, 'Keyboard', 4800.00, '2024-03-05', 'Completed', 'Net Banking'),
(3025, 1009, 'Headphones', 11000.00, '2024-03-08', 'Completed', 'UPI'),
(3026, 1017, 'Webcam', 6000.00, '2024-03-08', 'Completed', 'Debit Card'),
(3027, 1010, 'Tablet', 42000.00, '2024-03-10', 'Completed', 'Credit Card'),
(3028, 1018, 'Desktop', 105000.00, '2024-03-12', 'Completed', 'Credit Card'),
(3029, 1011, 'Printer', 20000.00, '2024-03-12', 'Completed', 'UPI'),
(3030, 1019, 'Scanner', 15000.00, '2024-03-15', 'Completed', 'Net Banking');
