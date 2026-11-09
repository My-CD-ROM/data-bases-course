-- Практична робота №10. Відбір груп за допомогою HAVING
-- Варіант 3: Cinema
-- База даних: lab_work_10.db

-- Завдання 1. HAVING з COUNT()
SELECT movie_id, COUNT(*) AS tickets_count
FROM tickets
GROUP BY movie_id
HAVING COUNT(*) > 1;

-- Фактичний результат:
-- movie_id | tickets_count
-- 1        | 2


-- Завдання 2. HAVING з AVG()
SELECT movie_id, AVG(price) AS average_price
FROM tickets
GROUP BY movie_id
HAVING AVG(price) > 180;

-- Фактичний результат:
-- movie_id | average_price
-- 1        | 185.0
-- 2        | 200.0


-- Завдання 3. WHERE + GROUP BY + HAVING
SELECT
    movie_id,
    COUNT(*) AS tickets_count,
    AVG(price) AS average_price
FROM tickets
WHERE price >= 180
GROUP BY movie_id
HAVING AVG(price) > 180;

-- Фактичний результат:
-- movie_id | tickets_count | average_price
-- 1        | 2             | 185.0
-- 2        | 1             | 200.0


-- Завдання 4. Навмисна помилка: агрегатна функція у WHERE
SELECT movie_id, COUNT(*) AS tickets_count
FROM tickets
WHERE COUNT(*) > 1
GROUP BY movie_id;

-- Точне повідомлення SQLite:
-- Execution finished with errors.
-- Result: misuse of aggregate: COUNT()


-- Завдання 5. LEFT JOIN + GROUP BY + HAVING
SELECT
    movies.id,
    movies.title,
    COUNT(tickets.id) AS tickets_count
FROM movies
LEFT JOIN tickets ON tickets.movie_id = movies.id
GROUP BY movies.id
HAVING COUNT(tickets.id) < 2
ORDER BY movies.id;

-- Фактичний результат:
-- 2 | Inception                                | 1
-- 3 | Titanic                                  | 1
-- 4 | Harry Potter and the Philosopher's Stone | 1
-- 5 | Lion King                                | 0
-- 6 | Matrix                                   | 0
