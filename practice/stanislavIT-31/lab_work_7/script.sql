-- ============================================================
-- Practice 7. Aggregate functions (COUNT, SUM, AVG, MIN, MAX)
-- Variant 4: Apteka (Pharmacy)
-- The schema does NOT change — only selection queries.
-- We work with the full three-table structure.
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
    purchase_price REAL,          -- may be NULL while the invoice is not yet checked
    FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE RESTRICT,
    FOREIGN KEY (supplier_id) REFERENCES suppliers (id) ON DELETE RESTRICT
);
INSERT INTO deliveries (id, medicine_id, supplier_id, delivery_date, quantity, purchase_price) VALUES
    (1, 5, 10, '2025-09-01', 76, 85.85),
    (2, 2, 4,  '2025-08-18', 40, 65.25),
    (3, 11, 12,'2025-08-26', 12, 17.44),
    (4, 4, 7,  '2024-05-22', 84, 39.52),
    (5, 9, 9,  '2025-07-24', 80, 36.46),
    (6, 12, 8, '2025-05-09', 39, NULL),   -- invoice not checked yet -> NULL
    (7, 4, 6,  '2024-12-18', 98, 24.81),
    (8, 4, 12, '2025-05-24', 85, 88.13),
    (9, 9, 10, '2025-02-27', 34, 33.70),
    (10, 6, 3, '2025-01-23', 78, 20.13),
    (11, 1, 1, '2025-12-05', 91, 79.48),
    (12, 8, 2, '2024-10-10', 70, NULL);   -- invoice not checked yet -> NULL

-- ============================================================
-- Task 1. COUNT(*) vs COUNT(column) on the fact table
-- purchase_price can be NULL, so COUNT(*) and COUNT(purchase_price)
-- should differ (2 rows have NULL). If they matched, we would set one
-- to NULL and recount.
-- ============================================================
SELECT COUNT(*) AS count_star, COUNT(purchase_price) AS count_price
FROM deliveries;

-- ============================================================
-- Task 2. SUM and AVG on a numeric column (purchase_price)
-- ============================================================
SELECT SUM(purchase_price) AS total_purchase_sum,
       AVG(purchase_price) AS average_purchase_price
FROM deliveries;

-- ============================================================
-- Task 3. MIN/MAX not only on numbers (date + text columns)
-- ============================================================
-- MIN/MAX on a DATE column: earliest and latest delivery date
SELECT MIN(delivery_date) AS earliest_delivery,
       MAX(delivery_date) AS latest_delivery
FROM deliveries;

-- MIN/MAX on a TEXT column: alphabetically first/last supplier name
SELECT MIN(name) AS first_supplier_alphabet,
       MAX(name) AS last_supplier_alphabet
FROM suppliers;

-- ============================================================
-- Task 4. Several aggregate functions in one query (fact table)
-- ============================================================
SELECT COUNT(*)                   AS deliveries_count,
       SUM(quantity)              AS total_units,
       AVG(purchase_price)        AS avg_purchase_price,
       MIN(quantity)              AS min_quantity,
       MAX(quantity)              AS max_quantity
FROM deliveries;

-- ============================================================
-- Task 5. Aggregate + WHERE (filter first, then aggregate)
-- Only deliveries from suppliers located in Kyiv.
-- ============================================================
SELECT COUNT(*) AS kyiv_deliveries,
       SUM(quantity) AS kyiv_units
FROM deliveries d
JOIN suppliers s ON s.id = d.supplier_id
WHERE s.city = 'Kyiv';
