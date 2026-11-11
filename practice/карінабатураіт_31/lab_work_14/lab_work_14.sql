-- Практична 14. Батури Каріни
-- Завдання 1. Атомарна пара INSERT + UPDATE
BEGIN;
INSERT INTO orders (id, product_id, customer_id, order_date, quantity) 
VALUES (101, 2, 1, '2026-06-10', 2);
UPDATE orders 
SET shipped_date = '2026-06-11' 
WHERE id = 101;
COMMIT;

SELECT * FROM orders WHERE id = 101;


-- Завдання 2. 
BEGIN;
INSERT INTO orders (id, product_id, customer_id, order_date, quantity) 
VALUES (102, 1, 3, '2026-06-11', 1);
ROLLBACK;

SELECT * FROM orders WHERE id = 102;


-- Завдання 3.
BEGIN;
INSERT INTO orders (id, product_id, customer_id, order_date, quantity) 
VALUES (103, 3, 2, '2026-06-12', 5);
SELECT * FROM orders WHERE id = 103;
ROLLBACK;


-- Завдання 4. Свідома помилка всередині транзакції
BEGIN;
INSERT INTO orders (id, product_id, customer_id, order_date, quantity) 
VALUES (104, 2, 1, '2026-06-13', 1);
-- Помилка UNIQUE (дублювання існуючого або конфлікт у customers.email)
INSERT INTO customers (id, full_name, email, phone) 
VALUES (1, 'Дубль Тест', 'test@test.com', '0500000000'); 
SELECT * FROM orders WHERE id = 104;
ROLLBACK;


-- Завдання 5. Забутий ROLLBACK
BEGIN;
INSERT INTO orders (id, product_id, customer_id, order_date, quantity) 
VALUES (105, 1, 2, '2026-06-14', 3);
-- Помилка UNIQUE
INSERT INTO customers (id, full_name, email, phone) 
VALUES (1, 'Дубль Тест', 'test@test.com', '0500000000'); 
COMMIT; -- Помилково замість ROLLBACK

SELECT * FROM orders WHERE id = 105;