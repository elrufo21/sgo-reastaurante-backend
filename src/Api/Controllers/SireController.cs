using System.Net;
using Ecommerce.Api.Interfaces;
using Ecommerce.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;

[ApiController]
[Route("api/sire")]
public class SireController : ControllerBase
{
    private readonly ISireService _sireService;
    private readonly ILogger<SireController> _logger;

    public SireController(ISireService sireService, ILogger<SireController> logger)
    {
        _sireService = sireService;
        _logger = logger;
    }

    [HttpGet("compras", Name = "GetSireCompras")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> ObtenerCompras([FromQuery] string periodo)
    {
        if (string.IsNullOrWhiteSpace(periodo))
        {
            return BadRequest(new { message = "El parametro periodo es requerido. Ejemplo: 202606." });
        }

        try
        {
            var result = await _sireService.ObtenerComprasAsync(periodo);
            return Content(result, "application/json");
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Configuracion SIRE compras incompleta.");
            return BadRequest(new { message = ex.Message });
        }
        catch (SunatApiException ex)
        {
            _logger.LogError(ex, "SUNAT SIRE devolvio error en compras. Url: {Url}. Body: {Body}", ex.RequestUrl, ex.ResponseBody);
            return StatusCode((int)ex.StatusCode, new
            {
                message = "SUNAT SIRE devolvio error en compras.",
                statusCode = (int)ex.StatusCode,
                requestUrl = ex.RequestUrl,
                sunatResponse = ex.ResponseBody,
                sunatDebug = ex.Debug
            });
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "No se pudo consultar compras SIRE.");
            return StatusCode((int)HttpStatusCode.BadGateway, new
            {
                message = "No se pudo consultar compras en SIRE.",
                detail = ex.Message
            });
        }
    }

    [HttpGet("ventas", Name = "GetSireVentas")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> ObtenerVentas([FromQuery] string periodo)
    {
        if (string.IsNullOrWhiteSpace(periodo))
        {
            return BadRequest(new { message = "El parametro periodo es requerido. Ejemplo: 202606." });
        }

        try
        {
            var result = await _sireService.ObtenerVentasAsync(periodo);
            return Content(result, "application/json");
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Configuracion SIRE ventas incompleta.");
            return BadRequest(new { message = ex.Message });
        }
        catch (SunatApiException ex)
        {
            _logger.LogError(ex, "SUNAT SIRE devolvio error en ventas. Url: {Url}. Body: {Body}", ex.RequestUrl, ex.ResponseBody);
            return StatusCode((int)ex.StatusCode, new
            {
                message = "SUNAT SIRE devolvio error en ventas.",
                statusCode = (int)ex.StatusCode,
                requestUrl = ex.RequestUrl,
                sunatResponse = ex.ResponseBody,
                sunatDebug = ex.Debug
            });
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "No se pudo consultar ventas SIRE.");
            return StatusCode((int)HttpStatusCode.BadGateway, new
            {
                message = "No se pudo consultar ventas en SIRE.",
                detail = ex.Message
            });
        }
    }

    [HttpGet("ventas/registros", Name = "GetSireVentasRegistros")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> ObtenerRegistrosVentas(
        [FromQuery] string periodo,
        [FromQuery] int maxIntentos = 10,
        [FromQuery] int segundosEspera = 3,
        [FromQuery] string? fecDocumentoDesde = null,
        [FromQuery] string? fecDocumentoHasta = null,
        [FromQuery] string? mtoTotalDesde = null,
        [FromQuery] string? mtoTotalHasta = null,
        [FromQuery] string? numRucAdquiriente = null,
        [FromQuery] string? numCarSunat = null,
        [FromQuery] string? codTipoCDP = null,
        [FromQuery] string? codTipoInconsistencia = null)
    {
        if (string.IsNullOrWhiteSpace(periodo))
        {
            return BadRequest(new { message = "El parametro periodo es requerido. Ejemplo: 202606." });
        }

        try
        {
            var result = await _sireService.ObtenerRegistrosVentasAsync(
                periodo,
                maxIntentos,
                segundosEspera,
                fecDocumentoDesde,
                fecDocumentoHasta,
                mtoTotalDesde,
                mtoTotalHasta,
                numRucAdquiriente,
                numCarSunat,
                codTipoCDP,
                codTipoInconsistencia);
            return Ok(result);
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "No se pudieron obtener registros RVIE automaticamente.");
            return BadRequest(new { message = ex.Message });
        }
        catch (SunatApiException ex)
        {
            _logger.LogError(ex, "SUNAT SIRE devolvio error al obtener registros ventas. Url: {Url}. Body: {Body}", ex.RequestUrl, ex.ResponseBody);
            return StatusCode((int)ex.StatusCode, new
            {
                message = "SUNAT SIRE devolvio error al obtener registros ventas.",
                statusCode = (int)ex.StatusCode,
                requestUrl = ex.RequestUrl,
                sunatResponse = ex.ResponseBody,
                sunatDebug = ex.Debug
            });
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "No se pudo obtener registros ventas SIRE.");
            return StatusCode((int)HttpStatusCode.BadGateway, new
            {
                message = "No se pudo obtener registros ventas en SIRE.",
                detail = ex.Message
            });
        }
    }

    [HttpGet("ventas/periodos", Name = "GetSireVentasPeriodos")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> ObtenerPeriodosVentas([FromQuery] string codLibro = "140000")
    {
        if (string.IsNullOrWhiteSpace(codLibro))
        {
            return BadRequest(new { message = "El parametro codLibro es requerido. Ejemplo: 140000." });
        }

        try
        {
            var result = await _sireService.ObtenerPeriodosVentasAsync(codLibro);
            return Content(result, "application/json");
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Configuracion SIRE periodos ventas incompleta.");
            return BadRequest(new { message = ex.Message });
        }
        catch (SunatApiException ex)
        {
            _logger.LogError(ex, "SUNAT SIRE devolvio error en periodos ventas. Url: {Url}. Body: {Body}", ex.RequestUrl, ex.ResponseBody);
            return StatusCode((int)ex.StatusCode, new
            {
                message = "SUNAT SIRE devolvio error en periodos ventas.",
                statusCode = (int)ex.StatusCode,
                requestUrl = ex.RequestUrl,
                sunatResponse = ex.ResponseBody,
                sunatDebug = ex.Debug
            });
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "No se pudo consultar periodos ventas SIRE.");
            return StatusCode((int)HttpStatusCode.BadGateway, new
            {
                message = "No se pudo consultar periodos ventas en SIRE.",
                detail = ex.Message
            });
        }
    }

    [HttpGet("ventas/ticket", Name = "GetSireVentasTicket")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> ConsultarTicketVentas(
        [FromQuery] string perIni,
        [FromQuery] string perFin,
        [FromQuery] string numTicket,
        [FromQuery] int page = 1,
        [FromQuery] int perPage = 20)
    {
        if (string.IsNullOrWhiteSpace(perIni) || string.IsNullOrWhiteSpace(perFin) || string.IsNullOrWhiteSpace(numTicket))
        {
            return BadRequest(new { message = "Los parametros perIni, perFin y numTicket son requeridos. Ejemplo: perIni=202606&perFin=202606&numTicket=2026..." });
        }

        try
        {
            var result = await _sireService.ConsultarTicketVentasAsync(perIni, perFin, numTicket, page, perPage);
            return Content(result, "application/json");
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Configuracion SIRE ticket ventas incompleta.");
            return BadRequest(new { message = ex.Message });
        }
        catch (SunatApiException ex)
        {
            _logger.LogError(ex, "SUNAT SIRE devolvio error al consultar ticket ventas. Url: {Url}. Body: {Body}", ex.RequestUrl, ex.ResponseBody);
            return StatusCode((int)ex.StatusCode, new
            {
                message = "SUNAT SIRE devolvio error al consultar ticket ventas.",
                statusCode = (int)ex.StatusCode,
                requestUrl = ex.RequestUrl,
                sunatResponse = ex.ResponseBody,
                sunatDebug = ex.Debug
            });
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "No se pudo consultar ticket ventas SIRE.");
            return StatusCode((int)HttpStatusCode.BadGateway, new
            {
                message = "No se pudo consultar ticket ventas en SIRE.",
                detail = ex.Message
            });
        }
    }

    [HttpGet("ventas/archivo", Name = "GetSireVentasArchivo")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> DescargarArchivoVentas(
        [FromQuery] string nomArchivoReporte,
        [FromQuery] string codTipoArchivoReporte = "01",
        [FromQuery] string codLibro = "140000",
        [FromQuery] string? perTributario = null,
        [FromQuery] string? codProceso = null,
        [FromQuery] string? numTicket = null)
    {
        if (string.IsNullOrWhiteSpace(nomArchivoReporte))
        {
            return BadRequest(new { message = "El parametro nomArchivoReporte es requerido. Debe venir desde la consulta del ticket." });
        }

        try
        {
            var bytes = await _sireService.DescargarArchivoVentasAsync(
                nomArchivoReporte,
                codTipoArchivoReporte,
                codLibro,
                perTributario,
                codProceso,
                numTicket);
            var fileName = Path.GetFileName(nomArchivoReporte);
            return File(bytes, "application/octet-stream", string.IsNullOrWhiteSpace(fileName) ? "sire-rvie.zip" : fileName);
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Configuracion SIRE archivo ventas incompleta.");
            return BadRequest(new { message = ex.Message });
        }
        catch (SunatApiException ex)
        {
            _logger.LogError(ex, "SUNAT SIRE devolvio error al descargar archivo ventas. Url: {Url}. Body: {Body}", ex.RequestUrl, ex.ResponseBody);
            return StatusCode((int)ex.StatusCode, new
            {
                message = "SUNAT SIRE devolvio error al descargar archivo ventas.",
                statusCode = (int)ex.StatusCode,
                requestUrl = ex.RequestUrl,
                sunatResponse = ex.ResponseBody,
                sunatDebug = ex.Debug
            });
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "No se pudo descargar archivo ventas SIRE.");
            return StatusCode((int)HttpStatusCode.BadGateway, new
            {
                message = "No se pudo descargar archivo ventas en SIRE.",
                detail = ex.Message
            });
        }
    }
}
