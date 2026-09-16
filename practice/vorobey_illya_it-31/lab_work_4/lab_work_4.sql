<?xml version="1.0" encoding="UTF-8"?><sqlb_project><db path="lab_work_4.db" readonly="0" foreign_keys="1" case_sensitive_like="0" temp_store="0" wal_autocheckpoint="1000" synchronous="2"/><attached/><window><main_tabs open="structure browser pragmas query" current="3"/></window><tab_structure><column_width id="0" width="300"/><column_width id="1" width="0"/><column_width id="2" width="100"/><column_width id="3" width="1781"/><column_width id="4" width="0"/><expanded_item id="0" parent="1"/><expanded_item id="1" parent="1"/><expanded_item id="2" parent="1"/><expanded_item id="3" parent="1"/></tab_structure><tab_browse><table title="cars" custom_title="0" dock_id="1" table="4,4:maincars"/><dock_state state="000000ff00000000fd00000001000000020000000000000000fc0100000001fb000000160064006f0063006b00420072006f00770073006500310100000000ffffffff0000012200ffffff000000000000000000000004000000040000000800000008fc00000000"/><default_encoding codec=""/><browse_table_settings/></tab_browse><tab_sql><sql name="SQL 1*">PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS sales;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS cars;

CREATE TABLE cars (
    id INTEGER PRIMARY KEY,
    brand TEXT NOT NULL,
    model TEXT NOT NULL,
    year INTEGER,
    price REAL,
    status TEXT NOT NULL DEFAULT 'в наявності'
);

INSERT INTO cars (brand, model, year, price, status) VALUES
    ('Toyota', 'Corolla', 2022, 720000, 'в наявності'),
    ('Volkswagen', 'Golf', 2021, 650000, 'продано'),
    ('Skoda', 'Octavia', 2023, 780000, 'в наявності'),
    ('Renault', 'Duster', 2020, 580000, 'в наявності'),
    ('Hyundai', 'Tucson', 2022, 950000, 'зарезервовано'),
    ('Ford', 'Focus', 2019, 490000, 'продано');

CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT NOT NULL,
    city TEXT
);

INSERT INTO customers (name, phone, city) VALUES
    ('Іван Петренко', '+380671112233', 'Київ'),
    ('Олена Коваленко', '+380672223344', 'Львів'),
    ('Андрій Мельник', '+380673334455', 'Одеса'),
    ('Марія Шевченко', '+380674445566', 'Дніпро'),
    ('Дмитро Бондаренко', '+380675556677', 'Харків'),
    ('Наталія Ткаченко', '+380676667788', 'Вінниця');

CREATE TABLE sales (
    id INTEGER PRIMARY KEY,
    car_id INTEGER NOT NULL,
    customer_id INTEGER,
    sale_date TEXT NOT NULL,
    sale_price REAL NOT NULL,
    FOREIGN KEY (car_id) REFERENCES cars(id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE SET NULL
);

INSERT INTO sales (car_id, customer_id, sale_date, sale_price) VALUES
    (1, 1, '2026-08-01', 720000),
    (2, 2, '2026-08-03', 650000),
    (3, 3, '2026-08-05', 780000),
    (4, 4, '2026-08-07', 580000),
    (5, 5, '2026-08-10', 950000),
    (6, 6, '2026-08-12', 490000),
    (1, 3, '2026-08-15', 715000),
    (3, 1, '2026-08-18', 775000),
    (4, 5, '2026-08-20', 575000),
    (5, 2, '2026-08-22', 940000);




</sql><current_tab id="0"/></tab_sql></sqlb_project>
