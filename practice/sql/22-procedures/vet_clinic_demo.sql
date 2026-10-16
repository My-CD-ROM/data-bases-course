-- База ветклініки для прикладів розділу «Теорія» Практики 22.
-- Виконайте файл в окремій порожній базі (наприклад, vet_demo), а не в базі свого варіанта.

DROP TABLE IF EXISTS visits, vets, animals, owners CASCADE;
CREATE TABLE owners (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    last_name TEXT NOT NULL,
    first_name TEXT NOT NULL,
    phone TEXT
);
CREATE TABLE animals (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    species TEXT NOT NULL,
    age INTEGER,
    status TEXT NOT NULL DEFAULT 'на обліку',
    owner_id INTEGER REFERENCES owners(id)
);
CREATE TABLE vets (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name TEXT NOT NULL,
    specialization TEXT
);
CREATE TABLE visits (
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    animal_id INTEGER NOT NULL REFERENCES animals(id),
    vet_id INTEGER NOT NULL REFERENCES vets(id),
    visit_date DATE NOT NULL,
    diagnosis TEXT
);
INSERT INTO owners (last_name, first_name, phone) VALUES
    ('Петренко', 'Ольга', '+380501112233'),
    ('Коваль', 'Андрій', '+380672223344'),
    ('Мельник', 'Ірина', '+380933334455');
INSERT INTO animals (name, species, age, status, owner_id) VALUES
    ('Мурка', 'кіт', 3, 'на обліку', 1),
    ('Барсик', 'кіт', 5, 'на обліку', 1),
    ('Рекс', 'собака', 7, 'на обліку', 2),
    ('Пушок', 'хом''як', 1, 'на обліку', 3);
INSERT INTO vets (name, specialization) VALUES
    ('Олена Бойко', 'терапевт'),
    ('Ігор Савчук', 'хірург');
INSERT INTO visits (animal_id, vet_id, visit_date, diagnosis) VALUES
    (1, 1, '2026-09-02', 'щеплення'),
    (3, 2, '2026-09-15', 'забій лапи'),
    (4, 1, '2026-10-01', 'огляд');
