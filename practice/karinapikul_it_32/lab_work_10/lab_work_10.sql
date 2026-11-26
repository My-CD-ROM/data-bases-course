
--Практична робота №10

-- Завдання 1. Вибір груп, у яких більше одного продажу
SELECT membership_id, COUNT(*) AS sales_count
FROM membership_sales
GROUP BY membership_id
HAVING COUNT(*) > 1;

-- Результат:
-- 3|3

-- Завдання 2. Використання MAX() замість COUNT()
SELECT client_id, MAX(purchase_date) AS last_purchase
FROM membership_sales
GROUP BY client_id
HAVING MAX(purchase_date) >= '2026-09-08';

-- Результат:
-- 2|2026-09-11
-- 6|2026-09-08

-- Завдання 3. Використання WHERE, GROUP BY та HAVING
SELECT membership_id, COUNT(*) AS sales_count
FROM membership_sales
WHERE purchase_date >= '2026-09-06'
GROUP BY membership_id
HAVING COUNT(*) > 1;

-- Результат:
-- 3|2

-- Завдання 4. Помилковий запит: агрегат у WHERE
-- SELECT membership_id, COUNT(*) AS sales_count
-- FROM membership_sales
-- WHERE COUNT(*) > 1
-- GROUP BY membership_id;

-- Результат:
-- Помилка SQLite: misuse of aggregate: COUNT()
  -- Причина: агрегатну функцію не можна використовувати в WHERE.

-- Завдання 5. Абонементи, продані менше двох разів
SELECT memberships.id, memberships.type,
       COUNT(membership_sales.id) AS sales_count
FROM memberships
LEFT JOIN membership_sales
    ON memberships.id = membership_sales.membership_id
GROUP BY memberships.id
HAVING COUNT(membership_sales.id) < 2;

-- Результат:
-- 1|Разовий|0
-- 2|Тижневий|1
-- 4|Квартальний|0
-- 5|Піврічний|1
-- 6|Річний|1
-- 7|Пробний|0
-- 8|Тестовий|0
-- 9|VIP|0