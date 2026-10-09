PRAGMA foreign_keys = ON;
--1--
UPDATE orders SET quantity = 2 WHERE id = 4;
--2--
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE id = 4;
--3--
SELECT COUNT(*) FROM orders;            -- до
DELETE FROM orders WHERE id = 10;
SELECT COUNT(*) FROM orders;            -- після
--4--
DELETE FROM clients WHERE id = 3;
