1747. Leetflex Banned Accounts
Table: LogInfo

+-------------+----------+
| Column Name | Type     |
+-------------+----------+
| account_id  | int      |
| ip_address  | int      |
| login       | datetime |
| logout      | datetime |
+-------------+----------+
This table may contain duplicate rows.
The table contains information about the login and logout dates of Leetflex accounts. It also contains the IP address from which the account was logged in and out.
It is guaranteed that the logout time is after the login time.

 

Write a solution to find the account_id of the accounts that should be banned from Leetflex. An account should be banned if it was logged in at some moment from two different IP addresses.

Return the result table in any order.

The result format is in the following example.

 

Example 1:

Input: 
LogInfo table:
+------------+------------+---------------------+---------------------+
| account_id | ip_address | login               | logout              |
+------------+------------+---------------------+---------------------+
| 1          | 1          | 2021-02-01 09:00:00 | 2021-02-01 09:30:00 |
| 1          | 2          | 2021-02-01 08:00:00 | 2021-02-01 11:30:00 |
| 2          | 6          | 2021-02-01 20:30:00 | 2021-02-01 22:00:00 |
| 2          | 7          | 2021-02-02 20:30:00 | 2021-02-02 22:00:00 |
| 3          | 9          | 2021-02-01 16:00:00 | 2021-02-01 16:59:59 |
| 3          | 13         | 2021-02-01 17:00:00 | 2021-02-01 17:59:59 |
| 4          | 10         | 2021-02-01 16:00:00 | 2021-02-01 17:00:00 |
| 4          | 11         | 2021-02-01 17:00:00 | 2021-02-01 17:59:59 |
+------------+------------+---------------------+---------------------+
Output: 
+------------+
| account_id |
+------------+
| 1          |
| 4          |
+------------+
Explanation: 
Account ID 1 --> The account was active from "2021-02-01 09:00:00" to "2021-02-01 09:30:00" with two different IP addresses (1 and 2). It should be banned.
Account ID 2 --> The account was active from two different addresses (6, 7) but in two different times.
Account ID 3 --> The account was active from two different addresses (9, 13) on the same day but they do not intersect at any moment.
Account ID 4 --> The account was active from "2021-02-01 17:00:00" to "2021-02-01 17:00:00" with two different IP addresses (10 and 11). It should be banned.

-- SQL Schema
Create table If Not Exists LogInfo (account_id int, ip_address int, login datetime, logout datetime)
Truncate table LogInfo
insert into LogInfo (account_id, ip_address, login, logout) values ('1', '1', '2021-02-01 09:00:00', '2021-02-01 09:30:00')
insert into LogInfo (account_id, ip_address, login, logout) values ('1', '2', '2021-02-01 08:00:00', '2021-02-01 11:30:00')
insert into LogInfo (account_id, ip_address, login, logout) values ('2', '6', '2021-02-01 20:30:00', '2021-02-01 22:00:00')
insert into LogInfo (account_id, ip_address, login, logout) values ('2', '7', '2021-02-02 20:30:00', '2021-02-02 22:00:00')
insert into LogInfo (account_id, ip_address, login, logout) values ('3', '9', '2021-02-01 16:00:00', '2021-02-01 16:59:59')
insert into LogInfo (account_id, ip_address, login, logout) values ('3', '13', '2021-02-01 17:00:00', '2021-02-01 17:59:59')
insert into LogInfo (account_id, ip_address, login, logout) values ('4', '10', '2021-02-01 16:00:00', '2021-02-01 17:00:00')
insert into LogInfo (account_id, ip_address, login, logout) values ('4', '11', '2021-02-01 17:00:00', '2021-02-01 17:59:59')

-- Solution
----------------------------------------------------------------------------------------------------------------
--Oracle & MySQL
----------------------------------------------------------------------------------------------------------------
-- join 

select distinct l1.account_id
from LogInfo l1 
join LogInfo l2
on l1.account_id = l2.account_id
and l1.ip_address != l2.ip_address
and l1.login between l2.login and l2.logout

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- self join- more popular answer on LC
  
select distinct l1.account_id
from LogInfo l1, LogInfo l2
where l1.account_id = l2.account_id
and l1.ip_address != l2.ip_address
and l1.login between l2.login and l2.logout


-- amazon- 1

------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- NOT WORKING FOR THIS CASE:

-- | account_id | ip_address | login               | logout              |
-- | ---------- | ---------- | ------------------- | ------------------- |
-- | 1          | 1          | 2021-02-01 09:00:00 | 2021-02-01 15:00:00 |
-- | 1          | 1          | 2021-02-01 10:00:00 | 2021-02-01 11:00:00 |
-- | 1          | 6          | 2021-02-01 12:00:00 | 2021-02-01 13:00:00 |

-- HERE 1ST AND THIRD OVERLAPS, BUT LEAD() DOESN'T CATCH THAT

with CTE as 
     (
        select account_id, ip_address, login, logout, 
        lead(login) over(partition by account_id order by login) as next_login,
        lead(ip_address) over(partition by account_id order by login) as next_ip
    from LogInfo
    )

select distinct account_id 
from CTE 
where next_login between login and logout
and next_ip != ip_address



