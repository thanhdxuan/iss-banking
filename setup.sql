create pluggable database bankpdb admin user bankadm identified by bankadm roles=(DBA) file_name_convert=('pdbseed', 'banksystem');

ALTER PLUGGABLE DATABASE bankpdb OPEN READ WRITE;

ALTER SESSION SET CONTAINER = BANKPDB;

CREATE USER bankcm IDENTIFIED BY bankcm;
CREATE USER bankcsr IDENTIFIED BY bankcsr;
CREATE USER bankca IDENTIFIED BY bankca;
CREATE USER customer IDENTIFIED BY customer;
DROP USER bankcm CASCADE;
DROP USER bankcsr CASCADE;
DROP USER bankca CASCADE;
DROP USER customer CASCADE;

GRANT CREATE SESSION TO BANKCM; 
GRANT CREATE SESSION TO BANKCSR; 
GRANT CREATE SESSION TO BANKCA; 
GRANT CREATE SESSION TO CUSTOMER; 

---
GRANT CREATE SESSION TO BANKADM;
GRANT CREATE TABLE TO BANKADM;
GRANT CREATE USER TO BANKADM;
GRANT CONNECT,RESOURCE,UNLIMITED TABLESPACE TO BANKADM;
CREATE TABLESPACE BANKING_DATA DATAFILE 'banking_data.dbf' SIZE 20m;

ALTER USER bankadm DEFAULT TABLESPACE BANKING_DATA;
ALTER USER bankadm TEMPORARY TABLESPACE TEMP;

grant execute on sys.dbms_crypto to BANKADM;

--- Connect to admin user
conn bankadm/bankadm@localhost:1521/bankpdb;

@@create.sql
@@insert_users.sql
@@insert_staffs.sql
@@insert_customers.sql
@@create_users.sql
@@create_role.sql
@@policies.sql
commit;

 --- Password profile

PROMPT Creating password profile ...
PROMPT Enter password of user 'sys'
conn sys as sysdba;

CREATE OR REPLACE FUNCTION bank_verify_strong_password_function
 ( username     varchar2,
   password     varchar2,
   old_password varchar2)
 return boolean IS
BEGIN
   if not ora_complexity_check(password, chars => 8, uppercase => 1, lowercase => 1, digit => 1, special => 1) then
      return(false);
   end if;
   return(true);
END;
/

CREATE MANDATORY PROFILE c##mandatory_app_password_profile LIMIT
   PASSWORD_GRACE_TIME        7
   PASSWORD_VERIFY_FUNCTION   bank_verify_strong_password_function;

ALTER SYSTEM SET MANDATORY_USER_PROFILE = c##mandatory_app_password_profile;
conn bankadm/bankadm@localhost:1521/bankpdb;

CREATE PROFILE bank_app_password_profile LIMIT
   FAILED_LOGIN_ATTEMPTS      5
   PASSWORD_LIFE_TIME         90 --- The password expires if it is not changed within the grace period (define in PASSWORD_GRACE_TIME), and further connections are rejected.
   PASSWORD_REUSE_TIME        3
   PASSWORD_REUSE_MAX         3
   PASSWORD_LOCK_TIME         365 --- The number of days an account will be locked after the specified number of consecutive failed login attempts.
   PASSWORD_GRACE_TIME        7
   INACTIVE_ACCOUNT_TIME      360
   PASSWORD_ROLLOVER_TIME     0;
