CREATE PROCEDURE [dbo].[UpdateUserProfile]
	@EmployeeId AS INT,
	@Countries AS VARCHAR(600) -- Example "120,12,7"
AS

BEGIN

		-- Removed any existing contries from the database that are no longer in the @Countries list 
		DELETE FROM [dbo].[EmployeeCountries]
			WHERE [CountryID] NOT IN (SELECT LTRIM(RTRIM(Split.a.value('.', 'VARCHAR(600)'))) AS CountryID  
			FROM  (SELECT CAST ('<M>' + REPLACE(@Countries, ',', '</M><M>') + '</M>' AS XML) AS String) 
			AS A CROSS APPLY String.nodes ('/M') AS Split(a)) 	
			AND EmployeeId = @EmployeeId;

		-- Get updated/new Countries in the @Countries list
		WITH CountriesCTE (EmployeeId, CountryID)  
		AS  
		(
		SELECT @EmployeeId AS EmployeeId, LTRIM(RTRIM(Split.a.value('.', 'VARCHAR(600)'))) AS CountryID  
			FROM  (SELECT CAST ('<M>' + REPLACE(@Countries, ',', '</M><M>') + '</M>' AS XML) AS String) 
			AS A CROSS APPLY String.nodes ('/M') AS Split(a) WHERE @Countries <> ''
		)

		-- Insert new Countries that are not in the system already
		INSERT INTO [dbo].[EmployeeCountries] ([EmployeeId], [CountryID])     
		SELECT c.EmployeeId, c.CountryID FROM CountriesCTE c
			LEFT JOIN [dbo].[EmployeeCountries] e ON c.EmployeeId = e.EmployeeId AND c.CountryID = e.CountryID
			WHERE e.EmployeeId IS NULL AND e.CountryID IS NULL


END

