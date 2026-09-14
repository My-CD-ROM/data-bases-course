SELECT brand, model, year, price
FROM cars;


SELECT brand, model, price
FROM cars
WHERE price > 30000;



SELECT brand, model, year, price
FROM cars
LIMIT 5;



INSERT INTO cars (id, brand, model, year, price, status)
VALUES (12, 'Mazda', 'CX-5', 2023, 29500.0, NULL);

SELECT brand, model, status
FROM cars
WHERE status IS NULL;

SELECT brand, model, status
FROM cars
WHERE status IS NOT NULL;



SELECT brand, model, year, price
FROM cars
WHERE price > 25000 AND year >= 2022;

-- 1. WHERE price = NULL не працює, тому що NULL означає невідоме значення. Для перевірки потрібно використовувати IS NULL

-- 2. WHERE фільтрує окремі рядки до групування, а HAVING фільтрує вже сформовані групи

-- 3. SELECT * краще уникати, коли потрібні не всі стовпці, тому що явний перелік стовпців робить запит зрозумілішим.