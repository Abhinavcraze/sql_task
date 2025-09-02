create database basics;

create table Employees(EmployeeID INT PRIMARY KEY,
   Name VARCHAR(100),
   DepartmentID INT,
   Salary DECIMAL(10,2),
   HireDate DATE)

create table Departments(DepartmentID INT PRIMARY KEY,
   DepartmentName VARCHAR(100))

create table Projects(
    ProjectID INT PRIMARY KEY,
    ProjectName VARCHAR(100),
    DepartmentID INT
)

create table EmployeeProjects(
    EmployeeID INT,
    ProjectID INT,
    HoursWorked INT,
    PRIMARY KEY (EmployeeID, ProjectID)
)

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (1, 'SQL Development'),
       (2, 'Frontend Development'),
       (3, 'Data Science'),
       (4, 'HR');

	   INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (5, 'MangoDB');

INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary, HireDate)
VALUES (1, 'Abhinav', 1, 60000, '2021-01-15'),
       (2, 'Naveen', 2, 75000, '2020-07-10'),
       (3, 'Saran', 3, 90000, '2022-03-20'),
       (4, 'Kavya', 1, 50000, '2019-11-05'),
       (5, 'Priya', 4, 45000, '2023-04-01');
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary, HireDate)
VALUES (7, 'kumar', 6, 60000, '2021-01-15');
INSERT INTO Employees (EmployeeID, Name, DepartmentID, Salary, HireDate)
VALUES (8, 'dhanya', 8, 60000, '2021-01-15');


INSERT INTO Projects (ProjectID, ProjectName, DepartmentID)
VALUES (101, 'Employee Management System', 1),
       (102, 'E-Commerce Website', 2),
       (103, 'Machine Learning Model', 3),
       (104, 'HR Onboarding System', 4),
       (105, 'Data Visualization Dashboard', 3);
	   INSERT INTO Projects (ProjectID, ProjectName, DepartmentID)
VALUES (106, 'Data analytics', 6);

INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
VALUES (1, 101, 120),   -- Abhinav works on Employee Management System
       (2, 102, 200),   -- Naveen on E-Commerce Website
       (3, 103, 180),   -- Saran on ML Model
       (4, 101, 90),    -- Kavya on Employee Management System
       (5, 104, 100),   -- Priya on HR Onboarding
       (3, 105, 150),   -- Saran also on Data Visualization
       (2, 105, 60);    -- Naveen also on Data Visualization
	   INSERT INTO EmployeeProjects (EmployeeID, ProjectID, HoursWorked)
VALUES (7, 106, 120);



	   -- Join and Aggregation
--total salary expense per department
SELECT d.departmentName , SUM(e.salary) AS TotalSalary FROM Employees e
    JOIN Departments d ON e.departmentID = d.departmentId GROUP BY d.departmentName;

--Department with maximum number of Employees
SELECT TOP 1 d.DepartmentName, Count(e.EmployeeId) AS NumEmployee FROM Employees e JOIN Departments d
ON e.DepartmentId = d.departmentId GROUP BY DEPARTMENTNAME Order By Count(e.EmployeeId) Desc;

--All Employee with the project they are working on
SELECT e.name , p.projectName From Employees e JOIN EmployeeProjects ep ON 
e.EmployeeID = ep.EmployeeId Join Projects p on ep.projectId = p.projectId;

--Employees not assigned to any project
SELECT e.EmployeeID, e.Name
FROM Employees e
LEFT JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
WHERE ep.ProjectID IS NULL;

--Employees working on projects outside their own department
SELECT DISTINCT e.name,p.projectName FROM Employees e Join EmployeeProjects ep ON
e.EmployeeId = ep.EmployeeId Join Projects p ON ep.projectID = p.projectID
where e.departmentId <> p.DepartmentId;




--Grouping & Conditions

--Departments with average salary > 60,000(Using Having)
SELECT d.DepartmentName , AVG(e.Salary) AS AvgSalary From 
Employees e JOIN Departments d ON e.DepartmentID = d.departmentID
GROUP BY d.departmentName HAVING AVG(e.salary) > 45000;

--Employees earning more than dept avg salary
SELECT e.EmployeeID, e.name , e.Salary , e.DepartmentId
From Employees e where e.Salary > (SELECT AVG(salary)
From Employees where DepartmentID = e.departmentId);

--Employees worked > 100 total hours
SELECT ep.EmployeeId , SUM(ep.HoursWorked) AS TOTALHOURS From 
EmployeeProjects ep Group By ep.EmployeeId Having SUM(ep.HoursWorked)>100;

--Projects with more than 1 employees
SELECT p.projectName, COUNT(ep.EmployeeID) as NumEmployees From 
Projects p JOIN EmployeeProjects ep ON p.ProjectId = ep.projectId
Group By p.ProjectName Having COUNT(ep.EmployeeID) > 1;

--Highest-paid employee in each department
Select e.* FROM Employees e where e.salary =(SELECT 
MAX(Salary) From employees where DepartmentID = e.DepartmentId);


--subqueries
--Employees with salary > company avg
SELECT * FROM Employees
WHERE Salary > (SELECT AVG(Salary) FROM Employees);

--Employees hired before oldest in Dept 4
SELECT * FROM Employees WHERE HireDate < (
    SELECT MIN(HireDate) FROM Employees WHERE DepartmentID = 4
);

--Employees working on all projects in their dept
SELECT e.EmployeeID, e.Name
FROM Employees e
WHERE NOT EXISTS (
    SELECT p.ProjectID
    FROM Projects p
    WHERE p.DepartmentID = e.DepartmentID
    EXCEPT                     --not understood
    SELECT ep.ProjectID
    FROM EmployeeProjects ep
    WHERE ep.EmployeeID = e.EmployeeID
);

SELECT DISTINCT e.name,e.employeeId FROM Employees e Join EmployeeProjects ep ON
e.EmployeeId = ep.EmployeeId Join Projects p ON ep.projectID = p.projectID
where e.departmentId = p.DepartmentId;

---or

SELECT e.EmployeeID, e.Name
FROM Employees e
JOIN EmployeeProjects ep ON e.EmployeeID = ep.EmployeeID
JOIN Projects p ON ep.ProjectID = p.ProjectID
WHERE p.DepartmentID = e.DepartmentID
GROUP BY e.EmployeeID, e.Name, e.DepartmentID    --not understood
HAVING COUNT(DISTINCT ep.ProjectID) = (
    SELECT COUNT(DISTINCT p2.ProjectID)
    FROM Projects p2
    WHERE p2.DepartmentID = e.DepartmentID
);

--Employees with 2nd highest salary
SELECT * FROM Employees WHERE Salary = (
    SELECT MAX(Salary)
    FROM Employees
    WHERE Salary < (SELECT MAX(Salary) FROM Employees)
);



--Window Function(Intermediate Level)
--partition function used in window function like SUM(),
--AVG(),COUNT(),ROW_NUMBER(),RANK(),LEAD(),LAG()

--Employees with top 3 salaries in dept
--NOT UNDERSTOOD



--Rank employees in each dept by salary
SELECT e.EmployeeID, e.Name, e.DepartmentID, e.Salary,
       RANK() OVER (PARTITION BY DepartmentID ORDER BY Salary DESC) AS SalaryRank
FROM Employees e;

--Salary with difference from dept avg
SELECT e.EmployeeID, e.Name, e.Salary,
       e.Salary - AVG(e.Salary) OVER (PARTITION BY e.DepartmentID) AS DiffFromDeptAvg
FROM Employees e;

--Running total of salaries by hire date
SELECT e.EmployeeID, e.Name, e.HireDate, e.Salary,
       SUM(e.Salary) OVER (ORDER BY HireDate ROWS UNBOUNDED PRECEDING) AS RunningTotal
FROM Employees e;    

--Previous employee’s salary (LAG)
SELECT e.EmployeeID, e.Name, e.Salary,
       LAG(e.Salary) OVER (ORDER BY HireDate) AS PreviousSalary
FROM Employees e;

--% of hours contributed by each employee per project
SELECT ep.ProjectID, ep.EmployeeID, ep.HoursWorked,
       (ep.HoursWorked * 100.0 / SUM(ep.HoursWorked) OVER (PARTITION BY ep.ProjectID)) AS PctContribution
FROM EmployeeProjects ep;



--Date and String Functions

--Employees working > 5 years
SELECT * FROM Employees
WHERE DATEDIFF(YEAR, HireDate, GETDATE()) > 5;
--(MySQL: TIMESTAMPDIFF(YEAR, HireDate, CURDATE()) > 5)

--Year & month hired
SELECT Name, YEAR(HireDate) AS HireYear, MONTH(HireDate) AS HireMonth
FROM Employees;

--Name ends with 'n' & length = 6
SELECT * FROM Employees WHERE Name LIKE '_____n'; 

--Employees hired same year as kumar
SELECT *
FROM Employees
WHERE YEAR(HireDate) = (
    SELECT YEAR(HireDate) FROM Employees WHERE Name = 'kumar'
);

--Employees hired on weekend
SELECT *
FROM Employees
WHERE DATENAME(WEEKDAY, HireDate) IN ('Saturday','Sunday');


--summa try
Select count(*) as FDDF from (SELECT e.name,d.departmentName from employees e
   left join departments d on e.departmentId = d.departmentId group by e.name,d.departmentname) AS sub;













