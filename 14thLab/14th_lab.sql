\c postgres
DROP DATABASE IF EXISTS join_db WITH (FORCE);
CREATE DATABASE join_db;
\c join_db

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    email       VARCHAR(100)
);

CREATE TABLE orders (
    order_id     SERIAL PRIMARY KEY,
    customer_id  INTEGER REFERENCES customers(customer_id),
    order_date   DATE,
    total_amount DECIMAL(10,2)
);

CREATE TABLE products (
    product_id   SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price        DECIMAL(10,2)
);

CREATE TABLE order_items (
    order_item_id SERIAL PRIMARY KEY,
    order_id      INTEGER REFERENCES orders(order_id),
    product_id    INTEGER REFERENCES products(product_id),
    quantity      INTEGER
);

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    manager_id  INTEGER REFERENCES employees(employee_id)
);

CREATE TABLE users (
    user_id  SERIAL PRIMARY KEY,
    username VARCHAR(50)
);

CREATE TABLE user_profiles (
    user_id    INTEGER PRIMARY KEY REFERENCES users(user_id),
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    phone      VARCHAR(20)
);

CREATE TABLE authors (
    author_id   SERIAL PRIMARY KEY,
    author_name VARCHAR(100)
);

CREATE TABLE books (
    book_id          SERIAL PRIMARY KEY,
    title            VARCHAR(200),
    publication_year INTEGER,
    author_id        INTEGER REFERENCES authors(author_id)
);

CREATE TABLE students (
    student_id   SERIAL PRIMARY KEY,
    student_name VARCHAR(100)
);

CREATE TABLE courses (
    course_id   SERIAL PRIMARY KEY,
    course_name VARCHAR(100)
);

CREATE TABLE enrollments (
    student_id      INTEGER REFERENCES students(student_id),
    course_id       INTEGER REFERENCES courses(course_id),
    enrollment_date DATE,
    grade           CHAR(2),
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO customers (name, email) VALUES
    ('Aibek',  'aibek@mail.kg'),
    ('Ainura', 'ainura@mail.kg'),
    ('Bakyt',  'bakyt@mail.kg'),
    ('Gulzat', 'gulzat@mail.kg');

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
    (1,    '2023-11-20',  80.00),
    (1,    '2024-02-14', 250.00),
    (2,    '2024-03-05',  95.50),
    (3,    '2024-05-10', 430.00),
    (NULL, '2024-06-01',  60.00);

INSERT INTO products (product_name, price) VALUES
    ('Laptop',   950.00),
    ('Mouse',     25.00),
    ('Notebook',   4.50);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
    (1, 2, 2),
    (2, 1, 1),
    (2, 3, 5),
    (3, 2, 1),
    (4, 1, 1),
    (5, 3, 10);

INSERT INTO employees (name, manager_id) VALUES
    ('Ruslan',  NULL),
    ('Bermet',  1),
    ('Daniyar', 1),
    ('Meerim',  3),
    ('Timur',   2);

INSERT INTO users (username) VALUES
    ('aibek_s'), ('ainura_t'), ('bakyt_m');

INSERT INTO user_profiles (user_id, first_name, last_name, phone) VALUES
    (1, 'Aibek',  'Sharshenov',    '+996 555 111 222'),
    (2, 'Ainura', 'Toktomamatova', '+996 700 333 444');

INSERT INTO authors (author_name) VALUES
    ('Jane Cooper'), ('John Miller'), ('Aziz Karimov');

INSERT INTO books (title, publication_year, author_id) VALUES
    ('Database Basics',    2019, 1),
    ('Advanced SQL',       2022, 1),
    ('Mountains of Asia',  2015, 3),
    ('Silk Road Stories',  2020, 3),
    ('Learning Python',    2018, 2);

INSERT INTO students (student_name) VALUES
    ('Aibek'), ('Meerim'), ('Timur');

INSERT INTO courses (course_name) VALUES
    ('Databases'), ('Algorithms'), ('Operating Systems');

INSERT INTO enrollments (student_id, course_id, enrollment_date, grade) VALUES
    (1, 1, '2026-09-01', 'A'),
    (1, 2, '2026-09-01', 'B+'),
    (2, 1, '2026-09-02', 'A-'),
    (2, 3, '2026-09-02', NULL),
    (3, 2, '2026-09-03', 'B');

\echo
\echo '================ PART 1: INNER, LEFT, RIGHT, FULL OUTER JOIN ================'
\echo '--- INNER JOIN: only customers who have orders'
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

\echo '--- LEFT JOIN: all customers, Gulzat has no orders (NULL)'
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id;

\echo '--- RIGHT JOIN: all orders, the guest order has no customer (NULL)'
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

\echo '--- FULL OUTER JOIN: all customers and all orders'
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

\echo
\echo '================ PART 2: CROSS, MULTIPLE TABLE, SELF JOIN, CONDITIONS ================'
\echo '--- CROSS JOIN: every customer with every product (4 x 3 = 12 rows)'
SELECT c.name, p.product_name
FROM customers c
CROSS JOIN products p;

\echo '--- Multiple table join: customers, orders, order_items, products'
SELECT c.name, o.order_date, oi.quantity, p.product_name, p.price
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

\echo '--- Self join: employees and their managers'
SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

\echo '--- Join with conditions: orders from 2024 over 100'
SELECT c.name, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_date >= '2024-01-01'
AND o.total_amount > 100;

\echo
\echo '================ PART 3: RELATIONSHIP TYPES ================'
\echo '--- One-to-one: users and profiles (bakyt_m has no profile)'
SELECT u.username, up.first_name, up.last_name, up.phone
FROM users u
LEFT JOIN user_profiles up ON u.user_id = up.user_id;

\echo '--- One-to-many: authors and their books (an author repeats per book)'
SELECT a.author_name, b.title, b.publication_year
FROM authors a
INNER JOIN books b ON a.author_id = b.author_id
ORDER BY a.author_name, b.publication_year;

\echo '--- Many-to-many: students and courses through enrollments (rows with no grade are left out)'
SELECT s.student_name, c.course_name, e.enrollment_date, e.grade
FROM students s
INNER JOIN enrollments e ON s.student_id = e.student_id
INNER JOIN courses c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL
ORDER BY s.student_name, c.course_name;

\echo
\echo '================ PART 4: PERFORMANCE AND COMMON PITFALLS ================'
\echo '--- Indexes on foreign key columns'
CREATE INDEX idx_orders_customer_id ON orders(customer_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_order_items_product_id ON order_items(product_id);

\echo '--- The three new indexes'
SELECT tablename, indexname
FROM pg_indexes
WHERE indexname LIKE 'idx_%'
ORDER BY indexname;

\echo '--- Table aliases: c for customers, o for orders'
SELECT c.name, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

\echo '--- Pitfall 1, wrong: no join condition gives a Cartesian product (4 x 5 = 20 rows)'
SELECT COUNT(*) AS rows_without_join_condition
FROM customers c, orders o;

\echo '--- Pitfall 1, correct: with the join condition'
SELECT c.name, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

\echo '--- Pitfall 2: find customers without orders using IS NULL'
SELECT c.name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.customer_id IS NULL;

\echo '================ END OF LAB 14 ================'
