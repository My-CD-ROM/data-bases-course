-- ============================================================
-- Practice 12. Creating and rolling back transactions in SQLite
-- Variant 4: Apteka (Pharmacy)
-- The schema does NOT change — only transactions over existing data.
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

-- Sanity before we start.
SELECT 'start_count', COUNT(*) FROM deliveries;
SELECT 'stock_paracetamol_before', stock_quantity FROM medicines WHERE id = 1;

-- ============================================================
-- Task 1. Atomic pair: INSERT + UPDATE in one transaction
-- A new delivery arrives; BOTH the delivery record AND the stock
-- counter must be updated together, otherwise the data is inconsistent.
-- ============================================================
BEGIN;
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
VALUES (1, 1, '2026-01-20', 60, 22.00);
UPDATE medicines SET stock_quantity = stock_quantity + 60 WHERE id = 1;
COMMIT;

-- Verify both changes are present
SELECT 'after_commit_count', COUNT(*) FROM deliveries;
SELECT 'stock_paracetamol_after', stock_quantity FROM medicines WHERE id = 1;

-- ============================================================
-- Task 2. Conscious ROLLBACK
-- Open a transaction, make changes, then ROLLBACK instead of COMMIT.
-- Verify the data is exactly as it was BEFORE BEGIN.
-- ============================================================
SELECT 'count_before_rollback', COUNT(*) FROM deliveries;
BEGIN;
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
VALUES (2, 2, '2026-02-01', 10, 5.00);
UPDATE medicines SET stock_quantity = stock_quantity - 10 WHERE id = 2;
ROLLBACK;

-- Verify nothing actually changed
SELECT 'count_after_rollback', COUNT(*) FROM deliveries;
SELECT 'stock_ibuprofen_after_rollback', stock_quantity FROM medicines WHERE id = 2;
SELECT 'rollback_row_absent', COUNT(*) FROM deliveries WHERE delivery_date = '2026-02-01';

-- ============================================================
-- Task 3. Intermediate state inside the transaction
-- Inside BEGIN (before COMMIT) our own uncommitted change IS visible in
-- this same session.
-- ============================================================
BEGIN;
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
VALUES (3, 3, '2026-02-10', 20, 9.00);
-- The new row is visible even though it is not yet committed:
SELECT 'inside_tx_count', COUNT(*) FROM deliveries;
ROLLBACK;
SELECT 'after_rollback_count', COUNT(*) FROM deliveries;

-- ============================================================
-- Task 4. Intentional error inside the transaction
-- One successful change, then a command that violates a constraint.
-- Capture the exact error, then check the first change is still present
-- (the transaction is still open), then ROLLBACK.
-- ============================================================
SELECT 'count_before_task4', COUNT(*) FROM deliveries;
BEGIN;
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
VALUES (7, 7, '2026-03-01', 15, 8.00);
-- The following violates the NOT NULL on quantity -> constraint error
UPDATE deliveries SET quantity = NULL WHERE medicine_id = 7 AND delivery_date = '2026-03-01';
-- Expected exact error:  NOT NULL constraint failed: deliveries.quantity
-- Check: the first (successful) INSERT is still present while still open:
SELECT 'inside_task4_count_after_error', COUNT(*) FROM deliveries;
SELECT 'task4_inserted_present', COUNT(*) FROM deliveries WHERE delivery_date = '2026-03-01';
ROLLBACK;
SELECT 'count_after_task4_rollback', COUNT(*) FROM deliveries;
SELECT 'task4_row_gone_after_rollback', COUNT(*) FROM deliveries WHERE delivery_date = '2026-03-01';

-- ============================================================
-- Task 5. Forgotten ROLLBACK (we COMMIT instead after the error)
-- One successful command, one failing command, then COMMIT.
-- Only the successful part gets persisted -> partial commit.
-- ============================================================
SELECT 'count_before_task5', COUNT(*) FROM deliveries;
BEGIN;
INSERT INTO deliveries (medicine_id, supplier_id, delivery_date, quantity, purchase_price)
VALUES (8, 8, '2026-03-15', 25, 11.00);
UPDATE deliveries SET quantity = NULL WHERE medicine_id = 8 AND delivery_date = '2026-03-15';
-- Expected exact error:  NOT NULL constraint failed: deliveries.quantity
COMMIT;
-- The INSERT was committed despite the error; the UPDATE was not applied.
SELECT 'count_after_task5_commit', COUNT(*) FROM deliveries;
SELECT 'task5_inserted_present', COUNT(*) FROM deliveries WHERE delivery_date = '2026-03-15';
