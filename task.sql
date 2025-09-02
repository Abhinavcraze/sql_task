--1.Get the full name, job title, department name, and city for all employees.

SELECT CONCAT(e.first_name, ' ', e.last_name) AS FULLNAME, j.job_title,d.department_name,
c.city_name from employee e left join job_title j on e.job_title_id = j.id join
city c on c.id = e.city_id join department d on d.id = e.department_id;
 
--2.Find departments with more than 2 employees, sorted by employee count.

SELECT department_name, COUNT(e.id) AS employeecount from employee e inner join
department d on d.id = e.department_id group by department_name having count(e.id)>2;
 
--3.Show the agreed salary progression of each employee over time using EMPLOYMENT_TERMS.

SELECT e.first_name AS employeename, et.salary_start_date, et.salary_end_date, et.agreed_salary
FROM employee e inner join employement_terms et on et.employee_id = e.id
order by e.id,et.salary_start_date;
 
--4.List how many employees are active vs deleted (use IsActive, IsDeleted).

select * into customer from employee;
ALTER TABLE customer ADD ISACTIVE BIT not null default  1;
ALTER TABLE customer ADD ISDELETED BIT not null default  0;
update customer set ISACTIVE =0,ISDELETED = 1 where employment_start<'2021-02-01';
SELECT IsActive, IsDeleted, COUNT(*) AS EMPLOYEECOUNT FROM customer GROUP BY IsActive, IsDeleted;
select * from customer;
 
--5.Find which job titles have never been assigned to any employee.

SELECT j.job_title from employee e inner join job_title j on e.job_title_id = j.id 
where j.id is null;
 
--6.For each department, find the employee who received the highest NET salary in SALARY_PAYMENT.

SELECT e.first_name,d.department_name,sp.net_salary from employee e inner join department d on
d.id = e.department_id join salary_payment sp on sp.employee_id = e.id where sp.net_salary =
(select max(net_salary) from salary_payment sp where sp.net_salary >
(SELECT MAX(NET_SALARY)FROM salary_payment sp))
 
--7.Using DEPARTMENT_HISTORY, list employees who have worked in more than 2 departments.

SELECT e.id, CONCAT(e.first_name, ' ', e.last_name) AS employeename, 
COUNT(distinct dh.department_id) AS TOTALDEPARTMENT FROM employee e inner join department_history dh
on dh.department_id = e.department_id group by e.id,e.first_name,e.last_name having count
(distinct dh.department_id) > 2;

 
--8.Show the breakdown of an employee’s gross salary, all adjustments (BONUS, OVERTIME, TAX DEDUCTION, etc.), and final net salary.

select concat(e.first_name,' ',e.last_name) as employeename , d.department_name ,sp.gross_salary,
a.adjustment_name,aa.adjustment_amount,sp.net_salary from employee e left join department d on
e.department_id = d.id left join salary_payment sp on e.id = sp.employee_id 
left join adjustment_amount aa on aa.salary_payment_id = sp.id left join adjustment a
on aa.adjustment_id = a.id; 
 
--9.Calculate the average number of years employees stay in a department (using DEPARTMENT_HISTORY start and end dates).

SELECT d.DEPARTMENT_ID, AVG(DATEDIFF(YEAR, start_date, end_date)) AS AVG_YEARS FROM 
department_history d join employee e on d.department_id = e.department_id join
salary_payment sp on sp.employee_id = e.id group by d.department_id;
 
--10.Detect potential duplicate data — for example, GENDER has multiple rows with “MALE”. 
--Write a query to identify such duplicates.

SELECT COUNT(g.id) AS gendercount, g.gender_name from gender g group by gender_name;
 
--11.For each year, find the employee with the highest net salary (SALARY_PAYMENT).

SELECT SP.EMPLOYEE_ID, SP.SALARY_PERIOD AS YEARS, NET_SALARY AS MAXSALARY
FROM SALARY_PAYMENT SP WHERE SP.NET_SALARY = (SELECT MAX(NET_SALARY)FROM
SALARY_PAYMENT SP WHERE SALARY_PERIOD = SP.SALARY_PERIOD);
 
--12.Compute the running total salary paid to each employee across all periods.

select e.id,e.first_name,e.last_name,sp.gross_salary,sp.salary_period,
SUM(CAST(sp.gross_salary as decimal(10,2))) over (partition by e.id order by
sp.gross_salary) as running_total from employee e join salary_payment sp on
e.id = sp.employee_id order by e.id,sp.salary_period;
 
--13.Find cases where GROSS_SALARY - Adjustments ≠ NET_SALARY (data integrity check).

SELECT SP.EMPLOYEE_ID, SP.GROSS_SALARY, aa.adjustment_amount, SP.NET_SALARY

FROM SALARY_PAYMENT SP join adjustment_amount aa on aa.salary_payment_id = sp.id 
WHERE (sp.GROSS_SALARY - aa.adjustment_amount) <> sp.net_salary;
 
--14.Find the employee with the longest working hours using WORKING_HOURS_LOG.

SELECT TOP 1 w.employee_id, SUM(DATEDIFF(HOUR, start_time, end_time)) AS total_hours
FROM WORKING_HOURS_LOG w GROUP BY w.employee_id;
 
--15.Show who (CreatedBy, ModifiedBy) created/modified records the most across all tables.

--select * into customer from employee;
ALTER TABLE customer ADD createdby VARCHAR(255);
ALTER TABLE customer ADD ModifiedBy VARCHAR(255);
update customer set ModifiedBy='Customers';
update customer set createdBy = 'admin' where employment_start<'2021-02-01';
update customer set createdBy = 'user' where employment_start>='2021-02-01';

SELECT CreatedBy AS UserName, COUNT(*) AS CreatedCount, ModifiedBy AS UserName, 
COUNT(*) AS ModifiedCount FROM customer GROUP BY CreatedBy, ModifiedBy;
 
--16.List each country with the number of employees working there.

SELECT co.country_name, COUNT(e.id) AS EMPLOYEECOUNT FROM employee e INNER JOIN
city c ON e.city_id = c.id INNER JOIN country co ON co.id = C.COUNTRY_ID
GROUP BY co.COUNTRY_NAME;
 
--17.Find the youngest and oldest employees (using DATE_OF_BIRTH).

SELECT TOP 1 e.id, concat(e.first_name,' ',e.last_name) as full_name, et.salary_start_date AS old
FROM employee e join employement_terms et on et.employee_id = e.id order by salary_start_date asc; 
 
SELECT TOP 1 e.id, concat(e.first_name,' ',e.last_name) as full_name, et.salary_start_date AS young
FROM employee e join employement_terms et on et.employee_id = e.id order by salary_start_date desc;
 
--18.For each employee, show how many times their job title has changed (use JOB_TITLE_HISTORY).

SELECT e.id, COUNT(jt.id) AS JOB_TITLE_CHANGED FROM employee e 
join job_title jt on e.job_title_id = jt.id  GROUP BY e.id;
 
--19.Find departments that currently have no employees assigned.

SELECT d.id, D.DEPARTMENT_NAME FROM department d LEFT JOIN 
employee e ON D.id = E.DEPARTMENT_ID WHERE e.id IS NULL;
 
--20.Find cities that don’t have any employees living in them.

SELECT c.city_name from city c where city_name is null;
 
--21.Compare each employee’s gross salary vs agreed salary (from SALARY_PAYMENT vs EMPLOYMENT_TERMS) and find mismatches.

SELECT e.id, e.first_name, sp.gross_salary ,et.agreed_salary  FROM SALARY_PAYMENT SP
INNER JOIN EMPLOYEMENT_TERMS ET ON SP.EMPLOYEE_ID = ET.EMPLOYEE_ID INNER JOIN 
EMPLOYEE E ON ET.EMPLOYEE_ID = e.id WHERE GROSS_SALARY <> AGREED_SALARY
 
--22.Calculate what percentage of an employee’s net salary came from adjustments.

SELECT e.id, e.first_name, sp.net_salary, ISNULL(a.ADJUSTMENT_AMOUNT,0) AS ADJUSTMENT_AMOUNT,
(CAST(ISNULL(a.ADJUSTMENT_AMOUNT,0) AS FLOAT) / sp.NET_SALARY) * 100 AS ADJUSTMENT_PERCENTAGE
FROM SALARY_PAYMENT SP INNER JOIN EMPLOYEE E ON e.id = SP.EMPLOYEE_ID 
LEFT JOIN ADJUSTMENT_AMOUNT A ON A.ADJUSTMENT_ID = SP.EMPLOYEE_ID

WHERE SP.NET_SALARY > 0;
 

 
--23.Show the sequence of departments an employee has worked in (ordered by START_DATE). (not understand)

SELECT e.id AS employee_id,e.first_name,STRING_AGG(d.department_name, ' → ') WITHIN 
GROUP (ORDER BY ed.start_date) AS department_sequence FROM employee e JOIN employee_department 
ed ON e.id = ed.employee_id JOIN department d ON ed.department_id = d.id GROUP BY 
e.id, e.first_name ORDER BY e.id;
 
--25.Find employees whose net salary is greater than 120% or less than 80% of their department’s average.

SELECT e.id,e.first_name,sp.net_salary, avg(cast(sp.gross_salary as int)) as avg_gross_sal from 
salary_payment sp full join employee e on e.id = sp.employee_id group by e.id,e.first_name,
sp.net_salary having sp.net_salary > 1.2 * avg(cast(sp.gross_salary as int)) 
and sp.net_salary < 0.8 * avg(cast(sp.gross_salary as int)); 

 
--26.For each employee, calculate the percentage increase in their agreed salary from first to last EMPLOYMENT_TERMS.

SELECT et.employee_id, ((MAX(et.AGREED_SALARY) - MIN(et.AGREED_SALARY)) * 100.0 /
MIN(et.AGREED_SALARY)) AS PercentageIncrease
FROM EMPLOYEMENT_TERMS et GROUP BY et.employee_id;
 
--27.Detect employees who have overlapping working hours in WORKING_HOURS_LOG (bad data).

SELECT w.employee_id, w.start_time AS Shift1_Start, w.end_time AS Shift1_End, 
w1.START_TIME AS Shift2_Start, w1.END_TIME AS Shift2_End FROM WORKING_HOURS_LOG w
JOIN WORKING_HOURS_LOG w1 ON w.EMPLOYEE_ID = w1.EMPLOYEE_ID AND w.START_TIME < w1.END_TIME 
AND w.END_TIME > w1.START_TIME AND w.START_TIME < w1.START_TIME ;

ORDER BY A.EMPLOYEE_ID, A.START_TIME;
 
--28.Across all years, find the top 3 employees who have earned the most (sum of NET_SALARY).

SELECT TOP 3 e.id, SUM(cast(sp.net_salary as int)) AS TOTAL_EARNED from salary_payment sp 
join employee e on sp.employee_id = e.id group by e.id order by Total_earned desc;														

 