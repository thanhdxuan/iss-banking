-------------------------------------------------------------
--- VPD cho BANK_ACCOUNT
CREATE OR REPLACE FUNCTION bank_account_policy_function (
    schema_name IN VARCHAR2,
    table_name IN VARCHAR2
) RETURN VARCHAR2 AS
    v_policy VARCHAR2(1000);
    user VARCHAR2(100);
BEGIN
    if SYS_CONTEXT('USERENV', 'SESSION_USER') = 'BANKADM' THEN
        v_policy := '1 = 1';
    ELSE
        user := SYS_CONTEXT('users_ctx', 'uuid');
        v_policy := 'c_id = ''' || user || ''' OR created_by = ''' || user || '''';
    END IF;
    RETURN v_policy;
END;
/
BEGIN
    DBMS_RLS.ADD_POLICY(
        object_schema => 'BANKADM',
        object_name => 'BANK_ACCOUNT',
        policy_name => 'bank_account_policy',
        function_schema => 'BANKADM',
        policy_function => 'bank_account_policy_function',
        statement_types => 'SELECT, UPDATE, DELETE'
    );
END;
/
--- AUDIT POLICY audit trên analyze và applications
CREATE AUDIT POLICY applications_audit_policy
    ACTIONS DELETE on APPLICATIONS,
            INSERT on APPLICATIONS,
            UPDATE on APPLICATIONS,
            ALL on ANALYZE;

            
--- OLS POLICY cho APPLICATIONS
