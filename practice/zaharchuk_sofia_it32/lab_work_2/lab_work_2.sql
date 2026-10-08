-- Виправлення схеми: дозволити NULL у стовпці status
CREATE TABLE rooms_new (
    id                 INTEGER PRIMARY KEY,
    type               TEXT NOT NULL,
    price_per_night    REAL NOT NULL,
    capacity           INTEGER NOT NULL,
    status             TEXT
);
INSERT INTO rooms_new SELECT * FROM rooms;
DROP TABLE rooms;
ALTER TABLE rooms_new RENAME TO rooms;

-- Завдання 1: SELECT з явним переліком стовпців
SELECT type, price_per_night, capacity FROM rooms;

-- Завдання 2: WHERE за умовою варіанта
SELECT type, price_per_night FROM rooms WHERE price_per_night > 1000;

-- Завдання 3: LIMIT
SELECT type, price_per_night FROM rooms LIMIT 3;

-- Завдання 4: IS NULL / IS NOT NULL
INSERT INTO rooms (type, price_per_night, capacity, status) VALUES ('економ', 700.0, 1, NULL);
SELECT type, status FROM rooms WHERE status IS NULL;
SELECT type, status FROM rooms WHERE status IS NOT NULL;

-- Завдання 5: складена умова
SELECT type, price_per_night, capacity FROM rooms WHERE price_per_night > 1000 AND capacity >= 2;
