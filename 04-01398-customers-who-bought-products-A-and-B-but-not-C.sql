-- 1398. Customers Who Bought Products A and B but Not C
-- Table: Customers
-- 
-- +---------------------+---------+
-- | Column Name         | Type    |
-- +---------------------+---------+
-- | customer_id         | int     |
-- | customer_name       | varchar |
-- +---------------------+---------+
-- customer_id is the column with unique values for this table.
-- customer_name is the name of the customer.
-- 
--  
-- 
-- Table: Orders
-- 
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | order_id      | int     |
-- | customer_id   | int     |
-- | product_name  | varchar |
-- +---------------+---------+
-- order_id is the column with unique values for this table.
-- customer_id is the id of the customer who bought the product "product_name".
-- 
--  
-- 
-- Write a solution to report the customer_id and customer_name of customers who bought products "A", "B" but did not buy the product "C" since we want to recommend them to purchase this product.
-- 
-- Return the result table ordered by customer_id.
-- 
-- The result format is in the following example.
-- 
--  
-- 
-- Example 1:
-- 
-- Input: 
-- Customers table:
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 1           | Daniel        |
-- | 2           | Diana         |
-- | 3           | Elizabeth     |
-- | 4           | Jhon          |
-- +-------------+---------------+
-- Orders table:
-- +------------+--------------+---------------+
-- | order_id   | customer_id  | product_name  |
-- +------------+--------------+---------------+
-- | 10         |     1        |     A         |
-- | 20         |     1        |     B         |
-- | 30         |     1        |     D         |
-- | 40         |     1        |     C         |
-- | 50         |     2        |     A         |
-- | 60         |     3        |     A         |
-- | 70         |     3        |     B         |
-- | 80         |     3        |     D         |
-- | 90         |     4        |     C         |
-- +------------+--------------+---------------+
-- Output: 
-- +-------------+---------------+
-- | customer_id | customer_name |
-- +-------------+---------------+
-- | 3           | Elizabeth     |
-- +-------------+---------------+
-- Explanation: Only the customer_id with id 3 bought the product A and B but not the product C.
-- 
-- Schema:
Create table If Not Exists Customers (customer_id int, customer_name varchar(30))
Create table If Not Exists Orders (order_id int, customer_id int, product_name varchar(30))
Truncate table Customers
insert into Customers (customer_id, customer_name) values ('1', 'Daniel')
insert into Customers (customer_id, customer_name) values ('2', 'Diana')
insert into Customers (customer_id, customer_name) values ('3', 'Elizabeth')
insert into Customers (customer_id, customer_name) values ('4', 'Jhon')
Truncate table Orders
insert into Orders (order_id, customer_id, product_name) values ('10', '1', 'A')
insert into Orders (order_id, customer_id, product_name) values ('20', '1', 'B')
insert into Orders (order_id, customer_id, product_name) values ('30', '1', 'D')
insert into Orders (order_id, customer_id, product_name) values ('40', '1', 'C')
insert into Orders (order_id, customer_id, product_name) values ('50', '2', 'A')
insert into Orders (order_id, customer_id, product_name) values ('60', '3', 'A')
insert into Orders (order_id, customer_id, product_name) values ('70', '3', 'B')
insert into Orders (order_id, customer_id, product_name) values ('80', '3', 'D')
insert into Orders (order_id, customer_id, product_name) values ('90', '4', 'C')

-- SOLUTION: summing up all products, choosing those customers that only has A and B as > 0 and C = 0
-- Oracle
select customer_id, customer_name
from Customers c
where customer_id in (
    select customer_id from Orders where product_name='A'
intersect select customer_id from Orders where product_name='B'
minus select customer_id from Orders where product_name='C'
)  order by 1;

-- MYSQL
select o.customer_id, c.customer_name
from
    (select order_id, customer_id, 
    sum(product_name='A') as A,
    sum(product_name='B') as B,
    sum(product_name='C') as C 
    from Orders 
    group by customer_id) o
left join Customers c
on c.customer_id = o.customer_id
where A > 0 and B > 0 and C = 0
order by 1

-------------------------------------------------------------------------------------------------------------------------------------------------
-- group_concat() approach- unique approach- my first thought
-- group all products per customer, choose customers with only A and B but not c
  
select  customer_id, customer_name
from
    (
        select o.order_id, o.customer_id, c.customer_name, group_concat(o.product_name order by product_name) as group_products
    from Orders o left join Customers c
    on o.customer_id = c.customer_id
    group by c.customer_id
    ) temp1
where group_products like '%A%B%' and group_products not like '%A%B%C%'
  
-------------------------------------------------------------------------------------------------------------------------------------------------
-- longer version of the 1st one
  
select o.customer_id, c.customer_name
from
    (select order_id, customer_id, 
    sum(case when product_name='A' then 1 else 0 end) as A,
    sum(case when product_name='B' then 1 else 0 end) as B,
    sum(case when product_name='C' then 1 else 0 end) as C 
    from Orders 
    group by customer_id) o
left join Customers c
on c.customer_id = o.customer_id
where A > 0 and B > 0 and C = 0
order by 1

-------------------------------------------------------------------------------------------------------------------------------------------------
-- much simpler version of the 1st one
  
select o.customer_id, c.customer_name
from Orders o
left join Customers c
on c.customer_id = o.customer_id
group by o.customer_id
having sum(product_name='A') > 0 and sum(product_name='B') > 0 and sum(product_name='C') = 0
order by 1


-- amazon- 2
-- facebook- 1
