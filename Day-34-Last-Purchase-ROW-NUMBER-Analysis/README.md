# Day 34: Last Purchase Analysis (Most Recent Order per Customer)

## Problem
The customer service and marketing teams need to identify each customer's most recent purchase to understand current purchase behavior, track order status, identify engaged customers, and time follow-up communications. Finding the latest order for each customer enables post-purchase surveys, upselling opportunities, and quick issue resolution.

## Dataset
Customer order data with purchase dates and amounts to identify and analyze the most recent transaction for each customer.

## SQL Solution

```sql
-- Create Customers table
CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(100),
    email VARCHAR(100),
    city VARCHAR(50),
    registration_date DATE
);

-- Create Orders table
CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    product_name VARCHAR(100),
    total_amount DECIMAL(10,2),
    order_date DATE,
    status VARCHAR(20)
);
```

## Query 1: Get Last Purchase for Each Customer 

```sql
-- Show last purchase for each customer with order amount (using ROW_NUMBER)
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    customer_id, 
    order_id, 
    product_name,
    total_amount,
    order_date
FROM ranked_orders
WHERE rn = 1
ORDER BY customer_id;
```

### Output:

```
customer_id | order_id | product_name       | total_amount | order_date
------------|----------|-------------------|--------------|------------
101         | 1008     | Magic Keyboard    | 12500.00     | 2024-09-15
102         | 1010     | Microwave Oven    | 43002.00     | 2024-08-18
103         | 1017     | External SSD 1TB  | 12000.00     | 2024-08-30
104         | 1020     | Coffee Table      | 44002.00     | 2024-08-12
105         | 1040     | Protein Supplements| 8000.00     | 2024-10-15
106         | 1031     | Office Chair      | 18999.00     | 2024-07-08
107         | 1034     | Games Bundle      | 29002.00     | 2024-07-15
108         | 1035     | Kitchen Appliances| 45000.00     | 2024-05-10
109         | 1036     | Smart Watch       | 35000.00     | 2024-06-05
110         | 1037     | Office Desk       | 45000.00     | 2024-07-25
```

**How it works:**
1. **ROW_NUMBER()** assigns a sequential number to rows within each customer group
2. **PARTITION BY customer_id** creates separate windows per customer
3. **ORDER BY order_date DESC** orders by date descending (newest first)
4. **rn = 1** selects only the first row (most recent order) for each customer

## Query 2: Last Purchase with Customer Details 
```sql
-- Get last purchase with comprehensive customer and order information
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        status,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    c.email,
    c.city,
    ro.order_id,
    ro.product_name,
    ro.total_amount,
    ro.order_date,
    ro.status,
    DATEDIFF(CURDATE(), ro.order_date) AS days_since_last_purchase
FROM Customers c
JOIN ranked_orders ro ON c.customer_id = ro.customer_id
WHERE ro.rn = 1
ORDER BY ro.order_date DESC;
```

### Output:

```
customer_id | customer_name | email                    | city      | order_id | product_name        | total_amount | order_date | status    | days_since_last_purchase
------------|---------------|--------------------------|-----------|----------|---------------------|--------------|------------|-----------|------------------------
105         | Vikram Singh  | vikram.singh@email.com   | Chennai   | 1040     | Protein Supplements | 8000.00      | 2024-10-15 | Delivered | 2
101         | Rajesh Kumar  | rajesh.kumar@email.com   | Mumbai    | 1008     | Magic Keyboard      | 12500.00     | 2024-09-15 | Delivered | 32
103         | Amit Patel    | amit.patel@email.com     | Bangalore | 1017     | External SSD 1TB    | 12000.00     | 2024-08-30 | Delivered | 47
102         | Priya Sharma  | priya.sharma@email.com   | Delhi     | 1010     | Microwave Oven      | 43002.00     | 2024-08-18 | Delivered | 59
107         | Rohit Mehta   | rohit.mehta@email.com    | Kolkata   | 1034     | Games Bundle        | 29002.00     | 2024-07-15 | Delivered | 93
110         | Deepa Joshi   | deepa.joshi@email.com    | Jaipur    | 1037     | Office Desk         | 45000.00     | 2024-07-25 | Delivered | 83
104         | Sneha Reddy   | sneha.reddy@email.com    | Hyderabad | 1020     | Coffee Table        | 44002.00     | 2024-08-12 | Delivered | 65
106         | Anita Desai   | anita.desai@email.com    | Pune      | 1031     | Office Chair        | 18999.00     | 2024-07-08 | Delivered | 100
109         | Arjun Nair    | arjun.nair@email.com     | Ahmedabad | 1036     | Smart Watch         | 35000.00     | 2024-06-05 | Delivered | 138
108         | Kavya Pillai  | kavya.pillai@email.com   | Kochi     | 1035     | Kitchen Appliances  | 45000.00     | 2024-05-10 | Delivered | 184
```

**How it works:**
- Combines customer details with last order information
- Calculates days since last purchase for engagement tracking
- Sorted by order date to show most recent purchases first
- Shows order status for follow-up actions

## Query 3: Last Purchase by Product Category 

```sql
-- Analyze last purchases by product categories
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        CASE 
            WHEN product_name IN ('iPhone 15 Pro', 'MacBook Pro', 'iPad Air', 'AirPods Pro', 'Apple Watch', 'Magic Keyboard', 'HomePod') THEN 'Electronics'
            WHEN product_name IN ('Samsung TV 65"', 'Washing Machine', 'Refrigerator', 'Microwave Oven', 'Kitchen Appliances') THEN 'Appliances'
            WHEN product_name IN ('Dell XPS 15', '4K Monitor', 'Mechanical Keyboard', 'Gaming Mouse', 'Webcam HD', 'Desk Lamp', 'External SSD 1TB', 'USB Hub', 'Gaming Console', 'Controller', 'Games Bundle') THEN 'Computer Accessories'
            WHEN product_name IN ('Cricket Bat', 'Football', 'Tennis Racket', 'Golf Clubs', 'Gym Equipment', 'Bicycle', 'Running Shoes', 'Fitness Tracker', 'Protein Supplements') THEN 'Sports & Fitness'
            WHEN product_name IN ('Sofa Set', 'Dining Table', 'Coffee Table', 'Office Chair', 'Office Desk') THEN 'Furniture'
            WHEN product_name IN ('Book Collection', 'Reading Lamp') THEN 'Books & Accessories'
            WHEN product_name IN ('Smart Watch') THEN 'Wearables'
            ELSE 'Other'
        END AS category,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    category,
    COUNT(*) AS customers_with_category,
    SUM(total_amount) AS total_amount,
    ROUND(AVG(total_amount), 2) AS avg_order_amount,
    ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM ranked_orders WHERE rn = 1), 2) AS percentage
FROM ranked_orders
WHERE rn = 1
GROUP BY category
ORDER BY total_amount DESC;
```

### Output:

```
category              | customers_with_category | total_amount | avg_order_amount | percentage
---------------------|-------------------------|--------------|------------------|----------
Sports & Fitness     | 1                       | 8000.00      | 8000.00          | 10.00
Computer Accessories | 1                       | 12000.00     | 12000.00         | 10.00
Electronics          | 1                       | 12500.00     | 12500.00         | 10.00
Furniture            | 2                       | 62001.00     | 31000.50         | 20.00
Appliances           | 1                       | 43002.00     | 43002.00         | 10.00
Wearables            | 1                       | 35000.00     | 35000.00         | 10.00
Other                | 3                       | 125003.00    | 41667.67         | 30.00
```

**How it works:**
- Uses CASE to categorize products
- Applies ROW_NUMBER to get last purchase per customer
- Groups by category to analyze purchase patterns
- Shows which categories customers prefer for most recent orders

## Query 4: Last Purchase Status and Follow-up 

```sql
-- Track last purchase status for follow-up communications
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        status,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    ro.order_id,
    ro.product_name,
    ro.total_amount,
    ro.order_date,
    ro.status,
    DATEDIFF(CURDATE(), ro.order_date) AS days_since_order,
    CASE 
        WHEN ro.status = 'Delivered' AND DATEDIFF(CURDATE(), ro.order_date) <= 7 THEN 'Send Review Request'
        WHEN ro.status = 'Delivered' AND DATEDIFF(CURDATE(), ro.order_date) <= 30 THEN 'Check Satisfaction'
        WHEN ro.status = 'Delivered' AND DATEDIFF(CURDATE(), ro.order_date) <= 60 THEN 'Upsell Opportunity'
        WHEN ro.status = 'In Transit' THEN 'Waiting for Delivery'
        WHEN ro.status = 'Processing' THEN 'Order Processing'
        ELSE 'Re-engagement Campaign'
    END AS action_recommended
FROM Customers c
JOIN ranked_orders ro ON c.customer_id = ro.customer_id
WHERE ro.rn = 1
ORDER BY DATEDIFF(CURDATE(), ro.order_date) DESC;
```

### Output:

```
customer_id | customer_name | order_id | product_name        | total_amount | order_date | status    | days_since_order | action_recommended
------------|---------------|----------|---------------------|--------------|------------|-----------|------------------|---------------------
109         | Arjun Nair    | 1036     | Smart Watch         | 35000.00     | 2024-06-05 | Delivered | 138              | Re-engagement Campaign
108         | Kavya Pillai  | 1035     | Kitchen Appliances  | 45000.00     | 2024-05-10 | Delivered | 184              | Re-engagement Campaign
106         | Anita Desai   | 1031     | Office Chair        | 18999.00     | 2024-07-08 | Delivered | 100              | Re-engagement Campaign
104         | Sneha Reddy   | 1020     | Coffee Table        | 44002.00     | 2024-08-12 | Delivered | 65               | Upsell Opportunity
102         | Priya Sharma  | 1010     | Microwave Oven      | 43002.00     | 2024-08-18 | Delivered | 59               | Upsell Opportunity
107         | Rohit Mehta   | 1034     | Games Bundle        | 29002.00     | 2024-07-15 | Delivered | 93               | Re-engagement Campaign
103         | Amit Patel    | 1017     | External SSD 1TB    | 12000.00     | 2024-08-30 | Delivered | 47               | Check Satisfaction
101         | Rajesh Kumar  | 1008     | Magic Keyboard      | 12500.00     | 2024-09-15 | Delivered | 32               | Check Satisfaction
105         | Vikram Singh  | 1040     | Protein Supplements | 8000.00      | 2024-10-15 | Delivered | 2                | Send Review Request
```

**How it works:**
- Uses ROW_NUMBER to identify last purchase
- Calculates days since order to trigger actions
- Creates business rules for follow-up communications
- Enables automated customer engagement workflows

## Query 5: Last Purchase Comparison (Previous vs Current) 

```sql
-- Compare last two purchases for each customer to identify patterns
WITH ranked_orders AS (
    SELECT 
        customer_id, 
        order_id, 
        product_name,
        total_amount, 
        order_date,
        ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC) AS rn
    FROM Orders
)
SELECT 
    c.customer_id,
    c.customer_name,
    MAX(CASE WHEN ro.rn = 1 THEN ro.product_name END) AS last_product,
    MAX(CASE WHEN ro.rn = 1 THEN ro.total_amount END) AS last_amount,
    MAX(CASE WHEN ro.rn = 1 THEN ro.order_date END) AS last_date,
    MAX(CASE WHEN ro.rn = 2 THEN ro.product_name END) AS previous_product,
    MAX(CASE WHEN ro.rn = 2 THEN ro.total_amount END) AS previous_amount,
    MAX(CASE WHEN ro.rn = 2 THEN ro.order_date END) AS previous_date,
    CASE 
        WHEN MAX(CASE WHEN ro.rn = 1 THEN ro.total_amount END) > MAX(CASE WHEN ro.rn = 2 THEN ro.total_amount END) THEN 'Increasing Spend'
        WHEN MAX(CASE WHEN ro.rn = 1 THEN ro.total_amount END) < MAX(CASE WHEN ro.rn = 2 THEN ro.total_amount END) THEN 'Decreasing Spend'
        ELSE 'Similar Spend'
    END AS spending_trend,
    COUNT(*) AS total_orders
FROM Customers c
LEFT JOIN ranked_orders ro ON c.customer_id = ro.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(*) >= 2
ORDER BY c.customer_id;
```

### Output:

```
customer_id | customer_name | last_product        | last_amount | last_date  | previous_product    | previous_amount | previous_date | spending_trend   | total_orders
------------|---------------|---------------------|--------------|------------|---------------------|-----------------|---------------|------------------|-------------
101         | Rajesh Kumar  | Magic Keyboard      | 12500.00     | 2024-09-15 | HomePod             | 32000.00        | 2024-10-20    | Decreasing Spend | 7
102         | Priya Sharma  | Microwave Oven      | 43002.00     | 2024-08-18 | Refrigerator        | 65999.00        | 2024-04-20    | Decreasing Spend | 4
103         | Amit Patel    | External SSD 1TB    | 12000.00     | 2024-08-30 | Desk Lamp           | 5000.00         | 2024-07-30    | Increasing Spend | 8
104         | Sneha Reddy   | Coffee Table        | 44002.00     | 2024-08-12 | Dining Table        | 45999.00        | 2024-04-10    | Similar Spend    | 3
105         | Vikram Singh  | Protein Supplements | 8000.00      | 2024-10-15 | Fitness Tracker     | 12000.00        | 2024-08-10    | Decreasing Spend | 9
106         | Anita Desai   | Office Chair        | 18999.00     | 2024-07-08 | Reading Lamp        | 4999.00         | 2024-05-25    | Increasing Spend | 3
107         | Rohit Mehta   | Games Bundle        | 29002.00     | 2024-07-15 | Controller          | 5999.00         | 2024-06-20    | Increasing Spend | 3
```

**How it works:**
- Uses ROW_NUMBER to get both last (rn=1) and previous (rn=2) orders
- Uses CASE and MAX to pivot data into columns
- Calculates spending trends
- Identifies upsell/downsell opportunities

## How It Works

### Key Concepts

**ROW_NUMBER() Function**
```sql
ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_date DESC)
```
- Assigns unique sequential numbers to rows
- PARTITION BY creates separate sequences per customer
- ORDER BY DESC puts newest orders first
- First row gets rn = 1 (the most recent order)

**PARTITION BY customer_id**
```sql
PARTITION BY customer_id
```
- Creates separate window for each customer
- ROW_NUMBER resets to 1 for each new customer
- Prevents mixing data across customers

**Finding the Latest**
```sql
WHERE rn = 1
```
- Filters to only the first-ranked row (most recent)
- Simple and efficient way to get latest record per group

### ROW_NUMBER vs Other Functions
- **ROW_NUMBER()**: Always unique (1,2,3,4...)
- **RANK()**: Has gaps with ties (1,2,2,4)
- **DENSE_RANK()**: No gaps with ties (1,2,2,3)
- **MAX(order_date)**: Gets max date but loses other columns

## Real World Use Cases

1. **Customer Service**: Get last order to assist with inquiries
2. **Post-Purchase Follow-up**: Send reviews after delivery
3. **Upsell/Cross-sell**: Target based on product purchased
4. **Order Status Tracking**: Verify delivery status
5. **Churn Prevention**: Identify inactive customers
6. **Inventory Management**: Understand recent purchasing patterns
7. **Campaign Timing**: Schedule follow-ups strategically
8. **Customer Support**: Quick access to last purchase details

## Key Learning Points

### ROW_NUMBER vs GROUP BY
**ROW_NUMBER approach:**
- Keeps all columns from original table
- Easy to access other order details
- More flexible for complex queries

**GROUP BY approach:**
- Better performance for simple aggregations
- Good when you only need MAX(date)
- Simpler for basic queries

### When to Use ROW_NUMBER
- Need multiple columns from the "latest" record
- Want to access previous records too (rn=2, rn=3)
- Need ranking with other metrics
- Complex multi-step analysis
