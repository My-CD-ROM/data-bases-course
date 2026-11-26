EXPLAIN QUERY PLAN
SELECT * FROM visits WHERE client_id = 2;
-- QUERY PLAN: `--SCAN visits

CREATE INDEX idx_visits_client ON visits(client_id);
EXPLAIN QUERY PLAN
SELECT * FROM visits WHERE client_id = 2;
-- QUERY PLAN: `--SEARCH visits USING INDEX idx_visits_client (client_id=?)

EXPLAIN QUERY PLAN
SELECT * FROM visits WHERE client_id = 2 AND duration_minutes = 60;
-- QUERY PLAN: `--SEARCH visits USING INDEX idx_visits_client (client_id=?)
CREATE INDEX idx_visits_client_duration
ON visits(client_id, duration_minutes);
EXPLAIN QUERY PLAN
SELECT * FROM visits WHERE client_id = 2 AND duration_minutes = 60;
-- QUERY PLAN: `--SEARCH visits USING INDEX idx_visits_client_duration (client_id=? AND duration_minutes=?)

EXPLAIN QUERY PLAN
SELECT visit_date FROM visits ORDER BY visit_date;
-- QUERY PLAN до індексу:
-- |--SCAN visits
-- `--USE TEMP B-TREE FOR ORDER BY
CREATE INDEX idx_visits_date ON visits(visit_date);
EXPLAIN QUERY PLAN
SELECT visit_date FROM visits ORDER BY visit_date;
-- QUERY PLAN після індексу: `--SCAN visits USING COVERING INDEX idx_visits_date

DROP INDEX idx_visits_client;
EXPLAIN QUERY PLAN
SELECT * FROM visits WHERE client_id = 2;
-- QUERY PLAN: `--SEARCH visits USING INDEX idx_visits_client_duration (client_id=?)
SELECT name, sql FROM sqlite_master
WHERE type = 'index' AND name = 'idx_visits_client';

SELECT name, sql FROM sqlite_master
WHERE type = 'index' AND name NOT LIKE 'sqlite_%' ORDER BY name;
