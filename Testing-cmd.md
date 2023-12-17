Để đáp ứng yêu cầu nghiệp vụ đã đề xuất ở chương trước, nhóm thiết kế các VPD để thiết lập các policy
Sau đây là phần demo policy.

# Sơ lược về tập dữ liệu và dữ liệu
conn bankadm/bankadm@localhost:1521/bankpdb;

# VPD Thứ nhất Quy định mỗi user chỉ được xem thông tin của chính mình.

conn DANIEL/"@Aa12345678"@localhost:1521/bankpdb;
select * from bankadm.users;

conn customer1/"@Aa12345678"@localhost:1521/bankpdb;
select * from bankadm.users;

# VPD Thứ 2 quy định khả năng truy cập đến thông tin của bảng applications,

* Cho xem tất cả các đơn trong hệ thống
Với khách hàng, khách hàng chỉ được xem những đơn mà mình đã tạo.
conn customer2/"@Aa12345678"@localhost:1521/bankpdb;
select uuid from bankadm.users where username = 'customer2';
select * from bankadm.applications;
select a.created_by uuid from bankadm.applications a;

conn customer3/"@Aa12345678"@localhost:1521/bankpdb;
select uuid from bankadm.users where username = 'customer3';
select * from bankadm.applications;
select a.created_by uuid from bankadm.applications a;

Với CM, luôn luôn có thể xem được tất cả các đơn
conn bankcm/"@Aa12345678"@localhost:1521/bankpdb;
select count(*) from bankadm.applications;


Với CA, chỉ được xem những đơn mà mình được phân công đánh giá
conn bankca02/"@Aa12345678"@localhost:1521/bankpdb;

select a.a_id, a.s_id from bankadm.analyze a;
select * from bankadm.applications;
select a.id from bankadm.applications a;

# VPD Thứ 3 quy định khả năng truy cập đến thông tin của bảng đánh giá
CA chỉ có thể xem được những đánh giá mà mình được phân công, 

conn bankca02/"@Aa12345678"@localhost:1521/bankpdb;
SELECT staff_id FROM BANKADM.STAFFS WHERE uuid = SYS_CONTEXT('users_ctx', 'uuid');
select a.a_id, a.s_id from bankadm.analyze a;

conn bankca03/"@Aa12345678"@localhost:1521/bankpdb;
SELECT staff_id FROM BANKADM.STAFFS WHERE uuid = SYS_CONTEXT('users_ctx', 'uuid');
select a.a_id, a.s_id from bankadm.analyze a;

# VPD Thứ 4 quy định khả năng truy cập đến thông tin thu nhập của khách hàng

Chỉ có CM và CA có thể xem được thông tin thu nhập của khách hàng

conn bankcm/"@Aa12345678"@localhost:1521/bankpdb;
select a.id, a.c_income from bankadm.applications a;

conn bankca03/"@Aa12345678"@localhost:1521/bankpdb;
select a.id, a.c_income from bankadm.applications a;

conn bankcsr01/"@Aa12345678"@localhost:1521/bankpdb;
select a.id, a.c_income from bankadm.applications a;

# VPD Thứ 5 quy định khả năng truy cập đến thông tin đánh giá của CA

Khi hết thời gian đánh giá, các đánh giá sẽ đc chuyển về CM để CM có thể phê duyệt,
Trước khi phê duyệt CA có thể tuỳ chỉnh thông tin đánh giá, nhưng sau khi đánh giá được CM phê duyệt thì không thể update.

conn bankca03/"@Aa12345678"@localhost:1521/bankpdb;
select * from bankadm.analyze;


conn bankadm/bankadm@localhost:1521/bankpdb;
update bankadm.analyze set ISREAD = 'Y' where a_id = 1;

conn bankca03/"@Aa12345678"@localhost:1521/bankpdb;
update bankadm.analyze set ANALYSIS = '124' where a_id = 1;

# VPD thứ 6 quy định khả năng truy cập đến thông tin của bảng đánh giá

CM chỉ có thể đổi người đánh giá cho một hồ sơ nếu như người đó chưa thực hiện đánh giá
conn bankcm/"@Aa12345678"@localhost:1521/bankpdb;

delete from bankadm.analyze where a_id = 1 and s_id = 2;

# Auditting

conn bankadm/bankadm@localhost:1521/bankpdb;
SELECT * FROM DBA_FGA_AUDIT_TRAIL;

conn customer1/"@Aa12345678"@localhost:1521/bankpdb;
update bankadm.applications set c_income = 2000000;


