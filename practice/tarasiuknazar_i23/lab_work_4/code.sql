CREATE TABLE "cars" (
	"id"	INTEGER,
	"brand"	TEXT,
	"model"	TEXT,
	"year"	INTEGER,
	"price"	REAL,
	"status"	TEXT,
	PRIMARY KEY("id")
);

CREATE TABLE clients (
    id INTEGER PRIMARY KEY,
    name TEXT
);

CREATE TABLE sales(
	id INTEGER PRIMARY KEY,
	car_id INTEGER,
	client_id INTEGER,
	
	FOREIGN KEY (car_id),
		REFERENCES cars(id),
	FOREIGN KEY (client_id),
		REFERENCES clients(id),
);