-- Практика 13. Форматування таблиць за допомогою printf і дат
-- УВАГА: замініть назви таблиць і колонок нижче на ті, що є у вашій БД.
-- Після виконання запитів скопіюйте їхні результати в коментарі після кожного запиту.

-- Завдання 1. printf() для числової колонки
-- Замініть fact_table і numeric_column на фактову таблицю та числову колонку свого варіанта.
SELECT numeric_column AS raw_value,
       printf('%.2f грн', numeric_column) AS formatted_value
FROM fact_table;

-- Якщо колонка ціла (наприклад, кількість примірників), можна використати:
-- SELECT copies_count AS raw_value,
--        printf('%d прим.', copies_count) AS formatted_value
-- FROM books;

-- Завдання 2. printf() з вирівнюванням
SELECT numeric_column AS raw_value,
       printf('%8.2f', numeric_column) AS aligned_value
FROM fact_table;

-- Завдання 3. Зсув дати відносно наявної
-- Замініть date_column на дату у вашій фактовій таблиці.
SELECT date_column AS original_date,
       date(date_column, '+30 days') AS shifted_date
FROM fact_table;

-- Завдання 4. Групування за роком
SELECT strftime('%Y', date_column) AS year,
       COUNT(*) AS records_count
FROM fact_table
GROUP BY strftime('%Y', date_column)
ORDER BY year;

-- Альтернатива: групування за місяцем (формат YYYY-MM)
-- SELECT strftime('%Y-%m', date_column) AS year_month,
--        COUNT(*) AS records_count
-- FROM fact_table
-- GROUP BY strftime('%Y-%m', date_column)
-- ORDER BY year_month;

-- Завдання 5. Свідома помилка з некоректною датою
SELECT 'not-a-date' AS input_value,
       date('not-a-date') AS date_result,
       strftime('%Y', 'not-a-date') AS year_result;
-- У SQLite date() і strftime() для такого некоректного рядка зазвичай повертають NULL,
-- а не повідомлення про помилку.
