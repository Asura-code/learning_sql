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
