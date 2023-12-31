--- Role của khách hàng:
CREATE ROLE CUSTOMER_ROLE;
GRANT SELECT ON APPLICATIONS TO CUSTOMER_ROLE;
GRANT INSERT ON APPLICATIONS TO CUSTOMER_ROLE;
GRANT SELECT ON BANK_ACCOUNT TO CUSTOMER_ROLE;
GRANT SELECT ON USERS TO CUSTOMER_ROLE;
GRANT UPDATE (email, phone_num) ON USERS TO CUSTOMER_ROLE;


--- Role của nhà phân tích tín dụng
CREATE ROLE CREDIT_ANALYST_ROLE;
GRANT SELECT ON APPLICATIONS TO CREDIT_ANALYST_ROLE;
GRANT SELECT ON BANK_ACCOUNT TO CREDIT_ANALYST_ROLE;
GRANT SELECT ON USERS TO CREDIT_ANALYST_ROLE;
GRANT SELECT ON STAFFS TO CREDIT_ANALYST_ROLE;
GRANT SELECT ON ANALYZE TO CREDIT_ANALYST_ROLE;
GRANT UPDATE (analysis) ON ANALYZE TO CREDIT_ANALYST_ROLE;

--- Role của nhà quản lý tín dụng
CREATE ROLE CREDIT_MANAGER_ROLE;
GRANT SELECT ON APPLICATIONS TO CREDIT_MANAGER_ROLE;
GRANT SELECT ON CUSTOMERS TO CREDIT_MANAGER_ROLE;
GRANT SELECT ON USERS TO CREDIT_MANAGER_ROLE;
GRANT SELECT ON STAFFS TO CREDIT_MANAGER_ROLE;
GRANT SELECT ON ANALYZE TO CREDIT_MANAGER_ROLE;
GRANT INSERT ON ANALYZE TO CREDIT_MANAGER_ROLE;
GRANT UPDATE (isRead) ON ANALYZE TO CREDIT_MANAGER_ROLE;
GRANT DELETE ON ANALYZE TO CREDIT_MANAGER_ROLE;
GRANT DELETE ON APPLICATIONS TO CREDIT_MANAGER_ROLE;
GRANT UPDATE (status) ON APPLICATIONS TO CREDIT_MANAGER_ROLE;
GRANT UPDATE (isApproved, cm_comment) ON APPLICATIONS TO CREDIT_MANAGER_ROLE;


--- Role của người đại diện dịch vụ khách hàng
CREATE ROLE CUSTOMER_SERVICE_REPRESENTATIVES_ROLE;
GRANT SELECT ON APPLICATIONS TO CUSTOMER_SERVICE_REPRESENTATIVES_ROLE;
GRANT UPDATE (c_name, c_cccd, c_phone_num, c_addr, c_email) 
ON APPLICATIONS TO CUSTOMER_SERVICE_REPRESENTATIVES_ROLE;

BEGIN
    FOR i IN (SELECT USERNAME FROM STAFFS s, USERS u WHERE S.JOB_POSTION = 'CM' AND S.UUID = u.UUID) LOOP
        EXECUTE IMMEDIATE 'GRANT CREDIT_MANAGER_ROLE TO ' || I.USERNAME;
    END LOOP;
END;
/
BEGIN
    FOR i IN (SELECT USERNAME FROM STAFFS s, USERS u WHERE S.JOB_POSTION = 'CA' AND S.UUID = u.UUID) LOOP
        EXECUTE IMMEDIATE 'GRANT CREDIT_ANALYST_ROLE TO ' || i.username;
        DBMS_OUTPUT.PUT_LINE('GRANT CREDIT_ANALYST_ROLE TO ' || i.username);    
    END LOOP;
END;
/
BEGIN
    FOR i IN (SELECT U.USERNAME FROM CUSTOMERS c, USERS u WHERE c.uuid = u.uuid) LOOP
        EXECUTE IMMEDIATE 'GRANT CUSTOMER_ROLE TO ' || i.username;
    END LOOP;
END;
/
BEGIN
    FOR i IN (SELECT USERNAME FROM STAFFS s, USERS u WHERE S.JOB_POSTION = 'CS' AND S.UUID = u.UUID) 
    LOOP
        EXECUTE IMMEDIATE 'GRANT CUSTOMER_SERVICE_REPRESENTATIVES_ROLE TO ' || i.username;
    END LOOP;
END;
/

-- --- TRIGGER GRANT INSERT CUSTOMERS OR STAFFS
-- CREATE OR REPLACE TRIGGER GRANT_ROLE_CUSTOMER
-- AFTER INSERT ON CUSTOMERS
-- FOR EACH ROW
-- DECLARE
--     username VARCHAR2(30);
-- BEGIN
--     SELECT USERNAME INTO username FROM USERS WHERE UUID = :NEW.UUID;
--     EXECUTE IMMEDIATE 'GRANT CUSTOMER_ROLE TO ' || username;
-- END;
-- /
-- DROP TRIGGER GRANT_ROLE_CUSTOMER;

-- CREATE OR REPLACE TRIGGER GRANT_ROLE_STAFF
-- AFTER INSERT ON STAFFS
-- FOR EACH ROW
-- DECLARE
--     username VARCHAR2(30);
-- BEGIN
--     SELECT USERNAME INTO username FROM USERS WHERE UUID = :NEW.UUID;
--     IF :NEW.JOB_POSTION = 'CM' THEN
--         EXECUTE IMMEDIATE 'GRANT CREDIT_MANAGER_ROLE TO ' || username;
--     ELSIF :NEW.JOB_POSTION = 'CA' THEN
--         EXECUTE IMMEDIATE 'GRANT CREDIT_ANALYST_ROLE TO ' || username;
--     ELSIF :NEW.JOB_POSTION = 'CS' THEN
--         EXECUTE IMMEDIATE 'GRANT CUSTOMER_SERVICE_REPRESENTATIVES_ROLE TO ' || username;
--     END IF;
-- END;
-- /
-- DROP TRIGGER GRANT_ROLE_STAFF;
