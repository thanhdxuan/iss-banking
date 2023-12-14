
--- CUSTOMERS
INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'Robert Davis','robert', 'robert@example.com', 'M', TO_DATE('1984-09-10', 'YYYY-MM-DD'), 7897897897, '555555555555');

INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'Daniel Lee','daniel', 'daniel@example.com', 'M', TO_DATE('1998-11-15', 'YYYY-MM-DD'), 2222222222, '777777777777');

INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'Olivia Adams','olivia', 'olivia@example.com', 'F', TO_DATE('1990-02-14', 'YYYY-MM-DD'), 3333333333, '888888888888');

INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'Sarah Thompson','sarah', 'sarah@example.com', 'F', TO_DATE('1991-03-02', 'YYYY-MM-DD'), 4564564564, '444444444444');

--- CA
INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'John Doe', 'johndoe','johndoe@example.com', 'M', TO_DATE('1990-05-15', 'YYYY-MM-DD'), 1234567890, '123456789012');

INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'BANK CA','bankca', 'bankca@example.com', 'F', TO_DATE('1990-02-14', 'YYYY-MM-DD'), 4444444444, '999999999999');

--- CM
INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'Michael Johnson','michael', 'michael@example.com', 'M', TO_DATE('1988-03-10', 'YYYY-MM-DD'), 5555555555, '111111111111');

INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'BANK CM','bankcm', 'bankcm@example.com', 'F', TO_DATE('1990-02-14', 'YYYY-MM-DD'), 0000000000, '000000000000');


--- CS
INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'BANK CSR','bankcsr', 'bankcsr@example.com','M', TO_DATE('1990-02-14', 'YYYY-MM-DD'), 0000000567, '000000000765');

INSERT INTO USERS (uuid, create_time, uname, username, email, gender, dob, phone_num, cccd)
VALUES (random_uuid(), SYSDATE, 'Emma Wilson','emma', 'emma@example.com', 'F', TO_DATE('1993-06-25', 'YYYY-MM-DD'), 1111111111, '666666666666');

