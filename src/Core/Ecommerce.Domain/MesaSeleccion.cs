namespace Ecommerce.Domain;

public class MesaSeleccion
{
    public int IdMesa { get; set; }
    public string NroMesa { get; set; } = string.Empty;
    public string EstadoMesa { get; set; } = string.Empty;
    public bool TieneOrdenActiva { get; set; }
    public string ModoApertura { get; set; } = "NUEVA";
    public string TipoRegistro { get; set; } = "-";
    public string CodigoPedidoOrden { get; set; } = "0";
    public string Serie { get; set; } = "0001";
    public string CorrelativoTicket { get; set; } = string.Empty;
    public MesaPedidoCabecera? Cabecera { get; set; }
    public List<MesaPedidoDetalle> Detalles { get; set; } = new();
}

public class MesaPedidoCabecera
{
    public long IdOrden { get; set; }
    public long ClienteId { get; set; }
    public string ClienteRazon { get; set; } = string.Empty;
    public string FechaOrdenTexto { get; set; } = string.Empty;
    public string HoraFinTexto { get; set; } = string.Empty;
    public string OrdenSerie { get; set; } = string.Empty;
    public string OrdenNumero { get; set; } = string.Empty;
    public string NroMesas { get; set; } = string.Empty;
    public string Observaciones { get; set; } = string.Empty;
    public string Usuario { get; set; } = string.Empty;
    public string EstadoOrden { get; set; } = string.Empty;
}

public class MesaPedidoDetalle
{
    public long DetalleId { get; set; }
    public long IdProducto { get; set; }
    public string ProductoNombre { get; set; } = string.Empty;
    public decimal PrecioUnitario { get; set; }
    public decimal Cantidad { get; set; }
    public decimal Importe { get; set; }
    public decimal ProductoCosto { get; set; }
    public decimal ProductoVentaB { get; set; }
    public long IdOrden { get; set; }
    public string EstadoDetalle { get; set; } = string.Empty;
    public string EnviarIMP { get; set; } = string.Empty;
}
