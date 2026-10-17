ALTER TABLE products RENAME TO products_old

CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT,
  size TEXT,
  price REAL NOT NULL,
  stock_quantity INTEGER NOT NULL
)

INSERT INTO products SELECT * FROM products_old;

-- At line 1:
-- INSERT INTO products (name, price) VALUES
--   ("Панчохи чорні", 123)
-- Result: NOT NULL constraint failed: products.stock_quantity

ALTER TABLE customers RENAME TO customers_old

CREATE TABLE customers ( 
  id INTEGER PRIMARY KEY, 
  first_name TEXT NOT NULL, 
  last_name TEXT NOT NULL, 
  email TEXT NOT NULL UNIQUE, 
  city TEXT NOT NULL 
)

INSERT INTO customers SELECT * FROM customers_old

-- At line 1:
-- INSERT INTO customers (first_name, last_name, email, city) VALUES
--   ("Роман", "Пилкович", "bogdan.velykodushnyi@gmail.com", "Київ")
-- Result: UNIQUE constraint failed: customers.email

ALTER TABLE products RENAME TO products_old1

CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT,
  size TEXT,
  price REAL NOT NULL CHECK (price >= 0),
  stock_quantity INTEGER NOT NULL
)

INSERT INTO products SELECT * FROM products_old1;

-- At line 1:
-- INSERT INTO products (name, price, stock_quantity) VALUES
--   ("Панчохи білі", -5, 34)
-- Result: CHECK constraint failed: price >= 0

CREATE TABLE products (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT,
  size TEXT,
  price REAL NOT NULL CHECK (price >= 0),
  stock_quantity INTEGER NOT NULL DEFAULT 0
)

INSERT INTO products (name, price) VALUES
  ("Сірий светр", 534)

SELECT name, price, stock_quantity FROM products

-- At line 1:
-- UPDATE products SET price = -454 WHERE name = "Сірий светр"
-- Result: CHECK constraint failed: price >= 0

ALTER TABLE orders RENAME TO orders_old

CREATE TABLE orders ( 
  id INTEGER PRIMARY KEY, 
  product_id INTEGER NOT NULL, 
  customer_id INTEGER NOT NULL, 
  order_date TEXT NOT NULL, 
  quantity INTEGER NOT NULL DEFAULT 1, 
  status TEXT NOT NULL DEFAULT "замовлено", 
  FOREIGN KEY (product_id) REFERENCES "products_old" (id) ON DELETE RESTRICT, 
  FOREIGN KEY (customer_id) REFERENCES "customers_old" (id) ON DELETE SET NULL 
)

INSERT INTO orders SELECT * FROM orders_old

DROP TABLE customers_old
DROP TABLE products_old
DROP TABLE products_old1
DROP TABLE products_old2
DROP TABLE orders_old