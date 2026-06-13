using System.Net;
using Ecommerce.Api.Interfaces;
using Ecommerce.Api.Services;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;

[ApiController]
[Route("api/sunat")]
public class SunatController : ControllerBase
{
    private readonly ISunatAuthService _sunatAuthService;
    private readonly ILogger<SunatController> _logger;

    public SunatController(ISunatAuthService sunatAuthService, ILogger<SunatController> logger)
    {
        _sunatAuthService = sunatAuthService;
        _logger = logger;
    }

    [HttpGet("token", Name = "GetSunatToken")]
    [ProducesResponseType((int)HttpStatusCode.OK)]
    public async Task<IActionResult> GetToken()
    {
        try
        {
            var token = await _sunatAuthService.GetAccessTokenAsync();
            return Ok(new { accessToken = token });
        }
        catch (InvalidOperationException ex)
        {
            _logger.LogWarning(ex, "Configuracion SUNAT incompleta.");
            return BadRequest(new { message = ex.Message });
        }
        catch (SunatApiException ex)
        {
            _logger.LogError(ex, "SUNAT devolvio error al obtener token. Url: {Url}. Body: {Body}", ex.RequestUrl, ex.ResponseBody);
            return StatusCode((int)ex.StatusCode, new
            {
                message = "SUNAT devolvio error al obtener token.",
                statusCode = (int)ex.StatusCode,
                requestUrl = ex.RequestUrl,
                sunatResponse = ex.ResponseBody,
                sunatDebug = ex.Debug
            });
        }
        catch (HttpRequestException ex)
        {
            _logger.LogError(ex, "No se pudo obtener token SUNAT.");
            return StatusCode((int)HttpStatusCode.BadGateway, new
            {
                message = "No se pudo obtener token de SUNAT.",
                detail = ex.Message
            });
        }
    }
}
