-- Практика 17. Імпорт «брудного» CSV (варіант 2, інтернет-магазин одягу; цільова таблиця products)
-- Дот-команди виконуються в консолі sqlite3. Файл: v2_raw_rows.csv (заголовок + 10 записів, роздільник «;»)

-- Завдання 1. «Наївний» імпорт
SELECT COUNT(*) AS before_count, MAX(id) AS max_id FROM products;   -- 16 | 16
CREATE TABLE products_staging (name TEXT, category TEXT, size TEXT, price REAL, stock_quantity INTEGER);
.mode csv
.import --skip 1 v2_raw_rows.csv products_staging
-- Перші три попередження CLI:
-- v2_raw_rows.csv:2: expected 5 columns but found 1 - filling the rest with NULL
-- v2_raw_rows.csv:3: expected 5 columns but found 2 - filling the rest with NULL
-- v2_raw_rows.csv:4: expected 5 columns but found 1 - filling the rest with NULL
SELECT COUNT(*) FROM products_staging;          -- 10
SELECT * FROM products_staging LIMIT 1;         -- name = 'Джогери утеплені;Штани;M;890.0;24', решта колонок порожні
DELETE FROM products_staging;

-- Завдання 2. Правильний імпорт з роздільником «;»
.mode csv
.separator ";"
.import --skip 1 v2_raw_rows.csv products_staging
SELECT COUNT(*) FROM products_staging;          -- 10, попереджень немає

-- Завдання 3. Контроль якості в проміжній таблиці
SELECT SUM(name = '') AS name_empty, SUM(category = '') AS category_empty, SUM(size = '') AS size_empty,
       SUM(price = '') AS price_empty, SUM(stock_quantity = '') AS stock_empty
FROM products_staging;
-- Результат: 0 | 0 | 2 | 0 | 1
SELECT typeof(price), typeof(stock_quantity), COUNT(*) FROM products_staging GROUP BY 1, 2;
-- Результат: real|integer|9 ; real|text|1  (один порожній stock_quantity лишився текстом '')
SELECT name, category, size, price, stock_quantity, COUNT(*) AS cnt
FROM products_staging
GROUP BY name, category, size, price, stock_quantity
HAVING COUNT(*) > 1;
-- Результат: Кардиган в'язаний | Светри | S | 1280.0 | 12 | 2
SELECT s.name FROM products_staging s
WHERE EXISTS (SELECT 1 FROM products p WHERE p.name = s.name AND p.category = s.category);
-- Результат: 0 рядків (повторів відносно цільової таблиці немає)
.schema products
-- NOT NULL: name, category, price, stock_quantity (size допускає NULL)
-- Розрахунок: 10 записів - 1 дублікат = 9 унікальних; з них 1 (Куртка джинсова) без stock_quantity
-- (NOT NULL) відкладається, отже має додатися 8 рядків.

-- Завдання 4. Перенесення з виправленням
SELECT COUNT(*), MAX(id) FROM products;         -- 16 | 16
-- спроба з NULLIF для обох колонок:
INSERT INTO products (name, category, size, price, stock_quantity)
SELECT DISTINCT name, category, NULLIF(size, ''), price, NULLIF(stock_quantity, '') FROM products_staging;
-- Помилка: NOT NULL constraint failed: products.stock_quantity  (жодного рядка не додано, COUNT = 16)
-- правильне перенесення (повні рядки, без дублікатів, NULLIF лише для size):
INSERT INTO products (name, category, size, price, stock_quantity)
SELECT DISTINCT name, category, NULLIF(size, ''), price, stock_quantity
FROM products_staging
WHERE stock_quantity <> '';
SELECT COUNT(*), MAX(id) FROM products;         -- 24 | 24  (приріст 8, id 17-24)
SELECT id, name FROM products WHERE id > 16 AND size IS NULL;
-- Результат: 19 Шарф кашеміровий ; 21 Спідниця міді
SELECT COUNT(*) FROM products WHERE name = 'Куртка джинсова';   -- 0 (відкладено)
DROP TABLE products_staging;

-- Завдання 5. Експорт доданих рядків
.headers on
.mode csv
.output products_new_export.csv
SELECT id, name, category, size, price, stock_quantity FROM products WHERE id > 16;
.output stdout
-- Вміст products_new_export.csv: див. lab_work_17.md
