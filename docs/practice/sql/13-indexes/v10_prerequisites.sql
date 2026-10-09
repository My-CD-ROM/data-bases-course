DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS routes;
DROP TABLE IF EXISTS drivers;
CREATE TABLE drivers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    experience_years INTEGER,
    license_category TEXT
);
CREATE TABLE routes (
    id INTEGER PRIMARY KEY,
    origin TEXT NOT NULL,
    destination TEXT NOT NULL,
    distance_km REAL
);
CREATE TABLE trips (
    id INTEGER PRIMARY KEY,
    driver_id INTEGER REFERENCES drivers(id),
    route_id INTEGER REFERENCES routes(id),
    trip_date TEXT NOT NULL,
    duration_min INTEGER
);
INSERT INTO drivers VALUES (1, 'Савченко', 'Роман', 24, 'CE');
INSERT INTO drivers VALUES (2, 'Гриценко', 'Юлія', 6, 'CE');
INSERT INTO drivers VALUES (3, 'Руденко', 'Максим', 3, 'CE');
INSERT INTO drivers VALUES (4, 'Коваль', 'Олег', 18, 'D');
INSERT INTO drivers VALUES (5, 'Кравець', 'Ігор', 22, 'D');
INSERT INTO drivers VALUES (6, 'Ткаченко', 'Роман', 6, 'CE');
INSERT INTO drivers VALUES (7, 'Кравець', 'Ігор', 20, 'CE');
INSERT INTO drivers VALUES (8, 'Ткаченко', 'Оксана', 3, 'CE');
INSERT INTO drivers VALUES (9, 'Кравець', 'Наталія', 1, 'C');
INSERT INTO drivers VALUES (10, 'Литвин', 'Софія', 2, 'C');
INSERT INTO drivers VALUES (11, 'Коваль', 'Ігор', 12, 'CE');
INSERT INTO drivers VALUES (12, 'Поліщук', 'Олег', 22, 'CE');
INSERT INTO routes VALUES (1, 'Київ', 'Львів', 540.0);
INSERT INTO routes VALUES (2, 'Київ', 'Одеса', 480.0);
INSERT INTO routes VALUES (3, 'Львів', 'Івано-Франківськ', 130.0);
INSERT INTO routes VALUES (4, 'Харків', 'Полтава', 145.0);
INSERT INTO routes VALUES (5, 'Дніпро', 'Запоріжжя', 85.0);
INSERT INTO routes VALUES (6, 'Київ', 'Вінниця', 260.0);
INSERT INTO routes VALUES (7, 'Одеса', 'Миколаїв', 130.0);
INSERT INTO routes VALUES (8, 'Київ', 'Чернігів', 150.0);
INSERT INTO routes VALUES (9, 'Львів', 'Тернопіль', 125.0);
INSERT INTO routes VALUES (10, 'Полтава', 'Черкаси', 165.0);
INSERT INTO routes VALUES (11, 'Київ', 'Житомир', 140.0);
INSERT INTO routes VALUES (12, 'Харків', 'Дніпро', 220.0);
INSERT INTO trips VALUES (1, 6, 6, '2025-02-19', 130);
INSERT INTO trips VALUES (2, 9, 6, '2025-06-21', 202);
INSERT INTO trips VALUES (3, 4, 2, '2024-12-06', 315);
INSERT INTO trips VALUES (4, 9, 7, '2024-05-25', 193);
INSERT INTO trips VALUES (5, 12, 8, '2024-10-10', 415);
INSERT INTO trips VALUES (6, 8, 4, '2024-03-28', 97);
INSERT INTO trips VALUES (7, 8, 3, '2025-02-26', 409);
INSERT INTO trips VALUES (8, 6, 11, '2025-12-03', 341);
INSERT INTO trips VALUES (9, 9, 5, '2025-03-23', 423);
INSERT INTO trips VALUES (10, 12, 11, '2024-06-17', 174);
INSERT INTO trips VALUES (11, 2, 4, '2024-04-26', 312);
INSERT INTO trips VALUES (12, 1, 6, '2025-08-26', 342);
INSERT INTO trips VALUES (13, 3, 10, '2024-02-10', 263);
INSERT INTO trips VALUES (14, 12, 12, '2025-09-14', 453);
INSERT INTO trips VALUES (15, 7, 10, '2024-03-11', 388);
INSERT INTO trips VALUES (16, 2, 8, '2025-11-17', 236);
INSERT INTO trips VALUES (17, 3, 9, '2024-03-14', 317);
INSERT INTO trips VALUES (18, 1, 2, '2024-05-06', 142);
INSERT INTO trips VALUES (19, 6, 12, '2024-06-17', 205);
INSERT INTO trips VALUES (20, 2, 5, '2024-11-18', 200);
