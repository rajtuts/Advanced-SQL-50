-- 1699. Number of Calls Between Two Persons

Table: Calls

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| from_id     | int     |
| to_id       | int     |
| duration    | int     |
+-------------+---------+
This table does not have a primary key (column with unique values), it may contain duplicates.
This table contains the duration of a phone call between from_id and to_id.
from_id != to_id

 

Write a solution to report the number of calls and the total call duration between each pair of distinct persons (person1, person2) where person1 < person2.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Calls table:
+---------+-------+----------+
| from_id | to_id | duration |
+---------+-------+----------+
| 1       | 2     | 59       |
| 2       | 1     | 11       |
| 1       | 3     | 20       |
| 3       | 4     | 100      |
| 3       | 4     | 200      |
| 3       | 4     | 200      |
| 4       | 3     | 499      |
+---------+-------+----------+
Output: 
+---------+---------+------------+----------------+
| person1 | person2 | call_count | total_duration |
+---------+---------+------------+----------------+
| 1       | 2       | 2          | 70             |
| 1       | 3       | 1          | 20             |
| 3       | 4       | 4          | 999            |
+---------+---------+------------+----------------+
Explanation: 
Users 1 and 2 had 2 calls and the total duration is 70 (59 + 11).
Users 1 and 3 had 1 call and the total duration is 20.
Users 3 and 4 had 4 calls and the total duration is 999 (100 + 200 + 200 + 499).

-- SQL Schema
Create table If Not Exists Calls (from_id int, to_id int, duration int)
Truncate table Calls
insert into Calls (from_id, to_id, duration) values ('1', '2', '59')
insert into Calls (from_id, to_id, duration) values ('2', '1', '11')
insert into Calls (from_id, to_id, duration) values ('1', '3', '20')
insert into Calls (from_id, to_id, duration) values ('3', '4', '100')
insert into Calls (from_id, to_id, duration) values ('3', '4', '200')
insert into Calls (from_id, to_id, duration) values ('3', '4', '200')
insert into Calls (from_id, to_id, duration) values ('4', '3', '499')
    
-- union all- this gets all calls, then we put condition p1 < p2
-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle
----------------------------------------------------------------------------------------------------------------
select from_id as person1, to_id as person2, count(*) as call_count, sum(duration) as total_duration 
from
    (select from_id, to_id, duration
    from Calls
    union all
    select to_id, from_id, duration
    from Calls) t
where from_id < to_id
group by from_id, to_id
----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------
select from_id as person1, to_id as person2, count(*) as call_count, sum(duration) as total_duration 
from
    (select from_id, to_id, duration
    from Calls
    union all
    select to_id, from_id, duration
    from Calls) t
where from_id < to_id
group by 1, 2

-----------------------------------------------------------------------------------------------------------------------------
-- without using union all
-- make p1 < p2, then do calculations
  
select 
(case when from_id < to_id then from_id else to_id end) as person1,
(case when from_id < to_id then to_id else from_id end) as person2,
count(*) as call_count,
sum(duration) as total_duration
from Calls
group by 1, 2


-- facebook- 2
-- amazon- 1
