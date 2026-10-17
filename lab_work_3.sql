CREATE TABLE products (
    id INTEGER PRIMARY KEY,
    name TEXT,
    category TEXT,
    size TEXT,
    price REAL,
    stock_quantity INTEGER
);

CREATE TABLE customers (
    id INTEGER PRIMARY KEY,
    last_name TEXT,
    first_name TEXT,
    email TEXT,
    city TEXT
);

CREATE TABLE orders (
    id INTEGER PRIMARY KEY,
    product_id INTEGER,
    customer_id INTEGER,
    order_date DATE,
    quantity INTEGER,
    status TEXT,
    FOREIGN KEY (product_id) REFERENCES products(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);