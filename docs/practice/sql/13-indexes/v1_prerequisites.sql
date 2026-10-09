DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS readers;
DROP TABLE IF EXISTS books;
CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    author TEXT NOT NULL,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER
);
CREATE TABLE readers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT UNIQUE,
    registration_date TEXT
);
CREATE TABLE loans (
    id INTEGER PRIMARY KEY,
    book_id INTEGER REFERENCES books(id),
    reader_id INTEGER REFERENCES readers(id),
    loan_date TEXT NOT NULL,
    return_date TEXT
);
INSERT INTO books VALUES (1, 'Кобзар', 'Тарас Шевченко', 1840, 'поезія', 4);
INSERT INTO books VALUES (2, 'Тигролови', 'Іван Багряний', 1944, 'роман', 3);
INSERT INTO books VALUES (3, 'Захар Беркут', 'Іван Франко', 1883, 'повість', 5);
INSERT INTO books VALUES (4, 'Місто', 'Валер''ян Підмогильний', 1928, 'роман', 2);
INSERT INTO books VALUES (5, 'Лісова пісня', 'Леся Українка', 1911, 'драма', 3);
INSERT INTO books VALUES (6, 'Тіні забутих предків', 'Михайло Коцюбинський', 1911, 'повість', 4);
INSERT INTO books VALUES (7, 'Собор', 'Олесь Гончар', 1968, 'роман', 2);
INSERT INTO books VALUES (8, 'Хіба ревуть воли, як ясла повні?', 'Панас Мирний', 1880, 'роман', 3);
INSERT INTO books VALUES (9, 'Маруся Чурай', 'Ліна Костенко', 1979, 'поема', 5);
INSERT INTO books VALUES (10, 'Земля', 'Ольга Кобилянська', 1902, 'повість', 2);
INSERT INTO books VALUES (11, 'Внутрішня Україна', 'Оксана Забужко', 1997, 'есеї', 3);
INSERT INTO books VALUES (12, 'Записки українського самашедшого', 'Ліна Костенко', 2010, 'роман', 4);
INSERT INTO readers VALUES (1, 'Захарченко', 'Максим', 'максим.захарченко1@example.com', '2022-04-05');
INSERT INTO readers VALUES (2, 'Руденко', 'Андрій', 'андрій.руденко2@example.com', '2024-07-02');
INSERT INTO readers VALUES (3, 'Іванов', 'Тарас', 'тарас.іванов3@example.com', '2024-10-01');
INSERT INTO readers VALUES (4, 'Гончаренко', 'Роман', 'роман.гончаренко4@example.com', '2022-08-19');
INSERT INTO readers VALUES (5, 'Ткаченко', 'Оксана', 'оксана.ткаченко5@example.com', '2022-12-14');
INSERT INTO readers VALUES (6, 'Кравець', 'Тарас', 'тарас.кравець6@example.com', '2023-02-03');
INSERT INTO readers VALUES (7, 'Олійник', 'Ігор', 'ігор.олійник7@example.com', '2024-05-26');
INSERT INTO readers VALUES (8, 'Іванов', 'Марія', 'марія.іванов8@example.com', '2023-02-18');
INSERT INTO readers VALUES (9, 'Ткаченко', 'Юлія', 'юлія.ткаченко9@example.com', '2024-04-23');
INSERT INTO readers VALUES (10, 'Коваль', 'Тарас', 'тарас.коваль10@example.com', '2023-02-28');
INSERT INTO readers VALUES (11, 'Бондаренко', 'Дарина', 'дарина.бондаренко11@example.com', '2023-08-21');
INSERT INTO readers VALUES (12, 'Литвин', 'Ігор', 'ігор.литвин12@example.com', '2023-04-22');
INSERT INTO loans VALUES (1, 5, 12, '2024-10-21', NULL);
INSERT INTO loans VALUES (2, 12, 4, '2024-08-13', NULL);
INSERT INTO loans VALUES (3, 11, 12, '2024-11-11', '2024-04-27');
INSERT INTO loans VALUES (4, 1, 6, '2025-05-03', NULL);
INSERT INTO loans VALUES (5, 10, 12, '2025-04-21', '2025-03-09');
INSERT INTO loans VALUES (6, 3, 4, '2025-12-19', '2025-06-08');
INSERT INTO loans VALUES (7, 3, 9, '2025-02-25', NULL);
INSERT INTO loans VALUES (8, 2, 3, '2024-11-14', '2025-07-20');
INSERT INTO loans VALUES (9, 8, 9, '2025-09-28', '2024-11-18');
INSERT INTO loans VALUES (10, 5, 11, '2025-02-10', '2025-01-24');
INSERT INTO loans VALUES (11, 12, 5, '2024-09-04', '2025-11-17');
INSERT INTO loans VALUES (12, 10, 4, '2024-06-25', NULL);
INSERT INTO loans VALUES (13, 9, 1, '2025-08-01', NULL);
INSERT INTO loans VALUES (14, 6, 5, '2024-01-08', '2024-02-24');
INSERT INTO loans VALUES (15, 8, 2, '2024-03-22', '2024-05-17');
INSERT INTO loans VALUES (16, 10, 7, '2024-09-25', '2024-12-10');
INSERT INTO loans VALUES (17, 7, 11, '2025-08-17', '2024-04-03');
INSERT INTO loans VALUES (18, 6, 1, '2024-10-08', NULL);
INSERT INTO loans VALUES (19, 12, 11, '2024-04-03', '2025-02-17');
INSERT INTO loans VALUES (20, 4, 5, '2025-04-18', NULL);
