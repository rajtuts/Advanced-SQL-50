1285. Find the Start and End Number of Continuous Ranges

Table: Logs

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| log_id        | int     |
+---------------+---------+
log_id is the column of unique values for this table.
Each row of this table contains the ID in a log Table.

Write a solution to find the start and end number of continuous ranges in the table Logs.

Return the result table ordered by start_id.

The result format is in the following example.

Example 1:

Input: 
Logs table:
+------------+
| log_id     |
+------------+
| 1          |
| 2          |
| 3          |
| 7          |
| 8          |
| 10         |
+------------+
Output: 
+------------+--------------+
| start_id   | end_id       |
+------------+--------------+
| 1          | 3            |
| 7          | 8            |
| 10         | 10           |
+------------+--------------+
Explanation: 
The result table should contain all ranges in table Logs.
From 1 to 3 is contained in the table.
From 4 to 6 is missing in the table
From 7 to 8 is contained in the table.
Number 9 is missing from the table.
Number 10 is contained in the table.

-- SQL Schema

Create table If Not Exists Logs (log_id int)
Truncate table Logs
insert into Logs (log_id) values ('1')
insert into Logs (log_id) values ('2')
insert into Logs (log_id) values ('3')
insert into Logs (log_id) values ('7')
insert into Logs (log_id) values ('8')
insert into Logs (log_id) values ('10')

-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle 
----------------------------------------------------------------------------------------------------------------
with consecutive_groups as (
    select log_id, log_id - rank() over (order by log_id) grp 
    from logs 
)
select min(log_id) start_id, max(log_id) end_id
from consecutive_groups 
group by grp
order by 1

----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------
    
-- row number- created just to look at what it looks like
-- continuous ranges have same differences from row number
-- so pick min as start, max as end and group by diff

select min(log_id) as start_id, max(log_id) as end_id
from
    (select log_id, 
        row_number() over(order by log_id) as rn, 
        log_id - row_number() over(order by log_id) as diff
    from Logs) temp
group by diff


-- microsoft- 1
