-- Завдання 1: NOT NULL на guests.phone
ALTER TABLE guests RENAME TO guests_old;
CREATE TABLE guests (
    id         INTEGER PRIMARY KEY,
    last_name  TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email      TEXT,
    phone      TEXT NOT NULL
);
INSERT INTO guests SELECT * FROM guests_old;
DROP TABLE guests_old;

-- Завдання 2: UNIQUE на guests.email
ALTER TABLE guests RENAME TO guests_old;
CREATE TABLE guests (
    id         INTEGER PRIMARY KEY,
    last_name  TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email      TEXT UNIQUE,
    phone      TEXT NOT NULL
);
INSERT INTO guests SELECT * FROM guests_old;
DROP TABLE guests_old;

-- Завдання 3: CHECK на rooms.capacity
ALTER TABLE rooms RENAME TO rooms_old;
CREATE TABLE rooms (
    id                 INTEGER PRIMARY KEY,
    type               TEXT NOT NULL,
    price_per_night    REAL NOT NULL,
    capacity           INTEGER NOT NULL CHECK (capacity > 0),
    status             TEXT NOT NULL
);
INSERT INTO rooms SELECT * FROM rooms_old;
DROP TABLE rooms_old;

-- Завдання 4: DEFAULT на rooms.status
ALTER TABLE rooms RENAME TO rooms_old;
CREATE TABLE rooms (
    id                 INTEGER PRIMARY KEY,
    type               TEXT NOT NULL,
    price_per_night    REAL NOT NULL,
    capacity           INTEGER NOT NULL CHECK (capacity > 0),
    status             TEXT NOT NULL DEFAULT 'вільний'
);
INSERT INTO rooms SELECT * FROM rooms_old;
DROP TABLE rooms_old;

INSERT INTO rooms (type, price_per_night, capacity) VALUES ('пентхаус', 6000.0, 4);

-- Завдання 5: порушення CHECK через UPDATE (розкоментувати для перевірки)
-- UPDATE rooms SET capacity = 0 WHERE type = 'одномісний';
