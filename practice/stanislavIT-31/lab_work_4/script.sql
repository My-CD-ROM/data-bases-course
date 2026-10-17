-- ============================================================
-- Practice 4. Adding records, setting keys and relationships
-- Variant 4: Apteka (Pharmacy)
-- Here the database first becomes a real linked structure of
-- three tables, exactly as planned in Practice 3:
--   dimension 1 : medicines(id, name, manufacturer, form, price, stock_quantity)
--   dimension 2 : suppliers(id, name, contact_person, phone, city)
--   fact table  : deliveries(id, medicine_id FK, supplier_id FK,
--                           delivery_date, quantity, purchase_price)
--
-- Run with:  sqlite3 medicines.db < script.sql
-- ============================================================

-- ---------- Task 1a. Enable foreign key checks first ----------
PRAGMA foreign_keys = ON;

-- ---------- Recreate dimension table 1 (from Practice 1 / prerequisites) ----------
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS medicines;

CREATE TABLE medicines (
    id                 INTEGER PRIMARY KEY,
    name               TEXT NOT NULL,
    manufacturer       TEXT,
    form               TEXT,
    price              REAL NOT NULL,
    stock_quantity     INTEGER NOT NULL DEFAULT 0
);

INSERT INTO medicines (name, manufacturer, form, price, stock_quantity) VALUES
    ('Paracetamol',   'Darnytsia',        'tablets',  45.00, 120),
    ('Aspirin',       'Bayer',            'tablets',  60.00, 80),
    ('No-Spa',        'Chinoin',          'tablets',  95.00, 50),
    ('Ibuprofen',     'Darnytsia',        'capsules', 70.00, 65),
    ('Vitamin C',     'Kyiv Vitamin Plant','tablets', 55.00, 100),
    ('Nasal spray',   'Pharmak',          'spray',    85.00, 40);

-- ---------- Task 1b. Create dimension table 2: suppliers ----------
CREATE TABLE suppliers (
    id               INTEGER PRIMARY KEY,
    name             TEXT NOT NULL,
    contact_person   TEXT,
    phone            TEXT,
    city             TEXT
);

-- ---------- Task 2. Create the fact table with two FOREIGN KEYs ----------
CREATE TABLE deliveries (
    id               INTEGER PRIMARY KEY,
    medicine_id      INTEGER NOT NULL,
    supplier_id      INTEGER NOT NULL,
    delivery_date    TEXT NOT NULL,
    quantity         INTEGER NOT NULL,
    purchase_price   REAL,
    FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE RESTRICT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE RESTRICT
);

-- ON DELETE strategy (justification, see readme.md):
--   medicine_id -> RESTRICT: delivery history is accounting data; deleting a
--       medicine that has ever been delivered must be forbidden.
--   supplier_id -> RESTRICT: the same logic — the pharmacy keeps the full
--       delivery ledger; removing a supplier with deliveries is not allowed.

-- ---------- Task 3a. Fill dimension table 2 (>= 5-6 rows) ----------
INSERT INTO suppliers (name, contact_person, phone, city) VALUES
    ('Optima-Pharm', 'Taras Bondarenko', '+38067 111 22 33', 'Lviv'),
    ('BaDM',         'Maria Rudenko',    '+38067 222 33 44', 'Kyiv'),
    ('Venta.Ltd',    'Yulia Kravets',    '+38067 333 44 55', 'Lviv'),
    ('Alba Ukraine', 'Oksana Honcharenko','+38067 444 55 66', 'Poltava'),
    ('Fra-M',        'Roman Lytvyn',     '+38067 555 66 77', 'Vinnytsia'),
    ('Medpharmcom',  'Sofia Zakharchenko','+38067 666 77 88', 'Odesa');

-- ---------- Task 3b. Fill the fact table (>= 8-10 rows), all FKs real ----------
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price) VALUES
    (1, 1, '2026-01-15', 100, 38.00),
    (1, 2, '2026-02-10', 120, 37.50),
    (2, 2, '2026-01-20', 80, 52.00),
    (3, 3, '2026-01-25', 60, 85.00),
    (4, 1, '2026-02-01', 65, 58.00),
    (5, 4, '2026-02-05', 100, 44.00),
    (6, 5, '2026-02-12', 40, 72.00),
    (2, 6, '2026-02-18', 90, 51.00),
    (3, 3, '2026-03-01', 70, 84.00),
    (6, 5, '2026-03-05', 50, 71.00);

-- ---------- Task 4. Intentional foreign key error ----------
-- Try to insert a delivery for a medicine that does not exist (medicine_id = 9999)
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
VALUES (9999, 1, '2026-03-10', 5, 10.00);
-- Expected exact error from SQLite:
--   Error: FOREIGN KEY constraint failed
-- This proves PRAGMA foreign_keys = ON actually works on this connection.

-- ---------- Task 5. Compare with the ER diagram of Practice 3 ----------
.schema medicines
.schema suppliers
.schema deliveries

-- Verify the structure: three tables, correct FK directions
SELECT 'deliveries rows: ' || COUNT(*) AS fact_rows FROM deliveries;
SELECT 'suppliers rows: ' || COUNT(*) AS dim2_rows FROM suppliers;
