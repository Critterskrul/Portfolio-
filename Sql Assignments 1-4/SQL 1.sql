--1) Display the count of the number of rows in the Patient table.
SELECT COUNT(*) AS PatientCount --Counts all rows and labels result as PatientCount
FROM Patient;

--2) Delete a specified record in the ProviderType table and prove that it is deleted. (before and after)
--Show record BEFORE delete
SELECT *
FROM ProviderType
WHERE ProviderType = 'Phlebotomist';

--Delete record
DELETE FROM ProviderType
WHERE ProviderType = 'Phlebotomist';

--Show record AFTER delete to verify removal
SELECT *
FROM ProviderType
WHERE ProviderType = 'Phlebotomist';

--3) Two table implied join qualified with a key value.
SELECT P.FName, P.LName, PA.AilmentID
FROM Patient P, PatientAilment PA --using implied join
WHERE P.PatientID = PA.PatientID -- Joins tables 
  AND P.PatientID = 1; --Filter for specific patient

--4) Three table implied join qualified with a key value.
SELECT P.FName, P.LName, A.Ailment
FROM Patient P, PatientAilment PA, Ailment A
WHERE P.PatientID = PA.PatientID  --Join Patient → PatientAilment
  AND PA.AilmentID = A.AilmentID   --Join PatientAilment → Ailment
  AND P.PatientID = 1;   --Filter by specific patient

/*5) Use twelve SQL functions (such as SUM). This should be twelve queries with at least one function for
each query.*/
-- 1 COUNT total patients
SELECT COUNT(*) FROM Patient;

-- 2 MAX newest DOB 
SELECT MAX(DOB) FROM Patient;

-- 3 MIN oldest DOB
SELECT MIN(DOB) FROM Patient;

-- 4 AVG average height
SELECT AVG(Height) FROM Patient;

-- 5 SUM total of all heights combined
SELECT SUM(Height) FROM Patient;

-- 6 UPPER converts last names to uppercase
SELECT UPPER(LName) FROM Patient;
 
-- 7 LOWER converts first names to lowercase
SELECT LOWER(FName) FROM Patient;

-- 8 LEN length of last name text
SELECT LEN(LName) FROM Patient;

-- 9 GETDATE current system date/time
SELECT GETDATE();

-- 10 YEAR extracts birth year
SELECT YEAR(DOB) FROM Patient;

-- 11 ISNULL replaces NULL middle names with N/A
SELECT ISNULL(MName, 'N/A') FROM Patient;

-- 12 CAST converts height decimal → integer
SELECT CAST(Height AS INT) FROM Patient;

--6) Write an SQL statement that utilizes 'like' in the where clause.
SELECT *
FROM Patient
WHERE LName LIKE 'S%'; --only shows Last names that start with S

/*7) Demonstrate the use of the rowcount feature to return 4 rows from a table that has more than 4 rows.
Then demonstrate the use of the rowcount feature to reset the number of rows returned to all of the rows in 
a table. Demonstrate an alternative to rowcount that has similar functionality. */
SET ROWCOUNT 4; --sets row count to 4
SELECT * FROM Patient;

SET ROWCOUNT 0; --sets row count to 0
SELECT * FROM Patient;

SELECT TOP 4 * --Alternative method to limit rows
FROM Patient;

--8) Create a SQL routine to insert values into the Ailment table.
Select * from Ailment  --Displays current ailments

Insert Into Ailment --insert
    (AilmentID, Ailment)
Values
    ('26', 'Broken Ankle') --Adds new ailment record
    
--9) Create a SQL routine to update one middle name in the Patient table.
UPDATE Patient --updates
SET MName = 'James' --Assign new middle name
WHERE PatientID = 3; --Target specific patient

select * From Patient Where PatientID =3 --Verify update

--10) Create SQL to truncate and populate a new table with at least 10 rows using data you supply in the insert statement. Table must have at least 3 columns and is not a table in the Sick database.
Truncate table Person; --Deletes all existing data
go

Insert into Person --inserts into Person
    (FName, LName)
Values  --Values that will be inserted
    ('Jim', 'Johnson'),
    ('Steve', 'Smith'),
    ('Sara', 'White'),
    ('Alice', 'Brown'),
    ('Bob', 'Davis'),
    ('Carol', 'Miller'),
    ('David', 'Wilson'),
    ('Eva', 'Taylor'),
    ('Frank', 'Anderson'),
    ('Grace', 'Thomas'); --Adds 10 rows

go
Select * From Person; --Verify insert
 
--11) Create a SQL statement that inserts 2 Ailments for a Patient of your choice and 3 Ailments for another Patient of your choice.
Insert into PatientAilment
    (PatientId, AilmentID)
Values
    (26, 13), --Patient 26 ailment 1
    (26, 25), --Patient 26 ailment 2
    (27, 12), --Patient 27 ailment 1
    (27, 22), --Patient 27 ailment 2
    (27, 25); --Patient 27 ailment 3

--12) Create a query that uses Group By with the  Patient and Ailment table.
Select Fname, LName, Count(AilmentID) as AilmentCount
From Patient P, PatientAilment PA 
Where P.PatientID = PA.PatientID --Join condition
Group by FName, LName --Group per patient
Order by AilmentCount Desc --Highest count first

--13) Create a SQL statement that utilizes the substring command.
Select Substring(LName, 2, 4) --Field name, start, end
From Patient

--14) Demonstrate the use of distinct, ascending, descending in a query.
Select Count(*) from Patient  --Total patient count

--Distinct names sorted descending
Select Distinct LName, FName From Patient
Order by LName, Fname Desc 

--Distinct names sorted ascending
Select Distinct LName, FName From Patient
Order by LName, FName Asc

--15) Demonstrate @@version
Select @@VERSION --Shows version

--16) How many Ailments are in Ailment table (number, not the list of records).
SELECT COUNT(*) AS TotalAilments --counts total Ailments
FROM Ailment;

--18) Which Patient  had the most Ailments.
SELECT TOP 1 P.PatientID, P.FName, P.LName, COUNT(*) AS AilmentCount --Shows Patient with most Ailments
FROM Patient P
JOIN PatientAilment PA ON P.PatientID = PA.PatientID
GROUP BY P.PatientID, P.FName, P.LName
ORDER BY AilmentCount DESC; --Highest first

--19) Which Provider member had the longest Last Name.
Select LName, Len(LName) as LNameLen
From Provider
Order by LNameLen DESC  --Longest name first

--20) Write a script that creates the data to have a Patient with more than one Ailment as well as a script to display that Patient and their Ailments.
--Insert multiple ailments for patient 5
 Insert into PatientAilment 
    (PatientId, AilmentId, ProviderId)
values
    (5, 14, 10),
    (5, 15, 10)

go

--Display patient + ailments + provider info
Select P.FName, P.LName, Ailment, StartDate, PR.LName
From Patient P, Ailment A, PatientAilment PA, Provider PR
Where P.PatientId = PA.PatientId 
     and A.AilmentID = PA.AilmentID
     and P.PatientID = 5 --Shows only that patient
     and PA.ProviderID = PR.ProviderID 