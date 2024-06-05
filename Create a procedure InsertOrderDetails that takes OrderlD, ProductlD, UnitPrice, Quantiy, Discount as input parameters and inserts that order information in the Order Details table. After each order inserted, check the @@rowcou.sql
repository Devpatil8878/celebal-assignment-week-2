
CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT,
    @Discount DECIMAL(5, 2) = 0
AS
BEGIN
    DECLARE @ProductUnitPrice DECIMAL(10, 2);
    DECLARE @UnitsInStock INT;
    DECLARE @ReorderLevel INT;

    -- Retrieve the product details
    SELECT @ProductUnitPrice = ListPrice, 
           @UnitsInStock = UnitsInStock,
           @ReorderLevel = SafetyStockLevel
    FROM Production.Product
    WHERE ProductID = @ProductID;

    -- Use product ListPrice if UnitPrice is not provided
    IF @UnitPrice IS NULL
        SET @UnitPrice = @ProductUnitPrice;

    -- Check stock availability
    IF @UnitsInStock < @Quantity
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
        RETURN;
    END;

    -- Insert order details
    INSERT INTO Sales.SalesOrderDetail (SalesOrderID, ProductID, UnitPrice, OrderQty, UnitPriceDiscount)
    VALUES (@OrderID, @ProductID, @UnitPrice, @Quantity, @Discount);

    -- Check if the insertion was successful
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
        RETURN;
    END;

    -- Update inventory
    UPDATE Production.Product
    SET UnitsInStock = UnitsInStock - @Quantity
    WHERE ProductID = @ProductID;

    -- Check if the inventory falls below the reorder level
    IF (SELECT UnitsInStock FROM Production.Product WHERE ProductID = @ProductID) < @ReorderLevel
    BEGIN
        PRINT 'Warning: Quantity in stock has dropped below reorder level.';
    END;
END;
GO
