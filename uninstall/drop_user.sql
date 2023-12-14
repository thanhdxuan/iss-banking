BEGIN
    FOR t IN (SELECT username from USERS)
    LOOP
        EXECUTE IMMEDIATE 'DROP USER ' || t.username;
    END LOOP;
END;
/
