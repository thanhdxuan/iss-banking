BEGIN
    FOR t IN (SELECT username from USERS)
    LOOP
        EXECUTE IMMEDIATE 'CREATE USER ' || t.username || ' IDENTIFIED BY "@Aa12345678"';                            
        EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO ' || t.username;
    END LOOP;
END;
/
CREATE OR REPLACE CONTEXT users_ctx USING users_ctx_pkg;

CREATE OR REPLACE PACKAGE users_ctx_pkg IS
    PROCEDURE set_uuid_ctx;
END;
/
CREATE OR REPLACE PACKAGE BODY users_ctx_pkg IS
PROCEDURE set_uuid_ctx AS
    uuid RAW(16);
    BEGIN
        SELECT uuid INTO uuid FROM USERS WHERE username = LOWER(SYS_CONTEXT('USERENV', 'SESSION_USER'));
        DBMS_SESSION.SET_CONTEXT('users_ctx', 'uuid', uuid);
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
    END set_uuid_ctx;
END;
/
CREATE TRIGGER set_uuid_ctx_trig AFTER LOGON ON DATABASE
    BEGIN
        BANKADM.users_ctx_pkg.set_uuid_ctx;
    END;
/
