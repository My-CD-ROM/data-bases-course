
PRAGMA foreign_keys = ON;

-- Завдання 1
CREATE TABLE visits (
    id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL REFERENCES clients(id) ON DELETE RESTRICT,
    visit_date TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    visit_type TEXT NOT NULL DEFAULT 'Тренування'
);

INSERT INTO visits (client_id, visit_date, duration_minutes, visit_type) VALUES
(1, '2026-01-12', 60, 'Тренування'),
(1, '2026-02-03', 45, 'Кардіо'),
(1, '2026-03-15', 70, 'Тренування'),
(2, '2026-01-20', 50, 'Кардіо'),
(2, '2026-04-02', 60, 'Тренування'),
(3, '2026-02-11', 40, 'Тренування');


-- Завдання 2
SELECT
    clients.id AS client_id,
    clients.last_name,
    clients.first_name,
    COUNT(visits.id) AS visits_count
FROM clients
JOIN visits
    ON visits.client_id = clients.id
GROUP BY clients.id, clients.last_name, clients.first_name
ORDER BY visits_count DESC;


-- Завдання 3
SELECT
    clients.id AS client_id,
    clients.last_name,
    clients.first_name,
    COUNT(visits.id) AS visits_count
FROM clients
JOIN visits
    ON visits.client_id = clients.id
GROUP BY clients.id, clients.last_name, clients.first_name
HAVING COUNT(visits.id) > 1
ORDER BY visits_count DESC;


-- Завдання 4
SELECT
    clients.id AS client_id,
    clients.last_name,
    clients.first_name,
    COUNT(visits.id) AS visits_count
FROM clients
JOIN visits
    ON visits.client_id = clients.id
WHERE visits.visit_date >= '2026-01-01'
GROUP BY clients.id, clients.last_name, clients.first_name
HAVING COUNT(visits.id) > 1
ORDER BY visits_count DESC;


-- Завдання 5а
INSERT INTO clients (last_name, first_name, phone, birth_date)
SELECT last_name, first_name, '0990000000', birth_date
FROM clients
WHERE id = 1;

INSERT INTO visits (client_id, visit_date, duration_minutes, visit_type)
SELECT id, '2026-05-10', 55, 'Тренування'
FROM clients
WHERE phone = '0990000000';

INSERT INTO visits (client_id, visit_date, duration_minutes, visit_type)
SELECT id, '2026-06-08', 65, 'Кардіо'
FROM clients
WHERE phone = '0990000000';


-- Завдання 5а: групування за id
SELECT
    clients.id AS client_id,
    clients.last_name,
    clients.first_name,
    COUNT(visits.id) AS visits_count
FROM clients
JOIN visits
    ON visits.client_id = clients.id
GROUP BY clients.id, clients.last_name, clients.first_name
HAVING COUNT(visits.id) > 1
ORDER BY visits_count DESC;


-- Завдання 5а: групування за ім'ям і прізвищем
SELECT
    clients.last_name,
    clients.first_name,
    COUNT(visits.id) AS visits_count
FROM clients
JOIN visits
    ON visits.client_id = clients.id
GROUP BY clients.last_name, clients.first_name
HAVING COUNT(visits.id) > 1
ORDER BY visits_count DESC;


-- Завдання 5б
SELECT
    clients.id AS client_id,
    clients.last_name,
    clients.first_name,
    COUNT(visits.id) AS visits_count
FROM clients
LEFT JOIN visits
    ON visits.client_id = clients.id
   AND visits.visit_date >= '2026-01-01'
GROUP BY clients.id, clients.last_name, clients.first_name
HAVING COUNT(visits.id) > 1
ORDER BY visits_count DESC;
