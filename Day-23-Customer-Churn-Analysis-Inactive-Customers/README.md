# Day 23: Customer Churn Analysis (Identifying Inactive Customers)

## Problem
The customer retention team needs to identify churned customers who haven't placed orders in the last 6 months for re-engagement campaigns, win-back strategies, and understanding customer lifecycle patterns. Identifying inactive customers helps in reducing churn rate, improving customer lifetime value, and optimizing marketing spend on retention efforts.

## Dataset
Customer and order data with transaction dates to identify customers who have stopped purchasing and analyze their characteristics for targeted retention campaigns.

---

## SQL Solution

### Create Tables

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    registration_date DATE,
    customer_tier VARCHAR(20),
    city VARCHAR(50)
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    order_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);
```

### Insert Sample Data

```sql
-- Insert Customers data
INSERT INTO Customers (customer_id, customer_name, email, registration_date, customer_tier, city) VALUES
(1001, 'Rajesh Kumar', 'rajesh.kumar@email.com', '2022-01-15', 'Premium', 'Mumbai'),
(1002, 'Priya Sharma', 'priya.sharma@email.com', '2022-02-20', 'Gold', 'Delhi'),
(1003, 'Amit Patel', 'amit.patel@email.com', '2022-03-10', 'Silver', 'Bangalore'),
(1004, 'Sneha Reddy', 'sneha.reddy@email.com', '2022-04-05', 'Premium', 'Hyderabad'),
(1005, 'Vikram Singh', 'vikram.singh@email.com', '2022-05-12', 'Gold', 'Jaipur'),
(1006, 'Anita Desai', 'anita.desai@email.com', '2022-06-18', 'Silver', 'Pune'),
(1007, 'Rohit Mehta', 'rohit.mehta@email.com', '2022-07-22', 'Gold', 'Ahmedabad'),
(1008, 'Kavya Pillai', 'kavya.pillai@email.com', '2022-08-30', 'Gold', 'Kochi'),
(1009, 'Arjun Nair', 'arjun.nair@email.com', '2022-09-14', 'Premium', 'Kolkata'),
(1010, 'Deepa Joshi', 'deepa.joshi@email.com', '2022-10-25', 'Silver', 'Chennai');

-- Insert Orders data (Active customers - recent orders)
INSERT INTO Orders (order_id, customer_id, product_name, order_amount, order_date, status) VALUES
(2001, 1001, 'Laptop', 65000.00, '2024-09-25', 'Completed'),
(2002, 1001, 'Mouse', 1500.00, '2024-09-26', 'Completed'),
(2003, 1003, 'Monitor', 18000.00, '2024-09-28', 'Completed'),
(2004, 1005, 'Keyboard', 3500.00, '2024-09-27', 'Completed'),
(2005, 1009, 'Headphones', 8500.00, '2024-08-20', 'Completed'),
(2006, 1007, 'Webcam', 4500.00, '2024-07-15', 'Completed');

-- Insert Orders data (Churned customers - old orders from 6+ months ago)
INSERT INTO Orders (order_id, customer_id, product_name, order_amount, order_date, status) VALUES
(2007, 1002, 'Laptop', 55000.00, '2023-09-15', 'Completed'),
(2008, 1002, 'Tablet', 35000.00, '2023-08-20', 'Completed'),
(2009, 1002, 'Mouse', 2000.00, '2023-07-10', 'Completed'),
(2010, 1004, 'Desktop', 75000.00, '2023-10-20', 'Completed'),
(2011, 1004, 'Monitor', 25000.00, '2023-09-15', 'Completed'),
(2012, 1006, 'Laptop', 48000.00, '2023-11-10', 'Completed'),
(2013, 1006, 'Keyboard', 4000.00, '2023-10-05', 'Completed'),
(2014, 1008, 'Tablet', 32000.00, '2023-10-05', 'Completed'),
(2015, 1008, 'Mouse', 1800.00, '2023-09-12', 'Completed'),
(2016, 1010, 'Monitor', 22000.00, '2023-09-28', 'Completed'),
(2017, 1010, 'Webcam', 5500.00, '2023-08-15', 'Completed');

-- Additional historical orders for better analysis
INSERT INTO Orders (order_id, customer_id, product_name, order_amount, order_date, status) VALUES
(2018, 1001, 'Tablet', 28000.00, '2024-08-15', 'Completed'),
(2019, 1001, 'Headphones', 7500.00, '2024-07-20', 'Completed'),
(2020, 1003, 'Laptop', 62000.00, '2024-08-10', 'Completed'),
(2021, 1005, 'Desktop', 85000.00, '2024-08-05', 'Completed'),
(2022, 1009, 'Monitor', 19000.00, '2024-07-25', 'Completed'),
(2023, 1002, 'Headphones', 8500.00, '2023-06-15', 'Completed'),
(2024, 1004, 'Keyboard', 3800.00, '2023-08-20', 'Completed'),
(2025, 1006, 'Mouse', 2200.00, '2023-09-05', 'Completed'),
(2026, 1008, 'Webcam', 6000.00, '2023-08-10', 'Completed'),
(2027, 1010, 'Keyboard', 3500.00, '2023-07-20', 'Completed');
```

---

## Query 1: Find Churned Customers (No Orders in Last 6 Months)

```sql
-- Find customers with no orders in last 6 months
SELECT customer_id
FROM Orders
GROUP BY customer_id
HAVING MAX(order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
```

**How it works:**
- `MAX(order_date)` finds the most recent order for each customer
- `DATE_SUB(CURDATE(), INTERVAL 6 MONTH)` calculates date 6 months ago
- `HAVING` filters groups where last order is older than 6 months

---

## Query 2: Churned Customers with Details

```sql
-- Get detailed information about churned customers
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.customer_tier,
    c.city,
    MAX(o.order_date) as last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_since_last_order,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as lifetime_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.customer_tier, c.city
HAVING MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
ORDER BY lifetime_value DESC;
```

**How it works:**
- `JOIN` combines customer details with their orders
- `GROUP BY` aggregates data per customer
- `DATEDIFF` calculates days since last purchase
- `HAVING` filters for customers inactive 6+ months

---

## Query 3: Customer Status Classification

```sql
-- Classify all customers by activity status
SELECT 
    c.customer_id,
    c.customer_name,
    c.customer_tier,
    MAX(o.order_date) as last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_inactive,
    CASE 
        WHEN MAX(o.order_date) >= DATE_SUB(CURDATE(), INTERVAL 1 MONTH) THEN 'Active'
        WHEN MAX(o.order_date) >= DATE_SUB(CURDATE(), INTERVAL 3 MONTH) THEN 'At Risk'
        WHEN MAX(o.order_date) >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH) THEN 'Dormant'
        ELSE 'Churned'
    END as customer_status,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as lifetime_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.customer_tier
ORDER BY days_inactive DESC;
```

**How it works:**
- `CASE WHEN` creates different customer status categories
- `DATE_SUB` with different intervals defines each status
- `LEFT JOIN` includes customers even if they have no orders
- Results show customer lifecycle stages

---

## Query 4: Churn Rate Analysis by Customer Tier

```sql
-- Calculate churn rate by customer tier
WITH CustomerStatus AS (
    SELECT 
        c.customer_id,
        c.customer_tier,
        CASE 
            WHEN MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH) THEN 1
            ELSE 0
        END as is_churned
    FROM Customers c
    LEFT JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id, c.customer_tier
)
SELECT 
    customer_tier,
    COUNT(*) as total_customers,
    SUM(is_churned) as churned_customers,
    COUNT(*) - SUM(is_churned) as active_customers,
    ROUND((SUM(is_churned) * 100.0 / COUNT(*)), 2) as churn_rate_pct
FROM CustomerStatus
GROUP BY customer_tier
ORDER BY churn_rate_pct DESC;
```

**How it works:**
- **CTE (WITH clause)** creates a temporary result set
- `is_churned` flag: 1 if churned, 0 if active
- `SUM(is_churned)` counts churned customers
- Churn rate = (Churned / Total) × 100

---

## Query 5: High-Value Churned Customers for Win-Back Campaign

```sql
-- Identify high-value churned customers for targeted campaigns
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.customer_tier,
    c.city,
    MAX(o.order_date) as last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_since_last_order,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as lifetime_value,
    ROUND(SUM(o.order_amount) / COUNT(o.order_id), 2) as avg_order_value,
    CASE 
        WHEN SUM(o.order_amount) >= 300000 THEN 'High Priority'
        WHEN SUM(o.order_amount) >= 150000 THEN 'Medium Priority'
        ELSE 'Low Priority'
    END as winback_priority
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.email, c.customer_tier, c.city
HAVING MAX(o.order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    AND SUM(o.order_amount) >= 150000
ORDER BY lifetime_value DESC, days_since_last_order;
```

**How it works:**
- Identifies churned customers with high lifetime value
- `HAVING` with two conditions: churned AND high value
- `winback_priority` categorizes customers for campaigns
- Sorted by value to focus on most valuable lost customers

---

## Key Concepts

- **MAX(order_date)**: Finds the most recent order date for each customer
- **DATE_SUB()**: Subtracts time interval from current date (MySQL syntax)
- **DATEDIFF()**: Calculates difference in days between two dates
- **HAVING vs WHERE**: HAVING filters after GROUP BY, WHERE filters before
- **LEFT JOIN**: Includes all customers even if they have no orders
- **CTE (WITH clause)**: Creates temporary named result set for clarity

---

## Real World Use Cases

1. **Win-Back Campaigns**: Email high-value churned customers with special offers
2. **Churn Prevention**: Identify at-risk customers before they churn
3. **Customer Segmentation**: Prioritize retention efforts by customer value
4. **Marketing Budget**: Allocate spend based on customer lifecycle stage
5. **Product Improvements**: Analyze why customers stop purchasing
6. **Customer Success**: Proactive outreach to dormant customers
7. **Revenue Forecasting**: Account for expected churn in projections
8. **Loyalty Programs**: Design interventions for each customer status

---

## Formula

```
Churn Rate = (Churned Customers / Total Customers) × 100
```
