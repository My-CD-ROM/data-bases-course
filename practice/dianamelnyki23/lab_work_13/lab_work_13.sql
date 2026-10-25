-- Практика 13. Форматування таблиць за допомогою printf і дат
-- Варіант 7: Фітнес-клуб
-- Структура бази даних не змінюється.

.headers on
.mode column

-- Завдання 1. printf(): ціна з двома знаками після крапки.
SELECT type, price,
       printf('%.2f грн', price) AS formatted_price
FROM memberships
ORDER BY price;

-- Завдання 2. printf(): ціна з мінімальною шириною поля.
SELECT type, price,
       printf('%8.2f', price) AS aligned_price
FROM memberships
ORDER BY price;

-- Завдання 3. Зсув дати придбання на 7 днів.
SELECT id, client_id, purchase_date,
       date(purchase_date, '+7 days') AS date_after_7_days
FROM membership_sales
ORDER BY purchase_date;

-- Завдання 4. Кількість продажів за місяцем придбання.
SELECT strftime('%Y-%m', purchase_date) AS sale_month,
       COUNT(*) AS sales_count
FROM membership_sales
GROUP BY sale_month
ORDER BY sale_month;

-- Завдання 5. Перевірка некоректної дати.
SELECT strftime('%Y', 'not-a-date') AS invalid_date_year,
       date('not-a-date', '+7 days') AS invalid_date_shift;
