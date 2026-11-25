-- Практична робота №15
-- Тема: Створення індексів та аналіз ефективності запитів
-- Варіант 3: база даних кінотеатру
-- Файл бази даних: lab_work_15.db
--
-- Увага: виконуйте цей скрипт на копії lab_work_14.db,
-- збереженій як lab_work_15.db. Якщо індекси вже створені під час
-- покрокового виконання практичної, видаліть їх перед повторним запуском
-- або використовуйте цей файл як звітний сценарій.

-- =========================================================
-- Завдання 1. Початковий план пошуку за зовнішнім ключем
-- =========================================================

EXPLAIN QUERY PLAN
SELECT * FROM tickets
WHERE viewer_id = 2;

-- Отриманий початковий план:
-- (2, 0, 216, 'SCAN tickets')


-- =========================================================
-- Завдання 2. Створення індексу за viewer_id
-- =========================================================

CREATE INDEX IF NOT EXISTS idx_tickets_viewer
ON tickets(viewer_id);

-- Перевірка використання індексу.
-- INDEXED BY використано для контрольованої демонстрації індексу,
-- оскільки таблиця містить мало записів.

EXPLAIN QUERY PLAN
SELECT * FROM tickets INDEXED BY idx_tickets_viewer
WHERE viewer_id = 2;

-- Отриманий план:
-- (3, 0, 61, 'SEARCH tickets USING INDEX idx_tickets_viewer (viewer_id=?)')


-- =========================================================
-- Завдання 3. Композитний індекс за viewer_id та hall
-- =========================================================

-- Початковий план до створення композитного індексу:
-- (2, 0, 216, 'SCAN tickets')
EXPLAIN QUERY PLAN
SELECT * FROM tickets
WHERE viewer_id = 2 AND hall = 2;

CREATE INDEX IF NOT EXISTS idx_tickets_viewer_hall
ON tickets(viewer_id, hall);

EXPLAIN QUERY PLAN
SELECT * FROM tickets INDEXED BY idx_tickets_viewer_hall
WHERE viewer_id = 2 AND hall = 2;

-- Отриманий план:
-- (3, 0, 60, 'SEARCH tickets USING INDEX idx_tickets_viewer_hall (viewer_id=? AND hall=?)')


-- =========================================================
-- Завдання 4. Індекс для сортування за purchase_date
-- =========================================================

-- Початковий план до створення індексу:
-- (3, 0, 216, 'SCAN tickets')
-- (17, 0, 0, 'USE TEMP B-TREE FOR ORDER BY')
EXPLAIN QUERY PLAN
SELECT * FROM tickets
ORDER BY purchase_date;

CREATE INDEX IF NOT EXISTS idx_tickets_purchase_date
ON tickets(purchase_date);

EXPLAIN QUERY PLAN
SELECT * FROM tickets INDEXED BY idx_tickets_purchase_date
ORDER BY purchase_date;

-- Отриманий план:
-- (4, 0, 224, 'SCAN tickets USING INDEX idx_tickets_purchase_date')


-- =========================================================
-- Завдання 5. Видалення індексу та перевірка
-- =========================================================

DROP INDEX IF EXISTS idx_tickets_viewer;

-- Після видалення простого індексу запит використовує
-- композитний індекс, оскільки viewer_id є його першим стовпцем.

EXPLAIN QUERY PLAN
SELECT * FROM tickets INDEXED BY idx_tickets_viewer_hall
WHERE viewer_id = 2;

-- Отриманий план:
-- (3, 0, 61, 'SEARCH tickets USING INDEX idx_tickets_viewer_hall (viewer_id=?)')

-- Перевірка індексів, що залишилися:
SELECT name, sql
FROM sqlite_master
WHERE type = 'index' AND tbl_name = 'tickets'
ORDER BY name;

-- Очікувані індекси:
-- idx_tickets_purchase_date
-- idx_tickets_viewer_hall

-- Кінець практичної роботи №15.
