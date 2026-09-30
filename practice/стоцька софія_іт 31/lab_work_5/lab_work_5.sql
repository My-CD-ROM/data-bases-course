BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "medicines" (
	"id"	INTEGER,
	"name"	TEXT,
	"manufacturer"	TEXT,
	"form"	TEXT,
	"price"	REAL CHECK("price" > 0),
	"stock_quantity"	INTEGER DEFAULT 0,
	PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "suppliers" (
	"id"	INTEGER,
	"name"	TEXT NOT NULL,
	"contact_person"	TEXT,
	"phone"	TEXT UNIQUE,
	"city"	TEXT,
	PRIMARY KEY("id")
);
INSERT INTO "medicines" VALUES (1,'Paracetamol','Farmak','таблетки',45.5,120);
INSERT INTO "medicines" VALUES (2,'Ibuprofen','Darnytsia','таблетки',68.0,85);
INSERT INTO "medicines" VALUES (3,'Validol','Arterium','таблетки',32.75,60);
INSERT INTO "medicines" VALUES (4,'Ambroxol','Farmak','сироп',95.2,40);
INSERT INTO "medicines" VALUES (5,'Chlorhexidine','Darnytsia','розчин',38.9,75);
INSERT INTO "medicines" VALUES (6,'Nurofen','Reckitt','капсули',125.0,35);
INSERT INTO "medicines" VALUES (7,'Test Medicine','Test','таблетки',10.0,5);
INSERT INTO "medicines" VALUES (8,'Default Medicine','Test','таблетки',25.5,0);
INSERT INTO "suppliers" VALUES (1,'Farmak','Іван Петренко','0501111111','Київ');
INSERT INTO "suppliers" VALUES (2,'Darnytsia','Олена Коваль','0502222222','Київ');
INSERT INTO "suppliers" VALUES (3,'Arterium','Андрій Мельник','0503333333','Київ');
INSERT INTO "suppliers" VALUES (4,'Zentiva','Марія Бондар','0504444444','Прага');
INSERT INTO "suppliers" VALUES (5,'Teva','Олексій Шевченко','0505555555','Київ');
INSERT INTO "suppliers" VALUES (6,'Berlin-Chemie','Наталія Лисенко','0506666666','Берлін');
COMMIT;
