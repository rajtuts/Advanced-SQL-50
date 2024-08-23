1767. Find the Subtasks That Did Not Execute
Table: Tasks

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| task_id        | int     |
| subtasks_count | int     |
+----------------+---------+
task_id is the column with unique values for this table.
Each row in this table indicates that task_id was divided into subtasks_count subtasks labeled from 1 to subtasks_count.
It is guaranteed that 2 <= subtasks_count <= 20.

 

Table: Executed

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| task_id       | int     |
| subtask_id    | int     |
+---------------+---------+
(task_id, subtask_id) is the combination of columns with unique values for this table.
Each row in this table indicates that for the task task_id, the subtask with ID subtask_id was executed successfully.
It is guaranteed that subtask_id <= subtasks_count for each task_id.

 

Write a solution to report the IDs of the missing subtasks for each task_id.

Return the result table in any order.

The result format is in the following example.

Example 1:

Input: 
Tasks table:
+---------+----------------+
| task_id | subtasks_count |
+---------+----------------+
| 1       | 3              |
| 2       | 2              |
| 3       | 4              |
+---------+----------------+
Executed table:
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 2          |
| 3       | 1          |
| 3       | 2          |
| 3       | 3          |
| 3       | 4          |
+---------+------------+
Output: 
+---------+------------+
| task_id | subtask_id |
+---------+------------+
| 1       | 1          |
| 1       | 3          |
| 2       | 1          |
| 2       | 2          |
+---------+------------+
Explanation: 
Task 1 was divided into 3 subtasks (1, 2, 3). Only subtask 2 was executed successfully, so we include (1, 1) and (1, 3) in the answer.
Task 2 was divided into 2 subtasks (1, 2). No subtask was executed successfully, so we include (2, 1) and (2, 2) in the answer.
Task 3 was divided into 4 subtasks (1, 2, 3, 4). All of the subtasks were executed successfully.

-- SQL Schema
Create table If Not Exists Tasks (task_id int, subtasks_count int)
Create table If Not Exists Executed (task_id int, subtask_id int)
Truncate table Tasks
insert into Tasks (task_id, subtasks_count) values ('1', '3')
insert into Tasks (task_id, subtasks_count) values ('2', '2')
insert into Tasks (task_id, subtasks_count) values ('3', '4')
Truncate table Executed
insert into Executed (task_id, subtask_id) values ('1', '2')
insert into Executed (task_id, subtask_id) values ('3', '1')
insert into Executed (task_id, subtask_id) values ('3', '2')
insert into Executed (task_id, subtask_id) values ('3', '3')
insert into Executed (task_id, subtask_id) values ('3', '4')

    -- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle
----------------------------------------------------------------------------------------------------------------

    with  cte(task_id, subtasks_count) as  
    (select task_id, subtasks_count 
    from Tasks
    
    union all
    
    select task_id, subtasks_count-1 subtasks_count
    from cte 
    where subtasks_count > 1)

select task_id, subtasks_count as subtask_id 
from cte
minus 
select * from Executed
    
----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------

-- using recursive CTE
-- calculate subtask_count starting from given number, subtracting 1 till it reaches 1
-- so subtasks count shouldn't be less than 2, because 2-1 = 1, and 1-1 will become 0
-- use recursive cte to get all subtaks
-- in the final query, pull all rows from cte, except the rows in Executed table

with recursive cte as
    (select task_id, subtasks_count 
    from Tasks
    
    union all
    
    select task_id, subtasks_count-1
    from cte 
    where subtasks_count > 1)

select task_id, subtasks_count as subtask_id 
from cte
where (task_id, subtasks_count) not in (select * 
                                        from Executed)

-- google- 1
