-- Variant 4. Pharmacy
-- State of the database BEFORE Practice 4: only dimension table 1
-- ("medicines"), as Practice 1 should have produced.

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS medicines;

CREATE TABLE medicines (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    manufacturer TEXT,
    form TEXT,
    price REAL NOT NULL,
    stock_quantity INTEGER NOT NULL DEFAULT 0
);

INSERT INTO medicines (name, manufacturer, form, price, stock_quantity) VALUES
    ('Парацетамол', 'Дарниця', 'таблетки', 45.0, 120),
    ('Аспірин', 'Bayer', 'таблетки', 60.0, 80),
    ('Но-шпа', 'Chinoin', 'таблетки', 95.0, 50),
    ('Ібупрофен', 'Дарниця', 'капсули', 70.0, 65),
    ('Вітамін C', 'Київський вітамінний завод', 'таблетки', 55.0, 100),
    ('Назальний спрей', 'Фармак', 'спрей', 85.0, 40);
