1795. Rearrange Products Table


Table: Products

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| product_id  | int     |
| store1      | int     |
| store2      | int     |
| store3      | int     |
+-------------+---------+
product_id is the primary key (column with unique values) for this table.
Each row in this table indicates the product's price in 3 different stores: store1, store2, and store3.
If the product is not available in a store, the price will be null in that store's column.

 

Write a solution to rearrange the Products table so that each row has (product_id, store, price). If a product is not available in a store, do not include a row with that product_id and store combination in the result table.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
Products table:
+------------+--------+--------+--------+
| product_id | store1 | store2 | store3 |
+------------+--------+--------+--------+
| 0          | 95     | 100    | 105    |
| 1          | 70     | null   | 80     |
+------------+--------+--------+--------+
Output: 
+------------+--------+-------+
| product_id | store  | price |
+------------+--------+-------+
| 0          | store1 | 95    |
| 0          | store2 | 100   |
| 0          | store3 | 105   |
| 1          | store1 | 70    |
| 1          | store3 | 80    |
+------------+--------+-------+
Explanation: 
Product 0 is available in all three stores with prices 95, 100, and 105 respectively.
Product 1 is available in store1 with price 70 and store3 with price 80. The product is not available in store2.

-- SQL Schema
Create table If Not Exists Products (product_id int, store1 int, store2 int, store3 int)
Truncate table Products
insert into Products (product_id, store1, store2, store3) values ('0', '95', '100', '105')
insert into Products (product_id, store1, store2, store3) values ('1', '70', 'None', '80')

-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle
----------------------------------------------------------------------------------------------------------------
-- 1. using UNION
    
SELECT product_id, 
    'store1' as store,
    store1 as price
FROM products where store1 is not null
UNION 
SELECT product_id, 
    'store2' as store,
    store2 as price
FROM products where store2 is not null
UNION
SELECT product_id, 
    'store3' as store,
    store3 as price
FROM products where store3 is not null

-- 2. Using UNPIVOT

SELECT * FROM Products
UNPIVOT(
    price   -- unpivot_clause
    FOR store  --  unpivot_for_clause
    IN ( -- unpivot_in_clause
        store1  AS 'store1', 
        store2  AS 'store2', 
        store3  AS 'store3'
    )
)

----------------------------------------------------------------------------------------------------------------
-- MySQL
----------------------------------------------------------------------------------------------------------------

-- beginner solution- using unions
-- create a table without nulls

select product_id, 'store1' as store, store1 as price
from Products
where store1 is not null
union
select product_id, 'store2' as store, store2 as price
from Products
where store2 is not null
union
select product_id, 'store3' as store, store3 as price
from Products
where store3 is not null

---------------------------------------------------------------------------------------------------------------------------------------------------------
-- create a table with nulls, then filter out rows without nulls

select product_id, store, price
from
    (select product_id, 'store1' as store, store1 as price
    from Products
    union 
    select product_id, 'store2' as store, store2 as price
    from Products
    union
    select product_id, 'store3' as store, store3 as price
    from Products) t
where price is not null


-- bloomberg- 2
-- apple- 2
-- amazon- 1
