CREATE DATABASE PayRollDemo;
Use payRollDemo;
                                             --schema
--Employees
--create lookup or independent table 
--(one to many)
-- Country table
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

--core Employee table
CREATE TABLE employee (
    id INT IDENTITY(1,1) PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    job_title_id INT NOT NULL,
    department_id INT NOT NULL,
    city_id INT NOT NULL,
    gender_id INT NULL,
    address VARCHAR(255),
    email VARCHAR(255),
    employment_start DATE NOT NULL

	-- Foreign keys
    FOREIGN KEY (job_title_id) REFERENCES job_title(id),
    FOREIGN KEY (department_id) REFERENCES department(id),
    FOREIGN KEY (city_id) REFERENCES city(id),
    FOREIGN KEY (gender_id) REFERENCES gender(id)
);

-- Job title history
CREATE TABLE job_title_history (
    id INT IDENTITY(1,1) PRIMARY KEY,
    job_title_id INT NOT NULL,
    employee_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    CHECK (end_date IS NULL OR end_date >= start_date),
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    FOREIGN KEY (job_title_id) REFERENCES job_title(id)
);

-- Department history
CREATE TABLE department_history (
    id INT IDENTITY(1,1) PRIMARY KEY,
    department_id INT NOT NULL,
    employee_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NULL,
    CHECK (end_date IS NULL OR end_date >= start_date),
    FOREIGN KEY (employee_id) REFERENCES employee(id),
    FOREIGN KEY (department_id) REFERENCES department(id)
);

-- Employment terms (salary agreements)
CREATE TABLE employment_terms (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    agreed_salary DECIMAL(10,2) NOT NULL,
    salary_start_date DATE NOT NULL,
    salary_end_date DATE NULL,
    CHECK (salary_end_date IS NULL OR salary_end_date >= salary_start_date),
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);

--getting into salaries table

-- Working hours
CREATE TABLE working_hours_log (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    start_time DATETIME2 NOT NULL,
    end_time DATETIME2 NULL,
    CHECK (end_time IS NULL OR end_time >= start_time),
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);

-- Salary payment
CREATE TABLE salary_payment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    employee_id INT NOT NULL,
    gross_salary DECIMAL(10,2) NOT NULL,
    net_salary DECIMAL(10,2) NOT NULL,
    salary_period DATE NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employee(id)
);

--while datatype is bool use BIT NOT NULL DEFAULT 0 in query
-- Adjustment definitions
CREATE TABLE adjustment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    adjustment_name VARCHAR(255) NOT NULL UNIQUE,
    adjustment_percentage DECIMAL(10,2) NULL,
    is_working_hours_adjustment BIT NOT NULL DEFAULT 0,
    is_other_adjustment BIT NOT NULL DEFAULT 0
);

-- Adjustment linked to work hours
CREATE TABLE working_hours_adjustment (
    id INT IDENTITY(1,1) PRIMARY KEY,
    working_hours_log_id INT NOT NULL,
    adjustment_id INT NOT NULL,
    salary_payment_id INT NULL,
    adjustment_amount DECIMAL(10,2) NULL,
    adjustment_percentage DECIMAL(10,2) NULL,
    FOREIGN KEY (working_hours_log_id) REFERENCES working_hours_log(id),
    FOREIGN KEY (adjustment_id) REFERENCES adjustment(id),
    FOREIGN KEY (salary_payment_id) REFERENCES salary_payment(id)
);

-- Adjustment linked to salary
CREATE TABLE adjustment_amount (
    id INT IDENTITY(1,1) PRIMARY KEY,
    salary_payment_id INT NOT NULL,
    adjustment_id INT NOT NULL,
    adjustment_amount DECIMAL(10,2) NULL,
    adjustment_percentage DECIMAL(10,2) NULL,
    FOREIGN KEY (salary_payment_id) REFERENCES salary_payment(id),
    FOREIGN KEY (adjustment_id) REFERENCES adjustment(id)
);


--Inserting values for each table
INSERT INTO country (country_name) VALUES
('USA'),
('India'),
('UK'),
('Germany'),
('Australia');


INSERT INTO city (city_name, country_id) VALUES
('New York', 1),
('Mumbai', 2),
('London', 3),
('Berlin', 4),
('Sydney', 5);


INSERT INTO gender (gender_name) VALUES
('Male'),
('Female'),
('Non-Binary'),
('Other'),
('Prefer Not to Say');


INSERT INTO department (department_name) VALUES
('HR'),
('IT'),
('Finance'),
('Sales'),
('Marketing');


INSERT INTO job_title (job_title) VALUES
('Software Engineer'),
('HR Manager'),
('Accountant'),
('Sales Executive'),
('Marketing Specialist');


INSERT INTO employee (first_name, last_name, date_of_birth, job_title_id, department_id, gender_id, city_id, address, email, employment_start) VALUES
('John', 'Doe', '1990-01-15', 1, 2, 1, 1, '123 Main St', 'john.doe@example.com', '2020-06-01'),
('Jane', 'Smith', '1985-03-22', 2, 1, 2, 2, '456 Elm St', 'jane.smith@example.com', '2019-04-15'),
('Robert', 'Brown', '1992-07-30', 3, 3, 1, 3, '789 Oak St', 'robert.brown@example.com', '2021-01-10'),
('Emily', 'Davis', '1988-11-05', 4, 4, 2, 4, '321 Pine St', 'emily.davis@example.com', '2022-03-20'),
('Michael', 'Wilson', '1995-09-12', 5, 5, 1, 5, '654 Maple St', 'michael.wilson@example.com', '2023-07-01');


INSERT INTO employment_terms (employee_id, agreed_salary, salary_start_date, salary_end_date) VALUES
(1, 75000.00, '2020-06-01', NULL),
(2, 90000.00, '2019-04-15', NULL),
(3, 60000.00, '2021-01-10', NULL),
(4, 55000.00, '2022-03-20', NULL),
(5, 65000.00, '2023-07-01', NULL);


INSERT INTO department_history (department_id, employee_id, start_date, end_date) VALUES
(2, 1, '2020-06-01', NULL),
(1, 2, '2019-04-15', NULL),
(3, 3, '2021-01-10', NULL),
(4, 4, '2022-03-20', NULL),
(5, 5, '2023-07-01', NULL);


INSERT INTO job_title_history (job_title_id, employee_id, start_date, end_date) VALUES
(1, 1, '2020-06-01', NULL),
(2, 2, '2019-04-15', NULL),
(3, 3, '2021-01-10', NULL),
(4, 4, '2022-03-20', NULL),
(5, 5, '2023-07-01', NULL);


INSERT INTO working_hours_log (employee_id, start_time, end_time) VALUES
(1, '2025-08-21 09:00:00', '2025-08-21 17:00:00'),
(2, '2025-08-21 10:00:00', '2025-08-21 18:00:00'),
(3, '2025-08-21 08:30:00', '2025-08-21 16:30:00'),
(4, '2025-08-21 09:15:00', '2025-08-21 17:15:00'),
(5, '2025-08-21 09:45:00', '2025-08-21 17:45:00');


INSERT INTO adjustment (adjustment_name, adjustment_percentage, is_working_hours_adjustment, is_other_adjustment) VALUES
('Overtime Bonus', 10.0, 1, 0),
('Performance Bonus', 15.0, 0, 1),
('Late Penalty', -5.0, 1, 0),
('Holiday Bonus', 8.0, 0, 1),
('Year-End Bonus', 12.0, 0, 1);


INSERT INTO working_hours_adjustment (working_hours_log_id, adjustment_id, salary_payment_id, adjustment_amount, adjustment_percentage) VALUES
(1, 1, NULL, 200.00, 10.0),
(2, 3, NULL, -50.00, -5.0),
(3, 1, NULL, 180.00, 10.0),
(4, 3, NULL, -40.00, -5.0),
(5, 1, NULL, 220.00, 10.0);


INSERT INTO salary_payment (employee_id, gross_salary, net_salary, salary_period) VALUES
(1, '75000', '70000', '2025-08-01'),
(2, '90000', '85000', '2025-08-01'),
(3, '60000', '57000', '2025-08-01'),
(4, '55000', '52000', '2025-08-01'),
(5, '65000', '62000', '2025-08-01');


INSERT INTO adjustment_amount (salary_payment_id, adjustment_id, adjustment_amount, adjustment_percentage) VALUES
(1, 2, 5000.00, 15.0),
(2, 2, 6000.00, 15.0),
(3, 4, 4800.00, 8.0),
(4, 5, 6240.00, 12.0),
(5, 5, 7800.00, 12.0);

















--accessing index (many->one) 
CREATE INDEX IX_city_country ON city(country_id);
CREATE INDEX IX_emp_jobtitle ON employee(job_title_id);
CREATE INDEX IX_emp_department ON employee(department_id);
CREATE INDEX IX_emp_city ON employee(city_id);
CREATE INDEX IX_emp_gender ON employee(gender_id);
CREATE INDEX IX_jth_emp ON job_title_history(employee_id);
CREATE INDEX IX_deph_emp ON department_history(employee_id);
CREATE INDEX IX_whl_emp ON working_hours_log(employee_id);
CREATE INDEX IX_salpay_emp ON salary_payment(employee_id);
CREATE INDEX IX_wha_log ON working_hours_adjustment(working_hours_log_id);
CREATE INDEX IX_wha_pay ON working_hours_adjustment(salary_payment_id);
CREATE INDEX IX_adjam_pay ON adjustment_amount(salary_payment_id);


--accessing by an help of index
--find all cities in india
SELECT city_name FROM city WHERE country_id = 2;

--Get all employees who are software engineers
SELECT first_name, last_name FROM employee WHERE job_title_id = 1;

--List employees in the Finance department.
SELECT first_name, last_name FROM employee WHERE department_id = 3;

--Query By city
SELECT e.first_name, e.last_name
FROM employee e
JOIN city c ON e.city_id = c.id
WHERE c.city_name = 'Mumbai';

--or

Select first_name, last_name from employee where city_id='2';

--count how many female employees are in the company
SELECT COUNT(*) AS FemaleEmployees FROM employee WHERE gender_id = 2;

--Find the job history for employee with ID = 3
SELECT job_title_id, start_date, end_date FROM job_title_history
WHERE employee_id = 3;

--Get all working hours logs for employee 4.
SELECT start_time, end_time FROM working_hours_log
WHERE employee_id = 4;

--Get the latest salary for employee 2.
SELECT TOP 1 gross_salary, net_salary, salary_period
FROM salary_payment WHERE employee_id = 2
ORDER BY salary_period DESC;

--Find all adjustments applied to a specific working hours log ID = 1.
SELECT adjustment_amount, adjustment_percentage
FROM working_hours_adjustment
WHERE working_hours_log_id = 1;

--Get all adjustments for salary payment 3.
SELECT adjustment_id, adjustment_amount, adjustment_percentage
FROM adjustment_amount
WHERE salary_payment_id = 3;



--offset
SELECT id, first_name, last_name, department_id FROM employee 
ORDER BY id OFFSET 2 ROWS FETCH NEXT 3 ROWS ONLY;

--Get 2 employees per page for department_id = 2:
SELECT id, first_name, last_name FROM employee
WHERE department_id = 2 ORDER BY employment_start
OFFSET 0 ROWS FETCH NEXT 2 ROWS ONLY;








Alter database PayRollDemo MODIFY NAME = EmployeePayroll;