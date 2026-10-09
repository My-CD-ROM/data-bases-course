SELECT books.title, books.author, loans.loan_date, loans.return_date
FROM loans
JOIN books ON loans.book_id = books.id
ORDER BY loans.loan_date;

SELECT books.id, books.title
FROM books
LEFT JOIN loans ON loans.book_id = books.id
WHERE loans.id IS NULL;

SELECT books.id, books.title
FROM books
LEFT JOIN loans ON loans.book_id = books.id
WHERE loans.id IS NULL;

INSERT INTO books (title, author, publication_year, genre, copies_count)
VALUES ('Чорний обеліск', 'Еріх Марія Ремарк', 1956, 'роман', 1);

SELECT books.id, books.title
FROM books
LEFT JOIN loans ON loans.book_id = books.id
WHERE loans.id IS NULL;

SELECT COUNT(*) FROM books;
SELECT COUNT(*) FROM readers;
SELECT COUNT(*) FROM books, readers;

SELECT id, title FROM books ORDER BY id;

INSERT INTO books (title, author, publication_year, genre, copies_count) VALUES
    ('Відьмак. Останнє бажання', 'Анджей Сапковський', 1993, 'фентезі', 11),
    ('Гра престолів', 'Джордж Р. Р. Мартін', 1996, 'фентезі', 8),
    ('Ім''я вітру', 'Патрік Ротфусс', 2007, 'фентезі', 6),
    ('Дівчина з татуюванням дракона', 'Стіг Ларссон', 2005, 'детектив', 10),
    ('Вбивство у «Східному експресі»', 'Агата Крісті', 1934, 'детектив', 14),
    ('Мовчання ягнят', 'Томас Гарріс', 1988, 'детектив', 9),
    ('Кривавими слідами', 'Ксенія Циганчук', 2019, 'детектив', 8),
    ('Дружина мого чоловіка', 'Джейн Коррі', 2019, 'дарк-роман', 7),
    ('Ловець невинних душ', 'Донато Каррізі', 2019, 'детектив', 6),
    ('Можливо, завтра', 'Марися Нікітюк', 2019, 'дарк-роман', 5),
    ('А спадком буде смерть', 'Ганна Дичок', 2025, 'детектив', 9),
    ('Сага про Стрепета', 'Петро Лущик', 2025, 'детектив', 4),
    ('Вигнанець і грішниця', 'Андрій Кокотюха', 2025, 'детектив', 6),
    ('Холодне Поле', 'Сергій Синюк', 2025, 'дарк-роман', 5),
    ('Залишена', 'Оксана Ковальчук', 2025, 'дарк-роман', 7),
    ('Майстер і Маргарита', 'Михайло Булгаков', 1967, 'роман', 9),
    ('Гаррі Поттер і філософський камінь (2-й примірник)', 'Джоан Роулінг', 1997, 'фентезі', 20);
SELECT COUNT(*) FROM books;

SELECT books.id, books.title
FROM books
LEFT JOIN loans ON loans.book_id = books.id
WHERE loans.id IS NULL;