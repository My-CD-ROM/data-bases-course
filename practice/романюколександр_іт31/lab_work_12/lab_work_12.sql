SELECT name, price, stock_quantity
FROM products
ORDER BY price DESC

SELECT product_id, order_date, quantity, status
FROM orders
ORDER BY status, order_date

SELECT product_id, rate, comment, feedback_date
FROM feedbacks
ORDER BY feedback_date DESC LIMIT 3

SELECT DISTINCT status
FROM orders

SELECT product_id, order_date, quantity, status
FROM orders
WHERE quantity BETWEEN 2 AND 3

SELECT first_name, last_name, email
FROM customers
WHERE last_name LIKE "%а"

SELECT first_name, last_name, email
FROM customers
WHERE last_name LIKE "ДО%"

SELECT first_name, last_name, email
FROM customers
WHERE last_name LIKE "До%"

SELECT first_name, last_name, email
FROM customers
WHERE last_name LIKE "до%"