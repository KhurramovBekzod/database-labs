DROP TABLE IF EXISTS loans;
DROP TABLE IF EXISTS book_authors;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS books;
DROP TABLE IF EXISTS authors;
DROP TABLE IF EXISTS student_phones;
DROP TABLE IF EXISTS student_enrollments;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS enrollments_bad;
DROP TABLE IF EXISTS students_bad;
DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS courses;
DROP TABLE IF EXISTS professors;
DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS departments;

CREATE TABLE professors (
    professor_id SERIAL PRIMARY KEY,
    first_name   VARCHAR(50) NOT NULL,
    last_name    VARCHAR(50) NOT NULL,
    department   VARCHAR(100),
    email        VARCHAR(100) UNIQUE
);

CREATE TABLE courses (
    course_id    SERIAL PRIMARY KEY,
    course_name  VARCHAR(100) NOT NULL,
    credits      INTEGER,
    description  TEXT,
    professor_id INTEGER REFERENCES professors(professor_id)
);

CREATE TABLE students (
    student_id    SERIAL PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    email         VARCHAR(100) UNIQUE,
    date_of_birth DATE,
    faculty       VARCHAR(100)
);

CREATE TABLE enrollments (
    student_id INTEGER REFERENCES students(student_id),
    course_id  INTEGER REFERENCES courses(course_id),
    PRIMARY KEY (student_id, course_id)
);

INSERT INTO professors (first_name, last_name, department, email) VALUES
    ('Aibek', 'Brown', 'Computer Science', 'brown@university.edu'),
    ('Dina',  'Davis', 'Mathematics',      'davis@university.edu');

INSERT INTO courses (course_name, credits, description, professor_id) VALUES
    ('Databases',       6, 'Relational databases and SQL', 1),
    ('Data Structures', 6, 'Lists, trees and graphs',      1),
    ('Calculus I',      5, 'Limits and derivatives',       2);

INSERT INTO students (first_name, last_name, email, date_of_birth, faculty) VALUES
    ('Alice', 'Johnson', 'alice@university.edu', '2005-03-14', 'Software Engineering'),
    ('Bob',   'Smith',   'bob@university.edu',   '2004-11-02', 'Applied Mathematics');

INSERT INTO enrollments (student_id, course_id) VALUES
    (1, 1), (1, 2), (2, 1), (2, 3);

SELECT first_name, last_name, date_of_birth,
       EXTRACT(YEAR FROM AGE(date_of_birth)) AS age
FROM students;

SELECT s.first_name || ' ' || s.last_name AS student,
       c.course_name,
       p.first_name || ' ' || p.last_name AS professor
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c     ON e.course_id = c.course_id
JOIN professors p  ON c.professor_id = p.professor_id
ORDER BY student, c.course_name;

DROP TABLE enrollments;
DROP TABLE students;
DROP TABLE courses;
DROP TABLE professors;

CREATE TABLE students_bad (
    student_id    INT PRIMARY KEY,
    name          VARCHAR(100),
    phone_numbers TEXT
);
INSERT INTO students_bad VALUES
    (1, 'Alice Johnson', '123-456-7890, 098-765-4321'),
    (2, 'Bob Smith',     '555-111-2222');

SELECT * FROM students_bad;

CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name       VARCHAR(100)
);

CREATE TABLE student_phones (
    student_id   INT,
    phone_number VARCHAR(15),
    phone_type   VARCHAR(20),
    PRIMARY KEY (student_id, phone_number),
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students VALUES
    (1, 'Alice Johnson'),
    (2, 'Bob Smith');
INSERT INTO student_phones VALUES
    (1, '123-456-7890', 'mobile'),
    (1, '098-765-4321', 'home'),
    (2, '555-111-2222', 'mobile');

SELECT s.name, p.phone_number, p.phone_type
FROM students s
JOIN student_phones p ON s.student_id = p.student_id
ORDER BY s.name, p.phone_type;

CREATE TABLE enrollments_bad (
    student_id  INT,
    course_id   INT,
    course_name VARCHAR(100),
    grade       CHAR(2),
    PRIMARY KEY (student_id, course_id)
);
INSERT INTO enrollments_bad VALUES
    (1, 101, 'Databases',       'A'),
    (2, 101, 'Databases',       'B+'),
    (1, 102, 'Data Structures', 'A-');

SELECT * FROM enrollments_bad;

CREATE TABLE courses (
    course_id   INT PRIMARY KEY,
    course_name VARCHAR(100),
    credits     INT
);

CREATE TABLE enrollments (
    student_id INT,
    course_id  INT,
    grade      CHAR(2),
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id)  REFERENCES courses(course_id)
);

INSERT INTO courses VALUES
    (101, 'Databases',       6),
    (102, 'Data Structures', 6);
INSERT INTO enrollments VALUES
    (1, 101, 'A'),
    (2, 101, 'B+'),
    (1, 102, 'A-');

SELECT s.name, c.course_name, e.grade
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c  ON e.course_id = c.course_id
ORDER BY s.name, c.course_name;

DROP TABLE students_bad;

CREATE TABLE students_bad (
    student_id      INT PRIMARY KEY,
    name            VARCHAR(100),
    department_id   INT,
    department_name VARCHAR(100)
);
INSERT INTO students_bad VALUES
    (1, 'Alice Johnson', 10, 'Software Engineering'),
    (2, 'Bob Smith',     10, 'Software Engineering'),
    (3, 'Carol Wilson',  20, 'Applied Mathematics');

SELECT * FROM students_bad;

CREATE TABLE departments (
    department_id   INT PRIMARY KEY,
    department_name VARCHAR(100),
    department_head VARCHAR(100)
);

ALTER TABLE students ADD COLUMN department_id INT;
ALTER TABLE students
ADD FOREIGN KEY (department_id) REFERENCES departments(department_id);

INSERT INTO departments VALUES
    (10, 'Software Engineering', 'Dr. Brown'),
    (20, 'Applied Mathematics',  'Dr. Davis');
INSERT INTO students VALUES (3, 'Carol Wilson', 20);
UPDATE students SET department_id = 10 WHERE student_id IN (1, 2);

SELECT s.student_id, s.name, d.department_name, d.department_head
FROM students s
JOIN departments d ON s.department_id = d.department_id
ORDER BY s.student_id;

UPDATE departments SET department_name = 'Software Engineering and AI'
WHERE department_id = 10;

SELECT s.name, d.department_name
FROM students s
JOIN departments d ON s.department_id = d.department_id
ORDER BY s.student_id;

CREATE TABLE authors (
    author_id  SERIAL PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name  VARCHAR(50) NOT NULL,
    birth_date DATE
);

CREATE TABLE books (
    book_id          SERIAL PRIMARY KEY,
    title            VARCHAR(200) NOT NULL,
    isbn             VARCHAR(13) UNIQUE,
    publication_year INTEGER,
    available_copies INTEGER DEFAULT 1
);

CREATE TABLE book_authors (
    book_id   INTEGER,
    author_id INTEGER,
    PRIMARY KEY (book_id, author_id),
    FOREIGN KEY (book_id)   REFERENCES books(book_id),
    FOREIGN KEY (author_id) REFERENCES authors(author_id)
);

CREATE TABLE members (
    member_id       SERIAL PRIMARY KEY,
    first_name      VARCHAR(50) NOT NULL,
    last_name       VARCHAR(50) NOT NULL,
    email           VARCHAR(100) UNIQUE NOT NULL,
    phone           VARCHAR(15),
    membership_date DATE DEFAULT CURRENT_DATE
);

CREATE TABLE loans (
    loan_id     SERIAL PRIMARY KEY,
    member_id   INTEGER NOT NULL,
    book_id     INTEGER NOT NULL,
    loan_date   DATE DEFAULT CURRENT_DATE,
    due_date    DATE NOT NULL,
    return_date DATE,
    late_fee    DECIMAL(10,2) DEFAULT 0.00,
    FOREIGN KEY (member_id) REFERENCES members(member_id),
    FOREIGN KEY (book_id)   REFERENCES books(book_id)
);

INSERT INTO authors (first_name, last_name, birth_date) VALUES
    ('John',  'Miller', '1975-04-12'),
    ('Jane',  'Cooper', '1980-09-30'),
    ('Aziz',  'Karimov', NULL);

INSERT INTO books (title, isbn, publication_year, available_copies) VALUES
    ('Database Basics',     '9780000000011', 2019, 3),
    ('Mountains of Asia',   '9780000000028', 2015, 2);

INSERT INTO book_authors (book_id, author_id) VALUES
    (1, 1), (1, 2), (2, 3);

INSERT INTO members (first_name, last_name, email, phone) VALUES
    ('Alice', 'Johnson', 'alice@example.com', '555-111-2222'),
    ('Bob',   'Smith',   'bob@example.com',   '555-333-4444');

INSERT INTO loans (member_id, book_id, loan_date, due_date, return_date, late_fee) VALUES
    (1, 1, '2026-09-01', '2026-09-15', '2026-09-20', 25.00),
    (1, 2, '2026-09-10', '2026-09-24', '2026-09-22', 0.00);

INSERT INTO loans (member_id, book_id, loan_date, due_date) VALUES
    (2, 1, '2026-09-20', '2026-10-04');

SELECT b.title, a.first_name || ' ' || a.last_name AS author
FROM books b
JOIN book_authors ba ON b.book_id = ba.book_id
JOIN authors a       ON ba.author_id = a.author_id
ORDER BY b.title, a.last_name;

SELECT m.first_name || ' ' || m.last_name AS member,
       b.title, l.loan_date, l.due_date, l.return_date, l.late_fee
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b   ON l.book_id = b.book_id
ORDER BY l.loan_date;

SELECT m.first_name || ' ' || m.last_name AS member, b.title, l.due_date
FROM loans l
JOIN members m ON l.member_id = m.member_id
JOIN books b   ON l.book_id = b.book_id
WHERE l.return_date IS NULL;