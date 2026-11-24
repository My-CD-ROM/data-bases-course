-- Практична робота 13
-- Форматування таблиць за допомогою printf і дат

-- Завдання 1. printf() для числової колонки
SELECT
    id,
    title,
    copies_count AS raw_value,
    printf('%d прим.', copies_count) AS formatted_value
FROM books;

-- Завдання 2. printf() з вирівнюванням
SELECT
    id,
    title,
    printf('%5d', copies_count) AS aligned_value
FROM books;

-- Завдання 3. Зсув дати на 7 днів
SELECT
    id,
    loan_date,
    date(loan_date, '+7 days') AS extended_date
FROM loans;

-- Завдання 4. Кількість видач книг за роком
SELECT
    strftime('%Y', loan_date) AS year,
    COUNT(*) AS loans_count
FROM loans
GROUP BY year
ORDER BY year;

-- Завдання 5. Перевірка некоректної дати
SELECT
    strftime('%Y', 'not-a-date') AS invalid_year,
    date('not-a-date', '+7 days') AS invalid_date;