# Day 20: Moving Average and Window Functions Analysis (Rolling Calculations & Trends)

## Problem
The sales and analytics teams need to identify trends and smooth out daily fluctuations in sales data by calculating moving averages. Moving averages help in understanding underlying trends, seasonal patterns, and making forecasts by reducing noise in daily sales data. This problem tests understanding of window functions, ROWS BETWEEN clause, and time-series analysis.

## Dataset
Daily sales order data with varying amounts across multiple days to demonstrate trend analysis and moving average calculations.

## SQL Solution

```sql
-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    region VARCHAR(50)
);

-- Insert sample data into Orders (Daily data for January 2024)
INSERT INTO Orders VALUES
-- Week 1
(1001, 2001, 'Laptop', 125000.00, '2024-01-01', 'North'),
(1002, 2002, 'Phone', 85000.00, '2024-01-01', 'South'),
(1003, 2003, 'Tablet', 45000.00, '2024-01-02', 'East'),
(1004, 2004, 'Headphones', 15000.00, '2024-01-02', 'West'),
(1005, 2005, 'Monitor', 35000.00, '2024-01-03', 'North'),
(1006, 2006, 'Keyboard', 8000.00, '2024-01-03', 'South'),
(1007, 2007, 'Mouse', 3000.00, '2024-01-04', 'East'),
(1008, 2008, 'Webcam', 12000.00, '2024-01-04', 'West'),

-- Week 2
(1009, 2009, 'Printer', 28000.00, '2024-01-05', 'North'),
(1010, 2010, 'Scanner', 18000.00, '2024-01-05', 'South'),
(1011, 2011, 'Speaker', 22000.00, '2024-01-06', 'East'),
(1012, 2012, 'Camera', 95000.00, '2024-01-06', 'West'),
(1013, 2013, 'Smartwatch', 45000.00, '2024-01-07', 'North'),
(1014, 2014, 'Earbuds', 12000.00, '2024-01-07', 'South'),
(1015, 2015, 'Charger', 2000.00, '2024-01-08', 'East'),
(1016, 2016, 'Power Bank', 5000.00, '2024-01-08', 'West'),

-- Week 3
(1017, 2017, 'Hard Drive', 15000.00, '2024-01-09', 'North'),
(1018, 2018, 'SSD', 25000.00, '2024-01-09', 'South'),
(1019, 2019, 'RAM', 18000.00, '2024-01-10', 'East'),
(1020, 2020, 'Graphics Card', 85000.00, '2024-01-10', 'West'),
(1021, 2021, 'Motherboard', 35000.00, '2024-01-11', 'North'),
(1022, 2022, 'Processor', 45000.00, '2024-01-11', 'South'),
(1023, 2023, 'Cooling Fan', 8000.00, '2024-01-12', 'East'),
(1024, 2024, 'Case', 12000.00, '2024-01-12', 'West'),

-- Week 4
(1025, 2025, 'Router', 15000.00, '2024-01-13', 'North'),
(1026, 2026, 'Switch', 22000.00, '2024-01-13', 'South'),
(1027, 2027, 'Cable', 2000.00, '2024-01-14', 'East'),
(1028, 2028, 'Adapter', 3000.00, '2024-01-14', 'West'),
(1029, 2029, 'USB Hub', 5000.00, '2024-01-15', 'North'),
(1030, 2030, 'Docking Station', 18000.00, '2024-01-15', 'South'),
(1031, 2031, 'Desk Lamp', 8000.00, '2024-01-16', 'East'),
(1032, 2032, 'Chair', 25000.00, '2024-01-16', 'West'),

-- Week 5
(1033, 2033, 'Desk', 35000.00, '2024-01-17', 'North'),
(1034, 2034, 'Bookshelf', 28000.00, '2024-01-17', 'South'),
(1035, 2035, 'Filing Cabinet', 15000.00, '2024-01-18', 'East'),
(1036, 2036, 'Whiteboard', 12000.00, '2024-01-18', 'West'),
(1037, 2037, 'Projector', 95000.00, '2024-01-19', 'North'),
(1038, 2038, 'Screen', 45000.00, '2024-01-19', 'South'),
(1039, 2039, 'Conference Phone', 28000.00, '2024-01-20', 'East'),
(1040, 2040, 'Video System', 85000.00, '2024-01-20', 'West');
```

## Query 1: 3-Day Moving Average of Sales

```sql
-- Calculate moving average over the last 3 days (including current day)
SELECT 
    order_date,
    SUM(total_amount) as daily_sales,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3_days
FROM Orders
GROUP BY order_date
ORDER BY order_date;
```

## Output:

```
order_date | daily_sales | moving_avg_3_days
-----------|-------------|------------------
2024-01-01 | 210000.00   | 210000.00
2024-01-02 | 60000.00    | 135000.00
2024-01-03 | 43000.00    | 104333.33
2024-01-04 | 15000.00    | 39333.33
2024-01-05 | 46000.00    | 34666.67
2024-01-06 | 117000.00   | 59333.33
2024-01-07 | 57000.00    | 73333.33
2024-01-08 | 7000.00     | 60333.33
2024-01-09 | 40000.00    | 34666.67
2024-01-10 | 103000.00   | 50000.00
2024-01-11 | 80000.00    | 74333.33
2024-01-12 | 20000.00    | 67666.67
2024-01-13 | 37000.00    | 45666.67
2024-01-14 | 5000.00     | 20666.67
2024-01-15 | 23000.00    | 21666.67
2024-01-16 | 33000.00    | 20333.33
2024-01-17 | 63000.00    | 39666.67
2024-01-18 | 27000.00    | 41000.00
2024-01-19 | 140000.00   | 76666.67
2024-01-20 | 113000.00   | 93333.33
```


## Query 2: Moving Average with Multiple Window Sizes 

```sql
-- Compare different moving average periods (3-day, 5-day, 7-day)
SELECT 
    order_date,
    SUM(total_amount) as daily_sales,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS ma_3_days,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 4 PRECEDING AND CURRENT ROW
    ), 2) AS ma_5_days,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ), 2) AS ma_7_days
FROM Orders
GROUP BY order_date
ORDER BY order_date;
```

## Output:

```
order_date | daily_sales | ma_3_days  | ma_5_days  | ma_7_days
-----------|-------------|------------|------------|------------
2024-01-01 | 210000.00   | 210000.00  | 210000.00  | 210000.00
2024-01-02 | 60000.00    | 135000.00  | 135000.00  | 135000.00
2024-01-03 | 43000.00    | 104333.33  | 104333.33  | 104333.33
2024-01-04 | 15000.00    | 39333.33   | 82000.00   | 82000.00
2024-01-05 | 46000.00    | 34666.67   | 74800.00   | 74800.00
2024-01-06 | 117000.00   | 59333.33   | 58200.00   | 81571.43
2024-01-07 | 57000.00    | 73333.33   | 57600.00   | 78285.71
2024-01-08 | 7000.00     | 60333.33   | 56400.00   | 63571.43
2024-01-09 | 40000.00    | 34666.67   | 53400.00   | 56428.57
2024-01-10 | 103000.00   | 50000.00   | 66800.00   | 61285.71
```


## Query 3: Moving Average with Running Total 

```sql
-- Calculate both moving average and cumulative total
SELECT 
    order_date,
    SUM(total_amount) as daily_sales,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3_days,
    SUM(SUM(total_amount)) OVER (
        ORDER BY order_date
    ) AS cumulative_total,
    ROUND((SUM(total_amount) / SUM(SUM(total_amount)) OVER (ORDER BY order_date)) * 100, 2) as pct_of_cumulative
FROM Orders
GROUP BY order_date
ORDER BY order_date;
```

## Output:

```
order_date | daily_sales | moving_avg_3_days | cumulative_total | pct_of_cumulative
-----------|-------------|-------------------|------------------|------------------
2024-01-01 | 210000.00   | 210000.00         | 210000.00        | 100.00
2024-01-02 | 60000.00    | 135000.00         | 270000.00        | 22.22
2024-01-03 | 43000.00    | 104333.33         | 313000.00        | 13.74
2024-01-04 | 15000.00    | 39333.33          | 328000.00        | 4.57
2024-01-05 | 46000.00    | 34666.67          | 374000.00        | 12.30
2024-01-06 | 117000.00   | 59333.33          | 491000.00        | 23.83
2024-01-07 | 57000.00    | 73333.33          | 548000.00        | 10.40
2024-01-08 | 7000.00     | 60333.33          | 555000.00        | 1.26
2024-01-09 | 40000.00    | 34666.67          | 595000.00        | 6.72
2024-01-10 | 103000.00   | 50000.00          | 698000.00        | 14.76
```


## Query 4: Sales Trend Analysis with LAG 

```sql
-- Compare current day sales with previous day and moving average
SELECT 
    order_date,
    SUM(total_amount) as daily_sales,
    LAG(SUM(total_amount)) OVER (ORDER BY order_date) as previous_day_sales,
    SUM(total_amount) - LAG(SUM(total_amount)) OVER (ORDER BY order_date) as day_over_day_change,
    ROUND(AVG(SUM(total_amount)) OVER (
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS moving_avg_3_days,
    CASE 
        WHEN SUM(total_amount) > AVG(SUM(total_amount)) OVER (
            ORDER BY order_date 
            ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ) THEN 'Above MA'
        ELSE 'Below MA'
    END as trend_indicator
FROM Orders
GROUP BY order_date
ORDER BY order_date;
```

## Output:

```
order_date | daily_sales | previous_day_sales | day_over_day_change | moving_avg_3_days | trend_indicator
-----------|-------------|-------------------|---------------------|-------------------|----------------
2024-01-01 | 210000.00   | NULL              | NULL                | 210000.00         | Below MA
2024-01-02 | 60000.00    | 210000.00         | -150000.00          | 135000.00         | Below MA
2024-01-03 | 43000.00    | 60000.00          | -17000.00           | 104333.33         | Below MA
2024-01-04 | 15000.00    | 43000.00          | -28000.00           | 39333.33          | Below MA
2024-01-05 | 46000.00    | 15000.00          | 31000.00            | 34666.67          | Above MA
2024-01-06 | 117000.00   | 46000.00          | 71000.00            | 59333.33          | Above MA
2024-01-07 | 57000.00    | 117000.00         | -60000.00           | 73333.33          | Below MA
2024-01-08 | 7000.00     | 57000.00          | -50000.00           | 60333.33          | Below MA
2024-01-09 | 40000.00    | 7000.00           | 33000.00            | 34666.67          | Above MA
2024-01-10 | 103000.00   | 40000.00          | 63000.00            | 50000.00          | Above MA
```


## Query 5: Region-wise Moving Average 

```sql
-- Calculate moving average separately for each region
SELECT 
    order_date,
    region,
    SUM(total_amount) as regional_daily_sales,
    ROUND(AVG(SUM(total_amount)) OVER (
        PARTITION BY region
        ORDER BY order_date 
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
    ), 2) AS region_moving_avg_3_days,
    RANK() OVER (PARTITION BY order_date ORDER BY SUM(total_amount) DESC) as daily_rank
FROM Orders
GROUP BY order_date, region
ORDER BY order_date, regional_daily_sales DESC;
```

## Output:

```
order_date | region | regional_daily_sales | region_moving_avg_3_days | daily_rank
-----------|--------|---------------------|-------------------------|------------
2024-01-01 | North  | 125000.00           | 125000.00               | 1
2024-01-01 | South  | 85000.00            | 85000.00                | 2
2024-01-02 | East   | 45000.00            | 45000.00                | 1
2024-01-02 | West   | 15000.00            | 15000.00                | 2
2024-01-03 | North  | 35000.00            | 80000.00                | 1
2024-01-03 | South  | 8000.00             | 46500.00                | 2
2024-01-04 | West   | 12000.00            | 13500.00                | 1
2024-01-04 | East   | 3000.00             | 24000.00                | 2
```


## How It Works
* **Window Functions**: Perform calculations across rows related to the current row
* **ROWS BETWEEN**: Defines the window frame (which rows to include in calculation)
* **PRECEDING**: Refers to rows before the current row
* **CURRENT ROW**: Includes the current row in the calculation
* **Moving Average**: Smooths out short-term fluctuations and highlights trends
* **LAG Function**: Accesses data from previous rows for comparison
* **PARTITION BY**: Creates separate windows for each partition (like region)
* **Running Totals**: Cumulative calculations using window functions

## Real World Use Cases
1. **Trend Analysis**: Identify upward or downward trends in sales data
2. **Anomaly Detection**: Spot unusual spikes or drops by comparing with moving average
3. **Forecasting**: Use historical moving averages for future predictions
4. **Performance Monitoring**: Track if daily performance is above or below trend
5. **Seasonal Patterns**: Smooth out daily noise to see weekly or monthly patterns
6. **Regional Comparison**: Compare performance trends across different regions

## Key Learning
**Window Functions with ROWS BETWEEN** enable sophisticated time-series analysis without self-joins. Moving averages are fundamental for understanding trends and making data-driven decisions.

**Frame Specification** (ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) determines which rows participate in calculations. Understanding frame boundaries is critical for accurate rolling calculations.

**Multiple Window Functions** can be combined in a single query to provide comprehensive trend analysis, comparing different time periods and metrics simultaneously.
