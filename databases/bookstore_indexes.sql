-- 1. View first 10 rows of tables: customers, orders, books
SELECT * FROM customers
LIMIT 10;

SELECT * FROM orders
LIMIT 10;

SELECT * FROM books
LIMIT 10;

-- 2. Examine the current indexes on tables customers, orders, books
SELECT * FROM pg_Indexes
WHERE tablename = 'customers';

SELECT * FROM pg_Indexes
WHERE tablename = 'orders';

SELECT * FROM pg_Indexes
WHERE tablename = 'books';

-- 3. Add indexes in the orders table on the foreign keys customer_id, book_id
CREATE INDEX orders_customer_id_idx
ON orders(customer_id);

CREATE INDEX orders_book_id_idx
ON orders(book_id);

-- 4. Check the runtime of a query searching for the original_language, title, sales_in_millions from books that have French as the original_language
EXPLAIN ANALYZE SELECT
  original_language,
  title,
  sales_in_millions
FROM books
WHERE original_language = 'French';
-- Execution time = 0.046ms

-- 5. Check the size of the books table
SELECT pg_size_pretty(pg_total_relation_size('books'));
-- Size = 56kB

-- 6. Create an index to help speed up searching for the search query in task 4.
CREATE INDEX books_original_language_title_sales_in_millions_idx
ON books(original_language, title, sales_in_millions);

-- 7. Repeat previous tasks and compare the runtime and size with the index in place.
EXPLAIN ANALYZE SELECT
  original_language,
  title,
  sales_in_millions
FROM books
WHERE original_language = 'French';
-- Execution time = 0.025ms

SELECT pg_size_pretty(pg_total_relation_size('books'));
-- Size = 88kB

-- 8. Delete multicolumn index on books
DROP INDEX IF EXISTS books_original_language_idx;

-- 9. Find the time of how long a bulk copy takes to add orders into the orders table.
SELECT NOW();

\COPY orders FROM 'orders_add.txt' DELIMITER ',' CSV HEADER;

SELECT NOW();
-- 45.185184 - 44.278173 = 0.907011s

-- 10. Drop all indexes on the orders table and repeat task 9
DROP INDEX IF EXISTS orders_customer_id_idx;

DROP INDEX IF EXISTS orders_book_id_idx;

SELECT NOW();

\COPY orders FROM 'orders_add.txt' DELIMITER ',' CSV HEADER;

SELECT NOW();
-- 15.899701 - 15.501527 = 0.398174s

-- 11. You are told you need to build an index on the customers table with first_name and email_address. People keep asking for contact information for clients. Before jumping in and creating the index, try to answer some of these questions:

  /* 11.1 Is this a good idea?
    Not enough information to know whether this is a good idea. The current database is not large enough for it likely to be worth it.
  */
  /* 11.2 What would you need to check to see if this would help the system?
    Need the exact queries to be able to check runtimes and understand other queries run on customers table to see what potential impact might be.
  */
  /* 11.3 What questions would you have to ensure it is a good use of an index?
    What is the goals that relate to the customers table?
  */
  /* What suggestions might you make?
    It might be better to change the columns for the index if there is a better mix of information that is better suited to be indexed depending upon the typical search queries.
  */
  /* What negative aspects of creating it should you bring up?
    Downsides with regards speed of inserting, updating and deleting data from the table, increased size of database and the impact on customers if they have access to the the table.
  */