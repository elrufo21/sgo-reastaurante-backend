namespace Ecommerce.Domain;

public class MesaCocinaPedidoItem
{
    public int IdMesa { get; set; }
    public string? NroMesa { get; set; }
    public string? EstadoMesa { get; set; }
    public long IdOrden { get; set; }
    public string EstadoOrden { get; set; } = string.Empty;
    public string? Observaciones { get; set; }
    public string? Usuario { get; set; }
    public DateTime? FechaOrden { get; set; }
    public decimal? Total { get; set; }
    public List<MesaPedidoDetalle> Detalles { get; set; } = new();
}
