/*
Kimberley Bennett
Unit 4 Lab: Aggregation and Pivoting

Reference Guide link:https://neon.com/postgresql/tutorial/coalesce#1-basic-postgresql-coalesce-function-examples


Lab Tasks
Task 1: Departmental Headcount & Salary Distribution
Executive leadership needs to understand compensation variance across corporate departments.

Requirements:
From employees, group by department.
Output:
department: Department name.
total_headcount: Count of all employees in the department.
avg_salary: Average employee salary rounded to 2 decimal places.
min_salary: Lowest salary in the department.
max_salary: Highest salary in the department.
salary_range: Difference between max_salary and min_salary.
Sort by avg_salary in descending order.*/

SELECT 
    department,
    --Below we are using aggregate functions to calculate the total headcount, average salary, minimum salary,
    --maximum salary, and salary range for each department in the employees table.
    COUNT(*) AS total_headcount,
    ROUND(AVG(salary), 2) AS avg_salary,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    (MAX(salary) - MIN(salary)) AS salary_range
    FROM employees
/*The GROUP BY clause divides the rows returned from the SELECT statement into groups.
For each group, you can apply an aggregate function such as SUM() 
to calculate the sum of items or COUNT() to get the number of items in the groups.*/
    GROUP BY department
    ORDER BY avg_salary DESC;







/*Task 2: Warehouse Inventory Valuation & Capital Risk Filter
The Chief Operating Officer needs to identify categories with substantial capital tied up in unsold active stock.

Requirements:
From products, filter for active products only (is_discontinued = FALSE).
Group by category.
Calculate:
total_sku_count: Number of distinct products in the category.
total_units_stocked: Sum of stock_quantity.
inventory_valuation_cost: Sum of stock_quantity * wholesale_cost rounded to 2 decimal places.
expected_retail_value: Sum of stock_quantity * retail_price rounded to 2 decimal places.
Use the HAVING clause to filter only categories where total_units_stocked is at least 100 units AND inventory_valuation_cost exceeds $1,000.00.
Sort by inventory_valuation_cost descending.*/

SELECT 
    category,
    COUNT(DISTINCT product_id) AS total_sku_count,
    SUM(stock_quantity) AS total_units_stocked,
    ROUND(SUM(stock_quantity * wholesale_cost), 2) AS inventory_valuation_cost,
    ROUND(SUM(stock_quantity * retail_price), 2) AS expected_retail_value
    FROM products
    WHERE is_discontinued = FALSE
    GROUP BY category
/*The HAVING clause specifies a search condition for a group.
The HAVING clause is often used with the GROUP BY clause to filter groups based on a specified condition.*/
--In this case, we are filtering for categories where the total units stocked is at least 100 and 
--the inventory valuation cost exceeds $1,000.00.
    HAVING SUM(stock_quantity) >= 100 AND SUM(stock_quantity * wholesale_cost) > 1000
    ORDER BY inventory_valuation_cost DESC;




    
/*Task 3: Multi-Table Order Summary & Basket Analysis
The Sales VP wants to identify large commercial customer orders from orders and order_lines.

Requirements:
Perform an INNER JOIN between orders and order_lines on order_id.
Group by order_id, customer_id, and order_date.
Calculate:
unique_items: Count of distinct order line items.
total_units_purchased: Sum of quantity.
order_subtotal: Sum of quantity * unit_price rounded to 2 decimal places.
Filter using HAVING for orders where order_subtotal is greater than or equal to $150.00.
Order by order_subtotal descending.*/

--Here we are doing an INNER JOIN because we want to combine data from the orders and order_lines tables based on matching order_id values.
SELECT 
    o.order_id,
    o.customer_id,
    o.order_date,
    COUNT(DISTINCT ol.product_id) AS unique_items,
    SUM(ol.quantity) AS total_units_purchased,
    ROUND(SUM(ol.quantity * ol.unit_price), 2) AS order_subtotal
    FROM orders o
    INNER JOIN order_lines ol ON o.order_id = ol.order_id
    GROUP BY o.order_id, o.customer_id, o.order_date
/*The HAVING clause is used to filter groups based on a specified condition.
In this case, we are filtering for orders where the order subtotal is greater than or equal to $150.00.*/
    HAVING SUM(ol.quantity * ol.unit_price) >= 150
    ORDER BY order_subtotal DESC;






/*Task 4: Facility Staffing Reconciliation (Set Operations)
Corporate Real Estate wants to audit physical facility leases to determine which locations currently have zero active employees assigned.

Requirements:
Write a query that selects all location_ids from the locations table.
Use the EXCEPT set operator to subtract all distinct location_ids present in the employees table where location_id IS NOT NULL.
Below the query, write a 2-sentence SQL comment (-- ...) explaining the business implication of this result set.*/


--Here we are using the EXCEPT set operator to find all location_ids in the locations table that do not have any active
-- employees assigned to them in the employees table. This result set indicates which corporate facilities currently have zero staff 
--assigned, which may require further investigation or action by the Corporate Real Estate team.
SELECT location_id 
    FROM locations
    /*Use the PostgreSQL EXCEPT operator to combine rows from two result 
    sets and return a result set containing rows from the first result set that do not appear in the second result set.*/
    EXCEPT
    SELECT DISTINCT location_id FROM employees WHERE location_id IS NOT NULL;



/*Task 5: Executive Regional Performance Matrix (Conditional Pivoting)
Transform the superstore transactional records into an executive spreadsheet-style cross-tab matrix.

Requirements:
Group by region. Replace any NULL region with 'Unassigned' using COALESCE.
Calculate:
total_orders: Total order count.
total_revenue: Total sales rounded to 2 decimal places.
furniture_revenue: Total sales for category 'Furniture' using CASE WHEN inside SUM.
office_supplies_revenue: Total sales for category 'Office Supplies' using CASE WHEN inside SUM.
technology_revenue: Total sales for category 'Technology' using CASE WHEN inside SUM.
tech_revenue_share_pct: Percentage of total regional sales generated by Technology, rounded to 1 decimal place.
Sort by total_revenue descending.*/

--Here we are using the COALESCE function to replace any NULL region values with 'Unassigned' in the result set. 
--We are also using CASE WHEN statements inside SUM to calculate total sales for each category, and we are calculating 
--the percentage of total regional sales generated by Technology.

SELECT 
/*The COALESCE() function accepts multiple arguments and returns the first argument that is not null. If all arguments are null, 
the COALESCE() function will return null. The COALESCE() function evaluates arguments from left to right until it finds the first
 non-null argument. All the remaining arguments from the first non-null argument are not evaluated.*/
    COALESCE(region, 'Unassigned') AS region,
    COUNT(*) AS total_orders,
    ROUND(SUM(sales), 2) AS total_revenue,
    --CASE is used like an IF ELSE Statement. It evaluates a list of conditions and returns one of multiple possible result expressions.
    --In this case when the category is 'Furniture' we want to sum the sales for that category, otherwise we want to return 0.
    --This becomes ADDED to the total revenue for the region. The same logic applies to the other categories.
    --The ELSE 0 is used to ensure that if the condition is not met, we return a value of 0 instead of NULL, 
    --which would affect the total revenue calculation.
    --END is used to signify the end of the CASE statement.
    ROUND(SUM(CASE WHEN category = 'Furniture' THEN sales ELSE 0 END), 2) AS furniture_revenue,
    ROUND(SUM(CASE WHEN category = 'Office Supplies' THEN sales ELSE 0 END), 2) AS office_supplies_revenue,
    ROUND(SUM(CASE WHEN category = 'Technology' THEN sales ELSE 0 END), 2) AS technology_revenue,
    --The NULLIF() function returns NULL if the two arguments are equal. If they are not equal, it returns the first argument.
    --In this case, we are using NULLIF to avoid division by zero when calculating
    -- the percentage of total regional sales generated by Technology. If the total revenue is 0, we return NULL
    ROUND(100.0 * SUM(CASE WHEN category = 'Technology' THEN sales ELSE 0 END) / NULLIF(SUM(sales), 0),1) AS tech_revenue_share_pct
    FROM superstore
    GROUP BY region 
    ORDER BY total_revenue DESC;