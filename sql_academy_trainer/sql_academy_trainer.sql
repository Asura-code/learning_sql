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