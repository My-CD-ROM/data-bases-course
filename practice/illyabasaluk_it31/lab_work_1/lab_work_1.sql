CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT,
    author TEXT,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER
);

INSERT INTO books (title, author, publication_year, genre, copies_count) VALUES
('Кобзар', 'Тарас Шевченко', 1840, 'Поезія', 5),
('Тигролови', 'Іван Багряний', 1944, 'Роман', 3),
('Місто', 'Валерʼян Підмогильний', 1928, 'Роман', 4),
('Захар Беркут', 'Іван Франко', 1883, 'Історичний роман', 6),
('Лісова пісня', 'Леся Українка', 1911, 'Драма', 4),
('Чорна рада', 'Пантелеймон Куліш', 1857, 'Історичний роман', 2);