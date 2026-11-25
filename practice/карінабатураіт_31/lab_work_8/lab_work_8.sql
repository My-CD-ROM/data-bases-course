-- Практика 8. Батура Каріна, ІТ-31 (Варіант 2)

-- Завдання 1.
SELECT COUNT(*) FROM orders;
SELECT COUNT(shipped_date) FROM orders;

-- Завдання 2. 
SELECT 
    SUM(quantity) AS total_quantity, 
    AVG(quantity) AS average_quantity 
FROM orders;

-- Завдання 3. 
SELECT 
    MIN(order_date) AS earliest_order, 
    MAX(order_date) AS latest_order 
FROM orders;

-- Завдання 4. 
SELECT 
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_items,
    AVG(quantity) AS avg_items,
    MAX(quantity) AS max_items
FROM orders;

-- Завдання 5. 
SELECT 
    COUNT(*) AS total_orders,
    SUM(quantity) AS total_items
FROM orders
WHERE product_id = 1;