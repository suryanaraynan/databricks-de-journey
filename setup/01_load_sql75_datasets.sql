-- Databricks notebook source
-- MAGIC %md
-- MAGIC # SQL 75 practice datasets (Databricks version)
-- MAGIC Converted from the PostgreSQL script in SahilGogna/Study-Resources (`analysis/sql-75-datasets.sql`).
-- MAGIC
-- MAGIC Changes for Databricks: `SERIAL` ids replaced with explicit INT ids, `VARCHAR`/`TEXT` → `STRING`,
-- MAGIC `NUMERIC` → `DECIMAL`, foreign keys and `DROP ... CASCADE` removed, `CREATE OR REPLACE TABLE` so the notebook can be rerun.
-- MAGIC
-- MAGIC Question notes from the original: Q21 use `name` (not employee_name) · Q22 ORDER BY `month_num` · Q33 HAVING > 1000 ·
-- MAGIC Q64 HAVING > 500 · Q65 HAVING COUNT(*) > 2 · Q70 employee_id = 2 · Q75 employee_id = 9 · Q72 use `product_versions`.

-- COMMAND ----------

USE CATALOG de_journey;
USE SCHEMA practice;

-- COMMAND ----------

-- 1. CUSTOMERS  (11 & 12 have no orders; NULL emails: 6, 11; invalid phone: 11)
CREATE OR REPLACE TABLE customers (
  customer_id INT, name STRING, customer_name STRING, first_name STRING, last_name STRING,
  email STRING, phone_number STRING, country STRING, city STRING, birth_date DATE, category STRING
);
INSERT INTO customers VALUES
(1,  'Alice Johnson','Alice Johnson','Alice','Johnson','alice@gmail.com','555-123-4567','USA','New York',DATE'1990-03-15','Premium'),
(2,  'Bob Smith','Bob Smith','Bob','Smith','bob@yahoo.com','555-234-5678','USA','Los Angeles',DATE'1985-07-22','Standard'),
(3,  'Carol White','Carol White','Carol','White','carol@gmail.com','555-345-6789','UK','London',DATE'1992-11-30','Premium'),
(4,  'David Brown','David Brown','David','Brown','david@outlook.com','555.456.7890','Canada','Toronto',DATE'1988-04-10','Standard'),
(5,  'Eva Martinez','Eva Martinez','Eva','Martinez','eva@gmail.com','555-567-8901','USA','Chicago',DATE'1995-09-05','Budget'),
(6,  'Frank Lee','Frank Lee','Frank','Lee',NULL,'5556789012','Australia','Sydney',DATE'1983-01-20','Standard'),
(7,  'Grace Kim','Grace Kim','Grace','Kim','grace@gmail.com','555-789-0123','USA','New York',DATE'1991-06-14','Premium'),
(8,  'Henry Davis','Henry Davis','Henry','Davis','henry@company.com','555-890-1234','UK','London',DATE'1987-12-03','Budget'),
(9,  'Iris Chen','Iris Chen','Iris','Chen','iris@gmail.com','555-901-2345','USA','San Francisco',DATE'1993-08-25','Premium'),
(10, 'Jack Wilson','Jack Wilson','Jack','Wilson','jack@hotmail.com','555-012-3456','Canada','Toronto',DATE'1986-02-17','Standard'),
(11, 'Karen Taylor','Karen Taylor','Karen','Taylor',NULL,'INVALID-PHONE','USA','Boston',DATE'1994-05-09','Budget'),
(12, 'Liam Anderson','Liam Anderson','Liam','Anderson','liam@gmail.com','555-111-2222','USA','Seattle',DATE'1997-10-31','Premium');

-- COMMAND ----------

-- 2. PRODUCTS  (9 & 10 are never ordered)
CREATE OR REPLACE TABLE products (
  product_id INT, product_name STRING, price DECIMAL(10,2), category STRING, subcategory STRING,
  sales DECIMAL(12,2), inventory INT, version STRING, version_number INT, features STRING, email STRING
);
INSERT INTO products VALUES
(1,  'Laptop Pro',1299.99,'Electronics','Computers',45000.00,50,'v2',2,'Upgraded quad-core processor, 16GB RAM','vendor@laptopco.com'),
(2,  'Wireless Mouse',29.99,'Electronics','Peripherals',8000.00,200,'v1',1,'Basic 2.4GHz wireless connectivity','peripherals@techsupply.com'),
(3,  'Python Book',49.99,'Books','Programming',5000.00,100,'v3',3,'Updated to Python 3.12 with exercises','editor@bookpress.com'),
(4,  'Running Shoes',89.99,'Clothing','Footwear',15000.00,75,'v1',1,'Lightweight foam sole, breathable mesh','footwear@sportsbrand.com'),
(5,  'Coffee Maker',79.99,'Electronics','Appliances',12000.00,30,'v2',2,'Faster brew cycle, quieter motor','vendor@homeappliances.com'),
(6,  'SQL Workbook',34.99,'Books','Database',3500.00,60,'v1',1,'Beginner-friendly SQL exercises','editor@bookpress.com'),
(7,  'Yoga Mat',24.99,'Clothing','Fitness',4000.00,150,'v1',1,'Non-slip surface, 6mm thick','supplier@yogaworld.com'),
(8,  'USB Hub',39.99,'Electronics','Peripherals',6000.00,80,'v2',2,'Added USB-C, expanded to 7 ports','peripherals@techsupply.com'),
(9,  'Desk Lamp',54.99,'Electronics','Lighting',2000.00,40,'v1',1,'LED dimmable, touch control','vendor@lightingsupply.com'),
(10, 'Notebook',9.99,'Books','Stationery',1000.00,300,'v1',1,'Ruled, 200 pages, A5 size','stationery@officesupply.com');

-- COMMAND ----------

-- 3. COLORS  (for CROSS JOIN)
CREATE OR REPLACE TABLE colors (color STRING);
INSERT INTO colors VALUES ('Red'), ('Blue'), ('Green'), ('Black');

-- COMMAND ----------

-- 4. ORDERS  (gaps at 4, 9, 14; duplicates customer+date: 1/24, 2/25)
CREATE OR REPLACE TABLE orders (
  order_id INT, customer_id INT, product_id INT, amount DECIMAL(10,2), quantity INT,
  order_date DATE, delivery_date DATE, signup_date DATE, status STRING, region STRING
);
INSERT INTO orders VALUES
(1, 1,1,1299.99,1,DATE'2024-01-05',DATE'2024-01-10',DATE'2023-01-05','completed','North'),
(2, 2,2,29.99,2,DATE'2024-01-08',DATE'2024-01-12',DATE'2023-02-10','completed','South'),
(3, 1,3,49.99,1,DATE'2024-01-15',DATE'2024-01-18',DATE'2023-01-05','completed','North'),
(5, 3,4,89.99,1,DATE'2024-01-20',DATE'2024-01-25',DATE'2023-03-15','completed','East'),
(6, 4,5,79.99,1,DATE'2024-02-01',DATE'2024-02-05',DATE'2023-04-20','pending','North'),
(7, 2,1,1299.99,1,DATE'2024-02-10',DATE'2024-02-16',DATE'2023-02-10','completed','South'),
(8, 5,6,34.99,2,DATE'2024-02-14',DATE'2024-02-17',DATE'2023-05-01','completed','West'),
(10,6,7,24.99,3,DATE'2024-02-20',DATE'2024-02-23',DATE'2023-06-10','completed','South'),
(11,7,8,39.99,1,DATE'2024-03-01',DATE'2024-03-05',DATE'2023-01-20','cancelled','North'),
(12,1,5,79.99,1,DATE'2024-03-10',DATE'2024-03-14',DATE'2023-01-05','completed','North'),
(13,8,3,49.99,2,DATE'2024-03-15',DATE'2024-03-19',DATE'2023-07-15','completed','East'),
(15,3,2,29.99,1,DATE'2024-03-20',DATE'2024-03-23',DATE'2023-03-15','pending','East'),
(16,9,1,1299.99,1,DATE'2024-04-01',DATE'2024-04-07',DATE'2023-08-01','completed','West'),
(17,2,4,89.99,2,DATE'2024-04-05',DATE'2024-04-10',DATE'2023-02-10','completed','South'),
(18,4,8,39.99,1,DATE'2024-04-10',DATE'2024-04-14',DATE'2023-04-20','completed','North'),
(19,7,3,49.99,1,DATE'2024-04-15',DATE'2024-04-18',DATE'2023-01-20','completed','North'),
(20,5,7,24.99,2,DATE'2024-04-20',DATE'2024-04-23',DATE'2023-05-01','pending','West'),
(21,9,6,34.99,3,DATE'2024-05-01',DATE'2024-05-04',DATE'2023-08-01','completed','West'),
(22,1,2,29.99,1,DATE'2024-05-05',DATE'2024-05-08',DATE'2023-01-05','cancelled','North'),
(23,10,4,89.99,1,DATE'2024-05-10',DATE'2024-05-14',DATE'2023-09-05','completed','East'),
(24,1,2,29.99,1,DATE'2024-01-05',DATE'2024-01-09',DATE'2023-01-05','pending','North'),
(25,2,3,49.99,1,DATE'2024-01-08',DATE'2024-01-11',DATE'2023-02-10','pending','South');

-- COMMAND ----------

-- 5. ORDER_ITEMS
CREATE OR REPLACE TABLE order_items (item_id INT, order_id INT, product_id INT, quantity INT, price DECIMAL(10,2));
INSERT INTO order_items VALUES
(1,1,1,1,1299.99),(2,1,2,2,29.99),(3,2,2,2,29.99),(4,3,3,1,49.99),(5,5,4,1,89.99),
(6,6,5,1,79.99),(7,7,1,1,1299.99),(8,7,3,2,49.99),(9,8,6,2,34.99),(10,10,7,3,24.99),
(11,11,8,1,39.99),(12,12,5,1,79.99),(13,12,2,1,29.99),(14,13,3,2,49.99),(15,15,2,1,29.99),
(16,16,1,1,1299.99),(17,17,4,2,89.99),(18,18,8,1,39.99),(19,19,3,1,49.99),(20,20,7,2,24.99),
(21,21,6,3,34.99),(22,22,2,1,29.99),(23,23,4,1,89.99);

-- COMMAND ----------

-- 6. EMPLOYEES  (4-level hierarchy: CEO > VPs > managers/seniors > staff)
CREATE OR REPLACE TABLE employees (employee_id INT, name STRING, manager_id INT, department STRING, salary DECIMAL(10,2));
INSERT INTO employees VALUES
(1,'Sarah Connor',NULL,'Executive',250000.00),
(2,'Tom Bradley',1,'Engineering',180000.00),
(3,'Lisa Park',1,'Sales',160000.00),
(4,'Mark Rivera',1,'Finance',170000.00),
(5,'James Liu',2,'Engineering',120000.00),
(6,'Nina Patel',2,'Engineering',115000.00),
(7,'Anna Torres',3,'Sales',95000.00),
(8,'Chris Evans',4,'Finance',110000.00),
(9,'Mike Johnson',5,'Engineering',90000.00),
(10,'Emily Wong',5,'Engineering',85000.00),
(11,'Ryan Kim',6,'Engineering',88000.00),
(12,'Sophie Hall',7,'Sales',72000.00);

-- COMMAND ----------

-- 7. TRANSACTIONS  (exact duplicates: 3/8, 2/13, 4/15; customer 1 rows 10→11 within 24h)
CREATE OR REPLACE TABLE transactions (transaction_id INT, customer_id INT, amount DECIMAL(10,2), transaction_date TIMESTAMP);
INSERT INTO transactions VALUES
(1,1,500.00,TIMESTAMP'2024-01-05 09:00:00'),
(2,2,150.00,TIMESTAMP'2024-01-06 14:30:00'),
(3,3,750.00,TIMESTAMP'2024-01-07 10:00:00'),
(4,4,200.00,TIMESTAMP'2024-01-08 11:00:00'),
(5,1,300.00,TIMESTAMP'2024-01-09 15:00:00'),
(6,5,450.00,TIMESTAMP'2024-01-10 08:00:00'),
(7,6,100.00,TIMESTAMP'2024-01-11 16:00:00'),
(8,3,750.00,TIMESTAMP'2024-01-07 10:00:00'),
(9,7,600.00,TIMESTAMP'2024-01-12 09:30:00'),
(10,1,200.00,TIMESTAMP'2024-01-12 20:00:00'),
(11,1,350.00,TIMESTAMP'2024-01-13 10:00:00'),
(12,8,250.00,TIMESTAMP'2024-01-15 12:00:00'),
(13,2,150.00,TIMESTAMP'2024-01-06 14:30:00'),
(14,9,800.00,TIMESTAMP'2024-01-16 09:00:00'),
(15,4,200.00,TIMESTAMP'2024-01-08 11:00:00');

-- COMMAND ----------

-- 8. SUBSCRIPTIONS
CREATE OR REPLACE TABLE subscriptions (subscription_id INT, customer_id INT, subscription_start DATE);
INSERT INTO subscriptions VALUES
(1,1,DATE'2024-01-01'),(2,2,DATE'2024-01-15'),(3,3,DATE'2024-02-01'),(4,4,DATE'2024-02-10'),
(5,5,DATE'2024-03-01'),(6,6,DATE'2024-03-15'),(7,7,DATE'2024-04-01'),(8,8,DATE'2024-04-20');

-- COMMAND ----------

-- 9. STOCK_PRICES  (column `date` needs backticks)
CREATE OR REPLACE TABLE stock_prices (`date` DATE, price DECIMAL(10,2));
INSERT INTO stock_prices VALUES
(DATE'2024-01-01',150.25),(DATE'2024-01-02',152.50),(DATE'2024-01-03',148.75),(DATE'2024-01-04',155.00),
(DATE'2024-01-05',153.25),(DATE'2024-01-06',157.50),(DATE'2024-01-07',156.00),(DATE'2024-01-08',160.25),
(DATE'2024-01-09',158.75),(DATE'2024-01-10',162.50),(DATE'2024-01-11',165.00),(DATE'2024-01-12',163.25),
(DATE'2024-01-13',168.50),(DATE'2024-01-14',170.00);

-- COMMAND ----------

-- 10. TRADES
CREATE OR REPLACE TABLE trades (trade_id INT, trader_id INT, trade_date DATE, profit_loss DECIMAL(12,2));
INSERT INTO trades VALUES
(1,101,DATE'2024-01-05',5000.00),(2,101,DATE'2024-01-10',-2000.00),(3,101,DATE'2024-01-15',8000.00),
(4,101,DATE'2024-01-20',3500.00),(5,101,DATE'2024-01-25',-1000.00),(6,101,DATE'2024-01-30',6000.00),
(7,102,DATE'2024-01-05',4000.00),(8,102,DATE'2024-01-12',7500.00),(9,102,DATE'2024-01-18',-3000.00),
(10,102,DATE'2024-01-22',9000.00),(11,102,DATE'2024-01-28',2000.00),(12,103,DATE'2024-01-07',1500.00),
(13,103,DATE'2024-01-14',5500.00),(14,103,DATE'2024-01-21',-500.00),(15,103,DATE'2024-01-28',4500.00);

-- COMMAND ----------

-- 11. ACCOUNTS
CREATE OR REPLACE TABLE accounts (account_id INT, balance DECIMAL(12,2));
INSERT INTO accounts VALUES
(1,-500.00),(2,0.00),(3,250.00),(4,750.00),(5,1000.00),
(6,5000.00),(7,9999.99),(8,15000.00),(9,50000.00),(10,-150.00);

-- COMMAND ----------

-- 12. SALES
CREATE OR REPLACE TABLE sales (sale_id INT, sale_amount DECIMAL(10,2));
INSERT INTO sales VALUES
(1,1500.00),(2,2300.00),(3,1800.00),(4,2100.00),(5,950.00),(6,3200.00),(7,2800.00),(8,1600.00);

-- COMMAND ----------

-- 13. SYSTEM1 & SYSTEM2  (FULL OUTER JOIN reconciliation: expect ids 4, 5, 6)
CREATE OR REPLACE TABLE system1 (id INT, amount DECIMAL(10,2));
CREATE OR REPLACE TABLE system2 (id INT, amount DECIMAL(10,2));
INSERT INTO system1 VALUES (1,500.00),(2,1200.00),(3,750.00),(4,300.00),(5,900.00);
INSERT INTO system2 VALUES (1,500.00),(2,1200.00),(3,750.00),(4,350.00),(6,450.00);

-- COMMAND ----------

-- 14. MONTHLY_SALES  (order by month_num, not month)
CREATE OR REPLACE TABLE monthly_sales (id INT, product_id INT, month STRING, month_num INT, sales DECIMAL(12,2));
INSERT INTO monthly_sales VALUES
(1,1,'January',1,12000.00),(2,1,'February',2,13500.00),(3,1,'March',3,11800.00),
(4,2,'January',1,2500.00),(5,2,'February',2,2800.00),(6,2,'March',3,2300.00),
(7,3,'January',1,1200.00),(8,3,'February',2,1500.00),(9,3,'March',3,1800.00),
(10,4,'January',1,3000.00),(11,4,'February',2,3500.00),(12,4,'March',3,2800.00);

-- COMMAND ----------

-- 15. CUSTOMER_SUMMARY
CREATE OR REPLACE TABLE customer_summary (customer_id INT, total_orders INT, avg_order_value DECIMAL(10,2));
INSERT INTO customer_summary VALUES
(1,15,250.00),(2,12,80.00),(3,8,150.00),(4,3,60.00),(5,11,120.00),
(6,4,45.00),(7,20,300.00),(8,7,90.00),(9,13,200.00),(10,2,30.00);

-- COMMAND ----------

-- 16. CUSTOMER_TOTALS
CREATE OR REPLACE TABLE customer_totals (customer_id INT, total_spent DECIMAL(12,2));
INSERT INTO customer_totals VALUES
(1,4500.00),(2,1200.00),(3,8900.00),(4,350.00),(5,2100.00),
(6,150.00),(7,6700.00),(8,800.00),(9,12000.00),(10,500.00);

-- COMMAND ----------

-- 17. PRODUCT_VERSIONS
CREATE OR REPLACE TABLE product_versions (id INT, product_id INT, product_name STRING, version STRING, version_number INT, features STRING);
INSERT INTO product_versions VALUES
(1,1,'Laptop Pro','v1',1,'Dual-core processor, 8GB RAM'),
(2,1,'Laptop Pro','v2',2,'Quad-core processor, 16GB RAM'),
(3,5,'Coffee Maker','v1',1,'Basic brew, manual temperature'),
(4,5,'Coffee Maker','v2',2,'Faster brew cycle, quieter motor'),
(5,8,'USB Hub','v1',1,'Standard 4-port USB-A hub'),
(6,8,'USB Hub','v2',2,'Added USB-C, expanded to 7 ports');

-- COMMAND ----------

-- VERIFICATION: expected row counts
SELECT 'customers' AS table_name, COUNT(*) AS row_count FROM customers  -- 12
UNION ALL SELECT 'products', COUNT(*) FROM products                     -- 10
UNION ALL SELECT 'colors', COUNT(*) FROM colors                         -- 4
UNION ALL SELECT 'orders', COUNT(*) FROM orders                         -- 22
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items               -- 23
UNION ALL SELECT 'employees', COUNT(*) FROM employees                   -- 12
UNION ALL SELECT 'transactions', COUNT(*) FROM transactions             -- 15
UNION ALL SELECT 'subscriptions', COUNT(*) FROM subscriptions           -- 8
UNION ALL SELECT 'stock_prices', COUNT(*) FROM stock_prices             -- 14
UNION ALL SELECT 'trades', COUNT(*) FROM trades                         -- 15
UNION ALL SELECT 'accounts', COUNT(*) FROM accounts                     -- 10
UNION ALL SELECT 'sales', COUNT(*) FROM sales                           -- 8
UNION ALL SELECT 'system1', COUNT(*) FROM system1                       -- 5
UNION ALL SELECT 'system2', COUNT(*) FROM system2                       -- 5
UNION ALL SELECT 'monthly_sales', COUNT(*) FROM monthly_sales           -- 12
UNION ALL SELECT 'customer_summary', COUNT(*) FROM customer_summary     -- 10
UNION ALL SELECT 'customer_totals', COUNT(*) FROM customer_totals       -- 10
UNION ALL SELECT 'product_versions', COUNT(*) FROM product_versions     -- 6
ORDER BY table_name;