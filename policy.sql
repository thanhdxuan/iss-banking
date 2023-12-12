--- Các chính sách bảo mật trong hoạt động tín dụng của ngân hàng
--- Chính sách được áp dụng trên các thành phần gồm:
--- Khách hàng (customer)
--- Nhân viên ngân hàng (bank staff)
--- Nhà phân tích tín dụng (credit analyst)
--- Nhà quản lý tín dụng (credit manager)
--- Người đại diện dịch vụ khách hàng (customer service representatives)

--- Chính sách bảo mật bao gồm có:
--- Đối với khách hàng: Khách hàng có thể xem thông tin hợp đồng(applications) của mình
--- Khách hàng chỉ được phép xem thông tin của mình và hợp đồng.

--- Ngoài ra khách hàng có thể thay đổi thông tin cá nhân bao gồm email, số điện thoại, địa chỉ

--- Đối với nhân viên ngân hàng: Nhân viên ngân hàng có thể xem thông tin hợp đồng(applications) 
--- của khách hàng mà mình phụ trách
--- Đối nhà phân tích tín dụng: có thể xem thông tin hợp đồng của khách hàng mà họ đang phân tích (khi hết đã có kết quả sẽ không còn xem được).
--- CA có thể viết tạo bản phân tích cho hợp đồng của khách hàng.
--- Đối với nhà quản lý tín dụng: Nhà quản lý tín dụng có thể xem thông tin hợp đồng (applications) của tất cả khách hàng.
--- CM có thể thay đổi trạng thái hợp đồng(applications) của khách hàng từ chờ duyệt sang đã duyệt hoặc từ chờ duyệt sang từ chối.

--- Đối với người đại diện dịch vụ khách hàng....

--- Các update được thực hiện luôn được audit bởi hệ thống.
--- Giám sát insert và update trên các bảng: applications, bank_account, customers, users, analyze


--- Role của khách hàng:
CREATE ROLE CUSTOMER_ROLE;
GRANT SELECT ON APPLICATIONS TO CUSTOMER_ROLE;
GRANT INSERT ON APPLICATIONS TO CUSTOMER_ROLE;
GRANT SELECT ON BANK_ACCOUNT TO CUSTOMER_ROLE;
GRANT SELECT ON CUSTOMERS TO CUSTOMER_ROLE;
GRANT SELECT ON USERS TO CUSTOMER_ROLE;
GRANT UPDATE (email, phone_num, addr) ON USERS TO CUSTOMER_ROLE;
GRANT CREATE SESSION TO CUSTOMER_ROLE;

BEGIN
FOR i IN (SELECT c.uuid,pwd FROM CUSTOMERS c, USERS u WHERE c.uuid = u.uuid) LOOP
    EXECUTE IMMEDIATE 'GRANT CUSTOMER_ROLE TO ' || i.uuid;
END LOOP;
END;

--- VPD user chỉ có thể xem thông tin của mình
CREATE OR REPLACE FUNCTION user_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
BEGIN
    v_policy := 'uuid = SYS_CONTEXT(''USERENV'', ''SESSION_USER'')';
    RETURN v_policy;
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'USERS',
        policy_name => 'CUSTOMER_POLICY',
        function_schema => 'BANKADM',
        policy_function => 'user_policy_function',
        statement_types => 'SELECT, UPDATE'
    );
END;
--- Role của nhân viên ngân hàng
-- CREATE ROLE BANK_STAFF_ROLE;
-- GRANT SELECT ON APPLICATIONS TO BANK_STAFF_ROLE;
-- GRANT SELECT ON BANK_ACCOUNT TO BANK_STAFF_ROLE;
-- GRANT SELECT ON CUSTOMERS TO BANK_STAFF_ROLE;
-- GRANT SELECT ON USERS TO BANK_STAFF_ROLE;
-- GRANT CREATE SESSION TO BANK_STAFF_ROLE;
-- GRANT BANK_STAFF_ROLE TO BANKCM;
--- Role của nhà phân tích tín dụng
CREATE ROLE CREDIT_ANALYST_ROLE;
GRANT SELECT ON APPLICATIONS TO CREDIT_ANALYST_ROLE;
GRANT DELETE ON APPLICATIONS TO CREDIT_ANALYST_ROLE;
GRANT SELECT ON BANK_ACCOUNT TO CREDIT_ANALYST_ROLE;
GRANT SELECT ON USERS TO CREDIT_ANALYST_ROLE;
GRANT SELECT ON ANALYZE TO CREDIT_ANALYST_ROLE;
GRANT UPDATE (analysis) ON ANALYZE TO CREDIT_ANALYST_ROLE;
GRANT CREATE SESSION TO CREDIT_ANALYST_ROLE;

BEGIN
FOR i IN (SELECT uuid FROM STAFFS WHERE job_postion = 'CA') LOOP
    EXECUTE IMMEDIATE 'GRANT CREDIT_ANALYST_ROLE TO ' || i.uuid;
END LOOP;
END;

--- VPD cho application
CREATE OR REPLACE FUNCTION applications_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
    user VARCHAR2(100);
    job_position VARCHAR2(3);
BEGIN
    user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    SELECT job_postion INTO job_position FROM STAFFS WHERE uuid = user;
    IF job_position = 'CA' THEN
        v_policy := 'status = 1 AND id IN (SELECT a_id FROM ANALYZE WHERE s_id = ' || user || ')';
    ELSIF job_position = 'CM' THEN
        v_policy := '1 = 1';
    ELSIF job_position = 'CS' THEN
        v_policy := 'status = 0 OR isApproved = ''Approved''';
    END IF;
    RETURN v_policy;
EXCEPTION --- Không là nhân viên ngân hàng tức là khách hàng
    WHEN NO_DATA_FOUND THEN
        RETURN 'created_by = ' || user;
END;
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'APPLICATIONS',
        policy_name => 'applications_policy_function',
        function_schema => 'BANKADM',
        policy_function => 'applications_policy_function',
        statement_types => 'SELECT, UPDATE, DELETE'
    );
END;

--- VPD cho ANALYZE
CREATE OR REPLACE FUNCTION analyze_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
BEGIN
    v_policy := 's_id = SYS_CONTEXT(''USERENV'', ''SESSION_USER'')';
    RETURN v_policy;
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'ANALYZE',
        policy_name => 'analyze_policy_function',
        function_schema => 'BANKADM',
        policy_function => 'analyze_policy_function',
        statement_types => 'SELECT, UPDATE, DELETE'
    );
END;

--- Role của nhà quản lý tín dụng
CREATE ROLE CREDIT_MANAGER_ROLE;
GRANT SELECT ON APPLICATIONS TO CREDIT_MANAGER_ROLE;
GRANT SELECT ON CUSTOMERS TO CREDIT_MANAGER_ROLE;
GRANT SELECT ON USERS TO CREDIT_MANAGER_ROLE;
GRANT SELECT ON ANALYZE TO CREDIT_MANAGER_ROLE;
GRANT UPDATE (status) ON APPLICATIONS TO CREDIT_MANAGER_ROLE;
GRANT UPDATE (isApproved, cm_comment) ON APPLICATIONS TO CREDIT_MANAGER_ROLE;
GRANT DELETE ON APPLICATIONS TO CREDIT_MANAGER_ROLE;
GRANT CREATE SESSION TO CREDIT_MANAGER_ROLE;
BEGIN
FOR i IN (SELECT uuid FROM STAFFS WHERE job_postion = 'CM') LOOP
    EXECUTE IMMEDIATE 'GRANT CREDIT_MANAGER_ROLE TO ' || i.uuid;
END LOOP;
END;

--- Role của người đại diện dịch vụ khách hàng
CREATE ROLE CUSTOMER_SERVICE_REPRESENTATIVES_ROLE;
GRANT SELECT ON APPLICATIONS TO CUSTOMER_SERVICE_REPRESENTATIVES_ROLE;
GRANT UPDATE 
(c_name, c_cccd, c_phone_num, c_addr, c_email) 
ON APPLICATIONS TO CUSTOMER_SERVICE_REPRESENTATIVES_ROLE;
GRANT CREATE SESSION TO CUSTOMER_SERVICE_REPRESENTATIVES_ROLE;


BEGIN
FOR i IN (SELECT uuid FROM STAFFS WHERE job_postion = 'CS') LOOP
    EXECUTE IMMEDIATE 'GRANT CUSTOMER_SERVICE_REPRESENTATIVES_ROLE TO ' || i.uuid;
END LOOP;
END;
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
--- Analyze policy khi isRead = 'Y' thì không được xóa ANALYZE 
CREATE OR REPLACE FUNCTION analyze_delete_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
BEGIN
    v_policy := 'last_updated is NULL';
    RETURN v_policy;
END;
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'ANALYZE',
        policy_name => 'analyze_delete_policy_function',
        function_schema => 'BANKADM',
        policy_function => 'analyze_delete_policy_function',
        statement_types => 'DELETE'
    );
END;

CREATE OR REPLACE TRIGGER analyze_update_trigger
BEFORE UPDATE ON ANALYZE
FOR EACH ROW
BEGIN
    :NEW.last_updated := SYSTIMESTAMP;
END;

CREATE OR REPLACE FUNCTION analyze_update_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
BEGIN
    v_policy := 'isRead = ''N''';
    RETURN v_policy;
END;
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'ANALYZE',
        policy_name => 'analyze_update_policy_function',
        function_schema => 'BANKADM',
        policy_function => 'analyze_update_policy_function',
        statement_types => 'UPDATE'
    );
END;

--- VPD cho BANK_ACCOUNT
CREATE OR REPLACE FUNCTION bank_account_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
    user VARCHAR2(100);
BEGIN
    user := SYS_CONTEXT('USERENV', 'SESSION_USER');
    v_policy := 'c_id = ' || user || ' OR created_by = ' || user;
    RETURN v_policy;
END;

BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'BANK_ACCOUNT',
        policy_name => 'bank_account_policy_function',
        function_schema => 'BANKADM',
        policy_function => 'bank_account_policy_function',
        statement_types => 'SELECT, UPDATE, DELETE'
    );
END;
--- AUDIT POLICY audit trên analyze và applications
CREATE AUDIT POLICY applications_audit_policy
    ACTIONS DELETE on APPLICATIONS,
            INSERT on APPLICATIONS,
            UPDATE on APPLICATIONS,
            ALL on ANALYZE;

            

