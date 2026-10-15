PRAGMA foreign_keys = ON;

SELECT id, product_id, customer_id, order_date, quantity, status
FROM orders
ORDER BY order_date DESC;

SELECT id, status, order_date, quantity
FROM orders
ORDER BY status ASC, order_date DESC;

SELECT id, product_id, customer_id, order_date, quantity, status
FROM orders
ORDER BY order_date DESC
LIMIT 3;

SELECT DISTINCT category
FROM products
ORDER BY category ASC;

SELECT COUNT(DISTINCT category) AS unique_categories
FROM products;

SELECT id, order_date, status
FROM orders
WHERE status IN ('виконано', 'очікує', 'скасовано')
ORDER BY order_date DESC;

SELECT name
FROM products
WHERE name LIKE 'Ф%';

SELECT name
FROM products
WHERE name LIKE 'ф%';

SELECT COUNT(*) AS uppercase_matches
FROM products
WHERE name LIKE 'Ф%';

SELECT COUNT(*) AS lowercase_matches
FROM products
WHERE name LIKE 'ф%';