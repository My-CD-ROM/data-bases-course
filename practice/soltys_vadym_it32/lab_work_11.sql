-- Практика 11. Комбіновані завдання (варіант 2, інтернет-магазин одягу)
-- Питання: які товари справді подобаються покупцям ЗАРАЗ (високий середній рейтинг за останні місяці)?
PRAGMA foreign_keys = ON;

-- Завдання 1. Нова залежна таблиця відгуків, пов'язана з products
CREATE TABLE reviews (
    id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    client_id INTEGER,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_date TEXT NOT NULL DEFAULT (date('now')),
    comment TEXT,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE,
    FOREIGN KEY (client_id) REFERENCES clients (id) ON DELETE SET NULL
);

INSERT INTO reviews (product_id, client_id, rating, review_date, comment) VALUES
 (1, 1, 5, '2026-02-10', 'Приємна тканина, сіла ідеально'),
 (1, 2, 5, '2026-03-15', 'Чудова якість за свою ціну'),
 (1, 4, 3, '2026-08-20', 'Після прання трохи сіла'),
 (2, 5, 2, '2026-08-05', 'Шов розійшовся за тиждень'),
 (2, 4, 2, '2026-09-12', 'Розмір не відповідає таблиці'),
 (3, 2, 4, '2026-09-02', 'Тепла, але трохи важка'),
 (3, 5, 5, '2026-09-20', 'Найкраща куртка, яку мав'),
 (4, 1, 5, '2026-09-15', 'Легка й гарна'),
 (5, 4, 3, '2026-08-30', 'Зручні, але швидко стоптались'),
 (6, 2, 5, '2026-02-25', 'Тепла шапка');
-- Групи за product_id: товар 1 → 3, товар 2 → 2, товар 3 → 2, товари 4, 5, 6 → по 1.
-- Товар 7 («Шарф вовняний») відгуків не має (потрібен для Завдання 5).

-- Завдання 2. JOIN + GROUP BY за p.id
SELECT p.name, COUNT(r.id) AS reviews_count, AVG(r.rating) AS avg_rating
FROM products p
JOIN reviews r ON r.product_id = p.id
GROUP BY p.id;
-- Результат: Футболка базова 3|4.33 ; Джинси класичні 2|2.0 ; Куртка зимова 2|4.5 ;
--            Сукня літня 1|5.0 ; Кросівки спортивні 1|3.0 ; Шапка вовняна 1|5.0

-- Завдання 3. + HAVING (середня оцінка не нижче 4)
SELECT p.name, COUNT(r.id) AS reviews_count, AVG(r.rating) AS avg_rating
FROM products p
JOIN reviews r ON r.product_id = p.id
GROUP BY p.id
HAVING AVG(r.rating) >= 4;
-- Результат: Футболка базова 3|4.33 ; Куртка зимова 2|4.5 ; Сукня літня 1|5.0 ; Шапка вовняна 1|5.0

-- Завдання 4. JOIN + WHERE (відгуки від 2026-07-01) + GROUP BY + HAVING
SELECT p.name, COUNT(r.id) AS reviews_count, AVG(r.rating) AS avg_rating
FROM products p
JOIN reviews r ON r.product_id = p.id
WHERE r.review_date >= '2026-07-01'
GROUP BY p.id
HAVING AVG(r.rating) >= 4;
-- Результат: Куртка зимова 2|4.5 ; Сукня літня 1|5.0

-- Завдання 5 (а). Пастка групування: додаємо «двійника» товару 1 (та сама назва, інший розмір)
INSERT INTO products (name, category, size, price, stock_quantity)
VALUES ('Футболка базова', 'Футболки', 'L', 299.0, 25);      -- отримує id = 8
INSERT INTO reviews (product_id, client_id, rating, review_date, comment) VALUES
 (8, 6, 2, '2026-09-25', 'Тканина тонка, просвічує'),
 (8, 5, 3, '2026-09-28', 'Звичайна, нічого особливого');

-- Запит із Завдання 3, групування за id
SELECT p.name, COUNT(r.id) AS reviews_count, AVG(r.rating) AS avg_rating
FROM products p
JOIN reviews r ON r.product_id = p.id
GROUP BY p.id
HAVING AVG(r.rating) >= 4;
-- Результат: Футболка базова 3|4.33 (id 1) ; Куртка зимова 2|4.5 ; Сукня літня 1|5.0 ; Шапка вовняна 1|5.0
--            (двійник id 8 із середнім 2.5 відсіяно)

-- Той самий запит, групування за назвою
SELECT p.name, COUNT(r.id) AS reviews_count, AVG(r.rating) AS avg_rating
FROM products p
JOIN reviews r ON r.product_id = p.id
GROUP BY p.name
HAVING AVG(r.rating) >= 4;
-- Результат: Куртка зимова 2|4.5 ; Сукня літня 1|5.0 ; Шапка вовняна 1|5.0
--            («Футболка базова» зникла: два товари злиті в одну групу з 5 відгуками й середнім 3.6)

-- Завдання 5 (б). LEFT JOIN замість JOIN у запиті Завдання 4
SELECT p.name, COUNT(r.id) AS reviews_count, AVG(r.rating) AS avg_rating
FROM products p
LEFT JOIN reviews r ON r.product_id = p.id
WHERE r.review_date >= '2026-07-01'
GROUP BY p.id
HAVING AVG(r.rating) >= 4;
-- Результат: Куртка зимова 2|4.5 ; Сукня літня 1|5.0   (без змін)
