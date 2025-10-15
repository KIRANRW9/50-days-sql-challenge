-- Query 1 - Detect Top 10% Purchases per Customer
SELECT customer_id, amount
FROM purchases
WHERE amount >= (
    SELECT PERCENTILE_CONT(0.9) WITHIN GROUP (ORDER BY amount)
    FROM purchases p2
    WHERE p2.customer_id = purchases.customer_id
);

-- Query 2 - Find Customers Who Never Made a Purchase
SELECT c.customer_id, c.customer_name
FROM customers c
LEFT JOIN purchases p ON c.customer_id = p.customer_id
WHERE p.customer_id IS NULL;

-- Query 3 - Get Average Purchase Amount per Customer
SELECT customer_id, AVG(amount) AS avg_purchase
FROM purchases
GROUP BY customer_id
ORDER BY avg_purchase DESC;

-- Query 4 - List Top 5 Products by Total Sales
SELECT product_id, SUM(amount) AS total_sales
FROM purchases
GROUP BY product_id
ORDER BY total_sales DESC
LIMIT 5;

-- Query 5 - Find Customers Who Spent Above the Overall Average
SELECT customer_id, SUM(amount) AS total_spent
FROM purchases
GROUP BY customer_id
HAVING SUM(amount) > (
    SELECT AVG(total) 
    FROM (
        SELECT SUM(amount) AS total
        FROM purchases
        GROUP BY customer_id
    ) AS avg_table
);

