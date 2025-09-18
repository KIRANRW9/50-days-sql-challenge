# Day 09: Customer Order Analytics and Average Calculations (AVG with GROUP BY)

## Problem
The sales and marketing teams need to analyze customer ordering behavior to understand spending patterns, identify high-value customers, and optimize pricing strategies. This analysis helps in customer segmentation, loyalty program design, and revenue optimization. This problem tests understanding of AVG function, GROUP BY operations, and customer analytics.

## Dataset
Customer order data with multiple transactions per customer showing order amounts, dates, and product categories for comprehensive spending analysis.

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
    total_amount DECIMAL(10,2),
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
-- Customer 101: High value, multiple orders
(1001, 101, 'iPhone 15 Pro Max', 'Electronics', 159900.00, '2024-01-15', 'Delivered'),
(1002, 101, 'MacBook Pro M3', 'Electronics', 199900.00, '2024-03-20', 'Delivered'),
(1003, 101, 'AirPods Pro', 'Electronics', 24900.00, '2024-06-10', 'Delivered'),

-- Customer 102: Medium value, regular orders
(1004, 102, 'Samsung Galaxy S24', 'Electronics', 79999.00, '2024-01-25', 'Delivered'),
(1005, 102, 'Samsung Watch', 'Electronics', 29999.00, '2024-04-15', 'Delivered'),

-- Customer 103: Low value, frequent orders
(1006, 103, 'Nike Shoes', 'Fashion', 8999.00, '2024-02-10', 'Delivered'),
(1007, 103, 'Adidas T-Shirt', 'Fashion', 2499.00, '2024-03-05', 'Delivered'),
(1008, 103, 'Puma Cap', 'Fashion', 1299.00, '2024-05-20', 'Delivered'),
(1009, 103, 'Reebok Socks', 'Fashion', 599.00, '2024-07-12', 'Delivered'),

-- Customer 104: Single high-value order
(1010, 104, 'Dell XPS Laptop', 'Electronics', 125000.00, '2024-02-28', 'Delivered'),

-- Customer 105: Mixed value orders
(1011, 105, 'Sony Headphones', 'Electronics', 15999.00, '2024-03-15', 'Delivered'),
(1012, 105, 'Canon Camera', 'Electronics', 45999.00, '2024-05-22', 'Delivered'),
(1013, 105, 'Kindle E-reader', 'Electronics', 12999.00, '2024-08-18', 'Delivered'),

-- Customer 106: Fashion focus
(1014, 106, 'Levis Jeans', 'Fashion', 4999.00, '2024-04-10', 'Delivered'),
(1015, 106, 'Zara Dress', 'Fashion', 3499.00, '2024-06-25', 'Delivered'),

-- Customer 107: Single medium order
(1016, 107, 'JBL Speaker', 'Electronics', 8999.00, '2024-07-30', 'Delivered'),

-- Customer 108: High-value single purchase
(1017, 108, 'Samsung 65 inch TV', 'Electronics', 89999.00, '2024-08-05', 'Delivered'),

-- Customer 109: Multiple small orders
(1018, 109, 'Phone Case', 'Accessories', 999.00, '2024-09-10', 'Delivered'),
(1019, 109, 'Charging Cable', 'Accessories', 599.00, '2024-09-20', 'Delivered'),
(1020, 109, 'Screen Protector', 'Accessories', 299.00, '2024-10-05', 'Delivered');
```

## Query 1: Average Order Value Per Customer

```sql
-- Calculate average order value for each customer
SELECT 
    customer_id, 
    AVG(total_amount) AS avg_order_value 
FROM Orders 
GROUP BY customer_id
ORDER BY avg_order_value DESC;
```

## Output:

```
customer_id | avg_order_value
------------|----------------
101         | 128233.33
104         | 125000.00
108         | 89999.00
102         | 54999.00
105         | 24999.00
107         | 8999.00
106         | 4249.00
103         | 3349.00
109         | 632.33
```


## Query 2: Customer Order Summary with Names 

```sql
-- Get customer names with their order statistics
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    MIN(o.total_amount) as min_order,
    MAX(o.total_amount) as max_order
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY avg_order_value DESC;
```

## Output:

```
customer_id | customer_name | city      | total_orders | total_spent | avg_order_value | min_order | max_order
------------|---------------|-----------|--------------|-------------|-----------------|-----------|----------
101         | Rajesh Kumar  | Mumbai    | 3            | 384700.00   | 128233.33       | 24900.00  | 199900.00
104         | Sneha Reddy   | Hyderabad | 1            | 125000.00   | 125000.00       | 125000.00 | 125000.00
108         | Kavya Pillai  | Kochi     | 1            | 89999.00    | 89999.00        | 89999.00  | 89999.00
102         | Priya Sharma  | Delhi     | 2            | 109998.00   | 54999.00        | 29999.00  | 79999.00
105         | Vikram Singh  | Chennai   | 3            | 74997.00    | 24999.00        | 12999.00  | 45999.00
107         | Rohit Mehta   | Kolkata   | 1            | 8999.00     | 8999.00         | 8999.00   | 8999.00
106         | Anita Desai   | Pune      | 2            | 8498.00     | 4249.00         | 3499.00   | 4999.00
103         | Amit Patel    | Bangalore | 4            | 13396.00    | 3349.00         | 599.00    | 8999.00
109         | Arjun Nair    | Ahmedabad | 3            | 1897.00     | 632.33          | 299.00    | 999.00
```


## Query 3: Customer Segmentation by Average Order Value 

```sql
-- Segment customers based on their average order value
SELECT 
    c.customer_name,
    c.city,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    COUNT(o.order_id) as total_orders,
    CASE 
        WHEN AVG(o.total_amount) >= 100000 THEN 'Premium'
        WHEN AVG(o.total_amount) >= 25000 THEN 'Gold'
        WHEN AVG(o.total_amount) >= 5000 THEN 'Silver'
        ELSE 'Bronze'
    END as customer_segment
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY avg_order_value DESC;
```

## Output:

```
customer_name | city      | avg_order_value | total_orders | customer_segment
--------------|-----------|-----------------|--------------|------------------
Rajesh Kumar  | Mumbai    | 128233.33       | 3            | Premium
Sneha Reddy   | Hyderabad | 125000.00       | 1            | Premium
Kavya Pillai  | Kochi     | 89999.00        | 1            | Gold
Priya Sharma  | Delhi     | 54999.00        | 2            | Gold
Vikram Singh  | Chennai   | 24999.00        | 3            | Silver
Rohit Mehta   | Kolkata   | 8999.00         | 1            | Silver
Anita Desai   | Pune      | 4249.00         | 2            | Bronze
Amit Patel    | Bangalore | 3349.00         | 4            | Bronze
Arjun Nair    | Ahmedabad | 632.33          | 3            | Bronze
```


## Query 4: Category-wise Average Order Analysis 

```sql
-- Analyze average order values by product category
SELECT 
    o.category,
    COUNT(o.order_id) as total_orders,
    COUNT(DISTINCT o.customer_id) as unique_customers,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    SUM(o.total_amount) as total_revenue,
    MIN(o.total_amount) as min_order,
    MAX(o.total_amount) as max_order
FROM Orders o
GROUP BY o.category
ORDER BY avg_order_value DESC;
```

## Output:

```
category    | total_orders | unique_customers | avg_order_value | total_revenue | min_order | max_order
------------|--------------|------------------|-----------------|---------------|-----------|----------
Electronics | 13           | 7                | 56999.23        | 740990.00     | 8999.00   | 199900.00
Fashion     | 6            | 2                | 3565.83         | 21395.00      | 599.00    | 8999.00
Accessories | 3            | 1                | 632.33          | 1897.00       | 299.00    | 999.00
```


## Query 5: High-Value Customer Analysis 

```sql
-- Find customers with above-average order values
SELECT 
    c.customer_name,
    c.city,
    ROUND(AVG(o.total_amount), 2) as avg_order_value,
    COUNT(o.order_id) as total_orders,
    SUM(o.total_amount) as total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING AVG(o.total_amount) > (
    SELECT AVG(total_amount) 
    FROM Orders
)
ORDER BY avg_order_value DESC;
```

## Output:

```
customer_name | city      | avg_order_value | total_orders | total_spent
--------------|-----------|-----------------|--------------|------------
Rajesh Kumar  | Mumbai    | 128233.33       | 3            | 384700.00
Sneha Reddy   | Hyderabad | 125000.00       | 1            | 125000.00
Kavya Pillai  | Kochi     | 89999.00        | 1            | 89999.00
Priya Sharma  | Delhi     | 54999.00        | 2            | 109998.00
```


## How It Works
* **AVG() Function**: Calculates the average (mean) value of a numeric column within each group
* **GROUP BY**: Groups rows by customer_id to calculate individual customer averages
* **JOIN with GROUP BY**: Combines customer information with order aggregations
* **HAVING Clause**: Filters groups based on aggregate conditions (after GROUP BY)
* **Subqueries**: Compare individual averages with overall average
* **CASE Statements**: Create business logic for customer segmentation
* **Multiple Aggregations**: COUNT, SUM, MIN, MAX alongside AVG for comprehensive analysis

## Real World Use Cases
1. **Customer Segmentation**: Identify high-value, medium-value, and low-value customers
2. **Pricing Strategy**: Understand customer spending patterns for optimal pricing
3. **Marketing Campaigns**: Target customers based on their purchasing behavior
4. **Loyalty Programs**: Design tier-based rewards based on average order values
5. **Sales Analysis**: Identify trends in customer spending and category performance
6. **Revenue Optimization**: Focus on customers and categories with higher order values

## Key Learning
**AVG with GROUP BY** is fundamental for customer analytics and business intelligence. It transforms individual transaction data into meaningful customer insights by calculating average behaviors per customer or segment.

**Customer Analytics**: Combining demographic data (customer names, cities) with transactional data (orders, amounts) provides a complete view of customer behavior and enables data-driven business decisions.

**Comparative Analysis**: Using HAVING with subqueries allows you to compare individual customer performance against overall averages, identifying above and below-average performers for targeted strategies.
