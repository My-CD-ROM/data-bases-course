\# Практична робота 5



\## Обмеження цілісності даних: NOT NULL, UNIQUE, CHECK, DEFAULT



\### Мета роботи



Застосувати до бази даних обмеження цілісності `NOT NULL`, `UNIQUE`, `CHECK` та `DEFAULT`, перевірити їхню роботу під час операцій `INSERT` та `UPDATE`, а також визначити їхній бізнес-сенс.



\---



\## Завдання 1. Обмеження NOT NULL



Для таблиці `readers` було додано обмеження `NOT NULL` для поля `phone`.



Фінальна структура таблиці:



```sql

CREATE TABLE readers (

&#x20;   id INTEGER PRIMARY KEY,

&#x20;   name TEXT NOT NULL,

&#x20;   phone TEXT NOT NULL,

&#x20;   address TEXT

);

```



Для перевірки було виконано вставку запису без значення `phone`:



```sql

INSERT INTO readers (name, address)

VALUES ('Тестовий Читач', 'Львів');

```



Отримано помилку:



```text

NOT NULL constraint failed: readers.phone

```



\*\*Результат:\*\* обмеження `NOT NULL` не дозволяє залишити обов'язкове поле порожнім.





\---



\## Завдання 2. Обмеження UNIQUE



Для таблиці `books` було додано складене обмеження:



```sql

UNIQUE (title, author)

```



Фінальна структура на цьому етапі:



```sql

CREATE TABLE books (

&#x20;   id INTEGER PRIMARY KEY,

&#x20;   title TEXT NOT NULL,

&#x20;   author TEXT NOT NULL,

&#x20;   publication\_year INTEGER,

&#x20;   genre TEXT,

&#x20;   copies\_count INTEGER,

&#x20;   UNIQUE (title, author)

);

```



Для перевірки було виконано вставку дубліката назви та автора.



Отримано помилку:



```text

UNIQUE constraint failed: books.title, books.author

```



\*\*Результат:\*\* однакова комбінація назви книги та автора не може повторюватися.







\---



\## Завдання 3. Обмеження CHECK



Для поля `copies\_count` було встановлено правило:



```sql

CHECK (copies\_count >= 0)

```



Перевірка неправильного значення:



```sql

INSERT INTO books (title, author, publication\_year, genre, copies\_count)

VALUES ('Тестова книга', 'Тестовий Автор', 2026, 'Тест', -1);

```



Отримано помилку:



```text

CHECK constraint failed: copies\_count >= 0

```



Після цього було виконано коректну вставку:



```sql

INSERT INTO books (title, author, publication\_year, genre, copies\_count)

VALUES ('Тестова книга 2', 'Тестовий Автор 2', 2026, 'Тест', 0);

```



Результат перевірки:



```text

Тестова книга 2|Тестовий Автор 2|0

```



\*\*Результат:\*\* `CHECK` не дозволяє записати від'ємну кількість примірників.







\---



\## Завдання 4. Обмеження DEFAULT



Для поля `copies\_count` було встановлено значення за замовчуванням:



```sql

DEFAULT 1

```



Фінальна структура таблиці `books`:



```sql

CREATE TABLE books (

&#x20;   id INTEGER PRIMARY KEY,

&#x20;   title TEXT NOT NULL,

&#x20;   author TEXT NOT NULL,

&#x20;   publication\_year INTEGER,

&#x20;   genre TEXT,

&#x20;   copies\_count INTEGER DEFAULT 1 CHECK (copies\_count >= 0),

&#x20;   UNIQUE (title, author)

);

```



Було виконано вставку без зазначення `copies\_count`:



```sql

INSERT INTO books (title, author, publication\_year, genre)

VALUES ('Книга за замовчуванням', 'Тестовий Автор', 2026, 'Тест');

```



Перевірка:



```sql

SELECT title, author, copies\_count

FROM books

WHERE title = 'Книга за замовчуванням';

```



Результат:



```text

Книга за замовчуванням|Тестовий Автор|1

```



\*\*Результат:\*\* якщо значення `copies\_count` не вказане, автоматично встановлюється `1`.





\## Завдання 5. Перевірка обмеження через UPDATE



Для перевірки було виконано:



```sql

UPDATE books

SET copies\_count = -1

WHERE id = (SELECT MIN(id) FROM books);

```



Отримано помилку:



```text

CHECK constraint failed: copies\_count >= 0

```



Обмеження цілісності діють як під час `INSERT`, так і під час `UPDATE`, тому некоректне значення не можна встановити жодною з цих операцій.





\---

\## Завдання 6. Бізнес-сенс обмежень



| Обмеження  | Бізнес-сенс                                                                                            |

| ---------- | ------------------------------------------------------------------------------------------------------ |

| `NOT NULL` | Забезпечує обов'язкове заповнення важливого поля та запобігає появі неповних записів.                  |

| `UNIQUE`   | Не допускає дублювання значень або комбінацій значень, які повинні бути унікальними.                   |

| `CHECK`    | Гарантує відповідність даних заданому правилу, наприклад кількість примірників не може бути від'ємною. |

| `DEFAULT`  | Автоматично встановлює стандартне значення, якщо користувач його не вказав.                            |



\---



\## Висновок



Під час практичної роботи було застосовано чотири обмеження цілісності даних: `NOT NULL`, `UNIQUE`, `CHECK` та `DEFAULT`. Для кожного обмеження було проведено практичну перевірку. Було встановлено, що обмеження дозволяють контролювати правильність даних та запобігати внесенню некоректної або неповної інформації до бази даних.



