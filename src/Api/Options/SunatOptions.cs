namespace Ecommerce.Api.Options;

public class SunatOptions
{
    public const string SectionName = "Sunat";

    public string ClientId { get; set; } = string.Empty;
    public string ClientSecret { get; set; } = string.Empty;
    public string Ruc { get; set; } = string.Empty;
    public string UsuarioSol { get; set; } = string.Empty;
    public string ClaveSol { get; set; } = string.Empty;
    public string SireBaseUrl { get; set; } = "https://api-sire.sunat.gob.pe";
    public string Scope { get; set; } = "https://api-sire.sunat.gob.pe";
    public string SeguridadBaseUrl { get; set; } = "https://api-seguridad.sunat.gob.pe";
    public string ComprobanteClientId { get; set; } = string.Empty;
    public string ComprobanteClientSecret { get; set; } = string.Empty;
    public string ComprobanteScope { get; set; } = "https://api.sunat.gob.pe/v1/contribuyente/contribuyentes";
    public string ComprobanteBaseUrl { get; set; } = "https://api.sunat.gob.pe";
    public string RceComprasEndpoint { get; set; } = string.Empty;
    public string RvieVentasEndpoint { get; set; } = string.Empty;
    public string RviePeriodosEndpoint { get; set; } = string.Empty;
    public string RvieTicketEndpoint { get; set; } = string.Empty;
    public string RvieArchivoEndpoint { get; set; } = string.Empty;
    public bool IncludeSensitiveDebug { get; set; }
}
