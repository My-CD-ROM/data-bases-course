# Практика 15. Індекси та EXPLAIN QUERY PLAN (варіант 2, інтернет-магазин одягу)

Усі плани отримані для SQLite 3.45.1. Формулювання плану в іншій версії може трохи відрізнятися, але суть (SCAN чи SEARCH) та сама.

## Завдання 1
`EXPLAIN QUERY PLAN SELECT * FROM orders WHERE product_id = 1;` до будь-якого індексу показав: `SCAN orders`. SQLite переглядає всю таблицю рядок за рядком.

## Завдання 2
Після `CREATE INDEX idx_orders_product ON orders(product_id);` той самий запит показав: `SEARCH orders USING INDEX idx_orders_product (product_id=?)`. Слово SCAN змінилось на SEARCH, а в плані з'явився індекс: SQLite знаходить потрібні рядки за значенням `product_id` без перегляду всієї таблиці.

## Завдання 3
Запит `WHERE product_id = 1 AND client_id = 2`:
- **до композитного індексу** (є лише `idx_orders_product`): `SEARCH orders USING INDEX idx_orders_product (product_id=?)`. Індекс звужує вибірку тільки за `product_id`, а умову на `client_id` SQLite перевіряє вже вручну для кожного знайденого рядка.
- **після** `CREATE INDEX idx_orders_product_client ON orders(product_id, client_id);`: `SEARCH orders USING INDEX idx_orders_product_client (product_id=? AND client_id=?)`. Тепер обидві умови використовуються в самому індексі, і SQLite одразу знаходить точні рядки.

## Завдання 4
Запит `SELECT * FROM orders ORDER BY order_date`:
- **до індексу:** `SCAN orders` і окремий крок `USE TEMP B-TREE FOR ORDER BY`. SQLite спочатку читає всю таблицю, а потім сортує результат у тимчасовій структурі.
- **після** `CREATE INDEX idx_orders_date ON orders(order_date);`: `SCAN orders USING INDEX idx_orders_date`. Крок сортування зник, бо індекс уже зберігає дати впорядкованими, і SQLite просто читає рядки в готовому порядку.

## Завдання 5
Після `DROP INDEX idx_orders_product;` план запиту `WHERE product_id = 1` не повернувся до SCAN: `SEARCH orders USING INDEX idx_orders_product_client (product_id=?)`. SQLite використала композитний індекс, бо його перша колонка `product_id` збігається з умовою (індекс працює для початкового префікса колонок). Окремий `SELECT name, tbl_name FROM sqlite_master WHERE type = 'index'` підтвердив, що `idx_orders_product` зі списку зник; лишилися `idx_orders_product_client` і `idx_orders_date` (та автоматичний індекс UNIQUE для `clients.email`).

## Контрольні питання (коротко)
1. `EXPLAIN QUERY PLAN` показує, як SQLite виконуватиме запит (SCAN чи SEARCH, який індекс), але сам запит не виконується. Запит може «працювати» й давати правильний результат, але через повне сканування бути повільним на великій таблиці, тому план перевіряють окремо.
2. Індекс лише на першій колонці знаходить усі рядки з потрібним `product_id`, а умову на `client_id` треба перевіряти для кожного з них окремо. Композитний індекс на обох колонках одразу веде до точних рядків, тому відбирається менше зайвих.
3. Індекс займає місце на диску й уповільнює `INSERT`, `UPDATE` і `DELETE`, бо його треба оновлювати разом із таблицею. Тому індекси створюють цілеспрямовано для колонок, за якими часто фільтрують, об'єднують чи сортують, а не «про всяк випадок» на кожній.
