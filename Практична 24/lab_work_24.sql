
-- Практична робота 24
-- Тема: Реалізація тригерів у PostgreSQL
-- Варіант 1: Бібліотека
-- Виконала: Вовк Марія, група І-23

-- 1. Створення таблиці журналу змін
CREATE TABLE IF NOT EXISTS public.books_changes_log (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    book_id INTEGER,
    action TEXT,
    old_copies_count INTEGER,
    new_copies_count INTEGER,
    logged_at TIMESTAMP DEFAULT now()
);

-- 2. Функція журналювання INSERT та UPDATE
CREATE OR REPLACE FUNCTION public.log_books_changes_24()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO public.books_changes_log (
            book_id, action, old_copies_count, new_copies_count
        )
        VALUES (NEW.id, 'INSERT', NULL, NEW.copies_count);

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO public.books_changes_log (
            book_id, action, old_copies_count, new_copies_count
        )
        VALUES (NEW.id, 'UPDATE', OLD.copies_count, NEW.copies_count);
    END IF;

    RETURN NEW;
END;
$$;

-- 3. AFTER-тригер для автоматичного журналювання
CREATE TRIGGER trg_log_books_changes_24
AFTER INSERT OR UPDATE
ON public.books
FOR EACH ROW
EXECUTE FUNCTION public.log_books_changes_24();

-- 4. Функція перевірки кількості примірників
CREATE OR REPLACE FUNCTION public.check_books_copies_24()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.copies_count IS NOT NULL AND NEW.copies_count < 0 THEN
        RAISE EXCEPTION
            'Кількість примірників книги не може бути від’ємною (отримано: %)',
            NEW.copies_count;
    END IF;

    RETURN NEW;
END;
$$;

-- 5. BEFORE-тригер для перевірки даних
CREATE TRIGGER trg_check_books_copies_24
BEFORE INSERT OR UPDATE
ON public.books
FOR EACH ROW
EXECUTE FUNCTION public.check_books_copies_24();

-- 6. Перевірка результатів
-- Тестовий запис: книга №28
SELECT id, title, copies_count
FROM public.books
WHERE id = 28;

-- Перегляд журналу змін
SELECT *
FROM public.books_changes_log
ORDER BY id;

-- 7. Приклади перевірки (виконувалися окремо)
-- Успішне додавання тестової книги:
-- INSERT INTO public.books
-- (title, author, publication_year, genre, copies_count, weekly_copy_days, is_modern)
-- VALUES ('Тестова книга для тригерів 24', 'Вовк Марія', 2026, 'Тест', 3, 2, TRUE);

-- Успішна зміна кількості:
-- UPDATE public.books SET copies_count = 4 WHERE id = 28;
-- UPDATE public.books SET copies_count = 5 WHERE id = 28;

-- Перевірка від’ємного значення (викликала помилку):
-- UPDATE public.books SET copies_count = -5 WHERE id = 28;
