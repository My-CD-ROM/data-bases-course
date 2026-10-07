-- Завдання 1. SELECT з явним переліком стовпців

SELECT title, author, publication_year, genre
FROM books;
-- Завдання 2. Вибірка за умовою WHERE

SELECT title, author, publication_year, genre
FROM books
WHERE publication_year > 1900;
-- Завдання 3. Обмеження кількості результатів

SELECT title, author, publication_year, genre
FROM books
LIMIT 3;
-- Завдання 4. Вибірка записів, де genre має значення NULL

SELECT title, author, genre
FROM books
WHERE genre IS NULL;
-- Завдання 4. Вибірка записів, де genre НЕ є NULL

SELECT title, author, genre
FROM books
WHERE genre IS NOT NULL;
-- Завдання 5. Складена умова AND

SELECT title, author, publication_year, copies_count
FROM books
WHERE publication_year > 1900
  AND copies_count > 3;