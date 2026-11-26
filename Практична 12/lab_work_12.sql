-- Практична робота 12. Сортування і фільтрація даних

-- Завдання 1. Сортування позик за датою
SELECT id, book_id, reader_id, loan_date, return_date
FROM loans
ORDER BY loan_date DESC;

-- Завдання 2. Сортування за двома колонками
SELECT id, book_id, reader_id, loan_date, return_date
FROM loans
ORDER BY return_date ASC, loan_date DESC;

-- Завдання 3. Три найновіші позики
SELECT id, book_id, reader_id, loan_date, return_date
FROM loans
ORDER BY loan_date DESC
LIMIT 3;

-- Завдання 4а. Унікальні жанри
SELECT DISTINCT genre
FROM books
ORDER BY genre;

-- Кількість унікальних жанрів
SELECT COUNT(DISTINCT genre) AS unique_genres
FROM books;

-- Завдання 4б. Книги за діапазоном років
SELECT id, title, publication_year
FROM books
WHERE publication_year BETWEEN 2000 AND 2026
ORDER BY publication_year DESC;

-- Завдання 5. Назви книг, які починаються з малої літери м
SELECT id, title
FROM books
WHERE title LIKE 'м%';

-- Назви книг, які починаються з великої літери М
SELECT id, title
FROM books
WHERE title LIKE 'М%';