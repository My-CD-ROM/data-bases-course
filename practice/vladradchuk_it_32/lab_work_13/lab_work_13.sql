
-- Практика 13. Форматування таблиць за допомогою printf і дат
-- Варіант 3: Кінотеатр

-- Завдання 1. Форматування ціни через printf()
SELECT
    id,
    price AS raw_price,
    printf('%.2f грн', price) AS formatted_price
FROM tickets;

-- Завдання 2. printf() з вирівнюванням ширини
SELECT
    id,
    price,
    printf('%8.2f грн', price) AS aligned_price
FROM tickets;

-- Завдання 3. Зсув дати на 30 днів
SELECT
    id,
    purchase_date,
    date(purchase_date, '+30 days') AS date_after_30_days
FROM tickets;

-- Завдання 4. Групування кількості квитків за роком
SELECT
    strftime('%Y', purchase_date) AS purchase_year,
    COUNT(*) AS tickets_count
FROM tickets
GROUP BY purchase_year
ORDER BY purchase_year;

-- Завдання 5. Перевірка некоректної дати
SELECT
    strftime('%Y', 'not-a-date') AS invalid_year,
    date('not-a-date') AS invalid_date;
