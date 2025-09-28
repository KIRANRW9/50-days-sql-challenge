-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    customer_tier VARCHAR(20),
    location VARCHAR(50)
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
(2001, 'Rajesh Kumar', 'rajesh.kumar@email.com', '2022-01-15', 'Premium', 'Mumbai'),
(2002, 'Priya Sharma', 'priya.sharma@email.com', '2022-03-20', 'Gold', 'Delhi'),
(2003, 'Amit Patel', 'amit.patel@email.com', '2022-06-10', 'Premium', 'Bangalore'),
(2004, 'Sneha Reddy', 'sneha.reddy@email.com', '2022-08-05', 'Silver', 'Hyderabad'),
(2005, 'Vikram Singh', 'vikram.singh@email.com', '2022-11-12', 'Gold', 'Chennai'),
(2006, 'Anita Desai', 'anita.desai@email.com', '2023-01-18', 'Silver', 'Pune'),
(2007, 'Rohit Mehta', 'rohit.mehta@email.com', '2022-05-22', 'Premium', 'Kolkata'),
(2008, 'Kavya Pillai', 'kavya.pillai@email.com', '2022-09-14', 'Gold', 'Kochi');

-- Insert sample data into Orders for 2023
INSERT INTO Orders VALUES
-- CUSTOMER 2001 (Rajesh Kumar) - EVERY MONTH BUYER (12 months)
(3001, 2001, 'iPhone 15', 'Electronics', 129900.00, '2023-01-15', 'Delivered'),
(3002, 2001, 'MacBook Pro', 'Electronics', 199900.00, '2023-02-20', 'Delivered'),
(3003, 2001, 'iPad Air', 'Electronics', 59900.00, '2023-03-25', 'Delivered'),
(3004, 2001, 'AirPods Pro', 'Electronics', 24900.00, '2023-04-30', 'Delivered'),
(3005, 2001, 'Apple Watch', 'Electronics', 45900.00, '2023-05-15', 'Delivered'),
(3006, 2001, 'Magic Keyboard', 'Electronics', 12900.00, '2023-06-20', 'Delivered'),
(3007, 2001, 'Studio Display', 'Electronics', 159900.00, '2023-07-10', 'Delivered'),
(3008, 2001, 'Mac Mini', 'Electronics', 59900.00, '2023-08-18', 'Delivered'),
(3009, 2001, 'HomePod', 'Electronics', 32900.00, '2023-09-22', 'Delivered'),
(3010, 2001, 'Apple TV', 'Electronics', 18900.00, '2023-10-14', 'Delivered'),
(3011, 2001, 'MagSafe Charger', 'Electronics', 4900.00, '2023-11-28', 'Delivered'),
(3012, 2001, 'AirTag 4-Pack', 'Electronics', 11900.00, '2023-12-05', 'Delivered'),

-- CUSTOMER 2003 (Amit Patel) - EVERY MONTH BUYER (12 months)
(3013, 2003, 'Samsung TV 65"', 'Electronics', 89999.00, '2023-01-08', 'Delivered'),
(3014, 2003, 'Washing Machine', 'Appliances', 45999.00, '2023-02-12', 'Delivered'),
(3015, 2003, 'Refrigerator', 'Appliances', 89999.00, '2023-03-18', 'Delivered'),
(3016, 2003, 'Air Conditioner', 'Appliances', 55999.00, '2023-04-22', 'Delivered'),
(3017, 2003, 'Microwave', 'Appliances', 18999.00, '2023-05-26', 'Delivered'),
(3018, 2003, 'Vacuum Cleaner', 'Appliances', 25999.00, '2023-06-30', 'Delivered'),
(3019, 2003, 'Coffee Machine', 'Appliances', 32999.00, '2023-07-15', 'Delivered'),
(3020, 2003, 'Dishwasher', 'Appliances', 65999.00, '2023-08-19', 'Delivered'),
(3021, 2003, 'Water Purifier', 'Appliances', 15999.00, '2023-09-23', 'Delivered'),
(3022, 2003, 'Electric Kettle', 'Appliances', 2999.00, '2023-10-27', 'Delivered'),
(3023, 2003, 'Toaster', 'Appliances', 4999.00, '2023-11-14', 'Delivered'),
(3024, 2003, 'Blender', 'Appliances', 8999.00, '2023-12-18', 'Delivered'),

-- CUSTOMER 2002 (Priya Sharma) - FREQUENT BUT NOT EVERY MONTH (10 months)
(3025, 2002, 'Nike Shoes', 'Fashion', 12999.00, '2023-01-20', 'Delivered'),
(3026, 2002, 'Adidas Jacket', 'Fashion', 8999.00, '2023-02-25', 'Delivered'),
(3027, 2002, 'Levi Jeans', 'Fashion', 5999.00, '2023-03-15', 'Delivered'),
-- Missing April
(3028, 2002, 'Zara Dress', 'Fashion', 3999.00, '2023-05-18', 'Delivered'),
(3029, 2002, 'H&M Top', 'Fashion', 1999.00, '2023-06-22', 'Delivered'),
(3030, 2002, 'Puma Sneakers', 'Fashion', 9999.00, '2023-07-16', 'Delivered'),
(3031, 2002, 'Forever21 Skirt', 'Fashion', 2999.00, '2023-08-20', 'Delivered'),
(3032, 2002, 'Mango Coat', 'Fashion', 7999.00, '2023-09-24', 'Delivered'),
-- Missing October
(3033, 2002, 'Gucci Handbag', 'Fashion', 89999.00, '2023-11-28', 'Delivered'),
(3034, 2002, 'Louis Vuitton Wallet', 'Fashion', 45999.00, '2023-12-22', 'Delivered'),

-- CUSTOMER 2005 (Vikram Singh) - SEASONAL BUYER (6 months)
(3035, 2005, 'Cricket Bat', 'Sports', 8999.00, '2023-03-12', 'Delivered'),
(3036, 2005, 'Football', 'Sports', 2999.00, '2023-04-16', 'Delivered'),
(3037, 2005, 'Tennis Racket', 'Sports', 12999.00, '2023-05-20', 'Delivered'),
(3038, 2005, 'Golf Clubs Set', 'Sports', 89999.00, '2023-06-24', 'Delivered'),
(3039, 2005, 'Gym Equipment', 'Sports', 45999.00, '2023-07-28', 'Delivered'),
(3040, 2005, 'Bicycle', 'Sports', 25999.00, '2023-08-15', 'Delivered'),

-- CUSTOMER 2004 (Sneha Reddy) - OCCASIONAL BUYER (3 months)
(3041, 2004, 'Sofa Set', 'Furniture', 89999.00, '2023-02-10', 'Delivered'),
(3042, 2004, 'Dining Table', 'Furniture', 65999.00, '2023-06-15', 'Delivered'),
(3043, 2004, 'Bed Frame', 'Furniture', 45999.00, '2023-11-20', 'Delivered'),

-- CUSTOMER 2007 (Rohit Mehta) - EVERY MONTH BUYER (12 months)
(3044, 2007, 'Book Collection', 'Books', 5999.00, '2023-01-12', 'Delivered'),
(3045, 2007, 'Kindle', 'Electronics', 12999.00, '2023-02-16', 'Delivered'),
(3046, 2007, 'Office Chair', 'Furniture', 18999.00, '2023-03-20', 'Delivered'),
(3047, 2007, 'Desk Lamp', 'Electronics', 3999.00, '2023-04-24', 'Delivered'),
(3048, 2007, 'Monitor', 'Electronics', 25999.00, '2023-05-28', 'Delivered'),
(3049, 2007, 'Keyboard', 'Electronics', 8999.00, '2023-06-15', 'Delivered'),
(3050, 2007, 'Mouse', 'Electronics', 2999.00, '2023-07-19', 'Delivered'),
(3051, 2007, 'Webcam', 'Electronics', 12999.00, '2023-08-23', 'Delivered'),
(3052, 2007, 'Headphones', 'Electronics', 15999.00, '2023-09-27', 'Delivered'),
(3053, 2007, 'Speakers', 'Electronics', 22999.00, '2023-10-31', 'Delivered'),
(3054, 2007, 'Printer', 'Electronics', 18999.00, '2023-11-25', 'Delivered'),
(3055, 2007, 'Scanner', 'Electronics', 8999.00, '2023-12-29', 'Delivered');
