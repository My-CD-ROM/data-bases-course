BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "movies" (
	"id"	INTEGER,
	"title"	TEXT NOT NULL,
	"genre"	TEXT NOT NULL,
	"duration_min"	INTEGER NOT NULL,
	"year"	INTEGER NOT NULL,
	"age_rating"	INTEGER NOT NULL,
	PRIMARY KEY("id")
);
INSERT INTO "movies" VALUES (1,'Інтерстеллар','фантастика',169,2014,12);
INSERT INTO "movies" VALUES (2,'Початок','фантастика',148,2010,12);
INSERT INTO "movies" VALUES (3,'Титанік','драма',195,1997,12);
INSERT INTO "movies" VALUES (4,'Гаррі Поттер і філософський камінь','фентезі',152,2001,6);
INSERT INTO "movies" VALUES (5,'Король Лев','мультфільм',88,1994,6);
INSERT INTO "movies" VALUES (6,'Матриця','фантастика',136,1999,16);
COMMIT;
