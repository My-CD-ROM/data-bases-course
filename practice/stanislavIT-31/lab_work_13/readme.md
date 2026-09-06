# Practice 13 — Creating indexes and analysing query efficiency

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — EXPLAIN QUERY PLAN before any index
```sql
EXPLAIN QUERY PLAN SELECT * FROM deliveries WHERE supplier_id = 7;
```
Plan BEFORE index:
```
QUERY PLAN
`--SCAN deliveries
```
The planner had no index on `supplier_id`, so it does a full table scan.

## Task 2 — CREATE INDEX on the foreign key
```sql
CREATE INDEX idx_deliveries_supplier ON deliveries(supplier_id);
EXPLAIN QUERY PLAN SELECT * FROM deliveries WHERE supplier_id = 7;
```
Plan AFTER index:
```
QUERY PLAN
`--SEARCH deliveries USING INDEX idx_deliveries_supplier (supplier_id=?)
```
**What changed:** the full `SCAN` became a targeted `SEARCH ... USING INDEX`
— the DBMS now locates matching rows directly through the index instead of reading
every row.

## Task 3 — Composite index on two columns
```sql
SELECT * FROM deliveries WHERE supplier_id = 7 AND substr(delivery_date, 6, 2) = '05';
```
- Before creating the composite index, the plan used `idx_deliveries_supplier`
  (`supplier_id=?`) — good on the first column but the month condition is then a
  residual filter.
- After `CREATE INDEX idx_deliveries_supplier_month ON deliveries(supplier_id, substr(delivery_date,6,2))`:
```
SEARCH deliveries USING INDEX idx_deliveries_supplier_month (supplier_id=? AND <expr>=?)
```
**Why the composite index helps more:** both columns are now consumed by the index
lookup itself, so SQLite narrows the search for *both* conditions in one step, rather
than resolving one and filtering the other afterwards. An index on only the first column
(`supplier_id`) cannot also restrict by the derived month expression.

## Task 4 — Index and ORDER BY
- Before the date index:
```
SCAN deliveries
`--USE TEMP B-TREE FOR ORDER BY
```
  — sorting the whole scanned result needed a temporary B-tree.
- After `CREATE INDEX idx_deliveries_date ON deliveries(delivery_date)`:
```
SCAN deliveries USING INDEX idx_deliveries_date
```
**What changed in the plan:** the `USE TEMP B-TREE FOR ORDER BY` sort step **disappeared**
— the index is already ordered by `delivery_date`, so the rows come out in the required
order without an explicit sort.

## Task 5 — DROP INDEX and re-check
```sql
DROP INDEX idx_deliveries_supplier;
EXPLAIN QUERY PLAN SELECT * FROM deliveries WHERE supplier_id = 7;
SELECT name FROM sqlite_master WHERE type = 'index' AND tbl_name = 'deliveries' ORDER BY name;
```
- The plan for `WHERE supplier_id = 7` now uses the composite index
  `idx_deliveries_supplier_month` (**partial** coverage, since `supplier_id` is its
  leading column) rather than the dropped single-column index. If no covering index
  existed, the plan would have returned to a plain `SCAN deliveries`.
- The `sqlite_master` query lists only `idx_deliveries_date` and
  `idx_deliveries_supplier_month` — confirming the dropped index was genuinely removed.

## Review questions and answers

**1. Why does EXPLAIN QUERY PLAN show a PLAN and not the query result, and why check the plan separately from "the query just works"?**

`EXPLAIN QUERY PLAN` only shows the *execution strategy* the planner chose (scans,
indexes, sort steps); it returns no data rows. "The query works" only proves the result
is correct, not that it is fast. Two correct queries on a big table can differ enormously
in speed because of a different plan, so you must inspect the plan to detect or avoid a
full-table scan and to verify an index is actually used.

**2. In Task 3, why does an index on just the first of the two condition columns give less benefit than a composite index on both?**

B-tree indexes can only use the index to restrict by a **prefix** of the indexed columns.
An index on `supplier_id` alone stops being useful the moment the first column condition
is satisfied — the second condition (`<expr>` for month) is not part of the index, so it
becomes a residual filter on the already-retrieved rows. The composite index stores both
values, so both conditions are resolved inside the index in one pass.

**3. What is the cost of creating an index, and why not index every column "just in case"?**

Every index (a) consumes extra disk space, (b) must be **updated on every INSERT, UPDATE
and DELETE** of the table, slowing write operations, and (c) adds maintenance overhead.
Indexing every column without knowing the actual query workload wastes space and slows
writes for indexes the queries never use. Indexes should be created deliberately, for the
columns that actually appear in `WHERE`, `ORDER BY`, or `JOIN` conditions.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
