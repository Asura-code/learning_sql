--1. Вывести имена всех людей, которые есть в базе данных авиакомпаний

SELECT name FROM passenger

--2. Вывести названия всеx авиакомпаний

SELECT name FROM company

--3. Вывести все рейсы, совершенные из Москвы

SELECT * FROM trip 
WHERE town_from = 'Moscow'

--4. Вывести имена людей, которые заканчиваются на "man"

SELECT name FROM passenger
WHERE name LIKE '%man'

-- через регулярные выражения

SELECT name FROM passenger
WHERE name REGEXP  'man$'

--5. Вывести количество рейсов, совершенных на TU-134

SELECT COUNT(*) as count FROM trip
WHERE plane = 'TU-134'

--6. Какие компании совершали перелеты на Boeing

SELECT DISTINCT name FROM Company 
JOIN Trip ON Company.id = Trip.company 
WHERE plane = 'Boeing'

--7. Вывести все названия самолётов, на которых можно улететь в Москву (Moscow)

SELECT DISTINCT plane from Trip 
WHERE town_to = 'Moscow'


--8. В какие города можно улететь из Парижа (Paris) и сколько времени это займёт?

SELECT town_to, TIMEDIFF(time_in, time_out) as flight_time FROM Trip
WHERE town_from = 'Paris'

--9. Какие компании организуют перелеты из Владивостока (Vladivostok)?

SELECT name FROM Company
JOIN Trip ON Trip.company = Company.id
WHERE  town_from = 'Vladivostok'

--10. Вывести вылеты, совершенные с 10 ч. по 14 ч. 1 января 1900 г.

SELECT * FROM Trip 
WHERE time_out BETWEEN 
'1900-01-01 10:00:00' AND '1900-01-01 14:00:00'


--11. Выведите пассажиров с самым длинным ФИО. Пробелы, дефисы и точки считаются частью имени.

SELECT name FROM Passenger 
WHERE LENGTH(name) = (SELECT MAX(LENGTH(name)) FROM Passenger)

--12. Выведите идентификаторы всех рейсов и количество пассажиров на них. Обратите внимание, что на каких-то рейсах пассажиров может не быть. В этом случае выведите число "0".

SELECT Trip.id , COUNT(Pass_in_trip.passenger) AS count 
FROM  Trip 
LEFT JOIN Pass_in_trip ON Pass_in_trip.trip = Trip.id
GROUP BY Trip.id

--13. Вывести имена людей, у которых есть полный тёзка среди пассажиров

SELECT name FROM Passenger
GROUP BY name
HAVING COUNT(name) > 1

--14. В какие города летал Bruce Willis

SELECT town_to FROM Trip
JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
JOIN Passenger ON Passenger.id = Pass_in_trip.passenger
WHERE Passenger.name = 'Bruce Willis'

--15. Выведите дату и время прилёта пассажира Стив Мартин (Steve Martin) в Лондон (London)

SELECT time_in FROM Trip
JOIN Pass_in_trip ON Trip.id = Pass_in_trip.trip
JOIN Passenger ON Passenger.id = Pass_in_trip.passenger
WHERE Passenger.name = 'Steve Martin' and Trip.town_to = 'London'

--16. Вывести отсортированный по количеству перелетов (по убыванию) и имени (по возрастанию) список пассажиров, совершивших хотя бы 1 полет.

SELECT name, COUNT(*) as count FROM Passenger
JOIN Pass_in_trip ON Pass_in_trip.passenger = Passenger.id
GROUP BY name
HAVING COUNT(*) >= 1
ORDER BY count DESC, name 


--17. Определить, сколько потратил в 2005 году каждый из членов семьи. В результирующей выборке не выводите тех членов семьи, которые ничего не потратили.

SELECT member_name, status, SUM(amount*unit_price) as costs FROM FamilyMembers
JOIN Payments ON FamilyMembers.member_id = Payments.family_member
WHERE YEAR(Payments.date) = '2005'
GROUP BY member_name, status

--18. Выведите имя самого старшего человека. Если таких несколько, то выведите их всех.

SELECT member_name FROM FamilyMembers
WHERE birthday = (SELECT MIN(birthday) as birthday FROM FamilyMembers)

--19. Определить, кто из членов семьи покупал картошку (potato)

SELECT status FROM FamilyMembers
JOIN Payments ON FamilyMembers.member_id = Payments.family_member
JOIN Goods ON Payments.good = Goods.good_id
WHERE Goods.good_name = 'potato'
GROUP BY member_id

--20. Сколько и кто из семьи потратил на развлечения (entertainment). Вывести статус в семье, имя, сумму

SELECT status, member_name, SUM(amount*unit_price) as costs FROM FamilyMembers
JOIN Payments ON FamilyMembers.member_id = Payments.family_member
JOIN Goods ON Payments.good = Goods.good_id
JOIN GoodTypes ON Goods.type = GoodTypes.good_type_id
WHERE good_type_name = 'entertainment'
GROUP BY member_id

--21. Определить товары, которые покупали более 1 раза

SELECT good_name FROM Goods
JOIN Payments ON Goods.good_id = Payments.good
GROUP BY good_name
HAVING  COUNT(good) > 1

--22. Найти имена всех матерей (mother)

SELECT member_name FROM FamilyMembers
WHERE status = 'mother'

--23. Найдите самый дорогой деликатес (delicacies) и выведите его цену

SELECT good_name, unit_price FROM Payments
JOIN Goods ON Payments.good = Goods.good_id
JOIN GoodTypes ON Goods.type = GoodTypes.good_type_id
WHERE good_type_name = 'delicacies'
GROUP BY good_name, unit_price
HAVING unit_price = (
    SELECT MAX(unit_price) as unit_price FROM Payments
    JOIN Goods ON Payments.good = Goods.good_id
    JOIN GoodTypes ON Goods.type = GoodTypes.good_type_id
    WHERE good_type_name = 'delicacies'
)

--24. Определить кто и сколько потратил в июне 2005

SELECT member_name, SUM(amount*unit_price) as costs FROM FamilyMembers
JOIN Payments ON FamilyMembers.member_id = Payments.family_member
WHERE date BETWEEN '2005-06-01T00:00:00.000Z' AND '2005-07-01T00:00:00.000Z'
GROUP BY member_name

--25. Определить, какие товары не покупались в 2005 году

SELECT good_name FROM Goods
WHERE good_id NOT IN (SELECT good FROM Payments
WHERE YEAR(date)='2005')

--26. Определить группы товаров, которые не приобретались в 2005 году

SELECT good_type_name FROM GoodTypes
WHERE good_type_name NOT IN (
    SELECT good_type_name FROM GoodTypes
    JOIN Goods ON GoodTypes.good_type_id = Goods.type
    JOIN Payments ON Goods.good_id = Payments.good
    GROUP BY good_type_name
)

--27. Узнайте, сколько было потрачено на каждую из групп товаров в 2005 году. Выведите название группы и потраченную на неё сумму. Если потраченная сумма равна нулю, т.е. товары из этой группы не покупались в 2005 году, то не выводите её.

SELECT good_type_name, SUM(amount*unit_price) as costs FROM GoodTypes
JOIN Goods ON GoodTypes.good_type_id = Goods.type
JOIN Payments ON Goods.good_id = Payments.good
WHERE YEAR(date) = '2005'
GROUP BY good_type_name

--28. Сколько рейсов совершили авиакомпании из Ростова (Rostov) в Москву (Moscow) ?

SELECT COUNT(*) as count FROM Trip
WHERE town_from = 'Rostov' AND town_to = 'Moscow'

--29. Выведите имена пассажиров улетевших в Москву (Moscow) на самолете TU-134

SELECT name FROM Passenger
JOIN Pass_in_trip ON Passenger.id = Pass_in_trip.passenger
JOIN Trip ON Pass_in_trip.trip = Trip.id
WHERE town_to = 'Moscow' AND plane = 'TU-134'
GROUP BY name

--30. Выведите нагруженность (число пассажиров) каждого рейса (trip). Результат вывести в отсортированном виде по убыванию нагруженности.

SELECT trip, COUNT(passenger) as count FROM Pass_in_trip
GROUP  BY trip
ORDER BY count DESC

--31. Вывести всех членов семьи с фамилией Quincey.

SELECT * FROM FamilyMembers
WHERE member_name REGEXP 'Quincey'

--32. Вывести средний возраст людей (в годах), хранящихся в базе данных. Результат округлите до целого в меньшую сторону.

SELECT FLOOR(AVG(YEAR(CURRENT_DATE) - YEAR(birthday))) as age FROM FamilyMembers -- FLOOR - округляет в меньшую сторону до целого

--33. Найдите среднюю цену икры на основе данных, хранящихся в таблице Payments. В базе данных хранятся данные о покупках красной (red caviar) и черной икры (black caviar). В ответе должна быть одна строка со средней ценой всей купленной когда-либо икры.

SELECT AVG(unit_price) as cost FROM Payments
JOIN Goods ON Payments.good = Goods.good_id
WHERE good_name REGEXP 'caviar'

--34. Сколько всего 10-ых классов

SELECT COUNT(name) as count FROM Class
WHERE name REGEXP '10'

--35. Сколько различных кабинетов школы использовались 2 сентября 2019 года для проведения занятий?

SELECT COUNT(DISTINCT classroom) as count FROM Schedule
WHERE date = '2019-09-02'

--36. Выведите информацию об обучающихся живущих на улице Пушкина (ul. Pushkina)?

SELECT * FROM Student
WHERE address REGEXP 'Pushkina'

--37. Сколько лет самому молодому обучающемуся ?

SELECT MIN(TIMESTAMPDIFF(YEAR,birthday,CURRENT_DATE)) as year FROM Student

--38. Сколько Анн (Anna) учится в школе ?

SELECT COUNT(*) as count FROM Student
WHERE first_name = 'Anna'

--39. Сколько обучающихся в 10 B классе ?

SELECT COUNT(*) AS count FROM Student_in_class
JOIN Class ON Student_in_class.class = Class.id
WHERE Class.name REGEXP '10 B'

--40. Выведите название предметов, которые преподает Ромашкин П.П. (Romashkin P.P.). Обратите внимание, что в базе данных есть несколько учителей с такими фамилией и инициалами.

SELECT name as subjects FROM Subject
JOIN Schedule ON Schedule.subject = Subject.id
JOIN Teacher ON Teacher.id = Schedule.teacher
WHERE Teacher.last_name REGEXP 'Romashkin' AND middle_name LIKE 'P%' AND first_name LIKE 'P%'

--41. Выясните, во сколько по расписанию начинается четвёртое занятие.

SELECT start_pair FROM Timepair
WHERE id = 4

--42. Сколько времени обучающийся будет находиться в школе, учась со 2-го по 4-ый уч. предмет?

SELECT DISTINCT TIMEDIFF(
(SELECT end_pair FROM Timepair
WHERE id = 4),
(SELECT start_pair FROM Timepair
WHERE id = 2)
) as time FROM Timepair

--43. Выведите фамилии преподавателей, которые ведут физическую культуру (Physical Culture). Отсортируйте преподавателей по фамилии в алфавитном порядке.

SELECT last_name FROM Teacher
JOIN Schedule ON Teacher.id = Schedule.teacher
JOIN Subject ON Schedule.subject = Subject.id
WHERE name REGEXP 'PHYSICAL CULTURE'
ORDER BY last_name 

--114. Напишите запрос, который выведет имена пилотов, которые в качестве второго пилота (second_pilot_id) в августе 2023 года летали в New York ||| Тинькоф

SELECT name FROM Pilots
JOIN Flights ON pilot_id = second_pilot_id
WHERE MONTH(flight_date) = '8' AND YEAR(flight_date) = '2023' AND destination = 'New York'

--101. Выведи для каждого пользователя первое наименование, которое он заказал (первое по времени транзакции). ||| VK

SELECT user_id, item FROM Transactions
WHERE transaction_ts in (
    SELECT MIN(transaction_ts) FROM Transactions
    GROUP BY user_id
)

--44. Найдите максимальный возраст (количество лет) среди обучающихся 10 классов на сегодняшний день. Для получения текущих даты и времени используйте функцию NOW().

SELECT MAX(TIMESTAMPDIFF(year, birthday, current_time)) as max_year FROM Student
JOIN Student_in_class ON Student.id = Student_in_class.student
JOIN Class ON Student_in_class.class = Class.id
WHERE Class.name LIKE '10%'

--45. Какие кабинеты чаще всего использовались для проведения занятий? Выведите те, которые использовались максимальное количество раз.

WITH CTE AS (SELECT classroom, COUNT(classroom) as mx FROM Schedule
GROUP BY classroom
ORDER BY mx DESC 
)

SELECT classroom FROM CTE
WHERE mx in (SELECT MAX(mx) FROM CTE)

--46. В каких классах введет занятия преподаватель "Krauze" ?

SELECT name FROM Class
JOIN Schedule ON Class.id = Schedule.class 
JOIN Teacher ON Schedule.teacher = Teacher.id 
WHERE Teacher.last_name REGEXP 'Krauze'
GROUP BY name

--47. Сколько занятий провел Krauze 30 августа 2019 г.?

SELECT COUNT(number_pair) as count FROM Schedule
JOIN Teacher ON Schedule.teacher = Teacher.id 
WHERE Teacher.last_name REGEXP 'Krauze' AND date = '2019-08-30'

--48. Выведите заполненность классов в порядке убывания

SELECT name, COUNT(student) as count FROM Class
JOIN Student_in_class ON Class.id = Student_in_class.class
GROUP BY name
ORDER BY count DESC 

--49. Какой процент обучающихся учится в "10 A" классе? Выведите ответ в диапазоне от 0 до 100 с округлением до четырёх знаков после запятой, например, 96.0201.

SELECT COUNT(student)*100 / (SELECT COUNT(student) FROM Student_in_class) as percent FROM Student_in_class
JOIN Class ON Student_in_class.class = Class.id
WHERE Class.name REGEXP '10 A'

--50. Какой процент обучающихся родился в 2000 году? Результат округлить до целого в меньшую сторону.

SELECT FLOOR(COUNT(student)*100 / (SELECT COUNT(student) FROM Student_in_class)) AS percent FROM Student_in_class
JOIN Student ON Student_in_class.student = Student.id 
WHERE YEAR(Student.birthday) = '2000'

--51. Добавьте товар с именем "Cheese" и типом "food" в список товаров (Goods).

INSERT INTO Goods
SET good_id = (SELECT COUNT(good_id) FROM Goods AS a)+1, 
    good_name = 'Cheese',
    type = (SELECT good_type_id FROM GoodTypes
            WHERE good_type_name = 'food'
            GROUP BY good_type_id)

--52. Добавьте в список типов товаров (GoodTypes) новый тип "auto".
INSERT INTO GoodTypes VALUES
((SELECT COUNT(*) FROM GoodTypes AS A)+1, 'auto')

--53. Измените имя "Andie Quincey" на новое "Andie Anthony".

UPDATE FamilyMembers
SET member_name = 'Andie Anthony'
WHERE member_name = 'Andie Quincey'

--54. Удалить всех членов семьи с фамилией "Quincey".

DELETE FROM FamilyMembers
WHERE member_name REGEXP 'Quincey'

--55. Удалить компании, совершившие наименьшее количество рейсов.

WITH CTE AS(
SELECT company, COUNT(company) AS A FROM Trip
GROUP BY company
)


DELETE FROM Company
WHERE id in (
    SELECT company FROM CTE
    WHERE A IN (SELECT MIN(A) FROM CTE)
    )

--56. Удалить все перелеты, совершенные из Москвы (Moscow).

DELETE FROM Trip
WHERE town_from = 'Moscow'

--57. Перенести расписание всех занятий на 30 мин. вперед.

UPDATE Timepair
SET start_pair = start_pair + INTERVAL 30 MINUTE,
    end_pair = end_pair + INTERVAL 30 MINUTE

--58. Добавить отзыв с рейтингом 5 на жилье, находящиеся по адресу "11218, Friel Place, New York", от имени "George Clooney"

INSERT INTO Reviews
SET id = (SELECT COUNT(*) FROM Reviews AS C)+1,
    reservation_id = (SELECT R.id FROM Reservations AS R
                      JOIN Users ON R.user_id = Users.id
                      JOIN Rooms ON R.room_id = Rooms.id
                      WHERE Users.name = 'George Clooney' AND Rooms.address = '11218, Friel Place, New York'),
    rating = 5

--59. Вывести пользователей,указавших Белорусский номер телефона ? Телефонный код Белоруссии +375.

SELECT * FROM Users
WHERE phone_number REGEXP '\\+375'

--60. Выведите идентификаторы преподавателей, которые хотя бы один раз за всё время преподавали в каждом из одиннадцатых классов.

WITH CTE AS (
SELECT teacher, name FROM Schedule
JOIN Class ON Schedule.class = Class.id
WHERE Class.name REGEXP '11'
GROUP BY teacher, name)

SELECT teacher FROM (SELECT COUNT(teacher) AS C, teacher FROM CTE
GROUP BY teacher) AS T
WHERE C = 2


-- ИЛИ другой способ

WITH CTE AS (
SELECT teacher, name FROM Schedule
JOIN Class ON Schedule.class = Class.id
WHERE Class.name REGEXP '11'
GROUP BY teacher, name)

SELECT teacher FROM (SELECT COUNT(teacher) AS C, teacher FROM CTE
GROUP BY teacher) AS T
WHERE C = 2

--93. Какой средний возраст клиентов, купивших Smartwatch (использовать наименование товара product.name) в 2024 году? Альфа

WITH CTX AS (
SELECT age, Customer.customer_key FROM Customer
JOIN Purchase ON Customer.customer_key = Purchase.customer_key
JOIN Product ON Purchase.product_key = Product.product_key
WHERE YEAR(Purchase.date) = '2024' AND Product.name = 'Smartwatch'
)

SELECT AVG(age) AS average_age FROM (SELECT DISTINCT customer_key, age FROM CTX) AS C


--94. Вывести имена покупателей, каждый из которых приобрёл Laptop и Monitor (использовать наименование товара product.name) в марте 2024 года? Альфа

SELECT name FROM (
    SELECT name, COUNT(*) AS t FROM (
        SELECT customer_key, name, p FROM (
            SELECT Customer.name, Product.name as p, Customer.customer_key FROM Customer
            JOIN Purchase ON Customer.customer_key = Purchase.customer_key
            JOIN Product ON Purchase.product_key = Product.product_key
            WHERE (Product.name = 'Laptop' OR Product.name = 'Monitor') AND YEAR(Purchase.date) = 2024 AND MONTH(Purchase.date) = 3) AS CTE
        GROUP BY p, name, customer_key) AS CT
    GROUP BY name) AS CTEX
WHERE t = 2





