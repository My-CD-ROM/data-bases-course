-- Практична робота 22
-- Створення процедур у PostgreSQL

-- 1. Процедура реєстрації видачі книги
CREATE OR REPLACE PROCEDURE register_loan(
    IN p_book_id INTEGER,
    IN p_reader_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO loans (book_id, reader_id, loan_date, return_date)
    VALUES (p_book_id, p_reader_id, CURRENT_DATE, NULL);

    UPDATE books
    SET copies_count = copies_count - 1
    WHERE id = p_book_id;
END;
$$;


-- 2. Процедура з перевіркою вхідних даних
CREATE OR REPLACE PROCEDURE register_loan(
    IN p_book_id INTEGER,
    IN p_reader_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_book_id IS NULL THEN
        RAISE EXCEPTION 'ID книги не може бути NULL';
    END IF;

    IF p_reader_id IS NULL THEN
        RAISE EXCEPTION 'ID читача не може бути NULL';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM books WHERE id = p_book_id) THEN
        RAISE EXCEPTION 'Книгу з ID % не знайдено', p_book_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM readers WHERE id = p_reader_id) THEN
        RAISE EXCEPTION 'Читача з ID % не знайдено', p_reader_id;
    END IF;

    IF (SELECT copies_count FROM books WHERE id = p_book_id) IS NULL
       OR (SELECT copies_count FROM books WHERE id = p_book_id) <= 0 THEN
        RAISE EXCEPTION 'Немає доступних примірників цієї книги';
    END IF;

    INSERT INTO loans (book_id, reader_id, loan_date, return_date)
    VALUES (p_book_id, p_reader_id, CURRENT_DATE, NULL);

    UPDATE books
    SET copies_count = copies_count - 1
    WHERE id = p_book_id;
END;
$$;


-- 3. Процедура з вихідним параметром OUT
CREATE OR REPLACE PROCEDURE register_loan_with_id(
    IN p_book_id INTEGER,
    IN p_reader_id INTEGER,
    OUT p_loan_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_book_id IS NULL THEN
        RAISE EXCEPTION 'ID книги не може бути NULL';
    END IF;

    IF p_reader_id IS NULL THEN
        RAISE EXCEPTION 'ID читача не може бути NULL';
    END IF;

    IF NOT EXISTS (SELECT 1 FROM books WHERE id = p_book_id) THEN
        RAISE EXCEPTION 'Книгу з ID % не знайдено', p_book_id;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM readers WHERE id = p_reader_id) THEN
        RAISE EXCEPTION 'Читача з ID % не знайдено', p_reader_id;
    END IF;

    IF (SELECT copies_count FROM books WHERE id = p_book_id) IS NULL
       OR (SELECT copies_count FROM books WHERE id = p_book_id) <= 0 THEN
        RAISE EXCEPTION 'Немає доступних примірників цієї книги';
    END IF;

    INSERT INTO loans (book_id, reader_id, loan_date, return_date)
    VALUES (p_book_id, p_reader_id, CURRENT_DATE, NULL)
    RETURNING id INTO p_loan_id;

    UPDATE books
    SET copies_count = copies_count - 1
    WHERE id = p_book_id;
END;
$$;


-- 4. Перевірка параметрів процедур
SELECT
    p.proname AS procedure_name,
    pg_get_function_arguments(p.oid) AS parameters
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
  AND p.prokind = 'p'
  AND p.proname IN ('register_loan', 'register_loan_with_id')
ORDER BY p.proname;
-- 5. Успішні виклики процедур
-- CALL register_loan(1, 2);
-- CALL register_loan(2, 3);
-- CALL register_loan_with_id(3, 4, NULL);

-- 6. Перевірка результатів
-- SELECT * FROM loans ORDER BY id DESC LIMIT 5;
-- SELECT id, title, copies_count FROM books WHERE id IN (1, 2, 3);
-- SELECT * FROM loans WHERE id = 14;
-- SELECT MAX(id) AS last_loan_id FROM loans;

-- 7. Перевірка помилкових викликів
-- SELECT register_loan(1, 2);
-- ERROR: register_loan(integer, integer) - процедура
-- HINT: Щоб викликати процедуру, використайте CALL.
-- SQL state: 42809

-- CALL register_loan(1);
-- ERROR: процедура register_loan(integer) не існує
-- SQL state: 42883

-- 8. Перевірка RAISE EXCEPTION
-- CALL register_loan(999, 3);
-- ERROR: Книгу з ID 999 не знайдено
-- SQL state: P0001

-- Перевірка відсутності неправильних записів
-- SELECT COUNT(*) AS total_invalid_loans
-- FROM loans
-- WHERE book_id = 999;

-- 9. Перевірка режимів параметрів
SELECT
    p.proname AS procedure_name,
    pg_get_function_arguments(p.oid) AS parameters
FROM pg_proc p
JOIN pg_namespace n ON n.oid = p.pronamespace
WHERE n.nspname = 'public'
  AND p.prokind = 'p'
  AND p.proname IN ('register_loan', 'register_loan_with_id')
ORDER BY p.proname;