PRAGMA foreign_keys = ON;

CREATE TABLE cars(
    id INTEGER PRIMARY KEY,
    brand TEXT,
    model TEXT,
    year INTEGER,
    price REAL,
    status TEXT
);

CREATE TABLE clients(
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT NOT NULL,
    email TEXT
);

CREATE TABLE sales (
    id INTEGER PRIMARY KEY,
    car_id INTEGER NOT NULL,
    client_id INTEGER,
    sale_date TEXT NOT NULL,
    sale_price REAL NOT NULL,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE RESTRICT,
    FOREIGN KEY (client_id) REFERENCES clients(id) ON DELETE SET NULL
);



INSERT INTO cars VALUES(1,'Toyota','Camry',2023,28500.0,'В наявності'),
    (2,'BMW','X5',2022,57000.0,'Продано'),
    (3,'Audi','A6',2024,49000.0,'В наявності'),
    (4,'Volkswagen','Passat',2021,23500.0,'В наявності'),
    (5,'Mercedes-Benz','C-Class',2023,45500.0,'Під замовлення'),
    (6,'Skoda','Octavia',2022,21900.0,'Продано'),
    (7,'Renault','Megane',2021,19800.0,'в наявності'),
    (8,'Ford','Kuga',2022,27400.0,'під замовлення'),
    (9,'Hyundai','Tucson',2023,31900.0,'в наявності'),
    (10,'Kia','Sportage',2020,24600.0,'продано'),
    (11,'Volvo','XC60',2022,43800.0,'в наявності');

INSERT INTO clients (id, last_name, first_name, phone, email) VALUES
    (1, 'Коваль', 'Олена', '+380671112233', 'olena.koval@gmail.com'),
    (2, 'Мельник', 'Андрій', '+380502223344', 'andrii.melnyk@gmail.com'),
    (3, 'Бондар', 'Ірина', '+380933334455', 'iryna.bondar@gmail.com'),
    (4, 'Шевчук', 'Максим', '+380674445566', 'maksym.shevchuk@gmail.com'),
    (5, 'Ткачук', 'Наталія', '+380505556677', 'nataliia.tkachuk@gmail.com'),
    (6, 'Поліщук', 'Віктор', '+380936667788', 'viktor.polishchuk@gmail.com');

INSERT INTO sales (id, car_id, client_id, sale_date, sale_price) VALUES
    (1, 1, 1, '2026-01-15', 28000.0),
    (2, 2, 2, '2026-02-03', 56500.0),
    (3, 3, 3, '2026-02-20', 48500.0),
    (4, 4, 4, '2026-03-11', 23000.0),
    (5, 5, 5, '2026-04-07', 45000.0),
    (6, 6, 6, '2026-04-25', 21500.0),
    (7, 7, 1, '2026-05-14', 33500.0),
    (8, 8, 2, '2026-06-02', 27500.0),
    (9, 9, 3, '2026-06-19', 24500.0),
    (10, 10, 4, '2026-07-08', 30000.0);
