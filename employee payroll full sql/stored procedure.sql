--main database --->payRollDemo1
USE payRollDemo1;
GO


--------------------------------------------------------------------------
--create a new table from an old table
select * into sptable from employee where 1 = 1;

-- to add a new columns in sp table
Alter table sptable add ISACTIVE BIT NOT NULL DEFAULT 1,
ISDELETED BIT NOT NULL DEFAULT 0,
CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
CreatedBy VARCHAR(100) NULL, 
ModifiedDate DATETIME NULL,ModifiedBy VARCHAR(100) NULL;

Alter table sptable add Action VARCHAR(10);

ALTER TABLE sptable
ALTER COLUMN CreatedBy VARCHAR(100) NULL;

UPDATE sptable
SET CreatedBy = 'System'  
WHERE CreatedBy IS NULL;
---------------------------------------------------------------------------

---above way or perform this manner       (while creating new sp table without cpying another)
CREATE TABLE sptable (
	id int,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    department_id INT,
    job_title_id INT,
    gender_id INT,
    address VARCHAR(200),
    city_id INT,
    email VARCHAR(100),
    employment_start DATE,
    IsActive BIT NOT NULL DEFAULT 1,
    IsDeleted BIT NOT NULL DEFAULT 0,
    CreatedDate DATETIME NOT NULL DEFAULT GETDATE(),
    CreatedBy VARCHAR(100),
    ModifiedDate DATETIME NULL,
    ModifiedBy VARCHAR(100)
);

UPDATE sptable
SET CreatedBy = 'System'  
WHERE CreatedBy IS NULL;


------------------------------------------------------------------------
--stored procedure for create

CREATE PROCEDURE sp_InsertEmployee
    @first_name VARCHAR(50),
    @last_name VARCHAR(50),
    @date_of_birth DATE,
    @department_id INT,
    @job_title_id INT,
    @gender_id INT,
    @address VARCHAR(200),
    @city_id INT,
    @email VARCHAR(100),
    @employment_start DATE,
    @CreatedBy VARCHAR(100),
	@Action VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON; --doesn't show 1 row affested message used in stored_procedure,triggers and script

	--CREATE
	 IF @Action = 'CREATE'
	 BEGIN
		INSERT INTO sptable (
			first_name, last_name, date_of_birth,
			department_id, job_title_id, gender_id, address,
			city_id, email, employment_start,
			IsActive, IsDeleted, CreatedDate, CreatedBy
		)
		VALUES (
			@first_name, @last_name, @date_of_birth,
			@department_id, @job_title_id, @gender_id, @address,
			@city_id, @email, @employment_start,
			1, 0, GETDATE(), @CreatedBy
		);
		--SELECT SCOPE_IDENTITY() AS NEWEMPLOYEEID;
	END			
END;

---------------------------------------------------------------------------------
--Insert a value in stored procedure

Execute sp_InsertEmployee 
	@first_name = 'KAVYA',
	@last_name = 'suresh',
	@date_of_birth ='2001-09-09',
	@job_title_id = 2,
	@address = 'xyz nagar',
	@department_id = 3,
	@gender_id = 2,
	@city_id = 4,
	@email = 'kavya.sursha@example.com',
	@employment_start = '2022-06-12',
	@createdby = 'Hr',
	@Action = 'create';

----------------------------------------------------------------------------------

--stored procedure for read(select)

CREATE PROCEDURE sp_ReadEmployee
	@Action VARCHAR(255),
	@department_id INT
AS
BEGIN
    SET NOCOUNT ON; --doesn't show 1 row affested message used in stored_procedure,triggers and script
	IF @Action = 'READ'
    BEGIN
        IF @department_id IS NOT NULL
            SELECT * FROM sptable WHERE department_id = @department_id;
        ELSE
            SELECT * FROM sptable;
    END
END;

--get all employee
EXEC sp_ReadEmployee 'READ';

-- Get a specific employee
EXEC sp_ReadEmployee 'READ', 2;
---------------------------------------------------------------------------------
--Update Employee
CREATE PROCEDURE sp_UpdateEmployee
    @id INT,
    @first_name VARCHAR(50) = NULL,
    @last_name VARCHAR(50) = NULL,
    @date_of_birth DATE = NULL,
    @department_id INT = NULL,
    @job_title_id INT = NULL,
    @gender_id INT = NULL,
    @city_id INT = NULL,
    @email VARCHAR(100) = NULL,
    @employment_start DATE = NULL,
    @CreatedBy VARCHAR(100) = NULL,
    @ModifiedDate DATETIME = NULL,
    @ModifiedBy VARCHAR(100) = NULL,
    @isActive BIT = NULL,
    @isDeleted BIT = NULL,
    @Action VARCHAR(255)
AS
BEGIN
    SET NOCOUNT ON;

    IF @Action = 'UPDATE'
    BEGIN
        UPDATE sptable
        SET
            first_name      = ISNULL(@first_name, first_name),
            last_name       = ISNULL(@last_name, last_name),
            date_of_birth   = ISNULL(@date_of_birth, date_of_birth),
            department_id   = ISNULL(@department_id, department_id),
            job_title_id    = ISNULL(@job_title_id, job_title_id),
            gender_id       = ISNULL(@gender_id, gender_id),
            city_id         = ISNULL(@city_id, city_id),
            email           = ISNULL(@email, email),
            employment_start = ISNULL(@employment_start, employment_start),
            IsActive        = ISNULL(@isActive, IsActive),
            IsDeleted       = ISNULL(@isDeleted, IsDeleted),
            ModifiedDate    = ISNULL(@ModifiedDate, GETDATE()),
            ModifiedBy      = ISNULL(@ModifiedBy, @CreatedBy)
        WHERE id = @id;

        SELECT 'Updated successfully' AS Message;
    END
END;

EXEC sp_UpdateEmployee
    @id = 1004,
    @Email = 'new.email@example.com',
	@Action = 'UPDATE';

EXEC sp_UpdateEmployee
    @id = 1,
    @first_name = 'Kavya',
    @Action = 'UPDATE';

------------------------------------------------------------------------------
--delete

CREATE PROCEDURE sp_DeleteEmployee
    @id INT
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM sptable
    WHERE id = @id;

    SELECT 'Employee deleted successfully' AS Message;
END;

EXEC sp_DeleteEmployee @id = 1004;
-------------------------------------------------------------------------------

select * from sptable;

drop procedure sp_InsertEmployee;
drop procedure sp_ReadEmployee;
drop procedure sp_UpdateEmployee;
drop procedure sp_DeleteEmployee;

