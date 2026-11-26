
-- Практична робота №19

-- 1. Створення таблиці абонементів
CREATE TABLE memberships (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    type TEXT NOT NULL,
    duration_days INTEGER NOT NULL,
    price REAL NOT NULL,
    price_per_day REAL GENERATED ALWAYS AS (price / duration_days) STORED,
    is_yearly BOOLEAN GENERATED ALWAYS AS (type = 'Річний') STORED
);

-- 2. Створення таблиці клієнтів
CREATE TABLE clients (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL UNIQUE,
    birth_date DATE NOT NULL
);

-- 3. Створення таблиці продажів абонементів
CREATE TABLE membership_sales (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    membership_id INTEGER NOT NULL
        REFERENCES memberships(id) ON DELETE RESTRICT,
    client_id INTEGER NOT NULL
        REFERENCES clients(id) ON DELETE CASCADE,
    purchase_date DATE NOT NULL,
    expiration_date DATE NOT NULL
);

-- 4. Синхронізація лічильників після імпорту CSV
SELECT setval(
    pg_get_serial_sequence('public.memberships', 'id'),
    (SELECT MAX(id) FROM memberships)
);

SELECT setval(
    pg_get_serial_sequence('public.clients', 'id'),
    (SELECT MAX(id) FROM clients)
);

SELECT setval(
    pg_get_serial_sequence('public.membership_sales', 'id'),
    (SELECT MAX(id) FROM membership_sales)
);

-- 5. Перевірка кількості записів
SELECT 'memberships' AS table_name, COUNT(*) AS records
FROM memberships
UNION ALL
SELECT 'clients', COUNT(*) FROM clients
UNION ALL
SELECT 'membership_sales', COUNT(*) FROM membership_sales;

-- 6. Перевірка зв'язків між таблицями
SELECT
    ms.id,
    c.last_name,
    c.first_name,
    m.type AS membership_type,
    ms.purchase_date,
    ms.expiration_date
FROM membership_sales ms
JOIN clients c ON ms.client_id = c.id
JOIN memberships m ON ms.membership_id = m.id
ORDER BY ms.id;

-- 7. Перевірка обчислюваних стовпців
SELECT id, type, duration_days, price,
       price_per_day, is_yearly
FROM memberships
ORDER BY id;

-- 8. Перевірка зовнішнього ключа
-- Спроба використати неіснуючий membership_id = 999
-- викликає помилку SQLSTATE 23503.
