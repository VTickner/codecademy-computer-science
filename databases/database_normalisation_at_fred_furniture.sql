-- 1. View first 10 rows of store table
SELECT * FROM store
LIMIT 10;

-- 2. Have any customers made more than one order? Count the number of distinct order_id and customer_id
SELECT 
  COUNT(DISTINCT(order_id)) AS order_count,
  COUNT(DISTINCT(customer_id)) AS customer_count
FROM store;
-- order_count = 100
-- customer_count = 80
-- Yes, some customers have made more than one order

-- 3. Write a query to return customer_id, customer_email, customer_phone where customer_id = 1. How many orders did this customer make?
SELECT 
  customer_id, 
  customer_email, 
  customer_phone, 
  COUNT(order_id) AS order_count
FROM store
WHERE customer_id = 1
GROUP BY customer_id, customer_email, customer_phone;
-- 2 orders

-- 4. Write a query to return item_1_id, item_1_name, item_1_price where item_1_id = 4. How many orders include this item as item_1?
SELECT 
  item_1_id, 
  item_1_name, 
  item_1_price, 
  COUNT(order_id) AS order_count
FROM store
WHERE item_1_id = 4
GROUP BY item_1_id, item_1_name, item_1_price;
-- 3 orders

-- 5. Use CREATE TABLE customers AS to create customers table described in the schema by querying the original store table
CREATE TABLE customers AS
  SELECT DISTINCT
    customer_id,
    customer_phone,
    customer_email
  FROM store;

-- 6. Make customer_id column as the primary key in the customers table
ALTER TABLE customers
ADD PRIMARY KEY (customer_id);

-- 7. Use CREATE TABLE items AS to create items table described in the schema by querying the original store table
CREATE TABLE items AS
  SELECT DISTINCT
    item_1_id AS item_id,
    item_1_name AS item_name,
    item_1_price AS item_price
  FROM store
  UNION
  SELECT DISTINCT
    item_2_id AS item_id,
    item_2_name AS item_name,
    item_2_price AS item_price
  FROM store
  WHERE item_2_id IS NOT NULL
  UNION
  SELECT DISTINCT
    item_3_id AS item_id,
    item_3_name AS item_name,
    item_3_price AS item_price
  FROM store
  WHERE item_3_id IS NOT NULL;

-- 8. Make item_id column as the primary key in the items table
ALTER TABLE items
ADD PRIMARY KEY (item_id);

-- 9. Use CREATE TABLE orders_items AS to create orders_items table described in the schema by querying the original store table
CREATE TABLE orders_items AS
  SELECT
    order_id,
    item_1_id AS item_id
  FROM store
  UNION ALL
  SELECT
    order_id,
    item_2_id AS item_id
  FROM store
  WHERE item_2_id IS NOT NULL
  UNION ALL
  SELECT
    order_id,
    item_3_id AS item_id
  FROM store
  WHERE item_3_id IS NOT NULL;

-- 10. Use CREATE TABLE orders AS to create orders table described in the schema by querying the original store table
CREATE TABLE orders AS
  SELECT
    order_id,
    order_date,
    customer_id
  FROM store;

-- 11. Make order_id column as the primary key in the orders table
ALTER TABLE orders
ADD PRIMARY KEY (order_id);

-- 12. Make customer_id column as a foreign key in the orders table and make item_id column as a foreign key in the orders_items table
ALTER TABLE orders
ADD FOREIGN KEY (customer_id)
REFERENCES customers(customer_id);

ALTER TABLE orders_items
ADD FOREIGN KEY (item_id)
REFERENCES items(item_id);

-- 13. Make order_id column as a foreign key in the orders_items table
ALTER TABLE orders_items
ADD FOREIGN KEY (order_id)
REFERENCES orders(order_id);

-- Added my own checks to check keys on normalised tables
SELECT
  constraint_name,
  table_name,
  column_name
FROM information_schema.key_column_usage
WHERE table_name = 'customers';

SELECT
  constraint_name,
  table_name,
  column_name
FROM information_schema.key_column_usage
WHERE table_name = 'items';

SELECT
  constraint_name,
  table_name,
  column_name
FROM information_schema.key_column_usage
WHERE table_name = 'orders';

SELECT
  constraint_name,
  table_name,
  column_name
FROM information_schema.key_column_usage
WHERE table_name = 'orders_items';

-- 14. Query the store table to return emails of all customers who made an order after July 25, 2019
SELECT
  customer_email,
  order_date
FROM store
WHERE order_date > '2019-07-25';

-- 15. Now run the same query on the normalised tables
SELECT
  customers.customer_email,
  orders.order_date
FROM customers, orders
WHERE customers.customer_id = orders.customer_id
  AND orders.order_date > '2019-07-25';

-- 16. Query the store table to return the number of orders containing each unique item re.g. two orders containing item 1, two orders contain item 2 etc.
WITH all_items AS (
  SELECT item_1_id AS item_id
  FROM store
  UNION ALL
  SELECT item_2_id AS item_id
  FROM store
  WHERE item_2_id IS NOT NULL
  UNION ALL
  SELECT item_3_id AS item_id
  FROM store
  WHERE item_3_id IS NOT NULL
)
SELECT item_id, COUNT(*)
FROM all_items
GROUP BY item_id;

-- 17. Now run the same query on the normalised tables
SELECT item_id, COUNT(*)
FROM orders_items
GROUP BY item_id;

-- 18. What types of queries are easier with normalised tables? What types of queries are more difficult?

-- 18.1 How many customers made more than one order? What are their emails?
SELECT COUNT(*) AS number_of_customers
FROM (
  SELECT
    customer_email,
    COUNT(order_id) AS total_orders
  FROM store
  GROUP BY customer_email
  HAVING COUNT(order_id) > 1
) AS subquery;
-- 20 customers

SELECT
  customer_email,
  COUNT(order_id) AS total_orders
FROM store
GROUP BY customer_email
HAVING COUNT(order_id) > 1;

SELECT COUNT(*) AS number_of_customers
FROM (
  SELECT
    c.customer_email,
    COUNT(o.order_id) AS total_orders
  FROM 
    customers AS c, 
    orders AS o
  WHERE c.customer_id = o.customer_id
  GROUP BY c.customer_email
  HAVING COUNT(o.order_id) > 1
) AS subquery;
-- 20 customers

SELECT
  c.customer_email,
  COUNT(o.order_id) AS total_orders
FROM 
  customers AS c, 
  orders AS o
WHERE c.customer_id = o.customer_id
GROUP BY c.customer_email
HAVING COUNT(o.order_id) > 1;

-- 18.2 Among order that were made after July 15, 2019 how many include a lamp?
SELECT 
  item_name, 
  COUNT(*) AS total_sold
FROM (
  SELECT 
    item_1_name AS item_name, 
    order_date
  FROM store
  UNION ALL
  SELECT 
    item_2_name AS item_name, 
    order_date 
  FROM store 
  WHERE item_2_name IS NOT NULL
  UNION ALL
  SELECT 
    item_3_name AS item_name,
    order_date 
  FROM store 
  WHERE item_3_name IS NOT NULL
) AS all_items
WHERE order_date > '2019-07-25' 
  AND item_name = 'lamp'
GROUP BY item_name;
-- 5 orders

SELECT 
    i.item_name, 
    COUNT(*) AS total_sold
FROM orders AS o
JOIN orders_items AS oi
  ON o.order_id = oi.order_id
JOIN items AS i
  ON oi.item_id = i.item_id
WHERE o.order_date > '2019-07-25'
  AND i.item_name = 'lamp'
GROUP BY i.item_name;

-- 18.3 How many orders included a chair?
SELECT COUNT(DISTINCT order_id) AS orders_with_chair
FROM store
WHERE 'chair' IN (item_1_name, item_2_name, item_3_name);
-- 3 orders

SELECT COUNT(DISTINCT o.order_id) AS orders_with_chair
FROM orders AS o
JOIN orders_items AS oi
  ON o.order_id = oi.order_id
JOIN items AS i ON oi.item_id = i.item_id
WHERE i.item_name = 'chair';