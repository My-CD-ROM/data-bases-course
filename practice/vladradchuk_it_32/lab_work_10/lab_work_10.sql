
-- Практика 10. Відбір груп за допомогою HAVING
-- Варіант 3: Кінотеатр

-- Завдання 1. HAVING на COUNT
SELECT
    movie_id,
    COUNT(*) AS tickets_count
FROM tickets
GROUP BY movie_id
HAVING COUNT(*) > 1;



-- Завдання 2. HAVING на AVG
SELECT
    movie_id,
    ROUND(AVG(price), 2) AS average_price
FROM tickets
GROUP BY movie_id
HAVING AVG(price) > 150;



-- Завдання 3. WHERE + GROUP BY + HAVING
SELECT
    movie_id,
    COUNT(*) AS tickets_count,
    ROUND(AVG(price), 2) AS average_price
FROM tickets
WHERE price >= 150
GROUP BY movie_id
HAVING COUNT(*) > 1;


-- Завдання 4. Свідома помилка WHERE з агрегатом
-- Запит навмисно неправильний.
-- SELECT
--     movie_id,
--     COUNT(*) AS tickets_count
-- FROM tickets
-- WHERE COUNT(*) > 1
-- GROUP BY movie_id;

-- Точний отриманий текст помилки:
-- Parse error near line 25: misuse of aggregate: COUNT()
--        COUNT(*) AS tickets_count FROM tickets WHERE COUNT(*) > 1 GROUP BY movie_


-- Завдання 5. LEFT JOIN + GROUP BY + HAVING
SELECT
    viewers.id,
    viewers.first_name,
    viewers.last_name,
    COUNT(tickets.id) AS tickets_count
FROM viewers
LEFT JOIN tickets ON viewers.id = tickets.viewer_id
GROUP BY viewers.id
HAVING COUNT(tickets.id) < 2;

-- Результат:
-- 5 | Дмитро | Ткаченко  | 1
-- 6 | Марія  | Кравченко | 1

-- LEFT JOIN зберігає глядачів без квитків.
-- COUNT(tickets.id) рахує лише наявні квитки.
