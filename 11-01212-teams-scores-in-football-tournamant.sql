## 1212. Team Scores in Football Tournament
-- Table: Teams    
--     
-- +---------------+----------+    
-- | Column Name   | Type     |    
-- +---------------+----------+    
-- | team_id       | int      |    
-- | team_name     | varchar  |    
-- +---------------+----------+    
-- team_id is the column with unique values of this table.    
-- Each row of this table represents a single football team.    
--     
--      
--     
-- Table: Matches    
--     
-- +---------------+---------+    
-- | Column Name   | Type    |    
-- +---------------+---------+    
-- | match_id      | int     |    
-- | host_team     | int     |    
-- | guest_team    | int     |     
-- | host_goals    | int     |    
-- | guest_goals   | int     |    
-- +---------------+---------+    
-- match_id is the column of unique values of this table.    
-- Each row is a record of a finished match between two different teams.     
-- Teams host_team and guest_team are represented by their IDs in the Teams table (team_id), and they scored host_goals and guest_goals goals, respectively.    
--     
--      
-- You would like to compute the scores of all teams after all matches. Points are awarded as follows:    
--     
--     A team receives three points if they win a match (i.e., Scored more goals than the opponent team).    
--     A team receives one point if they draw a match (i.e., Scored the same number of goals as the opponent team).    
--     A team receives no points if they lose a match (i.e., Scored fewer goals than the opponent team).    
--     
-- Write a solution that selects the team_id, team_name and num_points of each team in the tournament after all described matches.    
--     
-- Return the result table ordered by num_points in decreasing order. In case of a tie, order the records by team_id in increasing order.    
--     
-- The result format is in the following example.    
--     
--      
--     
-- Example 1:    
--     
-- Input:     
-- Teams table:    
-- +-----------+--------------+    
-- | team_id   | team_name    |    
-- +-----------+--------------+    
-- | 10        | Leetcode FC  |    
-- | 20        | NewYork FC   |    
-- | 30        | Atlanta FC   |    
-- | 40        | Chicago FC   |    
-- | 50        | Toronto FC   |    
-- +-----------+--------------+    
-- Matches table:    
-- +------------+--------------+---------------+-------------+--------------+    
-- | match_id   | host_team    | guest_team    | host_goals  | guest_goals  |    
-- +------------+--------------+---------------+-------------+--------------+    
-- | 1          | 10           | 20            | 3           | 0            |    
-- | 2          | 30           | 10            | 2           | 2            |    
-- | 3          | 10           | 50            | 5           | 1            |    
-- | 4          | 20           | 30            | 1           | 0            |    
-- | 5          | 50           | 30            | 1           | 0            |    
-- +------------+--------------+---------------+-------------+--------------+    
-- Output:     
-- +------------+--------------+---------------+    
-- | team_id    | team_name    | num_points    |    
-- +------------+--------------+---------------+    
-- | 10         | Leetcode FC  | 7             |    
-- | 20         | NewYork FC   | 3             |    
-- | 50         | Toronto FC   | 3             |    
-- | 30         | Atlanta FC   | 1             |    
-- | 40         | Chicago FC   | 0             |    
-- +------------+--------------+---------------+    
--     
-- SQL Schema:    
Create table If Not Exists Teams (team_id int, team_name varchar(30))
Create table If Not Exists Matches (match_id int, host_team int, guest_team int, host_goals int, guest_goals int)
Truncate table Teams
insert into Teams (team_id, team_name) values ('10', 'Leetcode FC')
insert into Teams (team_id, team_name) values ('20', 'NewYork FC')
insert into Teams (team_id, team_name) values ('30', 'Atlanta FC')
insert into Teams (team_id, team_name) values ('40', 'Chicago FC')
insert into Teams (team_id, team_name) values ('50', 'Toronto FC')
Truncate table Matches
insert into Matches (match_id, host_team, guest_team, host_goals, guest_goals) values ('1', '10', '20', '3', '0')
insert into Matches (match_id, host_team, guest_team, host_goals, guest_goals) values ('2', '30', '10', '2', '2')
insert into Matches (match_id, host_team, guest_team, host_goals, guest_goals) values ('3', '10', '50', '5', '1')
insert into Matches (match_id, host_team, guest_team, host_goals, guest_goals) values ('4', '20', '30', '1', '0')
insert into Matches (match_id, host_team, guest_team, host_goals, guest_goals) values ('5', '50', '30', '1', '0')  

-- union all- one for host(when that team was host)- count host score, 2nd for guest(when that team was guest)- count guest score
-- calculate sum of points
-- group by team_id

-- SOLUTION:
-------------------------------------------------------------------------------------------------------------------------
-- Oracle
-------------------------------------------------------------------------------------------------------------------------
/* Write your PL/SQL query statement below */

select n.team_id, n.team_name, sum(n.num_points) num_points
from 
(select team_id , team_name, 
sum(case when host_goals<guest_goals then 3 
     when host_goals=guest_goals then 1 
     else 0 end) num_points
from Teams t left join matches m
on t.team_id = m.guest_team
group by team_id,team_name
union all
select team_id, team_name,
sum((case when host_goals>guest_goals then 3 
     when host_goals=guest_goals then 1 
     else 0 end)) num_points
from Teams t left join matches m
on t.team_id = m.host_team
group by team_id,team_name) n
group by team_id,n.team_name
order by num_points desc,team_id asc

-- without using 'UNION ALL'- only used JOIN
select t.team_id, t.team_name, coalesce(
    sum(case when t.team_id = m.host_team and m.host_goals > m.guest_goals then 3
             when t.team_id = m.guest_team and m.guest_goals > m.host_goals then 3
             when host_goals = guest_goals then 1 end), 0) as num_points
from Teams t
left join Matches m
on m.host_team = t.team_id or m.guest_team = t.team_id
group by t.team_id, t.team_name
order by 3 desc, 1 asc
-------------------------------------------------------------------------------------------------------------------------
-- MySQL
-------------------------------------------------------------------------------------------------------------------------
select t.team_id, t.team_name, coalesce(sum(u.points), 0) as num_points
from Teams t
left join
    (select match_id, host_team as team_id, (case when host_goals > guest_goals then 3
                when host_goals = guest_goals then 1
                else 0 end) as points
    from Matches
    union all
    select match_id, guest_team as team_id,
                (case when host_goals < guest_goals then 3
                when host_goals = guest_goals then 1
                else 0 end) as points
    from Matches) u
on u.team_id = t.team_id
group by team_id
order by 3 desc, 1 asc

-------------------------------------------------------------------------------------------------------------------------
-- without using 'UNION ALL'- only used JOIN

select t.team_id, t.team_name, coalesce(
    sum(case when t.team_id = m.host_team and m.host_goals > m.guest_goals then 3
             when t.team_id = m.guest_team and m.guest_goals > m.host_goals then 3
             when host_goals = guest_goals then 1 end), 0) as num_points
from Teams t
left join Matches m
on m.host_team = t.team_id or m.guest_team = t.team_id
group by team_id
order by 3 desc, 1 asc


-- wayfair- 1
