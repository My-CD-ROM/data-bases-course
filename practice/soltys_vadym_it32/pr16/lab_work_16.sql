-- Практика 16. Імпорт CSV (варіант 2, інтернет-магазин одягу; цільова таблиця products)
-- Команди, що починаються з крапки, виконуються в консолі sqlite3 (CLI).
-- Файл: v2_new_rows.csv (заголовок name,category,size,price,stock_quantity + 8 рядків)

-- Завдання 1. Підрахунок до імпорту
SELECT COUNT(*) FROM products;
-- Результат: 8

-- Завдання 2. Проміжна таблиця й імпорт
CREATE TABLE products_staging (
    name TEXT,
    category TEXT,
    size TEXT,
    price REAL,
    stock_quantity INTEGER
);
.mode csv
.import --skip 1 v2_new_rows.csv products_staging
SELECT * FROM products_staging;
-- Результат: 8 рядків, заголовків серед них немає
-- (Худі оверсайз, Спортивні штани, Светр вовняний, Шорти літні,
--  Пальто осіннє, Блуза шовкова, Кеди класичні, Рукавички шкіряні)

-- Завдання 3. Перенесення в реальну таблицю і видалення проміжної
INSERT INTO products (name, category, size, price, stock_quantity)
SELECT name, category, size, price, stock_quantity FROM products_staging;
DROP TABLE products_staging;
SELECT COUNT(*) FROM products;
-- Результат: 16  (приріст 16 - 8 = 8 = кількість рядків CSV)

-- Завдання 4. Перевірка конкретних нових рядків
SELECT id, name, category, size, price, stock_quantity
FROM products
WHERE name IN ('Худі оверсайз', 'Спортивні штани', 'Светр вовняний', 'Шорти літні',
               'Пальто осіннє', 'Блуза шовкова', 'Кеди класичні', 'Рукавички шкіряні');
-- Результат: id 9, 10, 11, 12, 13, 14, 15, 16 (нумерація продовжила id 1-8)
SELECT name FROM sqlite_master WHERE name = 'products_staging';
-- Результат: 0 рядків (проміжну таблицю видалено)

-- Завдання 5. Свідомий прямий імпорт у products (виконано на окремій копії бази, не в робочій)
.mode csv
.import --skip 1 v2_new_rows.csv products
-- Повідомлення SQLite (для кожного з 8 рядків файлу, номери :2 ... :9):
-- v2_new_rows.csv:2: expected 6 columns but found 5 - filling the rest with NULL
-- v2_new_rows.csv:2: INSERT failed: datatype mismatch
-- ... (аналогічно для рядків :3, :4, :5, :6, :7, :8, :9)
SELECT COUNT(*) FROM products;
-- Результат на копії: 8 (жоден рядок не додався)
