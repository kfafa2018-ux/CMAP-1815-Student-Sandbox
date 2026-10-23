/* ============================================================================
   CMAP 1815: Introduction to Modern SQL
   Unit 1 Lab: Unit 01 Selection And Fundamentals

   Student Name: Kimberley Bennett
   Date:         10-22-2026
   Canvas Course: CMAP 1815
   ----------------------------------------------------------------------------
   Submission Rules:
   1. All SQL keywords MUST be uppercase (SELECT, FROM, WHERE, ORDER BY, AS).
   2. Every clause must begin on a new line.
   3. Always alias calculated expressions with meaningful snake_case names.
   4. Test every query against your live PostgreSQL database before turning in!
   5. Save this completed file as: lab1_yourlastname.sql
   ============================================================================ */


-- ==================================================================
-- PART 1: ENVIRONMENT & SYSTEM CATALOGS (20 Points)
-- ==================================================================

-- 1. Server Version: Write a query to display the exact
--    version of PostgreSQL running on your server.

/* States the exact version of PostgreSQL running */
SELECT version() AS server_version;


-- 2. Current Session: Write a query to display
--    your current active database user and the database name you are connected to.

/* States the current database and user */
SELECT current_database() AS database_name,
       CURRENT_USER AS session_user_name;


-- 3. Table Discovery: Query the information_schema.tables
--    catalog to list all base table names in the public schema,
--    sorted alphabetically by table name.

/* Lists all base table names in the public schema */
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'public'
  AND table_type = 'BASE TABLE'
ORDER BY table_name;


-- 4. Column Inspector: Query information_schema.columns
--    to find all column names and data types for the employees table, sorted by
--    ordinal_position.

/* Finds all column names and data types for the employees table */
SELECT column_name,
       data_type
FROM information_schema.columns
WHERE table_schema = 'public'
  AND table_name = 'employees'
ORDER BY ordinal_position;


-- ==================================================================
-- PART 2: PRECISION PROJECTION & DATA EXPLORATION (40 Points)
-- ==================================================================
--
-- Staff Directory: From the employees table, retrieve the first_name,
--  last_name, and title. Sort alphabetically by last_name.
-- Executive Compensation Roster: Retrieve the first_name,
--  last_name, and salary of all employees. Sort from highest paid to lowest paid.
-- Unique Departments: Write a query that returns a list of
--  all distinct departments in the company, sorted alphabetically from A to Z.
-- Department-Title Roster: Find all unique combinations of
--  department and title across the company. Order by department first, then by title.


-- Challenge 5: Staff Directory
-- From the 'employees' table, retrieve first_name, last_name, and title.
-- Sort alphabetically by last_name ASC.

/* Selects first_name, last_name, and title columns from the employees table */
SELECT first_name,
       last_name,
       title
/* Designates the datatable being used */
FROM employees
/* Orders the results by last_name in ascending order */
ORDER BY last_name ASC;


-- Challenge 6: Executive Compensation Roster
-- Retrieve first_name, last_name, and salary for all employees.
-- Sort from highest paid to lowest paid (DESC).

/* Selecting the first_name, last_name, and salary columns */
SELECT first_name,
       last_name,
       salary
/* Specifying the datatable I want my information from */
FROM employees
/* Ordering the results by salary in descending order */
ORDER BY salary DESC;


-- Challenge 7: Unique Departments
-- Write a query that returns a list of all distinct departments in the company,
-- sorted alphabetically from A to Z.

/* Returns only unique department categories from the employees datatable. */
SELECT DISTINCT department
FROM employees
/* Orders the results by department in ascending order (A-Z) */
ORDER BY department ASC;


-- Challenge 8: Department-Title Roster
-- Find all unique combinations of department and title across the company.
-- Order by department ASC, then by title ASC.

/* Selects unique combinations of department and title from the employees datatable */
SELECT DISTINCT department,
       title
/* Specifies the datatable being used */
FROM employees
/* Orders the results first by department in ascending order, then by title in ascending order */
ORDER BY department ASC,
         title ASC;


-- ==================================================================
-- PART 3: EXPRESSIONS, ALIASES & MATHEMATICAL PROJECTIONS (40 Points)
-- ==================================================================


-- Challenge 9: Polished Full Name with String Concatenation
-- Query 'employees' combining first_name and last_name into a single column
-- aliased as 'full_name' using string concatenation (||), along with their department.
-- Sort by department ASC, then by full_name ASC.

/* Selects the concatenated first_name and last_name as full_name, along with department from the employees datatable */
SELECT first_name || ' ' || last_name AS full_name,
       department
FROM employees
/* Orders the results first by department in ascending order, then by full_name in ascending order */
ORDER BY department ASC,
         full_name ASC;


-- Challenge 10: Bonus Simulation
-- Many employees receive an annual bonus. Query 'employees' displaying:
--   - last_name
--   - salary AS base_salary
--   - bonus AS annual_bonus
--   - salary + bonus AS total_compensation
-- (Observe what happens for employees with no bonus!)

/* Selects last_name, salary as base_salary, bonus as annual_bonus, and calculates total_compensation
   by adding salary and bonus from the employees datatable */
SELECT last_name,
       salary AS base_salary,
       bonus AS annual_bonus,
       salary + bonus AS total_compensation
FROM employees
/* Orders the results by last_name in ascending order */
ORDER BY last_name ASC;
/* Employees with no bonus will have NULL in the annual_bonus column, and total_compensation
   will also be NULL, because salary + NULL is NULL. */


-- Challenge 11: Retail Product Margins
-- From the 'products' table, retrieve:
--   - product_name
--   - retail_price
--   - cost_to_produce
--   - calculated column (retail_price - cost_to_produce) aliased as estimated_unit_profit
-- Sort so the most profitable products appear first (DESC).

/* Selects product_name, retail_price, cost_to_produce, and calculates estimated_unit_profit
   by subtracting cost_to_produce from retail_price from the products datatable */
SELECT product_name,
       retail_price,
       cost_to_produce,
       retail_price - cost_to_produce AS estimated_unit_profit
FROM products
/* Orders the results by estimated_unit_profit in descending order to show the most profitable products first */
ORDER BY estimated_unit_profit DESC;


-- Challenge 12: Total Inventory Value Analysis
-- From the 'products' table, project:
--   - product_name
--   - stock_quantity
--   - retail_price
--   - calculated column (stock_quantity * retail_price) aliased as total_inventory_value
-- Sort from highest inventory value to lowest (DESC).

/* Selects product_name, stock_quantity, retail_price, and calculates total_inventory_value
   by multiplying stock_quantity by retail_price from the products datatable */
SELECT product_name,
       stock_quantity,
       retail_price,
       stock_quantity * retail_price AS total_inventory_value
FROM products
/* Orders the results by total_inventory_value in descending order to show the highest inventory value first */
ORDER BY total_inventory_value DESC;