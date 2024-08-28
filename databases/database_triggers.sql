-- 1. Show all data in the customers and customers_log tables
SELECT * FROM customers
ORDER BY customer_id;

SELECT * FROM customers_log;

-- 2. Create a trigger to log anytime someone updates the customers table with first_name or last_name information
CREATE TRIGGER customer_updated
BEFORE UPDATE ON customers
FOR EACH ROW
EXECUTE PROCEDURE log_customers_change();

-- 3. Check by testing to see if trigger is working correctly
UPDATE customers
SET first_name = 'Steve'
WHERE last_name = 'Hall';

SELECT * FROM customers
ORDER BY customer_id;

SELECT * FROM customers_log;

-- 4. Check by testing to make sure trigger isn't fired when don't expect it to
UPDATE customers
SET years_old = 10
WHERE last_name = 'Hall';

SELECT * FROM customers
ORDER BY customer_id;

SELECT * FROM customers_log;

-- 5. Create a trigger to log once per statement when someone updates the customers table with first_name and last_name information
CREATE TRIGGER customer_insert
AFTER INSERT ON customers
FOR EACH STATEMENT
EXECUTE PROCEDURE log_customers_change();

-- 6. Add 3 names to the customers table in one statement trigger to check trigger is only inserting per statement
INSERT INTO customers (
  first_name,
  last_name, 
  email_address, 
  home_phone, 
  city, 
  state_name, 
  years_old)
VALUES
  ('Jeffrey','Cook','Jeffrey.Cook@example.com','202-555-0398','Jersey city','New Jersey',66),
  ('Emma','Cook','EmmaCook@example.com','202-555-0398','Jersey city','New Jersey',60),
  ('Zoe','Snow','Z.Snow@example.com','200-444-0194','New York','New York',48);

SELECT * FROM customers
ORDER BY customer_id;

SELECT * FROM customers_log;

-- 7. Place the conditional on the trigger when age is update to < 13.
CREATE TRIGGER customer_min_age
BEFORE UPDATE ON customers
FOR EACH ROW
WHEN (NEW.years_old < 13)
EXECUTE PROCEDURE override_with_min_age();

-- 8. Add to updates to the ages to test the trigger
UPDATE customers
SET years_old = 12
WHERE last_name = 'Campbell';

UPDATE customers
SET years_old = 24
WHERE last_name = 'Cook';

SELECT * FROM customers
ORDER BY customer_id;

SELECT * FROM customers_log;

-- 9. Make modifications to be both name and age
UPDATE customers
SET 
  years_old = 9,
  first_name = 'Dennis'
WHERE last_name = 'Hall';

SELECT * FROM customers
ORDER BY customer_id;

SELECT * FROM customers_log;

-- 10. Drop the trigger
SELECT * FROM information_schema.triggers;

DROP TRIGGER IF EXISTS customer_min_age ON customers;

-- 11. Check the triggers on the system to check trigger deleted correctly
SELECT * FROM information_schema.triggers;