-- Завдання 1: план до індексу
EXPLAIN QUERY PLAN SELECT * FROM bookings WHERE room_id = 3;
-- SCAN bookings

-- Завдання 2: індекс на зовнішньому ключі
CREATE INDEX idx_bookings_room ON bookings(room_id);
EXPLAIN QUERY PLAN SELECT * FROM bookings WHERE room_id = 3;
-- SEARCH bookings USING INDEX idx_bookings_room (room_id=?)

-- Завдання 3: композитний індекс
EXPLAIN QUERY PLAN SELECT * FROM bookings WHERE room_id = 3 AND guest_id = 4;
-- SEARCH bookings USING INDEX idx_bookings_room (room_id=?)
CREATE INDEX idx_bookings_room_guest ON bookings(room_id, guest_id);
EXPLAIN QUERY PLAN SELECT * FROM bookings WHERE room_id = 3 AND guest_id = 4;
-- SEARCH bookings USING INDEX idx_bookings_room_guest (room_id=? AND guest_id=?)

-- Завдання 4: індекс і ORDER BY
EXPLAIN QUERY PLAN SELECT * FROM bookings ORDER BY check_in_date;
-- SCAN bookings + USE TEMP B-TREE FOR ORDER BY
CREATE INDEX idx_bookings_checkin ON bookings(check_in_date);
EXPLAIN QUERY PLAN SELECT * FROM bookings ORDER BY check_in_date;
-- SCAN bookings USING INDEX idx_bookings_checkin

-- Завдання 5: DROP INDEX
DROP INDEX idx_bookings_room;
EXPLAIN QUERY PLAN SELECT * FROM bookings WHERE room_id = 3;
-- SEARCH bookings USING INDEX idx_bookings_room_guest (room_id=?)
SELECT name, tbl_name FROM sqlite_master WHERE type = 'index';
