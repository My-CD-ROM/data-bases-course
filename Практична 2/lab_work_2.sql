-- Практична робота №2
-- Формування запитів вибірки у SQLite
-- Таблиця: university

-- Завдання 1. SELECT з явним переліком стовпців
SELECT last_name, first_name, group_name, admission_year
FROM university;

-- Завдання 2. WHERE за умовою
-- Студенти, які вступили після 2023 року
SELECT last_name, first_name, admission_year
FROM university
WHERE admission_year > 2023;

-- Завдання 3. LIMIT
-- Перші 3 записи
SELECT id, last_name, first_name, group_name
FROM university
LIMIT 3;

-- Завдання 4. IS NULL / IS NOT NULL
-- Додатковий рядок із невідомою групою вже доданий у lab_work_2.db.

-- Записи, у яких група не вказана
SELECT id, last_name, first_name, group_name
FROM university
WHERE group_name IS NULL;

-- Записи, у яких група вказана
SELECT id, last_name, first_name, group_name
FROM university
WHERE group_name IS NOT NULL;

-- Завдання 5. Складена умова
-- Студенти групи ІТ-21, які вступили після 2023 року
SELECT last_name, first_name, group_name, admission_year
FROM university
WHERE group_name = 'ІТ-21'
  AND admission_year > 2023;
