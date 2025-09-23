# Day 14: Advanced Customer Order Analysis (Subqueries & HAVING Clause)

## Problem
The business intelligence team needs to identify high-volume customers who have placed more than a specific threshold of orders. This analysis helps in recognizing power users, understanding customer engagement levels, and developing targeted retention strategies for the most active customers. This problem tests understanding of subqueries, HAVING clause with GROUP BY, and nested query structures.

## Dataset
Customer order data with multiple transactions per customer, allowing analysis of ordering patterns and identification of high-frequency customers across different time periods and product categories.

## SQL Solution

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(15),
    city VARCHAR(50),
    registration_date DATE,
    customer_status VARCHAR(20) DEFAULT 'Active'
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    category VARCHAR(50),
    order_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20) DEFAULT 'Completed'
);
```

## Query 1: Count Customers with More Than 5 Orders

```sql
SELECT COUNT(*) AS customer_count
FROM (
    SELECT customer_id
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) > 5
) AS subquery;
```

### Output:

```
customer_count
--------------
4
```

## Query 2: Identify High-Volume Customers (More Than 5 Orders)

```sql
SELECT 
    c.customer_id,
    c.customer_name,
    c.city,
    COUNT(o.order_id) AS total_orders,
    SUM(o.order_amount) AS total_spent,
    ROUND(AVG(o.order_amount), 2) AS avg_order_value,
    MIN(o.order_date) AS first_order,
    MAX(o.order_date) AS last_order
FROM Customers c
INNER JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city
HAVING COUNT(o.order_id) > 5
ORDER BY total_orders DESC, total_spent DESC;
```

### Output:

```
customer_id | customer_name | city      | total_orders | total_spent | avg_order_value | first_order | last_order
------------|---------------|-----------|--------------|-------------|-----------------|-------------|------------
101         | Rajesh Kumar  | Mumbai    | 8            | 450000.00   | 56250.00        | 2024-01-15  | 2024-08-22
102         | Priya Sharma  | Delhi     | 7            | 385000.00   | 55000.00        | 2024-01-20  | 2024-09-10
103         | Amit Patel    | Bangalore | 6            | 275000.00   | 45833.33        | 2024-02-05  | 2024-08-30
104         | Sneha Reddy   | Hyderabad | 6            | 320000.00   | 53333.33        | 2024-01-28  | 2024-09-15
```

## Query 3: Customer Order Distribution Analysis

```sql
SELECT 
    CASE 
        WHEN order_count > 10 THEN 'Super Active (10+)'
        WHEN order_count > 5 THEN 'High Volume (6-10)'
        WHEN order_count > 2 THEN 'Medium Volume (3-5)'
        WHEN order_count > 0 THEN 'Low Volume (1-2)'
        ELSE 'No Orders'
    END AS customer_category,
    COUNT(*) AS customer_count,
    ROUND(AVG(order_count), 2) AS avg_orders,
    ROUND(AVG(total_spent), 2) AS avg_spent
FROM (
    SELECT 
        c.customer_id,
        COUNT(o.order_id) AS order_count,
        COALESCE(SUM(o.order_amount), 0) AS total_spent
    FROM Customers c
    LEFT JOIN Orders o ON c.customer_id = o.customer_id
    GROUP BY c.customer_id
) AS customer_stats
GROUP BY 
    CASE 
        WHEN order_count > 10 THEN 'Super Active (10+)'
        WHEN order_count > 5 THEN 'High Volume (6-10)'
        WHEN order_count > 2 THEN 'Medium Volume (3-5)'
        WHEN order_count > 0 THEN 'Low Volume (1-2)'
        ELSE 'No Orders'
    END
ORDER BY avg_orders DESC;
```

### Output:

```
customer_category    | customer_count | avg_orders | avg_spent
--------------------|----------------|------------|----------
High Volume (6-10)  | 4              | 6.75       | 357500.00
Medium Volume (3-5) | 6              | 3.83       | 165000.00
Low Volume (1-2)    | 8              | 1.50       | 45000.00
No Orders           | 2              | 0.00       | 0.00
```

## Query 4: Monthly High-Volume Customer Analysis

```sql
SELECT 
    MONTHNAME(o.order_date) AS order_month,
    MONTH(o.order_date) AS month_number,
    COUNT(DISTINCT CASE WHEN monthly_orders.order_count > 5 THEN o.customer_id END) AS high_volume_customers,
    COUNT(DISTINCT o.customer_id) AS total_active_customers,
    ROUND(
        COUNT(DISTINCT CASE WHEN monthly_orders.order_count > 5 THEN o.customer_id END) * 100.0 / 
        COUNT(DISTINCT o.customer_id), 2
    ) AS high_volume_percentage
FROM Orders o
INNER JOIN (
    SELECT 
        customer_id, 
        MONTH(order_date) AS order_month,
        COUNT(*) AS order_count
    FROM Orders
    GROUP BY customer_id, MONTH(order_date)
) AS monthly_orders ON o.customer_id = monthly_orders.customer_id 
    AND MONTH(o.order_date) = monthly_orders.order_month
GROUP BY MONTH(o.order_date), MONTHNAME(o.order_date)
ORDER BY month_number;
```

### Output:

```
order_month | month_number | high_volume_customers | total_active_customers | high_volume_percentage
------------|--------------|----------------------|------------------------|----------------------
January     | 1            | 0                    | 8                      | 0.00
February    | 2            | 0                    | 6                      | 0.00
March       | 3            | 0                    | 7                      | 0.00
April       | 4            | 0                    | 5                      | 0.00
May         | 5            | 0                    | 4                      | 0.00
June        | 6            | 0                    | 6                      | 0.00
July        | 7            | 0                    | 5                      | 0.00
August      | 8            | 0                    | 7                      | 0.00
September   | 9            | 0                    | 4                      | 0.00
```

## Query 5: Comparative Analysis - High Volume vs Regular Customers

```sql
SELECT 
    'High Volume (5+ orders)' AS customer_type,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    SUM(order_stats.total_orders) AS total_orders,
    ROUND(AVG(order_stats.total_orders), 2) AS avg_orders_per_customer,
    SUM(order_stats.total_spent) AS total_revenue,
    ROUND(AVG(order_stats.total_spent), 2) AS avg_spent_per_customer
FROM Customers c
INNER JOIN (
    SELECT 
        customer_id,
        COUNT(*) AS total_orders,
        SUM(order_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) > 5
) AS order_stats ON c.customer_id = order_stats.customer_id

UNION ALL

SELECT 
    'Regular (1-5 orders)' AS customer_type,
    COUNT(DISTINCT c.customer_id) AS customer_count,
    SUM(order_stats.total_orders) AS total_orders,
    ROUND(AVG(order_stats.total_orders), 2) AS avg_orders_per_customer,
    SUM(order_stats.total_spent) AS total_revenue,
    ROUND(AVG(order_stats.total_spent), 2) AS avg_spent_per_customer
FROM Customers c
INNER JOIN (
    SELECT 
        customer_id,
        COUNT(*) AS total_orders,
        SUM(order_amount) AS total_spent
    FROM Orders
    GROUP BY customer_id
    HAVING COUNT(*) <= 5
) AS order_stats ON c.customer_id = order_stats.customer_id;
```

### Output:

```
customer_type            | customer_count | total_orders | avg_orders_per_customer | total_revenue | avg_spent_per_customer
-------------------------|----------------|--------------|-------------------------|---------------|----------------------
High Volume (5+ orders) | 4              | 27           | 6.75                    | 1430000.00    | 357500.00
Regular (1-5 orders)     | 14             | 53           | 3.79                    | 2310000.00    | 165000.00
```


## How It Works

### Subqueries and Nested Queries
* **Subqueries in FROM clause**: Creates temporary result sets for complex analysis
* **Subqueries in SELECT clause**: Calculates values based on grouped data
* **Subqueries with COUNT()**: Counts results from grouped inner queries
* **HAVING with subqueries**: Filters groups after aggregation

### Advanced HAVING Techniques
* **HAVING vs WHERE**: HAVING filters after GROUP BY, WHERE filters before
* **HAVING with COUNT()**: Filters groups based on row count
* **Complex HAVING conditions**: Multiple conditions with AND/OR operators
* **HAVING with aggregate functions**: SUM, AVG, MIN, MAX in filter conditions

### Customer Segmentation Strategies
* **Frequency-based segmentation**: Group customers by order count
* **Threshold analysis**: Identify customers above specific metrics
* **Comparative analysis**: Compare high-volume vs regular customers
* **Retention analysis**: Track customer activity over time

## Real World Use Cases

1. **VIP Customer Programs**: Identify customers for premium service tiers
2. **Retention Strategies**: Focus on high-value customers at risk of churning
3. **Marketing Budget Allocation**: Invest more in proven high-volume customers
4. **Customer Service Priority**: Prioritize support for frequent buyers
5. **Inventory Planning**: Stock products preferred by high-volume customers
6. **Loyalty Program Design**: Create rewards matching customer activity levels
7. **Sales Team Focus**: Direct account management to most valuable customers
8. **Churn Prevention**: Early warning system for valuable customer retention

## Key Learning Points

### Subquery Performance
**Subqueries** can be powerful but may impact performance on large datasets. Consider using JOINs or CTEs (Common Table Expressions) for better optimization when dealing with complex nested queries.

### Understanding HAVING Clause
- **HAVING** works with GROUP BY to filter aggregated results
- **WHERE** filters individual rows before grouping
- **HAVING** filters groups after aggregation
- Use **HAVING** with aggregate functions like COUNT, SUM, AVG

### Customer Analytics Best Practices
- **Threshold Definition**: Business should define what constitutes "high volume"
- **Time-based Analysis**: Consider seasonality and business cycles
- **Retention Metrics**: Track customer activity over time periods
- **Segmentation Value**: Different customer tiers need different strategies

### Business Intelligence Applications
High-volume customer analysis enables businesses to optimize their most valuable relationships, allocate resources effectively, and develop targeted strategies for customer retention and growth.

## Advanced Extensions

Consider extending this analysis with:
- Cohort analysis to track customer behavior changes over time
- Predictive modeling for customer lifetime value
- Seasonal pattern analysis for high-volume customers
- Product preference analysis for frequent buyers
- Cross-selling opportunity identification based on order patterns
- Customer journey mapping from first to most recent orders
