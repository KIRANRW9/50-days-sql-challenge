-- Day 48: Time to First Purchase Analysis

-- Drop tables if exist (for clean slate)
DROP TABLE IF EXISTS Purchases;
DROP TABLE IF EXISTS Users;

-- Create Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    email VARCHAR(100),
    signup_date DATE NOT NULL,
    signup_source VARCHAR(50),
    country VARCHAR(50)
);

-- Create Purchases table
CREATE TABLE Purchases (
    purchase_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    product_name VARCHAR(100),
    purchase_amount DECIMAL(10,2),
    purchase_date DATE NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- Insert sample data into Users
INSERT INTO Users VALUES
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', '2024-01-01', 'Referral', 'India'),
(102, 'Priya Sharma', 'priya.sharma@email.com', '2024-01-03', 'Organic Search', 'India'),
(103, 'Amit Patel', 'amit.patel@email.com', '2024-01-05', 'Social Media', 'India'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', '2024-01-08', 'Paid Ads', 'India'),
(105, 'Vikram Singh', 'vikram.singh@email.com', '2024-01-10', 'Referral', 'India'),
(106, 'Anita Joshi', 'anita.joshi@email.com', '2024-01-12', 'Organic Search', 'India'),
(107, 'Rohit Verma', 'rohit.verma@email.com', '2024-01-15', 'Organic Search', 'India'),
(108, 'Deepak Gupta', 'deepak.gupta@email.com', '2024-01-18', 'Paid Ads', 'India'),
(109, 'Kavita Nair', 'kavita.nair@email.com', '2024-01-20', 'Social Media', 'India'),
(110, 'Suresh Yadav', 'suresh.yadav@email.com', '2024-01-25', 'Social Media', 'India'),
(111, 'Meera Iyer', 'meera.iyer@email.com', '2024-02-01', 'Referral', 'India'),
(112, 'Arjun Malhotra', 'arjun.malhotra@email.com', '2024-02-05', 'Organic Search', 'India'),
(113, 'Pooja Kulkarni', 'pooja.kulkarni@email.com', '2024-02-10', 'Paid Ads', 'India'),
(114, 'Karan Mehta', 'karan.mehta@email.com', '2024-02-15', 'Referral', 'India'),
(115, 'Divya Shah', 'divya.shah@email.com', '2024-02-20', 'Social Media', 'India'),
(116, 'Nikhil Desai', 'nikhil.desai@email.com', '2024-03-01', 'Organic Search', 'India'),
(117, 'Sana Khan', 'sana.khan@email.com', '2024-03-10', 'Referral', 'India'),
(118, 'Ravi Kapoor', 'ravi.kapoor@email.com', '2024-03-15', 'Paid Ads', 'India');

-- Insert sample data into Purchases
-- User 101: Fast converter (1 day)
INSERT INTO Purchases VALUES
(1, 101, 'Laptop', 15000.00, '2024-01-02'),
(2, 101, 'Mouse', 500.00, '2024-01-10'),
(3, 101, 'Keyboard', 1200.00, '2024-01-20');

-- User 102: Normal converter (5 days)
INSERT INTO Purchases VALUES
(4, 102, 'Smartphone', 12000.00, '2024-01-08'),
(5, 102, 'Headphones', 2000.00, '2024-01-15');

-- User 103: Fast converter (2 days)
INSERT INTO Purchases VALUES
(6, 103, 'Tablet', 25000.00, '2024-01-07'),
(7, 103, 'Charger', 800.00, '2024-01-18');

-- User 104: Normal converter (7 days)
INSERT INTO Purchases VALUES
(8, 104, 'Monitor', 22000.00, '2024-01-15'),
(9, 104, 'Webcam', 3500.00, '2024-01-25');

-- User 105: Fast converter (3 days)
INSERT INTO Purchases VALUES
(10, 105, 'Smartwatch', 18000.00, '2024-01-13'),
(11, 105, 'Fitness Band', 4000.00, '2024-02-05');

-- User 106: Slow converter (10 days)
INSERT INTO Purchases VALUES
(12, 106, 'Desktop', 35000.00, '2024-01-22');

-- User 107: Very slow converter (15 days)
INSERT INTO Purchases VALUES
(13, 107, 'Earbuds', 8000.00, '2024-01-30');

-- User 109: Normal converter (5 days)
INSERT INTO Purchases VALUES
(14, 109, 'Camera', 45000.00, '2024-01-25'),
(15, 109, 'Tripod', 2500.00, '2024-02-10');

-- User 111: Fast converter (2 days)
INSERT INTO Purchases VALUES
(16, 111, 'Gaming Console', 30000.00, '2024-02-03'),
(17, 111, 'Controller', 5000.00, '2024-02-20');

-- User 112: Normal converter (6 days)
INSERT INTO Purchases VALUES
(18, 112, 'Printer', 15000.00, '2024-02-11');

-- User 114: Fast converter (3 days)
INSERT INTO Purchases VALUES
(19, 114, 'Router', 8000.00, '2024-02-18'),
(20, 114, 'External HDD', 6000.00, '2024-03-05');

-- User 117: Slow converter (12 days)
INSERT INTO Purchases VALUES
(21, 117, 'Smart TV', 55000.00, '2024-03-22');

-- Users 108, 110, 113, 115, 116, 118 have NOT made purchases yet (non-converters)
