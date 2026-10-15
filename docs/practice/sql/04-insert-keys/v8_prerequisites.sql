-- Variant 8. Food delivery
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("dishes"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS dishes;

CREATE TABLE dishes (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT,
    price REAL NOT NULL,
    restaurant TEXT
);

INSERT INTO dishes (name, category, price, restaurant) VALUES
    ('Піца Маргарита', 'Піца', 259, 'Bon Pizza'),
    ('Борщ', 'Перші страви', 120, 'Смачно Вдома'),
    ('Суші сет Філадельфія', 'Суші', 449, 'Sushi Master'),
    ('Бургер класичний', 'Бургери', 189, 'BurgerHouse'),
    ('Салат Цезар', 'Салати', 159, 'Смачно Вдома'),
    ('Паста Карбонара', 'Паста', 229, 'Bon Pizza');
