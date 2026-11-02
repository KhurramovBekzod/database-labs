\c postgres
DROP DATABASE IF EXISTS query_db WITH (FORCE);
CREATE DATABASE query_db;
\c query_db

CREATE TABLE employees (
    id            SERIAL PRIMARY KEY,
    name          VARCHAR(100) NOT NULL,
    department    VARCHAR(50),
    department_id INTEGER,
    salary        NUMERIC(10,2)
);

CREATE TABLE sales (
    sale_id     SERIAL PRIMARY KEY,
    employee_id INTEGER REFERENCES employees(id),
    amount      NUMERIC(10,2)
);

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price        NUMERIC(10,2)
);

CREATE TABLE customers (
    customer_id   SERIAL PRIMARY KEY,
    customer_name VARCHAR(100)
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    email   VARCHAR(100)
);

INSERT INTO employees (name, department, department_id, salary) VALUES
    ('Aibek Sharshenov',  'Engineering', 5, 120000),
    ('Bakyt Mamatov',     'Engineering', 5,  80000),
    ('Ainura Toktomamatova','Sales',       3,  65000),
    ('Gulzat Sultanova',  'Sales',       3,  45000),
    ('Timur Asanov',      'Marketing',   7,  70000),
    ('Meerim Bekova',     'Engineering', 5,  72000),
    ('Nursultan Isakov',  'HR',          2,  50000),
    ('Bermet Usubalieva', 'Marketing',   7, 105000);

INSERT INTO sales (employee_id, amount) VALUES
    (3, 1500.00),
    (3,  800.00),
    (4,  300.00),
    (4, 2200.00),
    (5,  950.00);

INSERT INTO products (product_name, price) VALUES
    ('Strawberry',     35.00),
    ('Blueberry',      48.50),
    ('Raspberry Jam',  22.00),
    ('Apple',          10.00),
    ('Cranberry',      55.00),
    ('Coffee Beans',   20.00),
    ('Mystery Box',    NULL);

INSERT INTO customers (customer_name) VALUES
    ('Brad'),
    ('Brandon'),
    ('Branka'),
    ('Abraham'),
    ('Kubra'),
    ('bratislav');

INSERT INTO users (email) VALUES
    ('aibek@gmail.com'),
    ('Timur.Asanov@GMAIL.COM'),
    ('meerim@auca.kg'),
    ('bakyt@mail.ru'),
    ('not-an-email'),
    ('user@site');

SELECT * FROM employees;

SELECT name, department FROM employees;

SELECT name, salary, salary * 0.10 AS potential_bonus
FROM employees;

SELECT name, salary
FROM employees
WHERE department = 'Sales';

SELECT name
FROM employees
WHERE salary > 75000 AND department = 'Engineering';

SELECT product_name, price
FROM products
WHERE price BETWEEN 20 AND 50;

SELECT name, department
FROM employees
WHERE department <> 'Engineering' AND NOT salary < 60000;

SELECT product_name, price
FROM products
WHERE price IS NULL;

SELECT product_name, price
FROM products
WHERE price IS NOT NULL;

SELECT customer_name
FROM customers
WHERE customer_name LIKE 'Bra%';

SELECT customer_name
FROM customers
WHERE customer_name ILIKE 'bra%';

SELECT product_name
FROM products
WHERE product_name LIKE '%berry';

SELECT customer_name
FROM customers
WHERE customer_name LIKE 'Bra___';

SELECT email
FROM users
WHERE email ILIKE '%@gmail.com';

SELECT name
FROM employees
WHERE name ~ '^[AB]';

SELECT email
FROM users
WHERE email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$';

SELECT email
FROM users
WHERE email !~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$';

SELECT name, department
FROM employees
WHERE department_id IN (3, 5, 7);

SELECT name
FROM employees
WHERE id IN (SELECT employee_id FROM sales WHERE amount > 1000);

SELECT name
FROM employees e
WHERE EXISTS (
    SELECT 1
    FROM sales s
    WHERE s.employee_id = e.id AND s.amount > 1000
);

SELECT name
FROM employees e
WHERE NOT EXISTS (
    SELECT 1
    FROM sales s
    WHERE s.employee_id = e.id
)
ORDER BY name;

SELECT name, salary,
    CASE
        WHEN salary > 100000 THEN 'Senior'
        WHEN salary BETWEEN 60000 AND 100000 THEN 'Mid-Level'
        ELSE 'Junior'
    END AS employee_level
FROM employees;

WITH department_averages AS (
    SELECT
        department,
        AVG(salary) AS avg_salary
    FROM employees
    GROUP BY department
)
SELECT
    e.name,
    e.salary,
    e.department,
    ROUND(da.avg_salary, 2) AS avg_salary
FROM employees e
JOIN department_averages da ON e.department = da.department
WHERE e.salary > da.avg_salary;