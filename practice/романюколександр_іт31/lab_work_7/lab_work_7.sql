SELECT products.name AS product, orders.status AS status
FROM products
INNER JOIN orders ON orders.product_id = products.id
WHERE orders.status = "доставлено" OR orders.status = "прийнято"

SELECT products.name AS product, orders.status AS status, customers.last_name AS customer
FROM products
INNER JOIN orders ON orders.product_id = products.id
JOIN customers ON orders.customer_id = customers.id
WHERE orders.status = "доставлено" OR orders.status = "прийнято"

SELECT products.name AS product, orders.status AS status
FROM products
LEFT JOIN orders ON orders.product_id = products.id
WHERE orders.product_id IS NULL

SELECT COUNT(*) FROM customers, products

SELECT COUNT(*) FROM customers
SELECT COUNT(*) FROM products