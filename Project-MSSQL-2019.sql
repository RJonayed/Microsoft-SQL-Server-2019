--Date 02/02/2021
--Id-1261620 
--Name-Jonayed Rahaman

--For Create Database

Use Master 
Go

If DB_ID('StudentDB') is not null 
Drop Database StudentDB
go

Create Database StudentDB on
(Name=N'StudentDB',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQL2012\MSSQL\DATA\StudentDB.mdf',
Size=25mb,
MaxSize=100mb,
FileGrowth=5%)
Log on
(
Name=N'StudentDB_ldf',
FileName='C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQL2012\MSSQL\DATA\StudentDB.ldf',
Size=5mb,
MaxSize=25mb,
FileGrowth=1%
);
go

----------------------------------------------------------------------------------------------------

--Question No_1
--Answer No_1
--Table create & Values Insert

Use StudentDB
Go
Create table TSP
(
TspId int primary key not null,
TspName Varchar(10),
);

Use StudentDB
Go

Insert into TSP values
(101,'USSL'),(102,'PNTL');

Use StudentDB
go

Create table Hobby 
(HobbyId int primary key not null,
HobbyType Varchar(20));

Use StudentDB
Go
Insert into Hobby Values(201,'Football'),(202,'Volleyball'),(203,'Basketball');

Use StudentDB
go

Create table Subjects
(SubjectId int primary key not null,
SubjectName varchar(20));

Use StudentDB
Go
Insert into Subjects Values (301,'C#'),(302,'JEE'),(303,'WPDI');

Use StudentDB
go

Create table Student
(
StudentId int primary key not null,
StudentFName Varchar(10),
StudentLName varchar(10),
StudentPhoneNo char(7),
HobbyId int Foreign key references Hobby(HobbyId)
);

Use StudentDB
go

Insert into Student values(1,'Peter','Mark','1234567',201),(2,'Victor','Gomez','1234568',202),
(3,'Victor','Gomez','1234568',203),(4,'Victor','Gomez','1234568',201),(5,'Young','Lee','1234569',202);

Use StudentDB 
Go

Create Table Relation_t
(
StudentId int Foreign key References Student(StudentId),
TspId int Foreign key References Tsp(TspId),
SubjectsId int Foreign key References Subjects(SubjectId),
);

Use StudentDB 
Go
Insert into Relation_t values (1,101,301),(2,101,301),(3,101,301),(4,101,302),(5,102,303);
Go

-------------------------------------------------------------------------------------------------------------
--Question No_2
--Answer No_2
--For Delete 

Use StudentDB
go

Delete From Relation_t where StudentId=5;

Go
---------------------------------------------------------------------------------------------------------------

--Question No_3
--Answer No_3
--For update

Update Relation_t set SubjectsId=301 where StudentId=1;

Go

----------------------------------------------------------------------------------------------------------------

--Question No_4
--Answer No_4
--For Delete Table

Use StudentDB
go

Delete Relation_t 
Drop table Relation_t;

Go
------------------------------------------------------------------------------------------------------------
--Question No_5
--Answer No_5
--For Delete Column

Use StudentDB 
Go

Alter table Relation_t
Drop SubjectsId;

--------------------------------------------------------------------------------------

--Question No_6
--Answer No_6
--For Sub Query

Use StudentDB
Go

Select s.StudentId as [Student Id],(S.StudentFName+s.StudentLName) as "Student Name",
s.StudentPhoneNo as 'Student Phone',H.HobbyType as [Student Hobby] from Student S join Hobby H
On S.HobbyId=H.HobbyId where H.HobbyId in
(Select HobbyId From Hobby where HobbyId=201);

go
----------------------------------------------------------------------------------------

--Question No_7
--Answer No_7
--For join Query Group by Having 

Use StudentDB
Go

Select S.StudentId as 'Student Id',s.StudentFName+ ' ' +S.StudentLName as [Student Name],H.HobbyType as " Student Hobby"
,S.StudentPhoneNo as[Student Phone]
from Relation_t R join Student S join Hobby H
on S.HobbyId=H.HobbyId
on R.StudentId=S.StudentId Group by s.StudentId,S.StudentFName,S.StudentLName,H.HobbyType,s.StudentPhoneNo
having h.HobbyType='Football' order by S.StudentId desc;  
       
Go                                                    
------------------------------------------------------------------------------------------------

--Question No_8
--Answer No_8
--For Create View 

Use StudentDB
Go                                     
 
 Create view VwStudent
 As
Select S.StudentId as 'Student Id',s.StudentFName+ ' ' +S.StudentLName as [Student Name],H.HobbyType as " Student Hobby"
,S.StudentPhoneNo as[Student Phone] from Relation_t R join Student S join Hobby H
on S.HobbyId=H.HobbyId
on R.StudentId=S.StudentId Group by s.StudentId,S.StudentFName,S.StudentLName,H.HobbyType,S.StudentPhoneNo having h.HobbyType='Football';
 
Go                                                             
-----------------------------------------------------------------------------------------------------------------------------


--Question No_9
--Answer No_9
--For Create Trigger       
    
 Use StudentDB
 go

 Create trigger TrInsert
 on TSP
After Insert,Update
As
 Declare @TspId int;
 Declare @TspName Varchar(20);

 Update Tsp set TspName=Upper(TspName) where TspId in (Select TspId from TSP where TspId=102)

 Select @TspId=Ins.TspId from inserted as Ins;
 Select @TspName= Ins.TspName from inserted as Ins;
 Insert into TspCopy Values (@TspId,@TspName)

 Print 'Save Successfully'
 Print 'Update Successfully'

--Select * from TspCopy
--Insert into TSP values (104,'Roporting')
 Go
 
 -------------------------------------------------------------------------------------------
 --Question No_10
--Answer No_10
-- For Scalar Function

Use StudentDB
Go

Create Function FnScalar
(@StudentId int)
Returns varchar(40)
Begin 

Return (Select (StudentFName+ ' ' +StudentLName) from Student where StudentId=@StudentId)
End

Go

--For Check
--Select Dbo.FnScalar(1)As[Student Name]

--------------------------------------------------------------------------------------
--Question No_11
--Answer No_11

--For Table Function

Use StudentDB 
Go

Create Function FnGetPerson()
Returns Table
Return (Select S.StudentId as[Student Id],(S.StudentFName+ ' ' +S.StudentLName) as[Student Name],
S.StudentPhoneNo as[Student Phone],H.HobbyType as[Student Hobby] from Student S join Hobby H 
on S.HobbyId=H.HobbyId Where StudentId between 1 and 3);

Go
--For Check
--Select * from Dbo.FnGetPerson()

-------------------------------------------------------------------------------------------------
--Question No_12
--Answer No_12
--For Create Insert Trigger & Error Handle
Use StudentDB
Go

Create trigger TrInsertTSPShowError
on TSP
After Insert
As
Begin 
Declare @name varchar(5);
Select @name=i.TspName from inserted as i
if @name='PNTL'
Raiserror('TSP Name cannot be PNTL',11,1)
--throw 51000,'Connot insert.',1
rollback tran
Returns
End

--For Check  TrInserts
--Select * from TSP
--Insert into TSP values (103,'PNTL')
--Drop trigger TrInserts

 Go

-----------------------------------------------------------------------------------------------
--Question No_13
--Answer No_13
--For Create Trigger 
Use StudentDB
Go

Create Procedure SpInsert_Up_del_Output
@TaskType varchar(20),
@Tspid int,
@TspName varchar(20),
@count int Output
as
Begin

If @TaskType='Insert'
Begin try
Insert into TSP Values (@Tspid,@TspName)
End try

Begin Catch
Select
ERROR_MESSAGE()as ERRORMESSEGES,
ERROR_NUMBER()AS ERRORNUMBER,
ERROR_LINE()AS ERRORLINE,
ERROR_STATE()AS ERRORSTATE
--throw 51000,'Select Error',1
End Catch

if @TaskType='Update'
Begin 
Update TSP Set TspName=@TspName where TspId=@Tspid
End

if @TaskType='Delete'
Begin 
Delete from TSP where TspId=@Tspid
End 

if @TaskType='Count'
Begin
Select @count= Count(TspId) From TSP
End
End

Go

--For Check
Select * from TSP

Exec SpInsert_Up_del_Output 'Insert',204,'CZN',''
Exec SpInsert_Up_del_Output 'Update',204,'BITL',''
Exec SpInsert_Up_del_Output 'Delete',204,'',''

Declare @SCount int
Exec SpInsert_Up_del_Output 'Count','','',@SCount OutPut
Select @SCount as [Number Of TSP]

-----------------------------------------------------------------------------------------------

--Question No_14
--Answer No_14

--For CTE 
Use StudentDB
go

with StudentCount (StudentId, TotalStudent)
As
(
Select StudentId ,Count(StudentId) from Student group by StudentId
)
Select Sum(s.StudentId) as [Total Student],StudentFName+ ' ' +StudentLName as[Student Name] from StudentCount as St join 
Student as S 
On S.StudentId=St.StudentId group by s.StudentFName,s.StudentLName order by [Total Student];

go
--------------------------------------------------------------------------------------------------------------
--For Create Case 

--Question No_15
--Answer No_15

--Simple Case
Use StudentDB
Go

Select HobbyId,HobbyType,
Case HobbyType when 'Football' then 'Favourit'
when 'Volleyball' then 'Not Favourite'
End as[Hobby Taype]
from Hobby

Go

--Search Case
Use StudentDB
Go

Select HobbyId,HobbyType,
Case when HobbyId=201 then 'Favourit'
when HobbyId=202 then 'Not Favourite'
else 'Not Allow'
End as[Hobby Taype]
from Hobby

Go
--------------------------------------------------------------------------------------------------------------------------------
--Question No_16
--Answer No_16
--For Create Cursor
Use StudentDB
Go

Create Table #Cursor (Id int, CursorName varchar(20))

Insert into #Cursor values(304,'Web Design')
Insert into #Cursor values(305,'Graphics Design')
Insert into #Cursor values(306,'Data Base')

Declare @Name varchar(20),@id int
Declare SubjectsCursor cursor for
Select * from #Cursor
Open SubjectsCursor
Fetch next from SubjectsCursor into @id,@Name
While (@@FETCH_STATUS=0)
Begin
Insert into Subjects values(@id,@Name) 
Fetch next from SubjectsCursor into @id,@Name
End
Close SubjectsCursor
Deallocate SubjectsCursor

Go
--Select * from Subjects
 
--------------------------------------------------------------------------------------------------------------------------

--Question No_17
--Answer No_17
--For Clustered index 

Use StudentDB 
Go

Create table ForClustered
(
ClusteredId int primary key Nonclustered not null,
ClusteredType Varchar (10));

Create Clustered index IX_ClusteredType on ForClustered(ClusteredType)

Exec sp_helpindex ForClustered;

Go
----------------------------------------------------------------------------------------------------------------------------


--Question No_18
--Answer No_18
--For Transaction Commit

Use StudentDB 
go

Begin Tran
Insert into Relation_t values (1,101,301);
Commit Tran

--Transaction Commit Rollback
Use StudentDB 
go

Begin Try
Begin Tran

Insert into Relation_t values (1,101,301);
Insert into Relation_t values (2,101,301);

Commit Tran
End Try

begin catch
Rollback tran 
End Catch

Go
------------------------------------------------------------------------------------------------------------------------------------------
--End Projects