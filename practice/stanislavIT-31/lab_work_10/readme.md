# Practice 10 — Sorting and filtering (ORDER BY, DISTINCT, BETWEEN, IN, LIKE)

**Variant:** 4 — Apteka (Pharmacy)
**Deliverables:** `medicines.db`, `script.sql`, this `readme.md`.

## Task 1 — ORDER BY a single column
```sql
SELECT id, delivery_date, quantity FROM deliveries ORDER BY delivery_date DESC;
```
The first row is `id = 11` with the latest delivery date **2025-12-05** — because
`DESC` places the greatest date first, and that delivery is the most recent one.

## Task 2 — ORDER BY two columns
```sql
SELECT d.id, s.city, d.delivery_date, d.quantity
FROM deliveries d JOIN suppliers s ON s.id = d.supplier_id
ORDER BY s.city, d.delivery_date;
```
Rows are first sorted by supplier **city** (alphabetical), and within the same city the
**delivery date** acts as the secondary key — e.g. Poltava's deliveries (2025-02-27,
2025-08-18, 2025-09-01) are ordered from oldest to newest. The second column decides the
order *only among rows that tie on the first*.

## Task 3 — Top-3 via ORDER BY + LIMIT
```sql
SELECT id, quantity, purchase_price FROM deliveries ORDER BY quantity DESC LIMIT 3;
```
Returns the 3 largest single deliveries: **98, 91, 85** units.
**Why ORDER BY must come BEFORE LIMIT:** the limit is applied to the already-sorted
result; `ORDER BY` first fixes which rows are "on top", then `LIMIT 3` takes the first
three. Without `ORDER BY`, `LIMIT 3` would just take an arbitrary first three rows.

## Task 4 — DISTINCT and BETWEEN
(a) Distinct "category" column:
```sql
SELECT DISTINCT form FROM medicines;   -- tablets, capsules, syrup, ointment, drops  (5 values)
```
(b) Numeric range filter:
```sql
SELECT name, form, price FROM medicines WHERE price BETWEEN 40 AND 80 ORDER BY price;
```
Loratadine, Ibuprofen, Aspirin, Vitamin C, Amoxicillin (40–65).
**Why BETWEEN and not IN:** a price filter is a continuous *range* (`40 ≤ price ≤ 80`),
not a discrete set of exact values. `IN` would require enumerating every allowed price;
`BETWEEN` expresses the range directly and is read as an inclusive interval.

## Task 5 — LIKE and the Cyrillic case pitfall
With real Ukrainian values in the table (e.g. `Називін`, `Аскорбінова кислота`):
```sql
SELECT name FROM medicines WHERE name LIKE 'Н%';   -- -> 'Називін'
SELECT name FROM medicines WHERE name LIKE 'н%';   -- -> (nothing)
SELECT name FROM medicines WHERE name LIKE 'А%';   -- -> 'Аскорбінова кислота'
SELECT name FROM medicines WHERE name LIKE 'а%';   -- -> (nothing)
SELECT name FROM medicines WHERE name LIKE 'н%' COLLATE NOCASE; -- -> (nothing)
SELECT name FROM medicines WHERE name LIKE '%acin%';            -- -> matches English names
```
**The counted rows differ between the uppercase and lowercase variants of the same
Cyrillic letter** (`Н%` matches, `н%` does not; same for `А`/`а`). Why: SQLite's built-in
LIKE lowercases/uppercases **ASCII** characters only. For non-ASCII (Cyrillic) letters it
does **byte-exact** matching, so it is **case-sensitive**. Even `COLLATE NOCASE` does not
help, because its folding also covers ASCII only. For contrast, the ASCII pattern
`%acin%` successfully matched English names case-insensitively.

## Review questions and answers

**1. Why must ORDER BY be written BEFORE LIMIT — and what happens if ORDER BY is removed entirely, leaving only LIMIT 3?**

`LIMIT` truncates the result set *after* it is ordered, so the first N rows of the sorted
list are taken. If `ORDER BY` is removed, SQLite returns any three rows (in storage/
scan order), so the "top 3" becomes a meaningless arbitrary triple instead of the largest
three.

**2. In Task 4, when should you choose IN and when BETWEEN, if either can be replaced by a chain of OR/AND?**

Choose `BETWEEN` for a **continuous numeric/date range** (`a ≤ x ≤ b`) and `IN` for a
**discrete set of exact values**. `IN` is natural for a short, fixed enumeration (e.g. a
state list), while `BETWEEN` expresses an interval; using `IN` for a big range would force
you to list every value.

**3. Why is the Task 5 conclusion about case and Cyrillic important for this course, where nearly all text data is Ukrainian?**

Because the standard assumption "LIKE ignores case" is simply **false for Cyrillic** in
SQLite. A search for `н%` would silently return nothing even though `Називін` exists —
so a Ukrainian-text application must treat search patterns as case-sensitive (or use an
explicit case-insensitive collation that actually handles Cyrillic) or it will produce
wrong/empty results.

## How to run
```bash
sqlite3 medicines.db < script.sql
```
