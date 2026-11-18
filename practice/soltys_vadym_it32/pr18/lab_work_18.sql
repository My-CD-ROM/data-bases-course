-- Практика 18. Згенеровані стовпці (варіант 2, інтернет-магазин одягу; таблиця products)

-- Завдання 1. Числовий VIRTUAL-стовпець: ціна з ПДВ 20%
ALTER TABLE products ADD COLUMN price_with_vat REAL
    GENERATED ALWAYS AS (round(price * 1.2, 2)) VIRTUAL;
SELECT id, name, price, price_with_vat FROM products;
-- Результат (приклад): 1 Футболка базова 299.0 | 358.8 ; 4 Сукня літня 650.0 | 780.0 ;
--                      3 Куртка зимова 2499.0 | 2998.8 ; 24 Чоботи шкіряні 3400.0 | 4080

-- Завдання 2. Логічний VIRTUAL-прапорець: товару мало на складі (менше 10 одиниць)
ALTER TABLE products ADD COLUMN low_stock INTEGER
    GENERATED ALWAYS AS (stock_quantity < 10) VIRTUAL;
SELECT id, name, stock_quantity, low_stock FROM products;
-- low_stock = 1 для id 3 (6), 13 (6), 19 (9), 22 (8), 24 (5); для решти 0 (напр. id 11: 10 -> 0)

-- Завдання 3. Свідома помилка: пряме UPDATE у згенеровані стовпці
UPDATE products SET price_with_vat = 1 WHERE id = 1;
-- Помилка SQLite: cannot UPDATE generated column "price_with_vat"
UPDATE products SET low_stock = 1 WHERE id = 1;
-- Помилка SQLite: cannot UPDATE generated column "low_stock"

-- Завдання 4. Автоматичний перерахунок: змінюємо базову колонку price
SELECT id, name, price, price_with_vat FROM products WHERE id = 6;   -- до: 250.0 | 300.0
UPDATE products SET price = 275 WHERE id = 6;
SELECT id, name, price, price_with_vat FROM products WHERE id = 6;   -- після: 275.0 | 330.0

-- Завдання 5. WHERE за згенерованим стовпцем
SELECT id, name, price, price_with_vat
FROM products
WHERE price_with_vat > 1500
ORDER BY price_with_vat DESC;
-- Результат: 8 рядків: Чоботи шкіряні 4080, Пальто осіннє 3840, Куртка зимова 2998.8,
-- Кросівки спортивні 2278.8, Шарф кашеміровий 1740, Кеди класичні 1620, Худі оверсайз 1558.8,
-- Кардиган в'язаний 1536

-- Для контрольних питань (виконано на окремій копії бази):
-- ALTER TABLE products DROP COLUMN price;
-- Помилка: error in table products after drop column: no such column: price
-- ALTER TABLE products ADD COLUMN x REAL GENERATED ALWAYS AS (price*2) STORED;
-- Помилка: cannot add a STORED column
