# Practice 6 — Queries with different kinds of table joins in SQLite

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — INNER JOIN fact + dimension 1
```sql
SELECT m.name AS medicine, d.delivery_date, d.quantity, d.purchase_price
FROM deliveries d
JOIN medicines m ON m.id = d.medicine_id
ORDER BY d.delivery_date DESC;
```
Rather than raw `medicine_id`, each row now shows the human-readable medicine name,
ordered from the most recent delivery. The join is `ON m.id = d.medicine_id` — exactly
the declared foreign key.

## Task 2 — INNER JOIN all three tables
```sql
SELECT m.name AS medicine, s.name AS supplier, d.delivery_date, d.quantity
FROM deliveries d
JOIN medicines m ON m.id = d.medicine_id
JOIN suppliers s ON s.id = d.supplier_id
ORDER BY d.delivery_date;
```
One result row now shows three human-readable values at once (medicine, supplier,
date) with **no `id`** in the result.

## Task 3 — LEFT JOIN: dimension rows without a pair in the fact table
A new supplier `FreshBio Distributor` was added with no deliveries, then:
```sql
SELECT s.name AS supplier, s.city
FROM suppliers s
LEFT JOIN deliveries d ON d.supplier_id = s.id
WHERE d.id IS NULL;
```
Result: `Fra-M`, `Medzabezpechennia`, and the newly added `FreshBio Distributor` —
suppliers that have never made a delivery.

## Task 4 — CROSS JOIN pitfall
Separate counts: `medicines` = **13**, `suppliers` = **13**.
Comma syntax without join/where:
```sql
SELECT COUNT(*) FROM medicines, suppliers;
```
returns **169**, which equals the *product* 13 × 13, **not** the sum 26.
**Explanation:** with comma syntax (and no `WHERE` joining condition) SQLite builds the
Cartesian product of the two tables — every medicine is paired with every supplier. A
real report almost always wants *corresponding* rows, so a forgotten `WHERE`/`JOIN`
turns the query into this accidental cross product, which is almost never the intent.

## Task 5 — Justification of the JOIN type for Tasks 1-3
- **Task 1 (INNER JOIN):** every delivery row *must* have a real medicine (FK is NOT
  NULL), so `INNER` shows exactly the matching pairs; a `LEFT` would behave the same
  here since no delivery lacks a medicine, so `INNER` is the honest, minimal choice.
- **Task 2 (INNER JOIN):** the same reasoning chained onto a second dimension — every
  delivery also always has a supplier, so `INNER` keeps only complete, valid triples;
  `LEFT` would add no new rows here and just risk showing `NULL` supplier names.
- **Task 3 (LEFT JOIN):** here `LEFT` is essential — it *keeps* dimension rows that have
  **no** matching delivery (setting fact columns to `NULL`), which is exactly what the
  `WHERE d.id IS NULL` then filters on. An `INNER JOIN` would silently drop those
  suppliers before we could ever see them, returning an empty result.

## Review questions and answers

**1. Why does a row with `NULL` in a foreign key never appear in an `INNER JOIN` result over that key, but does appear in a `LEFT JOIN`?**

`INNER JOIN` keeps only rows where the join condition is `TRUE`, and a comparison with
`NULL` is never `TRUE` — so the row is dropped. `LEFT JOIN` keeps **all** rows of the
left table and, for a missing match, fills the right side with `NULL` rather than
dropping the row, so the left row still appears.

**2. What happens to the Task 2 result if one JOIN is changed to `LEFT JOIN` and the rest stay `INNER`?**

If we replaced the second join (the one that fetches suppliers) with a `LEFT JOIN`, the
result would keep every medicine–delivery pair and simply show `NULL` for the supplier
columns if a delivery's `supplier_id` had no matching supplier. Since in our data every
delivery has a supplier, the visible result would not change — but the semantics would
(certain rows would no longer require a supplier to be present).

**3. How does `JOIN a, b WHERE a.id = b.a_id` (old comma syntax with a condition in WHERE) differ from `JOIN a JOIN b ON a.id = b.a_id` in result, and in risk of error?**

In result they are equivalent **only if** the `WHERE` condition is written correctly —
both produce the same joined rows. The risk differs: with comma syntax the join
condition is optional, so forgetting it silently produces a Cartesian product; with the
explicit `JOIN ... ON` syntax the join condition is mandatory and the intent is clearer,
making the accidental cross product much harder to introduce.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
