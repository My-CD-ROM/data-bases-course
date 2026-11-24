PRAGMA foreign_keys = ON;

CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  first_name TEXT NOT NULL,
  last_name TEXT NOT NULL,
  email TEXT NOT NULL,
  city TEXT NOT NULL
);

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  product_id INTEGER NOT NULL,
  customer_id INTEGER NOT NULL,
  order_date TEXT NOT NULL,
  quantity INTEGER NOT NULL DEFAULT 1,
  status TEXT NOT NULL DEFAULT "замовлено",
  FOREIGN KEY (product_id) REFERENCES products (id) ON DELETE RESTRICT,
  FOREIGN KEY (customer_id) REFERENCES customers (id) ON DELETE SET NULL
);

INSERT INTO customers (first_name, last_name, email, city) VALUES
  ("Борис", "Пропорець", "borys.praporets@gmail.com", "Крижопіль"),
  ("Володимир", "Зелений", "volodymyr.zelenyi@gmail.com", "Стамбул"),
  ("Байрактар", "Лямпа", "bairactar.liampa@gmail.com", "Ковель"),
  ("Іванна", "Зірка", "ivanna.zirka@gmail.com", "Полтава"),
  ("Богдан", "Великодушний", "bogdan.velykodushnyi@gmail.com", "Кривий Ріг"),
  ("Олена", "Добра", "olena.dobra@gmail.com", "Біла церква");

INSERT INTO orders (product_id, customer_id, order_date, quantity, status) VALUES
  (3, 6, "2026-09-14", 2, "відправлено"),
  (1, 5, "2026-08-09", 1, "прийнято"),
  (6, 5, "2026-09-16", 1, "замовлено"),
  (2, 2, "2026-09-02", 1, "доставлено"),
  (5, 2, "2026-05-12", 2, "прийнято"),
  (3, 4, "2026-09-05", 1, "доставлено"),
  (4, 4, "2026-09-11", 2, "відправлено"),
  (6, 4, "2026-09-16", 1, "замовлено"),
  (1, 1, "2026-02-16", 1, "прийнято"),
  (2, 3, "2026-09-15", 1, "замовлено");

-- Видає помилку: At line 1:
-- INSERT INTO orders (product_id, customer_id, order_date, quantity, status) VALUES
--   (30, 16, "2026-09-28", 5, "відправлено")
-- Result: FOREIGN KEY constraint failed