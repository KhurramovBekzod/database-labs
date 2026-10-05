
DROP TABLE IF EXISTS temp_top_students;
DROP TABLE IF EXISTS enrollments;
DROP TABLE IF EXISTS university_students;
DROP TABLE IF EXISTS students;

CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,           
    first_name VARCHAR(50)  NOT NULL,        
    last_name  VARCHAR(50)  NOT NULL,
    email      VARCHAR(100) UNIQUE NOT NULL, 
    faculty    VARCHAR(100)                 
);

INSERT INTO students (first_name, last_name, email, faculty) VALUES
    ('Alymbek', 'Asanov',   'alymbek@example.com', 'COMSEH'),
    ('Timur',   'Bekov',    'timur@example.com',   'MED'),
    ('Beka',    'Sadykov',  'beka@example.com',    'MAT');

SELECT * FROM students;


CREATE TABLE enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id    INTEGER NOT NULL REFERENCES students (student_id),
    course_name   TEXT    NOT NULL,
    grade         INTEGER CHECK (grade >= 0 AND grade <= 100),
    is_active     BOOLEAN DEFAULT TRUE,
    enrolled_on   DATE    DEFAULT CURRENT_DATE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO enrollments (student_id, course_name, grade) VALUES
    (1, 'Databases', 95),
    (2, 'Anatomy',   88);

SELECT enrollment_id, student_id, course_name, grade, is_active, enrolled_on
FROM enrollments;

CREATE TABLE test_table (id INTEGER);
DROP TABLE test_table;


DROP TABLE IF EXISTS test_table;
DROP TABLE IF EXISTS non_existing_table;



ALTER TABLE students
ADD COLUMN date_of_birth DATE;

ALTER TABLE students
DROP COLUMN faculty;

ALTER TABLE students
ALTER COLUMN first_name TYPE TEXT;

ALTER TABLE students
ADD CONSTRAINT unique_student_email UNIQUE (email);


ALTER TABLE students
RENAME COLUMN email TO email_address;

ALTER TABLE students
RENAME TO university_students;


SELECT * FROM university_students;


SELECT column_name, data_type, is_nullable
FROM information_schema.columns
WHERE table_name = 'university_students'
ORDER BY ordinal_position;



CREATE TEMP TABLE temp_top_students (
    student_id INTEGER,
    grade      INTEGER
);

INSERT INTO temp_top_students
SELECT student_id, grade FROM enrollments WHERE grade >= 90;

SELECT * FROM temp_top_students;