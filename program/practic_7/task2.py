print('Batura IT-31')
letters = list("batura")
c = 6
print(f"Список літер: {letters}")
print(f"Довжина c: {c}")
#2
first_letter = letters[0]
middle_index = c // 2
middle_letter = letters[middle_index]
last_letter_1 = letters[-1]
last_letter_2  = letters[c - 1]

print(f"Перша літера: {first_letter}")
print(f"Середня літера: {middle_letter}")
print(f"Остання літера (спосіб 1): {last_letter_1}")
print(f"Остання літера (спосіб 2): {last_letter_2}")
#3
print(f"Перші три літери: {letters[:3]}")
print(f"Усі, крім перших трьох: {letters[3:]}")
print(f"Кожна друга літера: {letters[::2]}")
print(f"У зворотному порядку: {letters[::-1]}")
print(f"Останні дві літери: {letters[-2:]}")
print(f"З позиції c (довжиною 5): {letters[c:c+5]}")
#4
unique = []
for letter in letters:
    if letter not in unique:
        unique.append(letter)

print(f"Унікальні літери: {unique}")

has_duplicates = False
for letter in unique:
    count = letters.count(letter)
    if count > 1:
        print(f"Літера '{letter}' трапляється {count} рази(ів)")
        has_duplicates = True

if not has_duplicates:
    print("No repeated letters")

#5
alphabetical = sorted(letters)
print(f"Літери в алфавітному порядку: {alphabetical}")