ALTER TABLE orders RENAME TO orders_old

CREATE TABLE orders {
  id INTEGER PRIMARY KEY, 
  product_id INTEGER NOT NULL, 
  customer_id INTEGER NOT NULL, 
  order_date TEXT, 
  quantity INTEGER NOT NULL DEFAULT 1, 
  status TEXT NOT NULL DEFAULT "замовлено", 
  FOREIGN KEY (product_id) REFERENCES "products" (id) ON DELETE RESTRICT, 
  FOREIGN KEY (customer_id) REFERENCES "customers" (id) ON DELETE SET NULL 
}

INSERT INTO orders SELECT * FROM orders_old

DROP TABLE orders_old

UPDATE orders
SET order_date = NULL
WHERE id = 7

SELECT COUNT(*) FROM orders -- 9

SELECT COUNT(order_date) FROM orders -- 8

SELECT SUM(price) FROM products -- 8315.695

SELECT AVG(price) FROM products -- 1187.95642857143

SELECT MIN(last_name) FROM customers -- Великодушний

SELECT MAX(last_name) FROM customers -- Прапорець

SELECT SUM(quantity) AS "sum of ordered items", AVG(quantity) AS "average of ordered items", MIN(order_date) AS "earliest order", MAX(order_date) AS "last order", MAX(quantity) AS "biggest order" 
FROM orders

SELECT SUM(quantity) AS "sum of ordered items", AVG(quantity) AS "average of ordered items", MIN(order_date) AS "earliest order", MAX(order_date) AS "last order", MAX(quantity) AS "biggest order" 
FROM orders
WHERE customer_id = 4