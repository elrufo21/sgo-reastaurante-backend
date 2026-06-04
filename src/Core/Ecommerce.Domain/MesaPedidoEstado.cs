namespace Ecommerce.Domain;

public class MesaPedidoEstadoItem
{
    public long IdOrden { get; set; }
    public string EstadoOrden { get; set; } = string.Empty;
    public long? ClienteId { get; set; }
    public DateTime? FechaOrden { get; set; }
    public DateTime? HoraFin { get; set; }
    public string? OrdenSerie { get; set; }
    public string? OrdenNumero { get; set; }
    public string? NroMesas { get; set; }
    public string? Usuario { get; set; }
    public decimal? Total { get; set; }
    public int? IdMesa { get; set; }
    public string? EstadoMesa { get; set; }
}
