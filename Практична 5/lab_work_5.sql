-- Практична робота 5
-- Обмеження цілісності даних: NOT NULL, UNIQUE, CHECK, DEFAULT

PRAGMA foreign_keys = ON;

-- ============================================
-- Завдання 1. NOT NULL
-- ============================================

ALTER TABLE readers RENAME TO readers_old;

CREATE TABLE readers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    address TEXT
);

INSERT INTO readers (id, name, phone, address)
SELECT id, name, phone, address
FROM readers_old;

DROP TABLE readers_old;

-- Перевірка NOT NULL:
-- INSERT INTO readers (name, address)
-- VALUES ('Тестовий Читач', 'Львів');
-- Очікувана помилка:
-- NOT NULL constraint failed: readers.phone


-- ============================================
-- Завдання 2. UNIQUE
-- ============================================

ALTER TABLE books RENAME TO books_old;

CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER,
    UNIQUE (title, author)
);

INSERT INTO books (id, title, author, publication_year, genre, copies_count)
SELECT id, title, author, publication_year, genre, copies_count
FROM books_old;

DROP TABLE books_old;

-- Перевірка UNIQUE:
-- INSERT INTO books (title, author, publication_year, genre, copies_count)
-- SELECT title, author, publication_year, genre, copies_count
-- FROM books
-- LIMIT 1;
-- Очікувана помилка:
-- UNIQUE constraint failed: books.title, books.author


-- ============================================
-- Завдання 3. CHECK
-- ============================================

ALTER TABLE books RENAME TO books_old;

CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER CHECK (copies_count >= 0),
    UNIQUE (title, author)
);

INSERT INTO books (id, title, author, publication_year, genre, copies_count)
SELECT id, title, author, publication_year, genre, copies_count
FROM books_old;

DROP TABLE books_old;

-- Перевірка CHECK — неправильне значення:
-- INSERT INTO books (title, author, publication_year, genre, copies_count)
-- VALUES ('Тестова книга', 'Тестовий Автор', 2026, 'Тест', -1);
-- Очікувана помилка:
-- CHECK constraint failed: copies_count >= 0

-- Перевірка CHECK — правильне значення:
-- INSERT INTO books (title, author, publication_year, genre, copies_count)
-- VALUES ('Тестова книга 2', 'Тестовий Автор 2', 2026, 'Тест', 0);


-- ============================================
-- Завдання 4. DEFAULT
-- ============================================

ALTER TABLE books RENAME TO books_old;

CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER DEFAULT 1 CHECK (copies_count >= 0),
    UNIQUE (title, author)
);

INSERT INTO books (id, title, author, publication_year, genre, copies_count)
SELECT id, title, author, publication_year, genre, copies_count
FROM books_old;

DROP TABLE books_old;

-- Перевірка DEFAULT:
-- INSERT INTO books (title, author, publication_year, genre)
-- VALUES ('Книга за замовчуванням', 'Тестовий Автор', 2026, 'Тест');

-- SELECT title, author, copies_count
-- FROM books
-- WHERE title = 'Книга за замовчуванням';


-- ============================================
-- Завдання 5. UPDATE та CHECK
-- ============================================

-- Перевірка порушення CHECK через UPDATE:
-- UPDATE books
-- SET copies_count = -1
-- WHERE id = (SELECT MIN(id) FROM books);

-- Очікувана помилка:
-- CHECK constraint failed: copies_count >= 0


-- ============================================
-- Завдання 6. Бізнес-сенс обмежень
-- ============================================

-- NOT NULL:
-- Забезпечує обов'язкове заповнення важливого поля.

-- UNIQUE:
-- Не допускає дублювання значень або комбінацій значень,
-- які повинні бути унікальними.

-- CHECK:
-- Гарантує відповідність даних заданому правилу,
-- наприклад кількість примірників не може бути від'ємною.

-- DEFAULT:
-- Автоматично встановлює стандартне значення,
-- якщо користувач його не вказав.