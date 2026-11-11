-- Практична робота №11. Комбіновані завдання з групуванням та відбором даних
-- Варіант 3 — Cinema
-- База: movies / viewers / tickets
-- Нова таблиця зв'язку: watchlist (список фільмів, які глядачі планують подивитися)
--
-- Дослідницьке питання:
-- Які фільми мають найбільший попит у списках бажаного та які глядачі
-- планують найбільшу кількість фільмів?
--
-- УВАГА: запускайте на копії робочої бази lab_work_11.db.
-- Скрипт можна повторно запускати: INSERT OR IGNORE та перевірки NOT EXISTS
-- не створюють повторні записи watchlist або повторний фільм-двійник.

PRAGMA foreign_keys = ON;

-- ============================================================
-- Завдання 1. Створення нової таблиці зв'язку багато-до-багатьох
-- ============================================================
CREATE TABLE IF NOT EXISTS watchlist (
    id INTEGER PRIMARY KEY,
    movie_id INTEGER NOT NULL
        REFERENCES movies(id) ON DELETE CASCADE,
    viewer_id INTEGER NOT NULL
        REFERENCES viewers(id) ON DELETE CASCADE,
    added_date TEXT NOT NULL
        CHECK (
            length(added_date) = 10
            AND added_date GLOB '[0-9][0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9]'
        ),
    priority INTEGER NOT NULL DEFAULT 3
        CHECK (priority BETWEEN 1 AND 5),
    status TEXT NOT NULL DEFAULT 'planned'
        CHECK (status IN ('planned', 'watched', 'removed')),
    UNIQUE (movie_id, viewer_id)
);

-- 8 реалістичних записів. Утворюються групи різного розміру
-- і за movie_id, і за viewer_id. Фільми з id 5 та 6 не матимуть watchlist.
INSERT OR IGNORE INTO watchlist
    (movie_id, viewer_id, added_date, priority, status)
VALUES
    (1, 1, '2026-10-01', 5, 'planned'),
    (1, 2, '2026-10-02', 4, 'planned'),
    (1, 3, '2026-10-03', 5, 'planned'),
    (2, 1, '2026-10-04', 4, 'planned'),
    (2, 2, '2026-10-05', 3, 'planned'),
    (3, 1, '2026-10-06', 3, 'planned'),
    (3, 4, '2026-10-07', 5, 'planned'),
    (4, 3, '2026-10-08', 4, 'planned');

-- Перевірка створених записів:
SELECT
    w.id,
    m.title AS movie,
    v.last_name || ' ' || v.first_name AS viewer,
    w.added_date,
    w.priority,
    w.status
FROM watchlist AS w
JOIN movies AS m ON m.id = w.movie_id
JOIN viewers AS v ON v.id = w.viewer_id
ORDER BY w.id;

-- Результат:
-- 1 | Interstellar | Ковальчук Анна | 2026-10-01 | 5 | planned
-- 2 | Interstellar | Шевченко Максим | 2026-10-02 | 4 | planned
-- 3 | Interstellar | Мельник Олена | 2026-10-03 | 5 | planned
-- 4 | Inception    | Ковальчук Анна | 2026-10-04 | 4 | planned
-- 5 | Inception    | Шевченко Максим | 2026-10-05 | 3 | planned
-- 6 | Titanic      | Ковальчук Анна | 2026-10-06 | 3 | planned
-- 7 | Titanic      | Бондар Ігор     | 2026-10-07 | 5 | planned
-- 8 | Harry Potter and the Philosopher's Stone | Мельник Олена | 2026-10-08 | 4 | planned

-- ============================================================
-- Завдання 2. JOIN + GROUP BY за фільмом
-- Скільки глядачів додали кожен фільм до списку бажаного?
-- ============================================================
SELECT
    m.id,
    m.title,
    COUNT(w.id) AS interested_viewers
FROM movies AS m
INNER JOIN watchlist AS w ON w.movie_id = m.id
GROUP BY m.id
ORDER BY m.id;

-- Результат:
-- 1 | Interstellar | 3
-- 2 | Inception | 2
-- 3 | Titanic | 2
-- 4 | Harry Potter and the Philosopher's Stone | 1

-- Друга перспектива варіанта Cinema: GROUP BY за глядачем.
-- Скільки фільмів запланував кожен глядач?
SELECT
    v.id,
    v.last_name || ' ' || v.first_name AS viewer,
    COUNT(w.id) AS planned_movies
FROM viewers AS v
INNER JOIN watchlist AS w ON w.viewer_id = v.id
GROUP BY v.id
ORDER BY v.id;

-- Результат:
-- 1 | Ковальчук Анна | 3
-- 2 | Шевченко Максим | 2
-- 3 | Мельник Олена | 2
-- 4 | Бондар Ігор | 1

-- ============================================================
-- Завдання 3. HAVING COUNT за фільмом і за глядачем
-- Поріг: не менше двох записів у групі.
-- ============================================================
SELECT
    m.id,
    m.title,
    COUNT(w.id) AS interested_viewers
FROM movies AS m
INNER JOIN watchlist AS w ON w.movie_id = m.id
GROUP BY m.id
HAVING COUNT(w.id) >= 2
ORDER BY m.id;

-- Результат:
-- 1 | Interstellar | 3
-- 2 | Inception | 2
-- 3 | Titanic | 2

SELECT
    v.id,
    v.last_name || ' ' || v.first_name AS viewer,
    COUNT(w.id) AS planned_movies
FROM viewers AS v
INNER JOIN watchlist AS w ON w.viewer_id = v.id
GROUP BY v.id
HAVING COUNT(w.id) >= 2
ORDER BY v.id;

-- Результат:
-- 1 | Ковальчук Анна | 3
-- 2 | Шевченко Максим | 2
-- 3 | Мельник Олена | 2

-- ============================================================
-- Завдання 4. WHERE + JOIN + GROUP BY + HAVING
-- Беремо лише записи, додані з 4 жовтня 2026 року.
-- Залишаємо фільми, які додали щонайменше двоє глядачів.
-- ============================================================
SELECT
    m.id,
    m.title,
    COUNT(w.id) AS interested_viewers
FROM movies AS m
INNER JOIN watchlist AS w ON w.movie_id = m.id
WHERE w.added_date >= '2026-10-04'
GROUP BY m.id
HAVING COUNT(w.id) >= 2
ORDER BY m.id;

-- Результат:
-- 2 | Inception | 2
-- 3 | Titanic | 2

-- ============================================================
-- Завдання 5а. Експеримент: однакова назва, різні id
-- Додаємо фільм-двійник Interstellar і два записи watchlist до нього.
-- ============================================================
INSERT INTO movies (title, genre, duration_min, year, age_rating)
SELECT title, genre, duration_min, year, age_rating
FROM movies
WHERE id = 1
  AND NOT EXISTS (
      SELECT 1 FROM movies
      WHERE title = 'Interstellar' AND id <> 1
  );

-- Два глядачі додають саме новий запис-двійник Interstellar.
INSERT OR IGNORE INTO watchlist
    (movie_id, viewer_id, added_date, priority, status)
SELECT m.id, 2, '2026-10-09', 5, 'planned'
FROM movies AS m
WHERE m.title = 'Interstellar'
  AND m.id <> (SELECT MIN(id) FROM movies WHERE title = 'Interstellar')
  AND NOT EXISTS (
      SELECT 1 FROM watchlist AS w
      WHERE w.movie_id = m.id AND w.viewer_id = 2
  );

INSERT OR IGNORE INTO watchlist
    (movie_id, viewer_id, added_date, priority, status)
SELECT m.id, 4, '2026-10-10', 4, 'planned'
FROM movies AS m
WHERE m.title = 'Interstellar'
  AND m.id <> (SELECT MIN(id) FROM movies WHERE title = 'Interstellar')
  AND NOT EXISTS (
      SELECT 1 FROM watchlist AS w
      WHERE w.movie_id = m.id AND w.viewer_id = 4
  );

-- Варіант 1: GROUP BY за id — два фільми з однаковою назвою окремо.
SELECT
    m.id,
    m.title,
    COUNT(w.id) AS interested_viewers
FROM movies AS m
JOIN watchlist AS w ON w.movie_id = m.id
GROUP BY m.id
HAVING COUNT(w.id) >= 2
ORDER BY m.id;

-- Результат:
-- 1 | Interstellar | 3
-- 2 | Inception | 2
-- 3 | Titanic | 2
-- 7 | Interstellar | 2

-- Варіант 2: GROUP BY за title — однакові назви об'єднуються.
SELECT
    m.title,
    COUNT(w.id) AS interested_viewers
FROM movies AS m
JOIN watchlist AS w ON w.movie_id = m.id
GROUP BY m.title
HAVING COUNT(w.id) >= 2
ORDER BY m.title;

-- Результат:
-- Inception | 2
-- Interstellar | 5
-- Titanic | 2

-- ============================================================
-- Завдання 5б. Заміна INNER JOIN на LEFT JOIN у запиті Завдання 4
-- ============================================================
SELECT
    m.id,
    m.title,
    COUNT(w.id) AS interested_viewers
FROM movies AS m
LEFT JOIN watchlist AS w ON w.movie_id = m.id
WHERE w.added_date >= '2026-10-04'
GROUP BY m.id
HAVING COUNT(w.id) >= 2
ORDER BY m.id;

-- Результат після експерименту з фільмом-двійником:
-- 2 | Inception | 2
-- 3 | Titanic | 2
-- 7 | Interstellar | 2

-- Порівняння з INNER JOIN дає ті самі рядки:
-- WHERE відкидає рядки без watchlist (added_date для них NULL),
-- а HAVING COUNT(w.id) >= 2 додатково відкидає групи з 0 або 1 записом.

-- Перевірка, що фільми без watchlist існують:
SELECT m.id, m.title
FROM movies AS m
LEFT JOIN watchlist AS w ON w.movie_id = m.id
WHERE w.id IS NULL
ORDER BY m.id;

-- Результат:
-- 5 | Lion King
-- 6 | Matrix

-- Кінець Практичної роботи №11.
