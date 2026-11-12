-- Практика 15. Індекси та EXPLAIN QUERY PLAN (варіант 2, інтернет-магазин одягу)
-- Тексти планів отримані в SQLite 3.45.1; у вашій версії формулювання можуть трохи відрізнятися.

-- Завдання 1. План ДО індексу
EXPLAIN QUERY PLAN SELECT * FROM orders WHERE product_id = 1;
-- SCAN orders

-- Завдання 2. Індекс на зовнішньому ключі
CREATE INDEX idx_orders_product ON orders(product_id);
EXPLAIN QUERY PLAN SELECT * FROM orders WHERE product_id = 1;
-- SEARCH orders USING INDEX idx_orders_product (product_id=?)

-- Завдання 3. Композитний індекс
-- до композитного індексу (є лише idx_orders_product):
EXPLAIN QUERY PLAN SELECT * FROM orders WHERE product_id = 1 AND client_id = 2;
-- SEARCH orders USING INDEX idx_orders_product (product_id=?)
CREATE INDEX idx_orders_product_client ON orders(product_id, client_id);
-- після:
EXPLAIN QUERY PLAN SELECT * FROM orders WHERE product_id = 1 AND client_id = 2;
-- SEARCH orders USING INDEX idx_orders_product_client (product_id=? AND client_id=?)

-- Завдання 4. Індекс і ORDER BY
-- до:
EXPLAIN QUERY PLAN SELECT * FROM orders ORDER BY order_date;
-- SCAN orders
-- USE TEMP B-TREE FOR ORDER BY
CREATE INDEX idx_orders_date ON orders(order_date);
-- після:
EXPLAIN QUERY PLAN SELECT * FROM orders ORDER BY order_date;
-- SCAN orders USING INDEX idx_orders_date

-- Завдання 5. DROP INDEX
DROP INDEX idx_orders_product;
EXPLAIN QUERY PLAN SELECT * FROM orders WHERE product_id = 1;
-- SEARCH orders USING INDEX idx_orders_product_client (product_id=?)
SELECT name, tbl_name FROM sqlite_master WHERE type = 'index';
-- sqlite_autoindex_clients_1 | clients
-- idx_orders_product_client  | orders
-- idx_orders_date            | orders
-- (idx_orders_product зі списку зник)
