1501. Countries You Can Safely Invest In

    Table Person:

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| id             | int     |
| name           | varchar |
| phone_number   | varchar |
+----------------+---------+
id is the column of unique values for this table.
Each row of this table contains the name of a person and their phone number.
Phone number will be in the form 'xxx-yyyyyyy' where xxx is the country code (3 characters) and yyyyyyy is the phone number (7 characters) where x and y are digits. Both can contain leading zeros.

 

Table Country:

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| name           | varchar |
| country_code   | varchar |
+----------------+---------+
country_code is the column of unique values for this table.
Each row of this table contains the country name and its code. country_code will be in the form 'xxx' where x is digits.

 

Table Calls:

+-------------+------+
| Column Name | Type |
+-------------+------+
| caller_id   | int  |
| callee_id   | int  |
| duration    | int  |
+-------------+------+
This table may contain duplicate rows.
Each row of this table contains the caller id, callee id and the duration of the call in minutes. caller_id != callee_id

 

A telecommunications company wants to invest in new countries. The company intends to invest in the countries where the average call duration of the calls in this country is strictly greater than the global average call duration.

Write a solution to find the countries where this company can invest.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Person table:
+----+----------+--------------+
| id | name     | phone_number |
+----+----------+--------------+
| 3  | Jonathan | 051-1234567  |
| 12 | Elvis    | 051-7654321  |
| 1  | Moncef   | 212-1234567  |
| 2  | Maroua   | 212-6523651  |
| 7  | Meir     | 972-1234567  |
| 9  | Rachel   | 972-0011100  |
+----+----------+--------------+
Country table:
+----------+--------------+
| name     | country_code |
+----------+--------------+
| Peru     | 051          |
| Israel   | 972          |
| Morocco  | 212          |
| Germany  | 049          |
| Ethiopia | 251          |
+----------+--------------+
Calls table:
+-----------+-----------+----------+
| caller_id | callee_id | duration |
+-----------+-----------+----------+
| 1         | 9         | 33       |
| 2         | 9         | 4        |
| 1         | 2         | 59       |
| 3         | 12        | 102      |
| 3         | 12        | 330      |
| 12        | 3         | 5        |
| 7         | 9         | 13       |
| 7         | 1         | 3        |
| 9         | 7         | 1        |
| 1         | 7         | 7        |
+-----------+-----------+----------+
Output: 
+----------+
| country  |
+----------+
| Peru     |
+----------+
Explanation: 
The average call duration for Peru is (102 + 102 + 330 + 330 + 5 + 5) / 6 = 145.666667
The average call duration for Israel is (33 + 4 + 13 + 13 + 3 + 1 + 1 + 7) / 8 = 9.37500
The average call duration for Morocco is (33 + 4 + 59 + 59 + 3 + 7) / 6 = 27.5000 
Global call duration average = (2 * (33 + 4 + 59 + 102 + 330 + 5 + 13 + 3 + 1 + 7)) / 20 = 55.70000
Since Peru is the only country where the average call duration is greater than the global average, it is the only recommended country.

-- SQL Schema
Create table If Not Exists Person (id int, name varchar(15), phone_number varchar(11))
Create table If Not Exists Country (name varchar(15), country_code varchar(3))
Create table If Not Exists Calls (caller_id int, callee_id int, duration int)
Truncate table Person
insert into Person (id, name, phone_number) values ('3', 'Jonathan', '051-1234567')
insert into Person (id, name, phone_number) values ('12', 'Elvis', '051-7654321')
insert into Person (id, name, phone_number) values ('1', 'Moncef', '212-1234567')
insert into Person (id, name, phone_number) values ('2', 'Maroua', '212-6523651')
insert into Person (id, name, phone_number) values ('7', 'Meir', '972-1234567')
insert into Person (id, name, phone_number) values ('9', 'Rachel', '972-0011100')
Truncate table Country
insert into Country (name, country_code) values ('Peru', '051')
insert into Country (name, country_code) values ('Israel', '972')
insert into Country (name, country_code) values ('Morocco', '212')
insert into Country (name, country_code) values ('Germany', '049')
insert into Country (name, country_code) values ('Ethiopia', '251')
Truncate table Calls
insert into Calls (caller_id, callee_id, duration) values ('1', '9', '33')
insert into Calls (caller_id, callee_id, duration) values ('2', '9', '4')
insert into Calls (caller_id, callee_id, duration) values ('1', '2', '59')
insert into Calls (caller_id, callee_id, duration) values ('3', '12', '102')
insert into Calls (caller_id, callee_id, duration) values ('3', '12', '330')
insert into Calls (caller_id, callee_id, duration) values ('12', '3', '5')
insert into Calls (caller_id, callee_id, duration) values ('7', '9', '13')
insert into Calls (caller_id, callee_id, duration) values ('7', '1', '3')
insert into Calls (caller_id, callee_id, duration) values ('9', '7', '1')
insert into Calls (caller_id, callee_id, duration) values ('1', '7', '7')

    
-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle
----------------------------------------------------------------------------------------------------------------
select ct.name as country
from calls c
    inner join person p on  c.caller_id=p.id or c.callee_id=p.id
    inner join country ct on ct.country_code=substr(p.phone_number,1,3)
group by ct.name
having avg(duration) > (select avg(duration) from calls)


----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------
    
-- id_country- get country name for each person by joining on country code
-- id_duration- duration for each person on each call- each person can have multiple rows
-- final query- join these 2 to calculate avg for each country- group by country
-- use having clause to filter avg for country > global avg (calculated using id_duration cte)


with id_country as
    (select p.id, c.name as country
    from Person p
    join Country c
    on left(p.phone_number, 3) = c.country_code),

    id_duration as
    (select caller_id, duration
    from Calls
    union all
    select callee_id, duration
    from Calls)

select c.country
from id_country c
join id_duration d
on c.id = d.caller_id
group by c.country
having avg(duration) > (select avg(duration) 
                        from id_duration)

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- same as above but concise
-- first cte as above, 
-- then join on Calls using OR

select c.name as country
from Country c
join Person p 
on c.country_code = left(p.phone_number, 3)
join calls cl
on cl.caller_id = p.id or cl.callee_id = p.id
group by c.name
having avg(duration) > (select avg(duration) 
                        from Calls)


-- no companies listed
