.bail off
.headers on
.mode column
PRAGMA foreign_keys = ON;

SELECT COUNT(*) AS before_count FROM memberships;

CREATE TABLE memberships_staging (
    type TEXT,
    duration_days INTEGER,
    price REAL
);
.mode csv
.import --skip 1 v7_new_rows.csv memberships_staging
.mode column
SELECT * FROM memberships_staging;
SELECT COUNT(*) AS staging_count FROM memberships_staging;

INSERT INTO memberships (type, duration_days, price)
SELECT type, duration_days, price FROM memberships_staging;
DROP TABLE memberships_staging;
SELECT COUNT(*) AS after_count FROM memberships;

SELECT id, type, duration_days, price FROM memberships
WHERE type IN (
    'fitness basic', 'йога безлімит', 'кросфіт', 'групові заняття',
    'дитячий абонемент', 'персональний тренер (10 занять)', 'басейн', 'корпоративний'
)
ORDER BY id;

.open lab_work_16_test.db
PRAGMA foreign_keys = ON;
.mode csv
.import --skip 1 v7_new_rows.csv memberships
.mode column
SELECT COUNT(*) AS test_membership_count FROM memberships;

.open lab_work_16.db
SELECT COUNT(*) AS final_membership_count FROM memberships;
SELECT id, type, duration_days, price FROM memberships ORDER BY id;
SELECT name FROM sqlite_master WHERE type = 'table' AND name = 'memberships_staging';
