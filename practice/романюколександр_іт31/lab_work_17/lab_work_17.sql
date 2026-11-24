----------- TASK 1 -----------

CREATE TABLE products_staging (
  name TEXT,
  category TEXT,
  size TEXT,
  price REAL,
  stock_quantity INTEGER
);

-- .mode csv
-- .import --skip 1 v2_raw_rows.csv products_staging
-- v2_raw_rows.csv:2: expected 5 columns but found 2 - filling the rest with NULL
-- v2_raw_rows.csv:3: expected 5 columns but found 1 - filling the rest with NULL
-- v2_raw_rows.csv:4: expected 5 columns but found 1 - filling the rest with NULL

SELECT COUNT(*) FROM products_staging; -- 10

SELECT * FROM products_staging LIMIT 1;
-- "Сорочка лляна"," біла;Сорочки;M;799.0;14",,,

DELETE FROM products_staging;

----------- TASK 2 -----------

-- .separator ";"

-- .import --skip 1 v2_raw_rows.csv products_staging

SELECT COUNT(*) FROM products_staging; -- 10

----------- TASK 3 -----------

SELECT COUNT(*) FROM products_staging; -- 10

SELECT * FROM products_staging LIMIT 5;

SELECT SUM(name = '') AS empty_name, SUM(category = '') AS empty_category, SUM(size = '') AS empty_size, SUM(price = '') AS empty_price, SUM(stock_quantity = '') AS empty_stock_quantity
FROM products_staging;

SELECT name, price, typeof(price), stock_quantity, typeof(stock_quantity)
FROM products_staging;

SELECT name, category, size, price, stock_quantity, COUNT(*) AS count
FROM products_staging
GROUP BY name, category, size, price, stock_quantity
HAVING COUNT(*) > 1;

----------- TASK 4 -----------

SELECT COUNT(*) FROM products; -- 17
SELECT MAX(id) FROM products; --17

INSERT INTO products(name, category, size, price, stock_quantity)
SELECT DISTINCT name, category, size, price, stock_quantity
FROM products_staging
WHERE stock_quantity IS NOT '';

SELECT COUNT(*) FROM products; -- 24

SELECT * FROM products
WHERE stock_quantity IS NULL;

DROP TABLE products_staging;

----------- TASK 5 -----------

-- .headers on
-- .mode csv
-- .output products_export.csv

SELECT id, name, category, size, price, stock_quantity
FROM products
WHERE id > 17;

-- .output stdout