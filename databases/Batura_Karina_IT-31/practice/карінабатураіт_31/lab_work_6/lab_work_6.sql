--Практична 6, Варіант 2, Батури Каріни
-- Перевірка зовнішніх ключів
PRAGMA foreign_keys = ON;
--Завдання 1 
UPDATE orders SET status = 'completed' WHERE id = 1;
--Завдання 2
UPDATE products SET stock_quantity = 25 WHERE id = 1;
--Завдання 3
DELETE FROM orders WHERE id = 2;
--Завдання 4
--1)Перевірка ON DELETE RESTRICT
DELETE FROM products WHERE id = 2;
--2)Перевірка ON DELETE CASCADE
DELETE FROM customers WHERE id = 2;