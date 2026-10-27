-- Завдання 1. Атомарна пара INSERT + UPDATE
BEGIN;
INSERT INTO sales (car_id, client_id, sale_date, final_price) VALUES (6, 1, '2026-10-26', 17000.0);
UPDATE cars SET status = 'продано' WHERE id = 6;
COMMIT;
SELECT * FROM sales WHERE car_id = 6;
SELECT id, brand, model, status FROM cars WHERE id = 6;
-- Результат: sales id=10 (6, 1, 2026-10-26, 17000.0); Duster, статус 'продано'

-- Завдання 2. Свідомий ROLLBACK
BEGIN;
INSERT INTO sales (car_id, client_id, sale_date, final_price) VALUES (7, 2, '2026-10-26', 29000.0);
UPDATE cars SET status = 'продано' WHERE id = 7;
ROLLBACK;
SELECT * FROM sales WHERE car_id = 7;
SELECT id, brand, model, status FROM cars WHERE id = 7;
SELECT COUNT(*) FROM sales;
-- Результат: перший SELECT порожній; Sportage 'в наявності'; у sales 10 рядків

-- Завдання 3. Проміжний стан усередині транзакції
BEGIN;
INSERT INTO sales (car_id, client_id, sale_date, final_price) VALUES (8, 3, '2026-10-26', 30000.0);
UPDATE cars SET status = 'продано' WHERE id = 8;
SELECT * FROM sales WHERE car_id = 8;
SELECT id, brand, model, status FROM cars WHERE id = 8;
-- Результат до COMMIT: sales id=11 (8, 3, 2026-10-26, 30000.0); CX-5 'продано'
ROLLBACK;
SELECT COUNT(*) FROM sales;
SELECT id, status FROM cars WHERE id = 8;
-- Результат після ROLLBACK: 10 рядків; CX-5 'в наявності'

-- Завдання 4. Помилка всередині транзакції
BEGIN;
UPDATE cars SET status = 'продано' WHERE id = 9;
INSERT INTO cars (brand, model, year, price, vin) VALUES ('Test', 'Dup', 2020, 10000.0, 'JTNB11HK5L3000001');
-- Помилка: Runtime error: UNIQUE constraint failed: cars.vin (19)
SELECT id, brand, model, status FROM cars WHERE id = 9;
-- Результат: Focus 'продано' (перша зміна є, транзакція відкрита)
ROLLBACK;
SELECT id, status FROM cars WHERE id = 9;
-- Результат: Focus 'в наявності'

-- Завдання 5. Забутий ROLLBACK
BEGIN;
UPDATE cars SET status = 'продано' WHERE id = 9;
INSERT INTO cars (brand, model, year, price, vin) VALUES ('Test', 'Dup', 2020, 10000.0, 'JTNB11HK5L3000001');
-- Помилка: Runtime error: UNIQUE constraint failed: cars.vin (19)
COMMIT;
SELECT id, brand, model, status FROM cars WHERE id = 9;
SELECT COUNT(*) FROM cars WHERE brand = 'Test';
SELECT COUNT(*) FROM cars;
-- Результат: Focus 'продано'; рядків 'Test' 0; усього машин 9
