PROMPT Uninstalling bankpdb ...
PROMPT Enter password of user 'sys'
CONN SYS AS SYSDBA;
ALTER PLUGGABLE DATABASE BANKPDB CLOSE;
DROP PLUGGABLE DATABASE BANKPDB INCLUDING DATAFILES;
ALTER SYSTEM RESET MANDATORY_USER_PROFILE;

PROMPT Restarting database ...
SHUTDOWN IMMEDIATE;
STARTUP;