# Database Labs

Lab work for my Database course, written in SQL and run on **PostgreSQL 18**.

## Tools

- **PostgreSQL 18**: the database server
- **SQL Shell (psql)**: running the lab scripts
- **pgAdmin 4**: viewing tables and ER diagrams
- **Git and GitHub**: version control and submission

## Repository Contents

This repository contains my lab files and screenshots documenting my work for the course.

| Lab | Topic |
|:---:|:---|
| Lab 3 | Basic `psql` Commands |
| Lab 4 | First SQL Query |
| Lab 5 | Databases Overview |
| Lab 6 | Tables, Data Types and Constraints |
| Lab 7 | Primary Keys |
| Lab 8 | Foreign Keys and Relationships |
| Lab 9 | Database Design Basics |
| Lab 10 | Viewing Database and Table Structure |
| Lab 11 | Basic Data Operations |
| Lab 12 | Querying Data |
| Lab 13 | Aggregate Functions |
| Lab 14 | Joining Tables |
| Lab 15 | Advanced Querying |
| Lab 16 | Transactions and ACID Properties |
| Lab 17 | Data Import, Export and Backup |

Labs 1 and 2 (Introduction to Relational Databases, and Installing PostgreSQL and pgAdmin) covered theory and setup, so they have no files here.

## How to Run a Lab

1. Open **SQL Shell (psql)** and connect to the server.
2. Run the lab script:

   ```
   \i 'C:/Database Lab/12th_lab.sql'
   ```

Most scripts from Lab 10 onward create their own database first, so they can be run again at any time without affecting the other labs.
