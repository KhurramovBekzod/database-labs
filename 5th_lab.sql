CREATE DATABASE university;
CREATE DATABASE student_records;

\l

\c university

SELECT current_database();


\c student_records
SELECT current_database();


\c postgres

DROP DATABASE university;
DROP DATABASE student_records;


\l