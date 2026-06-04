namespace Ecommerce.Domain;

public class MesaCombinacionOperacionRequest
{
    public long IdOrden { get; set; }
    public int IdMesa { get; set; }
    public string? IdMesasOrden { get; set; }
}

public class MesaCombinacionOperacionResponse
{
    public bool Ok { get; set; }
    public string Resultado { get; set; } = string.Empty;
    public string MesasIdsCsv { get; set; } = string.Empty;
    public string NroMesas { get; set; } = string.Empty;
    public List<int> Mesas { get; set; } = new();
}

public class MesaCombinada
{
    public int IdMesa { get; set; }
    public string Nombre { get; set; } = string.Empty;
}
