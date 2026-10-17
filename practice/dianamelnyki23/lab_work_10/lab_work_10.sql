SELECT client_id, COUNT(*) AS sales_count
FROM membership_sales
GROUP BY client_id
HAVING COUNT(*) > 1;

-- Фактичний результат:
-- client_id | sales_count
-- 1         | 2
-- 2         | 2
-- 3         | 2
-- 5         | 2


SELECT type, AVG(price) AS average_price
FROM memberships
GROUP BY type
HAVING AVG(price) > 1000;

-- Фактичний результат:
-- Квартальний | 3000.0
-- Місячний    | 1200.0
-- Річний      | 9500.0


SELECT client_id, COUNT(*) AS sales_count
FROM membership_sales
WHERE purchase_date >= '2026-09-01'
GROUP BY client_id
HAVING COUNT(*) >= 2;

-- Фактичний результат:
-- client_id | sales_count
-- 1         | 2
-- 2         | 2
-- 3         | 2
-- 5         | 2


SELECT client_id, COUNT(*) AS sales_count
FROM membership_sales
WHERE COUNT(*) > 1
GROUP BY client_id;

-- Точний текст помилки, зафіксований під час виконання:
-- Parse error near line 17 of lab_work_10.sql: misuse of aggregate: COUNT()
--   UNT(*) AS sales_count FROM membership_sales WHERE COUNT(*) > 1 GROUP BY client
--                                       error here ---^


SELECT
    clients.id,
    clients.last_name,
    clients.first_name,
    COUNT(membership_sales.id) AS sales_count
FROM clients
LEFT JOIN membership_sales
    ON clients.id = membership_sales.client_id
GROUP BY clients.id
HAVING COUNT(membership_sales.id) < 2;

-- Фактичний результат:
-- id | last_name | first_name | sales_count
-- 4  | Бондар    | Олександр  | 1
-- 6  | Романюк   | Іван       | 1
