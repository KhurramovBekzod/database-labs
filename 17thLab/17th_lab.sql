\c postgres
DROP DATABASE IF EXISTS backup_restore_test WITH (FORCE);
DROP DATABASE IF EXISTS backup_single_table WITH (FORCE);
DROP DATABASE IF EXISTS backup_db WITH (FORCE);
CREATE DATABASE backup_db;
\c backup_db

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    email       VARCHAR(100),
    department  VARCHAR(50)
);

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price        NUMERIC(10,2)
);

CREATE TABLE products_import (
    product_id   INTEGER,
    product_name VARCHAR(100),
    price        NUMERIC(10,2)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    city        VARCHAR(50)
);

CREATE TABLE orders (
    order_id    SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date  DATE,
    total       NUMERIC(10,2)
);

CREATE TABLE customer_feedback (
    feedback_id SERIAL PRIMARY KEY,
    customer    VARCHAR(100),
    comment     TEXT
);

CREATE TABLE sales_data (
    region VARCHAR(50),
    amount NUMERIC(10,2)
);

CREATE TABLE target_customers (
    customer_id INTEGER PRIMARY KEY,
    name        VARCHAR(100),
    city        VARCHAR(50)
);

INSERT INTO employees (first_name, last_name, email, department) VALUES
    ('Aibek',  'Sharshenov',    'aibek@company.kg',  'IT'),
    ('Ainura', 'Toktomamatova', NULL,                'Sales'),
    ('Bakyt',  'Mamatov',       'bakyt@company.kg',  'IT'),
    ('Meerim', 'Bekova',        'meerim@company.kg', 'HR');

INSERT INTO products (product_name, price) VALUES
    ('Laptop',   950.00),
    ('Mouse',     25.00),
    ('Keyboard',  45.00);

INSERT INTO customers (name, city) VALUES
    ('Aibek',  'Bishkek'),
    ('Ainura', 'Osh'),
    ('Bakyt',  'Karakol'),
    ('Gulzat', 'Naryn');

INSERT INTO orders (customer_id, order_date, total) VALUES
    (1, '2026-09-01', 250.00),
    (2, '2026-09-15',  95.50),
    (3, '2026-10-02', 430.00);

INSERT INTO customer_feedback (customer, comment) VALUES
    ('Aibek',  'Fast delivery, good price'),
    ('Ainura', 'The box said "fragile", but it was fine'),
    ('Bakyt',  'Okay');

INSERT INTO target_customers VALUES
    (1, 'Aibek', 'Old city'),
    (9, 'Timur', 'Talas');

\echo
\echo '================ PART 1: COPY COMMAND ================'
\echo '--- COPY TO: export the whole employees table to a CSV file'
\copy employees TO 'C:/Database Lab/lab17/employees.csv' WITH CSV HEADER

\echo '--- COPY TO with a | delimiter and N/A for NULL (Ainura has no email)'
\copy employees TO 'C:/Database Lab/lab17/employees.txt' WITH DELIMITER '|' NULL 'N/A' CSV HEADER
\echo '--- What the file looks like'
\! type "C:\Database Lab\lab17\employees.txt"

\echo '--- Create a CSV file of new employees to import'
\copy (SELECT * FROM (VALUES ('Timur', 'Asanov', 'timur@company.kg'), ('Gulzat', 'Sultanova', 'gulzat@company.kg')) AS t(first_name, last_name, email)) TO 'C:/Database Lab/lab17/new_employees.csv' WITH CSV HEADER

\echo '--- COPY FROM: import specific columns only (department stays empty)'
\copy employees(first_name, last_name, email) FROM 'C:/Database Lab/lab17/new_employees.csv' WITH CSV HEADER
SELECT * FROM employees ORDER BY employee_id;

\echo '--- COPY a query result: only the IT employees'
\copy (SELECT * FROM employees WHERE department = 'IT') TO 'C:/Database Lab/lab17/it_employees.csv' WITH CSV HEADER

\echo
\echo '================ PART 2: CSV IMPORT AND EXPORT ================'
\echo '--- Basic CSV export with headers'
\copy products TO 'C:/Database Lab/lab17/products.csv' WITH CSV HEADER

\echo '--- CSV export with ; as the delimiter'
\copy customers TO 'C:/Database Lab/lab17/customers.csv' WITH CSV HEADER DELIMITER ';' QUOTE '"'

\echo '--- CSV export with order_date always in quotes'
\copy orders TO 'C:/Database Lab/lab17/orders.csv' WITH (FORMAT csv, HEADER true, FORCE_QUOTE (order_date))
\echo '--- What the file looks like'
\! type "C:\Database Lab\lab17\orders.csv"

\echo '--- Basic CSV import: products.csv into a second table (products_import)'
\copy products_import FROM 'C:/Database Lab/lab17/products.csv' WITH (FORMAT csv, HEADER true)
SELECT * FROM products_import ORDER BY product_id;

\echo '--- Create a CSV file where one row has a bad price'
\copy (SELECT * FROM (VALUES (4, 'Monitor', '180.00'), (5, 'Broken row', 'not-a-number'), (6, 'Webcam', '60.00')) AS t(product_id, product_name, price)) TO 'C:/Database Lab/lab17/products_with_errors.csv' WITH CSV HEADER

\echo '--- Import with ON_ERROR ignore: the bad row is skipped, the other two are loaded'
\copy products_import FROM 'C:/Database Lab/lab17/products_with_errors.csv' WITH (FORMAT csv, HEADER true, ON_ERROR ignore)
SELECT * FROM products_import ORDER BY product_id;

\echo '--- Import with a specific encoding (UTF8)'
TRUNCATE products_import;
\copy products_import FROM 'C:/Database Lab/lab17/products.csv' WITH CSV HEADER ENCODING 'UTF8'
SELECT * FROM products_import ORDER BY product_id;

\echo '--- Embedded commas and quotes: the export puts those values in quotes'
\copy customer_feedback TO 'C:/Database Lab/lab17/feedback.csv' WITH CSV HEADER DELIMITER ',' QUOTE '"' ESCAPE '"'
\echo '--- What the file looks like: quotes inside a value are doubled'
\! type "C:\Database Lab\lab17\feedback.csv"

\echo '--- Create a sales file where NULL is written as the word NULL'
\copy (SELECT * FROM (VALUES ('North', '1200.00'), ('South', 'NULL'), ('East', '800.00')) AS t(region, amount)) TO 'C:/Database Lab/lab17/sales.csv' WITH CSV HEADER

\echo '--- Import with NULL ''NULL'': the word NULL becomes a real NULL'
\copy sales_data FROM 'C:/Database Lab/lab17/sales.csv' WITH CSV HEADER NULL 'NULL'
SELECT region, amount, amount IS NULL AS is_null FROM sales_data;

\echo
\echo '================ PART 3: DATA MIGRATION (ETL) ================'
\echo '--- Create an empty staging table with the same columns as customers'
CREATE TABLE staging_customers AS SELECT * FROM customers WHERE 1=0;
SELECT COUNT(*) AS staging_rows FROM staging_customers;

\echo '--- Extract a batch of customers to a CSV file'
\copy (SELECT * FROM customers ORDER BY customer_id LIMIT 10000 OFFSET 0) TO 'C:/Database Lab/lab17/customers_batch_1.csv' WITH CSV HEADER

\echo '--- Load the batch into the staging table'
\copy staging_customers FROM 'C:/Database Lab/lab17/customers_batch_1.csv' WITH CSV HEADER
SELECT * FROM staging_customers;

\echo '--- Target table before the merge'
SELECT * FROM target_customers ORDER BY customer_id;

\echo '--- Merge: new customers are inserted, existing ones (id 1) are updated'
INSERT INTO target_customers
SELECT * FROM staging_customers
ON CONFLICT (customer_id) DO UPDATE SET
    name = EXCLUDED.name,
    city = EXCLUDED.city;

\echo '--- Target table after the merge: Aibek now has Bishkek, Timur is untouched'
SELECT * FROM target_customers ORDER BY customer_id;

\echo '--- Validation: row counts (the target has one more, Timur was already there)'
SELECT
    (SELECT COUNT(*) FROM customers)        AS source_rows,
    (SELECT COUNT(*) FROM target_customers) AS target_rows;

\echo '--- Partitioning a large table by date, so each year can be migrated separately'
CREATE TABLE large_table (
    id         INTEGER,
    created_at DATE,
    value      NUMERIC
) PARTITION BY RANGE (created_at);
CREATE TABLE large_table_2023 PARTITION OF large_table
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');
CREATE TABLE large_table_2024 PARTITION OF large_table
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');
INSERT INTO large_table VALUES
    (1, '2023-03-10', 10), (2, '2023-11-20', 20), (3, '2024-05-05', 30);
SELECT tableoid::regclass AS partition, id, created_at FROM large_table ORDER BY id;

\echo '--- Monitor pg_dump progress (0 rows when no pg_dump is running)'
SELECT pid, usename, application_name, client_addr, state
FROM pg_stat_activity
WHERE application_name = 'pg_dump';

\echo
\echo '================ PART 4: WAL AND POINT-IN-TIME RECOVERY SETTINGS ================'
\echo '--- Current WAL settings (read only, nothing is changed)'
SHOW wal_level;
SHOW archive_mode;
SHOW archive_command;

\echo '--- Create a named restore point that PITR could recover to'
SELECT pg_create_restore_point('before_data_migration');

\echo '--- Force a switch to a new WAL file'
SELECT pg_switch_wal();

\echo '================ END OF LAB 17 (SQL part) ================'
