conn bankcm/"@Aa12345678"@localhost:1521/bankpdb;

INSERT INTO BANKADM.ANALYZE
(a_id,s_id,isRead)
SELECT BANKADM.APPLICATIONS.id,BANKADM.STAFFS.STAFF_ID,'N'
FROM BANKADM.APPLICATIONS 
INNER JOIN BANKADM.STAFFS
ON BANKADM.STAFFS.JOB_POSTION = 'CA';


commit;

INSERT INTO BANKADM.ANALYZE
(a_id,s_id,isRead)
SELECT BANKADM.APPLICATIONS.id,BANKADM.STAFFS.STAFF_ID,'N'
FROM BANKADM.APPLICATIONS 
INNER JOIN BANKADM.STAFFS
ON BANKADM.STAFFS.JOB_POSTION = 'CA';
-- SELECT * FROM v$session WHERE USERNAME = 'BANKCM';
