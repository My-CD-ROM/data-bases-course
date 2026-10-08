SELECT product_id, COUNT(*) AS orders_count
FROM orders
GROUP BY product_id
HAVING COUNT(*) > 1;

SELECT product_id, SUM(quantity) AS total_quantity
FROM orders
GROUP BY product_id
HAVING SUM(quantity) > 3;

SELECT product_id, AVG(quantity) AS average_quantity
FROM orders
WHERE status = 'виконано'
GROUP BY product_id
HAVING AVG(quantity) > 1.5;

SELECT product_id, COUNT(*) AS orders_count
FROM orders
WHERE COUNT(*) > 1
GROUP BY product_id;

SELECT products.id, products.name, COUNT(orders.id) AS orders_count
FROM products
LEFT JOIN orders ON orders.product_id = products.id
GROUP BY products.id, products.name
HAVING COUNT(orders.id) < 2;