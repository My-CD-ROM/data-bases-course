# Practice 3 — Creating ER-diagrams for given examples

**Variant:** 4 — Apteka (Pharmacy)

This practice is pure **planning**: no database file is modified. The full ER-diagram
of the variant (two dimension tables + one fact table with two foreign keys) is drawn
and analysed in `er-diagram.md`.

## Deliverables
- `er-diagram.md` — the five tasks (mermaid `erDiagram`, relationship types, keys, a new entity, comparison with the example).
- This `readme.md` — review-question answers.

## Review questions and answers

**1. How does a logical model differ from a conceptual one, and how does a physical one differ from a logical one?**

A **conceptual** model describes the domain in business terms — the entities and their
relationships ("a pharmacy has suppliers and medicines, a delivery brings a medicine
from a supplier"), with no details about how the data is stored. A **logical** model
adds structure: it names the tables, columns, primary/foreign keys and relationship
types (1:N), still independent of any specific database product. A **physical** model
is the concrete implementation for a given DBMS — actual data types (INTEGER/REAL/TEXT),
indexes, constraints, storage details — i.e. the real `CREATE TABLE` statements.

**2. Why can't an M:N relationship be implemented with two foreign keys in one of the two main tables, and why is a separate table always needed?**

An M:N relationship means row A is linked to many rows B *and* row B to many rows A.
If we put a foreign key in just one of the two main tables, a single column can hold
only **one** reference, so a table row could point to at most one record of the other
side — that would at best give a 1:N, never an M:N. To store the many-to-many pairs we
need a separate junction (associative) table whose rows each hold the two foreign keys —
one per end of the relationship.

**3. What do the `||`, `o{`, `|{` notations in mermaid erDiagram mean, and how do you read aloud the line `A ||--o{ B`?**

| Symbol | Meaning |
|---|---|
| `||` | "exactly one" — the entity on this side has exactly one related record |
| `o{` | "zero or many" — the entity on this side can have zero or many related records |
| `|{` | "one or many" — the entity on this side has at least one related record |

The line `A ||--o{ B` is read aloud as: **"A has exactly one … of B" / "one A is
related to zero or many B"** — i.e. an entity of `A` corresponds to zero, one or many
entities of `B` (a 1:N relationship from A's perspective).

## How to view the diagram
The `mermaid` diagram in `er-diagram.md` renders in any markdown viewer that supports
Mermaid (e.g. GitHub, VS Code with the Mermaid extension).
