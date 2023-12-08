create pluggable database bankpdb admin user bankadm identified by bankadm roles=(DBA) file_name_convert=('pdbseed', 'banksystem');

ALTER PLUGGABLE DATABASE bankpdb OPEN READ WRITE;

ALTER SESSION SET CONTAINER = BANKPDB;

CREATE USER bankcm IDENTIFIED BY bankcm;
CREATE USER bankcsr IDENTIFIED BY bankcsr;
CREATE USER bankca IDENTIFIED BY bankca;
CREATE USER customer IDENTIFIED BY customer;

GRANT CREATE SESSION TO BANKCM; 
GRANT CREATE SESSION TO BANKCSR; 
GRANT CREATE SESSION TO BANKCA; 
GRANT CREATE SESSION TO CUSTOMER; 

---
GRANT CREATE SESSION TO BANKADM;
GRANT CREATE TABLE TO BANKADM;

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

commit;