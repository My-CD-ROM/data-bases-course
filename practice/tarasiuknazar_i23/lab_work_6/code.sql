1. UPDATE  sales SET client_id = 6 WHERE id = 6

2. UPDATE cars SET price = 6700 WHERE id = 4

3.	SELECT COUNT(*) AS sales_before
	FROM sales

	DELETE FROM sales WHERE id = 8

   	SELECT COUNT(*) AS sales_after
   	FROM sales;

4. Прогноз: зовнішній ключ sales.car_id → cars.id має дію ON DELETE NO ACTION. Оскільки на автомобіль з id = 5 посилаються рядки таблиці sales, спроба видалити цей автомобіль повинна бути відхилена. Пов'язані рядки таблиці sales повинні залишитися без змін.

	Execution finished with errors.
		Result: FOREIGN KEY constraint failed
		At line 1:
		DELETE FROM cars
		WHERE id = 5;