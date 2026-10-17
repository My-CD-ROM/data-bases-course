print('Batura IT-31')
#1
grades = [10, 11, 9, 10]
c = 16
#2
count_grade = sum(grades)/len(grades)
print(f"Список оцінок: {grades}")
print(f"Кількість: {len(grades)}")
print(f"Sum: {sum(grades)}")
print(f"Найкраща оцінка: {max(grades)}")
print(f"Найгірша: {min(grades)}")
print(f"Середнє значення: {count_grade:.2f}" )
#3
sort_grades = sorted(grades, reverse=True)
print(f"Впорядкований від найб: {sort_grades}" )
print(f"Оригінальний: {grades}")
#4
print(f"Три найкращі: {sort_grades[:3]}")
print(f"Три найгірші: {sort_grades[-3:][::-1]}")
#5
w_index = grades.index(min(grades)) + 1
print(f"Найгірша оцінка була за порядком: {w_index}")
#6
above_average = [g for g in grades if g > count_grade]
print(f"Оцінки, вищі за середнє: {above_average}")
print(f"Кількість оцінок, вищих за середнє: {len(above_average)}")
#7
print(f"Чи є 12 у списку: {12 in grades}")
print(f"Чи є 1 у списку: {1 in grades}")
#8
new_grade = c % 12 + 1
grades.append(new_grade)
print(f"Після додавання {new_grade} в кінець: {grades}")

grades.insert(0, 12)
print(f"Після вставки 12 на початок: {grades}")

grades.remove(min(grades))
print(f"Після вилучення найгіршої оцінки: {grades}")

popped_grade = grades.pop()
print(f"Вилучено останню оцінку: {popped_grade}")
print(f"Список після вилучення останньої оцінки: {grades}")
#9
print(f"Кількість оцінок 12 у списку: {grades.count(12)}")

#10
sort_result = grades.sort(reverse=True)
print(f"Значення, яке повернула операція sort(): {sort_result}")
print(f"Відсортований оригінальний список: {grades}")