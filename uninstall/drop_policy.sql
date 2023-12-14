-- --- DROP USERS_POLICY
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'USERS',
--         policy_name => 'user_policy'
--     );
-- END;
-- /

-- --- DROP APPLICATIONS
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'APPLICATIONS',
--         policy_name => 'applications_policy'
--     );
-- END;
-- /

-- --- DROP analyze_policy
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'ANALYZE',
--         policy_name => 'analyze_policy'
--     );
-- END;
-- /

-- --- DROP analyze_delete_policy
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'ANALYZE',
--         policy_name => 'analyze_delete_policy'
--     );
-- END;
-- /
-- --- DROP analyze_update_policy
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'ANALYZE',
--         policy_name => 'analyze_update_policy'
--     );
-- END;
-- /
-- --- DROP bank_account_policy
-- BEGIN
--     DBMS_RLS.DROP_POLICY(
--         object_schema => 'BANKADM',
--         object_name => 'BANK_ACCOUNT',
--         policy_name => 'bank_account_policy'
--     );
-- END;
-- /
--- DROP tất cả VPD policy;
BEGIN
    FOR i in (SELECT OBJECT_OWNER,OBJECT_NAME,POLICY_NAME FROM ALL_POLICIES) LOOP
        DBMS_RLS.DROP_POLICY(
            object_schema => i.OBJECT_OWNER,
            object_name => i.OBJECT_NAME,
            policy_name => i.POLICY_NAME
        );
    END LOOP;
END;
/
SELECT * FROM ALL_POLICIES;
/