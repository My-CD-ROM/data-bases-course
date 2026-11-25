-- lab_work_23.sql
-- Практика 23. Транзакції та обробка помилок у процедурах PostgreSQL
-- Варіант 2: Магазин одягу (products, customers, orders). Середовище: PostgreSQL 16.15.
-- Операція: place_order (замовлення), порційне оновлення: products.price + N %, з межею.
-- Результати виконання подано в коментарях під кожною командою.

-- ===== Підготовка: схема й дані (аналог бази з Практики 19) =====
-- Увага: структуру й дані підлаштуйте під свою базу з Практики 19.
CREATE TABLE customers (
    id        SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    phone     VARCHAR(20)
);
CREATE TABLE products (
    id             SERIAL PRIMARY KEY,
    name           VARCHAR(100) NOT NULL,
    category       VARCHAR(50),
    price          NUMERIC(10,2) NOT NULL CHECK (price > 0),
    stock_quantity INTEGER NOT NULL CHECK (stock_quantity >= 0)
);
CREATE TABLE orders (
    id          SERIAL PRIMARY KEY,
    product_id  INTEGER NOT NULL REFERENCES products(id),
    customer_id INTEGER NOT NULL REFERENCES customers(id),
    quantity    INTEGER NOT NULL,
    order_date  DATE NOT NULL DEFAULT CURRENT_DATE
);
INSERT INTO customers (last_name, phone) VALUES
 ('Коваленко','+380501112233'),('Шевченко','+380672223344'),('Бондаренко','+380933334455');
INSERT INTO products (name, category, price, stock_quantity) VALUES
 ('Футболка','верхній одяг',450.00,10),
 ('Джинси','штани',1200.00,5),
 ('Куртка','верхній одяг',2500.00,3),
 ('Кросівки','взуття',1800.00,8),
 ('Шапка','аксесуари',300.00,20);
INSERT INTO orders (product_id, customer_id, quantity, order_date) VALUES
 (1,1,2,'2026-10-01'),(4,2,1,'2026-10-05');

-- ===== Завдання 1. Процедура place_order: замовлення з перевірками (варіант 2 - Магазин одягу) =====
CREATE OR REPLACE PROCEDURE place_order(p_product_id INTEGER, p_customer_id INTEGER, p_qty INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    IF p_qty IS NULL OR p_qty <= 0 THEN
        RAISE EXCEPTION 'Кількість має бути додатною, отримано %', p_qty;
    END IF;

    SELECT stock_quantity INTO v_stock FROM products WHERE id = p_product_id FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Товару з id % не існує', p_product_id;
    END IF;

    IF v_stock < p_qty THEN
        RAISE EXCEPTION 'Недостатньо на складі: є %, потрібно %', v_stock, p_qty;
    END IF;

    INSERT INTO orders (product_id, customer_id, quantity, order_date)
    VALUES (p_product_id, p_customer_id, p_qty, CURRENT_DATE);

    UPDATE products SET stock_quantity = stock_quantity - p_qty WHERE id = p_product_id;

    RAISE NOTICE 'Замовлено % шт., залишок %', p_qty, v_stock - p_qty;
END;
$$;
-- CREATE PROCEDURE

-- Стан ДО успішного виклику (товар 3 - Куртка)
SELECT id, name, stock_quantity FROM products WHERE id = 3;
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
--  id |  name  | stock_quantity 
-- ----+--------+----------------
--   3 | Куртка |              3
-- (1 row)
--
--  orders_count | max_order_id 
-- --------------+--------------
--             2 |            2
-- (1 row)

-- Успішний виклик: 2 куртки, клієнт 1
CALL place_order(3, 1, 2);
-- NOTICE:  Замовлено 2 шт., залишок 1
-- CALL

-- Стан ПІСЛЯ: залишок 3 -> 1, нове замовлення
SELECT id, name, stock_quantity FROM products WHERE id = 3;
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
SELECT * FROM orders ORDER BY id;
--  id |  name  | stock_quantity 
-- ----+--------+----------------
--   3 | Куртка |              1
-- (1 row)
--
--  orders_count | max_order_id 
-- --------------+--------------
--             3 |            3
-- (1 row)
--
--  id | product_id | customer_id | quantity | order_date 
-- ----+------------+-------------+----------+------------
--   1 |          1 |           1 |        2 | 2026-10-01
--   2 |          4 |           2 |        1 | 2026-10-05
--   3 |          3 |           1 |        2 | 2026-11-25
-- (3 rows)

-- Невдалий виклик 1: кількість 0
CALL place_order(1, 1, 0);
SELECT id, name, stock_quantity FROM products WHERE id = 1;
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
-- ERROR:  Кількість має бути додатною, отримано 0
-- CONTEXT:  PL/pgSQL function place_order(integer,integer,integer) line 6 at RAISE
--  id |   name   | stock_quantity 
-- ----+----------+----------------
--   1 | Футболка |             10
-- (1 row)
--
--  orders_count | max_order_id 
-- --------------+--------------
--             3 |            3
-- (1 row)

-- Невдалий виклик 2: неіснуючий товар
CALL place_order(99, 2, 1);
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
-- ERROR:  Товару з id 99 не існує
-- CONTEXT:  PL/pgSQL function place_order(integer,integer,integer) line 12 at RAISE
--  orders_count | max_order_id 
-- --------------+--------------
--             3 |            3
-- (1 row)

-- Невдалий виклик 3: недостатньо на складі (є 1, потрібно 2)
CALL place_order(3, 2, 2);
SELECT id, name, stock_quantity FROM products WHERE id = 3;
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
-- ERROR:  Недостатньо на складі: є 1, потрібно 2
-- CONTEXT:  PL/pgSQL function place_order(integer,integer,integer) line 16 at RAISE
--  id |  name  | stock_quantity 
-- ----+--------+----------------
--   3 | Куртка |              1
-- (1 row)
--
--  orders_count | max_order_id 
-- --------------+--------------
--             3 |            3
-- (1 row)

-- ===== Завдання 2. Зрозуміле повідомлення замість системної помилки =====
-- Версія без обробника: неіснуючий клієнт 99 -> системна помилка зовнішнього ключа
CALL place_order(5, 99, 1);
SELECT id, name, stock_quantity FROM products WHERE id = 5;
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
-- ERROR:  insert or update on table "orders" violates foreign key constraint "orders_customer_id_fkey"
-- DETAIL:  Key (customer_id)=(99) is not present in table "customers".
-- CONTEXT:  SQL statement "INSERT INTO orders (product_id, customer_id, quantity, order_date)
--     VALUES (p_product_id, p_customer_id, p_qty, CURRENT_DATE)"
-- PL/pgSQL function place_order(integer,integer,integer) line 19 at SQL statement
--  id | name  | stock_quantity 
-- ----+-------+----------------
--   5 | Шапка |             20
-- (1 row)
--
--  orders_count | max_order_id 
-- --------------+--------------
--             3 |            3
-- (1 row)

-- Додаємо блок BEGIN ... EXCEPTION WHEN foreign_key_violation навколо INSERT
CREATE OR REPLACE PROCEDURE place_order(p_product_id INTEGER, p_customer_id INTEGER, p_qty INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    IF p_qty IS NULL OR p_qty <= 0 THEN
        RAISE EXCEPTION 'Кількість має бути додатною, отримано %', p_qty;
    END IF;

    SELECT stock_quantity INTO v_stock FROM products WHERE id = p_product_id FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Товару з id % не існує', p_product_id;
    END IF;

    IF v_stock < p_qty THEN
        RAISE EXCEPTION 'Недостатньо на складі: є %, потрібно %', v_stock, p_qty;
    END IF;

    BEGIN
        INSERT INTO orders (product_id, customer_id, quantity, order_date)
        VALUES (p_product_id, p_customer_id, p_qty, CURRENT_DATE);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Клієнта з id % не існує', p_customer_id;
    END;

    UPDATE products SET stock_quantity = stock_quantity - p_qty WHERE id = p_product_id;

    RAISE NOTICE 'Замовлено % шт., залишок %', p_qty, v_stock - p_qty;
END;
$$;
-- CREATE PROCEDURE

CALL place_order(5, 99, 1);
SELECT id, name, stock_quantity FROM products WHERE id = 5;
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
-- ERROR:  Клієнта з id 99 не існує
-- CONTEXT:  PL/pgSQL function place_order(integer,integer,integer) line 24 at RAISE
--  id | name  | stock_quantity 
-- ----+-------+----------------
--   5 | Шапка |             20
-- (1 row)
--
--  orders_count | max_order_id 
-- --------------+--------------
--             3 |            3
-- (1 row)

-- ===== Завдання 3. Порційна обробка з COMMIT: reprice_products (price + N %, з межею) =====
CREATE OR REPLACE PROCEDURE reprice_products(p_percent NUMERIC, p_max NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    r RECORD;
    v_new NUMERIC;
BEGIN
    FOR r IN SELECT id, price FROM products ORDER BY id LOOP
        v_new := round(r.price * (1 + p_percent / 100), 2);
        IF v_new > p_max THEN
            RAISE EXCEPTION 'Ціна товару % перевищила б межу: %', r.id, v_new;
        END IF;
        UPDATE products SET price = v_new WHERE id = r.id;
        COMMIT;
    END LOOP;
END;
$$;
-- CREATE PROCEDURE

-- Значення ДО виклику
SELECT id, name, price FROM products ORDER BY id;
--  id |   name   |  price  
-- ----+----------+---------
--   1 | Футболка |  450.00
--   2 | Джинси   | 1200.00
--   3 | Куртка   | 2500.00
--   4 | Кросівки | 1800.00
--   5 | Шапка    |  300.00
-- (5 rows)

-- +10 %, межа 2600: Куртка (2500 -> 2750) перевищує межу, помилка посередині таблиці
CALL reprice_products(10, 2600);
-- ERROR:  Ціна товару 3 перевищила б межу: 2750.00
-- CONTEXT:  PL/pgSQL function reprice_products(numeric,numeric) line 9 at RAISE

-- Значення ПІСЛЯ виклику
SELECT id, name, price FROM products ORDER BY id;
--  id |   name   |  price  
-- ----+----------+---------
--   1 | Футболка |  495.00
--   2 | Джинси   | 1320.00
--   3 | Куртка   | 2500.00
--   4 | Кросівки | 1800.00
--   5 | Шапка    |  300.00
-- (5 rows)

-- ===== Завдання 4. Дві пастки керування транзакціями =====
-- (а) CALL усередині явної транзакції; межа 100000, правило не порушується
SELECT id, name, price FROM products ORDER BY id;
BEGIN;
CALL reprice_products(10, 100000);
ROLLBACK;
SELECT id, name, price FROM products ORDER BY id;
--  id |   name   |  price  
-- ----+----------+---------
--   1 | Футболка |  495.00
--   2 | Джинси   | 1320.00
--   3 | Куртка   | 2500.00
--   4 | Кросівки | 1800.00
--   5 | Шапка    |  300.00
-- (5 rows)
--
-- BEGIN
-- ERROR:  invalid transaction termination
-- CONTEXT:  PL/pgSQL function reprice_products(numeric,numeric) line 12 at COMMIT
-- ROLLBACK
--  id |   name   |  price  
-- ----+----------+---------
--   1 | Футболка |  495.00
--   2 | Джинси   | 1320.00
--   3 | Куртка   | 2500.00
--   4 | Кросівки | 1800.00
--   5 | Шапка    |  300.00
-- (5 rows)

-- (б) тимчасово: COMMIT усередині блоку з EXCEPTION (завдання 2)
CREATE OR REPLACE PROCEDURE place_order(p_product_id INTEGER, p_customer_id INTEGER, p_qty INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    IF p_qty IS NULL OR p_qty <= 0 THEN
        RAISE EXCEPTION 'Кількість має бути додатною, отримано %', p_qty;
    END IF;

    SELECT stock_quantity INTO v_stock FROM products WHERE id = p_product_id FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Товару з id % не існує', p_product_id;
    END IF;

    IF v_stock < p_qty THEN
        RAISE EXCEPTION 'Недостатньо на складі: є %, потрібно %', v_stock, p_qty;
    END IF;

    BEGIN
        INSERT INTO orders (product_id, customer_id, quantity, order_date)
        VALUES (p_product_id, p_customer_id, p_qty, CURRENT_DATE);
        COMMIT;  -- ТИМЧАСОВО: COMMIT усередині блоку з EXCEPTION
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Клієнта з id % не існує', p_customer_id;
    END;

    UPDATE products SET stock_quantity = stock_quantity - p_qty WHERE id = p_product_id;

    RAISE NOTICE 'Замовлено % шт., залишок %', p_qty, v_stock - p_qty;
END;
$$;
-- CREATE PROCEDURE

-- Виклик з коректними даними (товар 5, клієнт 1, кількість 1)
SELECT id, name, stock_quantity FROM products WHERE id = 5;
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
CALL place_order(5, 1, 1);
SELECT id, name, stock_quantity FROM products WHERE id = 5;
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
--  id | name  | stock_quantity 
-- ----+-------+----------------
--   5 | Шапка |             20
-- (1 row)
--
--  orders_count | max_order_id 
-- --------------+--------------
--             3 |            3
-- (1 row)
--
-- ERROR:  cannot commit while a subtransaction is active
-- CONTEXT:  PL/pgSQL function place_order(integer,integer,integer) line 22 at COMMIT
--  id | name  | stock_quantity 
-- ----+-------+----------------
--   5 | Шапка |             20
-- (1 row)
--
--  orders_count | max_order_id 
-- --------------+--------------
--             3 |            3
-- (1 row)

-- Повертаємо робочу версію процедури (COMMIT прибрано)
CREATE OR REPLACE PROCEDURE place_order(p_product_id INTEGER, p_customer_id INTEGER, p_qty INTEGER)
LANGUAGE plpgsql
AS $$
DECLARE
    v_stock INTEGER;
BEGIN
    IF p_qty IS NULL OR p_qty <= 0 THEN
        RAISE EXCEPTION 'Кількість має бути додатною, отримано %', p_qty;
    END IF;

    SELECT stock_quantity INTO v_stock FROM products WHERE id = p_product_id FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Товару з id % не існує', p_product_id;
    END IF;

    IF v_stock < p_qty THEN
        RAISE EXCEPTION 'Недостатньо на складі: є %, потрібно %', v_stock, p_qty;
    END IF;

    BEGIN
        INSERT INTO orders (product_id, customer_id, quantity, order_date)
        VALUES (p_product_id, p_customer_id, p_qty, CURRENT_DATE);
    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Клієнта з id % не існує', p_customer_id;
    END;

    UPDATE products SET stock_quantity = stock_quantity - p_qty WHERE id = p_product_id;

    RAISE NOTICE 'Замовлено % шт., залишок %', p_qty, v_stock - p_qty;
END;
$$;
-- CREATE PROCEDURE

-- Перевірка: робоча версія знову працює
CALL place_order(5, 1, 1);
SELECT id, name, stock_quantity FROM products WHERE id = 5;
SELECT COUNT(*) AS orders_count, MAX(id) AS max_order_id FROM orders;
-- NOTICE:  Замовлено 1 шт., залишок 19
-- CALL
--  id | name  | stock_quantity 
-- ----+-------+----------------
--   5 | Шапка |             19
-- (1 row)
--
--  orders_count | max_order_id 
-- --------------+--------------
--             4 |            7
-- (1 row)

-- ===== Завдання 5 (додаткове). Із COMMIT і без нього =====
-- Повертаємо значення, записані перед завданням 3 (ціни товарів 1 і 2)
UPDATE products SET price = 450.00 WHERE id = 1;
UPDATE products SET price = 1200.00 WHERE id = 2;
SELECT id, name, price FROM products ORDER BY id;
-- UPDATE 1
-- UPDATE 1
--  id |   name   |  price  
-- ----+----------+---------
--   1 | Футболка |  450.00
--   2 | Джинси   | 1200.00
--   3 | Куртка   | 2500.00
--   4 | Кросівки | 1800.00
--   5 | Шапка    |  300.00
-- (5 rows)

-- Версія без COMMIT у циклі
CREATE OR REPLACE PROCEDURE reprice_products(p_percent NUMERIC, p_max NUMERIC)
LANGUAGE plpgsql
AS $$
DECLARE
    r RECORD;
    v_new NUMERIC;
BEGIN
    FOR r IN SELECT id, price FROM products ORDER BY id LOOP
        v_new := round(r.price * (1 + p_percent / 100), 2);
        IF v_new > p_max THEN
            RAISE EXCEPTION 'Ціна товару % перевищила б межу: %', r.id, v_new;
        END IF;
        UPDATE products SET price = v_new WHERE id = r.id;
    END LOOP;
END;
$$;
-- CREATE PROCEDURE

CALL reprice_products(10, 2600);
SELECT id, name, price FROM products ORDER BY id;
-- ERROR:  Ціна товару 3 перевищила б межу: 2750.00
-- CONTEXT:  PL/pgSQL function reprice_products(numeric,numeric) line 9 at RAISE
--  id |   name   |  price  
-- ----+----------+---------
--   1 | Футболка |  450.00
--   2 | Джинси   | 1200.00
--   3 | Куртка   | 2500.00
--   4 | Кросівки | 1800.00
--   5 | Шапка    |  300.00
-- (5 rows)

