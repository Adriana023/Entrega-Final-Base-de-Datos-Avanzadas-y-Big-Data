SELECT 
    d.NombreMes,
    p.NombreCategoria,
    c.NombreCanal,
    v.NombreVendedor,
    COUNT(f.ClaveHechoVenta) AS Ordenes,
    SUM(f.MontoVenta) AS Ventas_Netas
FROM dbo.FactVentas f
JOIN dbo.DimFecha d    ON f.ClaveFechaOrden = d.ClaveFecha
JOIN dbo.DimProducto p ON f.ClaveProducto   = p.ClaveProducto
JOIN dbo.DimCanal c    ON f.ClaveCanal      = c.ClaveCanal
JOIN dbo.DimVendedor v ON f.ClaveVendedor   = v.ClaveVendedor
JOIN dbo.DimCliente cl ON f.ClaveCliente    = cl.ClaveCliente
GROUP BY 
    d.NombreMes, 
    p.NombreCategoria, 
    c.NombreCanal, 
    v.NombreVendedor
ORDER BY Ventas_Netas DESC;
GO