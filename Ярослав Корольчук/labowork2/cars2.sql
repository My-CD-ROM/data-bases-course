BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "cars2" (
	"id"	INTEGER,
	"name"	TEXT,
	"brand"	TEXT,
	"year"	INTEGER,
	"type"	TEXT,
	"price"	INTEGER,
	"pride"	TEXT,
	PRIMARY KEY("id")
);
INSERT INTO "cars2" VALUES (1,'Model X','Tesla',2022,'SUV',45000,NULL);
COMMIT;
