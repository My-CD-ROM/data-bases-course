-- ============================================================
-- Practice 13. Creating indexes and analysing query efficiency
-- Variant 4: Apteka (Pharmacy)
-- The table structure does not change; only an index is added
-- (an index is not a table or a relationship).
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
    ('Activated charcoal', 'Kyivmedpreparat', 'tablets', 15.0, 150);

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
-- Task 1. EXPLAIN QUERY PLAN BEFORE any index.
--   Filter the fact table by the foreign key supplier_id = 7.
-- ============================================================
EXPLAIN QUERY PLAN
SELECT * FROM deliveries WHERE supplier_id = 7;

-- ============================================================
-- Task 2. CREATE INDEX on that foreign key, then re-run EXPLAIN.
-- ============================================================
CREATE INDEX idx_deliveries_supplier ON deliveries(supplier_id);

EXPLAIN QUERY PLAN
SELECT * FROM deliveries WHERE supplier_id = 7;

-- ============================================================
-- Task 3. Composite index on two columns
--   Filter by two conditions at once: supplier_id AND delivery month=.. .
--   Run EXPLAIN BEFORE and AFTER creating the composite index.
-- ============================================================
-- Before:
EXPLAIN QUERY PLAN
SELECT * FROM deliveries WHERE supplier_id = 7 AND substr(delivery_date, 6, 2) = '05';

CREATE INDEX idx_deliveries_supplier_month
    ON deliveries(supplier_id, substr(delivery_date, 6, 2));

-- After:
EXPLAIN QUERY PLAN
SELECT * FROM deliveries WHERE supplier_id = 7 AND substr(delivery_date, 6, 2) = '05';

-- ============================================================
-- Task 4. Index and ORDER BY
--   Create an index on the date column and compare the plan for a
--   query with ORDER BY delivery_date.
-- ============================================================
-- Before: (an ORDER BY over the whole table -> temporary B-TREE sort)
EXPLAIN QUERY PLAN
SELECT * FROM deliveries ORDER BY delivery_date;

CREATE INDEX idx_deliveries_date ON deliveries(delivery_date);

-- After:
EXPLAIN QUERY PLAN
SELECT * FROM deliveries ORDER BY delivery_date;

-- ============================================================
-- Task 5. DROP INDEX and re-check.
--   Drop one index and confirm the plan returns to a SCAN, and that
--   the index is removed from sqlite_master.
-- ============================================================
DROP INDEX idx_deliveries_supplier;

EXPLAIN QUERY PLAN
SELECT * FROM deliveries WHERE supplier_id = 7;

-- Confirm the dropped index is gone from the catalogue:
SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = 'deliveries' ORDER BY name;
