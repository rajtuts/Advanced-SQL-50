-- 1440. Evaluate Boolean Expression


-- Table Variables:
-- 
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | name          | varchar |
-- | value         | int     |
-- +---------------+---------+
-- In SQL, name is the primary key for this table.
-- This table contains the stored variables and their values.
-- 
--  
-- 
-- Table Expressions:
-- 
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | left_operand  | varchar |
-- | operator      | enum    |
-- | right_operand | varchar |
-- +---------------+---------+
-- In SQL, (left_operand, operator, right_operand) is the primary key for this table.
-- This table contains a boolean expression that should be evaluated.
-- operator is an enum that takes one of the values ('<', '>', '=')
-- The values of left_operand and right_operand are guaranteed to be in the Variables table.
-- 
--  
-- 
-- Evaluate the boolean expressions in Expressions table.
-- 
-- Return the result table in any order.
-- 
-- The result format is in the following example.
-- 
--  
-- 
-- Example 1:
-- 
-- Input: 
-- Variables table:
-- +------+-------+
-- | name | value |
-- +------+-------+
-- | x    | 66    |
-- | y    | 77    |
-- +------+-------+
-- Expressions table:
-- +--------------+----------+---------------+
-- | left_operand | operator | right_operand |
-- +--------------+----------+---------------+
-- | x            | >        | y             |
-- | x            | <        | y             |
-- | x            | =        | y             |
-- | y            | >        | x             |
-- | y            | <        | x             |
-- | x            | =        | x             |
-- +--------------+----------+---------------+
-- Output: 
-- +--------------+----------+---------------+-------+
-- | left_operand | operator | right_operand | value |
-- +--------------+----------+---------------+-------+
-- | x            | >        | y             | false |
-- | x            | <        | y             | true  |
-- | x            | =        | y             | false |
-- | y            | >        | x             | true  |
-- | y            | <        | x             | false |
-- | x            | =        | x             | true  |
-- +--------------+----------+---------------+-------+
-- Explanation: 
-- As shown, you need to find the value of each boolean expression in the table using the variables table.
-- 
-- SCHEMA:
Create Table If Not Exists Variables (name varchar(3), value int)
Create Table If Not Exists Expressions (left_operand varchar(3), operator ENUM('>', '<', '='), right_operand varchar(3))
Truncate table Variables
insert into Variables (name, value) values ('x', '66')
insert into Variables (name, value) values ('y', '77')
Truncate table Expressions
insert into Expressions (left_operand, operator, right_operand) values ('x', '>', 'y')
insert into Expressions (left_operand, operator, right_operand) values ('x', '<', 'y')
insert into Expressions (left_operand, operator, right_operand) values ('x', '=', 'y')
insert into Expressions (left_operand, operator, right_operand) values ('y', '>', 'x')
insert into Expressions (left_operand, operator, right_operand) values ('y', '<', 'x')
insert into Expressions (left_operand, operator, right_operand) values ('x', '=', 'x')


-- Sotion:
-- Oracle
select 
        a.left_operand, 
        a.operator, 
        a.right_operand,
        case
            when operator = '>' then (case when (b.value > c.value) then 'true' else 'false' end)
            when operator = '=' then (case when (b.value = c.value) then 'true' else 'false' end)
            when operator = '<' then (case when (b.value < c.value) then 'true' else 'false' end)
        end value
from expressions a inner join variables b on a.left_operand = b.name
                    inner join variables c on a.right_operand = c.name
    
-- MySQL    
-- create 2 value tables- l for left operand, r for right operand
-- use join to join it to the main table
-- write case statements using l.value and r.value

select e.left_operand, e.operator, e.right_operand,
    (case when operator = '>' and l.value > r.value then 'true'
    when operator = '<' and l.value < r.value then 'true'
    when operator = '=' and l.value = r.value then 'true'
    else 'false' end) as value
from Expressions e
join Variables l
on l.name = e.left_operand
join Variables r
on r.name = right_operand

-- point72-1 
