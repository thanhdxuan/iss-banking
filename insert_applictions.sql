conn DANIEL/"@Aa12345678"@localhost:1521/bankpdb;

INSERT INTO BANKADM.APPLICATIONS 
(acc_type ,climit , c_name , c_income , c_cccd , c_phone_num , c_addr , c_email)
VALUES
('C', 10000000, 'Daniel', 10000000, '777777777777', 123456789, 'HCM', 'daniel@example.com');

conn ROBERT/"@Aa12345678"@localhost:1521/bankpdb;

INSERT INTO BANKADM.APPLICATIONS
(acc_type ,climit , c_name , c_income , c_cccd , c_phone_num , c_addr , c_email)
VALUES
('D', 10000000, 'BANK_CM', 10000000, '888888888888', 123456788, 'HCM', 'bankcm@example.com');
-- CREATE TABLE APPLICATIONS (
--    id             INTEGER        GENERATED BY DEFAULT ON NULL AS IDENTITY,
--    acc_type       CHAR(1)        NOT NULL, --- Credit / Debit
--    climit         NUMBER         NOT NULL, --- account limit 
--    c_name         VARCHAR2(255)  NOT NULL,
--    c_income       NUMBER         NOT NULL,
--    c_cccd         CHAR(12)       NOT NULL,
--    c_phone_num    NUMBER         NOT NULL,
--    c_addr         VARCHAR2(255)  NOT NULL,
--    c_email        VARCHAR2(255)  NOT NULL,
--    status         NUMBER(1, 0)   NOT NULL,
--    created_by     RAW(16),
--    isApproved     CHAR(1),       --- Approved / Rejected / None
--    cm_comment     CLOB,
--    CONSTRAINT applications_pk PRIMARY KEY (id),
--    CONSTRAINT applications_users_fk FOREIGN KEY (created_by) REFERENCES USERS(uuid)
-- );