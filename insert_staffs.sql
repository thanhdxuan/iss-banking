-- Inserting staff member with job position "CA"
INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CA'
FROM USERS
WHERE USERS.username = 'johndoe';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CA'
FROM USERS
WHERE USERS.username = 'bankca';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CA'
FROM USERS
WHERE USERS.username = 'bankca01';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CA'
FROM USERS
WHERE USERS.username = 'bankca02';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CA'
FROM USERS
WHERE USERS.username = 'bankca03';

-- Inserting staff member with job position "CM"
INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CM'
FROM USERS
WHERE USERS.username = 'michael';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CM'
FROM USERS
WHERE USERS.username = 'bankcm';


-- Inserting staff member with job position "CS"
INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.username = 'emma';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.username = 'bankcs';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.username = 'bankcsr01';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.username = 'bankcsr02';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.username = 'bankcsr03';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.username = 'bankcsr04';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.username = 'bankcsr05';

INSERT INTO STAFFS (uuid, job_postion)
SELECT uuid, 'CS'
FROM USERS
WHERE USERS.username = 'bankcsr06';
