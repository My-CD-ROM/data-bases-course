-- Практична робота №12

-- Завдання 1. Сортування за однією колонкою

SELECT
    id,
    client_id,
    purchase_date,
    expiration_date
FROM membership_sales
ORDER BY purchase_date DESC;

-- Результат:
-- id | client_id | purchase_date | expiration_date
-- 9  | 2         | 2026-09-11    | 2026-10-10
-- 7  | 6         | 2026-09-08    | 2026-10-10
-- 6  | 5         | 2026-09-07    | 2027-09-07
-- 5  | 4         | 2026-09-06    | 2027-03-05
-- 3  | 3         | 2026-09-03    | 2026-10-02
-- 2  | 2         | 2026-09-02    | 2026-09-08


-- Завдання 2. Сортування за двома колонками

SELECT
    id,
    membership_id,
    client_id,
    purchase_date
FROM membership_sales
ORDER BY
    membership_id ASC,
    purchase_date DESC;

-- Результат:
-- id | membership_id | client_id | purchase_date
-- 2  | 2             | 2         | 2026-09-02
-- 9  | 3             | 2         | 2026-09-11
-- 7  | 3             | 6         | 2026-09-08
-- 3  | 3             | 3         | 2026-09-03
-- 5  | 5             | 4         | 2026-09-06
-- 6  | 6             | 5         | 2026-09-07


-- Завдання 3. Вибір трьох найновіших продажів

SELECT
    id,
    client_id,
    purchase_date,
    expiration_date
FROM membership_sales
ORDER BY purchase_date DESC
LIMIT 3;

-- Результат:
-- id | client_id | purchase_date | expiration_date
-- 9  | 2         | 2026-09-11    | 2026-10-10
-- 7  | 6         | 2026-09-08    | 2026-10-10
-- 6  | 5         | 2026-09-07    | 2027-09-07


-- Завдання 4.1. Унікальні типи абонементів

SELECT DISTINCT
    type
FROM memberships
ORDER BY type;

-- Результат: 9 унікальних типів
-- VIP
-- Квартальний
-- Місячний
-- Пробний
-- Піврічний
-- Разовий
-- Річний
-- Тестовий
-- Тижневий


-- Завдання 4.2. Абонементи тривалістю від 7 до 90 днів

SELECT
    id,
    type,
    duration_days
FROM memberships
WHERE duration_days BETWEEN 7 AND 90
ORDER BY duration_days ASC;

-- Результат:
-- id | type        | duration_days
-- 2  | Тижневий    | 7
-- 9  | VIP         | 15
-- 3  | Місячний    | 30
-- 4  | Квартальний | 90


-- Завдання 5.1. Пошук із маленької кириличної літери

SELECT
    id,
    last_name,
    first_name
FROM clients
WHERE last_name LIKE 'м%';

-- Результат: 0 рядків


-- Завдання 5.2. Пошук із великої кириличної літери

SELECT
    id,
    last_name,
    first_name
FROM clients
WHERE last_name LIKE 'М%';

-- Результат:
-- id | last_name | first_name
-- 3  | Мельник   | Анна