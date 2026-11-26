-- Практична робота №14. 

-- Завдання 1. Успішна транзакція
BEGIN;

INSERT INTO membership_sales
(membership_id, client_id, purchase_date, expiration_date)
VALUES (7, 4, '2026-11-02', '2026-11-05');

UPDATE memberships
SET description = 'Продаж оформлено клієнту 4'
WHERE id = 7;

SELECT * FROM membership_sales WHERE id = 10;
SELECT * FROM memberships WHERE id = 7;

COMMIT;

-- Завдання 2. Перевірка ROLLBACK
BEGIN;

UPDATE memberships
SET description = 'Тимчасова зміна для перевірки'
WHERE id = 8;

SELECT * FROM memberships WHERE id = 8;

ROLLBACK;

SELECT * FROM memberships WHERE id = 8;

-- Завдання 3. Перевірка власних змін до завершення транзакції
BEGIN;

UPDATE memberships
SET description = 'Проміжна зміна до COMMIT'
WHERE id = 8;

SELECT * FROM memberships WHERE id = 8;

ROLLBACK;

-- Завдання 4. Помилка UNIQUE та ROLLBACK
BEGIN;

UPDATE memberships
SET description = 'Перша успішна зміна'
WHERE id = 8;

-- Команда INSERT викликала помилку:
-- Runtime error: UNIQUE constraint failed: clients.phone (19)

INSERT INTO clients (last_name, first_name, phone, birth_date)
VALUES ('Тестовий', 'Клієнт', '+380931234567', '2000-01-01');

SELECT * FROM memberships WHERE id = 8;

ROLLBACK;

SELECT * FROM memberships WHERE id = 8;

-- Завдання 5. Помилка UNIQUE та COMMIT
BEGIN;

UPDATE memberships
SET description = 'Зміна із завдання 5'
WHERE id = 8;

-- Команда INSERT викликала помилку:
-- Runtime error: UNIQUE constraint failed: clients.phone (19)

INSERT INTO clients (last_name, first_name, phone, birth_date)
VALUES ('Тестовий', 'Клієнт', '+380931234567', '2000-01-01');

SELECT * FROM memberships WHERE id = 8;
SELECT * FROM clients WHERE phone = '+380931234567';

COMMIT;

-- Перевірка після COMMIT
SELECT * FROM memberships WHERE id = 8;
SELECT * FROM clients WHERE phone = '+380931234567';