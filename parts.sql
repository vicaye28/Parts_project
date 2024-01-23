Create DATABASE Parts; 
 
Use Parts;
CREATE TABLE part(
  P_id Varchar(50) NOT NULL,
  p_name VARCHAR(50) NOT NULL,
  colour VARCHAR(50) NOT NULL,
  weight FLOAT(2),
  city VARCHAR(50) NOT NULL

);
Insert INTO part
(P_id, p_name, colour, weight, city)
Values
('P1', 'NUT', 'RED', 12, 'LONDON'),
('P2', 'BOLT', 'GREEN', 17, 'PARIS'),
('P3', 'SCREW', 'BLUE', 17, 'ROME'),
('P4', 'SCREW', 'RED', 14, 'LONDON'),
('P5', 'CAM', 'BLUE', 12, 'PARIS'),
('P6', 'COG', 'RED', 19, 'LONDON');
select* from part;

Use Parts;
CREATE Table project(
J_id Varchar(50) NOT NULL,
  j_name VARCHAR(50) NOT NULL,
  city Varchar(50) NOT NULL
);
Insert into project
(J_id, j_name, city)
Values
('J1', 'SORTER', 'PARIS'),
('J2', 'DISPLAY', 'ROME'),
('J3', 'OCR', 'ATHENS'),
('J4', 'CONSOLE', 'ATHENS'),
('J5', 'RAID', 'LONDON'),
('J6', 'EDS', 'OSLO'),
('J7', 'TAPE', 'LONDON');
select * from part;

use Parts;
Create Table supplier(
  S_id Varchar(50) NOT NULL,
  Sname VARCHAR(50) NOT NULL,
  s_status Int Not null,
  city Varchar(50) Not null
);
Insert into supplier 
(S_id, sname, s_status, city)
Values 
('S1', 'SMITH', 20, 'LONDON'),
('S2', 'JONES', 10, 'PARIS'),
('S3', 'BLAKE', 30, 'PARIS'),
('S4', 'CLARK', 20, 'LONDON'),
('S5', 'ADAMS', 30, 'ATHENS');
select *from supplier;

Use Parts;
Create Table supply(
S_id varchar(50) NOT null,
P_id varchar(50) NOT NULL,
J_id varchar(50) Not null,
quantity int not null
);
Insert into supply
(S_id, P_id, J_id, quantity)
Values
('S1', 'P1', 'J1', 200),
('S1', 'P1', 'J4', 700),
('S2', 'P3', 'J1', 400),
('S2', 'P3', 'J2', 200),
('S2', 'P3', 'J4', 500),
('S2', 'P3', 'J5', 600),
('S2', 'P3', 'J6', 400),
('S2', 'P3', 'J7', 800),
('S2', 'P5', 'J2', 100),
('S3', 'P3', 'J1', 200),
('S3', 'P4', 'J2', 500),
('S4', 'P6', 'J3', 300),
('S4', 'P6', 'J7', 300),
('S5', 'P2', 'J2', 200),
('S5', 'P2', 'J4', 100),
('S5', 'P5', 'J5', 500),
('S5', 'P5', 'J7', 100),
('S5', 'P6', 'J2', 200),
('S5', 'P1', 'J4', 100),
('S5', 'P3', 'J4', 200),
('S5', 'P4', 'J4', 800),
('S5', 'P5', 'J4', 400),
('S5', 'P6', 'J4', 500);
select* from supply;

select distinct 
p_name, P_id
from part;

select J_id, city
from project
where city = 'LONDON';

/*find the name and weight of red parts*/
Use Parts;
Select p_name, weight
From part
where colour = 'RED';

/* find unique names of suppliers from London*/
Select distinct
sname
from supplier
where city = 'LONDON';

/* find the name and status of each supplier who supplies project J2-this uses a subquery */

Use parts;

select s.sname, s.s_status 
from supplier s
where S_ID in (select S_ID
from supply
where J_ID = 'J2');




/* Find the name and city of each project supplied by a London-based supplier */

select * from supply;

Select p.j_name, p.City
from project p
where city in (select city
from supplier
where city = 'LONDON');

Select p.j_name, p.City
from project p
Where J_ID in (select J_ID
from supply
where S_ID in (select S_ID
from supplier
where city = 'LONDON'));

/* Find the name and city of each project not supplied by a London-based supplier*/

Select p.j_name, p.City
from project p
Where J_ID NOT in (select J_ID
from supply
where S_ID in (select S_ID
from supplier
where city = 'LONDON'));

/*Find the supplier name, part name and project name for each case where a
supplier supplies a project with a part, but also the supplier city, project city
and part city are the same.*/
select * from supply;

Select s.Sname, p.p_name, pro.j_name
From supply s
Inner join part p
ON s.city = p.city
Inner Join project pro 
ON pro.city = p.city;

/* correct one- use the primary keys to join them, uses the supply table as this gives us the anser we want and 
now we want to filter that out*/
use Parts;
Select Sname, p_name, j_name
From supply s
Join supplier sl
ON s.S_id = sl.S_id
Join project pro
on s.J_id = pro.J_id
Join part p
ON s.P_id = p.P_id
where sl.city = pro.city AND pro.city = p.city;

use parts;
SELECT * from part;

/* created a fucntion to show if weight is heavy or light*/
Delimiter //
create function isitheavy(weight INT)
Returns varchar(20)
Deterministic
Begin 
Declare full_weight varchar (100);
	If weight >= 15 then
		set full_weight = 'Heavy';
	Elseif weight < 15 then
		set full_weight = 'Light';
	End if;
	Return(full_weight);
End //
Delimiter ;

SELECT p_id, p_name, weight, isitheavy(weight) as heavy_or_light
from
part;
 
/* procedure*/

select * from supplier;

/* created a procedure to add values into a table*/
Delimiter //:
Create procedure supplier(IN S_id varchar(10), IN Sname varchar(30), IN s_status INT, city varchar (30))
Begin 
Insert into supplier (S_id, Sname, s_status, city)
Values (S_id, Sname, s_status, city);
end //:
delimiter ;


call supplier('S7', 'Antonic', 10, 'Novi Sad');

select* 
from supplier;

/* created a trigger to make status always equal to a number divisible by 10*/

Delimiter //
create trigger incorrect_status
Before insert on supplier
For each row 
Begin 
Set New.s_status = New.s_status - New.s_status MOD 10;
End //
Delimiter ;

insert into supplier 
values ('S8', 'MARKS', 15, 'LONDON');

/* created an event to insert a row after specified time*/
create event IF NOT EXISTS event_practice
on SCHEDULE at current_timestamp + interval 1 minute 
do 
INSERT into supplier values ('S9', 'BAKER', 25, 'PARIS');

select * from supplier;
