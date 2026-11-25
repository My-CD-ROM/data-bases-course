-- Практична робота №18
-- Тема: Згенеровані стовпці у SQLite
-- Варіант 3: Кінотеатр
-- Базу lab_work_18.db попередньо створено копіюванням lab_work_17.db.
-- Скрипт фіксує виконані команди та результати перевірок.

.headers on
.mode box

-- 1. Додаємо VIRTUAL-стовпець ціни квитка з ПДВ 20%.
ALTER TABLE tickets
ADD COLUMN price_with_vat REAL
GENERATED ALWAYS AS (price * 1.2) VIRTUAL;

-- Перевірка першого згенерованого стовпця.
SELECT id, price, price_with_vat
FROM tickets;

-- 2. Додаємо VIRTUAL-стовпець, який показує, чи є жанр фільму "драма".
ALTER TABLE movies
ADD COLUMN is_drama INTEGER
GENERATED ALWAYS AS (genre = 'драма') VIRTUAL;

-- Перевірка другого згенерованого стовпця.
SELECT id, title, genre, is_drama
FROM movies;

-- 3. Перевіряємо заборону ручного оновлення згенерованого стовпця.
-- Очікувана помилка SQLite:
-- cannot UPDATE generated column "price_with_vat"
-- Команду наведено як частину звіту; під час повторного запуску
-- вона навмисно завершується помилкою.
UPDATE tickets
SET price_with_vat = 300
WHERE id = 1;

-- 4. Перевіряємо початкове значення квитка №1.
-- Було: price = 180.0, price_with_vat = 216.0.
SELECT id, price, price_with_vat
FROM tickets
WHERE id = 1;

-- Змінюємо базовий стовпець price.
UPDATE tickets
SET price = price + 20
WHERE id = 1;

-- Після зміни: price = 200.0, price_with_vat = 240.0.
SELECT id, price, price_with_vat
FROM tickets
WHERE id = 1;

-- 5. Фільтруємо квитки за згенерованим стовпцем.
SELECT id, price, price_with_vat
FROM tickets
WHERE price_with_vat > 200;

-- Кінець практичної роботи №18.
