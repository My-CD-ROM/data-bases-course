-- =====================================================
-- Практика 9. Формування запитів з групуванням даних
-- Варіант 3: Кінотеатр
-- =====================================================

-- Завдання 1. GROUP BY за однією колонкою

SELECT
    movie_id,
    COUNT(*) AS tickets_count
FROM tickets
GROUP BY movie_id;

-- Результат:
-- 1 | 2
-- 2 | 2
-- 3 | 2
-- 4 | 1
-- 5 | 2
-- 6 | 1


-- Завдання 2. JOIN + GROUP BY

SELECT
    movies.id,
    movies.title,
    COUNT(tickets.id) AS tickets_count
FROM movies
LEFT JOIN tickets ON tickets.movie_id = movies.id
GROUP BY movies.id;

-- Результат:
-- 1 | Тіні забутих предків | 2
-- 2 | Захар Беркут | 2
-- 3 | Мавка. Лісова пісня | 2
-- 4 | Я, Ти, Він, Вона | 1
-- 5 | Атлантида | 2
-- 6 | Памфір | 1
-- 7 | Тестовий фільм | 0


-- Завдання 3. Кілька агрегатних функцій

SELECT
    movies.id,
    movies.title,
    COUNT(tickets.id) AS tickets_count,
    ROUND(AVG(tickets.price), 2) AS average_price
FROM movies
LEFT JOIN tickets ON tickets.movie_id = movies.id
GROUP BY movies.id;

-- Результат:
-- 1 | Тіні забутих предків | 2 | 150.0
-- 2 | Захар Беркут | 2 | 180.0
-- 3 | Мавка. Лісова пісня | 2 | 160.0
-- 4 | Я, Ти, Він, Вона | 1 | 150.0
-- 5 | Атлантида | 2 | 170.0
-- 6 | Памфір | 1 | 190.0
-- 7 | Тестовий фільм | 0 | NULL


-- Завдання 4. GROUP BY за двома колонками

SELECT
    movie_id,
    hall,
    COUNT(*) AS tickets_count,
    ROUND(AVG(price), 2) AS average_price
FROM tickets
GROUP BY movie_id, hall
ORDER BY movie_id, hall;

-- Результат:
-- 1 | 1 | 1 | 150.0
-- 1 | 2 | 1 | 150.0
-- 2 | 1 | 2 | 180.0
-- 3 | 2 | 2 | 160.0
-- 4 | 2 | 1 | 150.0
-- 5 | 1 | 2 | 170.0
-- 6 | 1 | 1 | 190.0


-- Завдання 5. Колонка поза GROUP BY

-- Перший запуск
SELECT
    movie_id,
    seat,
    COUNT(*) AS tickets_count
FROM tickets
GROUP BY movie_id;

-- Результат:
-- 1 | A1 | 2
-- 2 | A2 | 2
-- 3 | B1 | 2
-- 4 | B2 | 1
-- 5 | C1 | 2
-- 6 | C2 | 1


-- Другий запуск того самого запиту
SELECT
    movie_id,
    seat,
    COUNT(*) AS tickets_count
FROM tickets
GROUP BY movie_id;

-- Результат другого запуску такий самий.
-- SQLite не гарантує значення колонки seat,
-- яка не входить до GROUP BY.
