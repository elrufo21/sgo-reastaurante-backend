namespace Ecommerce.Domain;

public class MesaListaCobro
{
    public int IdMesa { get; set; }
    public string? NroMesa { get; set; }
    public int? Capacidad { get; set; }
    public string? Ubicacion { get; set; }
    public string? EstadoMesa { get; set; }
    public long IdOrden { get; set; }
    public long? ClienteId { get; set; }
    public DateTime? FechaOrden { get; set; }
    public DateTime? HoraFin { get; set; }
    public string? OrdenSerie { get; set; }
    public string? OrdenNumero { get; set; }
    public string? Ticket { get; set; }
    public string? NroMesas { get; set; }
    public string? Usuario { get; set; }
    public decimal? Total { get; set; }
    public string? EstadoOrden { get; set; }
    public int? MinutosAbierta { get; set; }
}
