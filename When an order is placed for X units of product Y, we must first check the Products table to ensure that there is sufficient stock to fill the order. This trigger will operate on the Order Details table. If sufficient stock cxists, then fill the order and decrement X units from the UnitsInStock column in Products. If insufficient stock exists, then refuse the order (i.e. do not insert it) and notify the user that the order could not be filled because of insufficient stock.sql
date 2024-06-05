CREATE TRIGGER trgCheckStockAndFillOrder
ON OrderDetails
INSTEAD OF INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ProductID INT, @OrderQty INT;
    
    DECLARE insert_cursor CURSOR FOR
        SELECT ProductID, OrderQty
        FROM inserted;
    
    OPEN insert_cursor;
    
    FETCH NEXT FROM insert_cursor INTO @ProductID, @OrderQty;
    
    WHILE @@FETCH_STATUS = 0
    BEGIN
        IF EXISTS (SELECT * FROM Products WHERE ProductID = @ProductID AND UnitsInStock >= @OrderQty)
        BEGIN
            UPDATE Products
            SET UnitsInStock = UnitsInStock - @OrderQty
            WHERE ProductID = @ProductID;
            
            INSERT INTO OrderDetails (OrderID, ProductID, Quantity, UnitPrice)
            SELECT OrderID, ProductID, @OrderQty, UnitPrice
            FROM inserted
            WHERE ProductID = @ProductID;
        END
        ELSE
        BEGIN
            RAISERROR ('Insufficient stock for ProductID %d', 16, 1, @ProductID);
        END;
        
        FETCH NEXT FROM insert_cursor INTO @ProductID, @OrderQty;
    END;
    
    CLOSE insert_cursor;
    DEALLOCATE insert_cursor;
END;
