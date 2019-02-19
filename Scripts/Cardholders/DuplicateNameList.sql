USE JonakinVIAC

SELECT j.CardNumber AS 'Card Number', j.LastName AS 'J Last Name', j.FirstName AS ' J First Name', bn.LastName AS 'BN LastName', bn.FirstName AS 'BN First Name'
, mahs.LastName AS 'Marion LastName', mahs.FirstName AS 'Marion First Name', muhs.LastName AS 'Mullins LastName', muhs.FirstName AS 'Mullins First Name'
FROM dbo.P_People j
INNER JOIN BrittonsNeckVIAC.dbo.P_People bn ON bn.CardNumber = j.CardNumber
INNER JOIN MarionHighSchoolVIAC.dbo.P_People mahs ON mahs.CardNumber = j.CardNumber
INNER JOIN MullinsHighSchoolVIAC.dbo.P_People muhs ON muhs.CardNumber = j.CardNumber