-- Практика 2. Формування запитів вибірки у SQLite
-- Варіант 1: Бібліотека
-- Таблиця: books

-- Завдання 1. SELECT з явним переліком стовпців

SELECT title, author, publication_year, genre
FROM books;


-- Завдання 2. WHERE за умовою свого варіанта
-- Книги, опубліковані після 1900 року

SELECT title, publication_year
FROM books
WHERE publication_year > 1900;


-- Завдання 3. LIMIT
-- Перші 3 записи

SELECT title, author
FROM books
LIMIT 3;


-- Завдання 4. IS NULL / IS NOT NULL
-- Додатковий запис із невідомим жанром

INSERT INTO books (
    title,
    author,
    publication_year,
    genre,
    copies_count
) VALUES (
    'Приклад книги без жанру',
    'Невідомий автор',
    2020,
    NULL,
    2
);


-- Книги, у яких жанр не вказаний

SELECT title, genre
FROM books
WHERE genre IS NULL;


-- Книги, у яких жанр вказаний

SELECT title, genre
FROM books
WHERE genre IS NOT NULL;


-- Пояснення:
-- NULL означає відсутність або невідомість значення.
-- Тому порівняння через = NULL є некоректним.
-- Вираз genre = NULL повертає NULL, а не TRUE,
-- тому WHERE не вибирає такий рядок.
-- Для перевірки відсутності значення використовують IS NULL,
-- а для перевірки наявності значення — IS NOT NULL.


-- Завдання 5. Складена умова через AND
-- Книги після 1900 року, яких більше 4 примірників

SELECT title, publication_year, copies_count
FROM books
WHERE publication_year > 1900
  AND copies_count > 4;


-- Контрольні питання

-- 1. Чому WHERE price = NULL повертає порожній результат?
-- NULL означає невідоме або відсутнє значення.
-- Порівняння з NULL через оператор = дає NULL,
-- а WHERE пропускає тільки рядки, для яких умова TRUE.
-- Тому потрібно використовувати WHERE price IS NULL.
-- Для перевірки наявного значення використовується
-- WHERE price IS NOT NULL.


-- 2. Чим WHERE відрізняється від HAVING?
-- WHERE фільтрує окремі рядки таблиці до групування.
-- HAVING фільтрує вже сформовані групи після GROUP BY.


-- 3. У якому випадку варто уникати SELECT *?
-- SELECT * варто уникати, коли потрібні лише конкретні
-- стовпці таблиці. Явний перелік стовпців робить запит
-- зрозумілішим, повертає тільки необхідні дані та зменшує
-- залежність запиту від змін структури таблиці.