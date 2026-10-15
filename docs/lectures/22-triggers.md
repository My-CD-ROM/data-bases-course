# Лекція 22. Тригери (Triggers) у PostgreSQL

*Функції (Лекція 20) і процедури (Лекція 21) виконуються, коли їх
явно ВИКЛИКАЄ хтось — `SELECT` чи `CALL`. Але іноді потрібно, щоб дія
відбувалась автоматично, сама, щоразу коли в таблиці щось змінюється —
без жодного окремого викову. Для цього в PostgreSQL є **тригер**:
функція, яка виконується сама, "прив'язана" до `INSERT`/`UPDATE`/
`DELETE` конкретної таблиці.*

## 1. Функція-тригер: RETURNS TRIGGER, NEW і OLD

```sql
CREATE OR REPLACE FUNCTION log_status_change() RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO animal_log (animal_id, action, old_status, new_status)
        VALUES (NEW.id, 'INSERT', NULL, NEW.status);
    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO animal_log (animal_id, action, old_status, new_status)
        VALUES (NEW.id, 'UPDATE', OLD.status, NEW.status);
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
```

Тригер завжди складається з двох частин: спеціальної функції, що
повертає тип `TRIGGER` (а не звичайний тип, як у Лекції 20), і самого
`CREATE TRIGGER` (розділ 2), що прив'язує цю функцію до таблиці.
Усередині функції-тригера доступні спеціальні змінні: `NEW` — рядок
ПІСЛЯ зміни (для `INSERT`/`UPDATE`), `OLD` — рядок ДО зміни (для
`UPDATE`/`DELETE`), і `TG_OP` — текст типу операції (`'INSERT'`,
`'UPDATE'`, `'DELETE'`), що дозволяє одній функції обробляти кілька
видів подій по-різному.

## 2. CREATE TRIGGER — прив'язка функції до таблиці

```sql
CREATE TRIGGER trg_log_status
AFTER INSERT OR UPDATE ON animals
FOR EACH ROW
EXECUTE FUNCTION log_status_change();
```

`AFTER INSERT OR UPDATE ON таблиця FOR EACH ROW EXECUTE FUNCTION
ім'я_функції();` — тригер спрацьовує ПІСЛЯ (`AFTER`) кожного
(`FOR EACH ROW`) `INSERT` чи `UPDATE` над таблицею `animals`.
Перевірено: після `INSERT` нового рядка в `animal_log` автоматично
з'являється запис `('INSERT', NULL, 'на обліку')`, а після подальшого
`UPDATE` статусу — ще один запис `('UPDATE', 'на обліку', 'вибув')`
— без жодного окремого виклику, лише завдяки самому факту зміни
таблиці `animals`.

## 3. BEFORE-тригер: перевірка й блокування операції

```sql
CREATE OR REPLACE FUNCTION prevent_negative_age() RETURNS TRIGGER AS $$
BEGIN
    IF NEW.age < 0 THEN
        RAISE EXCEPTION 'Вік не може бути негативним: %', NEW.age;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_check_age
BEFORE INSERT OR UPDATE ON animals
FOR EACH ROW
EXECUTE FUNCTION prevent_negative_age();
```

```sql
INSERT INTO animals (name, age, status) VALUES ('Помилка', -3, 'на обліку');
```

```text
ERROR: Вік не може бути негативним: -3
```

`BEFORE` (замість `AFTER`) означає: тригер спрацьовує ДО того, як
зміна фізично застосується — і якщо функція-тригер викликає `RAISE
EXCEPTION`, сама операція `INSERT`/`UPDATE` скасовується цілком,
рядок не потрапляє в таблицю. Перевірено: спроба вставити тварину з
від'ємним віком заблокована — кількість рядків у таблиці не зросла.
Це схоже на `CHECK` (Лекція 5), але потужніше: тригер може перевіряти
й складнішу логіку, що зачіпає кілька колонок чи навіть інші таблиці,
а не лише один вираз над однією колонкою.

## 4. AFTER проти BEFORE — коли яке

`BEFORE` використовують для валідації й можливої відмови (як у
розділі 3) чи для модифікації самого значення `NEW` перед записом.
`AFTER` використовують, коли зміна вже точно відбулась і потрібна
похідна дія — типово, логування (розділ 2) чи оновлення пов'язаних
даних в іншій таблиці. Обидва — `FOR EACH ROW` у прикладах цієї
лекції: тригер спрацьовує окремо для КОЖНОГО зміненого рядка, а не
один раз на весь запит.

## Підсумок

- Тригер = функція, що повертає `TRIGGER` (зі спеціальними змінними
  `NEW`/`OLD`/`TG_OP`) + `CREATE TRIGGER`, що прив'язує цю функцію до
  `INSERT`/`UPDATE`/`DELETE` конкретної таблиці.
- `AFTER`-тригер спрацьовує після зміни — типово для логування чи
  похідних дій; `BEFORE`-тригер спрацьовує до зміни й може заблокувати
  операцію через `RAISE EXCEPTION`, якщо дані не проходять перевірку.
- `FOR EACH ROW` означає: тригер виконується окремо для кожного
  зміненого рядка.
- Тригер автоматизує реакцію на зміну таблиці — на відміну від функцій
  і процедур (Лекції 20-21), його ніхто явно не викликає, він
  спрацьовує сам.

Цією лекцією завершується Модуль 4 і весь курс: від першого `CREATE
TABLE` у SQLite (Лекція 1) до автоматичних тригерів у PostgreSQL — та
сама трьохтаблична схема вашого варіанта пройшла через увесь шлях.

**Практика до цієї лекції:** [Практика 20. Реалізація тригерів](../practice/20-triggers.md)
