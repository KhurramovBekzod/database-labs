\c postgres
DROP DATABASE IF EXISTS advanced_db WITH (FORCE);
CREATE DATABASE advanced_db;
\c advanced_db

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name  VARCHAR(50),
    last_name   VARCHAR(50),
    department  VARCHAR(50),
    salary      NUMERIC(10,2),
    manager_id  INTEGER REFERENCES employees(employee_id),
    tenure      INTEGER
);

CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    region_id    INTEGER,
    product_name VARCHAR(100),
    amount       NUMERIC(12,2),
    status       VARCHAR(30)
);

CREATE TABLE warehouse_1 (
    product_id   INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    quantity     INTEGER
);

CREATE TABLE warehouse_2 (
    product_id   INTEGER PRIMARY KEY,
    product_name VARCHAR(100),
    quantity     INTEGER
);

CREATE TABLE sales (
    sale_id      SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    year         INTEGER,
    sales_amount NUMERIC(12,2)
);

INSERT INTO employees (first_name, last_name, department, salary, manager_id, tenure) VALUES
    ('Ruslan',  'Abdyldaev',     'Management',  150000, NULL, 15),
    ('Bermet',  'Usubalieva',    'Engineering', 120000, 1,    10),
    ('Daniyar', 'Omurov',        'Sales',        95000, 1,     8),
    ('Aibek',   'Sharshenov',    'Engineering', 110000, 2,     6),
    ('Bakyt',   'Mamatov',       'Engineering',  80000, 2,     3),
    ('Meerim',  'Bekova',        'Engineering',  80000, 4,     2),
    ('Aizada',  'Kasymova',      'Engineering',  65000, 4,     1),
    ('Ainura',  'Toktomamatova', 'Sales',        70000, 3,     7),
    ('Kanat',   'Jumabaev',      'Sales',        58000, 3,     4),
    ('Gulzat',  'Sultanova',     'Sales',        45000, 8,     1);

INSERT INTO orders (region_id, product_name, amount, status) VALUES
    (1, 'Server rack',    600000, 'Medium Priority'),
    (1, 'Laptops x200',   550000, 'High Priority'),
    (2, 'Office chairs',  400000, 'Low Priority'),
    (2, 'Printers',       300000, 'Cancelled'),
    (3, 'Network switch', 900000, 'High Priority'),
    (3, 'Monitors x100',  250000, 'Low Priority');

INSERT INTO warehouse_1 (product_id, product_name, quantity) VALUES
    (1, 'Laptop',   5),
    (2, 'Mouse',    0),
    (3, 'Keyboard', 12),
    (4, 'Monitor',  0);

INSERT INTO warehouse_2 (product_id, product_name, quantity) VALUES
    (2, 'Mouse',    0),
    (3, 'Keyboard', 0),
    (4, 'Monitor',  3),
    (5, 'Webcam',   7);

INSERT INTO sales (product_name, year, sales_amount) VALUES
    ('Laptop', 2022, 30000), ('Laptop', 2022, 20000),
    ('Laptop', 2023, 62000),
    ('Laptop', 2024, 71000),
    ('Phone',  2022, 40000),
    ('Phone',  2023, 38000),
    ('Phone',  2024, 25000), ('Phone', 2024, 20000),
    ('Tablet', 2023, 15000),
    ('Tablet', 2024, 22000);

\echo
\echo '================ PART 1: SUBQUERIES AND CTEs ================'
\echo '--- Scalar subquery: employees earning above the company average'
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);

\echo '--- Row subquery: returns one row (department, salary), here the top earner in Sales'
SELECT first_name, last_name, department, salary
FROM employees
WHERE (department, salary) = (
    SELECT department, MAX(salary)
    FROM employees
    WHERE department = 'Sales'
    GROUP BY department
);

\echo '--- Table subquery in FROM: average salary per department, then only those above 80000'
SELECT department, avg_salary
FROM (
    SELECT department, ROUND(AVG(salary), 2) AS avg_salary
    FROM employees
    GROUP BY department
) AS dept_avg
WHERE avg_salary > 80000;

\echo '--- CTE: regions with total sales over 1,000,000'
WITH regional_sales AS (
    SELECT region_id, SUM(amount) AS total_sales
    FROM orders
    GROUP BY region_id
)
SELECT region_id, total_sales
FROM regional_sales
WHERE total_sales > 1000000
ORDER BY region_id;

\echo
\echo '================ PART 2: RECURSIVE QUERIES AND SET OPERATIONS ================'
\echo '--- Recursive CTE: the whole org chart, starting from the top manager'
WITH RECURSIVE org_chart AS (
    SELECT employee_id, first_name, last_name, manager_id
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.first_name, e.last_name, e.manager_id
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT * FROM org_chart;

\echo '--- Recursive CTE with a level column: how far each person is from the top'
WITH RECURSIVE org_chart AS (
    SELECT employee_id, first_name, manager_id, 1 AS level
    FROM employees
    WHERE manager_id IS NULL
    UNION ALL
    SELECT e.employee_id, e.first_name, e.manager_id, oc.level + 1
    FROM employees e
    INNER JOIN org_chart oc ON e.manager_id = oc.employee_id
)
SELECT level, first_name, manager_id
FROM org_chart
ORDER BY level, employee_id;

\echo '--- UNION: all unique products from both warehouses'
SELECT product_name FROM warehouse_1
UNION
SELECT product_name FROM warehouse_2
ORDER BY product_name;

\echo '--- UNION ALL: same, but duplicates are kept'
SELECT product_name FROM warehouse_1
UNION ALL
SELECT product_name FROM warehouse_2
ORDER BY product_name;

\echo '--- INTERSECT: products out of stock in both warehouses'
SELECT product_id FROM warehouse_1 WHERE quantity = 0
INTERSECT
SELECT product_id FROM warehouse_2 WHERE quantity = 0;

\echo '--- EXCEPT: products in warehouse 1 but not in warehouse 2'
SELECT product_name FROM warehouse_1
EXCEPT
SELECT product_name FROM warehouse_2;

\echo
\echo '================ PART 3: WINDOW FUNCTIONS AND PARTITIONING ================'
\echo '--- RANK by salary within each department'
SELECT
    first_name,
    last_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_salary_rank
FROM employees;

\echo '--- ROW_NUMBER vs RANK vs DENSE_RANK (Bakyt and Meerim have the same salary)'
SELECT
    first_name,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_number,
    RANK()       OVER (ORDER BY salary DESC) AS rank,
    DENSE_RANK() OVER (ORDER BY salary DESC) AS dense_rank
FROM employees
WHERE department = 'Engineering';

\echo '--- LAG and LEAD: the next higher and next lower salary in the department'
SELECT
    first_name,
    department,
    salary,
    LAG(salary)  OVER (PARTITION BY department ORDER BY salary DESC) AS next_higher,
    LEAD(salary) OVER (PARTITION BY department ORDER BY salary DESC) AS next_lower
FROM employees
WHERE department IN ('Engineering', 'Sales');

\echo '--- Running total of salaries with SUM() OVER'
SELECT
    first_name,
    salary,
    SUM(salary) OVER (ORDER BY employee_id) AS running_total
FROM employees;

\echo
\echo '================ PART 4: PIVOT AND UNPIVOT ================'
\echo '--- The raw sales rows'
SELECT product_name, year, sales_amount
FROM sales
ORDER BY product_name, year;

\echo '--- Pivot with conditional aggregation: one column per year'
SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS year_2024
FROM sales
GROUP BY product_name
ORDER BY product_name;

\echo '--- Save the pivoted result as a table so it can be unpivoted'
CREATE TABLE pivoted_sales AS
SELECT
    product_name,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS year_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS year_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS year_2024
FROM sales
GROUP BY product_name;

\echo '--- Unpivot with UNION ALL: columns back into rows'
SELECT product_name, '2022' AS year, year_2022 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2023' AS year, year_2023 AS sales_amount FROM pivoted_sales
UNION ALL
SELECT product_name, '2024' AS year, year_2024 AS sales_amount FROM pivoted_sales
ORDER BY product_name, year;

\echo
\echo '================ PART 5: COMPLEX FILTERING, SORTING AND OPTIMIZATION ================'
\echo '--- FILTER: department total, and the average salary of people with tenure over 5'
SELECT
    employee_id,
    first_name,
    department,
    SUM(salary) OVER (PARTITION BY department) AS total_dept_salary,
    ROUND(AVG(salary) FILTER (WHERE tenure > 5) OVER (), 2) AS avg_salary_senior
FROM employees
ORDER BY employee_id;

\echo '--- Custom sorting with CASE: High, Medium, Low priority, then everything else'
SELECT product_name, status
FROM orders
ORDER BY
    CASE status
        WHEN 'High Priority' THEN 1
        WHEN 'Medium Priority' THEN 2
        WHEN 'Low Priority' THEN 3
        ELSE 4
    END;

\echo '--- EXPLAIN: the plan PostgreSQL would use (the query is not run)'
EXPLAIN
SELECT first_name, salary
FROM employees
WHERE department = 'Engineering';

\echo '--- EXPLAIN ANALYZE: runs the query and shows the actual time (numbers vary each run)'
EXPLAIN ANALYZE
SELECT first_name, salary
FROM employees
WHERE department = 'Engineering';

\echo '--- LIMIT for testing: only the first 3 rows'
SELECT first_name, last_name, department
FROM employees
ORDER BY employee_id
LIMIT 3;

\echo '================ END OF LAB 15 ================'
