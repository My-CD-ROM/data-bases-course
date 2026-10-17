# Practice 7 — Aggregate functions (COUNT, SUM, AVG, MIN, MAX)

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — COUNT(*) versus COUNT(column)
```sql
SELECT COUNT(*) AS count_star, COUNT(purchase_price) AS count_price FROM deliveries;
```
Result: `COUNT(*)` = **12**, `COUNT(purchase_price)` = **10**.
They differ because 2 rows have `purchase_price = NULL` (invoices not checked yet).
This matches the theory: `COUNT(column)` skips `NULL`, while `COUNT(*)` counts all rows.

## Task 2 — SUM and AVG on a numeric column
```sql
SELECT SUM(purchase_price) AS total_purchase_sum,
       AVG(purchase_price) AS average_purchase_price FROM deliveries;
```
Result: `SUM` = **490.77**, `AVG` = **49.077**.
**Meaning in domain terms:** `490.77` is the pharmacy's **total purchase cost** spent on
all the deliveries with a verified invoice; `49.077` is the **average purchase price**
per delivered item. `AVG` divides only by the 10 rows that have a value (NULL rows are
excluded from the calculation), not by all 12.

## Task 3 — MIN/MAX not only on numbers
```sql
SELECT MIN(delivery_date) AS earliest_delivery, MAX(delivery_date) AS latest_delivery FROM deliveries;
SELECT MIN(name) AS first_supplier_alphabet, MAX(name) AS last_supplier_alphabet FROM suppliers;
```
Results: earliest delivery **2024-05-22**, latest **2025-12-05**; first supplier
alphabetically **Alba Ukraine**, last **Venta.Ltd**.
**Why these results:** on text/date columns the DBMS uses *textual (lexicographic /
collation) ordering* — the date strings sort chronologically (`YYYY-MM-DD`), and supplier
names sort by Unicode code points of the characters, so `MIN` gives the alphabetically
first name and `MAX` the last.

## Task 4 — Several aggregate functions in one query
```sql
SELECT COUNT(*) AS deliveries_count, SUM(quantity) AS total_units,
       AVG(purchase_price) AS avg_purchase_price,
       MIN(quantity) AS min_quantity, MAX(quantity) AS max_quantity
FROM deliveries;
```
Result: `12 | 787 | 49.077 | 12 | 98` — a single summary report over the whole fact table:
12 deliveries, 787 total units ordered, average purchase price 49.077, smallest/largest
single delivery quantity 12 and 98.

## Task 5 — Aggregate + WHERE
```sql
SELECT COUNT(*) AS kyiv_deliveries, SUM(quantity) AS kyiv_units
FROM deliveries d JOIN suppliers s ON s.id = d.supplier_id
WHERE s.city = 'Kyiv';
```
Result: **1** delivery, **70** units from Kyiv suppliers.
**Why the result changed this way:** the `WHERE` runs *before* the aggregate and removes
every delivery whose supplier is not in Kyiv (all but one). The aggregate functions then
see only the remaining single row, so the count drops from 12 to 1 and the sum from 787 to 70.

## Review questions and answers

**1. Why can `COUNT(*)` and `COUNT(column)` return different numbers on the same table, while `COUNT(*)` and `COUNT(id)` are almost always equal?**

`COUNT(*)` counts **all rows**, including those with any NULL values anywhere.
`COUNT(column)` counts only the rows where that particular column is **not NULL**.
`COUNT(id)` equals `COUNT(*)` in practice because a primary-key `id` is by definition
never NULL — every row has one.

**2. If a table has 5 rows with a numeric column, and one of them is NULL, what would the denominator be when computing `AVG` of that column — 5 or 4? Why?**

**4.** Aggregates `AVG`, `SUM`, `COUNT(column)` skip NULLs. `AVG` divides the sum by the
count of **non-NULL** values only, so the one NULL row is excluded from the denominator.

**3. What does `SUM(column)` return if ALL rows have NULL in that column — 0, NULL, or an error?**

It returns **`NULL`** (and the same holds for `AVG`). An aggregate over an empty set of
values yields `NULL`, not `0` and not an error. `COUNT(*)`/`COUNT(column)` would return
`0` in that case because they count rows rather than summing values.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
