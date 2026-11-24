BEGIN;
INSERT INTO orders (product_id, customer_id, order_date, quantity, status) VALUES 
(8, 6, '2026-11-11', 2, 'замовлено');
UPDATE products SET stock_quantity = stock_quantity - 2 WHERE id = 8;
COMMIT;

BEGIN;
INSERT INTO orders (product_id, customer_id, order_date, quantity, status) VALUES (3, 5, '2026-11-10', 1, 'замовлено');
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE id = 3;
ROLLBACK;

BEGIN;
INSERT INTO orders (product_id, customer_id, order_date, quantity, status) VALUES (7, 2, '2026-11-09', 1, 'відправлено');
SELECT * FROM orders;
ROLLBACK;

BEGIN;
INSERT INTO orders (product_id, customer_id, order_date, quantity, status) VALUES (2, 1, '2026-11-12', 50, 'відправлено');
UPDATE products SET stock_quantity = stock_quantity - 50 WHERE id = 2;
UPDATE products SET price = -50 WHERE id = 2;
-- Error near line 45: CHECK constraint failed: price >= 0
SELECT * FROM orders;
ROLLBACK;

BEGIN;
INSERT INTO orders (product_id, customer_id, order_date, quantity, status) VALUES (2, 1, '2026-11-12', 50, 'відправлено');
UPDATE products SET stock_quantity = stock_quantity - 50 WHERE id = 2;
UPDATE products SET price = -50 WHERE id = 2;
SELECT * FROM orders;
COMMIT;