-- Батура Каріна, група ІТ-31

-- Завдання 1. 
SELECT 
    product_id, 
    COUNT(*) AS total_orders
FROM orders
GROUP BY product_id;


-- Завдання 2. 
SELECT 
    products.name AS product_name, 
    COUNT(orders.id) AS total_orders
FROM products
LEFT JOIN orders ON orders.product_id = products.id
GROUP BY products.id;


-- Завдання 3. 
SELECT 
    products.name AS product_name, 
    COUNT(orders.id) AS total_orders,
    SUM(orders.quantity) AS total_items_sold
FROM products
LEFT JOIN orders ON orders.product_id = products.id
GROUP BY products.id;


-- Завдання 4. 
SELECT 
    product_id, 
    quantity, 
    COUNT(*) AS records_count
FROM orders
GROUP BY product_id, quantity;


-- Завдання 5. 
SELECT 
    product_id, 
    order_date, 
    COUNT(*) AS total
FROM orders
GROUP BY product_id;