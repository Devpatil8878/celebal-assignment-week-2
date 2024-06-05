

CREATE FUNCTION FormatDateYYMMDD
(
    @InputDate DATETIME
)
RETURNS VARCHAR(9)
AS
BEGIN
    DECLARE @FormattedDate VARCHAR(9);

    SET @FormattedDate = FORMAT(@InputDate, 'yy yyMMdd');

    RETURN @FormattedDate;
END;
GO
