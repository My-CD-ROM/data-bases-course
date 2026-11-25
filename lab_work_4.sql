PRAGMA foreign_keys = ON;

CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    category TEXT NOT NULL,
    size TEXT NOT NULL,
    price REAL NOT NULL,
    stock_quantity INTEGER NOT NULL
);

CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    email TEXT NOT NULL,
    city TEXT NOT NULL
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    product_id INTEGER NOT NULL,
    customer_id INTEGER NOT NULL,
    order_date TEXT NOT NULL,
    quantity INTEGER NOT NULL,
    status TEXT NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
);

INSERT INTO products (id, name, category, size, price, stock_quantity) VALUES
    (1, 'Футболка Basic', 'Футболка', 'M', 350, 10),
    (2, 'Футболка Oversize', 'Футболка', 'L', 450, 7),
    (3, 'Джинси Classic', 'Джинси', 'M', 900, 5),
    (4, 'Худі Sport', 'Худі', 'L', 750, 8),
    (5, 'Сорочка Casual', 'Сорочка', 'S', 600, 4),
    (6, 'Куртка Light', 'Куртка', 'M', 1200, 3);

INSERT INTO customers (id, last_name, first_name, email, city) VALUES
    (1, 'Шевченко', 'Олена', 'olena.shevchenko@gmail.com', 'Луцьк'),
    (2, 'Ковальчук', 'Максим', 'maksym.kovalchuk@gmail.com', 'Рівне'),
    (3, 'Бондар', 'Анна', 'anna.bondar@gmail.com', 'Львів'),
    (4, 'Мельник', 'Ігор', 'ihor.melnyk@gmail.com', 'Луцьк'),
    (5, 'Ткаченко', 'Марія', 'maria.tkachenko@gmail.com', 'Київ'),
    (6, 'Сидоренко', 'Андрій', 'andrii.sydorenko@gmail.com', 'Тернопіль');

INSERT INTO orders (id, product_id, customer_id, order_date, quantity, status) VALUES
    (1, 1, 1, '2026-09-01', 2, 'Виконано'),
    (2, 2, 2, '2026-09-02', 1, 'Виконано'),
    (3, 3, 3, '2026-09-03', 1, 'В обробці'),
    (4, 4, 1, '2026-09-04', 2, 'Виконано'),
    (5, 5, 4, '2026-09-05', 1, 'Відправлено'),
    (6, 6, 5, '2026-09-06', 1, 'В обробці'),
    (7, 1, 6, '2026-09-07', 1, 'Виконано'),
    (8, 3, 4, '2026-09-08', 2, 'Відправлено'),
    (9, 2, 5, '2026-09-09', 1, 'В обробці'),
    (10, 4, 2, '2026-09-10', 1, 'Виконано');