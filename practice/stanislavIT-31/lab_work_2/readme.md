# Practice 2 — Building SELECT queries in SQLite

**Variant:** 4 — Apteka (Pharmacy)
**Dimension table 1:** `medicines(id, name, manufacturer, form, price, stock_quantity)`
**Deliverables:** `medicines.db` (SQLite database), `script.sql` (all commands), this `readme.md`.

## Tasks carried out

### Task 1. SELECT with an explicit column list
```sql
SELECT name, price, stock_quantity FROM medicines;
```
Returns only the three columns useful for a stock review screen, instead of `*`.

### Task 2. WHERE with a condition characteristic of the variant
```sql
SELECT name, price FROM medicines WHERE price >= 50;
```
For a pharmacy the natural filter is the **price** — here we show all drugs
priced at 50 UAH or more, displaying only the columns needed to check the condition.

### Task 3. LIMIT
```sql
SELECT name, form, price FROM medicines LIMIT 3;
```
Shows the first 3 records of the table.

### Task 4. IS NULL / IS NOT NULL
One extra row was inserted where `form` is `NULL` (unknown):
```sql
INSERT INTO medicines (name, manufacturer, form, price, stock_quantity)
VALUES ('Experimental drug', 'Research Labs', NULL, 12.00, 5);
```
Then two queries were run:
```sql
SELECT name, manufacturer, form FROM medicines WHERE form IS NULL;      -- finds the new row
SELECT name, manufacturer, form FROM medicines WHERE form IS NOT NULL;  -- finds all the rest
```
**Explanation:** the row with the NULL `form` is *not* found by `= NULL`. In SQL any
comparison with an unknown value yields `NULL`, which is neither `TRUE` nor `FALSE`,
so `WHERE` never lets such a row through. The dedicated operator `IS NULL` directly
asks "is this cell empty?" and correctly finds the row, while `IS NOT NULL` returns
everything that has a value.

### Task 5. Compound condition
```sql
SELECT name, form, price, stock_quantity
FROM medicines
WHERE form = 'tablets' AND price < 40;
```
Two conditions joined by `AND`; the result is the cheap tablet drugs with good stock.

## Review questions and answers

**1. Why does `WHERE price = NULL` always return an empty result, even if there are NULLs in the price column? What should be written instead?**

Comparing anything (`=`, `<`, `>`, …) with `NULL` yields `NULL` — the unknown value — and `WHERE` only keeps rows where the condition is `TRUE`. Since `NULL` is neither `TRUE` nor `FALSE`, no row ever passes. Instead you must write `WHERE price IS NULL` (or `IS NOT NULL`), a dedicated operator that asks directly whether a cell has no value.

**2. How is WHERE fundamentally different from HAVING?**

`WHERE` filters individual rows of the table *before* any grouping happens. `HAVING` filters the *already formed groups* after `GROUP BY`. A condition on an aggregate value (e.g. `COUNT(*) > 1`) can therefore only live in `HAVING`, never in `WHERE`.

**3. When should you avoid `SELECT *`, and why?**

You should avoid it when you only need a few columns, want a stable, deterministic column order, transfer data over a slow network, or work with a schema that may change. `SELECT *` returns every column, including unneeded ones, makes queries slower, and silently changes when the table structure is altered — potentially breaking code that assumed a fixed shape.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
