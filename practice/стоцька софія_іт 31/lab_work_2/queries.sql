SELECT id, name, price, form
FROM medicines;

-- Завдання 2
SELECT name, price FROM medicines WHERE price > 100;

-- Завдання 3
SELECT * FROM medicines LIMIT 3;

--Завдання 4
INSERT INTO medicines (name, manufacturer, form, price) 
VALUES ('Аспірин', 'Фармак', NULL, 45.50);

SELECT name, price, form 
FROM medicines 
WHERE form IS NULL;

SELECT name, price, form 
FROM medicines 
WHERE form IS NOT NULL;

SELECT name, price, form 
FROM medicines 
WHERE price > 50 AND (price < 200 OR form IS NOT NULL);



-- 1. Чому WHERE price = NULL повертає порожній результат і що писати замість цього?
-- NULL означає «невідоме значення». Будь-яке порівняння з NULL через "=" завжди повертає UNKNOWN (невідомо), 
-- а блок WHERE відбирає лише значення TRUE.
-- Замість цього потрібно використовувати спеціальний оператор: IS NULL
SELECT * FROM products WHERE price IS NULL;

-- 2. Чим WHERE принципово відрізняється від HAVING?
-- WHERE фільтрує окремі рядки таблиці ДО групування (не може містити агрегатні функції).
-- HAVING фільтрує вже сформовані групи ПІСЛЯ виконання GROUP BY (використовується з SUM, AVG, COUNT тощо).

-- 3. У якому випадку варто уникати SELECT * і чому?
-- Уникати у продуктовому коді та реальних проєктах.
-- Причини: перевантажує мережу й пам'ять зайвими даними, знижує швидкість запиту (унеможливлює використання індексів) 
-- та може зламати код програми при зміні структури/порядку стовпців у таблиці.