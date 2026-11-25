-- Батури Каріни ІТ-31
-- ЗАВДАННЯ 1. EXPLAIN QUERY PLAN до індексу
EXPLAIN QUERY PLAN 
SELECT * FROM orders WHERE customer_id = 5;
-- Очікуваний план до індексу: SCAN orders

-- ЗАВДАННЯ 2. CREATE INDEX на зовнішньому ключі
CREATE INDEX idx_orders_customer ON orders(customer_id);
EXPLAIN QUERY PLAN 
SELECT * FROM orders WHERE customer_id = 5;
-- Очікуваний план після індексу: SEARCH orders USING INDEX idx_orders_customer (customer_id=?)

-- ЗАВДАННЯ 3. Композитний індекс
-- План до композитного індексу (коли є лише індекс на customer_id)
EXPLAIN QUERY PLAN 
SELECT * FROM orders WHERE customer_id = 5 AND quantity = 2;
-- Очікуваний план: SEARCH orders USING INDEX idx_orders_customer (customer_id=?) 
-- Створюємо композитний індекс на дві колонки
CREATE INDEX idx_orders_customer_quantity ON orders(customer_id, quantity);

-- План після створення композитного індексу
EXPLAIN QUERY PLAN 
SELECT * FROM orders WHERE customer_id = 5 AND quantity = 2;
-- Очікуваний план: SEARCH orders USING INDEX idx_orders_customer_quantity (customer_id=? AND quantity=?)
-- ЗАВДАННЯ 4. Індекс і ORDER BY

EXPLAIN QUERY PLAN 
SELECT * FROM orders ORDER BY order_date DESC;
-- SCAN orders та USE TEMP B-TREE FOR ORDER BY

-- Створюємо індекс на дату замовлення
CREATE INDEX idx_orders_date ON orders(order_date);

-- План після створення індексу за датою
EXPLAIN QUERY PLAN 
SELECT * FROM orders ORDER BY order_date DESC;
-- Очікуваний план: SCAN orders USING INDEX idx_orders_date 
-- (рядок USE TEMP B-TREE зник, бо індекс вже впорядкований)

-- ЗАВДАННЯ 5. DROP INDEX і повторна перевірка
-- Видаляємо один зі створених індексів
DROP INDEX idx_orders_date;
-- Перевіряємо план для сортування (він має повернутися до TEMP B-TREE або SCAN)
EXPLAIN QUERY PLAN 
SELECT * FROM orders ORDER BY order_date DESC;
-- Перевіряємо список індексів
SELECT name, tbl_name FROM sqlite_master WHERE type = 'index';