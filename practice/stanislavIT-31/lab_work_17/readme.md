# Practice 17 — Creating and using Views in PostgreSQL

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `script.sql`, `pharmacy_db_dump.sql` (db artifact), this `readme.md`.
Runs against the `pharmacy_db` database (schema from Practice 16); the script is
self-contained (it recreates the base schema + data first).

## Task 1 — An ordinary filter view
```sql
CREATE VIEW medicines_in_stock AS
SELECT id, name, manufacturer, form, price, stock_quantity
FROM medicines WHERE stock_quantity >= 60;
```
`SELECT * FROM medicines_in_stock` returned **9** rows (medicines with at least 60 units).
**What problem it solves:** "which medicines are currently in sufficient stock" is a
repeating question; without the view this `SELECT ... WHERE stock_quantity >= 60` would
be retyped in every report / query that needs it. The view stores the query once.

## Task 2 — The view is always "live"
Inserted a new medicine **Smecta** (stock 90, satisfies the WHERE condition):
```sql
INSERT INTO medicines (name, manufacturer, form, price, stock_quantity)
VALUES ('Smecta', 'Ipsen', 'powder', 95.0, 90);
```
- `SELECT COUNT(*) FROM medicines_in_stock` before: **9**, after: **10**.
- The row appeared in the view **with no extra command** — an ordinary view is just a
  stored query that re-evaluates against the current table every time it is read.

## Task 3 — Write through a simple view
```sql
INSERT INTO medicines_in_stock (name, manufacturer, form, price, stock_quantity)
VALUES ('Rennie', 'Bayer', 'tablets', 75.0, 88);
```
Because the view is based on a single table with no JOIN/aggregate, PostgreSQL routed the
INSERT to the base table: `SELECT * FROM medicines WHERE name = 'Rennie'` shows the row
(`id = 15`, all 6 columns filled). **Explanation:** the view's SELECT exposes the plain
columns, so an INSERT through it writes those columns; columns outside the view's SELECT
(aside from ones with defaults) are not touched — there were none here, so no NULL/DEFAULT
surprises. (If a fact-table view omitted a NOT NULL FK column, that column would need a
default or the insert would fail.)

## Task 4 — Materialized view and REFRESH
```sql
CREATE MATERIALIZED VIEW medicines_in_stock_mat AS
SELECT ... FROM medicines WHERE stock_quantity >= 60;
```
Sequence and counts (note: `mat_before` was taken after Rennie was already in the base):
- `mat_before` = **11**, `live_after_new_row` (ordinary view, after adding Efferalgan)=**12**,
  `mat_before_refresh` = **11**, after `REFRESH MATERIALIZED VIEW` = **12**.
**When did the materialized view "pick up" the new data?** Exactly at the `REFRESH
MATERIALIZED VIEW` command — before it, the materialized view still showed the snapshot it
was built from; only the explicit `REFRESH` recomputed it.

## Task 5 — CREATE OR REPLACE VIEW
```sql
CREATE OR REPLACE VIEW medicines_in_stock AS
SELECT id, name, manufacturer, form, price, stock_quantity
FROM medicines WHERE stock_quantity >= 80;
```
The view's threshold was changed from `>= 60` to `>= 80` **without `DROP VIEW`**; the
resulting `SELECT` now returns only medicines with stock ≥ 80 (9 rows) and the change
applied immediately.

## Review questions and answers

**1. Why does the ordinary view (Task 1) need no storage of its own, while the materialized view (Task 4) does?**

An **ordinary view** is just a saved query expression (a name for a SELECT); every read
re-executes it against the live tables, so it owns no data of its own. A **materialized
view** actually **stores** a physical copy (snapshot) of the result on disk, which is why
it needs storage and why it goes stale until `REFRESH`.

**2. In Task 3 — why did a column outside the view's SELECT get NULL/default rather than the value from the view's WHERE condition?**

An INSERT through a view writes only the columns that appear in the view's column list.
The WHERE condition of the view is a *filter for reads*, not a value source for writes —
PostgreSQL does not "fill in" a row to make it satisfy the view's WHERE. Any column not in
the view's SELECT is simply left as its default (or NULL). (In our composed view there are
no omitted columns, so none needed a default.)

**3. In a real scenario of your variant, when would a materialized view (with periodic REFRESH) be more appropriate than an ordinary view, and why?**

For a heavy, expensive aggregation on the fact table — e.g. the total purchase amount per
supplier per month, computed over the whole `deliveries` history. If this is read by many
reports but only changes when new deliveries arrive (e.g. daily), a materialized view lets
those reports read a precomputed snapshot instead of re-scanning and re-aggregating the
entire ledger every time — at the cost of a periodic `REFRESH MATERIALIZED VIEW`.

## How to run
```bash
psql -h /tmp -p 5433 -U postgres -d pharmacy_db -f script.sql
```
