CREATE TABLE feedbacks (
	id INTEGER PRIMARY KEY,
	product_id INTEGER NOT NULL,
	rate REAL CHECK (rate BETWEEN 0 AND 5),
	comment TEXT DEFAULT NULL,
	feedback_date TEXT NOT NULL,
	FOREIGN KEY (product_id) REFERENCES products (id)
)

INSERT INTO feedbacks (product_id, rate, comment, feedback_date) VALUES
	(1, 4.5, "Товар прийшов вчасно. Худі дуже сподобалось, хоча трохи завелике", "2026-09-01"),
	(1, 3, "Дуже довга доставка. Худі гарне", "2026-05-06"),
	(2, 2.5, "Кросівки виявилися дуже дорогими, хоча вони насправді стількох грошей не вартують. Добре, що доставка була швидкою", "2026-09-05"),
	(4, 4, "Купила чоловіку халат. Йому дуже сподобався. Єдиним мінусом була трохи довга доставка", "2025-11-21"),
	(5, 1.5, "За кепку з покемон 4000 тисячі це забагато. Хоча розумію, що Nintendo забирає багато грошей. Доставка була швидкою. Другу сподобалась кепка", "2026-06-07"),
	(6, 5, NULL, "2026-09-21"),
	(6, 4.7, "Сорочки прибули вчасно та мали гарний вигляд. Купила ще дві про запас. Рекомендую", "2026-10-02")

SELECT products.name, AVG(feedbacks.rate) AS "average rate"
FROM feedbacks
JOIN products ON feedbacks.product_id = products.id
GROUP BY products.id

SELECT products.name, AVG(feedbacks.rate) AS "average rate"
FROM feedbacks
JOIN products ON feedbacks.product_id = products.id
GROUP BY products.id
HAVING feedbacks.rate < 3

SELECT products.name, AVG(feedbacks.rate) AS "average rate"
FROM feedbacks
JOIN products ON feedbacks.product_id = products.id
WHERE feedbacks.feedback_date BETWEEN "2026-06-01" AND "2026-09-30"
GROUP BY products.id
HAVING feedbacks.rate < 3

INSERT INTO products (name, size, price, stock_quantity) VALUES
	("Блакитна сорочка", "M", 185.345, 57)

INSERT INTO feedbacks (product_id, rate, comment, feedback_date) VALUES
	(9, 1.5, "Неякісна сорочка, після першого прання зіпсувалась", "2026-09-14"),
	(9, 0, "Замість сорочки прийшла футболка. Як таке може бути?", "2026-08-26")

SELECT products.name, AVG(feedbacks.rate) AS "average rate"
FROM feedbacks
JOIN products ON feedbacks.product_id = products.id
GROUP BY products.id
HAVING feedbacks.rate < 3

SELECT products.name, AVG(feedbacks.rate) AS "average rate"
FROM feedbacks
JOIN products ON feedbacks.product_id = products.id
GROUP BY products.name
HAVING feedbacks.rate < 3