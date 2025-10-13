-- Day 35: Year-Over-Year Revenue Growth Analysis
-- Sample Data SQL File

-- Insert Sample Data into Orders Table
-- Creating data across 3 years (2022, 2023, 2024) to show YoY growth

-- ===== 2022 DATA (Base Year) =====
-- Q1 2022
INSERT INTO Orders VALUES
(1001, 101, 'Laptop', 85000.00, '2022-01-15', 'Delivered'),
(1002, 102, 'Mouse', 8000.00, '2022-01-20', 'Delivered'),
(1003, 103, 'Keyboard', 12000.00, '2022-02-10', 'Delivered'),
(1004, 104, 'Monitor', 35000.00, '2022-02-18', 'Delivered'),
(1005, 105, 'Headphones', 15000.00, '2022-03-05', 'Delivered'),
(1006, 106, 'Webcam', 12000.00, '2022-03-25', 'Delivered'),
(1007, 107, 'Speaker', 10000.00, '2022-03-30', 'Delivered');

-- Q2 2022
INSERT INTO Orders VALUES
(1008, 101, 'Phone', 65000.00, '2022-04-10', 'Delivered'),
(1009, 102, 'Tablet', 45000.00, '2022-05-08', 'Delivered'),
(1010, 103, 'Charger', 5000.00, '2022-05-15', 'Delivered'),
(1011, 104, 'Cable', 3000.00, '2022-06-12', 'Delivered'),
(1012, 105, 'Stand', 8000.00, '2022-06-20', 'Delivered'),
(1013, 106, 'Adapter', 12000.00, '2022-06-28', 'Delivered'),
(1014, 107, 'Hub', 95000.00, '2022-06-30', 'Delivered'),
(1015, 108, 'Drive', 55000.00, '2022-06-30', 'Delivered');

-- Q3 2022
INSERT INTO Orders VALUES
(1016, 101, 'Monitor', 42000.00, '2022-07-12', 'Delivered'),
(1017, 102, 'Printer', 48000.00, '2022-08-05', 'Delivered'),
(1018, 103, 'Scanner', 35000.00, '2022-08-18', 'Delivered'),
(1019, 104, 'Camera', 42000.00, '2022-09-10', 'Delivered');

-- Q4 2022
INSERT INTO Orders VALUES
(1020, 105, 'Laptop', 75000.00, '2022-10-15', 'Delivered'),
(1021, 106, 'Monitor', 38000.00, '2022-11-08', 'Delivered'),
(1022, 107, 'Keyboard', 15000.00, '2022-12-20', 'Delivered'),
(1023, 108, 'Mouse', 8000.00, '2022-12-28', 'Delivered');

-- ===== 2023 DATA (50% Growth Expected) =====
-- Q1 2023
INSERT INTO Orders VALUES
(1024, 101, 'Laptop', 120000.00, '2023-01-10', 'Delivered'),
(1025, 102, 'Mouse', 12000.00, '2023-01-22', 'Delivered'),
(1026, 103, 'Keyboard', 18000.00, '2023-02-08', 'Delivered'),
(1027, 104, 'Monitor', 52500.00, '2023-02-20', 'Delivered'),
(1028, 105, 'Headphones', 22500.00, '2023-03-05', 'Delivered'),
(1029, 106, 'Webcam', 18000.00, '2023-03-28', 'Delivered'),
(1030, 107, 'Speaker', 15000.00, '2023-03-30', 'Delivered'),
(1031, 108, 'Printer', 90000.00, '2023-03-31', 'Delivered'),
(1032, 109, 'Scanner', 52500.00, '2023-03-31', 'Delivered');

-- Q2 2023
INSERT INTO Orders VALUES
(1033, 101, 'Phone', 97500.00, '2023-04-12', 'Delivered'),
(1034, 102, 'Tablet', 67500.00, '2023-05-10', 'Delivered'),
(1035, 103, 'Charger', 7500.00, '2023-05-18', 'Delivered'),
(1036, 104, 'Cable', 4500.00, '2023-06-14', 'Delivered'),
(1037, 105, 'Stand', 12000.00, '2023-06-22', 'Delivered'),
(1038, 106, 'Adapter', 18000.00, '2023-06-30', 'Delivered'),
(1039, 107, 'Hub', 142500.00, '2023-06-30', 'Delivered'),
(1040, 108, 'Drive', 82500.00, '2023-06-30', 'Delivered'),
(1041, 109, 'Keyboard', 20000.00, '2023-06-30', 'Delivered'),
(1042, 110, 'Mouse', 10000.00, '2023-06-30', 'Delivered');

-- Q3 2023
INSERT INTO Orders VALUES
(1043, 101, 'Monitor', 63000.00, '2023-07-15', 'Delivered'),
(1044, 102, 'Printer', 72000.00, '2023-08-08', 'Delivered'),
(1045, 103, 'Scanner', 52500.00, '2023-08-20', 'Delivered'),
(1046, 104, 'Camera', 63000.00, '2023-09-12', 'Delivered'),
(1047, 105, 'Laptop', 45000.00, '2023-09-25', 'Delivered');

-- Q4 2023
INSERT INTO Orders VALUES
(1048, 106, 'Laptop', 112500.00, '2023-10-18', 'Delivered'),
(1049, 107, 'Monitor', 57000.00, '2023-11-10', 'Delivered'),
(1050, 108, 'Keyboard', 22500.00, '2023-12-22', 'Delivered'),
(1051, 109, 'Mouse', 12000.00, '2023-12-30', 'Delivered'),
(1052, 110, 'Speaker', 18000.00, '2023-12-31', 'Delivered');

-- ===== 2024 DATA (33% Growth Expected) =====
-- Q1 2024
INSERT INTO Orders VALUES
(1053, 101, 'Laptop', 160000.00, '2024-01-12', 'Delivered'),
(1054, 102, 'Mouse', 16000.00, '2024-01-25', 'Delivered'),
(1055, 103, 'Keyboard', 24000.00, '2024-02-10', 'Delivered'),
(1056, 104, 'Monitor', 70000.00, '2024-02-22', 'Delivered'),
(1057, 105, 'Headphones', 30000.00, '2024-03-08', 'Delivered'),
(1058, 106, 'Webcam', 24000.00, '2024-03-30', 'Delivered'),
(1059, 107, 'Speaker', 20000.00, '2024-03-31', 'Delivered'),
(1060, 108, 'Printer', 120000.00, '2024-03-31', 'Delivered'),
(1061, 109, 'Scanner', 70000.00, '2024-03-31', 'Delivered'),
(1062, 110, 'Drive', 15000.00, '2024-03-31', 'Delivered');

-- Q2 2024
INSERT INTO Orders VALUES
(1063, 101, 'Phone', 130000.00, '2024-04-14', 'Delivered'),
(1064, 102, 'Tablet', 90000.00, '2024-05-12', 'Delivered'),
(1065, 103, 'Charger', 10000.00, '2024-05-20', 'Delivered'),
(1066, 104, 'Cable', 6000.00, '2024-06-16', 'Delivered'),
(1067, 105, 'Stand', 16000.00, '2024-06-24', 'Delivered'),
(1068, 106, 'Adapter', 24000.00, '2024-07-01', 'Delivered'),
(1069, 107, 'Hub', 190000.00, '2024-07-01', 'Delivered'),
(1070, 108, 'Drive', 110000.00, '2024-07-01', 'Delivered'),
(1071, 109, 'Keyboard', 26500.00, '2024-07-01', 'Delivered'),
(1072, 110, 'Mouse', 13500.00, '2024-07-01', 'Delivered'),
(1073, 101, 'Case', 18000.00, '2024-07-02', 'Delivered');

-- Q3 2024
INSERT INTO Orders VALUES
(1074, 102, 'Monitor', 84000.00, '2024-07-17', 'Delivered'),
(1075, 103, 'Printer', 96000.00, '2024-08-10', 'Delivered'),
(1076, 104, 'Scanner', 70000.00, '2024-08-22', 'Delivered'),
(1077, 105, 'Camera', 84000.00, '2024-09-14', 'Delivered'),
(1078, 106, 'Laptop', 60000.00, '2024-09-27', 'Delivered');

-- Q4 2024
INSERT INTO Orders VALUES
(1079, 107, 'Laptop', 150000.00, '2024-10-20', 'Delivered'),
(1080, 108, 'Monitor', 76000.00, '2024-11-12', 'Delivered'),
(1081, 109, 'Keyboard', 30000.00, '2024-12-24', 'Delivered'),
(1082, 110, 'Mouse', 16000.00, '2024-12-31', 'Delivered'),
(1083, 101, 'Speaker', 24000.00, '2024-12-31', 'Delivered');
