1303. Find the Team Size

Table: Employee

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| team_id       | int     |
+---------------+---------+
employee_id is the primary key (column with unique values) for this table.
Each row of this table contains the ID of each employee and their respective team.

Write a solution to find the team size of each of the employees.

Return the result table in any order.

The result format is in the following example.

Example 1:

Input: 
Employee Table:
+-------------+------------+
| employee_id | team_id    |
+-------------+------------+
|     1       |     8      |
|     2       |     8      |
|     3       |     8      |
|     4       |     7      |
|     5       |     9      |
|     6       |     9      |
+-------------+------------+
Output: 
+-------------+------------+
| employee_id | team_size  |
+-------------+------------+
|     1       |     3      |
|     2       |     3      |
|     3       |     3      |
|     4       |     1      |
|     5       |     2      |
|     6       |     2      |
+-------------+------------+
Explanation: 
Employees with Id 1,2,3 are part of a team with team_id = 8.
Employee with Id 4 is part of a team with team_id = 7.
Employees with Id 5,6 are part of a team with team_id = 9.

-- SQL Schema
Create table If Not Exists Employee (employee_id int, team_id int)
Truncate table Employee
insert into Employee (employee_id, team_id) values ('1', '8')
insert into Employee (employee_id, team_id) values ('2', '8')
insert into Employee (employee_id, team_id) values ('3', '8')
insert into Employee (employee_id, team_id) values ('4', '7')
insert into Employee (employee_id, team_id) values ('5', '9')
insert into Employee (employee_id, team_id) values ('6', '9')

  -- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle & MySQL
----------------------------------------------------------------------------------------------------------------

-- if we do not use order by in over(), we do not get running total, just normal aggregate for all rows within that partition

select employee_id, count(*) over(partition by team_id) as team_size
from Employee
order by 1

-- Solution with CTE and grouping
/* Write your PL/SQL query statement below */
WITH team_size_tbl AS(
    SELECT e2.team_id, COUNT(e2.employee_id) AS team_count
    FROM employee e2
    GROUP BY e2.team_id
)
SELECT e1.employee_id, tst.team_count AS team_size
FROM employee e1, team_size_tbl tst
WHERE e1.team_id = tst.team_id
-- amazon- 1
