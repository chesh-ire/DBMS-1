
create table Salesman(
Salesman_ID int primary key,
Name varchar(20),
City varchar(20),
Commission varchar(20));
Create table Customer(
Customer_ID int primary key,
City varchar(20),
Grade int,
Salesman_ID references Salesman(Salesman_ID) on delete set null,
Cust_Name varchar(20));
create table Orders(Ord_No int primary key,
Purchase_Amt Number,
Ord_Date date,
Customer_ID references Customer(Customer_ID) on delete cascade,
Salesman_ID references Salesman(Salesman_ID) on delete cascade);
insert into salesman values(1000,'Rita','Mysuru','25%');
insert into salesman values(1001,'Jeevan','Bangalore','20%');
insert into salesman values(1002,'Baby','Bangalore','15%');
insert into salesman values(1004,'Abhi','Shivamogga','30%');
insert into customer values(1,'Bangalore',100,1000,'Mita');
insert into customer values(2,'Mysuru',200,1001,'Gita');
insert into customer values(3,'Mangalore',300,1000,'Anna');
insert into customer values(4,'Bangalore',400,1001,'Louis');
insert into customer values(5,'Bangalore',500,1002,'rose');
insert into orders values(50,5000,'04-May-2017',1,1000);
insert into orders values(51,450,'20-Jun-2017',1,1001);
insert into orders values(52,1000,'20-Jun-2017',3,1000);
insert into orders values(53,3500,'13-Apr-2017',4,1002);
insert into orders values(54,550,'09-Mar-2017',5,1001);
insert into orders values(55,5500,'13-Apr-2017',4,1004);
/* Q1 */
Select cust_name
from customer
where grade > (Select avg(grade)
from customer
where city='Bangalore');
/* Q2 */
select s.salesman_id, s.name ,count(*) as no_of_customers
from salesman s, customer c
where s.salesman_id=c.salesman_id
group by s.salesman_id, s.name
having count(*)>1;
/* Q3 using UNION */
select s.name , c.cust_name, s.city
from salesman s, customer c
where s.city=c.city
union
select s.name, c.cust_name , 'NO MATCH'
from salesman s, customer c
where s.city not in (select city from customer)
/* Q4 using Group by */
create view MAX_AMT_ODR as
Select o.ord_date, s.salesman_id, s.name
from salesman s, orders o
where s.salesman_id=o.salesman_id and o.purchase_amt in (select max(purchase_amt)
from orders
group by ord_date)
select * from MAX_AMT_ODR;
/* Q4 using correlated queries */
create view salesman_order as
select b.Ord_Date, a.Salesman_ID,Name
from Salesman a, Orders B
where A.Salesman_ID=b.Salesman_ID and b.Purchase_Amt= (select max(Purchase_Amt)
from Orders C
where C.Ord_Date=b.Ord_Date);
select * from salesman_order;
/* Q5 */
delete from salesman
where salesman_id=1000



LAB PROGRAM 1
1. Consider the following schema for a Library Database:
BOOK (BOOK_ID, TITLE, PUBLISHER_NAME, PUB_YEAR)
BOOK_AUTHORS (BOOK_ID, AUTHOR_NAME)
PUBLISHER (NAME, ADDRESS, PHONE)
BOOK_COPIES (BOOK_ID, BRANCH_ID, NO_OF_COPIES)
BOOK_LENDING (BOOK_ID, BRANCH_ID, CARD_NO, DATE_OUT, DUE_DATE)
LIBRARY_BRANCH (BRANCH_ID, BRANCH_NAME, ADDRESS)
CARD (CARD_NO)
Write SQL queries to
a) Retrieve details of all books in the library – id, title, name of publisher, authors,
number of copies in each branch.
b) Get the particulars of borrowers who have borrowed more than 3 books, but from
Jan 2017 to Jun 2017.
c) Partition the BOOK table based on year of publication. Demonstrate its working with
a simple query.
d) Create a view of all books and its number of copies that are currently available in the
library.
e) Delete a book in the BOOK table. Update the contents of other tables to reflect this
data manipulation operation.
Solution:
create table publisher(
name varchar(10) primary key,
pub_address varchar(10),
phone int);
create table library_branch(
branch_id int primary key,
branch_name varchar(10),
address varchar(10));
create table card(
card_no int primary key);
create table book(
book_id int primary key,
title varchar(20),
pub_name varchar(10) references publisher(name) on delete set null,
pub_year varchar(20)
);
create table book_author(
book_id int references book(book_id) on delete cascade,
author_name varchar(10),
primary key(book_id,author_name)
);
create table book_copies(
book_id int references book(book_id) on delete cascade,
branch_id int references library_branch(branch_id) on delete set null,
no_of_copies int,
primary key(book_id,branch_id)
);
create table book_lending(
book_id int references book(book_id) on delete cascade,
branch_id int references library_branch(branch_id) on delete cascade,
card_no int references card(card_no) on delete cascade,
date_out date,
due_date date,
primary key(book_id,branch_id,card_no)
);
insert into publisher values('Jaico Publishing House','Mumbai',3260618);
insert into publisher values('Penguin Random House','New York',18007333000);
insert into publisher values('Hachette India','Gurgaon',911244195000);
insert into publisher values('24by7Publishing','Kolkata',09433444334);
insert into publisher values('Srishti Publishers','Delhi',01141751981);
insert into library_branch values(1,'ISE','VVCE');
insert into library_branch values(2,'CSE','VVCE');
insert into library_branch values(3,'AIML','VVCE');
insert into library_branch values(4,'MECH','VVCE');
insert into library_branch values(5,'EC','VVCE');
insert into card values(1000);
insert into card values(1001);
insert into card values(1002);
insert into card values(1003);
insert into card values(1004);
insert into book values(100,'The Monk who sold his Ferrari','Jaico Publishing House',1996);
insert into book values(101,'The God of Small Things','Penguin Random House',1997);
insert into book values(102,'Durbar','Hachette India',2012);
insert into book values(103,'Kanishka','24by7Publishing',2017);
insert into book values(104,'Life Is What You Make It','Srishti Publishers',2011);
insert into book_author values(100,'Robin Sharma');
insert into book_author values(101,'Arundhati Roy');
insert into book_author values(102,'Tavleen Singh');
insert into book_author values(103,'Manoj Krishnan');
insert into book_author values(104,'Preeti Shenoy');
insert into book_copies values(100,1,6);
insert into book_copies values(101,2,7);
insert into book_copies values(102,3,8);
insert into book_copies values(103,4,9);
insert into book_copies values(104,5,10);
insert into book_copies values(102,2,10);
insert into book_copies values(104,1,10);
insert into book_lending values(100,1,1000,'01-Jan-2017','01-Feb-2017');
insert into book_lending values(101,2,1001,'01-Feb-2017','01-Mar-2017');
insert into book_lending values(102,3,1002,'01-Apr-2017','01-May-2017');
insert into book_lending values(103,4,1003,'01-Apr-2017','01-May-2017');
insert into book_lending values(104,5,1004,'01-May-2017','01-Jun-2017');
insert into book_lending values(102,1,1000,'10-Jan-2017','10-Feb-2017');
insert into book_lending values(103,2,1000,'10-Jan-2017','10-Feb-2017');
insert into book_lending values(101,2,1003,'01-Apr-2017','01-May-2017');
insert into book_lending values(104,3,1003,'01-Apr-2017','01-May-2017');
Queries
Q1.
select b.book_id,b.title,b.pub_name,a.author_name,c.branch_id,c.no_of_copies
from Book1 b, book1_author a,book_copies c
where b.book_id=a.book_id and a.book_id=c.book_id;
Q2
select card_no from book_lending
where date_out between '01-JAN-2017' and '01-jun-2017'
group by card_no
having count(*)>=3;
Q3.
create view book_pub_year as
select pub_year from book1;
select * from book_pub_year;
Q4.
create view book_in_lib as
select b.book_id,b.title,c.branch_id,c.no_of_copies
from book1 b, book_copies c
where b.book_id=c.book_id;
select * from book_in_lib;
Q5.
delete from book1 where book_id=103