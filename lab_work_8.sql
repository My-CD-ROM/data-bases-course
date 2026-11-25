-- Практика 8. Застосування агрегатних функцій
-- Варіант 3. Предметна область: Кінотеатр
-- Таблиці: movies, viewers, tickets
-- Структура бази даних не змінюється.

-- Перевірка структури фактової таблиці та обмежень NOT NULL
PRAGMA table_info(tickets);

-- =========================================================
-- Завдання 1. COUNT(*) проти COUNT(колонка)
-- =========================================================
SELECT
    COUNT(*) AS total_tickets,
    COUNT(purchase_date) AS tickets_with_purchase_date
FROM tickets;
-- Результат: 5 і 5.
-- purchase_date має обмеження NOT NULL, тому встановити NULL через UPDATE
-- без зміни структури таблиці неможливо.

-- Демонстрація COUNT на виразі, який повертає NULL для одного рядка:
SELECT
    COUNT(*) AS total_tickets,
    COUNT(CASE WHEN id <> 5 THEN purchase_date END) AS count_non_null_expression
FROM tickets;
-- Результат: 5 і 4. Це демонструє ігнорування NULL функцією COUNT,
-- але не змінює реальні дані таблиці.

-- =========================================================
-- Завдання 2. SUM і AVG на числовій колонці
-- =========================================================
SELECT
    SUM(price) AS total_revenue,
    AVG(price) AS average_ticket_price
FROM tickets;
-- Результат: 890.0 і 178.0.

-- =========================================================
-- Завдання 3. MIN/MAX на текстовій колонці
-- =========================================================
SELECT
    MIN(title) AS first_movie_alphabetically,
    MAX(title) AS last_movie_alphabetically
FROM movies;
-- Результат: Harry Potter and the Philosopher's Stone; Titanic.
-- SQLite використовує текстове порівняння за правилом BINARY за замовчуванням.

-- =========================================================
-- Завдання 4. Кілька агрегатних функцій в одному запиті
-- =========================================================
SELECT
    COUNT(*) AS tickets_count,
    SUM(price) AS total_revenue,
    AVG(price) AS average_price,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM tickets;
-- Результат: 5; 890.0; 178.0; 150.0; 200.0.

-- =========================================================
-- Завдання 5. Агрегат + WHERE за таблицею-виміром movies
-- =========================================================
SELECT
    COUNT(t.id) AS scifi_tickets,
    SUM(t.price) AS scifi_revenue,
    AVG(t.price) AS scifi_average_price
FROM tickets AS t
INNER JOIN movies AS m ON t.movie_id = m.id
WHERE m.genre = 'Sci-Fi';
-- Результат: 3; 570.0; 190.0.
-- Три квитки належать до двох Sci-Fi фільмів: два на Interstellar і один на Inception.

-- =========================================================
-- Контрольне питання 3. SUM, якщо всі значення NULL
-- =========================================================
SELECT SUM(NULLIF(price, price)) AS sum_all_null
FROM tickets;
-- Результат: NULL. NULLIF(price, price) повертає NULL для кожного рядка.
