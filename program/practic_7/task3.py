def print_table(subjects):
    print(f"{'#':<3}{'Subject':<16}{'Pairs':<7}{'Grade':>5}")
    for i, (title, pairs, grade) in enumerate(subjects, start=1):
        print(f"{i:<3}{title:<16}{pairs:<7}{grade:>5}")


def get_total_pairs(subjects):
    return sum(pairs for title, pairs, grade in subjects)


def get_max_pairs_subject(subjects):
    return max(subjects, key=lambda s: s[1])


def get_weakest_subject(subjects):
    return min(subjects, key=lambda s: s[2])


def print_histogram(subjects):
    for title, pairs, grade in subjects:
        print(f"{title}: {'#' * grade}")


def retake_weakest_subject(subjects):
    weakest = get_weakest_subject(subjects)
    title, pairs, old_grade = weakest

    new_grade = min(12, old_grade + 2)

    index = subjects.index(weakest)
    subjects[index] = (title, pairs, new_grade)

    print(f"Retake: {title} {old_grade} -> {new_grade}")


def main():
    print("Batura Karina, IT-31")

    subjects = [
        ("Programming", 4, 11),
        ("Databases", 4, 10),
        ("Ukrainian", 1, 9),
        ("Development", 2, 12),
        ("Administration", 3, 9),
        ("IT Law", 2, 8),
    ]

    print_table(subjects)

    total_pairs = get_total_pairs(subjects)
    print(f"Pairs per week: {total_pairs}")

    most_pairs = get_max_pairs_subject(subjects)
    weakest = get_weakest_subject(subjects)
    print(f"Most pairs: {most_pairs[0]} ({most_pairs[1]})")
    print(f"Weakest subject: {weakest[0]} ({weakest[2]})")

    titles = [title for title, pairs, grade in subjects]
    grades = [grade for title, pairs, grade in subjects]
    average = sum(grades) / len(grades)

    print(f"Titles: {titles}")
    print(f"Grades: {grades}, average: {average:.2f}")

    high_grades = [title for title, pairs, grade in subjects if grade >= 10]
    print(f"Grade 10+: {high_grades}")

    print_histogram(subjects)

    retake_weakest_subject(subjects)

    print(f"Subjects: {subjects}")


if __name__ == "__main__":
    main()