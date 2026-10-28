PRAGMA foreign_keys = ON;

-- =========================================
-- Практична робота №7
-- Тема: JOIN у SQLite
-- Варіант: Аптека
-- =========================================


-- =========================================
-- Завдання 1
-- INNER JOIN: поставки та препарати
-- =========================================

SELECT
    deliveries.id,
    medicines.name AS medicine,
    deliveries.quantity,
    deliveries.purchase_price
FROM deliveries
INNER JOIN medicines
    ON deliveries.medicine_id = medicines.id
ORDER BY medicines.name;


-- =========================================
-- Завдання 2
-- INNER JOIN трьох таблиць
-- =========================================

SELECT
    medicines.name AS medicine,
    suppliers.name AS supplier,
    deliveries.quantity,
    deliveries.purchase_price
FROM deliveries
INNER JOIN medicines
    ON deliveries.medicine_id = medicines.id
INNER JOIN suppliers
    ON deliveries.supplier_id = suppliers.id
ORDER BY medicines.name;


-- =========================================
-- Завдання 3
-- LEFT JOIN: постачальники без поставок
-- =========================================

SELECT
    suppliers.id,
    suppliers.name
FROM suppliers
LEFT JOIN deliveries
    ON deliveries.supplier_id = suppliers.id
WHERE deliveries.id IS NULL;


-- =========================================
-- Завдання 4
-- CROSS JOIN / декартовий добуток
-- =========================================

SELECT COUNT(*) AS total_combinations
FROM medicines, suppliers;

SELECT COUNT(*) AS medicines_count
FROM medicines;

SELECT COUNT(*) AS suppliers_count
FROM suppliers;


-- =========================================
-- Завдання 5
-- Обґрунтування вибору JOIN:
--
-- 1. INNER JOIN використано для отримання
--    тільки пов'язаних записів про поставки
--    та препарати.
--
-- 2. INNER JOIN використано для об'єднання
--    поставок, препаратів і постачальників.
--
-- 3. LEFT JOIN використано для пошуку
--    постачальників, які не мають поставок.
--
-- 4. Декартовий добуток використано для
--    отримання всіх можливих комбінацій
--    препаратів і постачальників.
-- =========================================