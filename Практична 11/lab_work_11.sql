-- Практична робота №11. Варіант 9 — Університет (деканат)
-- Дослідницьке питання:
-- Які студенти отримали найбільшу суму стипендій у поточному навчальному році?
--
-- Наявні таблиці: university (студенти), subjects (предмети), grades (оцінки).
-- Нова залежна таблиця scholarships пов'язана з university через student_id.

PRAGMA foreign_keys = ON;

-- Завдання 1. Створення нової залежної таблиці та наповнення даними.
CREATE TABLE scholarships (
    id INTEGER PRIMARY KEY,
    student_id INTEGER NOT NULL,
    academic_year TEXT NOT NULL
        CHECK (academic_year GLOB '20[0-9][0-9]-20[0-9][0-9]'),
    scholarship_type TEXT NOT NULL,
    amount INTEGER NOT NULL CHECK (amount > 0),
    assigned_date TEXT NOT NULL,
    UNIQUE (student_id, academic_year, scholarship_type),
    FOREIGN KEY (student_id) REFERENCES university(id) ON DELETE CASCADE
);

INSERT INTO scholarships
    (id, student_id, academic_year, scholarship_type, amount, assigned_date)
VALUES
    (1, 1, '2024-2025', 'Академічна', 2000, '2024-09-01'),
    (2, 1, '2025-2026', 'Академічна', 2500, '2025-09-01'),
    (3, 2, '2025-2026', 'Соціальна', 1800, '2025-09-03'),
    (4, 3, '2025-2026', 'Академічна', 3000, '2025-09-01'),
    (5, 4, '2024-2025', 'Соціальна', 1500, '2024-09-02'),
    (6, 4, '2025-2026', 'Академічна', 1700, '2025-09-01'),
    (7, 5, '2025-2026', 'Академічна', 2200, '2025-09-01'),
    (8, 6, '2025-2026', 'Соціальна', 1000, '2025-09-04');

-- Перевірка наповнення таблиці.
SELECT * FROM scholarships ORDER BY id;
-- 8 рядків. Студент university.id = 7 (Коваленко) не має стипендій.

-- Завдання 2. JOIN + GROUP BY: загальна сума стипендій кожного студента.
SELECT university.id, university.last_name, university.first_name,
       SUM(scholarships.amount) AS total_scholarship
FROM university
JOIN scholarships ON scholarships.student_id = university.id
GROUP BY university.id
ORDER BY university.id;
-- Результат:
-- 1 Петренко Олександр | 4500
-- 2 Іванов Максим      | 1800
-- 3 Сидоренко Марія    | 3000
-- 4 Ковальчук Ірина    | 3200
-- 5 Мельник Андрій     | 2200
-- 6 Бойко Софія        | 1000

-- Завдання 3. HAVING: залишаємо студентів із сумою понад 3000 грн.
SELECT university.id, university.last_name, university.first_name,
       SUM(scholarships.amount) AS total_scholarship
FROM university
JOIN scholarships ON scholarships.student_id = university.id
GROUP BY university.id
HAVING SUM(scholarships.amount) > 3000
ORDER BY university.id;
-- Результат: Петренко Олександр — 4500; Ковальчук Ірина — 3200.

-- Завдання 4. WHERE + JOIN + GROUP BY + HAVING:
-- лише навчальний рік 2025-2026 і сума понад 2000 грн.
SELECT university.id, university.last_name, university.first_name,
       SUM(scholarships.amount) AS total_scholarship
FROM university
JOIN scholarships ON scholarships.student_id = university.id
WHERE scholarships.academic_year = '2025-2026'
GROUP BY university.id
HAVING SUM(scholarships.amount) > 2000
ORDER BY university.id;
-- Результат:
-- Петренко Олександр — 2500
-- Сидоренко Марія — 3000
-- Мельник Андрій — 2200

-- Завдання 5а. Пастка групування.
-- Додаємо студента-двійника з тим самим ім'ям, що й у студента id=1.
INSERT INTO university (id, last_name, first_name, group_name, admission_year)
VALUES (8, 'Петренко', 'Олександр', 'ІТ-24', 2024);

-- Додаємо дві стипендії двійнику: разом 3200 грн.
INSERT INTO scholarships
    (id, student_id, academic_year, scholarship_type, amount, assigned_date)
VALUES
    (9, 8, '2024-2025', 'Академічна', 1600, '2024-09-01'),
    (10, 8, '2025-2026', 'Соціальна', 1600, '2025-09-02');

-- Запит 1: групування за унікальним id — записи двох тезок окремі.
SELECT university.id, university.last_name, university.first_name,
       SUM(scholarships.amount) AS total_scholarship
FROM university
JOIN scholarships ON scholarships.student_id = university.id
GROUP BY university.id
HAVING SUM(scholarships.amount) > 3000
ORDER BY university.id;
-- Результат: id=1 — 4500; id=4 — 3200; id=8 — 3200.

-- Запит 2: групування за текстовими ПІБ — двоє тезок об'єднуються.
SELECT university.last_name, university.first_name,
       SUM(scholarships.amount) AS total_scholarship
FROM university
JOIN scholarships ON scholarships.student_id = university.id
GROUP BY university.last_name, university.first_name
HAVING SUM(scholarships.amount) > 3000
ORDER BY university.last_name, university.first_name;
-- Результат: Ковальчук Ірина — 3200; Петренко Олександр — 7700.

-- Завдання 5б. LEFT JOIN замість JOIN у запиті Завдання 4.
SELECT university.id, university.last_name, university.first_name,
       SUM(scholarships.amount) AS total_scholarship
FROM university
LEFT JOIN scholarships ON scholarships.student_id = university.id
WHERE scholarships.academic_year = '2025-2026'
GROUP BY university.id
HAVING SUM(scholarships.amount) > 2000
ORDER BY university.id;
-- Результат такий самий, як у Завданні 4: 3 студенти.
-- Студент id=7 без стипендій не потрапляє до результату:
-- після LEFT JOIN academic_year має NULL, а WHERE відкидає цей рядок.

-- Завдання 5в. Відповідь на дослідницьке питання:
-- У 2025-2026 навчальному році понад 2000 грн стипендій отримали
-- Петренко Олександр (2500 грн), Сидоренко Марія (3000 грн)
-- та Мельник Андрій (2200 грн).
--
-- Контрольне питання:
-- JOIN дасть 6 рядків (2 книги × 3 продажі). COUNT(*) порахує продажі,
-- а не книги. Щоб порахувати книги, потрібно COUNT(DISTINCT books.id).
