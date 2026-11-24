
-- Практична робота 8. Агрегатні функції
-- Варіант 3 — Кінотеатр

-- Завдання 1
SELECT
    COUNT(*) AS усі_квитки,
    COUNT(purchase_date) AS квитки_з_датою
FROM tickets;

-- Результат: 10 | 10
-- NULL відсутні. Спроба UPDATE purchase_date = NULL
-- завершилася помилкою NOT NULL constraint failed.

-- Завдання 2
SELECT
    SUM(price) AS загальна_виручка,
    AVG(price) AS середня_ціна
FROM tickets;

-- Результат: 1660.0 | 166.0

-- Завдання 3
SELECT
    MIN(last_name) AS перше_прізвище,
    MAX(last_name) AS останнє_прізвище
FROM viewers;

-- Результат: Бондаренко | Шевченко

-- Завдання 4
SELECT
    COUNT(*) AS кількість_квитків,
    SUM(price) AS загальна_виручка,
    AVG(price) AS середня_ціна,
    MIN(price) AS найдешевший_квиток,
    MAX(price) AS найдорожчий_квиток
FROM tickets;

-- Результат: 10 | 1660.0 | 166.0 | 150.0 | 190.0

-- Завдання 5
SELECT
    COUNT(tickets.id) AS кількість_квитків,
    SUM(tickets.price) AS загальна_виручка,
    AVG(tickets.price) AS середня_ціна
FROM tickets
INNER JOIN movies ON tickets.movie_id = movies.id
WHERE movies.genre = 'драма';

-- Результат: 5 | 830.0 | 166.0

-- Контрольне питання 3
SELECT SUM(x) AS сума
FROM (
    SELECT NULL AS x
    UNION ALL
    SELECT NULL
    UNION ALL
    SELECT NULL
);

-- Результат: NULL
