CREATE TABLE books (
    id INTEGER PRIMARY KEY,
    title TEXT,
    author TEXT,
    publication_year INTEGER,
    genre TEXT,
    copies_count INTEGER
);

INSERT INTO books (title, author, publication_year, genre, copies_count) VALUES
('Кобзар', 'Тарас Шевченко', 1840, 'поезія', 5),
('Тигролови', 'Іван Багряний', 1944, 'роман', 4),
('Місто', 'Валер’ян Підмогильний', 1928, 'роман', 3),
('Лісова пісня', 'Леся Українка', 1911, 'драма', 6),
('Захар Беркут', 'Іван Франко', 1883, 'історична повість', 4),
('1984', 'Джордж Орвелл', 1949, 'антиутопія', 3);