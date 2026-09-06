-- ============================================================
-- Practice 9. Selecting groups with HAVING
-- Variant 4: Apteka (Pharmacy)
-- The schema does NOT change — only selection queries with HAVING.
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
-- Task 1. HAVING on COUNT
-- Only suppliers with MORE than 1 delivery (COUNT(*) > 1).
-- Justification for the threshold 1: it separates regular partners
-- (repeat deliveries) from one-off suppliers — a natural business cut.
-- ============================================================
SELECT supplier_id, COUNT(*) AS deliveries_count
FROM deliveries
GROUP BY supplier_id
HAVING COUNT(*) > 1;

-- ============================================================
-- Task 2. HAVING on another aggregate (SUM)
-- Suppliers whose deliveries total MORE than 100 units in total.
-- ============================================================
SELECT supplier_id, SUM(quantity) AS total_units
FROM deliveries
GROUP BY supplier_id
HAVING SUM(quantity) > 100;

-- ============================================================
-- Task 3. WHERE + GROUP BY + HAVING in one query
-- WHERE  : drop deliveries before 2025 (only consider 2025 records)
-- GROUP BY: by supplier
-- HAVING : keep only groups with total quantity > 80
-- These are two different filters (see readme.md).
-- ============================================================
SELECT s.name AS supplier, COUNT(*) AS cnt, SUM(d.quantity) AS units_2025
FROM deliveries d
JOIN suppliers s ON s.id = d.supplier_id
WHERE d.delivery_date >= '2025-01-01'
GROUP BY s.id
HAVING SUM(d.quantity) > 80
ORDER BY units_2025 DESC;

-- ============================================================
-- Task 4. Intentional error: aggregate in WHERE instead of HAVING
-- Putting COUNT(*) > 1 in WHERE is impossible — capture the exact error.
-- ============================================================
SELECT supplier_id, COUNT(*)
FROM deliveries
WHERE COUNT(*) > 1
GROUP BY supplier_id;
-- Expected exact SQLite error:
--   Error: misuse of aggregate function COUNT()
-- This fails because WHERE runs on the pre-aggregation rows (before
-- groups are formed), where aggregate functions do not exist yet.

-- ============================================================
-- Task 5. LEFT JOIN + GROUP BY + HAVING for "empty" groups
-- Suppliers with FEWER than 2 deliveries (including 0). LEFT JOIN is
-- required so suppliers with 0 deliveries still appear (INNER would
-- drop them before HAVING could see them).
-- ============================================================
SELECT s.name AS supplier, COUNT(d.id) AS deliveries_count
FROM suppliers s
LEFT JOIN deliveries d ON d.supplier_id = s.id
GROUP BY s.id
HAVING COUNT(d.id) < 2
ORDER BY deliveries_count;
