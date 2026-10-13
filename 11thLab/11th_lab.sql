\c postgres
DROP DATABASE IF EXISTS student_db WITH (FORCE);
CREATE DATABASE student_db;
\c student_db

CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name  VARCHAR(50),
    birth_date DATE
);

INSERT INTO Students (first_name, last_name, birth_date)
VALUES ('Aibek', 'Sharshenov', '2002-05-12');

INSERT INTO Students (first_name, last_name, birth_date) VALUES
    ('Ainura', 'Toktomamatova', '2001-09-23'),
    ('Bakyt',  'Mamatov',       '2003-01-15'),
    ('Gulzat', 'Sultanova',     '2002-07-30');

SELECT * FROM Students ORDER BY student_id;

UPDATE Students
SET birth_date = '2002-05-15'
WHERE first_name = 'Aibek' AND last_name = 'Sharshenov';

SELECT * FROM Students ORDER BY student_id;

DELETE FROM Students
WHERE first_name = 'Gulzat' AND last_name = 'Sultanova';

DELETE FROM Students
WHERE birth_date < '2002-01-01';

SELECT * FROM Students ORDER BY student_id;

\copy Students(first_name, last_name, birth_date) FROM 'C:/Database Lab/students.csv' DELIMITER ',' CSV HEADER

SELECT * FROM Students ORDER BY student_id;

INSERT INTO Students (first_name, last_name, birth_date)
VALUES ('Emir', 'Uulu', '2002-02-20');

UPDATE Students
SET last_name = 'Bekov'
WHERE last_name IN ('Uulu', 'Isakov');

SELECT * FROM Students ORDER BY student_id;

DELETE FROM Students
WHERE student_id IN (2, 3, 5);

SELECT * FROM Students ORDER BY student_id;

\copy Students TO 'C:/Database Lab/students_export.csv' DELIMITER ',' CSV HEADER