namespace Ecommerce.Domain;

public class MesaCambioRequest
{
    public int IdMesaOcupada { get; set; }
    public int IdMesaLibre { get; set; }
}

public class MesaCambioResponse
{
    public bool Ok { get; set; }
    public string Resultado { get; set; } = string.Empty;
    public long IdOrden { get; set; }
    public int IdMesaOcupada { get; set; }
    public int IdMesaLibre { get; set; }
    public string MesasActualizadasCsv { get; set; } = string.Empty;
}
