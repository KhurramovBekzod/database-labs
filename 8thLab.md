## Running the Lab 8 script in psql.
It creates foreign keys in four ways, shows the database rejecting rows that break referential integrity, demonstrates the ON DELETE and ON UPDATE options, 
and builds one-to-one, one-to-many and many-to-many relationships. The errors are intentional

<img width="1756" height="726" alt="image" src="https://github.com/user-attachments/assets/55d8f0f8-e9fb-4be2-b72d-f33a2a658531" />
<img width="1906" height="936" alt="image" src="https://github.com/user-attachments/assets/2bff3ae4-e5e7-4c34-b259-a043ab0047ff" />
<img width="1904" height="945" alt="image" src="https://github.com/user-attachments/assets/12713e16-ee54-4ca0-99b6-a49a7376f0e9" />
<img width="1732" height="660" alt="image" src="https://github.com/user-attachments/assets/3b4b942b-5129-4df7-8096-d751a69d2a2e" />

## Structure of the junction table
It has two foreign keys, one to **students** and one to **courses**, both with ON **DELETE CASCADE**, and a **UNIQUE** constraint on (student_id, course_id) 
that prevents duplicate enrollments.
<img width="1693" height="310" alt="image" src="https://github.com/user-attachments/assets/9de55279-e55c-492e-b0f8-268dc797aa52" />

