CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT,
    author TEXT,
    genre TEXT,
    publication_year INTEGER,
    copies_count INTEGER
);

INSERT INTO books (title, author, genre, publication_year, copies_count) VALUES
('Кобзар', 'Тарас Шевченко', 'Поезія', 1840, 5),
('Тигролови', 'Іван Багряний', 'Пригодницький роман', 1944, 3),
('Intermezzo', 'Михайло Коцюбинський', 'Новела', 1908, 2),
('Місто', 'Валер''ян Підмогильний', 'Урбаністичний роман', 1928, 4),
('Захар Беркут', 'Іван Франко', 'Історична повість', 1883, 6),
('Тіні забутих предків', 'Михайло Коцюбинський', 'Повість', 1911, 3);


SELECT name FROM sqlite_master WHERE type='table';

PRAGMA table_info(books);

SELECT * FROM books;
