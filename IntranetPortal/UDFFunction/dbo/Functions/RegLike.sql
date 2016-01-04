CREATE FUNCTION [dbo].[RegLike]
(@Text NVARCHAR (MAX), @Pattern NVARCHAR (255))
RETURNS BIT
AS
 EXTERNAL NAME [SqlRegularExpressions].[SqlRegularExpressions].[Like]

