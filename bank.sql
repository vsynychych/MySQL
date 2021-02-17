# 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
SELECT FirstName
FROM client
WHERE LENGTH(FirstName) < 6;


# 2. +Вибрати львівські відділення банку.+
SELECT DepartmentCity
FROM department
WHERE DepartmentCity = 'Lviv';


# 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
SELECT LastName, Education
FROM client
WHERE Education = 'high'
ORDER BY LastName;


# 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
SELECT *
FROM application
ORDER BY idApplication DESC
LIMIT 5;


# 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
SELECT *
FROM client
WHERE LastName LIKE '%OV'
   OR LastName LIKE '%OVA';


# 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
SELECT *
FROM client
         JOIN department ON client.Department_idDepartment = department.idDepartment
WHERE DepartmentCity LIKE 'Kyiv';


# 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
SELECT FirstName,
       Passport
FROM client
GROUP BY FirstName;


# 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
SELECT *
FROM client
         JOIN application ON client.idClient = application.Client_idClient
WHERE Currency LIKE 'Gryvnia'
  AND Sum > 5000;


# 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
SELECT SUM(CountOfWorkers)
FROM department;
SELECT SUM(CountOfWorkers)
FROM department
WHERE DepartmentCity LIKE 'Lviv';


# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
SELECT MAX(Sum)
FROM application
WHERE Client_idClient
GROUP BY Client_idClient;


# 11. Визначити кількість заявок на кредит для кожного клієнта.
SELECT COUNT(Client_idClient), Client_idClient
FROM application
GROUP BY Client_idClient;


# 12. Визначити найбільший та найменший кредити.
SELECT MAX(Sum) AS MAX, MIN(Sum) AS MIN
FROM application;


# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
SELECT COUNT(Client_idClient), FirstName, LastName, Education, Client_idClient
FROM client
         JOIN application ON client.idClient = application.Client_idClient
WHERE Education LIKE 'high'
GROUP BY Client_idClient;


# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
SELECT COUNT(Client_idClient), FirstName, LastName, City, Client_idClient, AVG(Sum) AS SumAvg
FROM application
         JOIN client ON client.idClient = application.Client_idClient
GROUP BY Client_idClient
ORDER BY SumAvg DESC
limit 1;


# 15. Вивести відділення, яке видало в кредити найбільше грошей
SELECT idDepartment, DepartmentCity, SUM(Sum) AS Summ
FROM department
         JOIN client ON department.idDepartment = client.Department_idDepartment
         JOIN application ON client.idClient = application.Client_idClient
GROUP BY DepartmentCity
ORDER BY Summ DESC
LIMIT 1;


# 16. Вивести відділення, яке видало найбільший кредит.
SELECT idDepartment, DepartmentCity, MAX(Sum)
FROM department
         JOIN client on department.idDepartment = client.Department_idDepartment
         JOIN application a on client.idClient = a.Client_idClient;


# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
UPDATE application
    JOIN client ON application.Client_idClient = client.idClient
SET Sum=6000
WHERE Education LIKE 'high';


# 18. Усіх клієнтів київських відділень переселити до Києва.
UPDATE client
    JOIN department d on d.idDepartment = client.Department_idDepartment
SET City= 'Kyiv'
WHERE DepartmentCity LIKE 'Kyiv';


# 19. Видалити усі кредити, які є повернені.
DELETE
FROM application
WHERE CreditState LIKE 'Returned';


# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.
DELETE application
FROM application
         JOIN client c on c.idClient = application.Client_idClient
WHERE c.LastName LIKE '_a%'
   OR c.LastName LIKE '_e%'
   OR c.LastName LIKE '_i%'
   OR c.LastName LIKE '_o%'
   OR c.LastName LIKE '_u%'
   OR c.LastName LIKE '_y%';



DELETE application
FROM application
         JOIN client c on c.idClient = application.Client_idClient
WHERE LastName regexp '^.[aeiouy]';




# Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
SELECT idDepartment, DepartmentCity, Sum, Currency
FROM department
         JOIN client c on department.idDepartment = c.Department_idDepartment
         JOIN application a on c.idClient = a.Client_idClient
WHERE DepartmentCity LIKE 'Lviv'
  AND Sum > 5000;


# Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
SELECT idClient,
       FirstName,
       LastName,
       Passport,
       Sum,
       CreditState
FROM client
         JOIN application a on client.idClient = a.Client_idClient
         JOIN department d on d.idDepartment = client.Department_idDepartment
WHERE CreditState LIKE 'Returned'
  AND Sum > 5000;


# /* Знайти максимальний неповернений кредит.*/
SELECT Sum, CreditState, idClient
FROM application
         JOIN client c on c.idClient = application.Client_idClient
WHERE CreditState LIKE 'Not returned'
ORDER BY Sum DESC
limit 1;


# /*Знайти клієнта, сума кредиту якого найменша*/
SELECT FirstName, LastName, idClient, SUM(Sum) AS Summ
FROM client
         JOIN department d on d.idDepartment = client.Department_idDepartment
         JOIN application a on client.idClient = a.Client_idClient
GROUP BY idClient
ORDER BY Summ
LIMIT 1;



# #місто чувака який набрав найбільше кредитів
SELECT COUNT(Client_idClient) AS CountCredits, City FROM client
JOIN application a on client.idClient = a.Client_idClient
GROUP BY Client_idClient
ORDER BY CountCredits DESC
LIMIT 1;



# PRACTICE**************************************************************************************************************
# Найти клиента львовського отделения с самим большим доларовим кредитом
SELECT FirstName, LastName, Passport, DepartmentCity, MAX(Sum), Currency
FROM client
         JOIN department d on d.idDepartment = client.Department_idDepartment
         JOIN application a on client.idClient = a.Client_idClient
WHERE DepartmentCity LIKE 'lviv'
  AND Currency LIKE 'Dollar';



# Найти клиента у которого больше всего кредитов
SELECT COUNT(idClient) AS CountCredyt, idClient, FirstName, LastName
FROM client
         JOIN application a on client.idClient = a.Client_idClient
GROUP BY idClient
ORDER BY CountCredyt DESC
limit 1;



# Найти среднее арифметическое долорових кредитов взятих во Львовском отделении
SELECT AVG(Sum)
FROM application
         JOIN client c on c.idClient = application.Client_idClient
         JOIN department d on d.idDepartment = c.Department_idDepartment
WHERE DepartmentCity LIKE 'Kyiv'
  AND Currency LIKE 'Dollar';



# Найти максимальний кредит для каждого клиента
SELECT MAX(Sum), COUNT(idClient), idClient FROM application
JOIN client c on c.idClient = application.Client_idClient
GROUP BY idClient;








