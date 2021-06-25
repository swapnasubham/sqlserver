-- lession 2 --
-- create database --
create database it;
alter database it modify name = programmer;
sp_renameDB 'programmer' ,'it';
drop database it;
alter database it set single_user with rollback immediate;

-- lession 3 --
use [hr];
-- create table --
create table department (
	department_id int not null primary key,
	department_name nvarchar(255) not null
);
-- foreign key constraints --
alter table employee add constraint FK_employee_department 
foreign key(department_id) references department(department_id);

-- lession 4 --
select * from employee;
insert into employee (employee_id,name,email,salary,department_id) values (10006,'AMIR KHAN','amirkhan',85000,300);
-- default constaint --
alter table employee add constraint DF_employee_department_id default 100 for department_id; 

insert into employee (employee_id,name,email,salary) values (10007,'PALASH MAL','palashmal',85000);
insert into employee (employee_id,name,email,salary,department_id) values (10008,'SANTU ROY','santuroy',35000,200);
select * from employee;

-- drop constraint --
alter table employee drop DF_employee_department_id;

-- lession 5 --
-- cascading referential integrity -- no action, set null, set default, cascade
delete from department where department_id = 200;
-- The DELETE statement conflicted with the REFERENCE constraint "FK_employee_department". 
-- The conflict occurred in database "hr", table "dbo.employee", column 'department_id'.
delete from department where department_id = 200;
select * from employee;

-- lession 6 --
-- table details alt+F1 --
select * from employee;
-- check constraints --
alter table employee drop constraint CK_employee_salary;
alter table employee add constraint CK_employee_salary check (salary > 0 and salary < 5000000);

-- lession 7 --
-- identity column --
create table STUDENT (
	roll_no int identity(1,1) primary key,
	first_name nvarchar(255),
	last_name nvarchar(255)
);
insert into student values ('ANIK','DAS');
insert into student values ('DANTE','DAS');
delete from student where roll_no = 2;
insert into student values ('SOMDUTTA','DE');
select * from student;
set identity_insert student off;
insert into student (roll_no,first_name,last_name) values (2,'DANTE','DAS');
-- reset identity value --
delete from student;
dbcc checkident(student,reseed,0);

-- lession 8 --
-- retrive the last generated identity column value --
SELECT SCOPE_IDENTITY();
SELECT  @@IDENTITY;
SELECT IDENT_CURRENT('STUDENT');

-- lession 9 --
-- unique constraint --
select * from employee;
alter table employee add constraint UQ_employee_email unique(email);
insert into employee (employee_id,name,email,salary,department_id) values (10009,'SUROJIT SARKAR','gojosarkar',2500,200);
alter table employee drop constraint UQ_employee_email;

-- lession 10 --
-- all about select --
SELECT * FROM employee;
SELECT 
	 [employee_id]
    ,[name]
    ,[email]
    ,[salary]
    ,[department_id]
FROM 
	[dbo].[employee];
-- DISTINCT VALUE --
SELECT
	DISTINCT [DEPARTMENT_ID]
FROM
	[EMPLOYEE];
-- WHERE CONDITION -- 
SELECT 
	 [employee_id]
    ,[name]
    ,[email]
    ,[salary]
    ,[department_id]
FROM 
	[dbo].[employee]
WHERE
	[department_id] = 100;

SELECT 
	 [employee_id]
    ,[name]
    ,[email]
    ,[salary]
    ,[department_id]
FROM 
	[dbo].[employee]
WHERE
	[department_id] IN ( 100,200)
ORDER BY
	[department_id];

SELECT
	 TOP 4 
	 [employee_id]
    ,[name]
    ,[email]
    ,[salary]
    ,[department_id]
FROM 
	[dbo].[employee];

SELECT
	 TOP 4 PERCENT
	 [employee_id]
    ,[name]
    ,[email]
    ,[salary]
    ,[department_id]
FROM 
	[dbo].[employee];

-- lession 11 --
-- all about group by --
UPDATE [dbo].[employee] SET department_id = 200 WHERE department_id IS NULL;

SELECT 
	COUNT(*) AS count,
	[department_id]
FROM
	[dbo].[employee]
GROUP BY
	[department_id];
-- lession 11 --
-- Having Clause --
SELECT 
	COUNT(*) AS count,
	[department_id]
FROM
	[dbo].[employee]
GROUP BY
	[department_id]
HAVING
	count(*) > 2;

SELECT 
	sum(salary) AS total,
	[department_id]
FROM
	[dbo].[employee]
GROUP BY
	[department_id]
HAVING
	department_id = 100;

-- lession 12 --
-- Joining --
SELECT 
	emp.employee_id
	,emp.name
	,emp.salary
	,dept.department_name
FROM
	[dbo].[employee] emp
	inner join [dbo].[department] dept on emp.department_id = dept.department_id
ORDER BY
	department_name;

-- left join --
SELECT 
	emp.employee_id
	,emp.name
	,emp.salary
	,dept.department_name
FROM
	[dbo].[employee] emp
	left join [dbo].[department] dept on emp.department_id = dept.department_id
ORDER BY
	department_name;

-- right join --
SELECT 
	emp.employee_id
	,emp.name
	,emp.salary
	,dept.department_name
FROM
	[dbo].[employee] emp
	right join [dbo].[department] dept on emp.department_id = dept.department_id
ORDER BY
	department_name;

-- full join --
SELECT 
	emp.employee_id
	,emp.name
	,emp.salary
	,dept.department_name
FROM
	[dbo].[employee] emp
	full join [dbo].[department] dept on emp.department_id = dept.department_id
ORDER BY
	department_name;

-- cross join --
SELECT 
	emp.employee_id
	,emp.name
	,emp.salary
	,dept.department_name
FROM
	[dbo].[employee] emp
	cross join [dbo].[department] dept
ORDER BY
	department_name;

-- lession 13 --
-- advance Joining --
-- no matching rows left--
SELECT 
	emp.employee_id
	,emp.name
	,emp.salary
	,dept.department_name
FROM
	[dbo].[employee] emp
	left join [dbo].[department] dept on emp.department_id = dept.department_id
WHERE 
	dept.department_id is null;

-- no matching rows right --
SELECT 
	emp.employee_id
	,emp.name
	,emp.salary
	,dept.department_name
FROM
	[dbo].[employee] emp
	right join [dbo].[department] dept on emp.department_id = dept.department_id
WHERE 
	emp.department_id is null;

-- no matching rows full --
SELECT 
	emp.employee_id
	,emp.name
	,emp.salary
	,dept.department_name
FROM
	[dbo].[employee] emp
	full join [dbo].[department] dept on emp.department_id = dept.department_id
WHERE 
	emp.department_id is null or dept.department_id is null;
	
-- lession 14 --
-- advance Joining --
-- self join--
-- left outer self join --
SELECT 
	 emp.employee_id
	,emp.name as employee_name
	,mgr.name as manager_name
FROM
	[dbo].[employee] emp
	left join [dbo].[employee] mgr on emp.manager_id = mgr.employee_id
ORDER BY
	mgr.name;
-- inner outer self join --
SELECT 
	 emp.employee_id
	,emp.name as employee_name
	,mgr.name as manager_name
FROM
	[dbo].[employee] emp
	inner join [dbo].[employee] mgr on emp.manager_id = mgr.employee_id
ORDER BY
	mgr.name;

-- right outer self join --
SELECT 
	 emp.employee_id
	,emp.name as employee_name
	,mgr.name as manager_name
FROM
	[dbo].[employee] emp
	right join [dbo].[employee] mgr on emp.manager_id = mgr.employee_id
ORDER BY
	mgr.name;

-- lession 15 --
-- different null function --
-- isnull function -- 
SELECT 
	 emp.[employee_id]
	,emp.[name] as employee_name
	,ISNULL(mgr.[name],'NO MANAGER') as manager_name
FROM
	[dbo].[employee] emp
	left join [dbo].[employee] mgr on emp.[manager_id] = mgr.[employee_id]
ORDER BY
	mgr.[name];

-- coalesce function --
SELECT 
	 emp.[employee_id]
	,emp.[name] as employee_name
	,coalesce(mgr.[name],'NO MANAGER') as manager_name
FROM
	[dbo].[employee] emp
	left join [dbo].[employee] mgr on emp.[manager_id] = mgr.[employee_id]
ORDER BY
	mgr.[name];

-- case clause --
SELECT 
	 emp.[employee_id]
	,emp.[name] as employee_name
	,CASE 
		WHEN mgr.[name] IS NULL THEN 'NO MANAGER' 
		ELSE mgr.[name] 
	END
	as manager_name
FROM
	[dbo].[employee] emp
	left join [dbo].[employee] mgr on emp.[manager_id] = mgr.[employee_id]
ORDER BY
	mgr.[name];

-- lession 16 --
-- colaesce function --
-- this function return first not null value
SELECT 
	 emp.[employee_id]
	,emp.[name] as employee_name
	,coalesce(mgr.[name],'NO MANAGER') as manager_name
FROM
	[dbo].[employee] emp
	left join [dbo].[employee] mgr on emp.[manager_id] = mgr.[employee_id]
ORDER BY
	mgr.[name];

-- lession 17 --
-- union and union all --
-- this function return first not null value
-- CTRL + L for estimate cost --
select [name] from [employee]
union all
select [first_name] from student;

select [name] from [employee]
union
select [first_name] from student;

-- lession 18 --
-- store procedure --
CREATE PROCEDURE SP_EMP_NAME_SALARY
AS
BEGIN

	SELECT 
		EMPLOYEE_ID
		,NAME
		,SALARY
	FROM
		EMPLOYEE
END;

SP_EMP_NAME_SALARY;	
exec SP_EMP_NAME_SALARY;
execute SP_EMP_NAME_SALARY;	

-- store procedure with inut parameter--
CREATE PROCEDURE SP_GET_EMP_BY_DEPARTMENT
@department_id int
AS
BEGIN

	SELECT 
		EMPLOYEE_ID
		,NAME
		,SALARY
	FROM
		EMPLOYEE
	WHERE
		DEPARTMENT_ID = @department_id
END;

SP_GET_EMP_BY_DEPARTMENT 100;
execute SP_GET_EMP_BY_DEPARTMENT 200;
execute SP_GET_EMP_BY_DEPARTMENT @department_id = 200;
sp_helptext [SP_GET_EMP_BY_DEPARTMENT];

ALTER PROCEDURE SP_GET_EMP_BY_DEPARTMENT
@department_id int
AS
BEGIN

	SELECT 
		EMPLOYEE_ID
		,NAME
		,SALARY
	FROM
		EMPLOYEE
	WHERE
		DEPARTMENT_ID = @department_id
	ORDER BY
		SALARY
END;

-- encryption --
ALTER PROCEDURE SP_GET_EMP_BY_DEPARTMENT
@department_id int
WITH ENCRYPTION
AS
BEGIN

	SELECT 
		EMPLOYEE_ID
		,NAME
		,SALARY
	FROM
		EMPLOYEE
	WHERE
		DEPARTMENT_ID = @department_id
	ORDER BY
		SALARY
END;

-- lession 19 --
-- store procedure with out parameter --

CREATE PROCEDURE SP_GET_EMP_COUNT_BY_DEPARTMENT
@department_id int,
@employee_count int output
AS
BEGIN

	SELECT 
		@employee_count = count(EMPLOYEE_ID)
	FROM
		EMPLOYEE
	WHERE
		DEPARTMENT_ID = @department_id
END;

declare @employee_count int
execute SP_GET_EMP_COUNT_BY_DEPARTMENT 100, @employee_count output
if (@employee_count is null)
	print('Employee Count is NULL')
else
	print('Employee Count is not NULL')
print @employee_count


declare @employee_count int
execute SP_GET_EMP_COUNT_BY_DEPARTMENT 100, @employee_count
if (@employee_count is null)
	print('Employee Count is NULL')
else
	print('Employee Count is not NULL')
print @employee_count

declare @employee_count int
execute SP_GET_EMP_COUNT_BY_DEPARTMENT @employee_count = @employee_count output, @department_id = 100
print @employee_count

sp_help SP_GET_EMP_COUNT_BY_DEPARTMENT;
sp_help EMPLOYEE;
--ALT+F1--

sp_helptext SP_GET_EMP_COUNT_BY_DEPARTMENT;
sp_depends SP_GET_EMP_COUNT_BY_DEPARTMENT;


-- lession 20 --
-- store procedure with outpur parameter and retrun value --
CREATE PROCEDURE SP_GET_EMP_BY_ID
@employee_id int,
@name nvarchar(255) output
AS
BEGIN
	SELECT 
		@name = name
	FROM
		EMPLOYEE
	WHERE
		employee_id = @employee_id
END;

declare @name nvarchar(255)
execute SP_GET_EMP_BY_ID @name = @name output, @employee_id = 10000
print @name

CREATE PROCEDURE SP_GET_EMP_COUNT
AS
BEGIN
	RETURN (SELECT 
		count(EMPLOYEE_ID)
	FROM
		EMPLOYEE)
END;

declare @total_count int
execute @total_count = SP_GET_EMP_COUNT
print @total_count

CREATE PROCEDURE SP_GET_EMP_BY_ID
@employee_id int,
@name nvarchar(255) output
AS
BEGIN
	SELECT 
		@name = name
	FROM
		EMPLOYEE
	WHERE
		employee_id = @employee_id
END;

declare @name nvarchar(255)
execute SP_GET_EMP_BY_ID @name = @name output, @employee_id = 10000
print 'Name is '+@name

-- Can't use Return --
CREATE PROCEDURE SP_GET_EMP_BY_ID_RETURN
@employee_id int
AS
BEGIN
	RETURN
	(SELECT 
		name
	FROM
		EMPLOYEE
	WHERE
		employee_id = @employee_id)
END;
-- Error, Retrun can only return one value and has to be integer--
declare @name nvarchar(255)
execute @name = SP_GET_EMP_BY_ID_RETURN 10000
print @name

--lession 20 --
-- advantage of store procedure --

CREATE PROCEDURE SP_GET_EMP_NAME_BY_ID
@employee_id int,
@name nvarchar(255) output
AS
BEGIN
	SELECT 
		@name = name
	FROM
		EMPLOYEE
	WHERE
		employee_id = @employee_id
END;

declare @name nvarchar(255)
execute SP_GET_EMP_NAME_BY_ID @name = @name output, @employee_id = 10000
print @name

-- lession 21 --
-- String Function --
SELECT ASCII('A');
SELECT ASCII('ABC');
SELECT CHAR(65);

DECLARE
	@START INT
	SET @START = 65
	WHILE(@START <= 90)
BEGIN
	PRINT CHAR(@START)
	SET @START = @START + 1
END

SELECT '     ANIK DAS    ';
SELECT LTRIM('     ANIK DAS    ');
SELECT RTRIM('     ANIK DAS    ');
SELECT RTRIM(LTRIM('     ANIK DAS    '));

SELECT FIRST_NAME,LAST_NAME FROM STUDENT;
SELECT FIRST_NAME+' '+LAST_NAME FROM STUDENT;

SELECT LOWER(FIRST_NAME),UPPER(LAST_NAME) FROM STUDENT;
SELECT REVERSE(FIRST_NAME+' '+LAST_NAME) FROM STUDENT;
SELECT LEN(FIRST_NAME+LAST_NAME) AS LENGTH FROM STUDENT;

-- lession 22 --
-- String Function --
SELECT LEFT('ABCDEF', 3)
SELECT RIGHT('ABCDEF', 3)
SELECT CHARINDEX('@','swapnasubham.das@gmail.com',1)
SELECT SUBSTRING('swapnasubham.das@gmail.com',18,10)
SELECT SUBSTRING('swapnasubham.das@gmail.com',CHARINDEX('@','swapnasubham.das@gmail.com') + 1,LEN('swapnasubham.das@gmail.com')-CHARINDEX('@','swapnasubham.das@gmail.com'))
SELECT SUBSTRING('swapnasubham.das@yahoo.com',CHARINDEX('@','swapnasubham.das@yahoo.com') + 1,LEN('swapnasubham.das@yahoo.com')-CHARINDEX('@','swapnasubham.das@yahoo.com'))

-- lession 24 --
-- String Function --

select REPLICATE('Anik',5)
--- masking eamil address or account number --
SELECT FIRST_NAME+SPACE(1)+LAST_NAME FROM STUDENT; 
SELECT FIRST_NAME, PATINDEX('%SO%',FIRST_NAME) AS FIRST_OCCURENCE FROM STUDENT WHERE PATINDEX('%SO%',FIRST_NAME) >= 1; 
SELECT FIRST_NAME+SPACE(1)+REPLACE(LAST_NAME,'DAS','DE') FROM STUDENT; 
SELECT FIRST_NAME+SPACE(1)+STUFF(LAST_NAME,1,2,'***') FROM STUDENT;

-- lession 25 --
-- Date Time  Function --
select GETDATE();
insert into table_date_time values (GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE(),GETDATE());
select * from table_date_time;
select GETDATE();
select CURRENT_TIMESTAMP;
select sysdatetime();
select sysdatetimeoffset();
select GETUTCDATE();


-- lession 26 --
-- Date Time  Function --
SELECT ISDATE('ANIK DAS')
SELECT ISDATE(GETDATE())
SELECT DAY(GETDATE())
SELECT MONTH(GETDATE())
SELECT YEAR(GETDATE())
SELECT DATENAME(DAY,'2021-03-10 07:20:18.697')
SELECT DATENAME(WEEKDAY,GETDATE())
SELECT DATENAME(MONTH,GETDATE())


-- lession 27 --
-- Date Time  Function --
SELECT DATEPART(DAY,'2021-03-10 07:20:18.697')
SELECT DATENAME(WEEKDAY,'2021-03-10 07:20:18.697')
SELECT DATENAME(MONTH,'2021-03-10 07:20:18.697')
SELECT DATENAME(YEAR,'2021-03-10 07:20:18.697')


