# Практика 12. Сортування і фільтрація даних
# Варіант 3 — Кінотеатр

-- Завдання 1. ORDER BY за однією колонкою
SELECT
    id,
    movie_id,
    viewer_id,
    price,
    purchase_date
FROM tickets
ORDER BY purchase_date DESC;

-- Результат:
-- id 9 і 10 — найновіші квитки, дата купівлі 2026-11-22.
-- Усього виведено 10 записів.

-- Завдання 2. ORDER BY за двома колонками
SELECT
    id,
    hall,
    purchase_date,
    price
FROM tickets
ORDER BY hall ASC, purchase_date DESC;

-- Результат:
-- Спочатку квитки із залу 1, потім із залу 2.
-- Усередині кожного залу записи відсортовані за датою спадання.

-- Завдання 3. Три найдорожчі квитки
SELECT
    id,
    movie_id,
    hall,
    price,
    purchase_date
FROM tickets
ORDER BY price DESC
LIMIT 3;

-- Результат:
-- id 6 — 190 грн.
-- id 2 — 180 грн.
-- id 10 — 180 грн.

-- Завдання 4а. DISTINCT — унікальні жанри
SELECT DISTINCT genre
FROM movies;

-- Результат:
-- драма, бойовик, анімація, комедія, Комедія.
-- Кількість унікальних значень: 5.

-- Завдання 4б. IN — пошук конкретних цін
SELECT
    id,
    movie_id,
    price
FROM tickets
WHERE price IN (150, 180);

-- Результат:
-- Знайдено 5 квитків із ціною 150 або 180 грн.

-- Завдання 5а. LIKE з великої літери
SELECT id, title
FROM movies
WHERE title LIKE 'Памфір%';

-- Результат:
-- id 6 — Памфір. Знайдено 1 запис.

-- Завдання 5б. LIKE з малої літери
SELECT id, title
FROM movies
WHERE title LIKE 'памфір%';

-- Результат:
-- Жодного запису не знайдено.