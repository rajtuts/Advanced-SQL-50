-- 1445. Apples & Oranges

Table: Sales

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| sale_date     | date    |
| fruit         | enum    | 
| sold_num      | int     | 
+---------------+---------+
(sale_date, fruit) is the primary key (combination of columns with unique values) of this table.
This table contains the sales of "apples" and "oranges" sold each day.

 

Write a solution to report the difference between the number of apples and oranges sold each day.

Return the result table ordered by sale_date.

The result format is in the following example.

 

Example 1:

Input: 
Sales table:
+------------+------------+-------------+
| sale_date  | fruit      | sold_num    |
+------------+------------+-------------+
| 2020-05-01 | apples     | 10          |
| 2020-05-01 | oranges    | 8           |
| 2020-05-02 | apples     | 15          |
| 2020-05-02 | oranges    | 15          |
| 2020-05-03 | apples     | 20          |
| 2020-05-03 | oranges    | 0           |
| 2020-05-04 | apples     | 15          |
| 2020-05-04 | oranges    | 16          |
+------------+------------+-------------+
Output: 
+------------+--------------+
| sale_date  | diff         |
+------------+--------------+
| 2020-05-01 | 2            |
| 2020-05-02 | 0            |
| 2020-05-03 | 20           |
| 2020-05-04 | -1           |
+------------+--------------+
Explanation: 
Day 2020-05-01, 10 apples and 8 oranges were sold (Difference  10 - 8 = 2).
Day 2020-05-02, 15 apples and 15 oranges were sold (Difference 15 - 15 = 0).
Day 2020-05-03, 20 apples and 0 oranges were sold (Difference 20 - 0 = 20).
Day 2020-05-04, 15 apples and 16 oranges were sold (Difference 15 - 16 = -1).

-- SQL Schema
Create table If Not Exists Sales (sale_date date, fruit ENUM('apples', 'oranges'), sold_num int)
Truncate table Sales
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-01', 'apples', '10')
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-01', 'oranges', '8')
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-02', 'apples', '15')
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-02', 'oranges', '15')
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-03', 'apples', '20')
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-03', 'oranges', '0')
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-04', 'apples', '15')
insert into Sales (sale_date, fruit, sold_num) values ('2020-05-04', 'oranges', '16')
  
-- simple aggregate with condition
-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle
----------------------------------------------------------------------------------------------------------------
select to_char(s.sale_date,'YYYY-MM-DD') sale_date,
((select s1.sold_num from sales s1 where s1.fruit='apples'
and s.sale_date=s1.sale_date) - (select s2.sold_num from sales s2 where s2.fruit='oranges' and s.sale_date=s2.sale_date)) diff
from sales s
group by sale_date
order by sale_date

----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------
select sale_date, (sum(case when fruit = 'apples' then sold_num else 0 end) - 
                  sum(case when fruit = 'oranges' then sold_num else 0 end)) as diff
from Sales
group by 1
order by 1

---------------------------------------------------------------------------------------------------------------  
-- using join- 1 table for apples, 1 for oranges, join on sales date

select sa.sale_date, (ifnull(sum(sa.sold_num),0)-ifnull(sum(so.sold_num), 0)) as diff
from Sales sa
join Sales so
on sa.sale_date = so.sale_date and sa.fruit = 'apples' and so.fruit = 'oranges'
group by 1
order by 1


-- facebook- 1
