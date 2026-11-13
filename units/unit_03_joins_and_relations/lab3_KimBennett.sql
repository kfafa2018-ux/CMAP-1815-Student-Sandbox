/*2. Applied SQL Laboratory Challenges & Starter Script (Graded Submission — 100 Points)
Unit 3 Student Lab Guide: Multi-Table Relational Integration & Anomaly Audits
Lab Objective
In this lab, you will:

Connect multiple normalized tables using ANSI SQL INNER JOIN and table aliases.
Chain three and four tables together to reconstruct complex business transactions.
Apply LEFT JOIN to prevent silent data loss in catalog and directory reports.
Execute the Anti-Join pattern to isolate business anomalies (unsold products, unstaffed facilities, customers without orders).
Submission Instructions
Open your personal GitHub Codespace.
Create a file named lab3_yourname.sql.
Ensure every query uses UPPERCASE keywords, places JOIN and ON clauses on separate lines, and qualifies every column with its table alias (e.g. e.first_name, l.city).
Test all queries against your PostgreSQL database to guarantee error-free execution.
Commit and push your code to your repository.



/*Lab Challenges
Part 1: Two-Table INNER JOINs & Disambiguation (25 Points)
Staff Regional Roster: Join employees and locations. 
Retrieve the employee's first_name, last_name, title, and the city and state of their assigned 
location. Sort by state ascending, then by last_name ascending.
Headquarters Staff Directory: Modify Challenge 1 to display only 
employees assigned to facilities in the state of 'WY'. Project full_name (combined), department, city, and facility_type.
Order Ownership Audit: Join orders and employees. Retrieve order_id,
 order_date, status, and the full name of the employee who processed 
 the order (first_name || ' ' || last_name AS processed_by). Sort by order_date descending.*/

--Selecting features fromt he employees and locations tables. 
SELECT 
    e.first_name
    ,e.last_name
    ,e.title
    ,l.city
    ,l.state
--Assigning aliases to the tables for easier reference in the query.
FROM employees AS e
--INNER JOIN is used to combine rows from two tables based on a related column between them. 
--In this case, we are joining the employees table to the locations table using the location_id column as the common key.
INNER JOIN locations AS l
--ON clause specifies the condition for the join, which is that the location_id column
--in the employees table must match the location_id column in the locations table.
ON e.location_id = l.location_id
--Sorting the results by state in ascending order and last name in ascending order.
ORDER BY l.state ASC, e.last_name ASC;






/*Part 2: Multi-Table Transaction Reconstructions (30 Points)
Order Line Subtotals (3 Tables): Join orders, order_lines, and products. Display:
o.order_id
o.order_date
p.product_name
p.category
ol.quantity
ol.unit_price
A calculated column line_subtotal (ol.quantity * ol.unit_price)
Sort by order_id ascending, then by line_subtotal descending.*/

SELECT o.order_id
    ,o.order_date
    ,p.product_name
    ,p.category
    ,ol.quantity
    ,ol.unit_price
    --Calculating the line subtotal by multiplying the quantity and unit price from the order_lines table.
    ,(ol.quantity * ol.unit_price) AS line_subtotal
--Assigning aliases to the tables for easier reference in the query.
FROM orders AS o
--INNER JOIN is used to combine rows from two or more tables based on a related column between them. In this case, we are joining
--the orders table to the order_lines table using the order_id column as the common key, and then joining the order_lines table to 
--the products table using the product_id column as the common key.
INNER JOIN order_lines AS ol
--ON clause specifies the condition for the join, which is that the order_id column
--in the orders table must match the order_id column in the order_lines table.
ON o.order_id = ol.order_id
INNER JOIN products AS p
--ON clause specifies the condition for the join, which is that the product_id column
--in the order_lines table must match the product_id column in the products table.
ON ol.product_id = p.product_id
--Filtering for line items strictly greater than $150.00.
--The alias can't be used in WHERE, so the full expression is repeated.
WHERE (ol.quantity * ol.unit_price) > 150.00
--Sorting the results by order_id in ascending order and line_subtotal in descending order.
ORDER BY o.order_id ASC, line_subtotal DESC;

/*High-Value Item Sales: Using the 3-table join from Challenge 4, filter for individual line items where 
the line_subtotal is strictly greater than $150.00. Order from highest subtotal to lowest.
Full Operational Audit Trail (4 Tables): Trace transactions from the sales rep's physical
 office all the way to the line item. Join locations → employees → orders → order_lines. Display:
o.order_id
l.city AS sales_office_city
e.last_name AS employee_last_name
ol.quantity
ol.unit_price
Filter for orders with status = 'Completed'. Sort by order_id ascending.*/

--Selecting features from the locations, employees, orders, and order_lines tables using
--INNER JOINs to trace transactions from the sales rep's physical office to the line item.
SELECT o.order_id
    ,l.city AS sales_office_city
    ,e.last_name AS employee_last_name
    ,ol.quantity        
    ,ol.unit_price
--Assigning aliases to the tables for easier reference in the query.
FROM locations AS l
--INNER JOIN is used to combine rows from two or more tables based on a related column between them. 
--In this case, we are joining the locations table to the employees table using the location_id column as the common key,
--then joining the employees table to the orders table using the employee_id column
-- as the common key, and finally joining the orders table to the order_lines table using the order_id column as the common key.
INNER JOIN employees AS e
--ON clause specifies the condition for the join, which is that the location_id column
--in the locations table must match the location_id column in the employees table.  
ON l.location_id = e.location_id
INNER JOIN orders AS o
--ON clause specifies the condition for the join, which is that the employee_id column
--in the employees table must match the employee_id column in the orders table.
ON e.employee_id = o.employee_id
INNER JOIN order_lines AS ol
--ON clause specifies the condition for the join, which is that the order_id column
--in the orders table must match the order_id column in the order_lines table.
ON o.order_id = ol.order_id
--Filtering the results to only include orders with status = 'Completed'.
WHERE o.status = 'Completed'
--Sorting the results by order_id in ascending order.
ORDER BY o.order_id ASC;







/*Part 3: Outer Joins & Data Loss Prevention (25 Points)
Complete Inventory Visibility: Write a query that lists ALL products in the database alongside 
any order line items, using a LEFT JOIN from products to order_lines. Display p.product_id, p.product_name,
 p.stock_quantity, ol.order_id, and ol.quantity. Notice the NULL values for products that have never been purchased!


--Selecting features from the products table and order_lines table using a LEFT JOIN to include
-- all products, even those without associated order line items.
SELECT p.product_id
    ,p.product_name
    ,p.stock_quantity
    ,ol.order_id
    ,ol.quantity
--COALESCE replaces NULL with 0 for products that have never been ordered. I did this for good practice, but it is not required for the lab.
    ,COALESCE(ol.quantity, 0) AS quantity
--Assigning aliases to the tables for easier reference in the query.
FROM products AS p
--LEFT JOIN is used to combine rows from two tables, returning all rows from the left table
--(products) and the matched rows from the right table (order_lines). If there is no match, NULL values will be returned for the right table's columns.
LEFT JOIN order_lines AS ol
--ON clause specifies the condition for the join, which is that the product_id column
--in the products table must match the product_id column in the order_lines table.
ON p.product_id = ol.product_id;



Locations Staffing Overview: Write a query using a LEFT JOIN from locations to employees that shows every facility in the
 company and any employees assigned to it. Display l.city, l.facility_type, e.first_name, and e.last_name. Sort by l.city ascending.*/

--Listing every facility and any employees assigned to it.
--LEFT JOIN from locations keeps all locations, even those with no employees.
SELECT l.city
    ,l.facility_type
    ,e.first_name
    ,e.last_name
FROM locations AS l
LEFT JOIN employees AS e
ON l.location_id = e.location_id
ORDER BY l.city ASC;




/*Part 4: Anomaly Audits via Anti-Joins (20 Points)
Dead Inventory Detection (The Anti-Join): Write an Anti-Join query to find all products that have NEVER appeared in 
any customer order. Display p.product_id, p.sku, p.product_name, p.stock_quantity, and p.retail_price. Order by stock_quantity 
descending to highlight tied-up warehouse capital.*/


SELECT p.product_id
    ,p.sku
    ,p.product_name
    ,p.stock_quantity
    ,p.retail_price
--Assigning aliases to the tables for easier reference in the query.
FROM products AS p
--LEFT JOIN is used to combine rows from two tables, returning all rows from the left table
--(products) and the matched rows from the right table (order_lines). If there is   no match,
-- NULL values will be returned for the right table's columns.
LEFT JOIN order_lines AS ol
--ON clause specifies the condition for the join, which is that the product_id column
--in the products table must match the product_id column in the order_lines table.
ON p.product_id = ol.product_id
--Filtering the results to only include products that have never appeared in any customer order 
--by checking for NULL values in the order_id column of the order_lines table.
WHERE ol.order_id IS NULL
--Sorting the results by stock_quantity in descending order to highlight tied-up warehouse capital.
ORDER BY p.stock_quantity DESC;

/*Unstaffed Facility Audit: Write an Anti-Join query against locations and employees to find facilities that currently
 have zero employees assigned. Display l.location_id, l.city, l.state, and l.facility_type.*/

SELECT l.location_id
    ,l.city
    ,l.state
    ,l.facility_type
--Locations is the left table so every facility is kept, matched or not.
FROM locations AS l
--Match each location to the employees assigned to it.
LEFT JOIN employees AS e
ON l.location_id = e.location_id
--A NULL employee_id means no employee matched, so the facility is unstaffed.
WHERE e.employee_id IS NULL;







/*
====================================================================
CMAP 1815 - Unit 3: In-Class Active Learning Challenges
Session Hands-on Practice
====================================================================

Instructions:
Work with your assigned lab partner. Ensure all SQL keywords are 
in UPPERCASE, table aliases are short and meaningful, and every projected 
column is explicitly prefixed (e.g. e.first_name, l.city).
*/
/* Joins in SQL (work very much like copy pasting rows and columns in Excel, or VLOOKUP)
A join combines rows from two tables based on a relationship between them, usually a foreign key 
matching a primary key. The join types differ in what happens to rows that have no match.

INNER JOIN keeps only rows that match in both tables. Unmatched rows from either side are dropped.
LEFT JOIN (or LEFT OUTER JOIN) keeps every row from the left table, plus matches from the right.
 Where there’s no match, the right-side columns come back as NULL.

RIGHT JOIN is the mirror image: every row from the right table, matches from the left. It’s rarely used, 
because you can get the same result by swapping the table order and using LEFT JOIN.

FULL OUTER JOIN keeps every row from both tables. Matches are paired up, and anything unmatched 
on either side appears with NULLs for the other table’s columns. It’s useful for finding mismatches in both directions, for example comparing two lists.

CROSS JOIN pairs every row of one table with every row of the other (a Cartesian product), 
with no ON condition. With 8 locations and 28 employees you’d get 224 rows. It’s useful for generating combinations, 
but it’s usually a bug when it happens by accident, such as forgetting the ON clause.

Self join isn’t a separate keyword. It’s a table joined to itself using aliases, to compare rows within the same table:*/

-- ==================================================================
-- CHALLENGE 1: Staff Facility Directory (2-Table INNER JOIN)
-- ==================================================================
-- Management needs a list of all employees and the facility details 
-- of their primary assignment.
-- Write a query joining 'employees' and 'locations' that displays:
--   - e.first_name, e.last_name
--   - e.department
--   - l.city
--   - l.state
--   - l.facility_type
-- Sort by l.state ascending, then by e.last_name ascending.

--using SELECT count * will tell you how many rows a data table has before you start joining tables together.
--This is a good way to check that after you join, it was a one to one join and you didn't accidentally create a cartesian product.

SELECT --Here we are joining the employees table to the locations table using the location_id column as the common key.
-- We are selecting the first name, last name, department, city, state, and facility type of each employee and their corresponding location. The results will be ordered by state and last name.
e.first_name 
,e.last_name
,e.department
,l.city
,l.state
,l.facility_type
--Assigning aliases to the tables for easier reference in the query.
FROM employees AS e
INNER JOIN locations AS l
--Joining the employees table to the locations table using the location_id column as the common key by specifying the ON clause.
ON e.location_id = l.location_id
--Sorting the results by state and last name in ascending order.
ORDER BY l.state ASC, e.last_name ASC;




-- ==================================================================
-- CHALLENGE 2: Order Revenue Itemization (3-Table INNER JOIN)
-- ==================================================================
-- Reconstruct detailed sales records by joining 'orders', 'order_lines', 
-- and 'products'.
-- Display:
--   - o.order_id
--   - o.order_date
--   - p.product_name
--   - ol.quantity
--   - ol.unit_price
--   - A calculated column 'item_subtotal' (quantity * unit_price)
-- Filter for orders placed in the year 2023 or later.
-- Sort by o.order_id ascending, then by item_subtotal descending.


SELECT o.order_id--Here we are joining the orders table to the order_lines table using the order_id column
-- as the common key, and then joining the order_lines table to the products table using the product_id column
-- as the common key. We are selecting the order_id, order_date, product_name, quantity, unit_price, and a calculated
-- column item_subtotal (quantity * unit_price) for each order. The results will be filtered for orders placed in the year 
-- 2023 or later and sorted by order_id ascending and item_subtotal descending.
    ,o.order_date
    ,p.product_name
    ,ol.quantity
    ,ol.unit_price
    --Calculating the item subtotal by multiplying the quantity and unit price from the order_lines table.
    ,(ol.quantity * ol.unit_price) AS item_subtotal
--Assigning aliases to the tables for easier reference in the query.
FROM orders AS o
--INNER JOIN is used to combine rows from two or more tables based on a related column between them.
-- In this case, we are joining the orders table to the order_lines table using the order_id column as the common key.
INNER JOIN order_lines AS ol
--ON clause specifies the condition for the join, which is that the order_id column 
--in the orders table must match the order_id column in the order_lines table. This works just like Excel's
-- VLOOKUP function, where you are looking up the order_id in the order_lines table based on the order_id in the orders table.
--Or how you copy paste from one spreadsheet to another and the data is matched up based on a common column.
ON o.order_id = ol.order_id
--Joining the order_lines table to the products table using the product_id column as the common key.
INNER JOIN products AS p
--ON clause specifies the condition for the join, which is that the product_id column
--in the order_lines table must match the product_id column in the products table. 
ON ol.product_id = p.product_id
--Filtering the results to only include orders placed in the year 2023 or later.
WHERE o.order_date >= '2023-01-01'
--Sorting the results by order_id ascending and item_subtotal descending.
ORDER BY o.order_id ASC, item_subtotal DESC;




-- ==================================================================
-- CHALLENGE 3: Complete Product Catalog Audit (LEFT JOIN)
-- ==================================================================
-- The merchandising team wants to view ALL products, along with any 
-- order line items associated with them.
-- Use a LEFT JOIN from 'products' to 'order_lines'.
-- Display:
--   - p.product_id
--   - p.product_name
--   - p.stock_quantity
--   - ol.order_id
--   - ol.quantity
-- Notice which products return NULL for order_id and quantity!

--Selecting features from the products table and order_lines table using a LEFT JOIN to include all products, even those without associated order line items.
SELECT p.product_id
    ,p.product_name
    ,p.stock_quantity
    ,ol.order_id
    ,ol.quantity
--Assigning aliases to the tables for easier reference in the query.
FROM products AS p
--LEFT JOIN is used to combine rows from two tables, returning all rows from the left table
--(products) and the matched rows from the right table (order_lines). If there is no match,
-- NULL values will be returned for the right table's columns.
--One to many relationship between products and order_lines, where each product can have multiple order line items,
-- but not all products may have been sold.
LEFT JOIN order_lines AS ol
--ON clause specifies the condition for the join, which is that the product_id column
--in the products table must match the product_id column in the order_lines table.
ON p.product_id = ol.product_id;




-- ==================================================================
-- CHALLENGE 4: Dead Inventory Anomaly Detection (The ANTI-JOIN)
-- ==================================================================
-- Find all products in our catalog that have NEVER been sold in an order.
-- Combine a LEFT JOIN with a WHERE clause checking for NULL.
-- Display:
--   - p.product_id
--   - p.sku
--   - p.product_name
--   - p.stock_quantity
--   - p.retail_price
-- Order by stock_quantity descending (identifying highest capital tied up).

--Selecting features from the products table using a LEFT JOIN to find products that have never been sold in an order.
SELECT p.product_id
    ,p.sku
    ,p.product_name
    ,p.stock_quantity
    ,p.retail_price
    ,ol.order_id
--Assigning aliases to the tables for easier reference in the query.
FROM products AS p
--LEFT JOIN is used to combine rows from two tables, returning all rows from the left table 
--(products) and the matched rows from the right table (order_lines). If there is no match,
-- NULL values will be returned for the right table's columns.
LEFT JOIN order_lines AS ol 
--ON clause specifies the condition for the join, which is that the product_id column
--in the products table must match the product_id column in the order_lines table.
ON p.product_id = ol.product_id
--Filtering the results to only include products that have never been sold in an order by checking for NULL values in the order_id column of the order_lines table.
WHERE ol.order_id IS NULL
--Sorting the results by stock_quantity in descending order to identify products with the highest capital tied up.
ORDER BY p.stock_quantity DESC;

--using * to check how many rows are returned in the result set is a good way to check that your query is working as expected. 
--If you expect a certain number of products to have never been sold, you can use SELECT COUNT(*) to verify that the number of rows returned
-- matches your expectations
SELECT COUNT(*) AS unsold_product_count
--Assigning an alias to the count result for easier reference in the query.
FROM products AS p
--LEFT JOIN is used to combine rows from two tables, returning all rows from the left table
--(products) and the matched rows from the right table (order_lines). 
--If there is no match, NULL values will be returned for the right table's columns.
LEFT JOIN order_lines AS ol
--ON clause specifies the condition for the join, which is that the product_id column
--in the products table must match the product_id column in the order_lines table.
ON p.product_id = ol.product_id
--Filtering the results to only include products that have never been sold in an order by checking for NULL values in the order_id column
-- of the order_lines table.
WHERE ol.order_id IS NULL;




-- ==================================================================
-- CHALLENGE 5: Four-Table Executive Sales Trail
-- ==================================================================
-- Trace an order completely from sales rep facility to line item.
-- Join: locations -> employees -> orders -> order_lines
-- Display:
--   - o.order_id
--   - l.city AS sales_office_city
--   - e.last_name AS rep_last_name
--   - ol.quantity
--   - ol.unit_price
-- Filter for orders with status = 'Completed'.
-- Sort by o.order_id ASC.

--Selecting features from the locations, employees, orders, and order_lines tables using INNER JOINs to trace an order completely from sales
-- rep facility to line item.
SELECT o.order_id
    ,l.city AS sales_office_city
    ,e.last_name AS rep_last_name
    ,ol.quantity
    ,ol.unit_price  
    JOIN locations AS l
--INNER JOIN is used to combine rows from two or more tables based on a related column between them. In this case, we are joining the locations table to the employees table using the location_id column as the common key, then joining the employees table to the orders table using the employee_id column
-- as the common key, and finally joining the orders table to the order_lines table using the order_id column as the common key.
INNER JOIN employees AS e
--ON clause specifies the condition for the join, which is that the location_id column
--in the locations table must match the location_id column in the employees table.
ON l.location_id = e.location_id
INNER JOIN orders AS o
--ON clause specifies the condition for the join, which is that the employee_id column
--in the employees table must match the employee_id column in the orders table.
ON e.employee_id = o.employee_id
INNER JOIN order_lines AS ol
--ON clause specifies the condition for the join, which is that the order_id column
--in the orders table must match the order_id column in the order_lines table.
ON o.order_id = ol.order_id
--Filtering the results to only include orders with status = 'Completed'.
WHERE o.status = 'Completed'
--Sorting the results by order_id in ascending order.
ORDER BY o.order_id ASC;
