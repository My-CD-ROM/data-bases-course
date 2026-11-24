# Практика 15. Створення індексів та аналіз ефективності запитів

Драницький Павло, група ІТ-31, варіант 9 (Університет). Файли: `lab_work_15.sql`, `lab_work_15.db`. Фактова таблиця: `grades`.

## Завдання 1 (довідково). План до індексу

```
EXPLAIN QUERY PLAN SELECT * FROM grades WHERE student_id = 1;

QUERY PLAN
`--SCAN grades
```

## Завдання 2. Індекс на зовнішньому ключі

Створено `CREATE INDEX idx_grades_student ON grades(student_id);`. План того самого запиту:

```
QUERY PLAN
`--SEARCH grades USING INDEX idx_grades_student (student_id=?)
```

Замість `SCAN grades` (повний перегляд усіх рядків) з'явився `SEARCH ... USING INDEX idx_grades_student (student_id=?)`. SQLite тепер знаходить потрібні рядки за індексом, не переглядаючи всю таблицю.

## Завдання 3. Композитний індекс

Запит: `SELECT * FROM grades WHERE student_id = 1 AND subject_id = 2;`.

До композитного індексу (є лише `idx_grades_student`):

```
QUERY PLAN
`--SEARCH grades USING INDEX idx_grades_student (student_id=?)
```

Після `CREATE INDEX idx_grades_student_subject ON grades(student_id, subject_id);`:

```
QUERY PLAN
`--SEARCH grades USING INDEX idx_grades_student_subject (student_id=? AND subject_id=?)
```

Різниця в тому, скільки умов використовує індекс. Одноколонковий індекс звужує вибірку лише за `student_id=?`, а умову `subject_id = 2` SQLite потім перевіряє окремо для кожного знайденого рядка. Композитний індекс використовує обидві умови (`student_id=? AND subject_id=?`) і одразу вказує на потрібні рядки.

## Завдання 4. Індекс і ORDER BY

Запит: `SELECT * FROM grades ORDER BY exam_date;`.

До індексу:

```
QUERY PLAN
|--SCAN grades
`--USE TEMP B-TREE FOR ORDER BY
```

Після `CREATE INDEX idx_grades_date ON grades(exam_date);`:

```
QUERY PLAN
`--SCAN grades USING INDEX idx_grades_date
```

Із плану зник крок `USE TEMP B-TREE FOR ORDER BY`. Раніше SQLite спершу читав усі рядки, а потім сортував їх у тимчасовій структурі. Тепер рядки читаються в порядку індексу, який уже відсортований за `exam_date`, тому окреме сортування не потрібне.

## Завдання 5. DROP INDEX

Виконано `DROP INDEX idx_grades_student;` і повторено запит із Завдання 1:

```
QUERY PLAN
`--SEARCH grades USING INDEX idx_grades_student_subject (student_id=?)
```

План **не повернувся до `SCAN`**: запит використовує інший наявний індекс, композитний `idx_grades_student_subject`, бо його перша колонка `student_id` збігається з умовою запиту. Для запиту лише за `student_id` окремий одноколонковий індекс виявився зайвим.

Перевірка видалення: `SELECT name, tbl_name FROM sqlite_master WHERE type = 'index';` повернув `idx_grades_date`, `idx_grades_student_subject` і службовий `sqlite_autoindex_subjects_1`. Індексу `idx_grades_student` у списку немає (`COUNT(*)` за його назвою дорівнює 0).

## Відповіді на контрольні питання

1. **Чому `EXPLAIN QUERY PLAN` показує план, а не результат, і навіщо перевіряти план окремо?** Команда не виконує запит, а лише показує, як SQLite збирається його виконувати (скан чи пошук за індексом, чи потрібне сортування). Результат запиту однаковий з індексом і без нього, тож за результатом не видно, чи індекс використовується. Це видно тільки з плану. На малій таблиці різниця в часі непомітна, але зростає разом з обсягом даних.
2. **Чому індекс лише на першій колонці дає менший ефект, ніж композитний?** Одноколонковий індекс відбирає рядки лише за однією умовою, а другу SQLite перевіряє вже на знайдених рядках. Композитний індекс враховує обидві умови одразу й відбирає рядки точніше.
3. **Яка ціна індексу і чому не індексувати кожну колонку?** Індекс займає місце в базі. Він також сповільнює `INSERT`, `UPDATE` і `DELETE`, бо кожну зміну треба відобразити в усіх індексах таблиці. Тож індекси варто будувати лише на колонках, за якими справді фільтрують, з'єднують таблиці чи сортують.
