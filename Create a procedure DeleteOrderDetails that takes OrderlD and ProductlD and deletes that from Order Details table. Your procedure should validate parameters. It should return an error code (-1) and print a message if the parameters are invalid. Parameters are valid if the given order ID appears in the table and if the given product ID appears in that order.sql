

CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @OrderID)
    BEGIN
        PRINT 'Error: The OrderID ' + CAST(@OrderID AS VARCHAR) + ' does not exist';
        RETURN -1;
    END

    IF NOT EXISTS (SELECT 1 FROM Sales.SalesOrderDetail WHERE SalesOrderID = @OrderID AND ProductID = @ProductID)
    BEGIN
        PRINT 'Error: The ProductID ' + CAST(@ProductID AS VARCHAR) + ' does not exist for OrderID ' + CAST(@OrderID AS VARCHAR);
        RETURN -1;
    END

    DELETE FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Error: Failed to delete the record. Please try again.';
        RETURN -1;
    END

    PRINT 'Record deleted successfully.';
    RETURN 0;
END;
GO
