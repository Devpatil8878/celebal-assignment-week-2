

CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT = NULL,
    @Discount DECIMAL(5, 2) = NULL
AS
BEGIN
    -- Declare variables to store the original values
    DECLARE @OriginalUnitPrice DECIMAL(10, 2);
    DECLARE @OriginalQuantity INT;
    DECLARE @OriginalDiscount DECIMAL(5, 2);
    DECLARE @UnitsInStock INT;

    -- Retrieve the original values from the Order Details
    SELECT @OriginalUnitPrice = UnitPrice, 
           @OriginalQuantity = OrderQty, 
           @OriginalDiscount = UnitPriceDiscount
    FROM Sales.SalesOrderDetail
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    -- Retrieve the current stock
    SELECT @UnitsInStock = UnitsInStock
    FROM Production.Product
    WHERE ProductID = @ProductID;

    -- Calculate the new quantity in stock
    IF @Quantity IS NOT NULL
    BEGIN
        SET @UnitsInStock = @UnitsInStock + @OriginalQuantity - @Quantity;
    END

    -- Check if the stock would be negative
    IF @UnitsInStock < 0
    BEGIN
        PRINT 'Failed to update the order. Not enough stock.';
        RETURN;
    END

    -- Update the Order Details
    UPDATE Sales.SalesOrderDetail
    SET UnitPrice = ISNULL(@UnitPrice, @OriginalUnitPrice),
        OrderQty = ISNULL(@Quantity, @OriginalQuantity),
        UnitPriceDiscount = ISNULL(@Discount, @OriginalDiscount)
    WHERE SalesOrderID = @OrderID AND ProductID = @ProductID;

    -- Check if the update was successful
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to update the order. Please try again.';
        RETURN;
    END;

    -- Update the UnitsInStock in the Products table
    UPDATE Production.Product
    SET UnitsInStock = @UnitsInStock
    WHERE ProductID = @ProductID;

    PRINT 'Order updated successfully.';
END;
GO
