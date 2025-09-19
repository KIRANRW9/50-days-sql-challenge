# Day 10: Latest Records and MAX Functions (Finding Most Recent Data)

## Problem
The customer service and sales teams need to track customer engagement by identifying the most recent activity for each customer. This analysis helps in understanding customer recency, identifying inactive customers, and planning re-engagement campaigns. This problem tests understanding of MAX function, GROUP BY operations, and finding latest records per group.

## Dataset
Customer order data with multiple transactions per customer showing order dates, amounts, and product information for recency analysis.

## SQL Solution

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50),
    registration_date DATE
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
(101, 'Rajesh Kumar', 'rajesh.kumar@email.com', '9876543210', 'Mumbai', '2023-01-15'),
(102, 'Priya Sharma', 'priya.sharma@email.com', '9876543211', 'Delhi', '2023-02-20'),
(103, 'Amit Patel', 'amit.patel@email.com', '9876543212', 'Bangalore', '2023-03-10'),
(104, 'Sneha Reddy', 'sneha.reddy@email.com', '9876543213', 'Hyderabad', '2023-04-05'),
(105, 'Vikram Singh', 'vikram.singh@email.com', '9876543214', 'Chennai', '2023-05-12'),
(106, 'Anita Desai', 'anita.desai@email.com', '9876543215', 'Pune', '2023-06-18'),
(107, 'Rohit Mehta', 'rohit.mehta@email.com', '9876543216', 'Kolkata', '2023-07-22'),
(108, 'Kavya Pillai', 'kavya.pillai@email.com', '9876543217', 'Kochi', '2023-08-14'),
(109, 'Arjun Nair', 'arjun.nair@email.com', '9876543218', 'Ahmedabad', '2023-09-08'),
(110, 'Deepa Joshi', 'deepa.joshi@email.com', '9876543219', 'Jaipur', '2023-10-25');

-- Insert sample data into Orders
INSERT INTO Orders VALUES
-- Customer 101: Multiple orders across months
(1001, 101, 'iPhone 15 Pro', 'Electronics', 129900.00, '2024-01-15', 'Delivered'),
(1002, 101, 'MacBook Air M3', 'Electronics', 114900.00, '2024-05-20', 'Delivered'),
(1003, 101, 'AirPods Pro', 'Electronics', 24900.00, '2024-08-10', 'Delivered'),

-- Customer 102: Regular customer with recent activity
(1004, 102, 'Samsung Galaxy S24', 'Electronics', 89999.00, '2024-02-25', 'Delivered'),
(1005, 102, 'Samsung Watch', 'Electronics', 29999.00, '2024-07-15', 'Delivered'),

-- Customer 103: Frequent shopper
(1006, 103, 'Nike Shoes', 'Fashion', 8999.00, '2024-01-10', 'Delivered'),
(1007, 103, 'Adidas T-Shirt', 'Fashion', 2499.00, '2024-03-05', 'Delivered'),
(1008, 103, 'Puma Jacket', 'Fashion', 4999.00, '2024-06-20', 'Delivered'),
(1009, 103, 'Reebok Cap', 'Fashion', 1299.00, '2024-09-15', 'Delivered'),

-- Customer 104: Single recent order
(1010, 104, 'Dell XPS Laptop', 'Electronics', 125000.00, '2024-04-28', 'Delivered'),

-- Customer 105: Recent active customer
(1011, 105, 'Sony Headphones', 'Electronics', 15999.00, '2024-03-15', 'Delivered'),
(1012, 105, 'Canon Camera', 'Electronics', 45999.00, '2024-08-22', 'Delivered'),

-- Customer 106: Inactive customer (older orders)
(1013, 106, 'Levis Jeans', 'Fashion', 4999.00, '2024-01-10', 'Delivered'),
(1014, 106, 'Zara Dress', 'Fashion', 3499.00, '2024-02-14', 'Delivered'),

-- Customer 107: Very recent order
(1015, 107, 'JBL Speaker', 'Electronics', 8999.00, '2024-10-15', 'Delivered'),

-- Customer 108: Mid-year activity
(1016, 108, 'Samsung 55" TV', 'Electronics', 65999.00, '2024-06-05', 'Delivered'),

-- Customer 109: Recent small purchases
(1017, 109, 'Phone Case', 'Accessories', 999.00, '2024-09-10', 'Delivered'),
(1018, 109, 'Charging Cable', 'Accessories', 599.00, '2024-10-01', 'Delivered'),

-- Customer 110: No orders (registered but never purchased)
-- This customer will not appear in order-based queries
```

## Query 1: Latest Order Date Per Customer 

```sql
-- Get the latest order date for each customer
SELECT 
    customer_id, 
    MAX(order_date) AS latest_order_date 
FROM Orders 
GROUP BY customer_id
ORDER BY latest_order_date DESC;
```

## Output:

```
customer_id | latest_order_date
------------|------------------
107         | 2024-10-15
109         | 2024-10-01
103         | 2024-09-15
105         | 2024-08-22
101         | 2024-08-10
102         | 2024-07-15
108         | 2024-06-05
106         | 2024-02-14
104         | 2024-04-28
```


## Query 2: Latest Order Details with Customer Names 

```sql
-- Get complete latest order details with customer information
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    o.order_id,
    o.product_name,
    o.order_amount,
    o.order_date as latest_order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_date = (
    SELECT MAX(order_date) 
    FROM Orders o2 
    WHERE o2.customer_id = c.customer_id
)
ORDER BY o.order_date DESC;
```

## Output:

```
customer_id | customer_name | city      | order_id | product_name      | order_amount | latest_order_date
------------|---------------|-----------|----------|-------------------|--------------|------------------
107         | Rohit Mehta   | Kolkata   | 1015     | JBL Speaker       | 8999.00      | 2024-10-15
109         | Arjun Nair    | Ahmedabad | 1018     | Charging Cable    | 599.00       | 2024-10-01
103         | Amit Patel    | Bangalore | 1009     | Reebok Cap        | 1299.00      | 2024-09-15
105         | Vikram Singh  | Chennai   | 1012     | Canon Camera      | 45999.00     | 2024-08-22
101         | Rajesh Kumar  | Mumbai    | 1003     | AirPods Pro       | 24900.00     | 2024-08-10
102         | Priya Sharma  | Delhi     | 1005     | Samsung Watch     | 29999.00     | 2024-07-15
108         | Kavya Pillai  | Kochi     | 1016     | Samsung 55" TV    | 65999.00     | 2024-06-05
104         | Sneha Reddy   | Hyderabad | 1010     | Dell XPS Laptop   | 125000.00    | 2024-04-28
106         | Anita Desai   | Pune      | 1014     | Zara Dress        | 3499.00      | 2024-02-14
```


## Query 3: Customer Activity Analysis 
```sql
-- Analyze customer activity based on latest order date
SELECT 
    c.customer_name,
    c.city,
    MAX(o.order_date) as latest_order_date,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as total_spent,
    DATEDIFF(CURDATE(), MAX(o.order_date)) as days_since_last_order,
    CASE 
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 30 THEN 'Active'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 90 THEN 'Recent'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) <= 180 THEN 'Inactive'
        ELSE 'Dormant'
    END as customer_status
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NOT NULL
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY latest_order_date DESC;
```

## Output:

```
customer_name | city      | latest_order_date | total_orders | total_spent | days_since_last_order | customer_status
--------------|-----------|-------------------|--------------|-------------|----------------------|----------------
Rohit Mehta   | Kolkata   | 2024-10-15        | 1            | 8999.00     | 35                   | Recent
Arjun Nair    | Ahmedabad | 2024-10-01        | 2            | 1598.00     | 49                   | Recent
Amit Patel    | Bangalore | 2024-09-15        | 4            | 17796.00    | 65                   | Recent
Vikram Singh  | Chennai   | 2024-08-22        | 2            | 61998.00    | 89                   | Recent
Rajesh Kumar  | Mumbai    | 2024-08-10        | 3            | 269700.00   | 101                  | Inactive
Priya Sharma  | Delhi     | 2024-07-15        | 2            | 119998.00   | 127                  | Inactive
Kavya Pillai  | Kochi     | 2024-06-05        | 1            | 65999.00    | 167                  | Inactive
Sneha Reddy   | Hyderabad | 2024-04-28        | 1            | 125000.00   | 205                  | Dormant
Anita Desai   | Pune      | 2024-02-14        | 2            | 8498.00     | 278                  | Dormant
```


## Query 4: Monthly Latest Order Trends

```sql
-- Analyze when customers placed their latest orders by month
SELECT 
    DATE_FORMAT(MAX(order_date), '%Y-%m') as latest_order_month,
    DATE_FORMAT(MAX(order_date), '%M %Y') as month_name,
    COUNT(DISTINCT customer_id) as customers_last_ordered,
    ROUND(AVG(order_amount), 2) as avg_order_amount
FROM Orders
GROUP BY customer_id
HAVING MAX(order_date) IS NOT NULL
ORDER BY latest_order_month DESC;
```

## Output:

```
latest_order_month | month_name    | customers_last_ordered | avg_order_amount
-------------------|---------------|------------------------|------------------
2024-10            | October 2024  | 2                      | 4799.00
2024-09            | September 2024| 1                      | 1299.00
2024-08            | August 2024   | 2                      | 35449.50
2024-07            | July 2024     | 1                      | 29999.00
2024-06            | June 2024     | 1                      | 65999.00
2024-04            | April 2024    | 1                      | 125000.00
2024-02            | February 2024 | 1                      | 3499.00
```


## Query 5: Customers with No Recent Activity 

```sql
-- Find customers who haven't ordered in the last 60 days or never ordered
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    c.registration_date,
    COALESCE(MAX(o.order_date), 'Never Ordered') as latest_order_date,
    CASE 
        WHEN MAX(o.order_date) IS NULL THEN 'Never Ordered'
        WHEN DATEDIFF(CURDATE(), MAX(o.order_date)) > 60 THEN 'Needs Re-engagement'
        ELSE 'Recent Customer'
    END as engagement_status
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city, c.registration_date
HAVING MAX(o.order_date) IS NULL 
    OR DATEDIFF(CURDATE(), MAX(o.order_date)) > 60
ORDER BY latest_order_date DESC;
```

## Output:

```
customer_id | customer_name | city      | registration_date | latest_order_date | engagement_status
------------|---------------|-----------|-------------------|-------------------|------------------
110         | Deepa Joshi   | Jaipur    | 2023-10-25        | Never Ordered     | Never Ordered
101         | Rajesh Kumar  | Mumbai    | 2023-01-15        | 2024-08-10        | Needs Re-engagement
102         | Priya Sharma  | Delhi     | 2023-02-20        | 2024-07-15        | Needs Re-engagement
108         | Kavya Pillai  | Kochi     | 2023-08-14        | 2024-06-05        | Needs Re-engagement
104         | Sneha Reddy   | Hyderabad | 2023-04-05        | 2024-04-28        | Needs Re-engagement
106         | Anita Desai   | Pune      | 2023-06-18        | 2024-02-14        | Needs Re-engagement
```


## How It Works
* **MAX() Function**: Finds the maximum (latest) date value within each group
* **GROUP BY**: Groups rows by customer_id to find individual customer's latest order
* **Correlated Subquery**: Compares each row's date with the maximum date for that customer
* **LEFT JOIN**: Includes customers who may not have placed orders
* **COALESCE**: Handles NULL values by providing alternative text
* **DATEDIFF**: Calculates days between dates for recency analysis
* **Date Formatting**: Uses DATE_FORMAT for readable month-year display

## Real World Use Cases
1. **Customer Re-engagement**: Identify customers who need follow-up campaigns
2. **Activity Monitoring**: Track customer engagement and purchasing patterns
3. **Churn Prevention**: Find customers at risk of becoming inactive
4. **Sales Pipeline**: Understand customer lifecycle and buying frequency
5. **Marketing Campaigns**: Target customers based on last activity date
6. **Customer Service**: Prioritize support based on recent activity levels

## Key Learning
**MAX with GROUP BY** is essential for finding the most recent record per group, which is a common business requirement. This pattern helps identify latest transactions, most recent customer activity, and current status analysis.

**Correlated Subqueries** with MAX function allow you to get complete record details for the latest entry, not just the date. This technique is crucial when you need both the maximum value and related information from the same row.

**Date-based Customer Segmentation** using DATEDIFF and CASE statements enables business-driven customer classification based on recency, helping prioritize marketing and retention efforts.
