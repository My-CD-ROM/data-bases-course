-- ============================================================
-- Practice 2. Building SELECT queries in SQLite
-- Variant 4: Apteka (Pharmacy)
-- Dimension table 1: medicines(id, name, manufacturer, form, price, stock_quantity)
-- We work with the SAME table created in Practice 1 — no schema change,
-- only selection queries applied to it.
--
-- Run with:  sqlite3 medicines.db < script.sql
-- ============================================================

PRAGMA foreign_keys = ON;

-- ---------- Recreate the Practice 1 table (so this lab stands alone) ----------
DROP TABLE IF EXISTS medicines;

CREATE TABLE medicines (
    id                 INTEGER PRIMARY KEY,
    name               TEXT NOT NULL,
    manufacturer       TEXT NOT NULL,
    form               TEXT,
    price              REAL NOT NULL,
    stock_quantity     INTEGER NOT NULL DEFAULT 0
);

INSERT INTO medicines (name, manufacturer, form, price, stock_quantity) VALUES
    ('Paracetamol',         'Darnytsia',              'tablets', 25.50, 120),
    ('No-Spa',              'Sanofi',                 'tablets', 89.90, 75),
    ('Ascorbic acid',       'Kyiv Vitamin Plant',     'tablets', 32.00, 200),
    ('Amoxicillin',         'Yuria-Pharm',            'capsules', 145.75, 40),
    ('Nazivin',             'Merck',                  'drops', 98.20, 30),
    ('Ibuprofen-gel',       'Zdorovia',               'ointment', 67.40, 55);

SELECT * FROM medicines;

-- ============================================================
-- Task 1. SELECT with an explicit list of columns (not *)
-- Show the columns that are most convenient for a pharmacist to review.
-- ============================================================
SELECT name, price, stock_quantity FROM medicines;

-- ============================================================
-- Task 2. WHERE with a condition typical for the variant (price)
-- For a pharmacy, filtering by price range is natural.
-- ============================================================
SELECT name, price FROM medicines WHERE price >= 50;

-- ============================================================
-- Task 3. LIMIT — first N records of the table
-- ============================================================
SELECT name, form, price FROM medicines LIMIT 3;

-- ============================================================
-- Task 4. IS NULL / IS NOT NULL
-- `form` realistically can be unknown for a newly added drug.
-- Insert one extra row where form is NULL (not empty string, not 0).
-- Then run two queries: one with IS NULL, one with IS NOT NULL.
-- ============================================================
INSERT INTO medicines (name, manufacturer, form, price, stock_quantity)
VALUES ('Experimental drug', 'Research Labs', NULL, 12.00, 5);

-- Query A: IS NULL — finds the row whose form is unknown
SELECT name, manufacturer, form FROM medicines WHERE form IS NULL;

-- Query B: IS NOT NULL — finds all rows that DO have a known form
SELECT name, manufacturer, form FROM medicines WHERE form IS NOT NULL;

-- Explanation (written, 2-3 sentences):
-- The row with the NULL form is NOT found by "= NULL", because in SQL any
-- comparison with an unknown value yields NULL (unknown), which is neither
-- TRUE nor FALSE — so WHERE never lets such a row through. Only the special
-- operator IS NULL directly asks "is this cell empty?" and correctly
-- identifies the row, while IS NOT NULL returns everything that has a value.

-- ============================================================
-- Task 5. Compound condition (AND / OR)
-- Combine two conditions with AND: cheap tablets that are in good stock.
-- ============================================================
SELECT name, form, price, stock_quantity
FROM medicines
WHERE form = 'tablets' AND price < 40;

-- ============================================================
-- Review questions
-- ============================================================
-- 1. Why does "WHERE price = NULL" always return an empty result even if
--    there are NULLs in the price column? What should be written instead?
--    Comparing anything to NULL yields NULL (the unknown value), which is
--    never TRUE, so WHERE discards every row. You must write
--    "WHERE price IS NULL" (or "IS NOT NULL") — a dedicated operator that
--    tests directly whether a cell has no value.

-- 2. How is WHERE fundamentally different from HAVING?
--    WHERE filters individual rows of a table BEFORE any grouping takes
--    place. HAVING filters the already-formed groups after GROUP BY. A
--    condition on an aggregate can only live in HAVING.

-- 3. When should you avoid "SELECT *", and why?
--    Avoid it when you only need a few columns, when you want deterministic
--    column order, when transferring large tables over a network, or when
--    the schema may change — because * returns every column including ones
--    you do not need, is slower, and breaks silently if the table structure
--    is altered.
