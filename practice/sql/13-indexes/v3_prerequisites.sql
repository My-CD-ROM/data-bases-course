DROP TABLE IF EXISTS tickets;
DROP TABLE IF EXISTS viewers;
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    genre TEXT,
    duration_min INTEGER,
    year INTEGER,
    age_rating TEXT
);
CREATE TABLE viewers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT UNIQUE,
    phone TEXT
);
CREATE TABLE tickets (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER REFERENCES movies(id),
    viewer_id INTEGER REFERENCES viewers(id),
    hall INTEGER,
    showtime TEXT,
    price REAL,
    seat TEXT,
    purchase_date TEXT
);
INSERT INTO movies VALUES (1, 'Тіні забутих предків', 'драма', 97, 1965, '12+');
INSERT INTO movies VALUES (2, 'Атлантида', 'фантастика', 108, 2019, '16+');
INSERT INTO movies VALUES (3, 'Поводир', 'драма', 130, 2013, '16+');
INSERT INTO movies VALUES (4, 'Мої думки тихі', 'комедія', 96, 2019, '12+');
INSERT INTO movies VALUES (5, 'Плем''я', 'драма', 132, 2014, '18+');
INSERT INTO movies VALUES (6, 'Незламна', 'драма', 104, 2022, '16+');
INSERT INTO movies VALUES (7, 'Стрімкі води', 'пригоди', 112, 2021, '12+');
INSERT INTO movies VALUES (8, 'Останній москаль', 'комедія', 100, 2018, '16+');
INSERT INTO movies VALUES (9, 'Дике поле', 'драма', 118, 2018, '18+');
INSERT INTO movies VALUES (10, 'Земля', 'драма', 71, 1930, '0+');
INSERT INTO movies VALUES (11, 'Вулкан', 'драма', 99, 2018, '16+');
INSERT INTO movies VALUES (12, 'Носороги', 'драма', 116, 2021, '18+');
INSERT INTO viewers VALUES (1, 'Поліщук', 'Ірина', 'ірина.поліщук1@example.com', '+380501000001');
INSERT INTO viewers VALUES (2, 'Литвин', 'Олег', 'олег.литвин2@example.com', '+380501000002');
INSERT INTO viewers VALUES (3, 'Гриценко', 'Олег', 'олег.гриценко3@example.com', '+380501000003');
INSERT INTO viewers VALUES (4, 'Руденко', 'Дарина', 'дарина.руденко4@example.com', '+380501000004');
INSERT INTO viewers VALUES (5, 'Савченко', 'Ірина', 'ірина.савченко5@example.com', '+380501000005');
INSERT INTO viewers VALUES (6, 'Ткаченко', 'Андрій', 'андрій.ткаченко6@example.com', '+380501000006');
INSERT INTO viewers VALUES (7, 'Олійник', 'Софія', 'софія.олійник7@example.com', '+380501000007');
INSERT INTO viewers VALUES (8, 'Бондаренко', 'Богдан', 'богдан.бондаренко8@example.com', '+380501000008');
INSERT INTO viewers VALUES (9, 'Кравець', 'Тарас', 'тарас.кравець9@example.com', '+380501000009');
INSERT INTO viewers VALUES (10, 'Бондаренко', 'Тарас', 'тарас.бондаренко10@example.com', '+380501000010');
INSERT INTO viewers VALUES (11, 'Олійник', 'Андрій', 'андрій.олійник11@example.com', '+380501000011');
INSERT INTO viewers VALUES (12, 'Савченко', 'Роман', 'роман.савченко12@example.com', '+380501000012');
INSERT INTO tickets VALUES (1, 11, 9, 3, '2025-02-09 12:00', 180.0, '1А', '2025-06-24');
INSERT INTO tickets VALUES (2, 6, 7, 5, '2025-07-19 13:00', 180.0, '1Г', '2025-09-26');
INSERT INTO tickets VALUES (3, 9, 11, 2, '2025-07-03 20:00', 180.0, '10В', '2025-12-10');
INSERT INTO tickets VALUES (4, 9, 5, 4, '2025-07-23 14:00', 150.0, '4Г', '2025-11-24');
INSERT INTO tickets VALUES (5, 3, 10, 5, '2025-07-18 10:00', 180.0, '5Б', '2025-10-20');
INSERT INTO tickets VALUES (6, 11, 6, 4, '2025-08-22 13:00', 200.0, '3А', '2025-09-22');
INSERT INTO tickets VALUES (7, 11, 10, 3, '2025-04-22 14:00', 150.0, '4Б', '2025-01-08');
INSERT INTO tickets VALUES (8, 8, 10, 1, '2025-07-21 19:00', 150.0, '7Г', '2025-04-05');
INSERT INTO tickets VALUES (9, 11, 12, 1, '2025-07-08 12:00', 200.0, '1Д', '2025-02-15');
INSERT INTO tickets VALUES (10, 3, 8, 5, '2025-08-20 21:00', 200.0, '9Г', '2025-12-28');
INSERT INTO tickets VALUES (11, 8, 8, 3, '2025-11-09 22:00', 200.0, '4В', '2025-02-23');
INSERT INTO tickets VALUES (12, 5, 4, 3, '2025-06-18 11:00', 150.0, '3Б', '2025-12-05');
INSERT INTO tickets VALUES (13, 12, 4, 1, '2025-07-11 18:00', 200.0, '7А', '2025-07-13');
INSERT INTO tickets VALUES (14, 10, 12, 1, '2025-08-01 15:00', 180.0, '7Г', '2025-08-08');
INSERT INTO tickets VALUES (15, 5, 7, 4, '2025-07-11 20:00', 200.0, '3Г', '2025-10-18');
INSERT INTO tickets VALUES (16, 1, 7, 5, '2025-02-21 16:00', 150.0, '8Б', '2025-05-13');
INSERT INTO tickets VALUES (17, 6, 4, 4, '2025-06-25 16:00', 180.0, '7В', '2025-08-01');
INSERT INTO tickets VALUES (18, 12, 9, 1, '2025-04-21 11:00', 120.0, '1Б', '2025-01-20');
INSERT INTO tickets VALUES (19, 3, 4, 2, '2025-11-04 19:00', 150.0, '8В', '2025-03-20');
INSERT INTO tickets VALUES (20, 10, 12, 1, '2025-05-04 19:00', 120.0, '5Д', '2025-07-23');
