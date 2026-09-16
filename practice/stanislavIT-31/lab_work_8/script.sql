-- ============================================================
-- Practice 8. Queries with data grouping (GROUP BY)
-- Variant 4: Apteka (Pharmacy)
-- The schema does NOT change — only selection queries with grouping
-- over the existing three-table structure.
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
-- Task 1. GROUP BY one dimension foreign key (supplier_id)
-- How many deliveries does each supplier make?
-- ============================================================
SELECT supplier_id, COUNT(*) AS deliveries_count
FROM deliveries
GROUP BY supplier_id;

-- ============================================================
-- Task 2. Human version via JOIN + GROUP BY
-- Group by the supplier PRIMARY KEY (s.id), show the name.
-- LEFT JOIN so a supplier with 0 deliveries would still show up.
-- ============================================================
SELECT s.name AS supplier, COUNT(d.id) AS deliveries_count
FROM suppliers s
LEFT JOIN deliveries d ON d.supplier_id = s.id
GROUP BY s.id
ORDER BY deliveries_count DESC;

-- ============================================================
-- Task 3. Several aggregates in one group
-- Each supplier: number of deliveries AND total units ordered.
-- ============================================================
SELECT s.name AS supplier,
       COUNT(d.id)     AS deliveries_count,
       COALESCE(SUM(d.quantity), 0) AS total_units
FROM suppliers s
LEFT JOIN deliveries d ON d.supplier_id = s.id
GROUP BY s.id
ORDER BY deliveries_count DESC;

-- ============================================================
-- Task 4. GROUP BY over two columns at once
-- Deliveries grouped by supplier city AND by delivery month.
-- ============================================================
SELECT s.city AS supplier_city,
       substr(d.delivery_date, 6, 2) AS month,
       COUNT(*) AS deliveries_count
FROM deliveries d
JOIN suppliers s ON s.id = d.supplier_id
GROUP BY s.city, substr(d.delivery_date, 6, 2)
ORDER BY supplier_city, month;

-- ============================================================
-- Task 5. Pitfall: a column outside GROUP BY
-- d.quantity is NOT in GROUP BY and NOT under an aggregate.
-- SQLite runs this without an error but the value is unpredictable.
-- Run it twice and compare.
-- ============================================================
SELECT supplier_id, delivery_date, COUNT(*) AS cnt
FROM deliveries
GROUP BY supplier_id;
