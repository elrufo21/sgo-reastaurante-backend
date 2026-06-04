namespace Ecommerce.Domain;

public class MesaActualizarEstadoPedidoRequest
{
    public long IdOrden { get; set; }
    public string Estado { get; set; } = string.Empty;
}

public class MesaActualizarEstadoPedidoResponse
{
    public bool Ok { get; set; }
    public long IdOrden { get; set; }
    public string? EstadoAnterior { get; set; }
    public string EstadoActual { get; set; } = string.Empty;
    public string Resultado { get; set; } = string.Empty;
}
