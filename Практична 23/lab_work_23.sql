
-- ============================================================
-- ПРАКТИЧНА РОБОТА №23
-- Тема: Транзакції та обробка помилок у процедурах PostgreSQL
-- Виконала: Вовк Марія
-- Група: І-23
-- Варіант: 1 — Бібліотека
-- ============================================================


-- ============================================================
-- ЗАВДАННЯ 1. Створення процедури видачі книги
-- ============================================================

CREATE OR REPLACE PROCEDURE public.issue_book_23(
    IN p_book_id INTEGER,
    IN p_reader_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_copies INTEGER;
BEGIN
    -- Перевірка вхідних параметрів
    IF p_book_id IS NULL THEN
        RAISE EXCEPTION 'ID книги не може бути NULL';
    END IF;

    IF p_reader_id IS NULL THEN
        RAISE EXCEPTION 'ID читача не може бути NULL';
    END IF;

    -- Перевірка наявності книги та блокування рядка
    SELECT copies_count
    INTO v_copies
    FROM public.books
    WHERE id = p_book_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Книгу з ID % не знайдено', p_book_id;
    END IF;

    -- Перевірка кількості примірників
    IF v_copies IS NULL OR v_copies <= 0 THEN
        RAISE EXCEPTION
            'Немає доступних примірників книги з ID %', p_book_id;
    END IF;

    -- Додавання запису про видачу книги
    INSERT INTO public.loans(book_id, reader_id, loan_date, return_date)
    VALUES (p_book_id, p_reader_id, CURRENT_DATE, NULL);

    -- Зменшення кількості примірників
    UPDATE public.books
    SET copies_count = copies_count - 1
    WHERE id = p_book_id;

    RAISE NOTICE
        'Книгу з ID % видано читачу з ID %. Залишок: %',
        p_book_id, p_reader_id, v_copies - 1;
END;
$$;


-- Перевірка успішної видачі книги:
-- CALL public.issue_book_23(8, 2);
-- Результат: книгу видано, кількість примірників зменшилася з 1 до 0.

-- Перевірка повторної видачі книги без примірників:
-- CALL public.issue_book_23(8, 2);
-- Очікувана помилка: немає доступних примірників книги з ID 8.

-- Перевірка видачі неіснуючої книги:
-- CALL public.issue_book_23(999, 2);
-- Очікувана помилка: книгу з ID 999 не знайдено.


-- ============================================================
-- ЗАВДАННЯ 2. Обробка помилки зовнішнього ключа
-- ============================================================

-- Початкова перевірка системної помилки зовнішнього ключа:
-- CALL public.issue_book_23(1, 999);
-- Результат: SQLSTATE 23503 (foreign_key_violation).
-- Причина: читача з ID 999 немає в таблиці readers.


-- Створення оновленої процедури з обробкою foreign_key_violation

CREATE OR REPLACE PROCEDURE public.issue_book_23(
    IN p_book_id INTEGER,
    IN p_reader_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_copies INTEGER;
BEGIN
    IF p_book_id IS NULL THEN
        RAISE EXCEPTION 'ID книги не може бути NULL';
    END IF;

    IF p_reader_id IS NULL THEN
        RAISE EXCEPTION 'ID читача не може бути NULL';
    END IF;

    SELECT copies_count
    INTO v_copies
    FROM public.books
    WHERE id = p_book_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Книгу з ID % не знайдено', p_book_id;
    END IF;

    IF v_copies IS NULL OR v_copies <= 0 THEN
        RAISE EXCEPTION
            'Немає доступних примірників книги з ID %', p_book_id;
    END IF;

    -- Обробка помилки зовнішнього ключа
    BEGIN
        INSERT INTO public.loans(book_id, reader_id, loan_date, return_date)
        VALUES (p_book_id, p_reader_id, CURRENT_DATE, NULL);

    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Читача з ID % не знайдено', p_reader_id;
    END;

    UPDATE public.books
    SET copies_count = copies_count - 1
    WHERE id = p_book_id;

    RAISE NOTICE
        'Книгу з ID % видано читачу з ID %. Залишок: %',
        p_book_id, p_reader_id, v_copies - 1;
END;
$$;


-- Перевірка обробки помилки:
-- CALL public.issue_book_23(1, 999);
-- Очікувана помилка: Читача з ID 999 не знайдено.
-- SQLSTATE P0001.
-- Новий запис позики не створюється.
-- Кількість примірників книги ID 1 залишається 7.


-- ============================================================
-- ЗАВДАННЯ 3. Пакетне оновлення кількості примірників
-- ============================================================

CREATE OR REPLACE PROCEDURE public.update_books_batch_23(
    IN p_increment INTEGER,
    IN p_max INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    r RECORD;
    v_new_count INTEGER;
BEGIN
    IF p_increment IS NULL OR p_increment <= 0 THEN
        RAISE EXCEPTION 'Збільшення має бути додатним числом';
    END IF;

    IF p_max IS NULL OR p_max < 0 THEN
        RAISE EXCEPTION 'Максимальна межа має бути невід’ємною';
    END IF;

    FOR r IN
        SELECT id, copies_count
        FROM public.books
        WHERE copies_count IS NOT NULL
        ORDER BY id
    LOOP
        v_new_count := r.copies_count + p_increment;

        IF v_new_count > p_max THEN
            RAISE EXCEPTION
                'Кількість примірників книги ID % перевищила межу. Нове значення: %, межа: %',
                r.id, v_new_count, p_max;
        END IF;

        UPDATE public.books
        SET copies_count = v_new_count
        WHERE id = r.id;

        RAISE NOTICE 'Книга ID %: нова кількість %',
            r.id, v_new_count;

        COMMIT;
    END LOOP;
END;
$$;


-- Для перевірки тимчасово було встановлено:
-- UPDATE public.books SET copies_count = 8 WHERE id = 26;

-- Виклик процедури виконувався окремо:
-- CALL public.update_books_batch_23(1, 8);

-- Результат:
-- Оновлено 24 книги.
-- Книгу ID 24 пропущено, оскільки copies_count = NULL.
-- На книзі ID 26 виникла помилка:
-- нове значення 9 перевищує максимальну межу 8.
-- Попередні зміни збережені завдяки COMMIT після кожного рядка.


-- ============================================================
-- ЗАВДАННЯ 4. Особливості використання COMMIT
-- ============================================================

-- ------------------------------------------------------------
-- 4а. Виклик процедури всередині явної транзакції
-- ------------------------------------------------------------

-- Команди виконувалися окремо:
-- BEGIN;
-- CALL public.update_books_batch_23(1, 100);
-- Очікувана помилка: SQLSTATE 2D000
-- Неприпустиме завершення транзакції.
-- Причина: процедура містить COMMIT,
-- але викликається всередині відкритої транзакції.
-- Після помилки виконано:
-- ROLLBACK;


-- ------------------------------------------------------------
-- 4б. COMMIT усередині блоку EXCEPTION
-- ------------------------------------------------------------

-- Тимчасова версія процедури для перевірки.
-- Цей блок наведено для документації.
-- Не потрібно виконувати його під час звичайного запуску файлу.

-- CREATE OR REPLACE PROCEDURE public.issue_book_23(
--     IN p_book_id INTEGER,
--     IN p_reader_id INTEGER
-- )
-- LANGUAGE plpgsql
-- AS $$
-- DECLARE
--     v_copies INTEGER;
-- BEGIN
--     SELECT copies_count
--     INTO v_copies
--     FROM public.books
--     WHERE id = p_book_id
--     FOR UPDATE;
--
--     IF NOT FOUND THEN
--         RAISE EXCEPTION 'Книгу з ID % не знайдено', p_book_id;
--     END IF;
--
--     IF v_copies IS NULL OR v_copies <= 0 THEN
--         RAISE EXCEPTION
--             'Немає доступних примірників книги з ID %', p_book_id;
--     END IF;
--
--     BEGIN
--         INSERT INTO public.loans(book_id, reader_id, loan_date, return_date)
--         VALUES (p_book_id, p_reader_id, CURRENT_DATE, NULL);
--
--         COMMIT;
--
--     EXCEPTION
--         WHEN foreign_key_violation THEN
--             RAISE EXCEPTION 'Читача з ID % не знайдено', p_reader_id;
--     END;
--
--     UPDATE public.books
--     SET copies_count = copies_count - 1
--     WHERE id = p_book_id;
-- END;
-- $$;

-- Виклик тимчасової процедури:
-- CALL public.issue_book_23(1, 2);

-- Очікувана помилка:
-- SQLSTATE 2D000.
-- Неможливо затвердити транзакцію,
-- коли активна підтранзакція.


-- ============================================================
-- ВІДНОВЛЕННЯ РОБОЧОЇ ПРОЦЕДУРИ
-- ============================================================

-- Після перевірки відновлюємо правильну версію
-- процедури issue_book_23 без COMMIT у блоці EXCEPTION.

CREATE OR REPLACE PROCEDURE public.issue_book_23(
    IN p_book_id INTEGER,
    IN p_reader_id INTEGER
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_copies INTEGER;
BEGIN
    IF p_book_id IS NULL THEN
        RAISE EXCEPTION 'ID книги не може бути NULL';
    END IF;

    IF p_reader_id IS NULL THEN
        RAISE EXCEPTION 'ID читача не може бути NULL';
    END IF;

    SELECT copies_count
    INTO v_copies
    FROM public.books
    WHERE id = p_book_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Книгу з ID % не знайдено', p_book_id;
    END IF;

    IF v_copies IS NULL OR v_copies <= 0 THEN
        RAISE EXCEPTION
            'Немає доступних примірників книги з ID %', p_book_id;
    END IF;

    BEGIN
        INSERT INTO public.loans(book_id, reader_id, loan_date, return_date)
        VALUES (p_book_id, p_reader_id, CURRENT_DATE, NULL);

    EXCEPTION
        WHEN foreign_key_violation THEN
            RAISE EXCEPTION 'Читача з ID % не знайдено', p_reader_id;
    END;

    UPDATE public.books
    SET copies_count = copies_count - 1
    WHERE id = p_book_id;

    RAISE NOTICE
        'Книгу з ID % видано читачу з ID %. Залишок: %',
        p_book_id, p_reader_id, v_copies - 1;
END;
$$;


-- Повторна перевірка відновленої процедури:
-- CALL public.issue_book_23(1, 999);
-- Очікувана помилка: Читача з ID 999 не знайдено.


-- ============================================================
-- ПЕРЕВІРКА ДАНИХ ПІСЛЯ ВИКОНАННЯ ПРАКТИЧНОЇ
-- ============================================================

-- Перевірка кількості примірників книг
SELECT id, title, copies_count
FROM public.books
ORDER BY id;

-- Перевірка записів про видачу книг
SELECT id, book_id, reader_id, loan_date, return_date
FROM public.loans
ORDER BY id;
