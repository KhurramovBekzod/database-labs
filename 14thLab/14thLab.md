***INNER, LEFT, RIGHT, FULL OUTER JOIN***

The four main join types on customers and orders. INNER keeps only matches, LEFT keeps every customer, RIGHT keeps every order, and FULL OUTER keeps both, with NULLs where there’s no match
<img width="1494" height="897" alt="image" src="https://github.com/user-attachments/assets/c7613b9f-9e21-4043-9336-0c280a69d81e" />

***CROSS JOIN, a four-table join, a self join, a join with WHERE conditions***

Advanced joins: a Cartesian product with CROSS JOIN, joining four tables, joining employees to their own table to find managers, and filtering joined rows
<img width="1591" height="955" alt="image" src="https://github.com/user-attachments/assets/5df1741e-26d9-452e-af0d-56551f38a2e7" />


***One-to-one, one-to-many, many-to-many***

Joins for each relationship type: users to profiles, authors to books, and students to courses through the enrollments junction table
<img width="1290" height="627" alt="image" src="https://github.com/user-attachments/assets/bde47f1e-d7f7-404d-b2d8-6f3bca89eb01" />

***Indexes, table aliases, pitfalls***

Indexes on the foreign key columns, table aliases, the Cartesian product you get without a join condition, and finding customers without orders with LEFT JOIN and IS NULL

<img width="1286" height="923" alt="image" src="https://github.com/user-attachments/assets/87b8f765-c822-4fe1-aad8-944c021ee376" />
