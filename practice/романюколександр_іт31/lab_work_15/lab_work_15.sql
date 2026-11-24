----------- TASK 1 -----------

EXPLAIN QUERY PLAN
SELECT *
FROM orders
WHERE product_id = 1

-- План: SCAN orders

----------- TASK 2 -----------

CREATE INDEX idx_orders_product_id ON orders(product_id)

EXPLAIN QUERY PLAN
SELECT *
FROM orders
WHERE product_id = 1

-- План: SEARCH orders USING INDEX idx_orders_product_id (product_id=?)

----------- TASK 3 -----------

EXPLAIN QUERY PLAN
SELECT *
FROM orders
WHERE product_id = 1 AND status = 'прийнято'

-- План: SCAN orders

CREATE INDEX idx_orders_product_id_status ON orders(product_id, status)

EXPLAIN QUERY PLAN
SELECT *
FROM orders
WHERE product_id = 1 AND status = 'прийнято'

-- План: SEARCH orders USING INDEX idx_orders_product_id_status (product_id=? AND status=?)

----------- TASK 4 -----------

EXPLAIN QUERY PLAN
SELECT *
FROM orders
ORDER BY order_date

-- План: SCAN orders, USE TEMP B-TREE FOR ORDER BY

CREATE INDEX idx_orders_order_date ON orders(order_date)

EXPLAIN QUERY PLAN
SELECT *
FROM orders
ORDER BY order_date

-- План: SCAN orders USING INDEX idx_orders_order_date

----------- TASK 5 -----------

EXPLAIN QUERY PLAN
SELECT *
FROM orders
WHERE product_id = 1

-- План: SEARCH orders USING INDEX idx_orders_product_id (product_id=?)

DROP INDEX idx_orders_product_id

EXPLAIN QUERY PLAN
SELECT *
FROM orders
WHERE product_id = 1

-- План: SEARCH orders USING INDEX idx_orders_product_id_status (product_id=?)

SELECT name, tbl_name FROM sqlite_master WHERE type = 'index'