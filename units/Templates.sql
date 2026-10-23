/*Class Notes: SQL Syntax & Best Practices

The Semicolon (;): Every SQL command must end with a semicolon.
 It is the period at the end of your SQL sentence.

 Commas (,): When projecting multiple columns, 
 separate them with commas (e.g., SELECT first_name, 
 last_name, salary). Crucial Rule: Never put a trailing 
 comma after the last column before the FROM keyword.

 professional standard practice requires writing SQL keywords in ALL CAPS 
 (SELECT, FROM, ORDER BY, AS) and beginning each clause on a new line for readability.

 (*): If you want to see every column in a table during initial exploration, use *

 DISTINCT: When you execute a query with DISTINCT, PostgreSQL must scan every 
 candidate row and perform a de-duplication pass using an in-memory hash table
  or on-disk sort. On tables containing millions of rows, DISTINCT can introduce 
  significant CPU and I/O latency. Use DISTINCT intentionally when auditing data or
   generating category lists, but avoid using it casually to mask duplicate rows 
   caused by improper join conditions.

   SQL is not limited to retrieving static column values; you can also 
   use it as a powerful calculation engine. You can create virtual columns
    using scalar arithmetic operators (+, -, *, /) and string concatenation (||).

    String Concatenation (||): Merge text columns together

Always use the AS keyword with a descriptive, lowercase snake_case identifier 
(such as AS estimated_unit_profit) to produce clean, professional report headers.*/

/* Below is a template for writing SQL queries. It includes the basic structure
 and comments to guide you in constructing your own queries. Fill in the
  placeholders with your specific column names, table names, and sorting
   preferences as needed. */

   
/*SELECT Columns Identifies the specific 
attributes you want to project (the "What").*/
SELECT * /*column_here*/

/*FROM Table Identifies the source table where the data lives (the "Where").*/
FROM employees; /*data_table_here*/

/*ORDER BY [Columns]: (Optional) Tells the database how
 to sort the result set (the "How it looks").
 To organize data for human consumption or reporting, 
 you must supply an ORDER BY clause:
ASC (Ascending)
DESC (Descending): Reverses the sort order (Z to A, highest 
number to lowest number).
Multi-Column Sorting: Sort by primary category, then by a 
secondary tie-breaker:
*/
/*ORDER BY */ /*column_here ASC or DESC or ASC one COLUMN, 
another column DESC together*/;




