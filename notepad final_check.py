import sqlite3

connection = sqlite3.connect("lab_work_5.db")

print("=== СТРУКТУРА STUDENTS ===")
print(connection.execute(
    "SELECT sql FROM sqlite_master WHERE name = 'students'"
).fetchone()[0])

print("\n=== СТРУКТУРА SUBJECTS ===")
print(connection.execute(
    "SELECT sql FROM sqlite_master WHERE name = 'subjects'"
).fetchone()[0])

print("\n=== ДАНІ STUDENTS ===")
for row in connection.execute("SELECT * FROM students"):
    print(row)

print("\n=== ДАНІ SUBJECTS ===")
for row in connection.execute("SELECT * FROM subjects"):
    print(row)

connection.close()