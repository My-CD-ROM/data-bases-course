-- Практика 9. Формування запитів з групуванням даних
-- Варіант 3: Cinema
-- Фактова таблиця: tickets
-- Таблиці-виміри: movies, viewers
-- Структура бази даних не змінюється.

-- =========================================================
-- Завдання 1. GROUP BY за одним зовнішнім ключем
-- =========================================================
SELECT
    movie_id,
    COUNT(*) AS tickets_count
FROM tickets
GROUP BY movie_id;

-- Результат:
-- movie_id | tickets_count
-- 1        | 2
-- 2        | 1
-- 3        | 1
-- 4        | 1


-- =========================================================
-- Завдання 2. JOIN + GROUP BY
-- =========================================================
SELECT
    movies.id,
    movies.title,
    COUNT(tickets.id) AS tickets_count
FROM movies
LEFT JOIN tickets ON tickets.movie_id = movies.id
GROUP BY movies.id;

-- Результат:
-- id | title                                      | tickets_count
-- 1  | Interstellar                              | 2
-- 2  | Inception                                 | 1
-- 3  | Titanic                                   | 1
-- 4  | Harry Potter and the Philosopher's Stone  | 1
-- 5  | Lion King                                 | 0
-- 6  | Matrix                                    | 0


-- =========================================================
-- Завдання 3. Дві агрегатні функції в одній групі
-- =========================================================
SELECT
    movies.id,
    movies.title,
    COUNT(tickets.id) AS tickets_count,
    AVG(tickets.price) AS average_price
FROM movies
LEFT JOIN tickets ON tickets.movie_id = movies.id
GROUP BY movies.id;

-- Результат:
-- id | title                                      | tickets_count | average_price
-- 1  | Interstellar                              | 2             | 185.0
-- 2  | Inception                                 | 1             | 200.0
-- 3  | Titanic                                   | 1             | 170.0
-- 4  | Harry Potter and the Philosopher's Stone  | 1             | 150.0
-- 5  | Lion King                                 | 0             | NULL
-- 6  | Matrix                                    | 0             | NULL


-- =========================================================
-- Завдання 4. GROUP BY за двома колонками
-- =========================================================
SELECT
    hall,
    purchase_date,
    COUNT(*) AS tickets_count,
    AVG(price) AS average_price
FROM tickets
GROUP BY hall, purchase_date
ORDER BY hall, purchase_date;

-- Результат:
-- hall | purchase_date | tickets_count | average_price
-- 1    | 2026-09-28    | 1             | 180.0
-- 1    | 2026-09-29    | 1             | 170.0
-- 1    | 2026-09-30    | 1             | 190.0
-- 2    | 2026-09-29    | 1             | 200.0
-- 3    | 2026-09-30    | 1             | 150.0

-- Кількість унікальних залів: 3
SELECT COUNT(DISTINCT hall) AS unique_halls
FROM tickets;

-- Результат: 3

-- Кількість унікальних дат придбання: 3
SELECT COUNT(DISTINCT purchase_date) AS unique_dates
FROM tickets;

-- Результат: 3


-- =========================================================
-- Завдання 5. Колонка поза GROUP BY (особливість SQLite)
-- =========================================================
SELECT
    movie_id,
    seat,
    COUNT(*) AS tickets_count
FROM tickets
GROUP BY movie_id;

-- Результат першого запуску:
-- movie_id | seat | tickets_count
-- 1        | A1   | 2
-- 2        | B5   | 1
-- 3        | C3   | 1
-- 4        | D4   | 1

-- Результат другого запуску:
-- movie_id | seat | tickets_count
-- 1        | A1   | 2
-- 2        | B5   | 1
-- 3        | C3   | 1
-- 4        | D4   | 1

-- У двох запусках значення seat збіглися. SQLite дозволяє такий
-- запит, але значення неагрегованої колонки поза GROUP BY не
-- визначене однозначно. Не слід покладатися на нього.
-- PostgreSQL відхилить цей запит, оскільки seat не входить
-- до GROUP BY і не використовується в агрегатній функції.
