
-- Практична робота 14
-- Завдання 1. Атомарна пара INSERT + UPDATE
BEGIN;

INSERT INTO loans (book_id, reader_id, loan_date, return_date)
VALUES (1, 1, '2026-10-25', NULL);

UPDATE books
SET copies_count = copies_count - 1
WHERE id = 1 AND copies_count > 0;

SELECT * FROM loans WHERE loan_date = '2026-10-25';
SELECT id, title, copies_count FROM books WHERE id = 1;

COMMIT;


-- Завдання 2. Свідомий ROLLBACK
BEGIN;

UPDATE books
SET copies_count = copies_count + 10
WHERE id = 1;

SELECT id, title, copies_count FROM books WHERE id = 1;

ROLLBACK;

SELECT id, title, copies_count FROM books WHERE id = 1;


-- Завдання 3. Проміжний стан усередині транзакції
BEGIN;

UPDATE books
SET copies_count = copies_count + 5
WHERE id = 1;

SELECT id, title, copies_count FROM books WHERE id = 1;

ROLLBACK;

SELECT id, title, copies_count FROM books WHERE id = 1;


-- Завдання 4. Помилка та ROLLBACK
BEGIN;

UPDATE books
SET copies_count = copies_count + 1
WHERE id = 1;

INSERT INTO books (id, title, author, copies_count)
VALUES (1, 'Тестова книга', 'Тестовий автор', 1);

SELECT id, title, copies_count FROM books WHERE id = 1;

ROLLBACK;

SELECT id, title, copies_count FROM books WHERE id = 1;


-- Завдання 5. Помилка та COMMIT
BEGIN;

UPDATE books
SET copies_count = copies_count + 1
WHERE id = 1;

INSERT INTO books (id, title, author, copies_count)
VALUES (1, 'Тестова книга', 'Тестовий автор', 1);

COMMIT;

SELECT id, title, copies_count FROM books WHERE id = 1;
