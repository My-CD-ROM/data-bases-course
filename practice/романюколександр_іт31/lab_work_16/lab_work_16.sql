----------- TASK 1 -----------

SELECT COUNT(*) FROM products; -- 9

----------- TASK 2 -----------

CREATE TABLE products_staging(
  name TEXT,
  category TEXT,
  size TEXT,
  price REAL,
  stock_quantity INTEGER
);

-- .mode csv
-- .import --skip 1 v2_new_rows.csv products_staging

SELECT * FROM products_staging;

----------- TASK 3 -----------

INSERT INTO products (name, category, size, price, stock_quantity)
SELECT name, category, size, price, stock_quantity FROM products_staging;

DROP TABLE products_staging;

SELECT COUNT(*) FROM products; -- 17

----------- TASK 4 -----------

SELECT * FROM products
WHERE name LIKE '%ий'

----------- TASK 5 -----------

-- .mode csv
-- .import --skip 1 v2_new_rows.csv products

-- expected 6 columns but found 5 - filling the rest with NULL
-- INSERT failed: datatype mismatch