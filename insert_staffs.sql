-- Inserting staff member with job position "CA"
INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CA'
FROM USERS
WHERE USERS.uname = 'John Doe';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CA'
FROM USERS
WHERE USERS.uname = 'BANK CA';
-- Inserting staff member with job position "CM"
INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CM'
FROM USERS
WHERE USERS.uname = 'Michael Johnson';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CM'
FROM USERS
WHERE USERS.uname = 'BANK CM';
-- Inserting staff member with job position "CS"
INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.uname = 'Emma Wilson';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.uname = 'BANK CS';
