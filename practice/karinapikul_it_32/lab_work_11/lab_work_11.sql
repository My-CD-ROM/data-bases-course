PRAGMA foreign_keys = ON;

-- Практична робота №11

-- 1. Створення таблиці відвідувань
CREATE TABLE visits (
    id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL,
    visit_date TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    visit_type TEXT NOT NULL DEFAULT 'Тренування',
    FOREIGN KEY (client_id) REFERENCES clients(id),
    UNIQUE (client_id, visit_date, duration_minutes, visit_type)
);

-- 2. Додавання відвідувань
INSERT OR IGNORE INTO visits
    (client_id, visit_date, duration_minutes, visit_type)
VALUES
    (2, '2026-09-02', 60, 'Тренування'),
    (2, '2026-09-10', 45, 'Кардіо'),
    (2, '2026-09-18', 60, 'Тренування'),
    (3, '2026-09-05', 50, 'Кардіо'),
    (3, '2026-09-15', 60, 'Тренування'),
    (4, '2026-09-08', 45, 'Кардіо'),
    (5, '2026-09-12', 60, 'Тренування'),
    (6, '2026-09-20', 55, 'Тренування');

-- 3. Відвідування разом з іменами клієнтів
SELECT
    clients.id,
    clients.last_name,
    clients.first_name,
    visits.visit_date,
    visits.duration_minutes,
    visits.visit_type
FROM clients
JOIN visits ON clients.id = visits.client_id
ORDER BY visits.visit_date;

-- 4. Кількість відвідувань кожного клієнта
SELECT
    clients.id,
    clients.last_name,
    clients.first_name,
    COUNT(visits.id) AS visits_count
FROM clients
JOIN visits ON clients.id = visits.client_id
GROUP BY clients.id, clients.last_name, clients.first_name
ORDER BY visits_count DESC;

-- 5. Клієнти, які відвідали клуб щонайменше двічі
SELECT
    clients.last_name,
    clients.first_name,
    COUNT(visits.id) AS visits_count
FROM clients
JOIN visits ON clients.id = visits.client_id
GROUP BY clients.id, clients.last_name, clients.first_name
HAVING COUNT(visits.id) >= 2
ORDER BY visits_count DESC;