-- lab_work_24.sql
-- Практика 24. Реалізація тригерів (варіант 2: Магазин одягу)
-- Середовище: PostgreSQL 16.15, база з Практик 19 і 23 (products, customers, orders).
-- Результати виконання подано в коментарях під кожною командою.

-- ===== Завдання 1. Таблиця журналу products_log =====
CREATE TABLE products_log (
    id         INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    product_id INTEGER,
    action     TEXT,
    old_price  NUMERIC(10,2),
    new_price  NUMERIC(10,2),
    logged_at  TIMESTAMP DEFAULT now()
);
-- CREATE TABLE

SELECT column_name, data_type FROM information_schema.columns WHERE table_name = 'products_log' ORDER BY ordinal_position;
--  column_name |          data_type          
-- -------------+-----------------------------
--  id          | integer
--  product_id  | integer
--  action      | text
--  old_price   | numeric
--  new_price   | numeric
--  logged_at   | timestamp without time zone
-- (6 rows)

-- ===== Завдання 2. AFTER-тригер для журналу змін ціни =====
CREATE OR REPLACE FUNCTION log_price_change() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO products_log (product_id, action, old_price, new_price)
        VALUES (NEW.id, 'INSERT', NULL, NEW.price);
    ELSIF TG_OP = 'UPDATE' THEN
        -- журнал веде лише зміни ціни (списання залишку процедурою place_order не логуються)
        IF OLD.price IS DISTINCT FROM NEW.price THEN
            INSERT INTO products_log (product_id, action, old_price, new_price)
            VALUES (NEW.id, 'UPDATE', OLD.price, NEW.price);
        END IF;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

CREATE TRIGGER trg_log_price
AFTER INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION log_price_change();
-- CREATE TRIGGER

-- Журнал спочатку порожній
SELECT id, product_id, action, old_price, new_price FROM products_log ORDER BY id;
--  id | product_id | action | old_price | new_price 
-- ----+------------+--------+-----------+-----------
-- (0 rows)

-- INSERT нового товару (жодного явного запису в журнал)
INSERT INTO products (name, category, price, stock_quantity) VALUES ('Шарф', 'аксесуари', 350.00, 15);
SELECT id, product_id, action, old_price, new_price FROM products_log ORDER BY id;
-- INSERT 0 1
--  id | product_id | action | old_price | new_price 
-- ----+------------+--------+-----------+-----------
--   1 |          6 | INSERT |           |    350.00
-- (1 row)

-- UPDATE ціни (Шарф: 350 -> 400)
UPDATE products SET price = 400.00 WHERE name = 'Шарф';
SELECT id, product_id, action, old_price, new_price FROM products_log ORDER BY id;
-- UPDATE 1
--  id | product_id | action | old_price | new_price 
-- ----+------------+--------+-----------+-----------
--   1 |          6 | INSERT |           |    350.00
--   2 |          6 | UPDATE |    350.00 |    400.00
-- (2 rows)

-- UPDATE залишку без зміни ціни: запису в журналі немає
UPDATE products SET stock_quantity = stock_quantity - 1 WHERE name = 'Шарф';
SELECT id, product_id, action, old_price, new_price FROM products_log ORDER BY id;
-- UPDATE 1
--  id | product_id | action | old_price | new_price 
-- ----+------------+--------+-----------+-----------
--   1 |          6 | INSERT |           |    350.00
--   2 |          6 | UPDATE |    350.00 |    400.00
-- (2 rows)

-- ===== Завдання 3. BEFORE-тригер для перевірки ціни =====
CREATE OR REPLACE FUNCTION validate_price() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.price IS NULL OR NEW.price <= 0 THEN
        RAISE EXCEPTION 'Ціна має бути додатною, отримано % (товар %)', NEW.price, NEW.name;
    END IF;

    IF TG_OP = 'UPDATE' AND NEW.price > OLD.price * 2 THEN
        RAISE EXCEPTION 'Ціну не можна підвищувати більш ніж удвічі за раз: було %, спроба встановити % (товар %)',
            OLD.price, NEW.price, OLD.name;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

CREATE TRIGGER trg_validate_price
BEFORE INSERT OR UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION validate_price();
-- CREATE TRIGGER

-- Обидва тригери на таблиці products
SELECT tgname, CASE WHEN tgtype & 2 = 2 THEN 'BEFORE' ELSE 'AFTER' END AS timing FROM pg_trigger WHERE tgrelid = 'products'::regclass AND NOT tgisinternal ORDER BY tgname;
--        tgname       | timing 
-- --------------------+--------
--  trg_log_price      | AFTER
--  trg_validate_price | BEFORE
-- (2 rows)

-- ===== Завдання 4. Перевірка блокування =====
-- Стан ДО: товари та журнал
SELECT id, name, price FROM products ORDER BY id;
SELECT id, product_id, action, old_price, new_price FROM products_log ORDER BY id;
--  id |   name   |  price  
-- ----+----------+---------
--   1 | Футболка |  450.00
--   2 | Джинси   | 1200.00
--   3 | Куртка   | 2500.00
--   4 | Кросівки | 1800.00
--   5 | Шапка    |  300.00
--   6 | Шарф     |  400.00
-- (6 rows)
--
--  id | product_id | action | old_price | new_price 
-- ----+------------+--------+-----------+-----------
--   1 |          6 | INSERT |           |    350.00
--   2 |          6 | UPDATE |    350.00 |    400.00
-- (2 rows)

-- Порушення 1: INSERT із від'ємною ціною
INSERT INTO products (name, category, price, stock_quantity) VALUES ('Брак', 'тест', -100.00, 5);
SELECT id, name, price FROM products WHERE name = 'Брак';
-- ERROR:  Ціна має бути додатною, отримано -100.00 (товар Брак)
-- CONTEXT:  PL/pgSQL function validate_price() line 4 at RAISE
--  id | name | price 
-- ----+------+-------
-- (0 rows)

-- Порушення 2: UPDATE, що підвищує ціну більш ніж удвічі (Шарф: 400 -> 1000)
UPDATE products SET price = 1000.00 WHERE name = 'Шарф';
SELECT id, name, price FROM products WHERE name = 'Шарф';
-- ERROR:  Ціну не можна підвищувати більш ніж удвічі за раз: було 400.00, спроба встановити 1000.00 (товар Шарф)
-- CONTEXT:  PL/pgSQL function validate_price() line 8 at RAISE
--  id | name | price  
-- ----+------+--------
--   6 | Шарф | 400.00
-- (1 row)

-- Журнал не змінився
SELECT id, product_id, action, old_price, new_price FROM products_log ORDER BY id;
--  id | product_id | action | old_price | new_price 
-- ----+------------+--------+-----------+-----------
--   1 |          6 | INSERT |           |    350.00
--   2 |          6 | UPDATE |    350.00 |    400.00
-- (2 rows)

-- ===== Завдання 5. Підсумкова перевірка обох тригерів разом (товар 1 - Футболка) =====
-- ДО: ціна Футболки та кількість записів у журналі
SELECT id, name, price FROM products WHERE id = 1;
SELECT COUNT(*) AS log_rows FROM products_log;
--  id |   name   | price  
-- ----+----------+--------
--   1 | Футболка | 450.00
-- (1 row)
--
--  log_rows 
-- ----------
--         2
-- (1 row)

-- (1) Успішна зміна: 450 -> 495 (+10 %), проходить перевірку
UPDATE products SET price = 495.00 WHERE id = 1;
-- UPDATE 1

-- (2) Неуспішна спроба: 495 -> 5000, блокується BEFORE-тригером
UPDATE products SET price = 5000.00 WHERE id = 1;
-- ERROR:  Ціну не можна підвищувати більш ніж удвічі за раз: було 495.00, спроба встановити 5000.00 (товар Футболка)
-- CONTEXT:  PL/pgSQL function validate_price() line 8 at RAISE

-- ПІДСУМОК: ціна, журнал по товару 1, загальна кількість записів
SELECT id, name, price FROM products WHERE id = 1;
SELECT id, product_id, action, old_price, new_price FROM products_log WHERE product_id = 1 ORDER BY id;
SELECT COUNT(*) AS log_rows FROM products_log;
--  id |   name   | price  
-- ----+----------+--------
--   1 | Футболка | 495.00
-- (1 row)
--
--  id | product_id | action | old_price | new_price 
-- ----+------------+--------+-----------+-----------
--   3 |          1 | UPDATE |    450.00 |    495.00
-- (1 row)
--
--  log_rows 
-- ----------
--         3
-- (1 row)

