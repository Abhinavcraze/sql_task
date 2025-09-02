create database basic;

create table Employees(EmployeeID INT PRIMARY KEY,
   Name VARCHAR(100),
   DepartmentID INT,
   Salary DECIMAL(10,2),
   HireDate DATE)

create table Departments(DepartmentID INT PRIMARY KEY,
   DepartmentName VARCHAR(100))

INSERT INTO Employees(EmployeeID, Name, DepartmentID, Salary, HireDate)
VALUES (1, 'Abhinav', 1, 10000, '2025-08-20'),
       (2, 'Naveen', 2, 20000, '2024-08-20'),
       (3, 'Saran', 3, 250000, '2023-06-20');
INSERT INTO Departments(DepartmentID, DepartmentName)
VALUES (1, 'SQL'),
       (2, 'JavaScript'),
       (3, 'React');
	   update employees set salary = null where employeeid=3;
	   update employees set salary =25000 where employeeid=3;
select * from Employees;
select name,salary from employees;
select * from employees where salary>15000;
select * from employees where hireDate > '2024-01-01';
select * from employees where departmentID = 2;
select * from employees order by Salary DESC;
select * from employees order by HireDate ASC;
select Name as Employee_name,salary from employees;
select count(*) AS TotalEmployee from Employees;
select AVG(salary) as AverageEmployee from Employees;
SELECT MIN(Salary) AS MinSalary,
       MAX(Salary) AS MaxSalary FROM Employees;
SELECT DepartmentID, count(*) AS EmployeeCount from employees GROUP BY DepartmentID;
SELECT e.name,d.departmentName From Employees e Join Departments d on e.DepartmentId = d.departmentId;
select d.DepartmentName , e.Name from departments d LEFT JOIN Employees e ON d.DepartmentId = e.departmentId;
SELECT * FROM EMPLOYEES Where Name LIKE 'A%';
SELECT * FROM Employees where name like '%ra%';
SELECT * FROM EMPLOYEES Where Name like '_____';
SELECT * FROM Employees WHERE Salary BETWEEN 15000 AND 20000;
SELECT * FROM Employees WHERE DepartmentID IN (1, 3);

update employees set salary = null where employeeid=3;
	   update employees set salary =25000 where employeeid=3;

SELECT * FROM Employees WHERE Salary IS NOT NULL;
select * from departments;