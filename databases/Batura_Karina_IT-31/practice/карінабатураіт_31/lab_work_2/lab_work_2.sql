-- Практична робота №2 (Варіант 2: products)
-- Студентка: Батура Каріна Віталіївна Група: ІТ-31

-- Завдання 1
SELECT name, price, size, category FROM products;

-- Завдання 2
SELECT name, price, size FROM products WHERE price > 500;

-- Завдання 3
SELECT name, price FROM products LIMIT 3;

-- Завдання 4
ALTER TABLE products ADD COLUMN description TEXT;

INSERT INTO products (name, category, size, price, stock_quantity, description) 
VALUES ('Сорочка лляна', 'Одяг', 'L', 1200.0, 5, NULL);

SELECT name, price, description FROM products WHERE description IS NULL;
SELECT name, price, description FROM products WHERE description IS NOT NULL;

-- Завдання 5
SELECT name, price, size, category 
FROM products 
WHERE price <= 1500 AND (size = 'M' OR category = 'Одяг');