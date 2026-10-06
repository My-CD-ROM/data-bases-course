-- Практична робота №6
-- Робота з командами UPDATE та DELETE у SQLite
-- Варіант: Бібліотека
-- Студентка: Вовк Марія
-- Група: І-23

PRAGMA foreign_keys = ON;

-- Перевірка структури зовнішніх ключів
PRAGMA foreign_key_list(loans);

-- Завдання 1. Оновлення конкретного запису loans
UPDATE loans
SET return_date = '2026-09-20'
WHERE id = 6;

-- Перевірка
SELECT * FROM loans
WHERE id = 6;

-- Завдання 2. Оновлення кількості примірників книги
UPDATE books
SET copies_count = copies_count + 1
WHERE id = 8;

-- Перевірка
SELECT * FROM books
WHERE id = 8;

-- Перевірка CHECK
-- UPDATE books
-- SET copies_count = -1
-- WHERE id = 8;

-- Завдання 3. Видалення одного конкретного запису
SELECT COUNT(*) AS before_delete FROM loans;

DELETE FROM loans
WHERE id = 10;

SELECT COUNT(*) AS after_delete FROM loans;

-- Перевірка ON DELETE CASCADE
-- Видалення читача автоматично видаляє пов'язані позики
DELETE FROM readers
WHERE id = 1;

SELECT * FROM loans
WHERE reader_id = 1;

-- Перевірка ON DELETE RESTRICT
-- Книгу, яка використовується у loans, видалити не можна
DELETE FROM books
WHERE id = 2;