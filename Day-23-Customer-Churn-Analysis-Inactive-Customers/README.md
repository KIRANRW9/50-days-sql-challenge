# Day 23: Customer Churn Analysis (Identifying Inactive Customers)

## Problem
The customer retention team needs to identify churned customers who haven't placed orders in the last 6 months for re-engagement campaigns, win-back strategies, and understanding customer lifecycle patterns. Identifying inactive customers helps in reducing churn rate, improving customer lifetime value, and optimizing marketing spend on retention efforts.

## Dataset
Customer and order data with transaction dates to identify customers who have stopped purchasing and analyze their characteristics for targeted retention campaigns.

## SQL Solution

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

## Query 1: Find Churned Customers (No Orders in Last 6 Months)

```sql
-- MySQL version - Find customers with no orders in last 6 months
SELECT customer_id
FROM Orders
GROUP BY customer_id
HAVING MAX(order_date) < DATE_SUB(CURDATE(), INTERVAL 6 MONTH);
```

### Output:

```
customer_id
-----------
1002
1004
1006
1008
1010
```


**How it works:**
- `MAX(order_date)` finds the most recent order for each customer
- `DATE_SUB(CURDATE(), INTERVAL 6 MONTH)` calculates date 6 months ago
- `HAVING` filters groups where last order is older than 6 months

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

### Output:

```
customer_id | customer_name | email                    | customer_tier | city      | last_order_date | days_since_last_order | total_orders | lifetime_value
------------|---------------|--------------------------|---------------|-----------|-----------------|-----------------------|--------------|---------------
1002        | Priya Sharma  | priya.sharma@email.com   | Gold          | Delhi     | 2023-09-15      | 385                   | 8            | 425000.00
1004        | Sneha Reddy   | sneha.reddy@email.com    | Premium       | Hyderabad | 2023-10-20      | 350                   | 6            | 380000.00
1006        | Anita Desai   | anita.desai@email.com    | Silver        | Pune      | 2023-11-10      | 329                   | 5            | 195000.00
1008        | Kavya Pillai  | kavya.pillai@email.com   | Gold          | Kochi     | 2023-10-05      | 365                   | 4            | 150000.00
1010        | Deepa Joshi   | deepa.joshi@email.com    | Silver        | Chennai   | 2023-09-28      | 372                   | 3            | 95000.00
```



**How it works:**
- `JOIN` combines customer details with their orders
- `GROUP BY` aggregates data per customer
- `DATEDIFF` calculates days since last purchase
- `HAVING` filters for customers inactive 6+ months

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

### Output:

```
customer_id | customer_name | customer_tier | last_order_date | days_inactive | customer_status | total_orders | lifetime_value
------------|---------------|---------------|-----------------|---------------|-----------------|--------------|---------------
1002        | Priya Sharma  | Gold          | 2023-09-15      | 385           | Churned         | 8            | 425000.00
1010        | Deepa Joshi   | Silver        | 2023-09-28      | 372           | Churned         | 3            | 95000.00
1008        | Kavya Pillai  | Gold          | 2023-10-05      | 365           | Churned         | 4            | 150000.00
1004        | Sneha Reddy   | Premium       | 2023-10-20      | 350           | Churned         | 6            | 380000.00
1006        | Anita Desai   | Silver        | 2023-11-10      | 329           | Churned         | 5            | 195000.00
1007        | Rohit Mehta   | Gold          | 2024-07-15      | 75            | Dormant         | 7            | 320000.00
1009        | Arjun Nair    | Premium       | 2024-08-20      | 39            | At Risk         | 9            | 550000.00
1001        | Rajesh Kumar  | Premium       | 2024-09-25      | 4             | Active          | 12           | 780000.00
1003        | Amit Patel    | Silver        | 2024-09-28      | 1             | Active          | 10           | 620000.00
1005        | Vikram Singh  | Gold          | 2024-09-27      | 2             | Active          | 11           | 695000.00
```


**How it works:**
- `CASE WHEN` creates different customer status categories
- `DATE_SUB` with different intervals defines each status
- `LEFT JOIN` includes customers even if they have no orders
- Results show customer lifecycle stages

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

### Output:

```
customer_tier | total_customers | churned_customers | active_customers | churn_rate_pct
--------------|-----------------|-------------------|------------------|---------------
Silver        | 4               | 3                 | 1                | 75.00
Gold          | 3               | 2                 | 1                | 66.67
Premium       | 3               | 1                 | 2                | 33.33
```


**How it works:**
- **CTE (WITH clause)** creates a temporary result set
- `is_churned` flag: 1 if churned, 0 if active
- `SUM(is_churned)` counts churned customers
- Churn rate = (Churned / Total) × 100

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

### Output:

```
customer_id | customer_name | email                    | customer_tier | city      | last_order_date | days_since_last_order | total_orders | lifetime_value | avg_order_value | winback_priority
------------|---------------|--------------------------|---------------|-----------|-----------------|-----------------------|--------------|----------------|-----------------|------------------
1002        | Priya Sharma  | priya.sharma@email.com   | Gold          | Delhi     | 2023-09-15      | 385                   | 8            | 425000.00      | 53125.00        | High Priority
1004        | Sneha Reddy   | sneha.reddy@email.com    | Premium       | Hyderabad | 2023-10-20      | 350                   | 6            | 380000.00      | 63333.33        | High Priority
1006        | Anita Desai   | anita.desai@email.com    | Silver        | Pune      | 2023-11-10      | 329                   | 5            | 195000.00      | 39000.00        | Medium Priority
1008        | Kavya Pillai  | kavya.pillai@email.com   | Gold          | Kochi     | 2023-10-05      | 365                   | 4            | 150000.00      | 37500.00        | Medium Priority
```


**How it works:**
- Identifies churned customers with high lifetime value
- `HAVING` with two conditions: churned AND high value
- `winback_priority` categorizes customers for campaigns
- Sorted by value to focus on most valuable lost customers

## How It Works

### Key Concepts
* **MAX(order_date)**: Finds the most recent order date for each customer
* **DATE_SUB()**: Subtracts time interval from current date (MySQL syntax)
* **DATEDIFF()**: Calculates difference in days between two dates
* **HAVING vs WHERE**: HAVING filters after GROUP BY, WHERE filters before
* **LEFT JOIN**: Includes all customers even if they have no orders
* **CTE (WITH clause)**: Creates temporary named result set for clarity


## Real World Use Cases

1. **Win-Back Campaigns**: Email high-value churned customers with special offers
2. **Churn Prevention**: Identify at-risk customers before they churn
3. **Customer Segmentation**: Prioritize retention efforts by customer value
4. **Marketing Budget**: Allocate spend based on customer lifecycle stage
5. **Product Improvements**: Analyze why customers stop purchasing
6. **Customer Success**: Proactive outreach to dormant customers
7. **Revenue Forecasting**: Account for expected churn in projections
8. **Loyalty Programs**: Design interventions for each customer status

## Key Learning Points

### Understanding GROUP BY with HAVING
**GROUP BY** creates groups, **HAVING** filters those groups. Think of it as:
1. First, group customers together
2. Then, for each group, find their last order
3. Finally, keep only groups where last order is old

### Date Calculations
- `CURDATE()` = Today's date
- `DATE_SUB(CURDATE(), INTERVAL 6 MONTH)` = 6 months ago
- `MAX(order_date) < [6 months ago]` = Last order was before 6 months ago
```
Churn Rate = (Churned Customers / Total Customers) × 100
```

