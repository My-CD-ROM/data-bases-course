-- Завдання 1. SELECT з явним переліком стовпців
SELECT name, brand, year, price
FROM cars2
LIMIT 10;

-- Завдання 2. WHERE за умовою варіанта (рік випуску)
SELECT name, brand, year
FROM cars2
WHERE year > 2015;

-- Завдання 3. LIMIT — перші 5 записів
SELECT name, brand, year
FROM cars2
LIMIT 5;

-- Завдання 4. Вставка рядка з NULL у стовпець pride (rating)
INSERT INTO cars2 (id, name, brand, year, type, price, pride)
VALUES (1, 'Model X', 'Tesla', 2022, 'SUV', 45000, NULL);

-- Завдання 4. Перевірка IS NULL — рядки без відомого pride
SELECT name, brand, pride
FROM cars2
WHERE pride IS NULL;

-- Завдання 4. Перевірка IS NOT NULL — рядки з відомим pride
SELECT name, brand, pride
FROM cars2
WHERE pride IS NOT NULL;

-- Завдання 5. Складена умова через AND
SELECT name, brand, year, price
FROM cars2
WHERE year > 2015 AND price < 50000;

-- Завдання 5. Складена умова AND + OR з явними дужками
SELECT name, brand, year, price
FROM cars2
WHERE (year > 2015 AND price < 50000) OR year > 2023;