CONN SYS AS SYSDBA;
ALTER PLUGGABLE DATABASE BANKPDB CLOSE;
DROP PLUGGABLE DATABASE BANKPDB INCLUDING DATAFILES;