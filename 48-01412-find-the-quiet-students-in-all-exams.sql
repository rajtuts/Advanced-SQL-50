1412. Find the Quiet Students in All Exams

Table: Student

+---------------------+---------+
| Column Name         | Type    |
+---------------------+---------+
| student_id          | int     |
| student_name        | varchar |
+---------------------+---------+
student_id is the primary key (column with unique values) for this table.
student_name is the name of the student.

 

Table: Exam

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| exam_id       | int     |
| student_id    | int     |
| score         | int     |
+---------------+---------+
(exam_id, student_id) is the primary key (combination of columns with unique values) for this table.
Each row of this table indicates that the student with student_id had a score points in the exam with id exam_id.

 

A quiet student is the one who took at least one exam and did not score the highest or the lowest score.

Write a solution to report the students (student_id, student_name) being quiet in all exams. Do not return the student who has never taken any exam.

Return the result table ordered by student_id.

The result format is in the following example.

 

Example 1:

Input: 
Student table:
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 1           | Daniel        |
| 2           | Jade          |
| 3           | Stella        |
| 4           | Jonathan      |
| 5           | Will          |
+-------------+---------------+
Exam table:
+------------+--------------+-----------+
| exam_id    | student_id   | score     |
+------------+--------------+-----------+
| 10         |     1        |    70     |
| 10         |     2        |    80     |
| 10         |     3        |    90     |
| 20         |     1        |    80     |
| 30         |     1        |    70     |
| 30         |     3        |    80     |
| 30         |     4        |    90     |
| 40         |     1        |    60     |
| 40         |     2        |    70     |
| 40         |     4        |    80     |
+------------+--------------+-----------+
Output: 
+-------------+---------------+
| student_id  | student_name  |
+-------------+---------------+
| 2           | Jade          |
+-------------+---------------+
Explanation: 
For exam 1: Student 1 and 3 hold the lowest and high scores respectively.
For exam 2: Student 1 hold both highest and lowest score.
For exam 3 and 4: Studnet 1 and 4 hold the lowest and high scores respectively.
Student 2 and 5 have never got the highest or lowest in any of the exams.
Since student 5 is not taking any exam, he is excluded from the result.
So, we only return the information of Student 2.

-- SQL Schema

Create table If Not Exists Student (student_id int, student_name varchar(30))
Create table If Not Exists Exam (exam_id int, student_id int, score int)
Truncate table Student
insert into Student (student_id, student_name) values ('1', 'Daniel')
insert into Student (student_id, student_name) values ('2', 'Jade')
insert into Student (student_id, student_name) values ('3', 'Stella')
insert into Student (student_id, student_name) values ('4', 'Jonathan')
insert into Student (student_id, student_name) values ('5', 'Will')
Truncate table Exam
insert into Exam (exam_id, student_id, score) values ('10', '1', '70')
insert into Exam (exam_id, student_id, score) values ('10', '2', '80')
insert into Exam (exam_id, student_id, score) values ('10', '3', '90')
insert into Exam (exam_id, student_id, score) values ('20', '1', '80')
insert into Exam (exam_id, student_id, score) values ('30', '1', '70')
insert into Exam (exam_id, student_id, score) values ('30', '3', '80')
insert into Exam (exam_id, student_id, score) values ('30', '4', '90')
insert into Exam (exam_id, student_id, score) values ('40', '1', '60')
insert into Exam (exam_id, student_id, score) values ('40', '2', '70')
insert into Exam (exam_id, student_id, score) values ('40', '4', '80')
    
-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle & MySQL
----------------------------------------------------------------------------------------------------------------

-- CTE1- find highest rank and lowest rank in 2 separate columns using dense_rank()
-- CTE2- get the list of students in CTE1
-- CTE3- get the list of students who took exams but are not in CTE2
-- final query- output id and name of students in CTE3

with CTE1 as 
    (select exam_id, student_id, score, 
        dense_rank() over(partition by exam_id order by score desc) rank_highest,
        dense_rank() over(partition by exam_id order by score asc) rank_lowest
    from Exam),
    CTE2 as
    (select student_id 
    from CTE1
    where rank_highest = 1 or rank_lowest = 1),
    CTE3 as
    (select distinct student_id
    from Exam 
    where student_id not in (select * from CTE2))

select student_id, student_name 
from Student
where student_id in (select * from CTE3)
order by 1

--------------------------------------------------------------------------------------------------------------------------------------------------------
-- CTE- find highest rank and lowest rank in 2 separate columns using dense_rank()
-- pull student_id from Exam table- note that student_id is not primary key, so use distnct
-- pull name from Student table
-- use Exam as left table because we don't want students who didn't take any exams
-- use WHERE condition not in-> CTE
  
with CTE as 
    (select exam_id, student_id, score, 
        dense_rank() over(partition by exam_id order by score desc) rank_highest,
        dense_rank() over(partition by exam_id order by score asc) rank_lowest
    from Exam)

select distinct e.student_id, s.student_name
from Exam e
left join Student s
on e.student_id = s.student_id
where e.student_id not in
    (select student_id 
    from CTE
    where rank_highest = 1 or rank_lowest = 1)
order by 1


-- no companies listed
