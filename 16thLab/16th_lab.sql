\c postgres
DROP DATABASE IF EXISTS tx_db WITH (FORCE);
CREATE DATABASE tx_db;
\c tx_db

CREATE TABLE accounts (
    account_id INTEGER PRIMARY KEY,
    owner      VARCHAR(50),
    balance    DECIMAL(10,2)
);

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100),
    email       VARCHAR(100)
);

CREATE TABLE orders (
    id          SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    total       DECIMAL(10,2)
);

CREATE TABLE inventory (
    product_id INTEGER PRIMARY KEY,
    stock      INTEGER
);

CREATE TABLE order_items (
    order_id   INTEGER REFERENCES orders(id),
    product_id INTEGER REFERENCES inventory(product_id),
    quantity   INTEGER
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    name       VARCHAR(100),
    price      DECIMAL(10,2) CHECK (price > 0)
);

CREATE TABLE logs (
    log_id  SERIAL PRIMARY KEY,
    message TEXT
);

CREATE TABLE audit_log (
    log_id    SERIAL PRIMARY KEY,
    action    VARCHAR(50),
    timestamp TIMESTAMP
);

CREATE TABLE users (
    id    SERIAL PRIMARY KEY,
    name  VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

CREATE TABLE user_preferences (
    user_id INTEGER REFERENCES users(id),
    theme   VARCHAR(20)
);

INSERT INTO accounts VALUES
    (1, 'Aibek',  1500.00),
    (2, 'Ainura',  800.00),
    (3, 'Bakyt',    50.00);

INSERT INTO customers (name, email) VALUES ('Aibek', 'aibek@email.com');

INSERT INTO inventory VALUES (101, 20), (102, 15), (103, 5);

\echo
\echo '================ PART 1: BEGIN, COMMIT, ROLLBACK ================'
\echo '--- Starting balances'
SELECT * FROM accounts ORDER BY account_id;

\echo '--- COMMIT: move 100 from account 1 to account 2, both updates are saved'
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;
SELECT * FROM accounts ORDER BY account_id;

\echo '--- ROLLBACK: the same transfer, then undo it'
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
\echo '--- Inside the transaction, before ROLLBACK: the change is visible'
SELECT * FROM accounts ORDER BY account_id;
ROLLBACK;
\echo '--- After ROLLBACK: balances are back to 1400 and 900'
SELECT * FROM accounts ORDER BY account_id;

\echo '--- Bank transfer: check the balance, then move 500 from account 1 to account 2'
BEGIN;
SELECT balance FROM accounts WHERE account_id = 1;
UPDATE accounts SET balance = balance - 500 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;
COMMIT;
SELECT * FROM accounts ORDER BY account_id;

\echo
\echo '================ PART 2: ACID PROPERTIES ================'
\echo '--- Atomicity: an order, its item and the stock update, all committed together'
BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 250.00);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 101, 2);
UPDATE inventory SET stock = stock - 2 WHERE product_id = 101;
COMMIT;
SELECT * FROM orders;
SELECT * FROM inventory WHERE product_id = 101;

\echo '--- Atomicity when something fails: product 999 does not exist (EXPECTED ERROR)'
BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 80.00);
INSERT INTO order_items (order_id, product_id, quantity) VALUES (currval('orders_id_seq'), 999, 1);
COMMIT;
\echo '--- COMMIT turned into ROLLBACK, so the 80.00 order was not saved either'
SELECT * FROM orders;

\echo '--- Consistency: a new customer and an order that points to it'
BEGIN;
INSERT INTO customers (name, email) VALUES ('John Doe', 'john@email.com');
INSERT INTO orders (customer_id, total) VALUES (currval('customers_customer_id_seq'), 100.00);
COMMIT;
SELECT o.id, c.name, o.total
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id
ORDER BY o.id;

\echo '--- Durability: reconnect, which starts a new session, and the committed data is still there'
\c tx_db
SELECT * FROM accounts ORDER BY account_id;

\echo
\echo '================ PART 3: ISOLATION LEVELS ================'
\echo '--- READ UNCOMMITTED (PostgreSQL treats it as READ COMMITTED, so no dirty reads)'
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM accounts ORDER BY account_id;
COMMIT;

\echo '--- READ COMMITTED (the default)'
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SHOW transaction_isolation;
SELECT * FROM accounts WHERE balance > 1000;
SELECT * FROM accounts WHERE balance > 1000;
COMMIT;

\echo '--- REPEATABLE READ'
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SHOW transaction_isolation;
SELECT * FROM accounts WHERE balance > 1000;
SELECT * FROM accounts WHERE balance > 1000;
COMMIT;

\echo '--- SERIALIZABLE: add 5% interest to every account'
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
SHOW transaction_isolation;
SELECT * FROM accounts ORDER BY account_id;
UPDATE accounts SET balance = balance * 1.05;
COMMIT;
SELECT * FROM accounts ORDER BY account_id;

\echo '--- SET TRANSACTION: choose the level as the first statement after BEGIN'
BEGIN;
SET TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SHOW transaction_isolation;
COMMIT;

\echo
\echo '================ PART 4: SAVEPOINTS ================'
\echo '--- ROLLBACK TO SAVEPOINT: undo the 500.00 order, keep the customer, add a 300.00 order'
BEGIN;
INSERT INTO customers (name, email) VALUES ('Alice', 'alice@email.com');
SAVEPOINT after_customer_insert;
INSERT INTO orders (customer_id, total) VALUES (1, 500.00);
ROLLBACK TO SAVEPOINT after_customer_insert;
INSERT INTO orders (customer_id, total) VALUES (1, 300.00);
COMMIT;
SELECT * FROM customers ORDER BY customer_id;
SELECT * FROM orders ORDER BY id;

\echo '--- Multiple savepoints: the negative price breaks the CHECK rule (EXPECTED ERROR)'
BEGIN;
INSERT INTO products (name, price) VALUES ('Laptop', 999.99);
SAVEPOINT sp1;
INSERT INTO products (name, price) VALUES ('Mouse', 25.99);
SAVEPOINT sp2;
INSERT INTO products (name, price) VALUES ('Invalid Product', -50.00);
ROLLBACK TO SAVEPOINT sp2;
INSERT INTO products (name, price) VALUES ('Keyboard', 79.99);
COMMIT;
\echo '--- Laptop, Mouse and Keyboard were committed, the invalid product was not'
SELECT * FROM products ORDER BY product_id;

\echo '--- RELEASE SAVEPOINT: the work is fine, so the savepoint is no longer needed'
BEGIN;
INSERT INTO logs (message) VALUES ('Starting process');
SAVEPOINT process_start;
INSERT INTO logs (message) VALUES ('Process completed');
RELEASE SAVEPOINT process_start;
COMMIT;
SELECT * FROM logs ORDER BY log_id;

\echo
\echo '================ PART 5: BEST PRACTICES ================'
\echo '--- Keep transactions short: one stock update and one order item'
BEGIN;
UPDATE inventory SET stock = stock - 1 WHERE product_id = 101;
INSERT INTO order_items (order_id, product_id, quantity) VALUES (1, 101, 1);
COMMIT;
SELECT * FROM inventory WHERE product_id = 101;

\echo '--- Handle errors: account 1 has enough money, so the transfer happens'
DO $$
DECLARE
    current_balance DECIMAL;
BEGIN
    SELECT balance INTO current_balance FROM accounts WHERE account_id = 1;

    IF current_balance < 100 THEN
        RAISE EXCEPTION 'insufficient_funds';
    END IF;

    UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

EXCEPTION
    WHEN raise_exception THEN
        RAISE NOTICE 'Transaction failed: Insufficient funds';
END $$;
SELECT * FROM accounts ORDER BY account_id;

\echo '--- Handle errors: account 3 has less than 100, so the block stops and nothing changes'
DO $$
DECLARE
    current_balance DECIMAL;
BEGIN
    SELECT balance INTO current_balance FROM accounts WHERE account_id = 3;

    IF current_balance < 100 THEN
        RAISE EXCEPTION 'insufficient_funds';
    END IF;

    UPDATE accounts SET balance = balance - 100 WHERE account_id = 3;
    UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;

EXCEPTION
    WHEN raise_exception THEN
        RAISE NOTICE 'Transaction failed: Insufficient funds';
END $$;
SELECT * FROM accounts ORDER BY account_id;

\echo '--- Appropriate isolation levels: SERIALIZABLE for money, READ COMMITTED for reports'
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE accounts SET balance = balance - 50 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 50 WHERE account_id = 3;
COMMIT;
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT COUNT(*) AS accounts, SUM(balance) AS total_money FROM accounts;
COMMIT;

\echo '--- Savepoints for complex operations: an order with two items'
BEGIN;
INSERT INTO orders (customer_id, total) VALUES (1, 1000.00);
SAVEPOINT before_items;
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (currval('orders_id_seq'), 101, 2);
INSERT INTO order_items (order_id, product_id, quantity)
VALUES (currval('orders_id_seq'), 102, 1);
COMMIT;
SELECT * FROM order_items ORDER BY order_id, product_id;

\echo '--- Monitor locks: blocked transactions (0 rows means nothing is blocked)'
SELECT
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks
    ON blocking_locks.locktype = blocked_locks.locktype
    AND blocking_locks.pid <> blocked_locks.pid
    AND blocking_locks.granted
JOIN pg_catalog.pg_stat_activity blocking_activity
    ON blocking_activity.pid = blocking_locks.pid
WHERE NOT blocked_locks.granted;

\echo '--- Explicit transaction: audit entry, user and preferences saved together'
BEGIN;
INSERT INTO audit_log (action, timestamp) VALUES ('user_creation', NOW());
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
INSERT INTO user_preferences (user_id, theme) VALUES (currval('users_id_seq'), 'dark');
COMMIT;

\echo '--- Avoid autocommit: the same email again fails, but the audit entry is already saved (EXPECTED ERROR)'
INSERT INTO audit_log (action, timestamp) VALUES ('user_creation', NOW());
INSERT INTO users (name, email) VALUES ('John Doe', 'john@example.com');
\echo '--- Two audit entries but only one user: the second entry describes something that never happened'
SELECT action, COUNT(*) FROM audit_log GROUP BY action;
SELECT id, name, email FROM users;

\echo '================ END OF LAB 16 ================'
