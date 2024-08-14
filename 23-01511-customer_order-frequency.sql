-- 1511. Customer Order Frequency

Table: Customers

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| customer_id   | int     |
| name          | varchar |
| country       | varchar |
+---------------+---------+
customer_id is the column with unique values for this table.
This table contains information about the customers in the company.

 

Table: Product

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| product_id    | int     |
| description   | varchar |
| price         | int     |
+---------------+---------+
product_id is the column with unique values for this table.
This table contains information on the products in the company.
price is the product cost.

 

Table: Orders

+---------------+---------+
| Column Name   | Type    |
+---------------+---------+
| order_id      | int     |
| customer_id   | int     |
| product_id    | int     |
| order_date    | date    |
| quantity      | int     |
+---------------+---------+
order_id is the column with unique values for this table.
This table contains information on customer orders.
customer_id is the id of the customer who bought "quantity" products with id "product_id".
Order_date is the date in format ('YYYY-MM-DD') when the order was shipped.

 

Write a solution to report the customer_id and customer_name of customers who have spent at least $100 in each month of June and July 2020.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Customers table:
+--------------+-----------+-------------+
| customer_id  | name      | country     |
+--------------+-----------+-------------+
| 1            | Winston   | USA         |
| 2            | Jonathan  | Peru        |
| 3            | Moustafa  | Egypt       |
+--------------+-----------+-------------+
Product table:
+--------------+-------------+-------------+
| product_id   | description | price       |
+--------------+-------------+-------------+
| 10           | LC Phone    | 300         |
| 20           | LC T-Shirt  | 10          |
| 30           | LC Book     | 45          |
| 40           | LC Keychain | 2           |
+--------------+-------------+-------------+
Orders table:
+--------------+-------------+-------------+-------------+-----------+
| order_id     | customer_id | product_id  | order_date  | quantity  |
+--------------+-------------+-------------+-------------+-----------+
| 1            | 1           | 10          | 2020-06-10  | 1         |
| 2            | 1           | 20          | 2020-07-01  | 1         |
| 3            | 1           | 30          | 2020-07-08  | 2         |
| 4            | 2           | 10          | 2020-06-15  | 2         |
| 5            | 2           | 40          | 2020-07-01  | 10        |
| 6            | 3           | 20          | 2020-06-24  | 2         |
| 7            | 3           | 30          | 2020-06-25  | 2         |
| 9            | 3           | 30          | 2020-05-08  | 3         |
+--------------+-------------+-------------+-------------+-----------+
Output: 
+--------------+------------+
| customer_id  | name       |  
+--------------+------------+
| 1            | Winston    |
+--------------+------------+
Explanation: 
Winston spent $300 (300 * 1) in June and $100 ( 10 * 1 + 45 * 2) in July 2020.
Jonathan spent $600 (300 * 2) in June and $20 ( 2 * 10) in July 2020.
Moustafa spent $110 (10 * 2 + 45 * 2) in June and $0 in July 2020.

-- SQL Schema
Create table If Not Exists Customers (customer_id int, name varchar(30), country varchar(30))
Create table If Not Exists Product (product_id int, description varchar(30), price int)

Create table If Not Exists Orders (order_id int, customer_id int, product_id int, order_date date, quantity int)

Truncate table Customers
insert into Customers (customer_id, name, country) values ('1', 'Winston', 'USA')
insert into Customers (customer_id, name, country) values ('2', 'Jonathan', 'Peru')
insert into Customers (customer_id, name, country) values ('3', 'Moustafa', 'Egypt')
Truncate table Product
insert into Product (product_id, description, price) values ('10', 'LC Phone', '300')
insert into Product (product_id, description, price) values ('20', 'LC T-Shirt', '10')
insert into Product (product_id, description, price) values ('30', 'LC Book', '45')
insert into Product (product_id, description, price) values ('40', 'LC Keychain', '2')
Truncate table Orders
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('1', '1', '10', '2020-06-10', '1')
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('2', '1', '20', '2020-07-01', '1')
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('3', '1', '30', '2020-07-08', '2')
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('4', '2', '10', '2020-06-15', '2')
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('5', '2', '40', '2020-07-01', '10')
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('6', '3', '20', '2020-06-24', '2')
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('7', '3', '30', '2020-06-25', '2')
insert into Orders (order_id, customer_id, product_id, order_date, quantity) values ('9', '3', '30', '2020-05-08', '3')
    
-- we need customer ids from 2 separate tables using 'and' condition
-- 1st table- get sum of expenditures of all customers in June 2020, filter by customers whose sum >= 100
-- 2nd table- get sum of expenditures of all customers in July 2020, filter by customers whose sum >= 100
-- pull all customers who are in table1 AND table 2

-- Solution:
-- Oracle 
select x.customer_id, c.name
from (
    select customer_id, month, sum(py) pyt
    from (
        select customer_id, to_char(order_date, 'YYYY-MM') month, price * quantity py
        from Orders o
        inner join Product p
        on o.product_id = p.product_id
    )
    where month = '2020-06' or month = '2020-07'
    group by customer_id, month
) x
inner join Customers c
on x.customer_id = c.customer_id
where pyt >= 100
group by x.customer_id, c.name
having count(*) = 2
    
-- MySQL
select c.customer_id, c.name 
from Customers
where customer_id in
    (select customer_id
    from Orders o 
    join Product p
    on o.product_id = p.product_id
    where left(order_date, 7) = '2020-06'
    group by customer_id
    having sum(quantity*price) >= 100) 
 and customer_id in
    (select customer_id, sum(quantity*price)
    from Orders o 
    join Product p
    on o.product_id = p.product_id
    where left(order_date, 7) = '2020-07'
    group by customer_id
    having sum(quantity*price) >= 100)

---------------------------------------------------------------------------------------------------------------------

-- create a temp table- join all tables
-- create 2 additional columns- expenditure in June and in July- CASE, AGGREGATE
-- in the main query, pull customer ids where expenditure in both columns are >= 100

with CTE as(select c.customer_id, c.name, 
    sum(case when left(o.order_date, 7) = '2020-06' then p.price*o.quantity else 0 end) june_spent,
    sum(case when left(o.order_date, 7) = '2020-07' then p.price*o.quantity else 0 end) july_spent
from Customers c
join Orders o 
on c.customer_id = o.customer_id
join Product p
on p.product_id = o.product_id
group by 1)

select customer_id, name 
from CTE
where june_spent >= 100 and july_spent >= 100


-- amazon- 1
