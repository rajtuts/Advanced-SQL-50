-- 1112. Highest Grade For Each Student
-- Table: Enrollments
-- 
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | student_id    | int     |
-- | course_id     | int     |
-- | grade         | int     |
-- +---------------+---------+
-- (student_id, course_id) is the primary key (combination of columns with unique values) of this table.
-- grade is never NULL.
-- 
--  
-- 
-- Write a solution to find the highest grade with its corresponding course for each student. In case of a tie, you should find the course with the smallest course_id.
-- 
-- Return the result table ordered by student_id in ascending order.
-- 
-- The result format is in the following example.
-- 
--  
-- 
-- Example 1:
-- 
-- Input: 
-- Enrollments table:
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 2          | 2         | 95    |
-- | 2          | 3         | 95    |
-- | 1          | 1         | 90    |
-- | 1          | 2         | 99    |
-- | 3          | 1         | 80    |
-- | 3          | 2         | 75    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+
-- Output: 
-- +------------+-------------------+
-- | student_id | course_id | grade |
-- +------------+-----------+-------+
-- | 1          | 2         | 99    |
-- | 2          | 2         | 95    |
-- | 3          | 3         | 82    |
-- +------------+-----------+-------+
-- 
-- Schema:
Create table If Not Exists Enrollments (student_id int, course_id int, grade int)
Truncate table Enrollments
insert into Enrollments (student_id, course_id, grade) values ('2', '2', '95')
insert into Enrollments (student_id, course_id, grade) values ('2', '3', '95')
insert into Enrollments (student_id, course_id, grade) values ('1', '1', '90')
insert into Enrollments (student_id, course_id, grade) values ('1', '2', '99')
insert into Enrollments (student_id, course_id, grade) values ('3', '1', '80')
insert into Enrollments (student_id, course_id, grade) values ('3', '2', '75')
insert into Enrollments (student_id, course_id, grade) values ('3', '3', '82')

-- Solution
-- Oracle:
-- use RANK() and pull results where rank = 1
select student_id,  course_id, grade
from
    (select student_id, course_id, grade, dense_rank() over(partition by student_id order by grade desc, course_id asc) as rnk
    from Enrollments) temp1
where rnk = 1
order by 1

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- mysql
-- nested 
-- first get id and highest grade, then get min course_id

select student_id, min(course_id) as course_id, grade
from Enrollments
where (student_id, grade) in
    (select student_id, max(grade) as grade
    from Enrollments
    group by student_id)
group by student_id
order by student_id

-- amazon- 2
-- coursera- 1
select student_id,  course_id, grade
from
    (select student_id, course_id, grade, dense_rank() over(partition by student_id order by grade desc, course_id asc) as rnk
    from Enrollments) temp1
where rnk = 1
order by 1

--------------------------------------------------------------------------------------------------------------------------------------------------------------
-- nested 
-- first get id and highest grade, then get min course_id

select student_id, min(course_id) as course_id, grade
from Enrollments
where (student_id, grade) in
    (select student_id, max(grade) as grade
    from Enrollments
    group by student_id)
group by student_id
order by student_id

-- amazon- 2
-- coursera- 1
