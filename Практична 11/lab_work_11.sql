-- Практична робота 11. Бронювання книг у бібліотеці

CREATE TABLE reservations (
    id INTEGER PRIMARY KEY,
    book_id INTEGER NOT NULL,
    reader_id INTEGER NOT NULL,
    reservation_date TEXT NOT NULL,
    status TEXT NOT NULL DEFAULT 'активне'
        CHECK (status IN ('активне', 'скасоване', 'виконане')),
    note TEXT,
    FOREIGN KEY (book_id) REFERENCES books(id),
    FOREIGN KEY (reader_id) REFERENCES readers(id),
    UNIQUE (book_id, reader_id, status)
);

-- Завдання 1. Додавання бронювань
INSERT INTO reservations (book_id, reader_id, reservation_date, status, note)
VALUES
(1, 1, '2026-10-01', 'активне', 'Очікує на отримання'),
(1, 2, '2026-10-02', 'активне', 'Потрібна для навчання'),
(2, 1, '2026-10-03', 'активне', 'Бронювання книги'),
(2, 3, '2026-10-04', 'виконане', 'Книгу отримано'),
(3, 2, '2026-10-05', 'активне', 'Для читання'),
(3, 4, '2026-10-06', 'скасоване', 'Бронювання скасовано'),
(4, 3, '2026-10-07', 'активне', 'Очікує на отримання'),
(4, 5, '2026-10-08', 'активне', 'Для навчання');

-- Завдання 2. Кількість бронювань кожної книги
SELECT books.id, books.title,
       COUNT(reservations.id) AS reservation_count
FROM books
JOIN reservations ON books.id = reservations.book_id
GROUP BY books.id, books.title
ORDER BY reservation_count DESC;

-- Завдання 3. Книги з двома або більше бронюваннями
SELECT books.id, books.title,
       COUNT(reservations.id) AS reservation_count
FROM books
JOIN reservations ON books.id = reservations.book_id
GROUP BY books.id, books.title
HAVING COUNT(reservations.id) >= 2
ORDER BY reservation_count DESC;

-- Завдання 4. Книги з активними бронюваннями
SELECT books.id, books.title,
       COUNT(reservations.id) AS active_reservations
FROM books
JOIN reservations ON books.id = reservations.book_id
WHERE reservations.status = 'активне'
GROUP BY books.id, books.title
HAVING COUNT(reservations.id) >= 1
ORDER BY active_reservations DESC;

-- Завдання 5а. Групування за ID читача
SELECT readers.id, readers.name,
       COUNT(reservations.id) AS reservation_count
FROM readers
JOIN reservations ON readers.id = reservations.reader_id
GROUP BY readers.id, readers.name
HAVING COUNT(reservations.id) >= 2
ORDER BY reservation_count DESC;

-- Завдання 5а. Групування за ім'ям читача
SELECT readers.name,
       COUNT(reservations.id) AS reservation_count
FROM readers
JOIN reservations ON readers.id = reservations.reader_id
GROUP BY readers.name
HAVING COUNT(reservations.id) >= 2
ORDER BY reservation_count DESC;

-- Завдання 5б. Перевірка LEFT JOIN
SELECT books.id, books.title,
       COUNT(reservations.id) AS active_reservations
FROM books
LEFT JOIN reservations ON books.id = reservations.book_id
WHERE reservations.status = 'активне'
GROUP BY books.id, books.title
HAVING COUNT(reservations.id) >= 1
ORDER BY active_reservations DESC;

-- Завдання 5в. Відповідь на дослідницьке питання:
-- Які книги мають найбільшу кількість активних бронювань?
-- Результат визначається запитом у Завданні 4.