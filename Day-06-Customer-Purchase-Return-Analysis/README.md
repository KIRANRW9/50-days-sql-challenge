# Day 06: Customer Purchase and Return Analysis (Subqueries & NOT IN)

## Problem
The customer service team needs to analyze customer purchase behavior and identify loyal customers who make purchases but never return products. This analysis helps in understanding customer satisfaction, product quality, and identifying customers for loyalty programs. This problem tests understanding of subqueries, NOT IN clause, and customer behavior analysis.

## Dataset
Customer purchase data with order information and return records across multiple transactions and product categories.

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

-- Create Returns table
CREATE TABLE Returns (
    return_id INT PRIMARY KEY,
    order_id INT,
    customer_id INT,
    return_reason VARCHAR(100),
    return_amount DECIMAL(10,2),
    return_date DATE,
    status VARCHAR(20)
);
```

## Query 1: Customers Who Made Purchases But Never Returned Products

```sql
SELECT DISTINCT c.customer_id, c.customer_name, c.email, c.city
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id NOT IN (
    SELECT customer_id 
    FROM Returns 
    WHERE customer_id IS NOT NULL
);
```

### Output:

```
customer_id | customer_name | email                      | city
------------|---------------|----------------------------|----------
101         | Rajesh Kumar  | rajesh.kumar@email.com     | Mumbai
103         | Amit Patel    | amit.patel@email.com       | Bangalore
105         | Vikram Singh  | vikram.singh@email.com     | Chennai
107         | Rohit Mehta   | rohit.mehta@email.com      | Kolkata
109         | Arjun Nair    | arjun.nair@email.com       | Ahmedabad
```

## Query 2: Purchase Summary for Non-Returning Customers

```sql
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as total_spent,
    AVG(o.order_amount) as avg_order_value,
    MIN(o.order_date) as first_purchase,
    MAX(o.order_date) as last_purchase
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id NOT IN (
    SELECT customer_id 
    FROM Returns 
    WHERE customer_id IS NOT NULL
)
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;
```

### Output:

```
customer_id | customer_name | total_orders | total_spent | avg_order_value | first_purchase | last_purchase
------------|---------------|--------------|-------------|-----------------|----------------|---------------
101         | Rajesh Kumar  | 2            | 219800.00   | 109900.00       | 2024-01-15     | 2024-06-15
103         | Amit Patel    | 2            | 157800.00   | 78900.00        | 2024-02-10     | 2024-07-08
105         | Vikram Singh  | 2            | 68998.00    | 34499.00        | 2024-03-05     | 2024-08-12
107         | Rohit Mehta   | 2            | 18998.00    | 9499.00         | 2024-04-18     | 2024-09-05
109         | Arjun Nair    | 1            | 45999.00    | 45999.00        | 2024-05-10     | 2024-05-10
```

## Query 3: Category-wise Analysis for Loyal Customers

```sql
SELECT 
    o.category,
    COUNT(DISTINCT c.customer_id) as loyal_customers,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as category_revenue,
    AVG(o.order_amount) as avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id NOT IN (
    SELECT customer_id 
    FROM Returns 
    WHERE customer_id IS NOT NULL
)
GROUP BY o.category
ORDER BY category_revenue DESC;
```

### Output:

```
category    | loyal_customers | total_orders | category_revenue | avg_order_value
------------|-----------------|--------------|------------------|----------------
Electronics | 5               | 8            | 462596.00        | 57824.50
Fashion     | 1               | 1            | 12999.00         | 12999.00
```

## Query 4: Customers Who Made Returns vs Non-Returning Customers

```sql
SELECT 
    'Returning Customers' as customer_type,
    COUNT(DISTINCT c.customer_id) as customer_count,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as total_revenue,
    AVG(o.order_amount) as avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id IN (
    SELECT customer_id FROM Returns
)
UNION ALL
SELECT 
    'Non-Returning Customers' as customer_type,
    COUNT(DISTINCT c.customer_id) as customer_count,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as total_revenue,
    AVG(o.order_amount) as avg_order_value
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id NOT IN (
    SELECT customer_id FROM Returns WHERE customer_id IS NOT NULL
);
```

### Output:

```
customer_type           | customer_count | total_orders | total_revenue | avg_order_value
------------------------|----------------|--------------|---------------|----------------
Returning Customers     | 5              | 5            | 172496.00     | 34499.20
Non-Returning Customers | 5              | 9            | 511595.00     | 56843.89
```

## Query 5: Loyalty Score Analysis

```sql
SELECT 
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) as total_orders,
    SUM(o.order_amount) as total_spent,
    DATEDIFF(CURDATE(), MIN(o.order_date)) as days_as_customer,
    ROUND(SUM(o.order_amount) / COUNT(o.order_id), 2) as avg_order_value,
    CASE 
        WHEN SUM(o.order_amount) > 150000 THEN 'Premium'
        WHEN SUM(o.order_amount) > 50000 THEN 'Gold'
        WHEN SUM(o.order_amount) > 20000 THEN 'Silver'
        ELSE 'Bronze'
    END as loyalty_tier
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
WHERE c.customer_id NOT IN (
    SELECT customer_id 
    FROM Returns 
    WHERE customer_id IS NOT NULL
)
GROUP BY c.customer_id, c.customer_name
ORDER BY total_spent DESC;
```

### Output:

```
customer_id | customer_name | total_orders | total_spent | days_as_customer | avg_order_value | loyalty_tier
------------|---------------|--------------|-------------|------------------|-----------------|-------------
101         | Rajesh Kumar  | 2            | 219800.00   | 243              | 109900.00       | Premium
103         | Amit Patel    | 2            | 157800.00   | 217              | 78900.00        | Premium
105         | Vikram Singh  | 2            | 68998.00    | 194              | 34499.00        | Gold
107         | Rohit Mehta   | 2            | 18998.00    | 131              | 9499.00         | Bronze
109         | Arjun Nair    | 1            | 45999.00    | 128              | 45999.00        | Silver
```

## How It Works

### Subqueries Explained
* **NOT IN with Subqueries**: Excludes rows where the value exists in the subquery result set
* **IN with Subqueries**: Includes only rows where the value exists in the subquery result set
* **Correlated vs Non-Correlated**: Non-correlated subqueries execute once; correlated subqueries execute for each outer query row
* **NULL Handling**: NOT IN returns no results if subquery contains NULL values, hence the `WHERE customer_id IS NOT NULL` condition

### Advanced Aggregation Techniques
* **GROUP BY with Multiple Columns**: Groups data by customer for detailed analysis
* **Aggregate Functions**: COUNT, SUM, AVG, MIN, MAX for comprehensive statistics
* **UNION ALL**: Combines results from multiple queries for comparison analysis
* **CASE Statements**: Creates categorical data based on numerical ranges

### JOIN Operations
* **INNER JOIN**: Returns only matching records between tables
* **Table Aliases**: Simplifies query readability with shortened table names
* **Multiple JOINs**: Connecting three or more tables for complex analysis

## Real World Use Cases

1. **Customer Retention Analysis**: Identify customers with high satisfaction (no returns)
2. **Loyalty Program Targeting**: Focus rewards on customers who don't return products
3. **Product Quality Assessment**: Analyze which categories have fewer returns
4. **Revenue Optimization**: Understand spending patterns of satisfied customers
5. **Customer Segmentation**: Create tiers based on spending and return behavior
6. **Marketing Campaigns**: Target high-value, low-maintenance customers
7. **Inventory Management**: Focus on products preferred by loyal customers
8. **Customer Support**: Allocate resources based on return patterns

## Key Learning Points

### Subquery Best Practices
**NOT IN vs NOT EXISTS**: Use NOT EXISTS when dealing with potential NULL values for better performance and reliability. NOT IN can produce unexpected results with NULLs.

### Understanding Customer Behavior
- **Loyal Customers**: Higher average order values and longer customer relationships
- **Return Patterns**: Returning customers may indicate product issues or different buying patterns
- **Category Analysis**: Electronics dominates loyal customer purchases, indicating quality satisfaction

### Performance Considerations
- Subqueries can be resource-intensive on large datasets
- Consider using JOINs instead of subqueries for better performance when possible
- Index customer_id columns for faster subquery execution
- DISTINCT is necessary when JOINing to prevent duplicate customer records

### Business Intelligence Applications
These queries enable customer service teams to make data-driven decisions about loyalty programs, product quality improvements, and customer retention strategies. The analysis provides actionable insights for revenue growth and customer satisfaction enhancement.

## Advanced Extensions

Consider extending this analysis with:
- Time-based return analysis to identify seasonal patterns
- Product-specific return rates and reasons
- Customer lifetime value calculations for loyal customers
- Predictive modeling for customer churn based on return behavior
- Integration with customer service data for comprehensive satisfaction analysis
