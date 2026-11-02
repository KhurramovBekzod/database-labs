\c postgres
DROP DATABASE IF EXISTS agg_db WITH (FORCE);
CREATE DATABASE agg_db;
\c agg_db

CREATE TABLE employees (
    employee_id      SERIAL PRIMARY KEY,
    first_name       VARCHAR(50),
    last_name        VARCHAR(50),
    email            VARCHAR(100),
    department       VARCHAR(50),
    salary           NUMERIC(10,2),
    age              INTEGER,
    hire_date        DATE,
    experience_years INTEGER,
    bonus            NUMERIC(10,2)
);

CREATE TABLE employee_skills (
    employee_id INTEGER REFERENCES employees(employee_id),
    skill_name  VARCHAR(50)
);

CREATE TABLE sales_data (
    department   VARCHAR(50),
    sales_amount NUMERIC(10,2)
);

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    category     VARCHAR(50),
    price        NUMERIC(10,2)
);

CREATE TABLE sales (
    sale_id   SERIAL PRIMARY KEY,
    sale_date DATE,
    amount    NUMERIC(10,2)
);

CREATE TABLE product_reviews (
    review_id  SERIAL PRIMARY KEY,
    product_id INTEGER REFERENCES products(product_id),
    rating     NUMERIC(2,1)
);

INSERT INTO employees (first_name, last_name, email, department, salary, age, hire_date, experience_years, bonus) VALUES
    ('Aibek',     'Sharshenov',    'aibek@company.kg',     'Engineering', 120000, 34, '2019-03-01', 10, 12000),
    ('Bakyt',     'Mamatov',       'bakyt@company.kg',     'Engineering',  80000, 28, '2022-06-15',  4, NULL),
    ('Meerim',    'Bekova',        'meerim@company.kg',    'Engineering',  72000, 26, '2023-09-01',  3, 5000),
    ('Daniyar',   'Omurov',        'daniyar@company.kg',   'Engineering',  95000, 41, '2016-02-10', 15, 9000),
    ('Aizada',    'Kasymova',      NULL,                   'Engineering',  65000, 24, '2024-01-20',  1, NULL),
    ('Ruslan',    'Abdyldaev',     'ruslan@company.kg',    'Engineering', 110000, 52, '2010-05-05', 25, 15000),
    ('Ainura',    'Toktomamatova', 'ainura@company.kg',    'Sales',        65000, 31, '2020-04-01',  7, 4000),
    ('Gulzat',    'Sultanova',     NULL,                   'Sales',        45000, 23, '2024-03-15',  1, NULL),
    ('Kanat',     'Jumabaev',      'kanat@company.kg',     'Sales',        58000, 36, '2018-11-11',  9, 3000),
    ('Elnura',    'Asanova',       'elnura@company.kg',    'Sales',        49000, 29, '2023-02-01',  4, NULL),
    ('Timur',     'Asanov',        'timur@company.kg',     'Marketing',    70000, 33, '2021-07-01',  8, 6000),
    ('Bermet',    'Usubalieva',    'bermet@company.kg',    'Marketing',   105000, 45, '2015-09-09', 18, 10000),
    ('Nursultan', 'Isakov',        NULL,                   'HR',           50000, 38, '2017-01-15', 12, NULL),
    ('Aigerim',   'Satybaldieva',  'aigerim@company.kg',   'HR',           47000, 27, '2023-05-20',  3, 2000);

INSERT INTO employee_skills (employee_id, skill_name) VALUES
    (1, 'SQL'), (1, 'Python'), (1, 'Docker'),
    (2, 'Java'), (2, 'SQL'),
    (3, 'HTML'), (3, 'Figma'), (3, 'CSS');

INSERT INTO sales_data (department, sales_amount) VALUES
    ('Sales',       12000), ('Sales',      8000), ('Sales', 9500),
    ('Engineering',  5000), ('Engineering', 7000),
    ('Marketing',    4000);

INSERT INTO products (product_name, category, price) VALUES
    ('Laptop',     'Electronics', 950.00),
    ('Phone',      'Electronics', 600.00),
    ('Headphones', 'Electronics', 120.00),
    ('Textbook',   'Books',        60.00),
    ('Novel',      'Books',        15.00),
    ('Coffee',     'Food',          8.00),
    ('Tea',        'Food',          5.00),
    ('Chocolate',  'Food',          3.00);

INSERT INTO sales (sale_date, amount) VALUES
    ('2025-08-14', 1200), ('2025-09-02',  800),
    ('2025-10-20', 1500), ('2025-11-05', 2100), ('2025-12-18', 3000),
    ('2026-01-10',  900), ('2026-03-22', 1100),
    ('2026-04-15', 1700), ('2026-06-30', 1300),
    ('2026-07-07', 2500);

INSERT INTO product_reviews (product_id, rating) VALUES
    (1, 5.0), (1, 4.5), (1, 4.0), (1, 5.0), (1, 4.5), (1, 4.0),
    (1, 5.0), (1, 4.5), (1, 3.5), (1, 5.0), (1, 4.5), (1, 4.0),
    (2, 4.0), (2, 3.5), (2, 3.0), (2, 4.0), (2, 4.5),
    (2, 3.5), (2, 4.0), (2, 3.0), (2, 4.0), (2, 3.5),
    (4, 5.0), (4, 5.0), (4, 4.5);

\echo
\echo '================ PART 1: COUNT, SUM, AVG, MAX, MIN ================'
\echo '--- COUNT(*): total number of employees'
SELECT COUNT(*) AS total_employees
FROM employees;

\echo '--- COUNT(email): employees with an email address'
SELECT COUNT(email) AS employees_with_email
FROM employees;

\echo '--- COUNT(DISTINCT department): unique departments'
SELECT COUNT(DISTINCT department) AS unique_departments
FROM employees;

\echo '--- SUM(salary): total salary expenditure'
SELECT SUM(salary) AS total_salaries
FROM employees;

\echo '--- SUM(sales_amount) by department'
SELECT department, SUM(sales_amount) AS total_sales
FROM sales_data
GROUP BY department;

\echo '--- AVG(salary): average salary'
SELECT ROUND(AVG(salary), 2) AS average_salary
FROM employees;

\echo '--- AVG(age) by department'
SELECT department, ROUND(AVG(age), 1) AS avg_age
FROM employees
GROUP BY department;

\echo '--- MAX and MIN salary'
SELECT
    MAX(salary) AS highest_salary,
    MIN(salary) AS lowest_salary
FROM employees;

\echo '--- MAX(hire_date): most recent hire by department'
SELECT department, MAX(hire_date) AS latest_hire
FROM employees
GROUP BY department;

\echo
\echo '================ PART 2: STRING_AGG, ARRAY_AGG, STATISTICS ================'
\echo '--- STRING_AGG: employees in each department'
SELECT department, STRING_AGG(first_name, ', ') AS employee_names
FROM employees
GROUP BY department;

\echo '--- STRING_AGG with ORDER BY: skills per employee'
SELECT employee_id, STRING_AGG(skill_name, ', ' ORDER BY skill_name) AS skills
FROM employee_skills
GROUP BY employee_id;

\echo '--- ARRAY_AGG: salaries in each department'
SELECT department, ARRAY_AGG(salary) AS salary_array
FROM employees
GROUP BY department;

\echo '--- ARRAY_AGG with ORDER BY: names ordered by last name'
SELECT department, ARRAY_AGG(first_name ORDER BY last_name) AS employees
FROM employees
GROUP BY department;

\echo '--- STDDEV and VARIANCE of salary by department'
SELECT
    department,
    ROUND(STDDEV(salary), 2)   AS salary_std_dev,
    ROUND(VARIANCE(salary), 2) AS salary_variance
FROM employees
GROUP BY department;

\echo '--- CORR: correlation between experience and salary'
SELECT ROUND(CORR(experience_years, salary)::NUMERIC, 4) AS experience_salary_correlation
FROM employees;

\echo
\echo '================ PART 3: GROUP BY AND HAVING ================'
\echo '--- Basic GROUP BY: products by category'
SELECT
    category,
    COUNT(*) AS number_of_products,
    SUM(price) AS total_value,
    ROUND(AVG(price), 2) AS average_price
FROM products
GROUP BY category;

\echo '--- Multiple column grouping: sales by year and quarter'
SELECT
    EXTRACT(YEAR FROM sale_date) AS year,
    EXTRACT(QUARTER FROM sale_date) AS quarter,
    COUNT(*) AS total_sales,
    SUM(amount) AS total_revenue
FROM sales
GROUP BY EXTRACT(YEAR FROM sale_date), EXTRACT(QUARTER FROM sale_date)
ORDER BY year, quarter;

\echo '--- GROUP BY an expression: age groups'
SELECT
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END AS age_group,
    COUNT(*) AS employee_count,
    ROUND(AVG(salary), 2) AS avg_salary
FROM employees
GROUP BY
    CASE
        WHEN age < 30 THEN 'Under 30'
        WHEN age BETWEEN 30 AND 50 THEN '30-50'
        ELSE 'Over 50'
    END;

\echo '--- HAVING: departments with more than 5 employees'
SELECT
    department,
    COUNT(*) AS employee_count
FROM employees
GROUP BY department
HAVING COUNT(*) > 5;

\echo '--- HAVING: products with average rating above 4.0 and at least 10 reviews'
SELECT
    product_id,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*) AS review_count
FROM product_reviews
GROUP BY product_id
HAVING AVG(rating) > 4.0 AND COUNT(*) >= 10;

\echo
\echo '================ PART 4: WINDOW FUNCTIONS AND NULL VALUES ================'
\echo '--- Aggregate function: one row per department'
SELECT department, ROUND(AVG(salary), 2) AS dept_avg_salary
FROM employees
GROUP BY department;

\echo '--- Window function: every employee, with the department average'
SELECT
    employee_id,
    first_name,
    department,
    salary,
    ROUND(AVG(salary) OVER (PARTITION BY department), 2) AS dept_avg_salary
FROM employees
ORDER BY department, employee_id;

\echo '--- NULLs: COUNT(*) includes them, COUNT(email) does not'
SELECT
    COUNT(*) AS total_rows,
    COUNT(email) AS non_null_emails,
    COUNT(*) - COUNT(email) AS null_emails
FROM employees;

\echo '--- NULLs: SUM, AVG and COUNT(bonus) ignore them'
SELECT
    SUM(bonus) AS total_bonus,
    ROUND(AVG(bonus), 2) AS avg_bonus,
    COUNT(bonus) AS employees_with_bonus
FROM employees;

\echo
\echo '================ PART 5: COMMON PATTERNS ================'
\echo '--- 1. Combining multiple aggregations'
SELECT
    department,
    COUNT(*) AS employee_count,
    MIN(salary) AS min_salary,
    MAX(salary) AS max_salary,
    ROUND(AVG(salary), 2) AS avg_salary,
    ROUND(STDDEV(salary), 2) AS salary_std_dev
FROM employees
GROUP BY department
ORDER BY avg_salary DESC;

\echo '--- 2. Conditional aggregation'
SELECT
    department,
    COUNT(*) AS total_employees,
    COUNT(CASE WHEN salary > 50000 THEN 1 END) AS high_earners,
    COUNT(CASE WHEN hire_date > '2023-01-01' THEN 1 END) AS recent_hires
FROM employees
GROUP BY department;

\echo '--- 3. Percentage of all employees in each department'
SELECT
    department,
    COUNT(*) AS dept_count,
    ROUND((COUNT(*)::FLOAT / (SELECT COUNT(*) FROM employees) * 100)::NUMERIC, 2) AS percentage
FROM employees
GROUP BY department
ORDER BY percentage DESC;

\echo '================ END OF LAB 13 ================'
