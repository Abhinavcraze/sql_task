

use payrolldemo1;



--1.Employee
create procedure ad_employee
	@first_name VARCHAR(255),
	@last_name VARCHAR(255),
	@date_of_birth DATE,
	@job_title_id INT, 
	@department_id INT,
	@gender_id INT,
	@city_id INT,
	@address VARCHAR(255), @email VARCHAR(255),
	@employment_start DATE
AS
BEGIN
	INSERT INTO employee (first_name,last_name,date_of_birth,job_title_id,department_id,
	gender_id,city_id,address,email,employment_start) VALUES (@first_name,@last_name,
	@date_of_birth,@job_title_id,@department_id,@gender_id,@city_id,@address,
	@email,@employment_start);
END;
GO

--2.Department
create procedure add_department
	@department_name VARCHAR(255)
AS
BEGIN
	INSERT INTO department(department_name) values (@department_name);
END;
Go

--3.Department_history
create procedure add_department_history
	@department_ID int,
	@employee_id int,
	@start_date DATE,
	@end_date DATE = null
AS
BEGIN
	Insert into department_history (department_id,employee_id,start_date,end_date)
	VALUES (@department_id,@employee_id,@start_date,@end_date);
END;
GO

create procedure add_job_title
	@job_title VARCHAR(255)
AS
BEGIN
	INSERT INTO job_title(job_title) values (@job_title);
END;
GO

-- 5. Job Title History
CREATE PROCEDURE add_job_title_history
    @job_title_id INT,
    @employee_id INT,
    @start_date DATE,
    @end_date DATE = NULL
AS
BEGIN
    INSERT INTO job_title_history (job_title_id, employee_id, start_date, end_date)
    VALUES (@job_title_id, @employee_id, @start_date, @end_date);
END;
GO


-- 6. Gender
CREATE PROCEDURE add_gender
    @gender_name VARCHAR(64)
AS
BEGIN
    INSERT INTO gender (gender_name)
    VALUES (@gender_name);
END;
GO


-- 7. City
CREATE PROCEDURE add_city
    @city_name VARCHAR(255),
    @country_id INT
AS
BEGIN
    INSERT INTO city (city_name, country_id)
    VALUES (@city_name, @country_id);
END;
GO


-- 8. Country
CREATE PROCEDURE add_country
    @country_name VARCHAR(255)
AS
BEGIN
    INSERT INTO country (country_name)
    VALUES (@country_name);
END;
GO


-- 9. Employment Terms
CREATE PROCEDURE add_employment_terms
    @employee_id INT,
    @agreed_salary DECIMAL(10,2),
    @salary_start_date DATE,
    @salary_end_date DATE = NULL
AS
BEGIN
    INSERT INTO employment_terms (employee_id, agreed_salary, salary_start_date, salary_end_date)
    VALUES (@employee_id, @agreed_salary, @salary_start_date, @salary_end_date);
END;
GO


-- 10. Working Hours Log
CREATE PROCEDURE add_working_hours_log
    @employee_id INT,
    @start_time DATETIME,
    @end_time DATETIME = NULL
AS
BEGIN
    INSERT INTO working_hours_log (employee_id, start_time, end_time)
    VALUES (@employee_id, @start_time, @end_time);
END;
GO


-- 11. Working Hours Adjustment
CREATE PROCEDURE add_working_hours_adjustment
    @working_hours_log_id INT,
    @adjustment_id INT,
    @salary_payment_id INT,
    @adjustment_amount DECIMAL(10,2),
    @adjustment_percentage DECIMAL(10,2)
AS
BEGIN
    INSERT INTO working_hours_adjustment (working_hours_log_id, adjustment_id, salary_payment_id, adjustment_amount, adjustment_percentage)
    VALUES (@working_hours_log_id, @adjustment_id, @salary_payment_id, @adjustment_amount, @adjustment_percentage);
END;
GO


-- 12. Salary Payment
CREATE PROCEDURE add_salary_payment
    @employee_id INT,
    @gross_salary DECIMAL(10,2),
    @net_salary DECIMAL(10,2),
    @salary_period DATE
AS
BEGIN
    INSERT INTO salary_payment (employee_id, gross_salary, net_salary, salary_period)
    VALUES (@employee_id, @gross_salary, @net_salary, @salary_period);
END;
GO


-- 13. Adjustment
CREATE PROCEDURE add_adjustment
    @adjustment_name VARCHAR(255),
    @adjustment_percentage DECIMAL(10,2),
    @is_working_hours_adjustment BIT,
    @is_other_adjustment BIT
AS
BEGIN
    INSERT INTO adjustment (adjustment_name, adjustment_percentage, is_working_hours_adjustment, is_other_adjustment)
    VALUES (@adjustment_name, @adjustment_percentage, @is_working_hours_adjustment, @is_other_adjustment);
END;
GO


-- 14. Adjustment Amount
CREATE PROCEDURE add_adjustment_amount
    @salary_payment_id INT,
    @adjustment_id INT,
    @adjustment_amount DECIMAL(10,2),
    @adjustment_percentage DECIMAL(10,2)
AS
BEGIN
    INSERT INTO adjustment_amount (salary_payment_id, adjustment_id, adjustment_amount, adjustment_percentage)
    VALUES (@salary_payment_id, @adjustment_id, @adjustment_amount, @adjustment_percentage);
END;
GO


--create
CREATE PROCEDURE get_all_employees
AS
BEGIN
    SELECT e.id, e.first_name, e.last_name, e.date_of_birth,
           jt.job_title, d.department_name, g.gender_name,
           c.city_name, e.address, e.email, e.employment_start
    FROM employee e
    LEFT JOIN job_title jt ON e.job_title_id = jt.id
    LEFT JOIN department d ON e.department_id = d.id
    LEFT JOIN gender g ON e.gender_id = g.id
    LEFT JOIN city c ON e.city_id = c.id;
END;
GO

--read all employee
CREATE PROCEDURE get_all_employees
AS
BEGIN
    SELECT e.id, e.first_name, e.last_name, e.date_of_birth,
           jt.job_title, d.department_name, g.gender_name,
           c.city_name, e.address, e.email, e.employment_start
    FROM employee e
    LEFT JOIN job_title jt ON e.job_title_id = jt.id
    LEFT JOIN department d ON e.department_id = d.id
    LEFT JOIN gender g ON e.gender_id = g.id
    LEFT JOIN city c ON e.city_id = c.id;
END;
GO

--read 1 employee by id
CREATE PROCEDURE get_employee_by_id
    @employee_id INT
AS
BEGIN
    SELECT e.id, e.first_name, e.last_name, e.date_of_birth,
           jt.job_title, d.department_name, g.gender_name,
           c.city_name, e.address, e.email, e.employment_start
    FROM employee e
    LEFT JOIN job_title jt ON e.job_title_id = jt.id
    LEFT JOIN department d ON e.department_id = d.id
    LEFT JOIN gender g ON e.gender_id = g.id
    LEFT JOIN city c ON e.city_id = c.id
    WHERE e.id = @employee_id;
END;
GO

--Update
CREATE PROCEDURE update_employee
    @employee_id INT,
    @first_name VARCHAR(255),
    @last_name VARCHAR(255),
    @date_of_birth DATE,
    @job_title_id INT,
    @department_id INT,
    @gender_id INT,
    @city_id INT,
    @address VARCHAR(255),
    @email VARCHAR(255),
    @employment_start DATE
AS
BEGIN
    UPDATE employee
    SET first_name = @first_name,
        last_name = @last_name,
        date_of_birth = @date_of_birth,
        job_title_id = @job_title_id,
        department_id = @department_id,
        gender_id = @gender_id,
        city_id = @city_id,
        address = @address,
        email = @email,
        employment_start = @employment_start
    WHERE id = @employee_id;
END;
GO

--Delete
CREATE PROCEDURE delete_employee
    @employee_id INT
AS
BEGIN
    DELETE FROM employee
    WHERE id = @employee_id;
END;
GO
-----------------------------------------------------------------

CREATE PROCEDURE search_employee_by_name
    @name VARCHAR(255)
AS
BEGIN
    SELECT e.id, e.first_name, e.last_name, e.email, d.department_name
    FROM employee e
    LEFT JOIN department d ON e.department_id = d.id
    WHERE e.first_name LIKE '%' + @name + '%'
       OR e.last_name LIKE '%' + @name + '%';
END;
GO

EXEC search_employee_by_name @name = 'John';

--------------------------------------------------------------------
CREATE PROCEDURE get_employees_by_department
    @department_id INT
AS
BEGIN
    SELECT e.id, e.first_name, e.last_name, e.email, d.department_name
    FROM employee e
    INNER JOIN department d ON e.department_id = d.id
    WHERE e.department_id = @department_id;
END;
GO

EXEC get_employees_by_department @department_id = 2;

-------------------------------------------------------------------------

CREATE PROCEDURE get_employees_hired_after
    @hire_date DATE
AS
BEGIN
    SELECT id, first_name, last_name, email, employment_start
    FROM employee
    WHERE employment_start > @hire_date;
END;
GO

EXEC get_employees_hired_after @hire_date ='01-01-2020';

---------------------------------------------------------------------------
--Calculate Net Salary (Gross – Adjustments)

create procedure sp_CalculateNetSalary 
	@employee_id INT
AS
BEGIN
	SELECT 
		e.first_name,e.last_name,sp.gross_salary,ISNULL(SUM(sa.adjustment_amount),0)
		AS total_adjustments,sp.gross_salary - ISNULL(SUM(sa.adjustment_amount),0)
		AS net_salary from employee e join salary_payment sp on sp.employee_id =
		e.id join adjustment_amount sa on sa.salary_payment_id = sp.id 
		where employee_id = @employee_id group by e.first_name,
		e.last_name,sp.gross_salary;
END;
GO

Exec sp_CalculateNetSalary @employee_id = 2;
                                                                                                   ---create a new table called as 'customer'    (******************)
----------------------------------------------------------------------------
--List All employees in a department

CREATE procedure sp_GetEmployeesByDepartment
    @department_id INT
AS
BEGIN
    SELECT c.id, c.first_name, c.last_name, d.department_name, jt.job_title AS job_title
    FROM customer c JOIN department d ON c.department_id = d.id JOIN job_title jt 
	ON c.job_title_id = jt.id WHERE c.department_id = @department_id AND c.isactive = 1;
END;
GO

Exec sp_GetEmployeesByDepartment @department_id = 3;


-----------------------------------------------------------------------------
--get employee job history

CREATE PROCEDURE sp_GetEmployeeJobHistory
    @employee_id INT
AS
BEGIN
    SELECT 
        jth.start_date,
        jth.end_date,
        jt.job_title AS job_title
    FROM job_title_history jth
    JOIN job_title jt ON jth.job_title_id = jt.id
    WHERE jth.employee_id = @employee_id
    ORDER BY jth.start_date;
END;
GO

Exec sp_GetEmployeeJobHistory @employee_id = 3;