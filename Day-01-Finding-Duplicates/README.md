# Day 01: Finding Duplicates

## Problem
Payment gateway timeouts are causing duplicate orders in our e-commerce system. Need to identify these duplicates.

## Dataset
Customer orders with some duplicate entries due to payment issues.

## SQL Solution

```sql
-- Create table and insert sample data
CREATE TABLE customer_orders (
    order_id INT PRIMARY KEY,
    customer_email VARCHAR(100),
    product_name VARCHAR(100),
    order_amount DECIMAL(10,2),
    order_date DATE,
    payment_status VARCHAR(20)
);

INSERT INTO customer_orders VALUES
(101, 'rohit.kumar@gmail.com', 'iPhone 15', 79999.00, '2024-03-01', 'Completed'),
(102, 'priya.nair@yahoo.com', 'Samsung TV', 45000.00, '2024-03-01', 'Completed'),
(103, 'rajesh.krishnan@hotmail.com', 'Dell Laptop', 65000.00, '2024-03-02', 'Completed'),
(104, 'rohit.kumar@gmail.com', 'iPhone 15', 79999.00, '2024-03-01', 'Pending'),
(105, 'rohit.kumar@gmail.com', 'iPhone 15', 79999.00, '2024-03-01', 'Failed'),
(106, 'sneha.iyer@gmail.com', 'Nike Shoes', 8999.00, '2024-03-02', 'Completed'),
(107, 'vikram.rao@outlook.com', 'Book Set', 2500.00, '2024-03-03', 'Completed'),
(108, 'priya.nair@yahoo.com', 'Samsung TV', 45000.00, '2024-03-01', 'Failed'),
(109, 'sneha.iyer@gmail.com', 'Nike Shoes', 8999.00, '2024-03-02', 'Pending'),
(110, 'arjun.pillai@gmail.com', 'Washing Machine', 35000.00, '2024-03-04', 'Completed');
```

### Query 1: Count Duplicates
```sql
SELECT 
    customer_email,
    product_name,
    COUNT(*) as duplicate_count
FROM customer_orders
GROUP BY customer_email, product_name
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;
```

**Output:**
```
customer_email           | product_name | duplicate_count
rohit.kumar@gmail.com    | iPhone 15    | 3
priya.nair@yahoo.com     | Samsung TV   | 2
sneha.iyer@gmail.com     | Nike Shoes   | 2
```

### Query 2: Show All Duplicate Records
```sql
SELECT * 
FROM customer_orders 
WHERE (customer_email, product_name) IN (
    SELECT customer_email, product_name
    FROM customer_orders
    GROUP BY customer_email, product_name
    HAVING COUNT(*) > 1
)
ORDER BY customer_email, product_name;
```

**Output:**
```
order_id | customer_email           | product_name | order_amount | order_date | payment_status
---------|--------------------------|--------------|--------------|------------|---------------
101      | rohit.kumar@gmail.com    | iPhone 15    | 79999.00     | 2024-03-01 | Completed
104      | rohit.kumar@gmail.com    | iPhone 15    | 79999.00     | 2024-03-01 | Pending
105      | rohit.kumar@gmail.com    | iPhone 15    | 79999.00     | 2024-03-01 | Failed
102      | priya.nair@yahoo.com     | Samsung TV   | 45000.00     | 2024-03-01 | Completed
108      | priya.nair@yahoo.com     | Samsung TV   | 45000.00     | 2024-03-01 | Failed
106      | sneha.iyer@gmail.com     | Nike Shoes   | 8999.00      | 2024-03-02 | Completed
109      | sneha.iyer@gmail.com     | Nike Shoes   | 8999.00      | 2024-03-02 | Pending
```

## How It Works
- **GROUP BY**: Groups records by customer email and product
- **COUNT(*)**: Counts how many records in each group
- **HAVING COUNT(*) > 1**: Only shows groups with more than 1 record (duplicates)
- **ORDER BY**: Sorts by highest duplicate count first

## Real World Use Cases
1. **E-commerce**: Find duplicate orders from payment timeouts
2. **CRM**: Identify customers with multiple accounts
3. **Banking**: Detect duplicate transactions
4. **Marketing**: Clean email lists before campaigns

## Key Learning
Using `GROUP BY` with `HAVING` is the standard way to find duplicates in any database. The pattern is always the same - group by the columns that should be unique, count the records, and filter for counts greater than 1.
