CREATE OR ALTER PROCEDURE [dbo].[obtenerIdOrden]
    @id_mesa int
AS
BEGIN
    SET NOCOUNT ON;

    SELECT TOP 1
        CONVERT(nvarchar, o.IdOrden) + '|' +
        CONVERT(nvarchar, REPLACE(o.NroMesas, 'MESA ', ''))
    FROM tbl_orden_pedido o
    INNER JOIN Combinacion_Mesas c
        ON o.IdOrden = c.IdOrden
    INNER JOIN tbl_mesa m
        ON c.id_mesa = m.id_mesa
    WHERE c.id_mesa = @id_mesa
      AND m.estado <> 'LIBRE'
      AND o.estado <> 'ANULADO'
      AND o.estado <> 'CANCELADO'
    ORDER BY o.IdOrden DESC;
END;
