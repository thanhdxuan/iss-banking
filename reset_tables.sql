BEGIN
   FOR t IN (SELECT table_name FROM user_tables) LOOP
      EXECUTE IMMEDIATE 'DROP TABLE ' || t.table_name || ' CASCADE CONSTRAINTS';
   END LOOP;
END;
/
@@create.sql
-- @@create_users.sql
-- @@create_role.sql

@@insert_users.sql
@@insert_staffs.sql
@@insert_customers.sql