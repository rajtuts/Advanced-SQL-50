603. Consecutive Available Seats

Table: Cinema

+-------------+------+
| Column Name | Type |
+-------------+------+
| seat_id     | int  |
| free        | bool |
+-------------+------+
seat_id is an auto-increment column for this table.
Each row of this table indicates whether the ith seat is free or not. 1 means free while 0 means occupied.

 

Find all the consecutive available seats in the cinema.

Return the result table ordered by seat_id in ascending order.

The test cases are generated so that more than two seats are consecutively available.

The result format is in the following example.

 

Example 1:

Input: 
Cinema table:
+---------+------+
| seat_id | free |
+---------+------+
| 1       | 1    |
| 2       | 0    |
| 3       | 1    |
| 4       | 1    |
| 5       | 1    |
+---------+------+
Output: 
+---------+
| seat_id |
+---------+
| 3       |
| 4       |
| 5       |
+---------+

-- SQL Schema

Create table If Not Exists Cinema (seat_id int primary key auto_increment, free bool)
Truncate table Cinema
insert into Cinema (seat_id, free) values ('1', '1')
insert into Cinema (seat_id, free) values ('2', '0')
insert into Cinema (seat_id, free) values ('3', '1')
insert into Cinema (seat_id, free) values ('4', '1')
insert into Cinema (seat_id, free) values ('5', '1')

-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle
----------------------------------------------------------------------------------------------------------------
select distinct b.seat_id  
from cinema a, cinema b
where ((a.seat_id=b.seat_id-1) or (a.seat_id-1=b.seat_id))
and a.free = 1 and b.free=1 
order by 1

----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------

-- lag and lead will give the rows above and below
-- if free = 1 and either of lag_free or lead_free is 1, it means we have 2 consecutive free seats.
-- just pick those rows

with CTE as(
    select seat_id, free, 
        lag(free, 1) over(order by seat_id) as lag_free, 
        lead(free, 1) over(order by seat_id) as lead_free
    from Cinema)

select seat_id 
from CTE
where (free = 1 and lag_free = 1) or (free = 1 and lead_free = 1)
order by 1

------------------------------------------------------------------------------------------------------------------------------------------------------------
-- if seat = free AND seat + 1 or seat - 1 have free = 1, then pull that seat  
  
select seat_id
from Cinema
where free = 1 and
     (seat_id - 1 in (select seat_id
                      from Cinema
                      where free = 1)
    or
    seat_id + 1 in (select seat_id
                      from Cinema
                      where free = 1))


-- amazon- 4
