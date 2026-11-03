-- ПРАКТИЧНА РОБОТА № 11
-- Батура Каріна, група ІТ-31
-- Варіант 2: Інтернет-магазин одягу 

-- Завдання 1.
CREATE TABLE product_reviews (
    id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    review_date TEXT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE CASCADE
);

INSERT INTO product_reviews (id, product_id, rating, comment, review_date) VALUES
(1, 1, 5, 'Чудова тепла куртка, дуже задоволена!', '2026-09-15'),
(2, 1, 4, 'Гарна якість, але трохи важкувата.', '2026-10-02'),
(3, 2, 3, 'Джинси непогані, але розмір не зовсім підійшов.', '2026-09-20'),
(4, 2, 5, 'Ідеальна посадка, рекомендую!', '2026-10-05'),
(5, 3, 5, 'Найм’якше худі у світі!', '2026-08-10'),
(6, 3, 4, 'Тепле і зручне, після прання все ок.', '2026-10-01'),
(7, 4, 5, 'Шкіра м''яка, кросівки супер!', '2026-10-04');


-- Завдання 2.
SELECT 
    products.id AS product_id,
    products.name AS product_name,
    AVG(product_reviews.rating) AS avg_rating
FROM products
JOIN product_reviews ON product_reviews.product_id = products.id
GROUP BY products.id;


-- Завдання 3. 
SELECT 
    products.id AS product_id,
    products.name AS product_name,
    AVG(product_reviews.rating) AS avg_rating
FROM products
JOIN product_reviews ON product_reviews.product_id = products.id
GROUP BY products.id
HAVING AVG(product_reviews.rating) >= 4.0;


-- Завдання 4. 
SELECT 
    products.id AS product_id,
    products.name AS product_name,
    AVG(product_reviews.rating) AS avg_rating
FROM products
JOIN product_reviews ON product_reviews.product_id = products.id
WHERE product_reviews.review_date >= '2026-10-01'
GROUP BY products.id
HAVING AVG(product_reviews.rating) >= 4.0;