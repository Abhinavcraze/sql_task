--if need to delete a particular column if it used a getcurrentdate method to get the data then use this

SELECT name
FROM sys.default_constraints
WHERE parent_object_id = OBJECT_ID('Employee')
  AND parent_column_id = (
      SELECT column_id                                              --for knowledge
      FROM sys.columns
      WHERE object_id = OBJECT_ID('Employee')                      --important
        AND name = 'CreatedDate'
  );

  ALTER TABLE Employee
DROP CONSTRAINT DF__employee__Create__6EF57B66;

ALTER TABLE Employee
DROP COLUMN CreatedDate;

--------------------------------------------------------------------------------

CREATE DATABASE PayRollDemo1;
Use payRollDemo1;

CREATE TABLE country (
    id INT IDENTITY(1,1) PRIMARY KEY,
    country_name VARCHAR(255) NOT NULL UNIQUE
);

-- City table (depends on country)
CREATE TABLE city (
    id INT IDENTITY(1,1) PRIMARY KEY,
    city_name VARCHAR(255) NOT NULL,
    country_id INT NOT NULL,
    FOREIGN KEY (country_id) REFERENCES country(id)
);

-- Gender table
CREATE TABLE gender (
    id INT IDENTITY(1,1) PRIMARY KEY,
    gender_name VARCHAR(64) NOT NULL UNIQUE
);

-- Department table
CREATE TABLE department (
    id INT IDENTITY(1,1) PRIMARY KEY,
    department_name VARCHAR(255) NOT NULL UNIQUE
);

-- Job Title table
CREATE TABLE job_title (
    id INT IDENTITY(1,1) PRIMARY KEY,
    job_title VARCHAR(255) NOT NULL UNIQUE
);

create table employee(
    id int identity(1,1) primary key,
	first_name VARCHAR(255) NOT NULL,
	last_name VARCHAR(255) NOT NULL,
	date_of_birth date NOT NULL,
	job_title_id int NOT NULL,
	department_id int NOT NULL,
	gender_id int NOT NULL,
	address varchar(255),
	city_id int NOT NULL,
	email varchar(255),
	employment_start date NOT NULL,

	FOREIGN KEY (job_title_id) references job_title(id),
	FOREIGN KEY (department_id) references department(id),
	FOREIGN KEY (gender_id) references gender(id),
	FOREIGN KEY (city_id) references city(id)
);

create table job_title_history(
    id int Identity(1,1) Primary key,
	job_title_id int not null,
	employee_id int not null,
	start_date date not null,
	end_date date null,

	check(end_date is null or start_date<=end_date),
	Foreign key (job_title_id) references job_title(id),
	Foreign key (employee_id) references employee(id)
);

create table department_history(
	id int identity(1,1) primary key,
	department_id int not null,
	employee_id int not null,
	start_date date not null,
	end_date date null,

	check(end_date is null or start_date<=end_date),
	FOREIGN KEY (department_id) references department(id),
	FOREIGN KEY (employee_id) references employee(id)
);
	
create table employement_terms(
   id int identity(1,1) primary key,
   employee_id int NOT NULL,
   agreed_salary decimal(10,2) NOT NULL,
   salary_start_date date NOT NULL,
   salary_end_date date null,
   check(salary_end_date is null or salary_start_date<=salary_end_date),
	FOREIGN KEY (employee_id) references employee(id)
);

--salary

create table working_hours_log(
   id int identity(1,1) primary key,
   employee_id int not null,
   start_time dateTime not null,
   end_time dateTime null,

   check(end_time is null or end_time>=start_time),
   FOREIGN KEY (employee_id) references employee(id)
);

create table salary_payment(
	id int identity(1,1) primary key,
	employee_id int not null,
	gross_salary varchar(255) not null,
	net_salary varchar(255) not null,
	salary_period date not null,
	FOREIGN KEY (employee_id) references employee(id)
);


create table adjustment (
   id int identity(1,1) primary key,
   adjustment_name varchar(255) not null Unique,
   adjustment_percentage decimal(10,2) not null,
   is_working_hours_adjustment BIT NOT NULL DEFAULT 0,
   is_other_adjustment BIT NOT NULL default 0
);

create table adjustment_amount(
	id int identity(1,1) primary key,
	salary_payment_id int not null,
	adjustment_id int not null,
	adjustment_amount decimal(10,2) null,
	adjustment_percentage decimal(10,2) null,

	Foreign key (salary_payment_id) references salary_payment(id),
	Foreign key (adjustment_id) references adjustment(id)
);

CREATE TABLE working_hours_adjustment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    working_hours_log_id INT NOT NULL,
    adjustment_id INT NOT NULL,
    salary_payment_id INT NULL,
    adjustment_amount INT NOT NULL,
    adjustment_percentage DECIMAL(10,2) NULL,
    FOREIGN KEY (working_hours_log_id) REFERENCES working_hours_log(id),
    FOREIGN KEY (adjustment_id) REFERENCES adjustment(id),
    FOREIGN KEY (salary_payment_id) REFERENCES salary_payment(id)
);

INSERT INTO country (country_name) VALUES
('India'),
('USA'),
('Germany'),
('Japan'),
('Canada');

INSERT INTO city (city_name, country_id) VALUES
('Chennai', 1),
('Mumbai', 1),
('New York', 2),
('Berlin', 3),
('Tokyo', 4),
('Toronto', 5),
('Los Angeles', 2),
('Frankfurt', 3);

INSERT INTO gender (gender_name) VALUES
('Male'),
('Female'),
('Other');

INSERT INTO department (department_name) VALUES
('IT'),
('HR'),
('Finance'),
('Marketing'),
('Operations');

INSERT INTO job_title (job_title) VALUES
('Software Engineer'),
('HR Executive'),
('Accountant'),
('Marketing Manager'),
('System Administrator'),
('Business Analyst'),
('Project Manager');

INSERT INTO employee (first_name, last_name, date_of_birth, job_title_id, department_id, gender_id, address, city_id, email, employment_start)
VALUES
('Arjun', 'Kumar', '1990-05-12', 1, 1, 1, '123 Anna Nagar', 1, 'arjun.kumar@example.com', '2018-06-01'),
('Priya', 'Sharma', '1992-09-20', 2, 2, 2, '456 Bandra', 2, 'priya.sharma@example.com', '2019-01-15'),
('John', 'Doe', '1985-07-15', 3, 3, 1, '789 5th Ave', 3, 'john.doe@example.com', '2017-03-10'),
('Anna', 'Müller', '1991-11-10', 4, 4, 2, '12 Hauptstrasse', 4, 'anna.mueller@example.com', '2020-07-01'),
('Takashi', 'Sato', '1988-03-18', 5, 1, 1, '34 Shibuya', 5, 'takashi.sato@example.com', '2016-09-05'),
('Sophia', 'Brown', '1993-02-25', 6, 5, 2, '56 Bloor St', 6, 'sophia.brown@example.com', '2021-05-12'),
('Michael', 'Smith', '1987-12-01', 7, 1, 1, '99 Sunset Blvd', 7, 'michael.smith@example.com', '2015-04-20');

INSERT INTO job_title_history (job_title_id, employee_id, start_date, end_date)
VALUES
(1, 1, '2018-06-01', NULL),
(2, 2, '2019-01-15', NULL),
(3, 3, '2017-03-10', NULL),
(4, 4, '2020-07-01', NULL),
(5, 5, '2016-09-05', NULL),
(6, 6, '2021-05-12', NULL),
(7, 7, '2015-04-20', NULL);

INSERT INTO department_history (department_id, employee_id, start_date, end_date)
VALUES
(1, 1, '2018-06-01', NULL),
(2, 2, '2019-01-15', NULL),
(3, 3, '2017-03-10', NULL),
(4, 4, '2020-07-01', NULL),
(1, 5, '2016-09-05', NULL),
(5, 6, '2021-05-12', NULL),
(1, 7, '2015-04-20', NULL);

INSERT INTO employement_terms (employee_id, agreed_salary, salary_start_date, salary_end_date)
VALUES
(1, 60000, '2018-06-01', NULL),
(2, 45000, '2019-01-15', NULL),
(3, 55000, '2017-03-10', NULL),
(4, 70000, '2020-07-01', NULL),
(5, 65000, '2016-09-05', NULL),
(6, 50000, '2021-05-12', NULL),
(7, 80000, '2015-04-20', NULL);

INSERT INTO working_hours_log (employee_id, start_time, end_time)
VALUES
(1, '2023-08-01 09:00', '2023-08-01 17:00'),
(2, '2023-08-01 10:00', '2023-08-01 18:00'),
(3, '2023-08-01 09:30', '2023-08-01 17:30'),
(4, '2023-08-01 08:45', NULL),
(5, '2023-08-01 09:15', '2023-08-01 17:15'),
(6, '2023-08-01 10:00', '2023-08-01 19:00'),
(7, '2023-08-01 08:00', '2023-08-01 16:00');

INSERT INTO salary_payment (employee_id, gross_salary, net_salary, salary_period)
VALUES
(1, '60000', '55000', '2023-07-31'),
(2, '45000', '42000', '2023-07-31'),
(3, '55000', '51000', '2023-07-31'),
(4, '70000', '66000', '2023-07-31'),
(5, '65000', '61000', '2023-07-31'),
(6, '50000', '47000', '2023-07-31'),
(7, '80000', '75000', '2023-07-31');

INSERT INTO adjustment (adjustment_name, adjustment_percentage, is_working_hours_adjustment, is_other_adjustment)
VALUES
('Tax Deduction', 10.00, 0, 1),
('Overtime Bonus', 5.00, 1, 0),
('Health Insurance', 2.50, 0, 1),
('Travel Allowance', 3.00, 0, 1),
('Weekend Work Bonus', 8.00, 1, 0);

INSERT INTO adjustment_amount (salary_payment_id, adjustment_id, adjustment_amount, adjustment_percentage)
VALUES
(1, 1, 6000, 10),
(2, 2, 2250, 5),
(3, 3, 1375, 2.5),
(4, 4, 2100, 3),
(5, 5, 5200, 8);

INSERT INTO working_hours_adjustment (working_hours_log_id, adjustment_id, salary_payment_id, adjustment_amount, adjustment_percentage)
VALUES
(1, 2, 1, 200, 5),
(2, 5, 2, 300, 8),
(3, 2, 3, 150, 5),
(4, 5, 4, 250, 8),
(5, 2, 5, 180, 5);

--List all employees’ first name and last name.
select first_name,last_name from employee;

--Show all departments’ names.
select distinct department_name from department;

--retreive all job titles
select job_title from job_title;

--Display all countries.
select distinct country_name from country;

--Find all cities with their country IDs.
select city_name,country_id from city;

--find all cities based on country id
select c.city_name from city c join country e on c.country_id = e.id;

--Show all genders available in the database.
select gender_name from gender;

--Retrieve all salary payments (gross and net).
select gross_salary,net_salary from salary_payment;

--List all employment terms (employee_id, agreed_salary).
select e.* from employement_terms e;
--Display all records from working_hours_log.
select w.* from working_hours_log w;
select * from working_hours_log
--List all adjustments (adjustment_name and percentage).
select adjustment_name, adjustment_percentage from adjustment;




--filtering from where clause

--Get employees who work in department_id = 2.
select first_name,last_name from employee where department_id=2;

--Find employees born after the year 1990.
select first_name,last_name from employee where date_of_birth > '1990-12-31';
--Show employees whose last name is "Doe".
select e.* from employee e where last_name = 'Doe';
--Get employees who started employment after 2020-01-01.
select e.* from employee e where employment_start > '2020-01-01';
--Show all salary payments greater than 50,000 gross.
select * from salary_payment where gross_salary>'50000';
--Find all working hours logs that started in 2023.
select * from working_hours_log where start_time >'2023';
select * from working_hours_log where year(start_time) ='2023'; --perfect query
--Display all adjustments where percentage > 5.
select * from adjustment where adjustment_percentage > 5;
--List employees living in city_id = 1.
select first_name,last_name from employee where city_id = 1;
--Find departments whose name contains "Finance".
select e.first_name,e.last_name,d.id,d.department_name from department d
join employee e on d.department_name = 'finance';
--Show all male employees (gender_id = 1 for example).
SELECT first_name, last_name, gender_id FROM employee WHERE gender_id = 1;


--c sorting and limiting

--Get the top 5 highest salaries from salary_payment.
select top 5 employee_id , gross_salary,net_salary from salary_payment order by 
gross_salary desc;
--List employees ordered by employment_start (earliest first).
select id,first_name,last_name,employment_start from employee order by 
employment_start asc;
--Show job titles in alphabetical order.
select id,job_title from job_title order by job_title asc;
--Display departments in reverse alphabetical order.
select department_name from department order by department_name desc;
--Find the most recent salary payment.
SELECT TOP 1 employee_id, gross_salary, net_salary, salary_period
FROM salary_payment ORDER BY salary_period DESC;


--Joins( 2 table)
--List employees with their department names.
select e.first_name, e.last_name ,e.department_id , d.department_name from
employee e join department d on e.department_id = d.id;
--Show employees with their job titles.
select e.first_name, e.last_name , t.job_title from
employee e join job_title t on e.job_title_id = t.id;
--Display employees with their gender names.
select e.first_name, e.last_name , g.gender_name from
employee e join gender g on e.gender_id = g.id;
--Show employees with their city and country names.
SELECT e.first_name, e.last_name, c.city_name, co.country_name FROM employee e 
JOIN city c ON e.city_id = c.id JOIN country co ON c.country_id = co.id;
--List salary payments along with employee first and last names
SELECT e.first_name, e.last_name, s.gross_salary, s.net_salary, s.salary_period
FROM salary_payment s JOIN employee e ON s.employee_id = e.id;


---JOIN(3+ TABLE)

--List employees with department name and job title.
select e.first_name,e.last_name,d.department_name,j.job_title from employee e
join department d on e.department_id = d.id join job_title j on 
e.job_title_id = j.id;
--Show salary payments with employee name and department.
select s.id,s.gross_salary,s.net_salary,e.first_name , e.last_name 
,d.department_name from salary_payment s join employee e on 
s.employee_id = e.id join department d on e.department_id = d.id;

--Display employees with their job history (job_title_history).
select e.first_name,e.last_name , j.job_title , jth.start_date , jth.end_date
from employee e join job_title j on e.job_title_id = j.id join 
job_title_history jth on jth.job_title_id = j.id;
--Find employees with department history details.
SELECT e.first_name, e.last_name, d.department_name, dh.start_date, dh.end_date
FROM department_history dh JOIN employee e ON dh.employee_id = e.id
JOIN department d ON dh.department_id = d.id;
--Show adjustments applied to salary payments with employee names.
SELECT e.first_name, e.last_name, sp.salary_period, a.adjustment_name,
p.adjustment_amount,p.adjustment_percentage
FROM adjustment_amount p JOIN salary_payment sp ON p.salary_payment_id = sp.id
JOIN employee e ON sp.employee_id = e.id JOIN adjustment a ON p.adjustment_id = a.id;

--aggregation

--Count total employees.
select count(id) as TotalEmployee from employee e;
--Find the average gross salary.
/***********************************************
*****************************
********************
**********************/
SELECT AVG(CAST(gross_salary AS INT)) AS avg_gross_salary FROM salary_payment;

--Find the highest net salary.
SELECT MAX(CAST(net_salary as INT)) AS highest_NET From salary_Payment;
--Count number of employees per department.
select d.department_name,count(e.id) as empperdepart from department d left join employee e on
e.department_id = d.id group by d.department_name;
--Get total salary payments made in 2023.
select sum(cast(gross_salary as int)) as tot_amount from salary_payment group by salary_period
having year(salary_period) = '2023';
--Find average agreed salary in employment_terms.
select avg(agreed_salary) as avg_agreed from employement_terms;
--Count number of employees in each city.
select c.city_name, count(e.id) as employeecount from city c left join 
employee e on e.city_id = c.id group by city_name;
--Find max and min adjustment percentage.
select max(adjustment_percentage) as maxpercent , min(adjustment_percentage) as
minpercent from adjustment_amount;
--Get average working hours duration (end_time - start_time).
select avg(DATEDIFF(year,start_time,end_time)) as avg_WH from working_hours_log;
--Count job titles assigned in job_title_history.
SELECT COUNT(*) AS total FROM job_title_history;

--subqueries

--Find employees who earn more than the average gross salary.
select e.first_name,e.last_name,sp.gross_salary from employee e join
 salary_payment sp on e.id = sp.employee_id 
 where CAST(sp.gross_salary AS INT) > (select avg(CAST(gross_salary as int))
 from salary_payment);
--Get departments with more than 5 employees.
select d.department_name,count(e.id) from employee e join department d on
d.id = e.department_id group by department_name having count(e.id)> 1;
--Show employees who have received at least one adjustment.
SELECT DISTINCT e.first_name, e.last_name FROM employee e JOIN 
salary_payment sp ON e.id = sp.employee_id JOIN adjustment_amount aa 
ON sp.id = aa.salary_payment_id;
--Find employees who changed departments more than once.
select e.first_name,e.last_name,count(dh.id) as dept_changes from employee e 
join department_history dh on e.id = dh.employee_id group by 
e.first_name , e.last_name having count(dh.id) > 1;
--List employees whose agreed salary in employment_terms is higher than their gross salary in salary_payment.
SELECT e.first_name, e.last_name, et.agreed_salary, sp.gross_salary
FROM employee e JOIN employement_terms et ON  et.employee_id = e.id
JOIN salary_payment sp ON e.id = sp.employee_id 
WHERE CAST(et.agreed_salary AS int) > CAST(sp.gross_salary AS Int);


--to convert not null to null
/*****************
**************
***********/
alter table salary_payment alter column salary_period date null;



--choose 3rd highest gross salary with employee name
select e.first_name, e.last_name , sp.gross_salary from employee e
join salary_payment sp on e.id=sp.employee_id order by gross_salary desc
offset 2 rows fetch next 1 rows only;


--select 2nd highest gross salary
select max(gross_salary) from salary_payment where 
 gross_salary < (select max(gross_salary) from salary_payment);


 select e.first_name, e.last_name,g.id,sp.gross_salary from 
employee e join gender g on g.id = e.gender_id join
salary_payment sp on sp.employee_id = e.id group by gender_id,
e.first_name,e.last_name,sp.gross_salary,g.id order by g.id desc ,gross_salary desc;

--Advanced joinand set operation

--Find employees who do not have any salary payments.
select e.first_name,e.last_name from employee e left join 
salary_payment sp on e.id = sp.employee_id where sp.id is null;
--List employees who don’t have department history records.
select e.first_name,e.last_name from employee e left join department_history dh
on e.department_id = dh.department_id where dh.id is null;
--Show employees who worked in more than one city (if city history existed).
select e.first_name , e.last_name , count(c.id) from employee e left join
city c on e.city_id = c.id where count(c.id)>1;
--Find employees who never had a job title history.
select e.first_name,e.last_name from employee e left join job_title_history jth
on e.job_title_id = jth.id where jth.id is null;
--Get all employees and their salary payments (include employees with no payments). (LEFT JOIN)
SELECT e.id, e.first_name, e.last_name,sp.id AS payment_id, 
sp.gross_salary,sp.net_salary FROM employee e LEFT JOIN salary_payment sp 
ON e.id = sp.employee_id;
--Find departments that don’t have any employees.
SELECT d.id, d.department_name FROM department d LEFT JOIN employee e 
ON d.id = e.department_id WHERE e.id IS NULL;
--Show employees who belong to multiple departments over time.
SELECT e.id, e.first_name, e.last_name, COUNT(DISTINCT dh.department_id) AS dept_count
FROM employee e JOIN department_history dh ON e.id = dh.employee_id GROUP BY
e.id, e.first_name, e.last_name HAVING COUNT(DISTINCT dh.department_id) > 1;
--List employees who have both job title history and department history. (INTERSECT)
SELECT DISTINCT e.id, e.first_name, e.last_name FROM employee e JOIN 
job_title_history jth ON e.id = jth.employee_id INTERSECT SELECT DISTINCT 
e.id, e.first_name, e.last_name FROM employee e JOIN department_history dh
ON e.id = dh.employee_id;
--Find employees who have either salary payments OR working hours logs. (UNION)
SELECT DISTINCT e.id, e.first_name, e.last_name FROM employee e
JOIN salary_payment sp ON e.id = sp.employee_id UNION 
SELECT DISTINCT e.id, e.first_name, e.last_name
FROM employee e JOIN working_hours_log wh ON e.id = wh.employee_id;
--Get employees who have salary payments but no adjustments. (EXCEPT)
select distinct e.first_name,e.last_name from employee e join salary_payment sp on
sp.employee_id = e.id except select distinct e.first_name,e.last_name from
employee e join salary_payment sp on sp.employee_id = e.id join adjustment_amount aa
on sp.id = aa.salary_payment_id;


--window function

--Rank employees by their gross salary (highest first).
select e.id,e.first_name,e.last_name,sp.gross_salary,RANK() OVER 
(ORDER BY CAST(sp.gross_salary AS INT) DESC) as salary_rank from employee e
join salary_payment sp on e.id = sp.employee_id;

--Calculate running total of salary payments per employee.
select e.id,e.first_name,e.last_name,sp.gross_salary,
SUM(CAST(sp.gross_salary as decimal(10,2))) over (partition by e.id order by
sp.gross_salary) as running_total from employee e join salary_payment sp on
e.id = sp.employee_id order by e.id;

--Find the average salary per department, and show each employee’s salary compared to department average.
SELECT e.id,e.first_name,e.last_name,d.department_name,CAST(sp.gross_salary 
AS DECIMAL(10,2)) AS gross_salary,AVG(CAST(sp.gross_salary AS DECIMAL(10,2))) OVER 
(PARTITION BY e.department_id) AS Dept_avg_sal,CAST(sp.gross_salary AS DECIMAL(10,2)) - 
AVG(CAST(sp.gross_salary AS DECIMAL(10,2))) OVER (PARTITION BY e.department_id) AS diff_sal
FROM employee e JOIN salary_payment sp ON sp.employee_id = e.id JOIN department d ON d.id = e.department_id;


--Display salary payments with percentage contribution of each employee in total payroll.
SELECT e.id AS employee_id,e.first_name,e.last_name,d.department_name,CAST(sp.gross_salary 
AS DECIMAL(10,2)) AS gross_salary,SUM(CAST(sp.gross_salary AS DECIMAL(10,2))) 
OVER () AS total_payroll,(CAST(sp.gross_salary AS DECIMAL(10,2)) * 100.0) /SUM(CAST(sp.gross_salary 
AS DECIMAL(10,2))) OVER () AS contribution_percent FROM employee e JOIN salary_payment sp 
ON sp.employee_id = e.id JOIN department d ON d.id = e.department_id;

--Show working hours logs with total hours worked by each employee.
SELECT e.id,e.first_name,e.last_name,whl.start_time,whl.end_time,DATEDIFF(HOUR, whl.start_time, whl.end_time)
AS hours_worked,SUM(DATEDIFF(HOUR, whl.start_time, whl.end_time)) OVER (PARTITION BY e.id) 
AS total_hours_worked FROM employee e JOIN working_hours_log whl ON e.id = whl.employee_id
ORDER BY e.id, whl.start_time;

--Rank employees by number of adjustments applied to them.
select e.id,e.first_name,e.last_name,count(aa.id) as count_adj_amount , rank() over (order by count(aa.id)
desc) as rank_employee_count from employee e join salary_payment sp on sp.employee_id = e.id join
adjustment_amount aa on aa.salary_payment_id = sp.id group by e.id,e.first_name,e.last_name 
order by rank_employee_count;

--For each department, find the employee with the earliest hire date.
SELECT d.department_name,e.id AS employee_id,e.first_name,e.last_name,e.employment_start FROM employee e
JOIN department d ON e.department_id = d.id WHERE e.employment_start = (SELECT MIN(emp.employment_start)
FROM employee emp WHERE emp.department_id = e.department_id);

--Show the difference between gross_salary and previous salary (per employee).
select  e.id as employee_id , e.first_name , e.last_name , sp.gross_salary,
LAG(cast(sp.gross_salary as int)) over (partition by e.id order by sp.gross_salary) as prev_salary,
sp.gross_salary - LAG(cast(sp.gross_salary as int)) over (partition by e.id order by sp.gross_salary) as diff_salary FROM employee e
JOIN salary_payment sp ON e.id = sp.employee_id ORDER BY e.id, sp.gross_salary;

--Find the employee with the longest employment duration using DATEDIFF.


select * from employee;


--common table expression

--Use a CTE to list employees with their department and job title.


WITH EmpDeptJob AS (SELECT e.id AS emp_id,e.first_name,e.last_name,d.department_name,jt.job_title
FROM employee e JOIN department d ON e.department_id = d.id JOIN job_title jt ON 
e.job_title_id = jt.id)
SELECT * FROM EmpDeptJob;

--CTE: Employees who worked more than 200 hours in total
WITH EmPWorkHours AS(select e.id AS emp_id,concat(e.first_name,' ',e.last_name) 
as full_name,sum(DATEDIFF(HOUR,w.start_time,w.end_time)) as total_hours from employee e join 
working_hours_log w on e.id = w.employee_id group by e.id,e.first_name,e.last_name)
Select * from empworkhours where total_hours > 200;

--Organizational Hierarchy (Manager ? Employee)
--assume employee table has manager id column    




















--views
--Create a view for employees with their current department and job title.
create view vw as select e.id as emp_id,e.first_name,e.last_name,d.department_name,
jt.job_title from employee e join department d on e.department_id = d.id join
job_title jt on e.job_title_id = jt.id;

select * from vw;

--salary payments with adjustments included
create view  vw_SalaryWithAdjustments AS Select sp.id AS payment_id,
e.first_name,e.last_name,sp.gross_salary, ISNULL(SUM(sa.adjustment_amount),0)
as total_adjustments,sp.gross_salary + ISNULL(SUM(sa.adjustment_Amount),0) AS
net_salary from salary_payment sp join employee e on sp.employee_id = e.id left
join working_hours_adjustment sa on sp.id = sa.salary_payment_id group by sp.id ,
e.first_name,e.last_name,sp.gross_salary;

select * from vw_SalaryWithAdjustments;

--department wise employee count
create view vw_DepartmentEmployeeCount AS sELECT d.id AS dept_id, d.department_name,
COUNT(e.id) as employee_count from department d left join employee e on 
d.id = e.department_id group by d.id,d.department_name;

select * from vw_DepartmentEmployeeCount;

--Working Hours Reporting (Employee Name, Total Hours)
create view vw_workinghours AS Select e.id as emp_id,e.first_name,e.last_name,
sum(datediff(HOUR,w.start_time,w.end_time)) AS Total_hours from employee e
join working_hours_log w on e.id = w.employee_id group by e.id,e.first_name,
e.last_name;

select * from vw_workinghours;

--payroll summary

CREATE VIEW vw_PayrollSummary AS SELECT e.id AS emp_id,e.first_name,
e.last_name,sp.gross_salary,ISNULL(SUM(sa.adjustment_amount), 0)
AS total_adjustments,sp.gross_salary + ISNULL(SUM(sa.adjustment_amount), 0) 
AS net_salary FROM employee e JOIN salary_payment sp ON e.id = sp.employee_id
LEFT JOIN adjustment_amount sa ON sp.id = sa.salary_payment_id
GROUP BY e.id, e.first_name, e.last_name, sp.gross_salary;

select * from vw_payrollSummary;


--Trigger
--prevent delating employee if salary payment exist

create trigger trg_preventEmployeeDelete on employee Instead of delete
AS
BEGIN
	IF EXISTS(select 1 from deleted d join salary_payment sp on d.id = sp.employee_id)
	BEGIN
		RAISERROR('cannot delete employee with salary payments.',16,1);
		ROLLBACK transaction;
	END

	ELSE
	BEGIN
		Delete from employee where id IN (select id from deleted);
	END
END;

select * from trg_preventEmployeeDelete;