1225. Report Contiguous Dates

Table: Failed

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| fail_date    | date    |
+--------------+---------+
fail_date is the primary key (column with unique values) for this table.
This table contains the days of failed tasks.

 Table: Succeeded

+--------------+---------+
| Column Name  | Type    |
+--------------+---------+
| success_date | date    |
+--------------+---------+
success_date is the primary key (column with unique values) for this table.
This table contains the days of succeeded tasks.

A system is running one task every day. Every task is independent of the previous tasks. The tasks can fail or succeed.

Write a solution to report the period_state for each continuous interval of days in the period from 2019-01-01 to 2019-12-31.

period_state is 'failed' if tasks in this interval failed or 'succeeded' if tasks in this interval succeeded. Interval of days are retrieved as start_date and end_date.

Return the result table ordered by start_date.

The result format is in the following example.

Example 1:

Input: 
Failed table:
+-------------------+
| fail_date         |
+-------------------+
| 2018-12-28        |
| 2018-12-29        |
| 2019-01-04        |
| 2019-01-05        |
+-------------------+
Succeeded table:
+-------------------+
| success_date      |
+-------------------+
| 2018-12-30        |
| 2018-12-31        |
| 2019-01-01        |
| 2019-01-02        |
| 2019-01-03        |
| 2019-01-06        |
+-------------------+
Output: 
+--------------+--------------+--------------+
| period_state | start_date   | end_date     |
+--------------+--------------+--------------+
| succeeded    | 2019-01-01   | 2019-01-03   |
| failed       | 2019-01-04   | 2019-01-05   |
| succeeded    | 2019-01-06   | 2019-01-06   |
+--------------+--------------+--------------+
Explanation: 
The report ignored the system state in 2018 as we care about the system in the period 2019-01-01 to 2019-12-31.
From 2019-01-01 to 2019-01-03 all tasks succeeded and the system state was "succeeded".
From 2019-01-04 to 2019-01-05 all tasks failed and the system state was "failed".
From 2019-01-06 to 2019-01-06 all tasks succeeded and the system state was "succeeded".

-- SQL Schema
Create table If Not Exists Failed (fail_date date)
Create table If Not Exists Succeeded (success_date date)
Truncate table Failed
insert into Failed (fail_date) values ('2018-12-28')
insert into Failed (fail_date) values ('2018-12-29')
insert into Failed (fail_date) values ('2019-01-04')
insert into Failed (fail_date) values ('2019-01-05')
Truncate table Succeeded
insert into Succeeded (success_date) values ('2018-12-30')
insert into Succeeded (success_date) values ('2018-12-31')
insert into Succeeded (success_date) values ('2019-01-01')
insert into Succeeded (success_date) values ('2019-01-02')
insert into Succeeded (success_date) values ('2019-01-03')
insert into Succeeded (success_date) values ('2019-01-06')
    
-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle
----------------------------------------------------------------------------------------------------------------

with cte as (
  select fail_date as dt, 'failed' as status
  from failed
  union 
  select success_date as dt, 'succeeded' as status
  from succeeded
)
select status as period_state, to_char(min(dt)) as start_date, to_char(max(dt)) as end_date
from (
select cte.*, row_number() over(order by dt) - row_number() over(partition by status order by dt) as grouping_seq
from cte
where dt between to_date('2019-01-01') and to_date('2019-12-31'))t
group by status,grouping_seq
order by 2    

----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------

-- cte1- unioned both tables and arranged in ascending order of dates
-- cte2- calculated rn and rnk and diff between them
-- final query- picked min date as start date, max date as end date, grouped by status and diff
-- rank()- gave them ranking based on their status ascending order date
-- row_number()- ordered by date asc
-- diff between them will be consistent if they are contiguous, hence group by diff
-- when the status changes, again diff between them will be contiguous hence group by status to get different records for same status

with cte1 as
    ((select fail_date as event_date, 'failed' as status
    from Failed)
    union all
    (select success_date as event_date, 'succeeded' as status
    from Succeeded)),
    cte2 as
    (select *,
        row_number() over(order by event_date) as rn,
        dense_rank() over (partition by status order by event_date) as rnk,
        row_number() over(order by event_date) - dense_rank() over (partition by status order by event_date) as diff   
    from cte1
    where event_date between '2019-01-01' and '2019-12-31'
    order by 1)

select status as period_state, min(event_date) as start_date, max(event_date) as end_date
from cte2
group by status, diff
order by 2

-- facebook- 1

------------------------------------------------------------------------------------------------------------------------------------------------------------

-- o/p of cte2
  
| event_date | status    | rn | rnk | diff |
| ---------- | --------- | -- | --- | ---- |
| 2019-01-01 | succeeded | 1  | 1   | 0    |
| 2019-01-02 | succeeded | 2  | 2   | 0    |
| 2019-01-03 | succeeded | 3  | 3   | 0    |
| 2019-01-04 | failed    | 4  | 1   | 3    |
| 2019-01-05 | failed    | 5  | 2   | 3    |
| 2019-01-06 | succeeded | 6  | 4   | 2    |
