--Query 1: Count Duplicates
SELECT 
    customer_email,
    product_name,
    COUNT(*) as duplicate_count
FROM customer_orders
GROUP BY customer_email, product_name
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;


--Query 2: Show All Duplicate Records
SELECT * 
FROM customer_orders 
WHERE (customer_email, product_name) IN (
    SELECT customer_email, product_name
    FROM customer_orders
    GROUP BY customer_email, product_name
    HAVING COUNT(*) > 1
)
ORDER BY customer_email, product_name;
