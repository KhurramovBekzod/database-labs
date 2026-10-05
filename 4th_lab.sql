DROP TABLE IF EXISTS students;
 
CREATE TABLE students (
    student_id SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL,
    email      VARCHAR(100),
    faculty    VARCHAR(50)
);
 
INSERT INTO students (name, email, faculty) VALUES
    ('Alymbek', 'alymbek@example.com', 'COMSEH'),
    ('Timur',   'timur@example.com',   'MED'),
    ('Beka',    'beka@example.com',    'MAT');
 
  
SELECT name, email FROM students;
  
SELECT * FROM students;

  
SELECT student_id, faculty FROM students;
  
SELECT name, email FROM students WHERE name = 'Timur';
  
SELECT name, faculty FROM students WHERE faculty = 'COMSEH';
 
  
SELECT name, email FROM students ORDER BY name;
  
SELECT name, email FROM students ORDER BY name DESC;
 
  
SELECT name, email FROM students LIMIT 2;
  
SELECT name, email FROM students ORDER BY student_id LIMIT 2;
 
  
SELECT name, faculty FROM students WHERE faculty = 'MED';

  
  
SELECT name, email FROM students LIMIT 2;
  
SELECT name, email FROM students ORDER BY student_id LIMIT 2;
 
  
SELECT name, faculty FROM students WHERE faculty = 'MED'; 