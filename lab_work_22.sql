-- lab_work_22.sql
-- Практика 22. Створення процедур у PostgreSQL (PL/pgSQL)
-- Середовище: PostgreSQL 16.15, база з Практик 19-21 (owners, animals, vet_visits).
-- Атомарна пара змін: INSERT у vet_visits + UPDATE animals.status.
-- Результати виконання подано в коментарях під кожною командою.

-- ===== Завдання 1. Процедура для атомарної пари: INSERT у vet_visits + UPDATE animals =====
CREATE OR REPLACE PROCEDURE register_visit(p_animal_id INTEGER, p_diagnosis TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO vet_visits (animal_id, visit_date, diagnosis)
    VALUES (p_animal_id, CURRENT_DATE, p_diagnosis);

    UPDATE animals SET status = 'на лікуванні' WHERE id = p_animal_id;
END;
$$;
-- CREATE PROCEDURE

-- Стан ДО виклику (тварина 2 - Рекс)
SELECT id, name, status FROM animals WHERE id = 2;
SELECT COUNT(*) AS visits_count, MAX(id) AS max_visit_id FROM vet_visits;
--  id | name |  status   
-- ----+------+-----------
--   2 | Рекс | на обліку
-- (1 row)
--
--  visits_count | max_visit_id 
-- --------------+--------------
--             3 |            3
-- (1 row)

CALL register_visit(2, 'отит');
-- CALL

-- Стан ПІСЛЯ виклику
SELECT id, name, status FROM animals WHERE id = 2;
SELECT COUNT(*) AS visits_count, MAX(id) AS max_visit_id FROM vet_visits;
SELECT * FROM vet_visits WHERE animal_id = 2 ORDER BY id;
--  id | name |    status    
-- ----+------+--------------
--   2 | Рекс | на лікуванні
-- (1 row)
--
--  visits_count | max_visit_id 
-- --------------+--------------
--             4 |            4
-- (1 row)
--
--  id | animal_id | visit_date | diagnosis 
-- ----+-----------+------------+-----------
--   2 |         2 | 2026-06-10 | огляд
--   4 |         2 | 2026-11-25 | отит
-- (2 rows)

-- ===== Завдання 2. Свідомі помилки виклику =====
SELECT register_visit(2, 'отит');
-- ERROR:  register_visit(integer, unknown) is a procedure
-- LINE 1: SELECT register_visit(2, 'отит');
--                ^
-- HINT:  To call a procedure, use CALL.

CALL register_visit(2);
-- ERROR:  procedure register_visit(integer) does not exist
-- LINE 1: CALL register_visit(2);
--              ^
-- HINT:  No procedure matches the given name and argument types. You might need to add explicit type casts.

-- ===== Завдання 3. Перевірка вхідних даних =====
CREATE OR REPLACE PROCEDURE register_visit(p_animal_id INTEGER, p_diagnosis TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_animal_id IS NULL THEN
        RAISE EXCEPTION 'Не вказано тварину (отримано %)', p_animal_id;
    END IF;
    IF p_diagnosis IS NULL OR trim(p_diagnosis) = '' THEN
        RAISE EXCEPTION 'Діагноз не може бути порожнім (тварина %)', p_animal_id;
    END IF;

    INSERT INTO vet_visits (animal_id, visit_date, diagnosis)
    VALUES (p_animal_id, CURRENT_DATE, p_diagnosis);

    UPDATE animals SET status = 'на лікуванні' WHERE id = p_animal_id;
END;
$$;
-- CREATE PROCEDURE

-- Коректний виклик (тварина 1 - Барсик)
SELECT id, name, status FROM animals WHERE id = 1;
SELECT COUNT(*) AS visits_count, MAX(id) AS max_visit_id FROM vet_visits;
CALL register_visit(1, 'щеплення від сказу');
SELECT id, name, status FROM animals WHERE id = 1;
SELECT COUNT(*) AS visits_count, MAX(id) AS max_visit_id FROM vet_visits;
--  id |  name  |  status   
-- ----+--------+-----------
--   1 | Барсик | на обліку
-- (1 row)
--
--  visits_count | max_visit_id 
-- --------------+--------------
--             4 |            4
-- (1 row)
--
-- CALL
--  id |  name  |    status    
-- ----+--------+--------------
--   1 | Барсик | на лікуванні
-- (1 row)
--
--  visits_count | max_visit_id 
-- --------------+--------------
--             5 |            5
-- (1 row)

-- Некоректний виклик: порожній діагноз (тварина 4 - Бім)
SELECT id, name, status FROM animals WHERE id = 4;
SELECT COUNT(*) AS visits_count, MAX(id) AS max_visit_id FROM vet_visits;
CALL register_visit(4, '');
SELECT id, name, status FROM animals WHERE id = 4;
SELECT COUNT(*) AS visits_count, MAX(id) AS max_visit_id FROM vet_visits;
--  id | name |  status   
-- ----+------+-----------
--   4 | Бім  | на обліку
-- (1 row)
--
--  visits_count | max_visit_id 
-- --------------+--------------
--             5 |            5
-- (1 row)
--
-- ERROR:  Діагноз не може бути порожнім (тварина 4)
-- CONTEXT:  PL/pgSQL function register_visit(integer,text) line 7 at RAISE
--  id | name |  status   
-- ----+------+-----------
--   4 | Бім  | на обліку
-- (1 row)
--
--  visits_count | max_visit_id 
-- --------------+--------------
--             5 |            5
-- (1 row)

-- Некоректний виклик: NULL замість діагнозу
CALL register_visit(4, NULL);
SELECT id, name, status FROM animals WHERE id = 4;
SELECT COUNT(*) AS visits_count, MAX(id) AS max_visit_id FROM vet_visits;
-- ERROR:  Діагноз не може бути порожнім (тварина 4)
-- CONTEXT:  PL/pgSQL function register_visit(integer,text) line 7 at RAISE
--  id | name |  status   
-- ----+------+-----------
--   4 | Бім  | на обліку
-- (1 row)
--
--  visits_count | max_visit_id 
-- --------------+--------------
--             5 |            5
-- (1 row)

-- Некоректний виклик: NULL замість тварини
CALL register_visit(NULL, 'огляд');
SELECT COUNT(*) AS visits_count, MAX(id) AS max_visit_id FROM vet_visits;
-- ERROR:  Не вказано тварину (отримано <NULL>)
-- CONTEXT:  PL/pgSQL function register_visit(integer,text) line 4 at RAISE
--  visits_count | max_visit_id 
-- --------------+--------------
--             5 |            5
-- (1 row)

-- ===== Завдання 4. OUT-параметр =====
CREATE OR REPLACE PROCEDURE register_visit_ret(
    p_animal_id INTEGER,
    p_diagnosis TEXT,
    OUT p_visit_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    IF p_animal_id IS NULL THEN
        RAISE EXCEPTION 'Не вказано тварину (отримано %)', p_animal_id;
    END IF;
    IF p_diagnosis IS NULL OR trim(p_diagnosis) = '' THEN
        RAISE EXCEPTION 'Діагноз не може бути порожнім (тварина %)', p_animal_id;
    END IF;

    INSERT INTO vet_visits (animal_id, visit_date, diagnosis)
    VALUES (p_animal_id, CURRENT_DATE, p_diagnosis)
    RETURNING id INTO p_visit_id;

    UPDATE animals SET status = 'на лікуванні' WHERE id = p_animal_id;
END;
$$;
-- CREATE PROCEDURE

CALL register_visit_ret(4, 'перелом лапи', NULL);
--  p_visit_id 
-- ------------
--           6
-- (1 row)

SELECT MAX(id) AS max_visit_id FROM vet_visits;
--  max_visit_id 
-- --------------
--             6
-- (1 row)

-- Без заповнювача для OUT-параметра процедуру не знайдено
CALL register_visit_ret(4, 'перелом лапи');
-- ERROR:  procedure register_visit_ret(integer, unknown) does not exist
-- LINE 1: CALL register_visit_ret(4, 'перелом лапи');
--              ^
-- HINT:  No procedure matches the given name and argument types. You might need to add explicit type casts.

\df register_visit*
--                                                       List of functions
--  Schema |        Name        | Result data type |                         Argument data types                         | Type 
-- --------+--------------------+------------------+---------------------------------------------------------------------+------
--  public | register_visit     |                  | IN p_animal_id integer, IN p_diagnosis text                         | proc
--  public | register_visit_ret |                  | IN p_animal_id integer, IN p_diagnosis text, OUT p_visit_id integer | proc
-- (2 rows)

-- ===== Додатково (до контрольного питання 2): помилка другого кроку скасовує перший =====
CREATE OR REPLACE PROCEDURE register_visit_fail(p_animal_id INTEGER, p_diagnosis TEXT)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO vet_visits (animal_id, visit_date, diagnosis)
    VALUES (p_animal_id, CURRENT_DATE, p_diagnosis);

    UPDATE animals SET age = age / 0 WHERE id = p_animal_id;  -- свідома помилка
END;
$$;
-- CREATE PROCEDURE

SELECT COUNT(*) AS visits_before FROM vet_visits;
--  visits_before 
-- ---------------
--              6
-- (1 row)

CALL register_visit_fail(5, 'тест');
-- ERROR:  division by zero
-- CONTEXT:  SQL statement "UPDATE animals SET age = age / 0 WHERE id = p_animal_id"
-- PL/pgSQL function register_visit_fail(integer,text) line 6 at SQL statement

SELECT COUNT(*) AS visits_after FROM vet_visits;
--  visits_after 
-- --------------
--             6
-- (1 row)

