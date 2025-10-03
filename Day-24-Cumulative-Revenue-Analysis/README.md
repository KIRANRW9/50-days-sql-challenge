# Day 24: Cumulative Revenue Analysis

## Problem
The finance and analytics team needs to track cumulative revenue over time to understand business growth trends, monitor daily revenue progression, and identify revenue patterns. Cumulative revenue analysis helps in forecasting, measuring business momentum, tracking against targets, and making data-driven strategic decisions.

## Dataset
Order data with transaction dates and amounts to calculate running totals and analyze revenue accumulation patterns over time.

---

## SQL Solution

### Create Table

```sql
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
```

### Insert Sample Data

```sql
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
```

---

## Query 1: Basic Cumulative Revenue by Day

```sql
-- Calculate cumulative revenue by day
SELECT 
    order_date,
    SUM(order_amount) AS daily_revenue,
    SUM(SUM(order_amount)) OVER (ORDER BY order_date) AS cumulative_revenue
FROM Orders
WHERE status = 'Completed'
GROUP BY order_date
ORDER BY order_date;
```

**How it works:**
- `SUM(order_amount)` calculates daily revenue (per group)
- `SUM(...) OVER (ORDER BY order_date)` creates running total
- Window function processes rows in order, adding each day's revenue to previous total
- Results show both daily and cumulative revenue

---

## Query 2: Cumulative Revenue with Daily Growth

```sql
-- Cumulative revenue with daily growth metrics
SELECT 
    order_date,
    SUM(order_amount) AS daily_revenue,
    SUM(SUM(order_amount)) OVER (ORDER BY order_date) AS cumulative_revenue,
    ROUND(SUM(order_amount) / SUM(SUM(order_amount)) OVER (ORDER BY order_date) * 100, 2) AS daily_contribution_pct,
    LAG(SUM(SUM(order_amount)) OVER (ORDER BY order_date), 1) 
        OVER (ORDER BY order_date) AS previous_cumulative
FROM Orders
WHERE status = 'Completed'
GROUP BY order_date
ORDER BY order_date;
```

**How it works:**
- `LAG()` function accesses previous row's cumulative revenue
- Shows percentage contribution of each day to total cumulative revenue
- Helps identify high-impact days and growth acceleration

---

## Query 3: Monthly Cumulative Revenue Analysis

```sql
-- Cumulative revenue by month with comparisons
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') AS month,
    COUNT(order_id) AS total_orders,
    SUM(order_amount) AS monthly_revenue,
    SUM(SUM(order_amount)) OVER (ORDER BY DATE_FORMAT(order_date, '%Y-%m')) AS cumulative_revenue,
    ROUND(AVG(order_amount), 2) AS avg_order_value,
    MIN(order_amount) AS min_order,
    MAX(order_amount) AS max_order
FROM Orders
WHERE status = 'Completed'
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

**How it works:**
- `DATE_FORMAT()` groups orders by month
- Calculates monthly metrics alongside cumulative total
- Shows business growth at monthly granularity
- Includes order statistics for deeper insights

---

## Query 4: Cumulative Revenue by Payment Method

```sql
-- Cumulative revenue breakdown by payment method
SELECT 
    order_date,
    payment_method,
    SUM(order_amount) AS daily_amount,
    SUM(SUM(order_amount)) OVER (
        PARTITION BY payment_method 
        ORDER BY order_date
    ) AS cumulative_by_method,
    SUM(SUM(order_amount)) OVER (ORDER BY order_date) AS overall_cumulative
FROM Orders
WHERE status = 'Completed'
GROUP BY order_date, payment_method
ORDER BY order_date, payment_method;
```

**How it works:**
- `PARTITION BY payment_method` creates separate running totals per payment method
- Compares payment method performance over time
- Shows both method-specific and overall cumulative revenue
- Useful for understanding payment preference trends

---

## Query 5: Cumulative Revenue with Target Tracking

```sql
-- Track cumulative revenue against monthly targets
WITH DailyRevenue AS (
    SELECT 
        order_date,
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(order_amount) AS daily_revenue
    FROM Orders
    WHERE status = 'Completed'
    GROUP BY order_date, DATE_FORMAT(order_date, '%Y-%m')
),
MonthlyTargets AS (
    SELECT '2024-01' AS month, 250000 AS target
    UNION ALL SELECT '2024-02', 280000
    UNION ALL SELECT '2024-03', 310000
)
SELECT 
    d.order_date,
    d.month,
    d.daily_revenue,
    SUM(d.daily_revenue) OVER (
        PARTITION BY d.month 
        ORDER BY d.order_date
    ) AS month_cumulative_revenue,
    t.target AS monthly_target,
    ROUND(SUM(d.daily_revenue) OVER (
        PARTITION BY d.month 
        ORDER BY d.order_date
    ) / t.target * 100, 2) AS target_achievement_pct
FROM DailyRevenue d
LEFT JOIN MonthlyTargets t ON d.month = t.month
ORDER BY d.order_date;
```

**How it works:**
- **CTE** separates daily revenue calculation and target definition
- `PARTITION BY month` resets cumulative total each month
- Calculates percentage of monthly target achieved
- Helps track progress toward revenue goals in real-time

---

## Key Concepts

- **Window Functions**: Perform calculations across sets of rows related to current row
- **SUM() OVER()**: Creates running/cumulative totals without collapsing rows
- **ORDER BY in OVER()**: Defines sequence for cumulative calculation
- **PARTITION BY**: Resets cumulative calculation for each partition/group
- **LAG()**: Accesses data from previous row for comparisons
- **Nested Aggregations**: `SUM(SUM(...))` - inner SUM groups, outer SUM accumulates

---

## Real World Use Cases

1. **Financial Reporting**: Track daily revenue accumulation for financial statements
2. **Sales Dashboards**: Real-time visualization of revenue growth trends
3. **Target Monitoring**: Compare actual cumulative revenue vs. targets
4. **Forecasting**: Predict end-of-period revenue based on cumulative trends
5. **Investor Reporting**: Show business momentum and growth trajectory
6. **Budget Management**: Monitor spending and revenue against budget allocations
7. **Performance Analytics**: Identify acceleration or deceleration in growth
8. **Strategic Planning**: Use historical cumulative patterns for future planning

---

## Formula

```
Cumulative Revenue (Day N) = Revenue (Day 1) + Revenue (Day 2) + ... + Revenue (Day N)

Daily Contribution % = (Daily Revenue / Cumulative Revenue) × 100

Target Achievement % = (Cumulative Revenue / Target) × 100
```

---

## Understanding Window Functions

**Regular GROUP BY**: Collapses rows into single summary row
```sql
SELECT order_date, SUM(order_amount) 
FROM Orders GROUP BY order_date;
-- Returns: One row per date
```

**Window Function**: Keeps all rows, adds calculation
```sql
SELECT order_date, order_amount,
       SUM(order_amount) OVER (ORDER BY order_date)
FROM Orders;
-- Returns: All rows with running total
```
