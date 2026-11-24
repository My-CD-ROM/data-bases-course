UPDATE orders SET quantity = 3 WHERE id = 8;

UPDATE products SET stock_quantity = 46 WHERE id = 7;

SELECT COUNT(*) FROM orders;

DELETE FROM orders WHERE id = 10;

SELECT COUNT(*) FROM orders;

PRAGMA foreign_keys = ON;

DELETE FROM products WHERE id = 5