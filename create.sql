-- Active: 1701874576202@@localhost@1521@bankpdb@SYSTEM
CREATE TABLE USER (  
    id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
    create_time DATE,
    name VARCHAR2(255),
    email VARCHAR2(255),
    gender VARCHAR2(255),
    dob DATE,
    phone_num NUMBER,
    pwd VARCHAR2(255)
);


CREATE TABLE STAFF (  
   uid NUMBER,
   staff_id GENERATED AS IDENTITY PRIMARY KEY,
   job_postion VARCHAR2(255)
);

CREATE TABLE CUSTOMER (  
   uid NUMBER,
   c_id GENERATED AS IDENTITY PRIMARY KEY,
   job VARCHAR2(255),
   addr VARCHAR2(255)
);

CREATE TABLE APPLICATIONS (
   id NUMBER GENERATED AS IDENTITY PRIMARY KEY,
   acc_type NCHAR,
   _limit INTEGER,
   c_name VARCHAR2(255),
   c_income INTEGER,
   c_cccd NUMBER NOT NULL,
   c_phone_num NUMBER NOT NULL,
   c_addr VARCHAR2(255) NOT NULL,
   c_email VARCHAR2(255) NOT NULL,
   status NUMBER(1, 0),
   created_by NUMBER,
   isApproved NUMBER(1, 0),
   comment NVARCHAR2
);

CREATE TABLE BANK_ACCOUNT (
   acc_num NUMBER(9) PRIMARY KEY,
   typ VARCHAR2(255) NOT NULL,
   _limit INTEGER NOT NULL,
   c_id NUMBER,
   created_by NUMBER
   created_date DATE,
);

CREATE TABLE ANALYZE (
   a_id NUMBER --Application id
   s_id NUMBER --staff id
   analysis NVARCHAR2(255)
)

COMMENT ON TABLE table_name IS '';
COMMENT ON COLUMN table_name. IS ''