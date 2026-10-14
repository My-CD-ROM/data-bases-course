PRAGMA foreign_keys = ON;

CREATE TABLE visits (
    id INTEGER PRIMARY KEY,
    client_id INTEGER NOT NULL,
    visit_date TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL
        CHECK (duration_minutes BETWEEN 15 AND 240),
    visit_type TEXT NOT NULL
        CHECK (visit_type IN (
            'Самостійне тренування',
            'Групове заняття',
            'Персональне тренування'
        )),
    FOREIGN KEY (client_id)
        REFERENCES clients(id)
        ON DELETE CASCADE
);

INSERT INTO visits
    (client_id, visit_date, duration_minutes, visit_type)
VALUES
    (1, '2026-09-03', 60, 'Групове заняття'),
    (1, '2026-09-12', 45, 'Самостійне тренування'),
    (1, '2026-10-04', 60, 'Персональне тренування'),
    (1, '2026-10-11', 60, 'Групове заняття'),
    (2, '2026-09-06', 50, 'Групове заняття'),
    (2, '2026-10-02', 60, 'Самостійне тренування'),
    (3, '2026-09-10', 90, 'Персональне тренування'),
    (5, '2026-09-14', 45, 'Самостійне тренування'),
    (5, '2026-10-08', 60, 'Групове заняття'),
    (5, '2026-10-10', 75, 'Персональне тренування');
SELECT * FROM visits;

SELECT
    c.id AS client_id,
    c.last_name,
    c.first_name,
    COUNT(v.id) AS visits_count
FROM clients AS c
JOIN visits AS v ON c.id = v.client_id
GROUP BY c.id, c.last_name, c.first_name
ORDER BY visits_count DESC;

SELECT
    c.id AS client_id,
    c.last_name,
    c.first_name,
    COUNT(v.id) AS visits_count
FROM clients AS c
JOIN visits AS v ON c.id = v.client_id
GROUP BY c.id, c.last_name, c.first_name
HAVING COUNT(v.id) >= 2
ORDER BY visits_count DESC;

SELECT
    c.id AS client_id,
    c.last_name,
    c.first_name,
    COUNT(v.id) AS visits_count
FROM clients AS c
JOIN visits AS v ON c.id = v.client_id
WHERE v.visit_date >= '2026-10-01'
  AND v.visit_date < '2026-11-01'
GROUP BY c.id, c.last_name, c.first_name
HAVING COUNT(v.id) >= 2
ORDER BY visits_count DESC;


INSERT INTO clients (last_name, first_name, phone, birth_date)
VALUES ('Мельник', 'Діана', '+380671234568', '2008-06-15');

SELECT id, last_name, first_name, phone
FROM clients
WHERE phone = '+380671234568';

INSERT INTO visits (client_id, visit_date, duration_minutes, visit_type)
VALUES
    (7, '2026-10-05', 60, 'Групове заняття'),
    (7, '2026-10-09', 45, 'Самостійне тренування');

SELECT
    c.id AS client_id,
    c.last_name,
    c.first_name,
    COUNT(v.id) AS visits_count
FROM clients AS c
JOIN visits AS v ON c.id = v.client_id
GROUP BY c.id, c.last_name, c.first_name
HAVING COUNT(v.id) >= 2
ORDER BY c.id;

SELECT
    c.last_name,
    c.first_name,
    COUNT(v.id) AS visits_count
FROM clients AS c
JOIN visits AS v ON c.id = v.client_id
GROUP BY c.last_name, c.first_name
HAVING COUNT(v.id) >= 2
ORDER BY visits_count DESC;

SELECT
    c.id AS client_id,
    c.last_name,
    c.first_name,
    COUNT(v.id) AS visits_count
FROM clients AS c
LEFT JOIN visits AS v ON c.id = v.client_id
WHERE v.visit_date >= '2026-10-01'
  AND v.visit_date < '2026-11-01'
GROUP BY c.id, c.last_name, c.first_name
HAVING COUNT(v.id) >= 2
ORDER BY visits_count DESC;






