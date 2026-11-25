-- lab_work_20.sql
-- Практика 20. Створення та застосування Views у PostgreSQL
-- Середовище: PostgreSQL 16.15. Результати виконання подано в коментарях під кожною командою.

-- ===== Підготовка: стан бази з Практики 19 (owners, animals, vet_visits) =====
-- Увага: структуру таблиць і дані підлаштуйте під свою базу з Практики 19.
CREATE TABLE owners (
    id        SERIAL PRIMARY KEY,
    last_name VARCHAR(50) NOT NULL,
    phone     VARCHAR(20)
);
CREATE TABLE animals (
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(50) NOT NULL,
    species       VARCHAR(30) NOT NULL,
    age           INT,
    status        VARCHAR(20),
    owner_id      INT REFERENCES owners(id),
    registered_at DATE DEFAULT CURRENT_DATE
);
CREATE TABLE vet_visits (
    id        SERIAL PRIMARY KEY,
    animal_id INT NOT NULL REFERENCES animals(id),
    visit_date DATE NOT NULL,
    diagnosis VARCHAR(100)
);
INSERT INTO owners (last_name, phone) VALUES
 ('Коваленко','+380501112233'),('Шевченко','+380672223344'),('Бондаренко','+380933334455');
INSERT INTO animals (name, species, age, status, owner_id, registered_at) VALUES
 ('Барсик','кіт',3,'на обліку',1,'2026-01-10'),
 ('Рекс','собака',5,'на обліку',2,'2026-02-15'),
 ('Мурка','кіт',2,'вибув',3,'2026-03-01'),
 ('Бім','собака',7,'на обліку',NULL,'2026-04-20'),
 ('Кеша','папуга',1,'вибув',1,'2026-05-05');
INSERT INTO vet_visits (animal_id, visit_date, diagnosis) VALUES
 (1,'2026-06-01','щеплення'),(2,'2026-06-10','огляд'),(4,'2026-07-03','щеплення');

-- ===== Завдання 1. Подання-фільтр: тварини, що перебувають на обліку =====
CREATE VIEW animals_active AS
SELECT id, name, species, age
FROM animals
WHERE status = 'на обліку';
-- CREATE VIEW

SELECT * FROM animals_active;
--  id |  name  | species | age 
-- ----+--------+---------+-----
--   1 | Барсик | кіт     |   3
--   2 | Рекс   | собака  |   5
--   4 | Бім    | собака  |   7
-- (3 rows)

-- ===== Завдання 2. Подання завжди актуальне =====
SELECT * FROM animals_active;
--  id |  name  | species | age 
-- ----+--------+---------+-----
--   1 | Барсик | кіт     |   3
--   2 | Рекс   | собака  |   5
--   4 | Бім    | собака  |   7
-- (3 rows)

INSERT INTO animals (name, species, age, status) VALUES ('Джек', 'собака', 1, 'на обліку');
-- INSERT 0 1

SELECT * FROM animals_active;
--  id |  name  | species | age 
-- ----+--------+---------+-----
--   1 | Барсик | кіт     |   3
--   2 | Рекс   | собака  |   5
--   4 | Бім    | собака  |   7
--   6 | Джек   | собака  |   1
-- (4 rows)

-- ===== Завдання 3. INSERT через просте подання =====
INSERT INTO animals_active (name, species, age) VALUES ('Лаки', 'кіт', 4);
-- INSERT 0 1

SELECT id, name, species, age, status, owner_id, registered_at FROM animals WHERE name = 'Лаки';
--  id | name | species | age | status | owner_id | registered_at 
-- ----+------+---------+-----+--------+----------+---------------
--   7 | Лаки | кіт     |   4 |        |          | 2026-11-25
-- (1 row)

SELECT * FROM animals_active;
--  id |  name  | species | age 
-- ----+--------+---------+-----
--   1 | Барсик | кіт     |   3
--   2 | Рекс   | собака  |   5
--   4 | Бім    | собака  |   7
--   6 | Джек   | собака  |   1
-- (4 rows)

-- ===== Завдання 4. Матеріалізоване подання і REFRESH =====
CREATE MATERIALIZED VIEW animals_active_mat AS
SELECT id, name, species, age
FROM animals
WHERE status = 'на обліку';
-- SELECT 4

INSERT INTO animals (name, species, age, status) VALUES ('Софі', 'кіт', 2, 'на обліку');
-- INSERT 0 1

SELECT COUNT(*) AS view_count FROM animals_active;
--  view_count 
-- ------------
--           5
-- (1 row)

SELECT COUNT(*) AS mat_view_count_before_refresh FROM animals_active_mat;
--  mat_view_count_before_refresh 
-- -------------------------------
--                              4
-- (1 row)

REFRESH MATERIALIZED VIEW animals_active_mat;
-- REFRESH MATERIALIZED VIEW

SELECT COUNT(*) AS mat_view_count_after_refresh FROM animals_active_mat;
--  mat_view_count_after_refresh 
-- ------------------------------
--                             5
-- (1 row)

-- ===== Завдання 5. CREATE OR REPLACE VIEW (нова колонка status — лише в кінець списку) =====
CREATE OR REPLACE VIEW animals_active AS
SELECT id, name, species, age, status
FROM animals
WHERE status = 'на обліку';
-- CREATE VIEW

SELECT * FROM animals_active;
--  id |  name  | species | age |  status   
-- ----+--------+---------+-----+-----------
--   1 | Барсик | кіт     |   3 | на обліку
--   2 | Рекс   | собака  |   5 | на обліку
--   4 | Бім    | собака  |   7 | на обліку
--   6 | Джек   | собака  |   1 | на обліку
--   8 | Софі   | кіт     |   2 | на обліку
-- (5 rows)

-- ===== Завдання 6. Які подання можна змінювати =====
CREATE VIEW animals_with_owners AS
SELECT a.id, a.name, a.species, o.last_name AS owner_last_name
FROM animals a
JOIN owners o ON o.id = a.owner_id;
-- CREATE VIEW

INSERT INTO animals_with_owners (name, species, owner_last_name) VALUES ('Тест', 'кіт', 'Коваленко');
-- ERROR:  cannot insert into view "animals_with_owners"
-- DETAIL:  Views that do not select from a single table or view are not automatically updatable.
-- HINT:  To enable inserting into the view, provide an INSTEAD OF INSERT trigger or an unconditional ON INSERT DO INSTEAD rule.

CREATE OR REPLACE VIEW animals_active AS
SELECT id, name, species, age, status
FROM animals
WHERE status = 'на обліку'
WITH CHECK OPTION;
-- CREATE VIEW

INSERT INTO animals_active (name, species, age, status) VALUES ('Альма', 'собака', 3, 'на обліку');
-- INSERT 0 1

INSERT INTO animals_active (name, species, age, status) VALUES ('Чужий', 'собака', 6, 'вибув');
-- ERROR:  new row violates check option for view "animals_active"
-- DETAIL:  Failing row contains (10, Чужий, собака, 6, вибув, null, 2026-11-25).

SELECT id, name, status FROM animals WHERE name IN ('Альма','Чужий');
--  id | name  |  status   
-- ----+-------+-----------
--   9 | Альма | на обліку
-- (1 row)

