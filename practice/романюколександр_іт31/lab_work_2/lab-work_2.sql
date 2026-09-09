SELECT name, category, size, price FROM products;

SELECT price FROM products WHERE price > 1000;

SELECT * FROM products LIMIT 2;

INSERT INTO products (name, category, size, price, stock_quantity) VALUES
  ("Блакитна сорочка", NULL, "M", 185.345, 57);

SELECT name FROM products WHERE category IS NULL;

SELECT category FROM products WHERE category IS NOT NULL;

SELECT name, size, price, stock_quantity FROM products WHERE stock_quantity > 25 AND price < 1000;

-- Відповіді на питання:

-- Завдання 4
-- Запит умови через = NULL неможливо коректно написати, бо результат вийде NULL, а має бути TRUE. 
-- Причиною для цього є поведінка SQLite.

-- Контрольні питання
-- Чому запит WHERE price = NULL завжди повертає порожній результат, навіть якщо в таблиці є рядки з NULL у стовпці price? 
-- Що саме потрібно написати замість цього?
-- Тому що за логікою SQLite, все що порівнюється із NULL повертає NULL. Замість порівняння price = NULL треба написати price IS NULL.

-- Чим WHERE принципово відрізняється від HAVING? 
-- WHERE фільтрує окремі рядки у таблиці, а HAVING - групи рядків у таблиці.

-- У якому випадку варто уникати SELECT *, і чому саме?
-- Використання SELECT * варто уникати при роботі із базами даних, які працюють в реальному часі. 
-- Усе через те, що ця команда покаже всю базу даних, де може бути конфіденційна інформація, а також може перевантажити систему.