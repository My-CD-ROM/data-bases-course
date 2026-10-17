CREATE TABLE cars (
	id INT PRIMARY KEY,
	brand TEXT NOT NULL DEFAULT "car brand",
	model TEXT NOT NULL UNIQUE,
	year INTEGER,
	price REAL CHECK (price > 1000),
	status TEXT
)

UPDATE cars_new SET price = 999 WHERE id = 4 видає помилку нижче

Execution finished with errors.
Result: CHECK constraint failed: price > 1000
At line 1:
UPDATE cars_new SET price = 999 WHERE id = 4