DROP TABLE IF EXISTS student_enrollments;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS comments;
DROP TABLE IF EXISTS blog_posts;
DROP TABLE IF EXISTS user_profiles;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;



CREATE TABLE departments (
    dept_id   SERIAL PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL,
    location  VARCHAR(100)
);


CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments(dept_id)
);
DROP TABLE employees;


CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
DROP TABLE employees;


CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER
);
ALTER TABLE employees
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (dept_id) REFERENCES departments(dept_id);
DROP TABLE employees;


CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER,
    CONSTRAINT fk_employee_department
        FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);


INSERT INTO departments (dept_name, location) VALUES
    ('Engineering', 'Building A'),
    ('Marketing',   'Building B'),
    ('HR',          'Building C');

INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 1);


INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('Jane', 'Doe', 99);


UPDATE employees SET dept_id = 99 WHERE first_name = 'John';


DELETE FROM departments WHERE dept_id = 1;


SELECT * FROM departments;
SELECT * FROM employees;


DROP TABLE employees;
TRUNCATE departments RESTART IDENTITY;
INSERT INTO departments (dept_name, location) VALUES
    ('Engineering', 'Building A'), ('Marketing', 'Building B'), ('HR', 'Building C');

CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments(dept_id) ON DELETE CASCADE
);
INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 1), ('Jane', 'Doe', 1), ('Mike', 'Brown', 2);


DELETE FROM departments WHERE dept_id = 1;


SELECT * FROM employees;


DROP TABLE employees;
TRUNCATE departments RESTART IDENTITY;
INSERT INTO departments (dept_name, location) VALUES
    ('Engineering', 'Building A'), ('Marketing', 'Building B'), ('HR', 'Building C');

CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments(dept_id) ON DELETE SET NULL
);
INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 1), ('Jane', 'Doe', 1), ('Mike', 'Brown', 2);


DELETE FROM departments WHERE dept_id = 1;
SELECT * FROM employees;


DROP TABLE employees;
TRUNCATE departments RESTART IDENTITY;
INSERT INTO departments (dept_name, location) VALUES
    ('Engineering', 'Building A'), ('Marketing', 'Building B'), ('HR', 'Building C');

INSERT INTO departments (dept_id, dept_name) VALUES (0, 'Unassigned');

CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER DEFAULT 0 REFERENCES departments(dept_id) ON DELETE SET DEFAULT
);
INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 1), ('Jane', 'Doe', 1), ('Mike', 'Brown', 2);

DELETE FROM departments WHERE dept_id = 1;
SELECT * FROM employees;

DROP TABLE employees;
TRUNCATE departments RESTART IDENTITY;
INSERT INTO departments (dept_name, location) VALUES
    ('Engineering', 'Building A'), ('Marketing', 'Building B'), ('HR', 'Building C');

CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments(dept_id) ON DELETE RESTRICT
);
INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 1), ('Jane', 'Doe', 1), ('Mike', 'Brown', 2);


DELETE FROM departments WHERE dept_id = 1;


DROP TABLE employees;
TRUNCATE departments RESTART IDENTITY;
INSERT INTO departments (dept_name, location) VALUES
    ('Engineering', 'Building A'), ('Marketing', 'Building B'), ('HR', 'Building C');

CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments(dept_id) ON UPDATE CASCADE
);
INSERT INTO employees (first_name, last_name, dept_id) VALUES
    ('John', 'Smith', 1), ('Jane', 'Doe', 1), ('Mike', 'Brown', 2);


UPDATE departments SET dept_id = 100 WHERE dept_id = 1;


SELECT * FROM employees;


DROP TABLE employees;
CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    dept_id    INTEGER REFERENCES departments(dept_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);


CREATE TABLE users (
    user_id    SERIAL PRIMARY KEY,
    username   VARCHAR(50)  UNIQUE NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_profiles (
    profile_id          SERIAL PRIMARY KEY,
    user_id             INTEGER UNIQUE NOT NULL,
    first_name          VARCHAR(50),
    last_name           VARCHAR(50),
    bio                 TEXT,
    profile_picture_url VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

INSERT INTO users (username, email) VALUES
    ('johndoe', 'john@example.com');


INSERT INTO user_profiles (user_id, first_name, last_name, bio) VALUES
    (1, 'John', 'Doe', 'Software developer passionate about databases');


INSERT INTO user_profiles (user_id, first_name, last_name) VALUES
    (1, 'Jane', 'Smith');

SELECT u.username, u.email, p.first_name, p.last_name, p.bio
FROM users u
JOIN user_profiles p ON u.user_id = p.user_id;


DROP TABLE user_profiles;
CREATE TABLE user_profiles (
    user_id             INTEGER PRIMARY KEY,   
    first_name          VARCHAR(50),
    last_name           VARCHAR(50),
    bio                 TEXT,
    profile_picture_url VARCHAR(255),
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);
INSERT INTO user_profiles (user_id, first_name, last_name, bio) VALUES
    (1, 'John', 'Doe', 'Software developer passionate about databases');
SELECT * FROM user_profiles;


DROP TABLE employees;
DROP TABLE departments;


CREATE TABLE departments (
    dept_id      SERIAL PRIMARY KEY,
    dept_name    VARCHAR(100) NOT NULL,
    manager_name VARCHAR(100),
    budget       DECIMAL(10,2)
);


CREATE TABLE employees (
    emp_id     SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    position   VARCHAR(100),
    salary     DECIMAL(10,2),
    hire_date  DATE DEFAULT CURRENT_DATE,
    dept_id    INTEGER NOT NULL,   -- foreign key
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE RESTRICT
);


INSERT INTO departments (dept_name, manager_name, budget) VALUES
    ('Engineering', 'Alice Johnson', 500000.00),
    ('Marketing',   'Bob Wilson',    200000.00);


INSERT INTO employees (first_name, last_name, position, salary, dept_id) VALUES
    ('John',  'Smith', 'Software Engineer',    75000.00, 1),
    ('Jane',  'Doe',   'Senior Developer',     85000.00, 1),
    ('Mike',  'Brown', 'DevOps Engineer',      80000.00, 1),
    ('Sarah', 'Davis', 'Marketing Specialist', 55000.00, 2);

SELECT d.dept_name, e.first_name, e.last_name, e.position
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
ORDER BY d.dept_name, e.last_name;


CREATE TABLE blog_posts (
    post_id        SERIAL PRIMARY KEY,
    title          VARCHAR(200) NOT NULL,
    content        TEXT,
    author         VARCHAR(100),
    published_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE comments (
    comment_id     SERIAL PRIMARY KEY,
    post_id        INTEGER NOT NULL,   -- foreign key
    commenter_name VARCHAR(100),
    comment_text   TEXT NOT NULL,
    comment_date   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (post_id) REFERENCES blog_posts(post_id) ON DELETE CASCADE
);

INSERT INTO blog_posts (title, content, author) VALUES
    ('Learning Foreign Keys', 'Notes from lab 8.', 'Alice Johnson');
INSERT INTO comments (post_id, commenter_name, comment_text) VALUES
    (1, 'Bob',   'Very helpful, thanks.'),
    (1, 'Carol', 'Clear explanation.');

SELECT p.title, c.commenter_name, c.comment_text
FROM blog_posts p
JOIN comments c ON p.post_id = c.post_id;



CREATE TABLE students (
    student_id      SERIAL PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) UNIQUE,
    enrollment_date DATE DEFAULT CURRENT_DATE
);


CREATE TABLE courses (
    course_id   SERIAL PRIMARY KEY,
    course_code VARCHAR(10)  UNIQUE NOT NULL,
    course_name VARCHAR(100) NOT NULL,
    credits     INTEGER NOT NULL,
    instructor  VARCHAR(100)
);


CREATE TABLE student_enrollments (
    enrollment_id   SERIAL PRIMARY KEY,
    student_id      INTEGER NOT NULL,
    course_id       INTEGER NOT NULL,
    enrollment_date DATE DEFAULT CURRENT_DATE,
    grade           CHAR(2), 


    FOREIGN KEY (student_id) REFERENCES students(student_id) ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES courses(course_id)   ON DELETE CASCADE,


    UNIQUE (student_id, course_id)
);


INSERT INTO students (first_name, last_name, email) VALUES
    ('Alice', 'Johnson', 'alice@university.edu'),
    ('Bob',   'Smith',   'bob@university.edu'),
    ('Carol', 'Wilson',  'carol@university.edu');

INSERT INTO courses (course_code, course_name, credits, instructor) VALUES
    ('CS101',   'Introduction to Programming', 3, 'Dr. Brown'),
    ('CS201',   'Data Structures',             4, 'Dr. Davis'),
    ('MATH101', 'Calculus I',                  4, 'Dr. Wilson');


INSERT INTO student_enrollments (student_id, course_id, grade) VALUES
    (1, 1, 'A'),    -- Alice in CS101
    (1, 2, 'B+'),   -- Alice in CS201
    (2, 1, 'A-'),   -- Bob in CS101
    (2, 3, 'B'),    -- Bob in MATH101
    (3, 2, 'A'),    -- Carol in CS201
    (3, 3, 'A-');   -- Carol in MATH101


INSERT INTO student_enrollments (student_id, course_id, grade) VALUES (1, 1, 'C');

SELECT
    s.first_name || ' ' || s.last_name AS student_name,
    c.course_code,
    c.course_name,
    se.grade,
    se.enrollment_date
FROM students s
JOIN student_enrollments se ON s.student_id = se.student_id
JOIN courses c ON se.course_id = c.course_id
ORDER BY s.last_name, c.course_code;

SELECT s.first_name, s.last_name, se.grade
FROM students s
JOIN student_enrollments se ON s.student_id = se.student_id
JOIN courses c ON se.course_id = c.course_id
WHERE c.course_code = 'CS101';


SELECT c.course_code, c.course_name, c.credits, se.grade
FROM courses c
JOIN student_enrollments se ON c.course_id = se.course_id
JOIN students s ON se.student_id = s.student_id
WHERE s.email = 'alice@university.edu';