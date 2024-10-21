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
