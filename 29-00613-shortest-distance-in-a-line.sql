613. Shortest Distance in a Line

Table: Point

+-------------+------+
| Column Name | Type |
+-------------+------+
| x           | int  |
+-------------+------+
In SQL, x is the primary key column for this table.
Each row of this table indicates the position of a point on the X-axis.

Find the shortest distance between any two points from the Point table.

The result format is in the following example.

Example 1:

Input: 
Point table:
+----+
| x  |
+----+
| -1 |
| 0  |
| 2  |
+----+
Output: 
+----------+
| shortest |
+----------+
| 1        |
+----------+
Explanation: The shortest distance is between points -1 and 0 which is |(-1) - 0| = 1.

Follow up: How could you optimize your solution if the Point table is ordered in ascending order?

-- SQL Schema
Create Table If Not Exists Point (x int not null)
Truncate table Point
insert into Point (x) values ('-1')
insert into Point (x) values ('0')
insert into Point (x) values ('2')

-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle
----------------------------------------------------------------------------------------------------------------
-- 1. using Lead funtion
select min(diff) shortest
from(
select lead(x) over(order by x) -x diff
from Point
 )

-- 2. using CTE and ABS function


  
----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------

-- cross joining all the points from 2 tables, except the ones where they are same
-- find the min of absolute distance

select min(abs(a - b)) as shortest
from
  (select p1.x as a, p2.x as b
  from Point p1 cross join Point p2
  where p1.x != p2.x) temp

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- concise version of the above
  
select min(abs(p1.x - p2.x)) as shortest
from Point p1 cross join Point p2
where p1.x != p2.x

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- pull min distance with a where condition

select min(p1.x - p2.x) as shortest
from Point p1, Point p2
where p1.x > p2.x

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- sort the table, and do lag. Now diff between current and lag- because difference between the sorted will always be lesser than difference between the larger ones
-- pull the min distance
  
with CTE as 
  (select x - lag(x) over(order by x) as distance
  from Point)

select min(distance) as shortest from CTE

-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- picking the lowest distance, 1st row will always be null hence use offset

select x - lag(x) over(order by x) as shortest
from Point
order by 1 asc
limit 1 offset 1


-- no companies listed
