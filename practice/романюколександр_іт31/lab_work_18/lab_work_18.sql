----------- TASK 1 -----------

ALTER TABLE products ADD COLUMN price_with_vat REAL
GENERATED ALWAYS AS (price * 1.2) VIRTUAL;

SELECT name, price, price_with_vat
FROM products;

----------- TASK 2 -----------

ALTER TABLE orders ADD COLUMN received_by_the_customer INTEGER
GENERATED ALWAYS AS (status='прийнято') VIRTUAL;

SELECT * FROM orders
WHERE status='прийнято';

----------- TASK 3 -----------

UPDATE products SET price_with_vat = 1200 WHERE id = 5;

----------- TASK 4 -----------

SELECT name, price, price_with_vat
FROM products
WHERE id=5;

UPDATE products SET price = 6767 WHERE id=5;

SELECT name, price, price_with_vat
FROM products
WHERE id=5;

----------- TASK 5 -----------

SELECT name, price, price_with_vat, stock_quantity
FROM products
WHERE price_with_vat >= 1000;