# Practice 9 — Selecting groups with HAVING

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — HAVING on COUNT
```sql
SELECT supplier_id, COUNT(*) AS deliveries_count
FROM deliveries GROUP BY supplier_id HAVING COUNT(*) > 1;
```
Result: suppliers **10** and **12**, each with 2 deliveries.
**Why the threshold of 1:** it separates *regular* partners (who make repeat
deliveries) from one-off suppliers — a natural business cut for "suppliers we work
with continuously".

## Task 2 — HAVING on another aggregate (SUM)
```sql
SELECT supplier_id, SUM(quantity) AS total_units
FROM deliveries GROUP BY supplier_id HAVING SUM(quantity) > 100;
```
Result: supplier **10** (Pharmpostach) with **110** total units — only one supplier
has ordered more than 100 units in total.

## Task 3 — WHERE + GROUP BY + HAVING in one query
```sql
SELECT s.name AS supplier, COUNT(*) AS cnt, SUM(d.quantity) AS units_2025
FROM deliveries d JOIN suppliers s ON s.id = d.supplier_id
WHERE d.delivery_date >= '2025-01-01'
GROUP BY s.id
HAVING SUM(d.quantity) > 80
ORDER BY units_2025 DESC;
```
Result: Pharmpostach (110), Lixem (97), Optima-Pharm (91).
**What filters what (two different things):** `WHERE` drops **individual rows** — all
deliveries dated before 2025 are removed from the calculation *before* grouping, so the
sums are computed over the 2025 records only. `HAVING` then filters the **already formed
groups** — it keeps only those supplier groups whose total 2025 quantity exceeds 80.
These are genuinely different steps: `WHERE` removes source rows, `HAVING` removes result
groups.

## Task 4 — Intentional error: aggregate in WHERE instead of HAVING
```sql
SELECT supplier_id, COUNT(*) FROM deliveries WHERE COUNT(*) > 1 GROUP BY supplier_id;
```
Exact SQLite error:
```
Parse error near line 122: misuse of aggregate: COUNT()
```
**Why this is impossible on this pipeline step:** the query pipeline is
`FROM → WHERE → GROUP BY → HAVING → SELECT`. `WHERE` runs on the *raw rows before any
grouping*, so aggregate functions (which need the whole group) simply do not exist yet at
that step — the DBMS reports that `COUNT()` is being misused.

## Task 5 — LEFT JOIN + GROUP BY + HAVING for "empty" groups
```sql
SELECT s.name AS supplier, COUNT(d.id) AS deliveries_count
FROM suppliers s LEFT JOIN deliveries d ON d.supplier_id = s.id
GROUP BY s.id HAVING COUNT(d.id) < 2 ORDER BY deliveries_count;
```
Result includes all suppliers with fewer than 2 deliveries: `Fra-M` (0),
`Medzabezpechennia` (0), and the single-delivery suppliers.
**Why LEFT JOIN is necessary:** suppliers with **0** deliveries have no matching row in
`deliveries`. An `INNER JOIN` would remove those suppliers *before* `GROUP BY` ever
formed their group, so `HAVING COUNT(...) < 2` could never "see" them. `LEFT JOIN` keeps
them (with `NULL` fact columns → `COUNT(d.id) = 0`), so they correctly appear.

## Review questions and answers

**1. Why can't the Task 4 query be "just fixed" by rearranging words — why is a fundamentally different command (HAVING) needed rather than a different placement of WHERE?**

Moving `WHERE COUNT(*) > 1` to a different position does not change the fact that `WHERE`
is syntactically and semantically a pre-grouping filter — aggregates are meaningless there
regardless of order. The condition on an aggregate value simply does not belong to the
`WHERE` step of the pipeline at all; it requires the separate `HAVING` clause that runs on
formed groups.

**2. What changes in the Task 5 result if `LEFT JOIN` is replaced by `INNER JOIN` while the HAVING condition stays the same?**

The suppliers with **0** deliveries (`Fra-M`, `Medzabezpechennia`) would disappear from
the result, because `INNER JOIN` drops them before grouping. Only suppliers that actually
have deliveries would remain (the single-delivery ones that still satisfy `< 2`).

**3. If you needed to both drop certain "unwanted" rows (e.g. postponed deliveries) and show only groups with a sum above a threshold, in what order would you write WHERE/GROUP BY/HAVING, and is that order mandatory syntactically or only by meaning?**

ORDER: `WHERE` (remove unwanted rows) → `GROUP BY` → `HAVING` (keep groups above the
threshold). This order is **mandatory syntactically** (SQL grammar fixes WHERE before
GROUP BY before HAVING) — but it also matches the meaning: rows must be filtered before
they can be grouped, and groups must exist before they can be filtered by aggregate value.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
The `misuse of aggregate` parse error in Task 4 is the expected intentional error.
