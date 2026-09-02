SELECT id, name, price, form
FROM medicines;

-- Завдання 2
SELECT name, price FROM medicines WHERE price > 100;

-- Завдання 3
SELECT * FROM medicines LIMIT 3;

--Завдання 4
INSERT INTO medicines (name, manufacturer, form, price) 
VALUES ('Аспірин', 'Фармак', NULL, 45.50);

SELECT name, price, form 
FROM medicines 
WHERE form IS NULL;

SELECT name, price, form 
FROM medicines 
WHERE form IS NOT NULL;

SELECT name, price, form 
FROM medicines 
WHERE price > 50 AND (price < 200 OR form IS NOT NULL);
