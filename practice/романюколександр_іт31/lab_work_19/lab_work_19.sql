----------- TASK 2 -----------

CREATE TABLE products ( 
	id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	name TEXT NOT NULL, 
	category TEXT, 
	size TEXT, 
	price REAL NOT NULL CHECK (price >= 0), 
	stock_quantity INTEGER NOT NULL DEFAULT 0, 
	price_with_vat REAL GENERATED ALWAYS AS (price * 1.2) VIRTUAL
)

CREATE TABLE customers ( 
	id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
	first_name TEXT NOT NULL, 
	last_name TEXT NOT NULL, 
	email TEXT NOT NULL UNIQUE, 
	city TEXT NOT NULL 
)

CREATE TABLE orders ( 
	id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	product_id INTEGER NOT NULL, 
	customer_id INTEGER NOT NULL, 
	order_date TEXT, 
	quantity INTEGER NOT NULL DEFAULT 1, 
	status TEXT NOT NULL DEFAULT 'замовлено', 
	received_by_the_customer BOOLEAN GENERATED ALWAYS AS (status='прийнято') VIRTUAL, 
	FOREIGN KEY (product_id) REFERENCES "products" (id) ON DELETE RESTRICT, 
	FOREIGN KEY (customer_id) REFERENCES "customers" (id) ON DELETE SET NULL 
)

CREATE TABLE feedbacks ( 
	id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
	product_id INTEGER NOT NULL, 
	rate REAL CHECK (rate BETWEEN 0 AND 5), 
	comment TEXT DEFAULT NULL, 
	feedback_date TEXT NOT NULL, 
	FOREIGN KEY (product_id) REFERENCES products (id) 
)

----------- TASK 3 -----------

-- .headers on
-- .mode csv
-- .output products.csv
SELECT id, name, category, size, price, stock_quantity
FROM products;
-- .output stdout

-- .output customers.csv
SELECT id, first_name, last_name, email, city
FROM customers;
-- .output stdout

-- .output orders.csv
SELECT id, product_id, customer_id, order_date, quantity, status
FROM orders;
-- .output stdout

-- .output feedbacks.csv 
SELECT id, product_id, rate, comment, feedback_date
FROM feedbacks;
-- .output stdout

----------- TASK 4 -----------

SELECT setval(pg_get_serial_sequence('customers', 'id'), (SELECT MAX(id) FROM customers));

SELECT setval(pg_get_serial_sequence('products', 'id'), (SELECT MAX(id) FROM products));

SELECT setval(pg_get_serial_sequence('orders', 'id'), (SELECT MAX(id) FROM orders));

SELECT setval(pg_get_serial_sequence('feedbacks', 'id'), (SELECT MAX(id) FROM feedbacks));

INSERT INTO customers (first_name, last_name, email, city) VALUES (
	'Василь', 'Гончаренко', 'vasyl.honcharenko', 'Чернігів'
)

INSERT INTO products (name, category, size, price, stock_quantity) VALUES (
	'Вишиванка з червоним візерунком', 'вишиванки', 'S', 1991, 9
)

INSERT INTO orders (product_id, customer_id, order_date, quantity, status) VALUES (
	25, 7, '2026-10-27', 5, 'прийнято'
)

INSERT INTO feedbacks (product_id, rate, comment, feedback_date) VALUES (
	7, 5.0, 'Гарна вишиванка. Прийшла швидко. Легко прасується', '2026-11-02'
)

----------- TASK 5 -----------
-- Команда -- відповідь у PostgreSQL -- відповідь у SQLite
SELECT COUNT(*) FROM feedbacks -- 10 -- 9 (10 - 1 = 9)
SELECT COUNT(*) FROM orders -- 14 -- 13 (14 - 1 = 13)
SELECT COUNT(*) FROM products -- 25 -- 24 (25 - 1 = 24)
SELECT COUNT(*) FROM customers -- 7 -- 6 (7 - 1 = 6)

-- ERROR:  insert або update в таблиці "orders" порушує обмеження зовнішнього ключа "orders_customer_id_fkey"
-- Ключ (customer_id)=(777) не присутній в таблиці "customers". 