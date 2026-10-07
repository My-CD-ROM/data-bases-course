-- Практична робота №5
-- Варіант 1 — Бібліотека
-- Обмеження цілісності даних

-- =========================================
-- 1. NOT NULL
-- =========================================

CREATE TABLE books_new (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER
);

INSERT INTO books_new (id, title, author, publication_year, genre, copies_count)
SELECT id, title, author, publication_year, genre, copies_count
FROM books;

-- Перевірка NOT NULL:
-- INSERT INTO books (author, publication_year, genre, copies_count)
-- VALUES ('Тестовий автор', 2026, 'Тест', 1);
-- Очікувана помилка:
-- NOT NULL constraint failed: books.title


-- =========================================
-- 2. UNIQUE
-- =========================================

-- UNIQUE для комбінації title + author
-- UNIQUE (title, author)

-- Перевірка:
-- INSERT INTO books (title, author, publication_year, genre, copies_count)
-- VALUES ('Чорна рада', 'Пантелеймон Куліш', 1857, 'Роман', 3);
-- Очікувана помилка:
-- UNIQUE constraint failed: books.title, books.author


-- =========================================
-- 3. CHECK
-- =========================================

-- CHECK для кількості примірників:
-- copies_count >= 0

-- Перевірка:
-- UPDATE books
-- SET copies_count = -5
-- WHERE title = 'Чорна рада';

-- Очікувана помилка:
-- CHECK constraint failed: copies_count >= 0


-- =========================================
-- 4. DEFAULT
-- =========================================

-- Значення за замовчуванням:
-- copies_count DEFAULT 0

-- Перевірка:
-- INSERT INTO books (title, author, publication_year, genre)
-- VALUES ('Тестова книга', 'Тестовий автор', 2026, 'Тест');

-- Перевірка результату:
-- SELECT title, copies_count
-- FROM books
-- WHERE title = 'Тестова книга';


-- =========================================
-- 5. Перевірка через UPDATE
-- =========================================

-- UPDATE books
-- SET copies_count = -1
-- WHERE title = 'Чорна рада';

-- Очікувана помилка:
-- CHECK constraint failed: copies_count >= 0


-- =========================================
-- 6. Перелік використаних обмежень
-- =========================================

-- title TEXT NOT NULL
-- UNIQUE (title, author)
-- copies_count INTEGER CHECK (copies_count >= 0)
-- copies_count INTEGER DEFAULT 0