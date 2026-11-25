-- Практична робота 10. Відбір груп за допомогою HAVING

-- Завдання 1. HAVING на COUNT.
-- Книги, які видавали більше одного разу.
SELECT books.title, COUNT(loans.id) AS loans_count
FROM books
JOIN loans ON books.id = loans.book_id
GROUP BY books.id
HAVING COUNT(loans.id) > 1;

-- Завдання 2. HAVING на MAX.
-- Автори, у яких максимальна кількість примірників більша за 1.
SELECT author, MAX(copies_count) AS max_copies
FROM books
GROUP BY author
HAVING MAX(copies_count) > 1;

-- Завдання 3. WHERE + GROUP BY + HAVING.
-- Книги, видані у 2020 році або пізніше, які видавали більше одного разу.
SELECT books.title, books.publication_year,
       COUNT(loans.id) AS loans_count
FROM books
JOIN loans ON books.id = loans.book_id
WHERE books.publication_year >= 2020
GROUP BY books.id
HAVING COUNT(loans.id) > 1;

-- Завдання 4. Навмисна помилка: агрегатна функція у WHERE.
-- Цей запит призначений для демонстрації помилки.
SELECT book_id, COUNT(*) AS loans_count
FROM loans
WHERE COUNT(*) > 1
GROUP BY book_id;

-- Завдання 5. LEFT JOIN + GROUP BY + HAVING.
-- Читачі, у яких менше двох видач, включно з нулем.
SELECT readers.name, COUNT(loans.id) AS loans_count
FROM readers
LEFT JOIN loans ON readers.id = loans.reader_id
GROUP BY readers.id
HAVING COUNT(loans.id) < 2;
