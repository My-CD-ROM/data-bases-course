DROP TABLE IF EXISTS deliveries;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS medicines;
CREATE TABLE medicines (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    manufacturer TEXT,
    form TEXT,
    price REAL,
    stock_quantity INTEGER
);
CREATE TABLE suppliers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    contact_person TEXT,
    phone TEXT,
    city TEXT
);
CREATE TABLE deliveries (
    id INTEGER PRIMARY KEY,
    medicine_id INTEGER REFERENCES medicines(id),
    supplier_id INTEGER REFERENCES suppliers(id),
    delivery_date TEXT NOT NULL,
    quantity INTEGER,
    purchase_price REAL
);
INSERT INTO medicines VALUES (1, 'Парацетамол', 'Дарниця', 'таблетки', 25.0, 120);
INSERT INTO medicines VALUES (2, 'Ібупрофен', 'Фармак', 'таблетки', 45.0, 90);
INSERT INTO medicines VALUES (3, 'Но-шпа', 'Chinoin', 'таблетки', 110.0, 60);
INSERT INTO medicines VALUES (4, 'Аспірин', 'Bayer', 'таблетки', 55.0, 80);
INSERT INTO medicines VALUES (5, 'Мукалтин', 'Тернофарм', 'таблетки', 30.0, 100);
INSERT INTO medicines VALUES (6, 'Валідол', 'Дарниця', 'таблетки', 20.0, 70);
INSERT INTO medicines VALUES (7, 'Амоксицилін', 'Київмедпрепарат', 'капсули', 65.0, 50);
INSERT INTO medicines VALUES (8, 'Лоратадин', 'Фармак', 'таблетки', 40.0, 65);
INSERT INTO medicines VALUES (9, 'Сироп від кашлю', 'Тернофарм', 'сироп', 85.0, 40);
INSERT INTO medicines VALUES (10, 'Крем від опіків', 'Дарниця', 'мазь', 95.0, 35);
INSERT INTO medicines VALUES (11, 'Вітамін C', 'Фармак', 'таблетки', 60.0, 110);
INSERT INTO medicines VALUES (12, 'Активоване вугілля', 'Київмедпрепарат', 'таблетки', 15.0, 150);
INSERT INTO suppliers VALUES (1, 'Оптіма-Фарм', 'Тарас Бондаренко', '+380442000001', 'Львів');
INSERT INTO suppliers VALUES (2, 'БаДМ', 'Марія Руденко', '+380442000002', 'Київ');
INSERT INTO suppliers VALUES (3, 'Вента.Лтд', 'Юлія Кравець', '+380442000003', 'Львів');
INSERT INTO suppliers VALUES (4, 'Альба Україна', 'Оксана Гончаренко', '+380442000004', 'Полтава');
INSERT INTO suppliers VALUES (5, 'Фра-М', 'Роман Литвин', '+380442000005', 'Вінниця');
INSERT INTO suppliers VALUES (6, 'Медфармком', 'Софія Захарченко', '+380442000006', 'Одеса');
INSERT INTO suppliers VALUES (7, 'Ліки Контроль', 'Максим Олійник', '+380442000007', 'Черкаси');
INSERT INTO suppliers VALUES (8, 'Аптека Холдинг', 'Максим Мельник', '+380442000008', 'Вінниця');
INSERT INTO suppliers VALUES (9, 'Юніфарма', 'Андрій Литвин', '+380442000009', 'Дніпро');
INSERT INTO suppliers VALUES (10, 'Фармпостач', 'Богдан Гриценко', '+380442000010', 'Полтава');
INSERT INTO suppliers VALUES (11, 'Медзабезпечення', 'Ігор Кравець', '+380442000011', 'Одеса');
INSERT INTO suppliers VALUES (12, 'Ліксем', 'Максим Мельник', '+380442000012', 'Вінниця');
INSERT INTO deliveries VALUES (1, 5, 10, '2025-09-01', 76, 85.85);
INSERT INTO deliveries VALUES (2, 2, 4, '2025-08-18', 40, 65.25);
INSERT INTO deliveries VALUES (3, 11, 12, '2025-08-26', 12, 17.44);
INSERT INTO deliveries VALUES (4, 4, 7, '2024-05-22', 84, 39.52);
INSERT INTO deliveries VALUES (5, 9, 9, '2025-07-24', 80, 36.46);
INSERT INTO deliveries VALUES (6, 12, 8, '2025-05-09', 39, 19.65);
INSERT INTO deliveries VALUES (7, 4, 6, '2024-12-18', 98, 24.81);
INSERT INTO deliveries VALUES (8, 4, 12, '2025-05-24', 85, 88.13);
INSERT INTO deliveries VALUES (9, 9, 10, '2025-02-27', 34, 33.7);
INSERT INTO deliveries VALUES (10, 6, 3, '2025-01-23', 78, 20.13);
INSERT INTO deliveries VALUES (11, 1, 1, '2025-12-05', 91, 79.48);
INSERT INTO deliveries VALUES (12, 8, 2, '2024-10-10', 70, 48.3);
INSERT INTO deliveries VALUES (13, 6, 3, '2024-05-28', 71, 19.13);
INSERT INTO deliveries VALUES (14, 2, 7, '2025-02-19', 90, 64.92);
INSERT INTO deliveries VALUES (15, 3, 3, '2025-02-08', 25, 54.65);
INSERT INTO deliveries VALUES (16, 7, 10, '2024-09-13', 67, 82.68);
INSERT INTO deliveries VALUES (17, 5, 10, '2025-05-19', 89, 14.82);
INSERT INTO deliveries VALUES (18, 12, 2, '2024-11-07', 43, 62.83);
INSERT INTO deliveries VALUES (19, 3, 4, '2024-09-03', 30, 10.21);
INSERT INTO deliveries VALUES (20, 8, 12, '2025-05-02', 39, 33.05);
