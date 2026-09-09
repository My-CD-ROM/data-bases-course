CREATE TABLE movies (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT NOT NULL,
    genre TEXT NOT NULL,
    duration INTEGER NOT NULL,
    release_year INTEGER NOT NULL,
    ticket_price REAL NOT NULL
);

INSERT INTO movies (title, genre, duration, release_year, ticket_price) VALUES
('Interstellar', 'Фантастика', 169, 2014, 220.00),
('Avatar', 'Фантастика', 162, 2009, 200.00),
('Titanic', 'Драма', 195, 1997, 180.00),
('Joker', 'Трилер', 122, 2019, 210.00),
('Dune', 'Фантастика', 155, 2021, 230.00);

SELECT * FROM movies;
