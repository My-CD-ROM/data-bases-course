
PRAGMA foreign_keys = ON;

-- Завдання 1

EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE client_id = 1;



-- Завдання 2

CREATE INDEX idx_sales_client
ON membership_sales(client_id);


EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE client_id = 1;



-- Завдання 3

EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE client_id = 1
AND purchase_date = '2026-10-01';


CREATE INDEX idx_sales_client_date
ON membership_sales(client_id, purchase_date);

EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE client_id = 1
AND purchase_date = '2026-10-01';

-- Завдання 4

EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
ORDER BY purchase_date;


CREATE INDEX idx_sales_purchase_date
ON membership_sales(purchase_date);


EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
ORDER BY purchase_date;


-- Завдання 5

DROP INDEX idx_sales_client_date;

EXPLAIN QUERY PLAN
SELECT *
FROM membership_sales
WHERE client_id = 1
AND purchase_date = '2026-10-01';

SELECT name
FROM sqlite_master
WHERE type = 'index'
AND tbl_name = 'membership_sales'
ORDER BY name;
