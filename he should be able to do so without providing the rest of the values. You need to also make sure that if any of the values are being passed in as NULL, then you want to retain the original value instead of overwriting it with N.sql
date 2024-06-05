

CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT = NULL,
    @Discount DECIMAL(5, 2) = NULL
AS
BEGIN
    DECLARE @OriginalUnitPrice DECIMAL(10, 2);
    DECLARE @OriginalQuantity INT;
    DECLARE @OriginalDiscount DECIMAL(5, 2);
    DECLARE @UnitsInStock INT;

    SELECT @OriginalUnitPrice = UnitPrice, 
           @OriginalQuantity = OrderQty, 
           @OriginalDiscount = UnitPriceDiscount
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    SELECT @UnitsInStock = UnitsInStock
    FROM Production.Product
    WHERE ProductID = @ProductID;

    IF @Quantity IS NOT NULL
    BEGIN
        SET @UnitsInStock = @UnitsInStock + @OriginalQuantity - @Quantity;
    END

    IF @UnitsInStock < 0
    BEGIN
        PRINT 'Failed to update the order. Not enough stock.';
        RETURN;
    END

    UPDATE Sales.SalesOrderDetail
    SET UnitPrice = ISNULL(@UnitPrice, @OriginalUnitPrice),
        OrderQty = ISNULL(@Quantity, @OriginalQuantity),
        UnitPriceDiscount = ISNULL(@Discount, @OriginalDiscount)
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to update the order. Please try again.';
        RETURN;
    END;

    UPDATE Production.Product
    SET UnitsInStock = @UnitsInStock
    WHERE ProductID = @ProductID;

    PRINT 'Order updated successfully.';
END;
GO
