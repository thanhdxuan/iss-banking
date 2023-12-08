-- Active: 1701874576202@@localhost@1521@bankpdb@SYSTEM
CREATE TABLE USERS (  
   uuid          RAW(16)         NOT NULL,
   create_time   DATE,
   uname         VARCHAR2(255)  NOT NULL,
   email         VARCHAR2(25)   NOT NULL,
   gender        CHAR(1),
   dob           DATE           NOT NULL,
   phone_num     NUMBER         NOT NULL,
   cccd          CHAR(12)       UNIQUE NOT NULL,
   pwd           VARCHAR2(255)  NOT NULL,
   CONSTRAINT user_pk PRIMARY KEY(uuid)
);

CREATE TABLE STAFFS (  
   uuid           RAW(16)        NOT NULL,
   staff_id       INTEGER        GENERATED BY DEFAULT ON NULL AS IDENTITY,
   job_postion    VARCHAR2(3)    NOT NULL, -- CA, CM, CS
   CONSTRAINT staff_users_fk FOREIGN KEY (uuid) REFERENCES USERS(uuid),
   CONSTRAINT staff_pk PRIMARY KEY (uuid),
   CONSTRAINT staff_id_unique UNIQUE (staff_id)
);

CREATE TABLE CUSTOMERS (  
   uuid           RAW(16)        NOT NULL,
   c_id           INTEGER        GENERATED BY DEFAULT ON NULL AS IDENTITY,
   job            VARCHAR2(50),
   addr           VARCHAR2(255),
   CONSTRAINT customer_users_fk FOREIGN KEY (uuid) REFERENCES USERS(uuid),
   CONSTRAINT customer_pk PRIMARY KEY (uuid), 
   CONSTRAINT customer_id_unique UNIQUE (c_id)
);

CREATE TABLE APPLICATIONS (
   id             INTEGER        GENERATED BY DEFAULT ON NULL AS IDENTITY,
   acc_type       CHAR(1)        NOT NULL, --- Credit / Debit
   climit         NUMBER         NOT NULL, --- account limit 
   c_name         VARCHAR2(255)  NOT NULL,
   c_income       NUMBER         NOT NULL,
   c_cccd         CHAR(12)       NOT NULL,
   c_phone_num    NUMBER         NOT NULL,
   c_addr         VARCHAR2(255)  NOT NULL,
   c_email        VARCHAR2(255)  NOT NULL,
   status         NUMBER(1, 0)   NOT NULL,
   created_by     RAW(16),
   isApproved     CHAR(1),       --- Approved / Rejected / None
   cm_comment     CLOB,
   CONSTRAINT applications_pk PRIMARY KEY (id),
   CONSTRAINT applications_users_fk FOREIGN KEY (created_by) REFERENCES USERS(uuid)
);

CREATE TABLE BANK_ACCOUNT (
   acc_num        INTEGER         NOT NULL,
   typ            CHAR(1)         NOT NULL,
   climit         NUMBER          NOT NULL,
   c_id           INTEGER,
   created_by     INTEGER,
   created_date   DATE,
   CONSTRAINT bankaccount_pk PRIMARY KEY (acc_num),
   CONSTRAINT bankaccount_customers_fk FOREIGN KEY (c_id) REFERENCES CUSTOMERS(c_id),
   CONSTRAINT bankaccount_staff_fk FOREIGN KEY (created_by) REFERENCES STAFFS(staff_id)
);

CREATE TABLE ANALYZE (
   a_id           INTEGER, -- Application id
   s_id           INTEGER, -- Staff id
   analysis       CLOB NOT NULL,
   CONSTRAINT analyze_pk PRIMARY KEY (a_id, s_id),
   CONSTRAINT analyze_application_fk FOREIGN KEY (a_id) REFERENCES APPLICATIONS(id),
   CONSTRAINT analyze_staff_fk FOREIGN KEY (s_id) REFERENCES STAFFS(staff_id)
);


create or replace function random_uuid return RAW is
  v_uuid RAW(16);
begin
  v_uuid := sys.dbms_crypto.randombytes(16);
  return (utl_raw.overlay(utl_raw.bit_or(utl_raw.bit_and(utl_raw.substr(v_uuid, 7, 1), '0F'), '40'), v_uuid, 7));
end random_uuid;
/

CREATE OR REPLACE FUNCTION app_user_password_profile
 ( username     varchar2,
   password     varchar2,
   old_password varchar2)
 return boolean IS
BEGIN
   -- mandatory verify function will always be evaluated regardless of the
   -- password verify function that is associated to a particular profile/user
   -- requires the minimum password length to be 8 characters
   if not ora_complexity_check(password, chars => 8) then
      return(false);
   end if;
   return(true);
END;
/