SELECT * FROM STAFFS;
SELECT * FROM APPLICATIONS;
SELECT * FROM ANALYZE;
UPDATE APPLICATIONS SET STATUS = 1;
SELECT SYS_CONTEXT('users_ctx','uuid') FROM DUAL;
INSERT INTO ANALYZE (a_id, s_id, ISREAD)
VALUES (3, 1, 'N');
GRANT CREDIT_ANALYST_ROLE TO BANKCA;
GRANT CREDIT_MANAGER_ROLE TO BANKCM;
GRANT CUSTOMER_SERVICE_REPRESENTATIVES_ROLE TO BANKCSR 