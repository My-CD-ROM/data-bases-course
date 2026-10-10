SELECT customer_id, COUNT(*) AS ordered_products
FROM orders
GROUP BY customer_id

SELECT customers.last_name AS last_name, COUNT(*) AS ordered_products
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id
GROUP BY customers.id

SELECT customers.last_name AS last_name, SUM(products.price) AS products_sum, COUNT(*) AS ordered_products
FROM orders
INNER JOIN customers ON orders.customer_id = customers.id
INNER JOIN products ON orders.product_id = products.id
GROUP BY customers.id

SELECT customer_id, order_date, status
FROM orders
GROUP BY orders.status, orders.order_date

SELECT order_date, quantity, COUNT(*)
FROM orders
GROUP BY order_date