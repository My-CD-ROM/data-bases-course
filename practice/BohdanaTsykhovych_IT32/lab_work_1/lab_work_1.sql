CREATE TABLE cars(
id INTEGER PRIMARY KEY,
brand TEXT,
model TEXT,
year INTEGER,
price REAL,
status TEXT
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

SELECT * FROM cars;