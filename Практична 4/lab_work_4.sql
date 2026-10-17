PRAGMA foreign_keys = ON;

CREATE TABLE readers (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    phone TEXT,
    address TEXT
);

CREATE TABLE loans (
    id INTEGER PRIMARY KEY,
    book_id INTEGER NOT NULL,
    reader_id INTEGER NOT NULL,
    loan_date TEXT NOT NULL,
    return_date TEXT,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE RESTRICT,
    FOREIGN KEY (reader_id) REFERENCES readers(id) ON DELETE CASCADE
);

INSERT INTO readers (name, phone, address) VALUES
('Анна Коваль', '0501112233', 'Львів'),
('Олег Мельник', '0672223344', 'Луцьк'),
('Ірина Бондар', '0633334455', 'Володимир'),
('Максим Шевчук', '0664445566', 'Рівне'),
('Софія Ткач', '0985556677', 'Тернопіль'),
('Андрій Лисенко', '0936667788', 'Київ');

INSERT INTO loans (book_id, reader_id, loan_date, return_date) VALUES
(1, 1, '2026-09-01', '2026-09-10'),
(2, 2, '2026-09-02', '2026-09-12'),
(3, 3, '2026-09-03', '2026-09-13'),
(4, 4, '2026-09-04', '2026-09-14'),
(5, 5, '2026-09-05', '2026-09-15'),
(6, 6, '2026-09-06', NULL),
(1, 3, '2026-09-07', NULL),
(2, 4, '2026-09-08', NULL),
(3, 5, '2026-09-09', NULL),
(4, 1, '2026-09-10', NULL);

SELECT * FROM readers;
SELECT * FROM loans;