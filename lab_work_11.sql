PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS reviews (
    id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    review_date TEXT NOT NULL,
    comment TEXT NOT NULL,
    FOREIGN KEY(product_id) REFERENCES products(id) ON DELETE CASCADE
);

INSERT INTO reviews (id, product_id, rating, review_date, comment) VALUES
(1, 1, 5, '2026-09-03', 'Якісний матеріал'),
(2, 1, 4, '2026-09-07', 'Зручна футболка'),
(3, 1, 5, '2026-09-18', 'Відповідає опису'),
(4, 2, 4, '2026-09-05', 'Добре для спорту'),
(5, 2, 3, '2026-09-19', 'Трохи тонка тканина'),
(6, 3, 5, '2026-09-08', 'Гарна посадка'),
(7, 3, 4, '2026-09-21', 'Якісні джинси'),
(8, 4, 3, '2026-09-25', 'Тепле худі, але є нюанси');

SELECT p.id, p.name, COUNT(r.id) AS reviews_count,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM products p
JOIN reviews r ON r.product_id = p.id
GROUP BY p.id, p.name
ORDER BY p.id;

SELECT p.id, p.name, COUNT(r.id) AS reviews_count,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM products p
JOIN reviews r ON r.product_id = p.id
GROUP BY p.id, p.name
HAVING AVG(r.rating) >= 4
ORDER BY p.id;

SELECT p.id, p.name, COUNT(r.id) AS reviews_count,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM products p
JOIN reviews r ON r.product_id = p.id
WHERE r.review_date >= '2026-09-01'
GROUP BY p.id, p.name
HAVING AVG(r.rating) >= 4
ORDER BY p.id;

SELECT p.id, p.name, COUNT(r.id) AS reviews_count,
       ROUND(AVG(r.rating), 2) AS average_rating
FROM products p
LEFT JOIN reviews r ON r.product_id = p.id
WHERE r.review_date >= '2026-09-01'
GROUP BY p.id, p.name
HAVING AVG(r.rating) >= 4
ORDER BY p.id;