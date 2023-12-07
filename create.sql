-- Active: 1701874576202@@localhost@1521@bankpdb@SYSTEM
CREATE TABLE USER (  
    uid           NUMBER         NOT NULL,
    create_time   DATE,
    uname         VARCHAR2(255), NOT NULL
    email         VARCHAR2(25),  NOT NULL
    gender        CHAR(1),
    dob           DATE,          NOT NULL
    phone_num     NUMBER,        NOT NULL
    cccd          NUMBER(12)     UNIQUE NOT NULL
    pwd           VARCHAR2(255)  NOT NULL
    CONSTRAINT user_pk
      PRIMARY KEY(uid)
);


CREATE TABLE STAFF (  
   uid            NUMBER,        NOT NULL
   staff_id       NUMBER(4)      NOT NULL
   job_postion    VARCHAR2(3)    NOT NULL -- CA, CM, CS
);

CREATE TABLE CUSTOMER (  
   uid            NUMBER,  NOT NULL
   c_id           NUMBER   NOT NULL
   job            VARCHAR2(50),
   addr           VARCHAR2(255)
);

CREATE TABLE APPLICATIONS (
   id             NUMBER         NOT NULL
   acc_type       CHAR(1),       NOT NULL --- Credit / Debit
   climit         NUMBER,        NOT NULL --- account limit 
   c_name         VARCHAR2(255), NOT NULL
   c_income       NUMBER,        NOT NULL
   c_cccd         NUMBER(12)     NOT NULL,
   c_phone_num    NUMBER         NOT NULL,
   c_addr         VARCHAR2(255)  NOT NULL,
   c_email        VARCHAR2(255)  NOT NULL,
   status         NUMBER(1, 0),  NOT NULL
   created_by     NUMBER,
   isApproved     CHAR(1),       --- Approved / Rejected / None
   cm_comment     CLOB
);

CREATE TABLE BANK_ACCOUNT (
   acc_num        NUMBER         NOT NULL,
   typ            CHAR(1)        NOT NULL,
   climit         NUMBER        NOT NULL,
   c_id           NUMBER,
   created_by     NUMBER
   created_date   DATE,
);

CREATE TABLE ANALYZE (
   a_id           NUMBER -- Application id
   s_id           NUMBER -- Staff id
   analysis       CLOB
)