1783. Grand Slam Titles

Table: Players

+----------------+---------+
| Column Name    | Type    |
+----------------+---------+
| player_id      | int     |
| player_name    | varchar |
+----------------+---------+
player_id is the primary key (column with unique values) for this table.
Each row in this table contains the name and the ID of a tennis player.

 

Table: Championships

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| year          | int     |
| Wimbledon     | int     |
| Fr_open       | int     |
| US_open       | int     |
| Au_open       | int     |
+---------------+---------+
year is the primary key (column with unique values) for this table.
Each row of this table contains the IDs of the players who won one each tennis tournament of the grand slam.

 

Write a solution to report the number of grand slam tournaments won by each player. Do not include the players who did not win any tournament.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Players table:
+-----------+-------------+
| player_id | player_name |
+-----------+-------------+
| 1         | Nadal       |
| 2         | Federer     |
| 3         | Novak       |
+-----------+-------------+
Championships table:
+------+-----------+---------+---------+---------+
| year | Wimbledon | Fr_open | US_open | Au_open |
+------+-----------+---------+---------+---------+
| 2018 | 1         | 1       | 1       | 1       |
| 2019 | 1         | 1       | 2       | 2       |
| 2020 | 2         | 1       | 2       | 2       |
+------+-----------+---------+---------+---------+
Output: 
+-----------+-------------+-------------------+
| player_id | player_name | grand_slams_count |
+-----------+-------------+-------------------+
| 2         | Federer     | 5                 |
| 1         | Nadal       | 7                 |
+-----------+-------------+-------------------+
Explanation: 
Player 1 (Nadal) won 7 titles: Wimbledon (2018, 2019), Fr_open (2018, 2019, 2020), US_open (2018), and Au_open (2018).
Player 2 (Federer) won 5 titles: Wimbledon (2020), US_open (2019, 2020), and Au_open (2019, 2020).
Player 3 (Novak) did not win anything, we did not include them in the result table.

-- SQL Schema
Create table If Not Exists Players (player_id int, player_name varchar(20))
Create table If Not Exists Championships (year int, Wimbledon int, Fr_open int, US_open int, Au_open int)
Truncate table Players
insert into Players (player_id, player_name) values ('1', 'Nadal')
insert into Players (player_id, player_name) values ('2', 'Federer')
insert into Players (player_id, player_name) values ('3', 'Novak')
Truncate table Championships
insert into Championships (year, Wimbledon, Fr_open, US_open, Au_open) values ('2018', '1', '1', '1', '1')
insert into Championships (year, Wimbledon, Fr_open, US_open, Au_open) values ('2019', '1', '1', '2', '2')
insert into Championships (year, Wimbledon, Fr_open, US_open, Au_open) values ('2020', '2', '1', '2', '2')

-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle
----------------------------------------------------------------------------------------------------------------
with CTE as 
    (select Wimbledon as id
    from Championships
    union all
    select Fr_open as id
    from Championships
    union all
    select US_open as id
    from Championships
    union all
    select Au_open as id
    from Championships)

select c.id as player_id, p.player_name, count(c.id) as grand_slams_count
from CTE c 
join Players p
on c.id = p.player_id
group by c.id, p.player_name
    
----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------

-- beginner level solution
-- all player ids in a single column, count those, join with Players for name

with CTE as 
    (select Wimbledon as id
    from Championships
    union all
    select Fr_open as id
    from Championships
    union all
    select US_open as id
    from Championships
    union all
    select Au_open as id
    from Championships)

select c.id as player_id, p.player_name, count(c.id) as grand_slams_count
from CTE c 
join Players p
on c.id = p.player_id
group by 1

------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- using cross join
-- using aggregate function because we want to group by each player
-- using cross join, we are getting all players and all championships
-- so we use having to filter only those players who have won at least 1

select p.player_id, p.player_name,
    sum(case when p.player_id = c.Wimbledon then 1 else 0 end +
        case when p.player_id = c.Fr_open then 1 else 0 end +
        case when p.player_id = c.US_open then 1 else 0 end +
        case when p.player_id = c.Au_open then 1 else 0 end) as grand_slams_count
from Players p 
cross join Championships c
group by p.player_id
having grand_slams_count > 0


-- amazon- 1
