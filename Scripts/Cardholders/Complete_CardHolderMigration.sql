/*
Title: Merge MonitorCast card holders without duplicates
Create By: Michael Reading
Date: 12 Feb 19
*/

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

-- Copy CardHolder info from donor P_People table to gaining P_People table

USE ToMergeVIAC

INSERT INTO VIAC.dbo.P_People
SELECT ParentPeopleID,
CardNumber,
CardNumber2,
PIN,
UserFlag,
HotStamp,
IssueCode,
ActivateDate,
DeActivateDate,
VacationStartDate,
VacationEndDate,
TmpStartDate,
TmpEndDate,
UseLimits,
UniqueKeyINT,
UniqueKeySTR,
FromActiveDirectory,
AD_Domain,
IsActive,
LastName,
FirstName,
Notes,
Title,
CompanyID,
Department,
PhotoFormat,
PhotoImage,
SignatureFormat,
SignatureImage,
EMailAddress,
PhoneNumber,
SSN,
DOB,
DOH,
DOT,
Address1,
Address2,
City,
State,
ZIP,
Custom1,
Custom2,
Custom3,
Custom4,
Custom5,
Custom6,
Custom7,
Custom8,
Custom9,
Custom10,
Custom11,
Custom12,
Custom13,
Custom14,
Custom15,
Custom16,
LastModifiedDate,
LastModifiedBy,
ProfileID,
MiddleInit,
EmployeeID,
DriverLicence,
DriverLicenceState,
CardFormatID,
UseLimit,
UserLevel,
AssetID,
PhotoThumbnail,
BiometricData,
BioType,
BioFlag,
BioMinScore,
PhoneNumber2,
BadgeTemplateID,
LastBadgePrintedDate,
Flag1,
Flag2,
ExtendedSetting,
CardSpecialStatus,
PhotoImagePath,
isWholeSite,
P_PeopleStatus
FROM ToMergeVIAC.dbo.P_People WHERE P_PeopleStatus = 1;