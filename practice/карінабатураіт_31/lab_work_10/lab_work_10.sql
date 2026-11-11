-- ПРАКТИЧНА РОБОТА № 10
-- Батура Каріна, група ІТ-31
-- Завдання 1.
SELECT 
    product_id, 
    COUNT(*) AS order_count
FROM orders
GROUP BY product_id
Having COUNT(*) > 1;


-- Завдання 2. 
SELECT 
    product_id, 
    SUM(quantity) AS total_quantity
FROM orders
GROUP BY product_id
HAVING SUM(quantity) > 1;


-- Завдання 3. 
SELECT 
    product_id, 
    COUNT(*) AS orders_count
FROM orders
WHERE order_date >= '2026-10-01'
GROUP BY product_id
HAVING COUNT(*) > 1;


-- Завдання 4. 
SELECT 
    product_id, 
    COUNT(*) 
FROM orders 
WHERE COUNT(*) > 1 
GROUP BY product_id;


-- Завдання 5. 
SELECT 
    products.name, 
    COUNT(orders.id) AS orders_count
FROM products
LEFT JOIN orders ON orders.product_id = products.id
GROUP BY products.id
HAVING COUNT(orders.id) < 1;