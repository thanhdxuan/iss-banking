--- VPD user chỉ có thể xem thông tin của mình
--- DROP_POLICY user_policy_function
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'USERS',
--         policy_name => 'user_policy'
--     );
-- END;
-- /
CREATE OR REPLACE FUNCTION user_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
BEGIN
    if SYS_CONTEXT('USERENV', 'SESSION_USER') = 'BANKADM' THEN
        v_policy := '1 = 1';
    ELSE 
        v_policy := 'username = LOWER(SYS_CONTEXT(''USERENV'', ''SESSION_USER''))';
    END IF;
    RETURN v_policy;
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'USERS',
        policy_name => 'user_policy',
        function_schema => 'BANKADM',
        policy_function => 'user_policy_function',
        statement_types => 'SELECT, UPDATE'
    );
END;

/
--- TRIGGER cho applications INSERT
CREATE OR REPLACE TRIGGER applications_insert_trigger
BEFORE INSERT ON APPLICATIONS
FOR EACH ROW
BEGIN
    :NEW.created_by := SYS_CONTEXT('users_ctx', 'uuid');
    :NEW.status := 0;
    :NEW.isApproved := 'N';
    :NEW.cm_comment := NULL;
END;
/
-------------------------------------------------------------
--- VPD cho applications
BEGIN
    DBMS_RLS.DROP_POLICY(
        policy_name => 'applications_policy',
        object_schema => 'BANKADM',
        object_name => 'APPLICATIONS'
    );
END;
/
--- GRANT EXECUTE ON applications_policy_function TO DANIEL;
--- GRANT EXECUTE ON applications_policy_function TO BANKCM;
CREATE OR REPLACE FUNCTION applications_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
    user_id RAW(16);
    job_position VARCHAR2(3);
    staff_id INTEGER;
    -- excep EXCEPTION;
    -- PRAGMA EXCEPTION_INIT(excep, -942);
BEGIN
    user_id := SYS_CONTEXT('users_ctx', 'uuid');
    IF SYS_CONTEXT('USERENV', 'SESSION_USER') = 'BANKADM' THEN
        v_policy := '1 = 1';
        RETURN v_policy;
    END IF;
    EXECUTE IMMEDIATE 'SELECT job_postion, STAFF_ID FROM STAFFS WHERE uuid = :1' INTO job_position, staff_id USING user_id;
    -- SELECT job_postion, STAFF_ID INTO job_position, staff_id FROM STAFFS WHERE uuid = user_id;
    IF job_position = 'CA' THEN
        v_policy := 'id IN (SELECT a_id FROM ANALYZE WHERE s_id = ' || staff_id || ')';
    ELSIF job_position = 'CM' THEN
        v_policy := '1 = 1';
    ELSIF job_position = 'CS' THEN
        v_policy := '1 = 1';
    END IF;
    RETURN v_policy;
EXCEPTION
    WHEN OTHERS THEN
        v_policy := 'created_by = ''' || user_id || '''';
        RETURN v_policy;
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'APPLICATIONS',
        policy_name => 'applications_policy',
        function_schema => 'BANKADM',
        policy_function => 'applications_policy_function',
        statement_types => 'SELECT, UPDATE, DELETE'
    );
END;
/
--- Redaction policy CSR bị ẩn đi các thông tin c_income của khách hàng
BEGIN
    DBMS_REDACT.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'APPLICATIONS',
        policy_name => 'redact_c_income',
        column_name => 'c_income',
        function_type => DBMS_REDACT.FULL,
        expression => 'SYS_CONTEXT(''SYS_SESSION_ROLES'', ''CUSTOMER_SERVICE_REPRESENTATIVES_ROLE'') = ''TRUE'''
    );
END;
/
-------------------------------------------------------------------
--- Analyze policy khi chưa được phê duyệt
--- DROP analyze_select_policy_function
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'ANALYZE',
--         policy_name => 'analyze_select_policy'
--     );
-- END;
-- /
-- --- GRANT EXECUTE ON analyze_select_policy_function TO BANKCA;
-- --- GRANT EXECUTE ON analyze_select_policy_function TO BANKCM;
CREATE OR REPLACE FUNCTION analyze_select_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
    uname VARCHAR2(100);
BEGIN
    IF SYS_CONTEXT('USERENV','SESSION_USER')= 'BANKADM' THEN
        v_policy := '1 = 1';
    ELSE
        v_policy := 'SYS_CONTEXT(''SYS_SESSION_ROLES'',''CREDIT_MANAGER_ROLE'') = ''TRUE'''||
        ' OR s_id IN (SELECT staff_id FROM STAFFS WHERE uuid = SYS_CONTEXT(''users_ctx'', ''uuid''))';
    END IF;

    RETURN v_policy;
END;
/
-- DECLARE
--     v_policy VARCHAR2(1000);
-- BEGIN
--     IF SYS_CONTEXT('USERENV','SESSION_USER') = 'BANKADM' THEN
--         v_policy := '1 = 1';
--     ELSIF SYS_CONTEXT('SYS_SESSION_ROLES','CREDIT_MANAGER_ROLE') = 'TRUE' THEN
--         v_policy := '1 = 1';
--     ELSE
--         v_policy := 's_id IN (SELECT staff_id FROM STAFFS WHERE uuid = SYS_CONTEXT(''users_ctx'', ''uuid''))';
--     END IF;
--     DBMS_OUTPUT.PUT_LINE(v_policy);
-- END;
-- /
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'ANALYZE',
        policy_name => 'analyze_select_policy',
        function_schema => 'BANKADM',
        policy_function => 'analyze_select_policy_function',
        statement_types => 'SELECT'
    );
END;
/


-------------------------------------------------------------

--- Analyze policy khi last_updated is NULL thì xóa ANALYZE 
--- DROP analyze_delete_policy_function
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'ANALYZE',
--         policy_name => 'analyze_delete_policy'
--     );
-- END;
-- /
CREATE OR REPLACE FUNCTION analyze_delete_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
BEGIN
    IF SYS_CONTEXT('USERENV','SESSION_USER')= 'BANKADM' THEN
        v_policy := '1 = 1';
    ELSE
        v_policy := 'last_updated is NULL';
    END IF;
    -- v_policy := '1 = 1';
    RETURN v_policy;
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'ANALYZE',
        policy_name => 'analyze_delete_policy',
        function_schema => 'BANKADM',
        policy_function => 'analyze_delete_policy_function',
        statement_types => 'DELETE'
    );
END;
/
CREATE OR REPLACE TRIGGER analyze_update_trigger
BEFORE UPDATE ON ANALYZE
FOR EACH ROW
BEGIN
    :NEW.last_updated := SYSTIMESTAMP;
END;
/
-------------------------------------------------------------

--- Analyze update khi chưa được phê duyệt
--- DROP analyze_update_policy_function
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'ANALYZE',
--         policy_name => 'analyze_update_policy'
--     );
-- END;
-- /
CREATE OR REPLACE FUNCTION analyze_update_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
BEGIN
    if SYS_CONTEXT('USERENV', 'SESSION_USER') = 'BANKADM' THEN
        v_policy := '1 = 1';
    ELSE
        v_policy := 'isRead = ''N'' AND s_id IN (SELECT staff_id FROM STAFFS WHERE uuid = SYS_CONTEXT(''users_ctx'', ''uuid''))';
    END IF;
    RETURN v_policy;
END;

/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'ANALYZE',
        policy_name => 'analyze_update_policy',
        function_schema => 'BANKADM',
        policy_function => 'analyze_update_policy_function',
        statement_types => 'UPDATE'
    );
END;
/

CREATE AUDIT POLICY applications_audit_policy
    ACTIONS DELETE on APPLICATIONS,
            INSERT on APPLICATIONS,
            UPDATE on APPLICATIONS,
            ALL on ANALYZE;