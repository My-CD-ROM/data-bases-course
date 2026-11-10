-- Практична 8. Варіант 9: університет / деканат.
-- Структура таблиць не змінюється.

-- Завдання 1. NULL демонструємо на nullable-полі таблиці-виміру,
-- оскільки grades порожня, а її поля NOT NULL.
UPDATE university SET first_name = NULL WHERE id = 7;
SELECT COUNT(*) AS total_rows, COUNT(first_name) AS rows_with_first_name
FROM university;
-- Результат: 7 та 6.

-- Завдання 2. Сума й середнє кредитів дисциплін.
SELECT SUM(credits) AS total_credits, AVG(credits) AS average_credits
FROM subjects;
-- Результат: 27 та 4.5.

-- Завдання 3. MIN/MAX текстової назви дисципліни.
SELECT MIN(title) AS alphabetically_first, MAX(title) AS alphabetically_last
FROM subjects;
-- Результат: 'Алгоритми та структури даних' та 'Операційні системи'.

-- Завдання 4. Кілька агрегатів над фактовою таблицею grades.
SELECT COUNT(*) AS total_grades, COUNT(grade) AS grades_filled,
       SUM(grade) AS grade_sum, AVG(grade) AS grade_average,
       MIN(grade) AS minimum_grade, MAX(grade) AS maximum_grade
FROM grades;
-- grades порожня: COUNT = 0, SUM/AVG/MIN/MAX = NULL.

-- Завдання 5. Агрегати з фільтром за групою.
SELECT COUNT(*) AS students_count, MIN(admission_year) AS earliest_admission,
       MAX(admission_year) AS latest_admission
FROM university
WHERE group_name = 'ІТ-21';
-- Результат: 3, 2021, 2021.

-- Контрольне питання 3: сума всіх NULL.
SELECT SUM(NULL) AS sum_of_all_null_values FROM subjects;
-- Результат: NULL.
