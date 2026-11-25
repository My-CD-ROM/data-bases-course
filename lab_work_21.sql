-- lab_work_21.sql
-- Практика 21. Написання функцій у PostgreSQL (PL/pgSQL)
-- Середовище: PostgreSQL 16.15, база з Практики 19/20 (таблиці owners, animals, vet_visits).
-- Результати виконання подано в коментарях під кожною командою.

-- ===== Завдання 1. Скалярна функція з обчисленням: вік тварини у місяцях =====
CREATE OR REPLACE FUNCTION age_in_months(age_years INTEGER)
RETURNS INTEGER AS $$
BEGIN
    RETURN age_years * 12;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT id, name, age, age_in_months(age) AS age_months FROM animals ORDER BY id;
--  id |  name  | age | age_months 
-- ----+--------+-----+------------
--   1 | Барсик |   3 |         36
--   2 | Рекс   |   5 |         60
--   3 | Мурка  |   2 |         24
--   4 | Бім    |   7 |         84
--   5 | Кеша   |   1 |         12
--   6 | Джек   |   1 |         12
--   7 | Лаки   |   4 |         48
--   8 | Софі   |   2 |         24
--   9 | Альма  |   3 |         36
-- (9 rows)

-- ===== Завдання 2. Скалярна функція з умовною логікою: вікова категорія =====
CREATE OR REPLACE FUNCTION age_category(age_years INTEGER)
RETURNS TEXT AS $$
BEGIN
    IF age_years IS NULL THEN
        RETURN 'невідомо';
    ELSIF age_years < 1 THEN
        RETURN 'малюк';
    ELSIF age_years < 7 THEN
        RETURN 'дорослий';
    ELSE
        RETURN 'старший';
    END IF;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT id, name, age, age_category(age) AS category FROM animals ORDER BY id;
--  id |  name  | age | category 
-- ----+--------+-----+----------
--   1 | Барсик |   3 | дорослий
--   2 | Рекс   |   5 | дорослий
--   3 | Мурка  |   2 | дорослий
--   4 | Бім    |   7 | старший
--   5 | Кеша   |   1 | дорослий
--   6 | Джек   |   1 | дорослий
--   7 | Лаки   |   4 | дорослий
--   8 | Софі   |   2 | дорослий
--   9 | Альма  |   3 | дорослий
-- (9 rows)

-- Перевірка граничних значень і NULL
SELECT v AS age, age_category(v) AS category FROM (VALUES (0),(1),(6),(7),(NULL)) AS t(v);
--  age | category 
-- -----+----------
--    0 | малюк
--    1 | дорослий
--    6 | дорослий
--    7 | старший
--      | невідомо
-- (5 rows)

-- ===== Завдання 3. Функція, що повертає таблицю =====
-- Спроба 1 (як у прикладі з лекції): name оголошено як TEXT, а в таблиці VARCHAR(50)
CREATE OR REPLACE FUNCTION animals_by_species_text(p_species TEXT)
RETURNS TABLE(id INTEGER, name TEXT, age INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT a.id, a.name, a.age FROM animals a WHERE a.species = p_species;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT * FROM animals_by_species_text('кіт');
-- ERROR:  structure of query does not match function result type
-- DETAIL:  Returned type character varying(50) does not match expected type text in column 2.
-- CONTEXT:  SQL statement "SELECT a.id, a.name, a.age FROM animals a WHERE a.species = p_species"
-- PL/pgSQL function animals_by_species_text(text) line 3 at RETURN QUERY

-- Спроба 2: типи в RETURNS TABLE узгоджено з таблицею (VARCHAR)
CREATE OR REPLACE FUNCTION animals_by_species(p_species TEXT)
RETURNS TABLE(id INTEGER, name VARCHAR, age INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT a.id, a.name, a.age FROM animals a WHERE a.species = p_species;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT * FROM animals_by_species('кіт') ORDER BY id;
--  id |  name  | age 
-- ----+--------+-----
--   1 | Барсик |   3
--   3 | Мурка  |   2
--   7 | Лаки   |   4
--   8 | Софі   |   2
-- (4 rows)

-- Порівняння з прямим запитом
SELECT id, name, age FROM animals WHERE species = 'кіт' ORDER BY id;
--  id |  name  | age 
-- ----+--------+-----
--   1 | Барсик |   3
--   3 | Мурка  |   2
--   7 | Лаки   |   4
--   8 | Софі   |   2
-- (4 rows)

-- Різниця між двома результатами має бути порожньою (0 рядків)
(SELECT * FROM animals_by_species('кіт') EXCEPT SELECT id, name, age FROM animals WHERE species = 'кіт')
UNION ALL
(SELECT id, name, age FROM animals WHERE species = 'кіт' EXCEPT SELECT * FROM animals_by_species('кіт'));
--  id | name | age 
-- ----+------+-----
-- (0 rows)

-- ===== Завдання 4. Свідома помилка: COMMIT у функції =====
CREATE OR REPLACE FUNCTION bad_commit(p_id INTEGER)
RETURNS VOID AS $$
BEGIN
    UPDATE animals SET age = age + 1 WHERE id = p_id;
    COMMIT;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT bad_commit(1);
-- ERROR:  invalid transaction termination
-- CONTEXT:  PL/pgSQL function bad_commit(integer) line 4 at COMMIT

-- Перевірка: зміна не збереглася (age Барсика досі 3)
SELECT id, name, age FROM animals WHERE id = 1;
--  id |  name  | age 
-- ----+--------+-----
--   1 | Барсик |   3
-- (1 row)

-- ===== Завдання 5. Функція в WHERE =====
SELECT id, name, age FROM animals WHERE age_category(age) = 'старший' ORDER BY id;
--  id | name | age 
-- ----+------+-----
--   4 | Бім  |   7
-- (1 row)

-- Те саме з розгорнутим CASE у WHERE
SELECT id, name, age FROM animals
WHERE CASE WHEN age IS NULL THEN 'невідомо'
           WHEN age < 1 THEN 'малюк'
           WHEN age < 7 THEN 'дорослий'
           ELSE 'старший' END = 'старший'
ORDER BY id;
--  id | name | age 
-- ----+------+-----
--   4 | Бім  |   7
-- (1 row)

-- Спроба створити індекс за виразом з функцією (функція за замовчуванням VOLATILE)
CREATE INDEX idx_animals_age_cat ON animals (age_category(age));
-- ERROR:  functions in index expression must be marked IMMUTABLE

-- Позначаємо функцію IMMUTABLE (результат залежить лише від аргументу) і повторюємо
CREATE OR REPLACE FUNCTION age_category(age_years INTEGER)
RETURNS TEXT AS $$
BEGIN
    IF age_years IS NULL THEN
        RETURN 'невідомо';
    ELSIF age_years < 1 THEN
        RETURN 'малюк';
    ELSIF age_years < 7 THEN
        RETURN 'дорослий';
    ELSE
        RETURN 'старший';
    END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;
-- CREATE FUNCTION

CREATE INDEX idx_animals_age_cat ON animals (age_category(age));
-- CREATE INDEX

-- Таблиця мала, тому планувальник обирає Seq Scan; для демонстрації вимикаємо його
SET enable_seqscan = off;
EXPLAIN SELECT id, name FROM animals WHERE age_category(age) = 'старший';
RESET enable_seqscan;
-- SET
--                                      QUERY PLAN                                      
-- -------------------------------------------------------------------------------------
--  Index Scan using idx_animals_age_cat on animals  (cost=0.14..8.15 rows=1 width=122)
--    Index Cond: (age_category(age) = 'старший'::text)
-- (2 rows)
--
-- RESET

-- Індекс по звичайній колонці age функцію в WHERE не прискорює
CREATE INDEX idx_animals_age ON animals (age);
SET enable_seqscan = off;
EXPLAIN SELECT id, name FROM animals WHERE age >= 7;
RESET enable_seqscan;
-- CREATE INDEX
-- SET
--                                    QUERY PLAN                                    
-- ---------------------------------------------------------------------------------
--  Index Scan using idx_animals_age on animals  (cost=0.14..8.19 rows=3 width=122)
--    Index Cond: (age >= 7)
-- (2 rows)
--
-- RESET

-- ===== Завдання 6. Точний збіг типів у RETURN QUERY =====
-- Спроба 1: cnt оголошено як INTEGER, COUNT(*) повертає BIGINT
CREATE OR REPLACE FUNCTION species_summary_bad()
RETURNS TABLE(species VARCHAR, cnt INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT a.species, COUNT(*) FROM animals a GROUP BY a.species;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT * FROM species_summary_bad();
-- ERROR:  structure of query does not match function result type
-- DETAIL:  Returned type bigint does not match expected type integer in column 2.
-- CONTEXT:  SQL statement "SELECT a.species, COUNT(*) FROM animals a GROUP BY a.species"
-- PL/pgSQL function species_summary_bad() line 3 at RETURN QUERY

-- Виправлення 1: приведення COUNT(*)::INTEGER у запиті
CREATE OR REPLACE FUNCTION species_summary_cast()
RETURNS TABLE(species VARCHAR, cnt INTEGER) AS $$
BEGIN
    RETURN QUERY
    SELECT a.species, COUNT(*)::INTEGER FROM animals a GROUP BY a.species;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT * FROM species_summary_cast() ORDER BY species;
--  species | cnt 
-- ---------+-----
--  кіт     |   4
--  папуга  |   1
--  собака  |   4
-- (3 rows)

-- Виправлення 2: тип BIGINT в оголошенні
CREATE OR REPLACE FUNCTION species_summary_bigint()
RETURNS TABLE(species VARCHAR, cnt BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT a.species, COUNT(*) FROM animals a GROUP BY a.species;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT * FROM species_summary_bigint() ORDER BY species;
--  species | cnt 
-- ---------+-----
--  кіт     |   4
--  папуга  |   1
--  собака  |   4
-- (3 rows)

-- Перевірка інших типів. Колонка species має тип VARCHAR(30), а в оголошенні TEXT:
CREATE OR REPLACE FUNCTION species_summary_text()
RETURNS TABLE(species TEXT, cnt BIGINT) AS $$
BEGIN
    RETURN QUERY
    SELECT a.species, COUNT(*) FROM animals a GROUP BY a.species;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT * FROM species_summary_text();
-- ERROR:  structure of query does not match function result type
-- DETAIL:  Returned type character varying(30) does not match expected type text in column 1.
-- CONTEXT:  SQL statement "SELECT a.species, COUNT(*) FROM animals a GROUP BY a.species"
-- PL/pgSQL function species_summary_text() line 3 at RETURN QUERY

-- AVG(INTEGER) повертає NUMERIC; оголошуємо REAL
CREATE OR REPLACE FUNCTION avg_age_bad()
RETURNS TABLE(species VARCHAR, avg_age REAL) AS $$
BEGIN
    RETURN QUERY
    SELECT a.species, AVG(a.age) FROM animals a GROUP BY a.species;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT * FROM avg_age_bad();
-- ERROR:  structure of query does not match function result type
-- DETAIL:  Returned type numeric does not match expected type real in column 2.
-- CONTEXT:  SQL statement "SELECT a.species, AVG(a.age) FROM animals a GROUP BY a.species"
-- PL/pgSQL function avg_age_bad() line 3 at RETURN QUERY

-- Виправлення: AVG(a.age)::REAL
CREATE OR REPLACE FUNCTION avg_age_fixed()
RETURNS TABLE(species VARCHAR, avg_age REAL) AS $$
BEGIN
    RETURN QUERY
    SELECT a.species, AVG(a.age)::REAL FROM animals a GROUP BY a.species;
END;
$$ LANGUAGE plpgsql;
-- CREATE FUNCTION

SELECT * FROM avg_age_fixed() ORDER BY species;
--  species | avg_age 
-- ---------+---------
--  кіт     |    2.75
--  папуга  |       1
--  собака  |       4
-- (3 rows)

