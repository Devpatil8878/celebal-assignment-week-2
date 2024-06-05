CREATE VIEW MyProducts AS
SELECT 
    p.ProductID,
    p.Name AS ProductName,
    p.QuantityPerUnit,
    p.UnitPrice,
    s.CompanyName,
    c.Name AS CategoryName
FROM 
    Production.Product p
    JOIN Production.Supplier s ON p.SupplierID = s.SupplierID
    JOIN Production.Category c ON p.CategoryID = c.CategoryID
WHERE 
    p.Discontinued = 0;
