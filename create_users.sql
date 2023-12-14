BEGIN
    FOR t IN (SELECT username from USERS)
    LOOP
        EXECUTE IMMEDIATE 'CREATE USER ' || t.username || ' IDENTIFIED BY "@Aa12345678"';                            
        EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO ' || t.username;
    END LOOP;
END;
/
DROP TRIGGER create_user_trig;
CREATE OR REPLACE TRIGGER create_user_trig 
AFTER INSERT ON USERS
FOR EACH ROW
DECLARE
    v_username VARCHAR2(30);
BEGIN
    v_username := :NEW.username;
    EXECUTE IMMEDIATE 'CREATE USER ' || v_username || ' IDENTIFIED BY "@Aa12345678"';
    -- EXECUTE IMMEDIATE 'GRANT CREATE SESSION TO ' || v_username;
    -- DBMS_OUTPUT.PUT_LINE('CREATE USER ' || v_username || ' IDENTIFIED BY "@Aa12345678"');
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
