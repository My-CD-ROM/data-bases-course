PRAGMA foreign_keys = ON;

-- Завдання 1. Атомарна пара INSERT + UPDATE
BEGIN;

INSERT INTO membership_sales (
    id,
    membership_id,
    client_id,
    purchase_date,
    expiration_date
)
SELECT
    COALESCE(MAX(id), 0) + 1,
    (SELECT MIN(id) FROM memberships),
    (SELECT MIN(id) FROM clients),
    '2026-10-30',
    '2026-11-30'
FROM membership_sales;

-- Оновлюю дату завершення щойно створеного продажу
UPDATE membership_sales
SET expiration_date = '2026-12-30'
WHERE id = (SELECT MAX(id) FROM membership_sales);

-- Перевіряю результат до фіксації транзакції
SELECT *
FROM membership_sales
WHERE id = (SELECT MAX(id) FROM membership_sales);

COMMIT;


-- Завдання 2. Свідомий ROLLBACK
BEGIN;

UPDATE membership_sales
SET expiration_date = '2030-01-01'
WHERE id = (SELECT MIN(id) FROM membership_sales);

-- Перевіряю зміну до скасування
SELECT id, expiration_date
FROM membership_sales
WHERE id = (SELECT MIN(id) FROM membership_sales);

ROLLBACK;

-- Перевіряю, що початкову дату відновлено
SELECT id, expiration_date
FROM membership_sales
WHERE id = (SELECT MIN(id) FROM membership_sales);


-- Завдання 3. Проміжний стан усередині транзакції
BEGIN;

UPDATE membership_sales
SET expiration_date = '2031-01-01'
WHERE id = (SELECT MIN(id) FROM membership_sales);

-- Зміна вже видима в цій самій сесії
SELECT id, expiration_date
FROM membership_sales
WHERE id = (SELECT MIN(id) FROM membership_sales);

-- Скасовую зміну, щоб зберегти початкові дані
ROLLBACK;


-- Завдання 4. Успішна зміна та навмисна помилка
BEGIN;

-- Перша команда виконується успішно
INSERT INTO membership_sales (
    id,
    membership_id,
    client_id,
    purchase_date,
    expiration_date
)
SELECT
    COALESCE(MAX(id), 0) + 1,
    (SELECT MIN(id) FROM memberships),
    (SELECT MIN(id) FROM clients),
    '2026-10-31',
    '2026-11-30'
FROM membership_sales;

-- Друга команда має викликати помилку UNIQUE,
-- якщо запис з id = 1 вже існує
INSERT INTO membership_sales (
    id,
    membership_id,
    client_id,
    purchase_date,
    expiration_date
)
VALUES (
    1,
    (SELECT MIN(id) FROM memberships),
    (SELECT MIN(id) FROM clients),
    '2026-11-01',
    '2026-12-01'
);

-- Виконай цей SELECT окремо після помилки
SELECT *
FROM membership_sales
WHERE id = (SELECT MAX(id) FROM membership_sales);

-- Заверши транзакцію скасуванням
ROLLBACK;


-- Завдання 5. Та сама помилка, але з COMMIT
BEGIN;

-- Перша команда виконується успішно
INSERT INTO membership_sales (
    id,
    membership_id,
    client_id,
    purchase_date,
    expiration_date
)
SELECT
    COALESCE(MAX(id), 0) + 1,
    (SELECT MIN(id) FROM memberships),
    (SELECT MIN(id) FROM clients),
    '2026-11-02',
    '2026-12-02'
FROM membership_sales;

-- Повторне використання id = 1 має викликати помилку
INSERT INTO membership_sales (
    id,
    membership_id,
    client_id,
    purchase_date,
    expiration_date
)
VALUES (
    1,
    (SELECT MIN(id) FROM memberships),
    (SELECT MIN(id) FROM clients),
    '2026-11-03',
    '2026-12-03'
);

-- Попри помилку, фіксую транзакцію
COMMIT;

-- Перевіряю, чи залишився перший доданий запис
SELECT *
FROM membership_sales
WHERE purchase_date = '2026-11-02';