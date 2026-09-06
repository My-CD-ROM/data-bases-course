-- ============================================================
-- Practice 15. Generated columns in SQLite (VIRTUAL)
-- Variant 4: Apteka (Pharmacy)
-- None of the existing tables are dropped; we only ADD derived
-- columns to the medicines dimension table.
--
-- Run with:  sqlite3 medicines.db < script.sql
-- ============================================================

PRAGMA foreign_keys = ON;

-- ---------- Recreate the medicines dimension table (self-contained) ----------
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

-- ============================================================
-- Task 1. Derived numeric value: stock value = price * stock
-- Business sense: the money currently "frozen" in the stock of each
-- medicine in the warehouse (price per unit * units on hand).
-- ============================================================
ALTER TABLE medicines ADD COLUMN stock_value REAL
    GENERATED ALWAYS AS (price * stock_quantity) VIRTUAL;

SELECT name, price, stock_quantity, stock_value
FROM medicines
ORDER BY name;

-- ============================================================
-- Task 2. Derived logical flag: is the stock LOW (below 60 units)?
-- The formula is a comparison, producing 0/1 (SQLite booleans).
-- ============================================================
ALTER TABLE medicines ADD COLUMN low_stock INTEGER
    GENERATED ALWAYS AS (stock_quantity < 60) VIRTUAL;

SELECT name, stock_quantity, low_stock
FROM medicines
ORDER BY low_stock DESC, name;
-- 1 = at risk (below 60), 0 = enough stock.

-- ============================================================
-- Task 3. Intentional error: direct write to a generated column
-- Trying to set stock_value directly must be rejected.
-- ============================================================
UPDATE medicines SET stock_value = 1 WHERE id = 1;
-- Expected exact error:
--   Error: cannot UPDATE a generated column

-- ============================================================
-- Task 4. Automatic recalculation
-- Change the BASE column (price), then confirm the generated column
-- recomputes synchronously WITHOUT any extra command.
-- ============================================================
-- Before:
SELECT name, price, stock_value
FROM medicines WHERE id = 1;

UPDATE medicines SET price = 30.0 WHERE id = 1;

-- After (stock_value must have changed with price, untouched by us):
SELECT name, price, stock_value
FROM medicines WHERE id = 1;

-- ============================================================
-- Task 5. WHERE over a generated column
-- Filter rows by the generated column itself, as if it were a base column.
-- ============================================================
SELECT name, price, stock_quantity, stock_value
FROM medicines
WHERE stock_value > 3000
ORDER BY stock_value DESC;

-- ============================================================
-- (View the final table schema including the generated columns)
-- ============================================================
.schema medicines
