-- ============================================================
-- Practice 16. Creating a database in PostgreSQL (PgAdmin)
-- Variant 4: Apteka (Pharmacy)
-- Translate the ready three-table schema from SQLite into PostgreSQL
-- and load the accumulated data, then fix the id counters.
--
-- Database: pharmacy_db   (created in PgAdmin: right-click server ->
--            Create -> Database, name: pharmacy_db)
-- Run in the Query Tool / via psql.
-- ============================================================

-- Idempotent cleanup so the script can be re-run:
DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS medicines;

-- ============================================================
-- Task 2. The three translated CREATE TABLE
--   * GENERATED ALWAYS AS IDENTITY instead of INTEGER PRIMARY KEY
--   * proper types (TEXT, INTEGER, NUMERIC)
--   * FOREIGN KEY on both links of the fact table (NO PRAGMA needed —
--     PostgreSQL enforces foreign keys natively)
-- ============================================================
CREATE TABLE medicines (
    id               INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name             TEXT NOT NULL,
    manufacturer     TEXT,
    form             TEXT,
    price            NUMERIC NOT NULL,
    stock_quantity   INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE suppliers (
    id               INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name             TEXT NOT NULL,
    contact_person   TEXT,
    phone            TEXT,
    city             TEXT
);

CREATE TABLE deliveries (
    id               INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    medicine_id      INTEGER NOT NULL REFERENCES medicines(id) ON DELETE RESTRICT,
    supplier_id      INTEGER NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    delivery_date    DATE NOT NULL,
    quantity         INTEGER NOT NULL,
    purchase_price   NUMERIC
);

-- ============================================================
-- Task 3. Load the data (as exported from SQLite / re-entered here),
-- keeping the original ids exactly as they were in SQLite so that the
-- migrated counts and ids match. NOTE: with GENERATED ALWAYS AS IDENTITY
-- an explicit id is only allowed via OVERRIDING SYSTEM VALUE (the CSV
-- migration in PgAdmin behaves the same way).
-- ============================================================
INSERT INTO medicines (id, name, manufacturer, form, price, stock_quantity)
    OVERRIDING SYSTEM VALUE VALUES
    (1,  'Paracetamol',        'Darnytsia',        'tablets',  25.0, 120),
    (2,  'Ibuprofen',          'Pharmak',          'tablets',  45.0, 90),
    (3,  'No-Spa',             'Chinoin',          'tablets',  110.0, 60),
    (4,  'Aspirin',            'Bayer',            'tablets',  55.0, 80),
    (5,  'Mukaltin',           'Ternopharm',       'tablets',  30.0, 100),
    (6,  'Validol',            'Darnytsia',        'tablets',  20.0, 70),
    (7,  'Amoxicillin',        'Kyivmedpreparat',  'capsules', 65.0, 50),
    (8,  'Loratadine',         'Pharmak',          'tablets',  40.0, 65),
    (9,  'Cough syrup',        'Ternopharm',       'syrup',    85.0, 40),
    (10, 'Burn cream',         'Darnytsia',        'ointment', 95.0, 35),
    (11, 'Vitamin C',          'Pharmak',          'tablets',  60.0, 110),
    (12, 'Activated charcoal', 'Kyivmedpreparat',  'tablets',  15.0, 150);

INSERT INTO suppliers (id, name, contact_person, phone, city)
    OVERRIDING SYSTEM VALUE VALUES
    (1,  'Optima-Pharm',      'Taras Bondarenko',  '+380****0001', 'Lviv'),
    (2,  'BaDM',              'Maria Rudenko',     '+380****0002', 'Kyiv'),
    (3,  'Venta.Ltd',         'Yulia Kravets',     '+380****0003', 'Lviv'),
    (4,  'Alba Ukraine',      'Oksana Honcharenko','+380****0004', 'Poltava'),
    (5,  'Fra-M',             'Roman Lytvyn',      '+380****0005', 'Vinnytsia'),
    (6,  'Medpharmcom',       'Sofia Zakharchenko','+380****0006', 'Odesa'),
    (7,  'Liky Control',      'Maksym Oliinyk',    '+380****0007', 'Cherkasy'),
    (8,  'Pharmacy Holding',  'Maksym Melnyk',     '+380****0008', 'Vinnytsia'),
    (9,  'UniPharma',         'Andriy Lytvyn',     '+380****0009', 'Dnipro'),
    (10, 'Pharmpostach',      'Bohdan Hrytsenko',  '+380****0010', 'Poltava'),
    (11, 'Medzabezpechennia', 'Ihor Kravets',      '+380****0011', 'Odesa'),
    (12, 'Lixem',             'Maksym Melnyk',     '+380****0012', 'Vinnytsia');

INSERT INTO deliveries (id, medicine_id, supplier_id, delivery_date, quantity, purchase_price)
    OVERRIDING SYSTEM VALUE VALUES
    (1,  5,  10, '2025-09-01', 76, 85.85),
    (2,  2,  4,  '2025-08-18', 40, 65.25),
    (3,  11, 12, '2025-08-26', 12, 17.44),
    (4,  4,  7,  '2024-05-22', 84, 39.52),
    (5,  9,  9,  '2025-07-24', 80, 36.46),
    (6,  12, 8,  '2025-05-09', 39, 19.65),
    (7,  4,  6,  '2024-12-18', 98, 24.81),
    (8,  4,  12, '2025-05-24', 85, 88.13),
    (9,  9,  10, '2025-02-27', 34, 33.70),
    (10, 6,  3,  '2025-01-23', 78, 20.13),
    (11, 1,  1,  '2025-12-05', 91, 79.48),
    (12, 8,  2,  '2024-10-10', 70, 48.30),
    (13, 6,  3,  '2024-05-28', 71, 19.13),
    (14, 2,  7,  '2025-02-19', 90, 64.92),
    (15, 3,  3,  '2025-02-08', 25, 54.65),
    (16, 7,  10, '2024-09-13', 67, 82.68),
    (17, 5,  10, '2025-05-19', 89, 14.82),
    (18, 12, 2,  '2024-11-07', 43, 62.83),
    (19, 3,  4,  '2024-09-03', 30, 10.21),
    (20, 8,  12, '2025-05-02', 39, 33.05);

-- ============================================================
-- Task 4. Fix the id counters for ALL THREE tables.
-- After importing rows with explicit ids, the identity sequence still
-- starts at 1; setval() pushes it to MAX(id) so the next INSERT does
-- not try to repeat an already used id.
-- ============================================================
SELECT setval(pg_get_serial_sequence('medicines', 'id'), (SELECT MAX(id) FROM medicines));
SELECT setval(pg_get_serial_sequence('suppliers', 'id'), (SELECT MAX(id) FROM suppliers));
SELECT setval(pg_get_serial_sequence('deliveries', 'id'), (SELECT MAX(id) FROM deliveries));

-- Prove the counter continues correctly (not repeating an existing id):
INSERT INTO medicines (name, manufacturer, form, price, stock_quantity)
VALUES ('Nimesil', 'Berlin-Chemie', 'powder', 65.0, 45) RETURNING id;   -- must be 13

-- ============================================================
-- Task 5. Integrity check of the migration + intentional FK error
-- ============================================================
SELECT 'medicines', COUNT(*) FROM medicines
UNION ALL SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL SELECT 'deliveries', COUNT(*) FROM deliveries;

-- Intentional FK error: a delivery for a medicine that does not exist.
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
VALUES (9999, 1, '2026-01-01', 5, 9.99);
-- Expected exact PostgreSQL error:
--   ERROR:  insert or update on table "deliveries" violates foreign key
--           constraint "deliveries_medicine_id_fkey"
--   DETAIL:  Key (medicine_id)=(9999) is not present in table "medicines".
