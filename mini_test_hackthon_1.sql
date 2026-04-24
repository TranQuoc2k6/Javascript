create database mini_test;
use mini_test;

-- I. Khởi tạo và Cập nhật

-- 1. Tạo bảng : Viết lệnh SQL tạo 4 bảng trên với đầy đủ các ràng buộc đầy đủ

create table customers (
	customer_id varchar(100) primary key,
    full_name varchar(100) not null,
    license_no varchar(20) unique,
    phone varchar(15) not null,
    address varchar(15) not null
);

create table staffs (
	staff_id varchar(10) primary key,
    full_name varchar(100) not null,
    branch varchar(50) not null,
    salary_base decimal(15,2) check (salary_base >= 0) not null,
    performance_score decimal(3,2) default 0
);

create table rentals (
	rental_id int primary key auto_increment,
    customer_id varchar(10),
    foreign key (customer_id) references customers (customer_id),
    staff_id varchar(10),
    foreign key (staff_id) references staffs (staff_id),
    rental_date timestamp not null,
    return_date timestamp not null,
    status enum ('Booked', 'PickedUp', 'Returned', 'Cancelled')
);

create table payments (
	payment_id int primary key auto_increment,
    rental_id int,
    foreign key (rental_id) references rentals (rental_id),
    payment_method varchar(50) not null,
    payment_date timestamp default (current_timestamp()),
    amount decimal(15,2) check (amount >= 0)
);

-- 2. Chèn dữ liệu : Thêm ít nhất 5 khách hàng, 5 nhân viên, 5 hợp đồng và 5 phiếu thanh toán (đảm bảo tính logic về thời gian và mã liên kết).
insert into customers 
values 
	('C001','Nguyen Van A','DL12345','0901234567','Hanoi'),
	('C002','Tran Thi B','DL23456','0912345678','Da Nang'),
	('C003','Le Hoang Nam','DL34567','0923456789','Hue'),
	('C004','Pham Hoang Long',NULL,'0934567890','Hanoi'),
	('C005','Hoang Minh Tuan','DL56789','0945678901','HCM');
    
insert into staffs
values 
	('S001','Nguyen Van Staff1','Hanoi',10000000,4.2),
	('S002','Tran Staff2','Hanoi',12000000,4.5),
	('S003','Le Staff3','Da Nang',9000000,3.8),
	('S004','Pham Staff4','HCM',11000000,4.7),
	('S005','Hoang Staff5','Da Nang',9500000,4.1);
    
insert into rentals (customer_id, staff_id, rental_date, return_date, status)
values 
	('C001','S001','2024-10-01','2024-10-05','Returned'),
	('C002','S002','2024-10-03','2024-10-06','PickedUp'),
	('C003','S003','2023-12-20','2023-12-25','Cancelled'),
	('C004','S001','2024-09-15','2024-09-20','Returned'),
	('C005','S004','2024-10-10','2024-10-15','Booked'),
	('C001','S002','2024-10-12','2024-10-18','Returned'),
	('C002','S002','2024-10-15','2024-10-20','Returned');
    
insert into payments (rental_id, payment_method, payment_date, amount)
values
	(1,'Cash','2024-10-05',2000000),
	(2,'Credit Card','2024-10-03',3000000),
	(4,'Cash','2024-09-20',1500000),
	(6,'Credit Card','2024-10-18',4000000),
	(7,'Cash','2024-10-20',2500000);


select * from customers;
select * from staffs;
select * from rentals;
select * from payments;


-- 3. Cập nhật địa chỉ : Thay đổi địa chỉ của khách hàng C003 thành "Lien Chieu, Da Nang".
update customers
set address = 'Da Nang'
where customer_id = 'C003';

-- 4. Tăng lương & Đánh giá: Nhân viên S002 làm việc tốt, hãy tăng salary_base thêm 10% và cập nhật performance_score thành 4.8.
update staffs
set salary_base = salary_base * 1.1, performance_score = 4.8 -- không được dùng 'and' trong trường hợp này; chỉ được dùng and trong where hoặc having
where staff_id = 'S002';

-- 5. Xóa dữ liệu : Xóa các hợp đồng có trạng thái "Cancelled" và có ngày thuê trước "2024-01-01".
delete from rentals 
where status = 'Cancelled' and rental_date < '2024-01-01';

-- 6. Ràng buộc (Constraint): Viết lệnh ALTER TABLE để thêm ràng buộc mặc định (DEFAULT) cho cột address trong bảng Customers là "Unknown".
alter table customers
modify column address varchar(15) not null default 'Unknown';

-- 7. Thêm cột (Alter): Thêm cột email (VARCHAR(100)) vào bảng Staffs.
alter table staffs
add column email varchar(100);

-- 8. Cập nhật hàng loạt: Giảm 5% giá trị amount trong bảng Payments cho tất cả các giao dịch thực hiện bằng phương thức "Cash".
update payments
set amount = amount * 0.95
where payment_method = 'Cash';

-- 9. Ràng buộc kiểm tra (Check): Thêm một ràng buộc CHECK cho bảng Rentals để đảm bảo return_date phải lớn hơn hoặc bằng rental_date.
alter table rentals
add constraint check (return_date >= rental_date);

-- II. Truy vấn dữ liệu cơ bản

-- 1. Liệt kê nhân viên có performance_score từ 4.0 trở lên tại chi nhánh "Hanoi".
select *
from staffs
where performance_score >= 4 and branch = 'Hanoi';

-- Tìm khách hàng có tên chứa từ khóa "Hoang" và có cung cấp số điện thoại.
select *
from customers
where full_name like '%Hoang%' and phone is not null;

-- 2. Hiển thị danh sách hợp đồng: rental_id, rental_date, status, sắp xếp theo rental_date mới nhất lên đầu.
select rental_id, rental_date, status
from rentals
order by rental_date desc;

-- 3. Lấy 3 bản ghi thanh toán mới nhất có phương thức là 'Credit Card'.
select *
from payments
where payment_method = 'Credit Card'
order by payment_date desc
limit 3;

-- 4. Hiển thị staff_id, full_name của nhân viên, bỏ qua 3 người đầu tiên và lấy 2 người tiếp theo.
select staff_id, full_name
from staffs
limit 2 offset 3;

-- 5. Lọc theo khoảng (Between): Liệt kê các phiếu thanh toán có số tiền (amount) nằm trong khoảng từ 1.000.000 đến 5.000.000.
select *
from payments
where amount between 1000000 and 5000000;

-- 6. Xử lý thời gian: Hiển thị danh sách các hợp đồng thuê xe (Rentals) được thực hiện trong tháng 10 năm 2024.
select *
from rentals
where return_date between '2024-10-01' and '2024-10-31';

-- 7. Tìm giá trị duy nhất (Distinct): Lấy danh sách các thành phố (chi nhánh) khác nhau từ bảng Staffs mà không trùng lặp.
select distinct branch
from staffs;

-- 8. Lọc theo danh sách (In): Tìm các nhân viên làm việc tại chi nhánh "Hanoi" hoặc "Da Nang".
select full_name, branch
from staffs
where branch in ('Hanoi', 'Da Nang');

-- 9. Kiểm tra giá trị trống (Is Null): Liệt kê những khách hàng chưa cập nhật số bằng lái xe (license_no là NULL) 
-- Lưu ý: Sinh viên cần chỉnh sửa lại ràng buộc NOT NULL lúc tạo bảng để làm câu này
select *
from customers
where license_no is null;

-- III. Truy vấn nâng cao 

-- 11. Hiển thị rental_id, full_name (khách), full_name (nhân viên) và status của các hợp đồng có trạng thái 'PickedUp'.
select r.rental_id, c.full_name, s.full_name, r.status
from rentals as r
join customers as c
on r.customer_id = c.customer_id
join staffs as s
on r.staff_id = s.staff_id
where status = 'PickedUp';

-- 12. Liệt kê tất cả nhân viên và mã hợp đồng họ đã xử lý (bao gồm cả nhân viên chưa có hợp đồng nào).
select s.staff_id, full_name, rental_id
from staffs as s
left join rentals as r
on s.staff_id = r.staff_id;

-- 13. Tính tổng doanh thu (SUM(amount)) thu được từ mỗi phương thức thanh toán
select payment_method, sum(amount)
from payments
group by payment_method;

-- 14. Thống kê số lượng hợp đồng mỗi nhân viên đã thực hiện. Chỉ hiện người có trên 2 hợp đồng.
select staff_id, count(rental_id) as rental_total
from rentals
where rental_id is not null
group by staff_id
having rental_total > 2;

-- 15. Tìm nhân viên có lương cơ bản cao hơn mức lương trung bình của toàn công ty.
select *
from staffs
where salary_base > (
	select avg(salary_base)
    from staffs
);

-- 16. Hiển thị tên khách hàng và tổng tiền họ đã chi trả cho các hợp đồng đã hoàn tất ('Returned').
select status , c.full_name, sum(amount) as total_amount
from customers as c
join rentals as r
on c.customer_id = r.customer_id
join payments as p
on r.rental_id = p.rental_id
where status = 'Returned'
group by status, c.full_name;

-- 17. Xuất báo cáo gồm: rental_id, customer_name, staff_name, payment_method và amount.
select r.rental_id, c.customer_id, s.full_name, p.payment_method, p.amount
from rentals as r
left join customers as c
on r.customer_id = c.customer_id
left join staffs as s
on r.staff_id = s.staff_id
left join payments as p
on r.rental_id = p.rental_id;