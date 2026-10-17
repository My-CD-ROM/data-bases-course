-- Практична робота №1
-- Варіант №1 — Бібліотека
-- Студентка: Марія Вовк
-- Група: І-23

CREATE TABLE books (
id INTEGER PRIMARY KEY,
title TEXT NOT NULL,
author TEXT NOT NULL,
publication_year INTEGER,
genre TEXT,
copies_count INTEGER
);

INSERT INTO books (title, author, publication_year, genre, copies_count) VALUES
('Кобзар', 'Тарас Шевченко', 1840, 'поезія', 8),
('Тигролови', 'Іван Багряний', 1944, 'роман', 5),
('Місто', 'Валер’ян Підмогильний', 1928, 'роман', 4),
('Захар Беркут', 'Іван Франко', 1883, 'історична повість', 6),
('Лісова пісня', 'Леся Українка', 1911, 'драма-феєрія', 7),
('Чорна рада', 'Пантелеймон Куліш', 1857, 'історичний роман', 3);

SELECT * FROM books;

-- Пояснення типів:
-- id INTEGER PRIMARY KEY — унікальний числовий ідентифікатор книги.
-- title TEXT — назва книги є текстовим значенням.
-- author TEXT — ім'я та прізвище автора є текстовим значенням.
-- publication_year INTEGER — рік видання є цілим числом.
-- genre TEXT — жанр книги є текстовим значенням.
-- copies_count INTEGER — кількість примірників є цілим числом.

-- SQLite використовує type affinity. Типи TEXT та INTEGER
-- обрано відповідно до характеру даних.