-- Inserting customer 1
INSERT INTO CUSTOMERS (uuid, job, addr)
SELECT uuid, 'Software Engineer', '123 Main St'
FROM USERS
WHERE USERS.username = 'robert';

-- Inserting customer 2
INSERT INTO CUSTOMERS (uuid, job, addr)
SELECT uuid, 'Teacher', '456 Elm St'
FROM USERS
WHERE USERS.username = 'daniel';

-- Inserting customer 3
INSERT INTO CUSTOMERS (uuid, job, addr)
SELECT uuid, 'Doctor', '789 Oak St'
FROM USERS
WHERE USERS.username = 'olivia';

-- Inserting customer 4
INSERT INTO CUSTOMERS (uuid, job, addr)
SELECT uuid, 'Lawyer', '321 Pine St'
FROM USERS
WHERE USERS.username = 'sarah';