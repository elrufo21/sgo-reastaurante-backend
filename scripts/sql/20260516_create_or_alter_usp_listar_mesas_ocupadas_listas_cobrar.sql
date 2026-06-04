IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Combinacion_Mesas_id_mesa_IdOrden'
      AND object_id = OBJECT_ID('dbo.Combinacion_Mesas')
)
BEGIN
    CREATE INDEX IX_Combinacion_Mesas_id_mesa_IdOrden
        ON dbo.Combinacion_Mesas (id_mesa ASC, IdOrden DESC);
END
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.indexes
    WHERE name = 'IX_Tbl_Orden_Pedido_Estado_IdOrden'
      AND object_id = OBJECT_ID('dbo.Tbl_Orden_Pedido')
)
BEGIN
    CREATE INDEX IX_Tbl_Orden_Pedido_Estado_IdOrden
        ON dbo.Tbl_Orden_Pedido (Estado ASC, IdOrden DESC)
        INCLUDE (ClienteId, FechaOrden, HoraFin, OrdenSerie, OrdenNumero, NroMesas, Usuario, Total);
END
GO

IF OBJECT_ID('dbo.uspListarMesasOcupadasListasCobrar', 'P') IS NOT NULL
    DROP PROCEDURE dbo.uspListarMesasOcupadasListasCobrar;
GO

CREATE PROCEDURE [dbo].[uspListarMesasOcupadasListasCobrar]
AS
BEGIN
    SET NOCOUNT ON;

    ;WITH FuenteMesas AS
    (
        -- Camino principal: mesas registradas en tabla de combinacion
        SELECT
            c.id_mesa,
            o.IdOrden,
            o.ClienteId,
            o.FechaOrden,
            o.HoraFin,
            o.OrdenSerie,
            o.OrdenNumero,
            o.NroMesas,
            o.Usuario,
            o.Total,
            o.Estado AS EstadoOrden
        FROM dbo.Combinacion_Mesas c
        INNER JOIN dbo.Tbl_Orden_Pedido o
            ON o.IdOrden = c.IdOrden
        WHERE UPPER(LTRIM(RTRIM(ISNULL(o.Estado, '')))) NOT IN ('ANULADO', 'CANCELADO')

        UNION ALL

        -- Fallback: mesa unidad cuando no existe fila en Combinacion_Mesas
        SELECT
            CONVERT(int, x.MesaToken) AS id_mesa,
            o.IdOrden,
            o.ClienteId,
            o.FechaOrden,
            o.HoraFin,
            o.OrdenSerie,
            o.OrdenNumero,
            o.NroMesas,
            o.Usuario,
            o.Total,
            o.Estado AS EstadoOrden
        FROM dbo.Tbl_Orden_Pedido o
        CROSS APPLY
        (
            SELECT REPLACE(REPLACE(UPPER(LTRIM(RTRIM(ISNULL(o.NroMesas, '')))), 'MESA', ''), ' ', '') AS MesaToken
        ) x
        WHERE UPPER(LTRIM(RTRIM(ISNULL(o.Estado, '')))) NOT IN ('ANULADO', 'CANCELADO')
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.Combinacion_Mesas c2
              WHERE c2.IdOrden = o.IdOrden
          )
          AND x.MesaToken <> ''
          AND x.MesaToken NOT LIKE '%[^0-9]%'
    ),
    OrdenesActivasPorMesa AS
    (
        SELECT
            f.id_mesa,
            f.IdOrden,
            f.ClienteId,
            f.FechaOrden,
            f.HoraFin,
            f.OrdenSerie,
            f.OrdenNumero,
            f.NroMesas,
            f.Usuario,
            f.Total,
            f.EstadoOrden,
            ROW_NUMBER() OVER (
                PARTITION BY f.id_mesa
                ORDER BY f.IdOrden DESC
            ) AS rn
        FROM FuenteMesas f
    )
    SELECT
        m.id_mesa AS IdMesa,
        m.nro_mesa AS NroMesa,
        m.capacidad AS Capacidad,
        m.ubicacion AS Ubicacion,
        m.estado AS EstadoMesa,
        x.IdOrden,
        x.ClienteId,
        x.FechaOrden,
        x.HoraFin,
        x.OrdenSerie,
        x.OrdenNumero,
        (ISNULL(x.OrdenSerie, '') + '-' + ISNULL(x.OrdenNumero, '')) AS Ticket,
        x.NroMesas,
        x.Usuario,
        x.Total,
        x.EstadoOrden,
        DATEDIFF(MINUTE, x.FechaOrden, GETDATE()) AS MinutosAbierta
    FROM OrdenesActivasPorMesa x
    INNER JOIN dbo.tbl_mesa m
        ON m.id_mesa = x.id_mesa
    WHERE x.rn = 1
      AND UPPER(LTRIM(RTRIM(ISNULL(m.estado, '')))) <> 'LIBRE'
    ORDER BY
        x.FechaOrden ASC,
        m.id_mesa ASC;
END;
GO
