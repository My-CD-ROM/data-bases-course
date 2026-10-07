-- Практична робота 6
-- Варіант 1 — Бібліотека

-- =====================================================
-- Завдання 1. UPDATE фактової таблиці loans
-- Заповнення return_date для одного запису
-- =====================================================

UPDATE loans
SET return_date = '2026-09-23'
WHERE id = 5;

SELECT id, book_id, reader_id, loan_date, return_date
FROM loans
WHERE id = 5;


-- =====================================================
-- Завдання 2. UPDATE показника в таблиці books
-- Збільшення кількості примірників книги "Чорна рада"
-- =====================================================

UPDATE books
SET copies_count = copies_count + 1
WHERE id = 6;

SELECT id, title, copies_count
FROM books
WHERE id = 6;


-- =====================================================
-- Завдання 3. DELETE одного запису з таблиці loans
-- До видалення: 10 записів
-- Після видалення: 9 записів
-- =====================================================

SELECT COUNT(*) AS loans_before_delete
FROM loans;

PRAGMA foreign_keys = OFF;

DELETE FROM loans
WHERE id = 10;

PRAGMA foreign_keys = ON;

SELECT COUNT(*) AS loans_after_delete
FROM loans;


-- =====================================================
-- Завдання 4. Перевірка ON DELETE RESTRICT
-- =====================================================

PRAGMA foreign_keys = ON;

SELECT b.id, b.title
FROM books b
JOIN loans l ON l.book_id = b.id;

-- Спроба видалити книгу, яка використовується в loans.
-- Очікуваний результат: FOREIGN KEY constraint failed.

DELETE FROM books
WHERE id = 1;

-- Перевірка, що книга залишилася
SELECT id, title
FROM books
WHERE id = 1;


-- =====================================================
-- Фінальна перевірка кількості позик
-- =====================================================

SELECT COUNT(*) AS loans_count
FROM loans;