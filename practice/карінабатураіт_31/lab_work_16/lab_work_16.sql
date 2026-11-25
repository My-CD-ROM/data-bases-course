-- Практична робота №16 (Варіант 2: Інтернет-магазин одягу)
--Батури Каріни
-- Завдання 1: Підрахунок кількості рядків до імпорту
SELECT COUNT(*) AS count_before FROM products;
--8
-- Завдання 2
CREATE TABLE products_staging (
    name TEXT,
    category TEXT,
    size TEXT,
    price REAL,
    stock_quantity INTEGER
);
.mode csv
.import --skip 1 v2_new_rows.csv products_staging

-- Перевірка вмісту проміжної таблиці
SELECT * FROM products_staging;

-- Завдання 3: Перенесення даних у цільову таблицю products
INSERT INTO products (name, category, size, price, stock_quantity)
SELECT name, category, size, price, stock_quantity FROM products_staging;

-- Видалення проміжної таблиці
DROP TABLE products_staging;

-- Підрахунок кількості рядків після імпорту
SELECT COUNT(*) AS count_after FROM products;
--16

-- Завдання 4: Перевірка нових рядків та послідовності id
SELECT id, name, category, size, price, stock_quantity 
FROM products 
ORDER BY id DESC LIMIT 8;

-- Завдання 5: Свідома помилка прямого імпорту в цільову таблицю
-- .import --skip 1 v2_new_rows.csv products