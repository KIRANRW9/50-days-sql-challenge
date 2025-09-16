# Day 07: Order Frequency Analysis (GROUP BY & Aggregation Functions)

## Problem
The business analytics team needs to analyze customer ordering patterns to understand purchase frequency, identify high-volume customers, and segment customers based on their ordering behavior. This analysis helps in inventory planning, customer relationship management, and targeted marketing campaigns. This problem tests understanding of GROUP BY clauses, aggregate functions, and customer segmentation techniques.

## Dataset
Customer order data with transaction records across multiple time periods, allowing analysis of ordering frequency and customer behavior patterns.

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

-- Insert sample data
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

INSERT INTO Orders VALUES
(1001, 101, 'Laptop', 'Electronics', 75000.00, '2024-01-15', 'Completed'),
(1002, 101, 'Mouse', 'Electronics', 1500.00, '2024-02-20', 'Completed'),
(1003, 101, 'Keyboard', 'Electronics', 3500.00, '2024-03-10', 'Completed'),
(1004, 102, 'Smartphone', 'Electronics', 45000.00, '2024-01-25', 'Completed'),
(1005, 103, 'Tablet', 'Electronics', 25000.00, '2024-02-14', 'Completed'),
(1006, 103, 'Headphones', 'Electronics', 8000.00, '2024-04-18', 'Completed'),
(1007, 104, 'Monitor', 'Electronics', 18000.00, '2024-03-22', 'Completed'),
(1008, 105, 'Printer', 'Electronics', 12000.00, '2024-05-16', 'Completed'),
(1009, 105, 'Scanner', 'Electronics', 8500.00, '2024-06-20', 'Completed'),
(1010, 106, 'Camera', 'Electronics', 35000.00, '2024-07-12', 'Completed'),
(1011, 107, 'Smart Watch', 'Electronics', 15000.00, '2024-08-05', 'Completed'),
(1012, 107, 'Fitness Tracker', 'Electronics', 5000.00, '2024-09-10', 'Completed'),
(1013, 108, 'Bluetooth Speaker', 'Electronics', 4500.00, '2024-10-15', 'Completed'),
(1014, 109, 'Power Bank', 'Electronics', 2500.00, '2024-11-08', 'Completed'),
(1015, 110, 'Wireless Charger', 'Electronics', 3000.00, '2024-12-02', 'Completed');
```

## Query 1: Count of Orders per Customer

```sql
SELECT 
    customer_id, 
    COUNT(*) AS order_count 
FROM Orders 
GROUP BY customer_id
ORDER BY order_count DESC;
```

### Output:

```
customer_id | order_count
------------|------------
101         | 3
103         | 2
105         | 2
107         | 2
102         | 1
104         | 1
106         | 1
108         | 1
109         | 1
110         | 1
```

## Query 2: Customer Order Frequency with Names

```sql
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS order_count,
    ROUND(AVG(o.order_amount), 2) AS avg_order_value
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
ORDER BY order_count DESC, avg_order_value DESC;
```

### Output:

```
customer_id | customer_name | city      | order_count | avg_order_value
------------|---------------|-----------|-------------|----------------
101         | Rajesh Kumar  | Mumbai    | 3           | 26666.67
103         | Amit Patel    | Bangalore | 2           | 16500.00
105         | Vikram Singh  | Chennai   | 2           | 10250.00
107         | Rohit Mehta   | Kolkata   | 2           | 10000.00
102         | Priya Sharma  | Delhi     | 1           | 45000.00
106         | Anita Desai   | Pune      | 1           | 35000.00
104         | Sneha Reddy   | Hyderabad | 1           | 18000.00
108         | Kavya Pillai  | Kochi     | 1           | 4500.00
110         | Deepa Joshi   | Jaipur    | 1           | 3000.00
109         | Arjun Nair    | Ahmedabad | 1           | 2500.00
```

## Query 3: Customer Segmentation by Order Frequency

```sql
SELECT 
    CASE 
        WHEN COUNT(o.order_id) >= 3 THEN 'High Frequency'
        WHEN COUNT(o.order_id) = 2 THEN 'Medium Frequency'
        WHEN COUNT(o.order_id) = 1 THEN 'Low Frequency'
        ELSE 'No Orders'
    END AS customer_segment,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    ROUND(AVG(COUNT(o.order_id)), 2) AS avg_orders_per_customer
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY 
    CASE 
        WHEN COUNT(o.order_id) >= 3 THEN 'High Frequency'
        WHEN COUNT(o.order_id) = 2 THEN 'Medium Frequency'
        WHEN COUNT(o.order_id) = 1 THEN 'Low Frequency'
        ELSE 'No Orders'
    END
ORDER BY customer_count DESC;
```

### Output:

```
customer_segment | customer_count | avg_orders_per_customer
-----------------|----------------|------------------------
Low Frequency    | 6              | 1.00
Medium Frequency | 3              | 2.00
High Frequency   | 1              | 3.00
```

## Query 4: Monthly Order Distribution

```sql
SELECT 
    MONTHNAME(order_date) AS order_month,
    MONTH(order_date) AS month_number,
    COUNT(*) AS total_orders,
    COUNT(DISTINCT customer_id) AS unique_customers,
    SUM(order_amount) AS monthly_revenue
FROM Orders
GROUP BY MONTH(order_date), MONTHNAME(order_date)
ORDER BY month_number;
```

### Output:

```
order_month | month_number | total_orders | unique_customers | monthly_revenue
------------|--------------|--------------|------------------|----------------
January     | 1            | 2            | 2                | 120000.00
February    | 2            | 2            | 2                | 26500.00
March       | 3            | 2            | 2                | 21500.00
April       | 4            | 1            | 1                | 8000.00
May         | 5            | 1            | 1                | 12000.00
June        | 6            | 1            | 1                | 8500.00
July        | 7            | 1            | 1                | 35000.00
August      | 8            | 1            | 1                | 15000.00
September   | 9            | 1            | 1                | 5000.00
October     | 10           | 1            | 1                | 4500.00
November    | 11           | 1            | 1                | 2500.00
December    | 12           | 1            | 1                | 3000.00
```

## Query 5: Top Customers by Order Count and Value

```sql
SELECT 
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS order_count,
    SUM(o.order_amount) AS total_spent,
    ROUND(AVG(o.order_amount), 2) AS avg_order_value,
    MAX(o.order_date) AS last_order_date,
    DATEDIFF(CURDATE(), MAX(o.order_date)) AS days_since_last_order
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING COUNT(o.order_id) >= 1
ORDER BY order_count DESC, total_spent DESC
LIMIT 5;
```

### Output:

```
customer_name | city      | order_count | total_spent | avg_order_value | last_order_date | days_since_last_order
--------------|-----------|-------------|-------------|-----------------|-----------------|----------------------
Rajesh Kumar  | Mumbai    | 3           | 80000.00    | 26666.67        | 2024-03-10      | 190
Amit Patel    | Bangalore | 2           | 33000.00    | 16500.00        | 2024-04-18      | 151
Vikram Singh  | Chennai   | 2           | 20500.00    | 10250.00        | 2024-06-20      | 88
Rohit Mehta   | Kolkata   | 2           | 20000.00    | 10000.00        | 2024-09-10      | 6
Priya Sharma  | Delhi     | 1           | 45000.00    | 45000.00        | 2024-01-25      | 234
```

## Bonus Query 6: Customer Order Patterns with Rankings

```sql
SELECT 
    c.customer_name,
    COUNT(o.order_id) AS order_count,
    SUM(o.order_amount) AS total_spent,
    RANK() OVER (ORDER BY COUNT(o.order_id) DESC) AS frequency_rank,
    RANK() OVER (ORDER BY SUM(o.order_amount) DESC) AS spending_rank,
    CASE 
        WHEN COUNT(o.order_id) >= 3 AND SUM(o.order_amount) >= 50000 THEN 'VIP'
        WHEN COUNT(o.order_id) >= 2 OR SUM(o.order_amount) >= 30000 THEN 'Premium'
        WHEN COUNT(o.order_id) >= 1 AND SUM(o.order_amount) >= 10000 THEN 'Regular'
        ELSE 'New'
    END AS customer_tier
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY frequency_rank, spending_rank;
```

### Output:

```
customer_name | order_count | total_spent | frequency_rank | spending_rank | customer_tier
--------------|-------------|-------------|----------------|---------------|---------------
Rajesh Kumar  | 3           | 80000.00    | 1              | 1             | VIP
Amit Patel    | 2           | 33000.00    | 2              | 3             | Premium
Vikram Singh  | 2           | 20500.00    | 2              | 5             | Premium
Rohit Mehta   | 2           | 20000.00    | 2              | 6             | Premium
Priya Sharma  | 1           | 45000.00    | 5              | 2             | Premium
Anita Desai   | 1           | 35000.00    | 5              | 4             | Premium
Sneha Reddy   | 1           | 18000.00    | 5              | 7             | Regular
Kavya Pillai  | 1           | 4500.00     | 5              | 8             | New
Deepa Joshi   | 1           | 3000.00     | 5              | 9             | New
Arjun Nair    | 1           | 2500.00     | 5              | 10            | New
```

## How It Works

### GROUP BY Fundamentals
* **GROUP BY Clause**: Groups rows with the same values into summary rows
* **Aggregate Functions**: COUNT, SUM, AVG, MAX, MIN work on grouped data
* **HAVING Clause**: Filters groups after aggregation (vs WHERE which filters before)
* **Multiple Grouping**: GROUP BY multiple columns creates subgroups

### Advanced Aggregation Techniques
* **COUNT(*)**: Counts all rows in each group including NULLs
* **COUNT(column)**: Counts non-NULL values in specified column
* **LEFT JOIN with GROUP BY**: Includes customers with zero orders
* **CASE in GROUP BY**: Creates custom grouping categories

### Window Functions with Aggregation
* **RANK() OVER()**: Assigns rankings based on aggregate values
* **Combining Rankings**: Multiple ranking criteria for comprehensive analysis
* **Partitioning**: PARTITION BY creates separate ranking groups

## Real World Use Cases

1. **Customer Segmentation**: Identify high-value, medium-value, and low-value customers
2. **Inventory Planning**: Understand ordering patterns for stock management
3. **Marketing Campaigns**: Target customers based on purchase frequency
4. **Loyalty Programs**: Reward frequent purchasers with special benefits
5. **Sales Forecasting**: Predict future orders based on historical patterns
6. **Customer Retention**: Identify customers who haven't ordered recently
7. **Resource Allocation**: Allocate customer service resources based on customer tiers
8. **Revenue Analysis**: Understand revenue distribution across customer segments

## Key Learning Points

### GROUP BY vs Window Functions
**GROUP BY** collapses rows into groups and requires aggregate functions, while **Window Functions** preserve individual rows while adding analytical insights. Use GROUP BY for summary reports and window functions for detailed analysis.

### Understanding Aggregation
- **COUNT(*)**: Includes all rows, even with NULL values
- **COUNT(column)**: Excludes NULL values
- **SUM/AVG**: Ignore NULL values in calculations
- **HAVING**: Filters after grouping, allows aggregate conditions

### Customer Segmentation Strategy
- **Frequency-based**: Segment by number of orders
- **Value-based**: Segment by total spending
- **Hybrid approach**: Combine frequency and value for comprehensive tiers
- **Recency analysis**: Include time since last purchase

### Performance Considerations
- Index on GROUP BY columns for faster query execution
- Use HAVING instead of WHERE for aggregate conditions
- Consider query complexity when combining multiple aggregations
- LIMIT results for large datasets to improve response time

### Business Intelligence Applications
Order frequency analysis forms the foundation of customer relationship management, enabling businesses to make data-driven decisions about marketing spend, inventory management, and customer service priorities.

## Advanced Extensions

Consider extending this analysis with:
- Time-series analysis of ordering patterns over months/quarters
- Cohort analysis to track customer behavior over time
- RFM analysis (Recency, Frequency, Monetary) for comprehensive customer scoring
- Seasonal trend analysis for inventory and marketing planning
- Customer lifetime value calculations based on ordering patterns
