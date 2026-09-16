-- ============================================================
-- Practice 10. Sorting and filtering data (ORDER BY, DISTINCT,
--               BETWEEN, IN, LIKE)
-- Variant 4: Apteka (Pharmacy)
-- The schema does NOT change — only selection queries.
--
-- Run with:  sqlite3 medicines.db < script.sql
-- ============================================================

PRAGMA foreign_keys = ON;

-- ---------- Recreate the full three-table schema (self-contained) ----------
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS suppliers;
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
    ('Paracetamol', 'Darnytsia', 'tablets', 25.0, 120),
    ('Ibuprofen', 'Pharmak', 'tablets', 45.0, 90),
    ('No-Spa', 'Chinoin', 'tablets', 110.0, 60),
    ('Aspirin', 'Bayer', 'tablets', 55.0, 80),
    ('Mukaltin', 'Ternopharm', 'tablets', 30.0, 100),
    ('Validol', 'Darnytsia', 'tablets', 20.0, 70),
    ('Amoxicillin', 'Kyivmedpreparat', 'capsules', 65.0, 50),
    ('Loratadine', 'Pharmak', 'tablets', 40.0, 65),
    ('Cough syrup', 'Ternopharm', 'syrup', 85.0, 40),
    ('Burn cream', 'Darnytsia', 'ointment', 95.0, 35),
    ('Vitamin C', 'Pharmak', 'tablets', 60.0, 110),
    ('Activated charcoal', 'Kyivmedpreparat', 'tablets', 15.0, 150),
    -- two rows with real UKRAINIAN (Cyrillic) names, to test LIKE case behaviour
    ('Називін', 'Merck', 'drops', 98.0, 30),
    ('Аскорбінова кислота', 'Kyiv Vitamin Plant', 'tablets', 32.0, 200);

CREATE TABLE suppliers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    contact_person TEXT,
    phone TEXT,
    city TEXT
);
INSERT INTO suppliers (name, contact_person, phone, city) VALUES
    ('Optima-Pharm', 'Taras Bondarenko', '+380****0001', 'Lviv'),
    ('BaDM', 'Maria Rudenko', '+380****0002', 'Kyiv'),
    ('Venta.Ltd', 'Yulia Kravets', '+380****0003', 'Lviv'),
    ('Alba Ukraine', 'Oksana Honcharenko', '+380****0004', 'Poltava'),
    ('Fra-M', 'Roman Lytvyn', '+380****0005', 'Vinnytsia'),
    ('Medpharmcom', 'Sofia Zakharchenko', '+380****0006', 'Odesa'),
    ('Liky Control', 'Maksym Oliinyk', '+380****0007', 'Cherkasy'),
    ('Pharmacy Holding', 'Maksym Melnyk', '+380****0008', 'Vinnytsia'),
    ('UniPharma', 'Andriy Lytvyn', '+380****0009', 'Dnipro'),
    ('Pharmpostach', 'Bohdan Hrytsenko', '+380****0010', 'Poltava'),
    ('Medzabezpechennia', 'Ihor Kravets', '+380****0011', 'Odesa'),
    ('Lixem', 'Maksym Melnyk', '+380****0012', 'Vinnytsia');

CREATE TABLE deliveries (
    id INTEGER PRIMARY KEY,
    medicine_id INTEGER NOT NULL,
    supplier_id INTEGER NOT NULL,
    delivery_date TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    purchase_price REAL,
    FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE RESTRICT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE RESTRICT
);
INSERT INTO deliveries (id, medicine_id, supplier_id, delivery_date, quantity, purchase_price) VALUES
    (1, 5, 10, '2025-09-01', 76, 85.85),
    (2, 2, 4,  '2025-08-18', 40, 65.25),
    (3, 11, 12,'2025-08-26', 12, 17.44),
    (4, 4, 7,  '2024-05-22', 84, 39.52),
    (5, 9, 9,  '2025-07-24', 80, 36.46),
    (6, 12, 8, '2025-05-09', 39, 19.65),
    (7, 4, 6,  '2024-12-18', 98, 24.81),
    (8, 4, 12, '2025-05-24', 85, 88.13),
    (9, 9, 10, '2025-02-27', 34, 33.70),
    (10, 6, 3, '2025-01-23', 78, 20.13),
    (11, 1, 1, '2025-12-05', 91, 79.48),
    (12, 8, 2, '2024-10-10', 70, 48.30);

-- ============================================================
-- Task 1. ORDER BY a single date column, DESCENDING
-- Most recent delivery first.
-- ============================================================
SELECT id, delivery_date, quantity
FROM deliveries
ORDER BY delivery_date DESC;

-- ============================================================
-- Task 2. ORDER BY two columns at once
-- First by supplier city (alphabetical), then by delivery date within
-- the same city.
-- ============================================================
SELECT d.id, s.city, d.delivery_date, d.quantity
FROM deliveries d
JOIN suppliers s ON s.id = d.supplier_id
ORDER BY s.city, d.delivery_date;

-- ============================================================
-- Task 3. Top-3 via ORDER BY + LIMIT
-- The 3 largest single deliveries by quantity.
-- ============================================================
SELECT id, quantity, purchase_price
FROM deliveries
ORDER BY quantity DESC
LIMIT 3;

-- ============================================================
-- Task 4. DISTINCT and BETWEEN/IN
-- (a) DISTINCT over a "category" column (form) of dimension 1.
-- (b) BETWEEN on a numeric column (price) — more natural here than IN,
--     because we want a CONTINUOUS price range, not a discrete list.
-- ============================================================
SELECT DISTINCT form FROM medicines;

SELECT name, form, price
FROM medicines
WHERE price BETWEEN 40 AND 80
ORDER BY price;

-- ============================================================
-- Task 5. LIKE and the Cyrillic (Ukrainian) case pitfall
-- The database contains real Ukrainian values (e.g. 'Називін').
-- SQLite's built-in LIKE is CASE-SENSITIVE for non-ASCII text, so a
-- lowercase 'н' does NOT match an uppercase 'Н'.
-- ============================================================
-- (a) Pattern with UPPERCASE first letter  'Н%'  -> matches 'Називін'
SELECT name FROM medicines WHERE name LIKE 'Н%';

-- (b) Pattern with LOWERCASE first letter  'н%'  -> matches NOTHING
SELECT name FROM medicines WHERE name LIKE 'н%';

-- (c) Same behaviour on 'А'/'а' (Аскорбінова ...)
SELECT name FROM medicines WHERE name LIKE 'А%';
SELECT name FROM medicines WHERE name LIKE 'а%';

-- (d) COLLATE NOCASE does NOT fix Cyrillic either (it only folds ASCII)
SELECT name FROM medicines WHERE name LIKE 'н%' COLLATE NOCASE;

-- (English comparison, ASCII, for contrast: LIKE here IS case-insensitive)
SELECT name FROM medicines WHERE name LIKE '%acin%';   -- matches Paracetamol etc.
