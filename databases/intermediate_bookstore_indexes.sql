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

-- 3. Check the runtime of a query searching for customer_id, quantity from orders that have sold more than 18 copies
EXPLAIN ANALYZE SELECT
  customer_id,
  quantity
FROM orders
WHERE quantity > 18;
-- Execution time = 11.395ms

--4. Create index for the above query
CREATE INDEX orders_customer_id_quantity_above_18_idx
ON orders(customer_id, quantity)
WHERE quantity > 18;

-- 5. Check the runtime with the new index
EXPLAIN ANALYZE SELECT
  customer_id,
  quantity
FROM orders
WHERE quantity > 18;
-- Execution time = 3.771ms
/* 5.1 Can you explain the change?
The number of orders that have more than 18 books sold is small so that this index has a significant impact.
*/
/* 5.2 As more orders are placed, would this difference become greater or less noticeable?
As more orders are placed the runtime difference will be even more noticeable unless larger orders become the norm.
*/

-- 6. Check the runtime of a query on the customers table, add a primary key then re-run the query
EXPLAIN ANALYZE SELECT *
FROM customers
WHERE customer_id < 100;
-- Execution time = 12.910ms

ALTER TABLE customers
ADD CONSTRAINT customers_pkey
PRIMARY KEY (customer_id);

EXPLAIN ANALYZE SELECT *
FROM customers
WHERE customer_id < 100;
-- Execution time = 0.150ms

--7. Use customers primary key to fix ordering and get first 10 rows of table
CLUSTER customers USING customers_pkey;

SELECT * FROM customers
LIMIT 10;

-- 8. Create a multi-column index of customer_id and book_id on the orders table
EXPLAIN ANALYZE SELECT customer_id, book_id
FROM orders;
-- Execution time = 24.270ms

CREATE INDEX orders_customer_id_book_id_idx
ON orders(customer_id, book_id);

EXPLAIN ANALYZE SELECT customer_id, book_id
FROM orders;
-- Execution time = 16.757ms

-- 9. Drop previous index and recreate adding quantity
DROP INDEX IF EXISTS orders_customer_id_book_id_idx;

EXPLAIN ANALYZE SELECT customer_id, book_id, quantity
FROM orders
WHERE quantity > 18;
-- Execution time = 3.912ms

CREATE INDEX orders_customer_id_book_id_quantity_idx
ON orders(customer_id, book_id, quantity);

EXPLAIN ANALYZE SELECT customer_id, book_id, quantity
FROM orders
WHERE quantity > 18;
-- Execution time = 3.930ms

-- 10. Create an index on books to improve speed of search with author and title
CREATE INDEX books_author_title_idx
ON books(author, title);

-- 11. Write an explain analyze when looking for all the information on all orders where the total price (quantity * price_base) is over 100
EXPLAIN ANALYZE SELECT *
FROM orders
WHERE (quantity * price_base > 100);
-- Execution time = 34.276ms

-- 12. Write an index to speed theis query up
CREATE INDEX orders_total_price_over_100_idx
ON orders((quantity * price_base > 100));

-- 13. Run the explain analyze again to compare execution times
EXPLAIN ANALYZE SELECT *
FROM orders
WHERE (quantity * price_base > 100);
-- Execution time = 33.779ms

-- 14. What can be done to add or remove more indexes to make the system more efficient?
-- First check what indexes currently exist
SELECT * FROM pg_indexes
WHERE tablename IN ('customers', 'books', 'orders')
ORDER BY tablename, indexname;

-- Drop unneeded indexes
DROP INDEX IF EXISTS books_author_idx;
DROP INDEX IF EXISTS books_title_idx;

-- Create useful indexes
CREATE INDEX customers_last_name_first_name_email_address
ON customers(last_name, first_name, email_address);

SELECT * FROM pg_indexes
WHERE tablename IN ('customers', 'books', 'orders')
ORDER BY tablename, indexname;