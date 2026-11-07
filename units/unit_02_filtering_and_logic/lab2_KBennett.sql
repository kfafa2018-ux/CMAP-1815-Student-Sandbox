/*
====================================================================
CMAP 1815 - Unit 2: In-Class Active Learning Challenges
Session Hands-on Practice
====================================================================

Instructions:
Work with your assigned lab partner. Ensure all SQL keywords are 
in UPPERCASE, string literals are in single quotes, and OR conditions 
are guarded with parentheses.
*/

-- ==================================================================
-- CHALLENGE 1: Targeted Inventory Search
-- ==================================================================
-- A retail manager needs to audit warehouse stock.
-- Write a query against the 'products' table that retrieves:
--   1. product_name
--   2. category
--   3. retail_price
--   4. stock_quantity
-- Filter for products where:
--   - The retail price is between $30.00 and $150.00 (inclusive)
--   - AND the stock quantity is less than 50 units.
-- Order by stock_quantity ascending (lowest stock first).
SELECT product_name, category, retail_price, stock_quantity
    FROM products
/*filter means use the WHERE clause*/
/*Parenthesis for readability, and to specify the retail price*/
    WHERE (retail_price between 30.00 and 150.00) AND
    stock_quantity < 50;






-- ==================================================================
-- CHALLENGE 2: HR Tenure & Name Search
-- ==================================================================
-- The HR director is planning a recognition event.
-- Find all employees who:
--   1. Were hired before January 1, 2018 (hire_date < '2018-01-01')
--   2. AND whose last name starts with the letter 'M' or 'D' (use LIKE / ILIKE)
-- Display their first name, last name, department, and hire date.
-- Sort by hire_date from oldest to newest.

SELECT first_name, last_name, department, hire_date
    FROM employees
    /*use quotations around dates*/
    WHERE (hire_date < '2018-01-01')
    /*using ILIKE because it is not case sensitive*/
    /*%means list any characters after the m or d*/
    /*Ust parenthesis so the correct order of operations happens where OR is handled independently of the AND*/
    AND (last_name ILIKE 'm%' OR last_name ILIKE 'd%')
    /*Sort by hire date using ORDER BY and DESC*/
    ORDER BY hire_date DESC;







-- ==================================================================
-- CHALLENGE 3: The Missing Bonus Audit
-- ==================================================================
-- Management wants to identify full-time staff who did NOT receive 
-- an annual bonus, but earn a base salary of at least $60,000.
-- Write a query against 'employees' displaying:
--   - full_name (first and last combined)
--   - department
--   - salary
--   - bonus
-- Filter for bonus IS NULL and salary >= 60000.
-- Sort by salary descending.

/*selecting relevant features from employees, then displaying their bonus in the alias bonus*/
SELECT first_name || ' ' || last_name AS NAME,
    department,
    salary, 
    COALESCE (bonus, 0) AS bonus
    FROM employees
    /*COALESCE takes any bonus other than null or zero before the comma, for NULL or 0 values it then assigns them as 0*/
    WHERE NOT COALESCE (bonus, 0) = 0
    AND salary >= 60000
    ORDER BY salary DESC;




-- ==================================================================
-- CHALLENGE 4: Multi-Department High Earner Screen
-- ==================================================================
-- Retrieve all employees who:
--   - Work in either the 'Research' OR 'Engineering' departments
--   - AND earn an annual salary strictly greater than $90,000.
-- (CRITICAL: Make sure to wrap your OR condition in parentheses!)
-- Display first_name, last_name, department, and salary.
-- Sort by department alphabetically, then by salary descending.

SELECT first_name, last_name, department, salary
    FROM employees
    WHERE (department IN ('Research', 'Engineering' )) AND
    salary > 90000
    ORDER BY department ASC, salary DESC;




-- ==================================================================
-- CHALLENGE 5: Web Store Pagination Simulation
-- ==================================================================
-- You are writing the backend query for an e-commerce catalog page.
-- The user is viewing "Page 2" of the catalog.
-- Each page shows exactly 4 products per page.
-- Products must be sorted by retail_price from highest to lowest.
-- Write a query using LIMIT and OFFSET to return the 4 products for Page 2
-- (i.e. products ranked 5th through 8th in price).

SELECT * 
    FROM products
    ORDER BY retail_price DESC
    /*Limit 4 means only display 4 at a time, OFFSET 4 means move down 4 to get it to page 2*/
    LIMIT 4 OFFSET 4;

-- SQLBook: Code
/*Lab Challenges
Part 1: Numerical Boundaries & Inclusive Ranges (25 Points)
Premium Inventory: Write a query against products retrieving the product_name, retail_price, 
and stock_quantity for all items priced at or above $100.00. Sort from highest to lowest price.


Mid-Tier Catalog: Find all products whose retail_price is between $30.00 and $80.00 (inclusive).
 Display product_name, category, and retail_price. Sort by price ascending.


Critical Stock Alert: Management needs an urgent reorder list. 
Find all products where stock_quantity is strictly less than 25 units.
 Display product_name, stock_quantity, and category, sorted with the lowest inventory at the top.*/

/*Premium Inventory*/
SELECT product_name, retail_price, stock_quantity
FROM products
WHERE retail_price >= 100.00
ORDER BY retail_price DESC;

/*Mid-Tier Catalog*/
SELECT product_name, category, retail_price
FROM products
WHERE retail_price BETWEEN 30.00 AND 80.00
ORDER BY retail_price ASC;

/*Critical Stock Alert*/
SELECT product_name, stock_quantity, category
FROM products
WHERE stock_quantity < 25
ORDER BY stock_quantity ASC;




/*Part 2: Categorical Sets & Pattern Matching (25 Points)
Key Departments Roster: Retrieve the first_name, last_name, department, and salary for all employees who
 work in Research, Security, or Engineering. Sort by department alphabetically, then by salary descending.


Non-Technical Staff: Find all employees who do NOT work in Security, Engineering, or Research. Project their
 full_name (first and last concatenated) and their department. SKU Prefix Audit: Find all products whose sku starts
  with the prefix 'ELEC' using the LIKE operator. Display sku, product_name, and retail_price.


Description Keyword Search: Find all products where the description contains the word 
'heavy' (case-insensitive, matching 'Heavy', 'heavy', etc.) using ILIKE. Display product_name and description.*/

/*Key Departments Roster*/
SELECT first_name, last_name, department, salary
FROM employees
WHERE department IN ('Research', 'Security', 'Engineering')
ORDER BY department ASC, salary DESC;

/*Non-Technical Staff*/
SELECT first_name || ' ' || last_name AS full_name, department
FROM employees
WHERE department NOT IN ('Security', 'Engineering', 'Research');

/*SKU Prefix Audit*/
SELECT sku, product_name, retail_price
FROM products
WHERE sku LIKE 'ELEC%';

/*Description Keyword Search*/
SELECT product_name, description
FROM products
WHERE description ILIKE '%heavy%';


/*Part 3: Boolean Gates & Parentheses Discipline (25 Points)

Senior High-Earners: Find all employees who earn a salary of $80,000 or more AND were hired prior to January 1, 2018. 
Display first_name, last_name, salary, and hire_date.


The Branch Security/Sales Filter: Human Resources wants a list of staff in 
either Security OR Sales who also earn at least $60,000. *(CRITICAL: You must use parentheses to ensure that the salary filter applies 
to BOTH departments!)* Display last_name, department, and salary.


Active Operations Exception: Find all employees who work in Operations AND whose is_active status is TRUE, but whose
 salary is strictly less than $60,000.*/
 

/*Senior High-Earners*/
SELECT first_name, last_name, salary, hire_date
  FROM employees
  WHERE salary >= 80000
  AND hire_date < '2018-01-01';

/*The Branch Security/Sales Filter*/
SELECT last_name, department, salary
  FROM employees
  WHERE (department = 'Security' OR department = 'Sales')
  AND salary >= 60000;


/*Active Operations Exception*/
SELECT *
  FROM employees
  WHERE department = 'Operations'
  AND is_active = TRUE
  AND salary < 60000;

/*Part 4: The Mystery of NULL & Web Pagination (25 Points)
The Missing Bonus Report: Retrieve all employees whose bonus is currently missing (IS NULL). Display first_name, 
last_name, department, salary, and bonus. Order by salary descending.


Catalog Web Pagination (Page 2): Simulate pagination on an e-commerce website. 
Retrieve Page 2 of the product catalog where each page displays 5 products, ordered by retail_price descending.
*(Hint: Use LIMIT and OFFSET to skip the first 5 records and return the next 5).*/

/*The Missing Bonus Report*/
SELECT first_name, last_name, department, salary, bonus
FROM employees
WHERE bonus IS NULL
ORDER BY salary DESC;

/*Catalog Web Pagination (Page 2)*/
SELECT *
FROM products
ORDER BY retail_price DESC
LIMIT 5 OFFSET 5;
