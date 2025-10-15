```sql
-- Create Users table
CREATE TABLE Users (
    user_id INT PRIMARY KEY,
    username VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    user_tier VARCHAR(20)
);

-- Create Logins table
CREATE TABLE Logins (
    login_id INT PRIMARY KEY,
    user_id INT,
    login_date DATE,
    login_time TIME,
    platform VARCHAR(20)
);

-- Insert sample data into Users
INSERT INTO Users VALUES
(1001, 'rajesh_kumar', 'rajesh@email.com', '2023-12-01', 'Premium'),
(1002, 'priya_sharma', 'priya@email.com', '2023-11-15', 'Gold'),
(1003, 'amit_patel', 'amit@email.com', '2023-10-20', 'Silver'),
(1004, 'sneha_reddy', 'sneha@email.com', '2023-12-10', 'Premium'),
(1005, 'vikram_singh', 'vikram@email.com', '2023-09-25', 'Gold');

-- Insert sample data into Logins
INSERT INTO Logins VALUES
-- USER 1001: Long streak (7 days) + Another streak (5 days)
(2001, 1001, '2024-01-01', '09:30:00', 'Mobile'),
(2002, 1001, '2024-01-02', '10:15:00', 'Web'),
(2003, 1001, '2024-01-03', '08:45:00', 'Mobile'),
(2004, 1001, '2024-01-04', '09:00:00', 'Mobile'),
(2005, 1001, '2024-01-05', '11:30:00', 'Web'),
(2006, 1001, '2024-01-06', '10:00:00', 'Mobile'),
(2007, 1001, '2024-01-07', '09:15:00', 'Web'),
-- Gap of 2 days
(2008, 1001, '2024-01-10', '08:30:00', 'Mobile'),
(2009, 1001, '2024-01-11', '10:45:00', 'Web'),
(2010, 1001, '2024-01-12', '09:30:00', 'Mobile'),
(2011, 1001, '2024-01-13', '11:00:00', 'Web'),
(2012, 1001, '2024-01-14', '08:45:00', 'Mobile'),

-- USER 1002: Medium streak (4 days)
(2013, 1002, '2024-01-15', '07:30:00', 'Mobile'),
(2014, 1002, '2024-01-16', '08:15:00', 'Web'),
(2015, 1002, '2024-01-17', '07:45:00', 'Mobile'),
(2016, 1002, '2024-01-18', '09:00:00', 'Mobile'),
-- Gap
(2017, 1002, '2024-01-22', '10:30:00', 'Web'),

-- USER 1003: Very long streak (10 days) - Super engaged user
(2018, 1003, '2024-02-01', '06:30:00', 'Mobile'),
(2019, 1003, '2024-02-02', '06:45:00', 'Mobile'),
(2020, 1003, '2024-02-03', '07:00:00', 'Mobile'),
(2021, 1003, '2024-02-04', '06:30:00', 'Mobile'),
(2022, 1003, '2024-02-05', '07:15:00', 'Mobile'),
(2023, 1003, '2024-02-06', '06:45:00', 'Mobile'),
(2024, 1003, '2024-02-07', '07:30:00', 'Mobile'),
(2025, 1003, '2024-02-08', '06:30:00', 'Mobile'),
(2026, 1003, '2024-02-09', '07:00:00', 'Mobile'),
(2027, 1003, '2024-02-10', '06:45:00', 'Mobile'),

-- USER 1004: Short streak (3 days - minimum qualifying)
(2028, 1004, '2024-01-20', '12:00:00', 'Web'),
(2029, 1004, '2024-01-21', '11:45:00', 'Web'),
(2030, 1004, '2024-01-22', '12:15:00', 'Web'),
-- Gap
(2031, 1004, '2024-01-25', '10:00:00', 'Mobile'),

-- USER 1005: No qualifying streaks (only 2-day streak)
(2032, 1005, '2024-02-15', '14:00:00', 'Web'),
(2033, 1005, '2024-02-16', '15:30:00', 'Web'),
-- Gap
(2034, 1005, '2024-02-20', '13:45:00', 'Mobile'),
(2035, 1005, '2024-02-25', '14:30:00', 'Web');
```
