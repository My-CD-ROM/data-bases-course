DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS clients;
DROP TABLE IF EXISTS cars;
CREATE TABLE cars (
    id INTEGER PRIMARY KEY,
    brand TEXT NOT NULL,
    model TEXT NOT NULL,
    year INTEGER,
    price REAL,
    status TEXT
);
CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT,
    email TEXT UNIQUE
);
CREATE TABLE sales (
    id INTEGER PRIMARY KEY,
    car_id INTEGER REFERENCES cars(id),
    client_id INTEGER REFERENCES clients(id),
    sale_date TEXT NOT NULL,
    sale_price REAL
);
INSERT INTO cars VALUES (1, 'Toyota', 'Corolla', 2022, 780000.0, 'в наявності');
INSERT INTO cars VALUES (2, 'Skoda', 'Octavia', 2021, 720000.0, 'продано');
INSERT INTO cars VALUES (3, 'Volkswagen', 'Golf', 2023, 850000.0, 'в наявності');
INSERT INTO cars VALUES (4, 'Renault', 'Duster', 2020, 650000.0, 'продано');
INSERT INTO cars VALUES (5, 'Hyundai', 'Tucson', 2022, 980000.0, 'в наявності');
INSERT INTO cars VALUES (6, 'Kia', 'Sportage', 2023, 1050000.0, 'в наявності');
INSERT INTO cars VALUES (7, 'Ford', 'Focus', 2019, 590000.0, 'продано');
INSERT INTO cars VALUES (8, 'Nissan', 'Qashqai', 2021, 890000.0, 'в наявності');
INSERT INTO cars VALUES (9, 'Mazda', 'CX-5', 2022, 1120000.0, 'в наявності');
INSERT INTO cars VALUES (10, 'Honda', 'Civic', 2020, 700000.0, 'продано');
INSERT INTO cars VALUES (11, 'BMW', '3 Series', 2023, 1650000.0, 'в наявності');
INSERT INTO cars VALUES (12, 'Audi', 'A4', 2022, 1580000.0, 'продано');
INSERT INTO clients VALUES (1, 'Ткаченко', 'Софія', '+380673000001', 'софія.ткаченко1@example.com');
INSERT INTO clients VALUES (2, 'Коваль', 'Тетяна', '+380673000002', 'тетяна.коваль2@example.com');
INSERT INTO clients VALUES (3, 'Савченко', 'Ірина', '+380673000003', 'ірина.савченко3@example.com');
INSERT INTO clients VALUES (4, 'Олійник', 'Тарас', '+380673000004', 'тарас.олійник4@example.com');
INSERT INTO clients VALUES (5, 'Захарченко', 'Максим', '+380673000005', 'максим.захарченко5@example.com');
INSERT INTO clients VALUES (6, 'Литвин', 'Петро', '+380673000006', 'петро.литвин6@example.com');
INSERT INTO clients VALUES (7, 'Шевченко', 'Тетяна', '+380673000007', 'тетяна.шевченко7@example.com');
INSERT INTO clients VALUES (8, 'Мельник', 'Максим', '+380673000008', 'максим.мельник8@example.com');
INSERT INTO clients VALUES (9, 'Руденко', 'Максим', '+380673000009', 'максим.руденко9@example.com');
INSERT INTO clients VALUES (10, 'Гончаренко', 'Софія', '+380673000010', 'софія.гончаренко10@example.com');
INSERT INTO clients VALUES (11, 'Коваль', 'Дарина', '+380673000011', 'дарина.коваль11@example.com');
INSERT INTO clients VALUES (12, 'Руденко', 'Максим', '+380673000012', 'максим.руденко12@example.com');
INSERT INTO sales VALUES (1, 1, 2, '2024-11-27', 1532620.25);
INSERT INTO sales VALUES (2, 10, 1, '2025-10-02', 1415730.81);
INSERT INTO sales VALUES (3, 3, 8, '2025-05-06', 1696334.57);
INSERT INTO sales VALUES (4, 7, 11, '2025-02-16', 917553.27);
INSERT INTO sales VALUES (5, 6, 6, '2024-03-11', 993974.11);
INSERT INTO sales VALUES (6, 8, 5, '2025-09-02', 1045791.09);
INSERT INTO sales VALUES (7, 6, 5, '2025-02-25', 985010.07);
INSERT INTO sales VALUES (8, 9, 1, '2025-07-02', 725099.05);
INSERT INTO sales VALUES (9, 6, 10, '2025-11-15', 1411988.64);
INSERT INTO sales VALUES (10, 4, 5, '2024-05-15', 1557015.94);
INSERT INTO sales VALUES (11, 8, 2, '2024-11-20', 1459176.48);
INSERT INTO sales VALUES (12, 12, 3, '2025-09-01', 1162701.69);
INSERT INTO sales VALUES (13, 2, 4, '2024-08-04', 1277251.63);
INSERT INTO sales VALUES (14, 3, 8, '2025-09-23', 828109.88);
INSERT INTO sales VALUES (15, 8, 8, '2024-08-18', 673570.36);
INSERT INTO sales VALUES (16, 4, 10, '2024-02-09', 1427210.16);
INSERT INTO sales VALUES (17, 7, 6, '2025-01-10', 1371261.18);
INSERT INTO sales VALUES (18, 10, 10, '2025-03-15', 1146296.69);
INSERT INTO sales VALUES (19, 6, 6, '2025-08-11', 1543522.02);
INSERT INTO sales VALUES (20, 12, 4, '2025-04-28', 1430653.37);
