

CREATE FUNCTION FormatDate
(
    @InputDate DATETIME
)
RETURNS VARCHAR(10)
AS
BEGIN
    DECLARE @FormattedDate VARCHAR(10);

    SET @FormattedDate = FORMAT(@InputDate, 'MM/dd/yyyy');

    RETURN @FormattedDate;
END;
GO
