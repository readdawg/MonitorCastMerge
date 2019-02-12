
--Create P_PeopleStatus Column in Gaining VIAC
USE VIAC
ALTER TABLE dbo.P_People
ADD P_Peopletatus int;
GO

--Create P_PeopleStatus Column in donor VIAC
USE ToMergeVIAC
ALTER TABLE dbo.P_People
ADD P_PeopleStatus int;
GO

--SET P_PeopleStatus to NULL in donor VIAC
UPDATE ToMergeVIAC.dbo.P_People
SET P_PeopleStatus = NULL;


-- Check donor CardNumber against existing CardNumbers in Gaining P_People table
USE ToMergeVIAC
DECLARE @count int = 1
DECLARE @maxID int 

SET @maxID = (SELECT MAX(PeopleID) FROM ToMergeVIAC.dbo.P_People)

WHILE @count <= @maxID

BEGIN

DECLARE @cardNumber nvarchar(10) = (SELECT CardNumber FROM ToMergeVIAC.dbo.P_People WHERE PeopleID = @count)

DECLARE @sql NVARCHAR(max) = '

				IF NOT EXISTS (SELECT CardNumber FROM VIAC.dbo.P_People WHERE CardNumber = ' + @cardNumber + ')
					BEGIN				

						UPDATE ToMergeVIAC.dbo.P_People						
						SET P_PeopleStatus = 1 WHERE CardNumber = ' + @cardNumber +'
					END				

				ELSE

					BEGIN
						UPDATE ToMergeVIAC.dbo.P_People
						SET P_PeopleStatus = 0 WHERE CardNumber = ' + @cardNumber +'
					END				
				'			

EXEC (@sql)

SET @count = @count + 1
SET @cardNumber = ''

END

GO