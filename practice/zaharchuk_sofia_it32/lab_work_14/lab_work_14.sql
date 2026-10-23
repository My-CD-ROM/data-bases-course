PRAGMA foreign_keys = ON;

-- Завдання 1: атомарна пара INSERT + UPDATE
BEGIN;
INSERT INTO bookings (room_id, guest_id, check_in_date, check_out_date) VALUES (7, 2, '2026-10-01', '2026-10-05');
UPDATE rooms SET status = 'зайнятий' WHERE id = 7;
COMMIT;
SELECT id, type, status FROM rooms WHERE id = 7;

-- Завдання 2: ROLLBACK
BEGIN;
INSERT INTO bookings (room_id, guest_id, check_in_date, check_out_date) VALUES (6, 3, '2026-10-10', '2026-10-12');
UPDATE rooms SET status = 'зайнятий' WHERE id = 6;
ROLLBACK;
SELECT id, status FROM rooms WHERE id = 6;

-- Завдання 3: власна зміна видна до COMMIT
BEGIN;
UPDATE rooms SET status = 'на прибиранні' WHERE id = 6;
SELECT id, type, status FROM rooms WHERE id = 6;
ROLLBACK;

-- Завдання 4: помилка всередині транзакції
BEGIN;
UPDATE rooms SET status = 'на прибиранні' WHERE id = 5;
INSERT INTO guests (last_name, first_name, email, phone) VALUES ('Тест', 'Тест', 'kovalenko.o@example.com', '0670000000');
-- Runtime error: UNIQUE constraint failed: guests.email (19)
SELECT id, status FROM rooms WHERE id = 5;
ROLLBACK;
SELECT id, status FROM rooms WHERE id = 5;

-- Завдання 5: COMMIT після помилки
BEGIN;
UPDATE rooms SET status = 'на прибиранні' WHERE id = 5;
INSERT INTO guests (last_name, first_name, email, phone) VALUES ('Тест', 'Тест', 'kovalenko.o@example.com', '0670000000');
-- Runtime error: UNIQUE constraint failed: guests.email (19)
COMMIT;
SELECT id, status FROM rooms WHERE id = 5;
-- результат: на прибиранні (UPDATE зафіксовано, INSERT відхилено)
UPDATE rooms SET status = 'зайнятий' WHERE id = 5;
