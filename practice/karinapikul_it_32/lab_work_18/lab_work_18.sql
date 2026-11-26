
-- Практична робота №18

-- Завдання 1. Похідне числове значення
ALTER TABLE memberships
ADD COLUMN price_per_day REAL
GENERATED ALWAYS AS (price / duration_days) VIRTUAL;

SELECT id, type, price, duration_days, price_per_day
FROM memberships;

-- Завдання 2. Похідний логічний прапорець
ALTER TABLE memberships
ADD COLUMN is_yearly INTEGER
GENERATED ALWAYS AS (type = 'Річний') VIRTUAL;

SELECT id, type, is_yearly
FROM memberships;

-- Завдання 3. Свідома помилка прямого запису
UPDATE memberships
SET price_per_day = 100
WHERE id = 1;

-- Отримана помилка:
-- Parse error: cannot UPDATE generated column "price_per_day"

-- Завдання 4. Автоматичний перерахунок
-- Перевірка до зміни
SELECT id, type, price, duration_days, price_per_day
FROM memberships
WHERE id = 2;

-- Зміна базової колонки
UPDATE memberships
SET price = 700
WHERE id = 2;

-- Перевірка після зміни
SELECT id, type, price, duration_days, price_per_day
FROM memberships
WHERE id = 2;

-- Завдання 5. WHERE за згенерованим стовпцем
SELECT id, type, price_per_day
FROM memberships
WHERE price_per_day > 50;
