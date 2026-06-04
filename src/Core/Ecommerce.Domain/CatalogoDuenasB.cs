namespace Ecommerce.Domain;

public class CatalogoDuenasBCategoria
{
    public long IdSubLinea { get; set; }
    public string NombreSublinea { get; set; } = string.Empty;
    public List<CatalogoDuenasBProducto> Productos { get; set; } = new();
}

public class CatalogoDuenasBProducto
{
    public long IdProducto { get; set; }
    public string ProductoNombre { get; set; } = string.Empty;
    public decimal ProductoVenta { get; set; }
    public decimal ProductoCantidad { get; set; }
    public string ProductoUM { get; set; } = string.Empty;
    public decimal ProductoCosto { get; set; }
    public string EnviarIMP { get; set; } = string.Empty;
    public long IdSubLinea { get; set; }
}
