-- Day 32: UNPIVOT Data Normalization

-- Drop table if exists (for clean slate)
DROP TABLE IF EXISTS ProductSales;

-- Create ProductSales table (Wide format with month columns)
CREATE TABLE ProductSales (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    january DECIMAL(10,2),
    february DECIMAL(10,2),
    march DECIMAL(10,2),
    april DECIMAL(10,2),
    may DECIMAL(10,2),
    june DECIMAL(10,2)
);

-- Insert sample data (Wide format - each row has all months as columns)
INSERT INTO ProductSales VALUES
(101, 'Laptop', 'Electronics', 125000.00, 135000.00, 142000.00, 138000.00, 145000.00, 155000.00),
(102, 'Smartphone', 'Electronics', 95000.00, 102000.00, 108000.00, 105000.00, 112000.00, 118000.00),
(103, 'Tablet', 'Electronics', 65000.00, 68000.00, 72000.00, 70000.00, 75000.00, 78000.00),
(104, 'Smartwatch', 'Accessories', 45000.00, 48000.00, 52000.00, 50000.00, 55000.00, 58000.00),
(105, 'Headphones', 'Accessories', 35000.00, 38000.00, 42000.00, 40000.00, 45000.00, 48000.00);

-- Verify data insertion
SELECT 'Wide Format Data (Before UNPIVOT)' AS info;
SELECT * FROM ProductSales;

-- Show summary statistics
SELECT 
    'Data Summary' AS info,
    COUNT(*) AS total_products,
    SUM(january + february + march + april + may + june) AS total_revenue_6_months,
    ROUND(AVG(january + february + march + april + may + june), 2) AS avg_revenue_per_product
FROM ProductSales;

-- Show category breakdown
SELECT 
    category,
    COUNT(*) AS product_count,
    SUM(january + february + march + april + may + june) AS category_total_revenue
FROM ProductSales
GROUP BY category;
