BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "memberships" (
	"int"	INTEGER,
	"type"	TEXT,
	"duration_days"	INTEGER,
	"price"	REAL,
	PRIMARY KEY("int")
);
INSERT INTO "memberships" VALUES (1,'Basic',30,500.0);
INSERT INTO "memberships" VALUES (2,'Standard',90,1200.0);
INSERT INTO "memberships" VALUES (3,'Premium',180,2200.0);
INSERT INTO "memberships" VALUES (4,'Vip',365,4000.0);
INSERT INTO "memberships" VALUES (5,'Student',30,350.0);
INSERT INTO "memberships" VALUES (6,'Weekend',7,200.0);
INSERT INTO "memberships" VALUES (7,'Family',90,1800.0);
INSERT INTO "memberships" VALUES (8,'First_visit',7,NULL);
COMMIT;
