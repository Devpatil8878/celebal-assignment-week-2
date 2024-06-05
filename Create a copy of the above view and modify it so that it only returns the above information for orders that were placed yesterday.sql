CREATE VIEW vwCustomerOrdersYesterday AS
SELECT 
    c.CompanyName,
    o.OrderID,
    o.OrderDate,
    od.ProductID,
    p.Name AS ProductName,
    od.OrderQty AS Quantity,
    od.UnitPrice,
    (od.OrderQty * od.UnitPrice) AS TotalPrice
FROM 
    Sales.Customer c
    JOIN Sales.SalesOrderHeader o ON c.CustomerID = o.CustomerID
    JOIN Sales.SalesOrderDetail od ON o.SalesOrderID = od.SalesOrderID
    JOIN Production.Product p ON od.ProductID = p.ProductID
WHERE
    o.OrderDate = DATEADD(day, -1, GETDATE());
