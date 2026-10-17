# Practice 8 — Queries with data grouping (GROUP BY)

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — GROUP BY over one dimension foreign key
```sql
SELECT supplier_id, COUNT(*) AS deliveries_count FROM deliveries GROUP BY supplier_id;
```
Returns a count per supplier. **Meaning of each result row, in my own words:**
each row says "supplier with this id made exactly N deliveries" — e.g. supplier 10 made
2 deliveries, supplier 1 made 1. Grouping by the foreign key splits the fact table into
one group per supplier and counts the rows in each.

## Task 2 — Human version via JOIN + GROUP BY
```sql
SELECT s.name AS supplier, COUNT(d.id) AS deliveries_count
FROM suppliers s LEFT JOIN deliveries d ON d.supplier_id = s.id
GROUP BY s.id ORDER BY deliveries_count DESC;
```
Suppliers are shown by name, grouped by the supplier **primary key** `s.id` (not by the
text column). Fra-M and Medzabezpechennia appear with `0` because of `LEFT JOIN` — they
have no deliveries but are still listed.

## Task 3 — Several aggregates in one group
```sql
SELECT s.name AS supplier, COUNT(d.id) AS deliveries_count,
       COALESCE(SUM(d.quantity), 0) AS total_units
FROM suppliers s LEFT JOIN deliveries d ON d.supplier_id = s.id
GROUP BY s.id ORDER BY deliveries_count DESC;
```
Each supplier group now shows both the number of deliveries and the total units ordered
(e.g. Pharmpostach: 2 deliveries, 110 units).

## Task 4 — GROUP BY over two columns
```sql
SELECT s.city AS supplier_city, substr(d.delivery_date, 6, 2) AS month, COUNT(*) AS deliveries_count
FROM deliveries d JOIN suppliers s ON s.id = d.supplier_id
GROUP BY s.city, substr(d.delivery_date, 6, 2) ORDER BY supplier_city, month;
```
Result has **11 rows**. The number of unique city values is 6 and the number of unique
month values is 10; the number of *combinations actually present* (11) is smaller than
the full Cartesian product 6 × 10 because not every city happened to deliver in every
month — the two-column grouping granularity splits the rows further than a single column.

## Task 5 — Pitfall: a column outside GROUP BY
```sql
SELECT supplier_id, delivery_date, COUNT(*) AS cnt FROM deliveries GROUP BY supplier_id;
```
SQLite executes this **without an error**, even though `delivery_date` is neither in
`GROUP BY` nor under an aggregate. I ran the query **twice**: both runs returned
**identical** output (e.g. supplier 10 → `2025-09-01`). **Why it cannot be relied on:**
for each group SQLite has to pick *some* arbitrary row's value for the non-grouped column,
and nothing in the SQL guarantees *which* one — the two runs matched here because the
underlying row order did not change, but the standard does not promise that value, and
PostgreSQL would reject the query outright. Such a result is therefore not trustworthy.

## Review questions and answers

**1. Why must the Task 2 query group by the dimension table's `id`, not by its text column (name)?**

The supplier name is not guaranteed unique — two different suppliers could share a name,
and grouping by text would merge them into one false group. Grouping by the primary key
`id` guarantees one group per actual supplier, and displaying the name is then just a
label for that unique group. Grouping by text directly risks collapsing distinct rows.

**2. If Task 2's `LEFT JOIN` were replaced with `INNER JOIN`, which result rows could disappear?**

Any supplier with **zero** deliveries would vanish, because `INNER JOIN` only keeps
pairs that have a matching delivery. Suppliers Fra-M and Medzabezpechennia (0 deliveries)
would drop out of the result.

**3. Why does SQLite allow a column outside `GROUP BY` without an aggregate (Task 5), while PostgreSQL would raise an error?**

SQLite is deliberately **lenient**: it permits the query and silently picks an arbitrary
value for the non-grouped column. PostgreSQL follows the SQL standard strictly and
rejects any column that is neither grouped nor aggregated — making the nondeterministic
query an error instead of a quietly unreliable result.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
