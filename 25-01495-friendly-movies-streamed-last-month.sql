-- 1495. Friendly Movies Streamed Last Month
Table: TVProgram

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| program_date  | date    |
| content_id    | int     |
| channel       | varchar |
+---------------+---------+
(program_date, content_id) is the primary key (combination of columns with unique values) for this table.
This table contains information of the programs on the TV.
content_id is the id of the program in some channel on the TV.

 

Table: Content

+------------------+---------+
| Column Name      | Type    |
+------------------+---------+
| content_id       | varchar |
| title            | varchar |
| Kids_content     | enum    |
| content_type     | varchar |
+------------------+---------+
content_id is the primary key (column with unique values) for this table.
Kids_content is an ENUM (category) of types ('Y', 'N') where: 
'Y' means is content for kids otherwise 'N' is not content for kids.
content_type is the category of the content as movies, series, etc.

 

Write a solution to report the distinct titles of the kid-friendly movies streamed in June 2020.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
TVProgram table:
+--------------------+--------------+-------------+
| program_date       | content_id   | channel     |
+--------------------+--------------+-------------+
| 2020-06-10 08:00   | 1            | LC-Channel  |
| 2020-05-11 12:00   | 2            | LC-Channel  |
| 2020-05-12 12:00   | 3            | LC-Channel  |
| 2020-05-13 14:00   | 4            | Disney Ch   |
| 2020-06-18 14:00   | 4            | Disney Ch   |
| 2020-07-15 16:00   | 5            | Disney Ch   |
+--------------------+--------------+-------------+
Content table:
+------------+----------------+---------------+---------------+
| content_id | title          | Kids_content  | content_type  |
+------------+----------------+---------------+---------------+
| 1          | Leetcode Movie | N             | Movies        |
| 2          | Alg. for Kids  | Y             | Series        |
| 3          | Database Sols  | N             | Series        |
| 4          | Aladdin        | Y             | Movies        |
| 5          | Cinderella     | Y             | Movies        |
+------------+----------------+---------------+---------------+
Output: 
+--------------+
| title        |
+--------------+
| Aladdin      |
+--------------+
Explanation: 
"Leetcode Movie" is not a content for kids.
"Alg. for Kids" is not a movie.
"Database Sols" is not a movie
"Alladin" is a movie, content for kids and was streamed in June 2020.
"Cinderella" was not streamed in June 2020.

-- SWL Schema
  Create table If Not Exists TVProgram (program_date date, content_id int, channel varchar(30))
Create table If Not Exists Content (content_id varchar(30), title varchar(30), Kids_content ENUM('Y', 'N'), content_type varchar(30))
Truncate table TVProgram
insert into TVProgram (program_date, content_id, channel) values ('2020-06-10 08:00', '1', 'LC-Channel')
insert into TVProgram (program_date, content_id, channel) values ('2020-05-11 12:00', '2', 'LC-Channel')
insert into TVProgram (program_date, content_id, channel) values ('2020-05-12 12:00', '3', 'LC-Channel')
insert into TVProgram (program_date, content_id, channel) values ('2020-05-13 14:00', '4', 'Disney Ch')
insert into TVProgram (program_date, content_id, channel) values ('2020-06-18 14:00', '4', 'Disney Ch')
insert into TVProgram (program_date, content_id, channel) values ('2020-07-15 16:00', '5', 'Disney Ch')
Truncate table Content
insert into Content (content_id, title, Kids_content, content_type) values ('1', 'Leetcode Movie', 'N', 'Movies')
insert into Content (content_id, title, Kids_content, content_type) values ('2', 'Alg. for Kids', 'Y', 'Series')
insert into Content (content_id, title, Kids_content, content_type) values ('3', 'Database Sols', 'N', 'Series')
insert into Content (content_id, title, Kids_content, content_type) values ('4', 'Aladdin', 'Y', 'Movies')
insert into Content (content_id, title, Kids_content, content_type) values ('5', 'Cinderella', 'Y', 'Movies')
  


-- use DISTINCT because we want distinct titles
-- use where condition for filter

select distinct title
from Content c join TVProgram t
on c.content_id = t.content_id
where c.Kids_content = 'Y' and c.content_type = 'Movies' and t.program_date like '2020-06%'


-- amazon- 1
