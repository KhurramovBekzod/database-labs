***COMMIT, ROLLBACK, a bank transfer***

BEGIN, COMMIT and ROLLBACK on account balances. A committed transfer is saved, and a rolled-back one is undone even though it was visible inside the transaction
<img width="1128" height="911" alt="image" src="https://github.com/user-attachments/assets/e2da63cf-00e7-4c66-bea9-f9ccf5605e52" />


***Atomicity, consistency, durability***

ACID: a failed transaction saves nothing (atomicity), a new customer and their order are added together (consistency), and committed data is still there after reconnecting (durability)
<img width="1348" height="781" alt="image" src="https://github.com/user-attachments/assets/12112e4f-4e6a-4f28-a5b7-07196589ce23" />


***The four isolation levels and SET TRANSACTION***

Starting transactions at each isolation level, checked with SHOW transaction_isolation, with 5% interest applied under SERIALIZABLE.
<img width="1250" height="895" alt="image" src="https://github.com/user-attachments/assets/3c85f5de-441d-4df3-ac64-f94c9622b88b" />
<img width="1202" height="667" alt="image" src="https://github.com/user-attachments/assets/de68a0ed-cd6e-4460-91c3-05f26cd5b551" />



***ROLLBACK TO SAVEPOINT, multiple savepoints, RELEASE***

Savepoints: undoing part of a transaction while keeping the rest, recovering from a failed insert, and releasing a savepoint
<img width="1280" height="832" alt="image" src="https://github.com/user-attachments/assets/edee32f8-c320-45ca-800e-4884d33405f8" />



***Best practices***

Best practices: short transactions, handling errors in a DO block, choosing isolation levels, savepoints for multi-step work, checking for locks
<img width="1193" height="775" alt="image" src="https://github.com/user-attachments/assets/c32774ac-0b1e-4cda-91e1-ba31892deea4" />
<img width="1249" height="789" alt="image" src="https://github.com/user-attachments/assets/84869070-9e31-4e60-9979-7fa975fa8f61" />

