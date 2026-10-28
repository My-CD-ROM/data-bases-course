SELECT customer_id, COUNT(*) AS orders_count
FROM orders
GROUP BY customer_id
HAVING COUNT(*) >= 2

SELECT order_date, COUNT(*) AS orders_count
FROM orders
GROUP BY order_date
HAVING MIN(order_date) >= "2026-09-01" -- Замовлення, найраніша дата замовлення яких була 2026-09-01

SELECT name, size, category, SUM(price) AS sum
FROM products
WHERE size = 'M'
GROUP BY category
HAVING SUM(price) >= 700

SELECT name, size, category, SUM(price) AS sum
FROM products
WHERE SUM(price) >= 700
GROUP BY category
HAVING size = 'M'

-- Result: 1 rows returned in 5ms
-- EXECUTING ALL IN 'SQL 1*'
--
-- At line 1:
-- SELECT name, size, category, SUM(price) AS sum
-- FROM products
-- WHERE SUM(price) >= 700
-- GROUP BY category
-- HAVING size = 'M'
-- Result: misuse of aggregate: SUM()

SELECT customers.first_name AS customer_name, COUNT(orders.customer_id) AS order_count
FROM customers
LEFT JOIN orders ON orders.customer_id = customers.id
GROUP BY customers.id
HAVING COUNT(orders.customer_id) < 2