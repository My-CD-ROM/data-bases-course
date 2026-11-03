-- Практика 14. Транзакції (варіант 2, інтернет-магазин одягу)
PRAGMA foreign_keys = ON;

-- Початковий стан: orders = 9 рядків; stock_quantity: товар 1 = 40, 2 = 15, 3 = 8, 4 = 19

-- Завдання 1. Атомарна пара: нове замовлення + зменшення залишку товару
BEGIN;
INSERT INTO orders (product_id, client_id, order_date, quantity) VALUES (3, 2, '2026-10-05', 2);
UPDATE products SET stock_quantity = stock_quantity - 2 WHERE id = 3;
COMMIT;
SELECT * FROM orders WHERE id = 10;                         -- (10, 3, 2, '2026-10-05', 2)
SELECT id, stock_quantity FROM products WHERE id = 3;       -- (3, 6)
SELECT COUNT(*) FROM orders;                                -- 10

-- Завдання 2. Свідомий ROLLBACK
BEGIN;
INSERT INTO orders (product_id, client_id, order_date, quantity) VALUES (1, 1, '2026-10-06', 1);
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE id = 1;
ROLLBACK;
SELECT COUNT(*) FROM orders;                                -- 10 (без змін)
SELECT stock_quantity FROM products WHERE id = 1;           -- 40 (без змін)

-- Завдання 3. Проміжний стан усередині транзакції
BEGIN;
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE id = 2;
SELECT id, stock_quantity FROM products WHERE id = 2;       -- (2, 14)  — власна зміна видна
-- (у другій сесії того самого файлу в цей момент: (2, 15))
ROLLBACK;
SELECT id, stock_quantity FROM products WHERE id = 2;       -- (2, 15)

-- Завдання 4. Помилка всередині транзакції
BEGIN;
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE id = 4;
INSERT INTO clients (full_name, email) VALUES ('Тест Тестович', 'olena.k@mail.com');
-- Помилка SQLite: UNIQUE constraint failed: clients.email
SELECT id, stock_quantity FROM products WHERE id = 4;       -- (4, 18)  — перша зміна ПРИСУТНЯ
SELECT COUNT(*) FROM clients;                               -- 5 (рядка-порушника немає)
ROLLBACK;
SELECT id, stock_quantity FROM products WHERE id = 4;       -- (4, 19)

-- Завдання 5. Забутий ROLLBACK: той самий сценарій, але COMMIT
BEGIN;
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE id = 4;
INSERT INTO clients (full_name, email) VALUES ('Тест Тестович', 'olena.k@mail.com');
-- Помилка SQLite: UNIQUE constraint failed: clients.email
COMMIT;
SELECT id, stock_quantity FROM products WHERE id = 4;       -- (4, 18)  — перша зміна зафіксована
SELECT COUNT(*) FROM clients;                               -- 5 (друга зміна не застосована)

-- Фінальний стан бази: orders = 10 рядків; stock_quantity: товар 3 = 6, товар 4 = 18 (решта без змін)
