-- ============================================================
-- Practice 5. UPDATE and DELETE commands in SQLite
-- Variant 4: Apteka (Pharmacy)
-- The schema does NOT change here — only the data in the tables.
-- We work with the full three-table structure from Practice 4.
--   medicines, suppliers, deliveries(medicine_id FK, supplier_id FK, ...)
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
-- Task 1. UPDATE one specific row in the fact table
-- The purchase_price can be missing while goods are being counted
-- ("temporary" value). Confirm one delivery by filling its price.
-- WHERE uses the primary key to touch exactly ONE row.
-- ============================================================
SELECT id, medicine_id, supplier_id, delivery_date, purchase_price
FROM deliveries WHERE id = 12;

UPDATE deliveries
SET purchase_price = 48.30
WHERE id = 12;

SELECT id, medicine_id, supplier_id, delivery_date, purchase_price
FROM deliveries WHERE id = 12;

-- ============================================================
-- Task 2. UPDATE one "changeable" indicator in a dimension table
-- stock_quantity of one specific medicine is adjusted after a sale.
-- ============================================================
SELECT id, name, stock_quantity FROM medicines WHERE id = 7;

UPDATE medicines SET stock_quantity = 44 WHERE id = 7;

SELECT id, name, stock_quantity FROM medicines WHERE id = 7;
-- (Written justification in readme.md: UPDATE is right here because we want
--  to change one attribute of an existing, still-valid row — the row itself
--  remains the same real medicine; DELETE+INSERT would lose its id and rewrite
--  everything unnecessarily.)

-- ============================================================
-- Task 3. DELETE exactly one row from the fact table
-- Cancel one delivery (e.g. id = 6 was a mistaken record).
-- First count BEFORE, delete, count AFTER to show exactly one row vanished.
-- ============================================================
SELECT COUNT(*) AS count_before FROM deliveries;

DELETE FROM deliveries WHERE id = 6;

SELECT COUNT(*) AS count_after FROM deliveries;

-- ============================================================
-- Task 4. Integrity-constraint check on UPDATE
-- Deliberately try to UPDATE that violates a constraint from Lecture 5.
-- deliveries.quantity is NOT NULL, so setting it to NULL must fail.
-- ============================================================
UPDATE deliveries SET quantity = NULL WHERE id = 1;
-- Expected exact error:  NOT NULL constraint failed: deliveries.quantity
-- The NOT NULL constraint declared at CREATE TABLE time still acts on UPDATE,
-- not just on INSERT.

-- ============================================================
-- Task 5. DELETE/UPDATE without WHERE — analysis WITHOUT executing
-- (NOT executed, only reasoned about; full discussion in readme.md)
-- ============================================================
SELECT COUNT(*) AS current_deliveries FROM deliveries;
