-- Inserting staff member with job position "CA"
INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CA'
FROM USERS
WHERE USERS.uname = 'John Doe';

-- Inserting staff member with job position "CM"
INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CM'
FROM USERS
WHERE USERS.uname = 'Michael Johnson';

-- Inserting staff member with job position "CS"
INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.uname = 'Emma Wilson';