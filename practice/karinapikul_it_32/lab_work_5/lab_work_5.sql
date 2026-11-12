– Практична робота №5

– Завдання 1. NOT NULL
– birth_date у clients має NOT NULL

INSERT INTO clients (last_name, first_name, phone)
VALUES (‘Karina’, ‘Pikul’, ‘+380000000000’);

– Завдання 2. UNIQUE
– phone у clients має UNIQUE

INSERT INTO clients (last_name, first_name, phone, birth_date)
VALUES (‘Karina’, ‘Pikul’, ‘+380501112233’, ‘2009-03-01’);

– Завдання 3. CHECK
– price у memberships має CHECK (price > 0)

INSERT INTO memberships (type, duration_days, price, description)
VALUES (‘neznay’, 10, -500, ‘ww’);

INSERT INTO memberships (type, duration_days, price, description)
VALUES (‘Тестовий’, 5, 500, ‘Test’);

– Завдання 4. DEFAULT
– description має DEFAULT ‘Без опису’

INSERT INTO memberships (type, duration_days, price)
VALUES (‘VIP’, 10, 2500);

SELECT * FROM memberships
WHERE type = ‘VIP’;

– Завдання 5. Перевірка CHECK через UPDATE

UPDATE memberships
SET price = -100
WHERE id = 1;