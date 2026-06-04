CREATE OR ALTER PROCEDURE [dbo].[MRDuenasB]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        'Categoria|Productos[' +
        ISNULL(
            (
                SELECT STUFF(
                    (
                        SELECT
                            '¬' + CONVERT(varchar, s.IdSubLinea) +
                            '|' + s.NombreSublinea
                        FROM Sublinea s
                        ORDER BY s.NombreSublinea ASC
                        FOR XML PATH('')
                    ),
                    1,
                    1,
                    ''
                )
            ),
            '~'
        ) +
        '[' +
        ISNULL(
            (
                SELECT STUFF(
                    (
                        SELECT
                            '¬' + CONVERT(varchar, p.IdProducto) +
                            '|' + CONVERT(varchar, p.ProductoNombre) +
                            '|' + CONVERT(varchar, p.ProductoVenta) +
                            '|' + CONVERT(varchar, p.ProductoCantidad) +
                            '|' + p.ProductoUM +
                            '|' + CONVERT(varchar, p.ProductoCosto) +
                            '|' + CONVERT(varchar, s.EnviarIMP) +
                            '|' + CONVERT(varchar, p.IdSubLinea)
                        FROM Producto p
                        INNER JOIN Sublinea s
                            ON s.IdSubLinea = p.IdSubLinea
                        WHERE p.ProductoEstado = 'BUENO'
                        ORDER BY s.NombreSublinea, p.ProductoNombre ASC
                        FOR XML PATH('')
                    ),
                    1,
                    1,
                    ''
                )
            ),
            '~'
        );
END;
