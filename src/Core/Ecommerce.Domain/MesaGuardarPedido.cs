namespace Ecommerce.Domain;

public class MesaGuardarPedidoRequest
{
    public long IdOrden { get; set; } = 0;
    public long ClienteId { get; set; } = 1;
    public string Serie { get; set; } = "0001";
    public string? Numero { get; set; }
    public string? NroMesas { get; set; }
    public string? Observaciones { get; set; }
    public string Usuario { get; set; } = string.Empty;
    public decimal? Total { get; set; }
    public string EstadoOrden { get; set; } = "REGISTRADO";
    public string EstadoMesa { get; set; } = "OCUPADA";
    public string TipoRegistro { get; set; } = "-";
    public List<int> Mesas { get; set; } = new();
    public List<MesaGuardarPedidoDetalleRequest> Detalles { get; set; } = new();
}

public class MesaGuardarPedidoDetalleRequest
{
    public long DetalleId { get; set; } = 0;
    public long IdProducto { get; set; }
    public decimal Cantidad { get; set; }
    public decimal PrecioUnitario { get; set; }
    public decimal? Importe { get; set; }
    public string EstadoDetalle { get; set; } = "PENDIENTE";
}

public class MesaGuardarPedidoResponse
{
    public bool Ok { get; set; }
    public string Resultado { get; set; } = string.Empty;
    public long? IdOrden { get; set; }
    public string EstadoMesa { get; set; } = string.Empty;
}
