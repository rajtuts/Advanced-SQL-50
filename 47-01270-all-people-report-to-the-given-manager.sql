1270. All People Report to the Given Manager
Table: Employees

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| employee_id   | int     |
| employee_name | varchar |
| manager_id    | int     |
+---------------+---------+
employee_id is the column of unique values for this table.
Each row of this table indicates that the employee with ID employee_id and name employee_name reports his work to his/her direct manager with manager_id
The head of the company is the employee with employee_id = 1.

 

Write a solution to find employee_id of all employees that directly or indirectly report their work to the head of the company.

The indirect relation between managers will not exceed three managers as the company is small.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Employees table:
+-------------+---------------+------------+
| employee_id | employee_name | manager_id |
+-------------+---------------+------------+
| 1           | Boss          | 1          |
| 3           | Alice         | 3          |
| 2           | Bob           | 1          |
| 4           | Daniel        | 2          |
| 7           | Luis          | 4          |
| 8           | Jhon          | 3          |
| 9           | Angela        | 8          |
| 77          | Robert        | 1          |
+-------------+---------------+------------+
Output: 
+-------------+
| employee_id |
+-------------+
| 2           |
| 77          |
| 4           |
| 7           |
+-------------+
Explanation: 
The head of the company is the employee with employee_id 1.
The employees with employee_id 2 and 77 report their work directly to the head of the company.
The employee with employee_id 4 reports their work indirectly to the head of the company 4 --> 2 --> 1. 
The employee with employee_id 7 reports their work indirectly to the head of the company 7 --> 4 --> 2 --> 1.
The employees with employee_id 3, 8, and 9 do not report their work to the head of the company directly or indirectly. 

-- SQL schema
Create table If Not Exists Employees (employee_id int, employee_name varchar(30), manager_id int)
Truncate table Employees
insert into Employees (employee_id, employee_name, manager_id) values ('1', 'Boss', '1')
insert into Employees (employee_id, employee_name, manager_id) values ('3', 'Alice', '3')
insert into Employees (employee_id, employee_name, manager_id) values ('2', 'Bob', '1')
insert into Employees (employee_id, employee_name, manager_id) values ('4', 'Daniel', '2')
insert into Employees (employee_id, employee_name, manager_id) values ('7', 'Luis', '4')
insert into Employees (employee_id, employee_name, manager_id) values ('8', 'John', '3')
insert into Employees (employee_id, employee_name, manager_id) values ('9', 'Angela', '8')
insert into Employees (employee_id, employee_name, manager_id) values ('77', 'Robert', '1')

-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle & MySQL
----------------------------------------------------------------------------------------------------------------
    
    

-- innermost layer will give- 2, 77 because they directly report to 1
-- second layer will give- 4 because he reports to 2
-- outermost layer will give 7 because he reports to 4
-- so first table- 7
-- 2nd table- 4
-- 3rd table- 2, 77

select employee_id
from Employees
where manager_id in
    (select employee_id
    from Employees
    where manager_id in
        (select employee_id
        from Employees
        where manager_id = 1 and employee_id != 1))
union
select employee_id
    from Employees
    where manager_id in
        (select employee_id
        from Employees
        where manager_id = 1 and employee_id != 1)
union
select employee_id
from Employees
where manager_id = 1 and employee_id != 1

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- using join
-- tier1 is immediate reportees of 1- 2, 77
-- tier 2 has 1 layer between them and 1- tier1.employee_id = Employee.manager_id- 4
-- tier3 has 2 layers between them and 1- tier2.emplpoyee_id = Employee.manager_id- 7

with tier1 as 
    (select e.employee_id
    from Employees e
    where manager_id = 1 and e.employee_id != 1),
    tier2 as
    (select e.employee_id
    from Employees e
    join tier1 t1
    on t1.employee_id = e.manager_id),
    tier3 as
    (select e.employee_id
    from Employees e
    join tier2 t2
    on t2.employee_id = e.manager_id)

select employee_id 
from tier1
union
select employee_id
from tier2
union
select employee_id
from tier3

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- using 2 joins 
  
select e1.employee_id
from Employees e1
join Employees e2
on e1.manager_id = e2.employee_id
join Employees e3
on e2.manager_id = e3.employee_id
where e3.manager_id = 1 and e1.employee_id != 1


-- adobe- 2
-- google- 1

-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- NOT A SOLUTION- ONLY EXPLANATION- JOINS

select e1.employee_id as e1emp, e1.manager_id as e1man, e2.employee_id as e2emp, e2.manager_id as e2man, e3.employee_id as e3emp, e3.manager_id as e3man
from Employees e1
join Employees e2
on e1.manager_id = e2.employee_id
join Employees e3
on e2.manager_id = e3.employee_id

-- logic- o/p e1emp
-- e1man = e2emp, e2man = e3emp, e3man = 1, e1emp != 1
-- we are outputting employee != 1 and ultimate manager = 1

| e1emp | e1man | e2emp | e2man | e3emp | e3man |
| ----- | ----- | ----- | ----- | ----- | ----- |
| 4     | 2     | 2     | 1     | 1     | 1     |
| 1     | 1     | 1     | 1     | 1     | 1     |
| 2     | 1     | 1     | 1     | 1     | 1     |
| 77    | 1     | 1     | 1     | 1     | 1     |
| 9     | 8     | 8     | 3     | 3     | 3     |
| 3     | 3     | 3     | 3     | 3     | 3     |
| 8     | 3     | 3     | 3     | 3     | 3     |
| 7     | 4     | 4     | 2     | 2     | 1     |

