/* ============================================================================
   CMAP 1815: Introduction to Modern SQL
   Unit 1 Lab: Unit 01 Selection And Fundamentals
   
   Student Name: [YOUR NAME HERE]
   Date:         [SUBMISSION DATE]
   Canvas Course: CMAP 1815
   ----------------------------------------------------------------------------
   Submission Rules:
   1. All SQL keywords MUST be uppercase (SELECT, FROM, WHERE, ORDER BY, AS).
   2. Every clause must begin on a new line.
   3. Always alias calculated expressions with meaningful snake_case names.
   4. Test every query against your live PostgreSQL database before turning in!
   5. Save this completed file as: lab1_yourlastname.sql
   ============================================================================ */

-- Test connection to verify server state
SELECT version(), current_database(), current_user;

/*| **1. Query Accuracy & Execution** | All required challenge queries execute cleanly without syntax errors and produce the exact requested dataset. | 1–2 minor logic or execution errors (e.g., incorrect sort direction, minor column omission). | Multiple queries fail to execute or return incorrect datasets. | **40** |
| **2. Formatting & SQL Style Standards** | Keywords are strictly **UPPERCASE** (`SELECT`, `FROM`, `ORDER BY`, `AS`). Clauses begin on separate lines. No trailing commas. | Inconsistent keyword casing (mixed upper/lower) or cluttered single-line formatting. | Unformatted code block; difficult to read; missing semicolons. | **20** |
| **3. Precision Projection & Aliasing** | Named columns used exclusively (zero unrequested `SELECT *`). Expressions cleanly aliased with meaningful `snake_case` headers using `AS`. | Missing aliases for computed expressions (`?column?` in output) or unnecessary use of `SELECT *`. | Monolithic `SELECT *` used throughout; no aliases provided. | **20** |
| **4. Sorting & De-duplication Logic** | Correct application of `DISTINCT` and multi-level `ORDER BY` sorting (ascending vs. descending). | Single sort correct, but secondary tie-breaker omitted or inverted. | Incorrect sort ordering; failed to de-duplicate unique values. | **10** |
| **5. Environment & System Catalog Questions** | Accurate answers provided for server metadata inspection (PostgreSQL version, current user, table counts). | Minor omission or misunderstanding of system catalog roles. | Catalog exploration questions unanswered or incorrect. | **10** |
| **Total** | | | | **100** |*/

/* ----------------------------------------------------------------------------
   CHALLENGE QUERIES
   (Refer to lab_guide.md for prompt specifications)
   ---------------------------------------------------------------------------- */

-- Challenge 1:
-- [Write query here]


-- Challenge 2:
-- [Write query here]


-- Challenge 3:
-- [Write query here]


-- Challenge 4:
-- [Write query here]


-- Challenge 5:
-- [Write query here]

