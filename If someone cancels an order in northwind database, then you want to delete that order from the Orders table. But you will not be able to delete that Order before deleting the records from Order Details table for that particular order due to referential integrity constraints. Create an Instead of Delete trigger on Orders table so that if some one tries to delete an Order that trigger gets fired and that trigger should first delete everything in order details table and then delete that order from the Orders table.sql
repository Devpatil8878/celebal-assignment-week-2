CREATE TRIGGER trgInsteadOfDeleteOrder
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DELETE FROM OrderDetails
    WHERE OrderID IN (SELECT deleted.OrderID FROM deleted);

    DELETE FROM Orders
    WHERE OrderID IN (SELECT deleted.OrderID FROM deleted);
END;
