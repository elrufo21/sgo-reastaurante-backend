using System.Net;
using Ecommerce.Application.Contracts.Mesas;
using Ecommerce.Domain;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class MesaController : ControllerBase
{
    private static readonly HashSet<string> EstadosPedidoPermitidos = new(StringComparer.OrdinalIgnoreCase)
    {
        "REGISTRADO",
        "EN_PREPARACION",
        "EN_DESPACHO",
        "TERMINADO",
        "CANCELADO",
        "ANULADO",
        "ENVIADO"
    };

    private readonly IMesa _mesaRepository;

    public MesaController(IMesa mesaRepository)
    {
        _mesaRepository = mesaRepository;
    }

    [AllowAnonymous]
    [HttpGet("list", Name = "GetMesaList")]
    [ProducesResponseType(typeof(IReadOnlyList<Mesa>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<Mesa>>> GetMesaList(
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50,
        CancellationToken cancellationToken = default)
    {
        return Ok(await _mesaRepository.ListarAsync(page, pageSize, cancellationToken));
    }

    [AllowAnonymous]
    [HttpGet("{idMesa:int}/orden-activa", Name = "GetMesaOrdenActiva")]
    [ProducesResponseType(typeof(MesaOrdenActiva), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<MesaOrdenActiva?>> GetMesaOrdenActiva(
        int idMesa,
        CancellationToken cancellationToken = default)
    {
        if (idMesa <= 0)
        {
            return BadRequest("idMesa debe ser mayor a 0.");
        }

        return Ok(await _mesaRepository.ObtenerOrdenActivaPorMesaAsync(idMesa, cancellationToken));
    }

    [AllowAnonymous]
    [HttpGet("{idMesa:int}/seleccion", Name = "GetMesaSeleccion")]
    [ProducesResponseType(typeof(MesaSeleccion), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<MesaSeleccion>> GetMesaSeleccion(
        int idMesa,
        [FromQuery] string serie = "0001",
        CancellationToken cancellationToken = default)
    {
        if (idMesa <= 0)
        {
            return BadRequest("idMesa debe ser mayor a 0.");
        }

        return Ok(await _mesaRepository.ResolverSeleccionMesaAsync(idMesa, serie, cancellationToken));
    }

    [AllowAnonymous]
    [HttpGet("pedidos", Name = "ListarPedidosPorEstadoMesa")]
    [ProducesResponseType(typeof(IReadOnlyList<MesaPedidoEstadoItem>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<MesaPedidoEstadoItem>>> ListarPedidosPorEstado(
        [FromQuery] string? estado = null,
        [FromQuery] string? estados = null,
        [FromQuery] int page = 1,
        [FromQuery] int pageSize = 50,
        CancellationToken cancellationToken = default)
    {
        if (page <= 0)
        {
            return BadRequest("page debe ser mayor a 0.");
        }

        if (pageSize <= 0)
        {
            return BadRequest("pageSize debe ser mayor a 0.");
        }

        var estadosNormalizados = ParseEstadosPedido(estado, estados);
        if (estadosNormalizados is not null && estadosNormalizados.Any(x => !EstadosPedidoPermitidos.Contains(x)))
        {
            return BadRequest("Estado no permitido. Use: REGISTRADO, EN_PREPARACION, EN_DESPACHO, TERMINADO, CANCELADO, ANULADO o ENVIADO.");
        }

        return Ok(await _mesaRepository.ListarPedidosPorEstadoAsync(estadosNormalizados, page, pageSize, cancellationToken));
    }

    [AllowAnonymous]
    [HttpGet("cocina/mesas", Name = "ListarMesasCocinaConDetalle")]
    [ProducesResponseType(typeof(IReadOnlyList<MesaCocinaPedidoItem>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<MesaCocinaPedidoItem>>> ListarMesasCocinaConDetalle(
        [FromQuery] string? estados = "REGISTRADO,EN_PREPARACION",
        CancellationToken cancellationToken = default)
    {
        var estadosNormalizados = ParseEstadosPedido(null, estados) ?? new List<string> { "REGISTRADO", "EN_PREPARACION" };
        if (estadosNormalizados.Any(x => !EstadosPedidoPermitidos.Contains(x)))
        {
            return BadRequest("Estado no permitido. Use: REGISTRADO, EN_PREPARACION, EN_DESPACHO, TERMINADO, CANCELADO, ANULADO o ENVIADO.");
        }

        var pedidos = await _mesaRepository.ListarPedidosPorEstadoAsync(estadosNormalizados, 1, 500, cancellationToken);
        var mesaIds = pedidos
            .Where(x => x.IdMesa.HasValue && x.IdMesa.Value > 0)
            .Select(x => x.IdMesa!.Value)
            .Distinct()
            .ToList();

        var tareas = mesaIds
            .Select(idMesa => _mesaRepository.ResolverSeleccionMesaAsync(idMesa, "0001", cancellationToken))
            .ToArray();

        var selecciones = await Task.WhenAll(tareas);
        var resultado = new List<MesaCocinaPedidoItem>();

        foreach (var seleccion in selecciones)
        {
            if (!seleccion.TieneOrdenActiva || seleccion.Cabecera is null)
            {
                continue;
            }

            var estadoOrden = NormalizarEstadoPedido(seleccion.Cabecera.EstadoOrden);
            if (!estadosNormalizados.Contains(estadoOrden, StringComparer.OrdinalIgnoreCase))
            {
                continue;
            }

            resultado.Add(new MesaCocinaPedidoItem
            {
                IdMesa = seleccion.IdMesa,
                NroMesa = seleccion.NroMesa,
                EstadoMesa = seleccion.EstadoMesa,
                IdOrden = seleccion.Cabecera.IdOrden,
                EstadoOrden = seleccion.Cabecera.EstadoOrden,
                Observaciones = seleccion.Cabecera.Observaciones,
                Usuario = seleccion.Cabecera.Usuario,
                FechaOrden = ParseFechaOrdenTexto(seleccion.Cabecera.FechaOrdenTexto),
                Total = seleccion.Detalles.Sum(d => d.Importe),
                Detalles = seleccion.Detalles
            });
        }

        return Ok(resultado
            .OrderBy(x => x.FechaOrden ?? DateTime.MinValue)
            .ThenBy(x => x.IdMesa)
            .ToList());
    }

    [AllowAnonymous]
    [HttpPut("pedido/{idOrden:long}/estado", Name = "ActualizarEstadoPedidoMesa")]
    [ProducesResponseType(typeof(MesaActualizarEstadoPedidoResponse), (int)HttpStatusCode.OK)]
    [ProducesResponseType((int)HttpStatusCode.BadRequest)]
    [ProducesResponseType((int)HttpStatusCode.NotFound)]
    public async Task<ActionResult<MesaActualizarEstadoPedidoResponse>> ActualizarEstadoPedido(
        long idOrden,
        [FromBody] MesaActualizarEstadoPedidoRequest request,
        CancellationToken cancellationToken = default)
    {
        if (idOrden <= 0)
        {
            return BadRequest("idOrden debe ser mayor a 0.");
        }

        if (request is null)
        {
            return BadRequest("Payload requerido.");
        }

        var estadoNormalizado = NormalizarEstadoPedido(request.Estado);
        if (string.IsNullOrWhiteSpace(estadoNormalizado))
        {
            return BadRequest("Estado es requerido.");
        }

        if (!EstadosPedidoPermitidos.Contains(estadoNormalizado))
        {
            return BadRequest("Estado no permitido. Use: REGISTRADO, EN_PREPARACION, EN_DESPACHO, TERMINADO, CANCELADO, ANULADO o ENVIADO.");
        }

        request.IdOrden = idOrden;
        request.Estado = estadoNormalizado;

        var response = await _mesaRepository.ActualizarEstadoPedidoAsync(request, cancellationToken);
        if (!response.Ok && string.Equals(response.Resultado, "orden_no_encontrada", StringComparison.OrdinalIgnoreCase))
        {
            return NotFound(response);
        }

        return Ok(response);
    }

    [AllowAnonymous]
    [HttpPost("pedido/guardar", Name = "GuardarPedidoMesa")]
    [ProducesResponseType(typeof(MesaGuardarPedidoResponse), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<MesaGuardarPedidoResponse>> GuardarPedidoMesa(
        [FromBody] MesaGuardarPedidoRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request is null)
        {
            return BadRequest("Payload requerido.");
        }

        if (string.IsNullOrWhiteSpace(request.Usuario))
        {
            return BadRequest("Usuario es requerido.");
        }

        if (request.Detalles is null || request.Detalles.Count == 0)
        {
            return BadRequest("Debe enviar al menos un item en Detalles.");
        }

        if (request.Mesas is null)
        {
            request.Mesas = new List<int>();
        }

        var response = await _mesaRepository.GuardarPedidoAsync(request, cancellationToken);
        return Ok(response);
    }

    [AllowAnonymous]
    [HttpPost("combinadas/agregar", Name = "AgregarMesaCombinada")]
    [ProducesResponseType(typeof(MesaCombinacionOperacionResponse), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<MesaCombinacionOperacionResponse>> AgregarMesaCombinada(
        [FromBody] MesaCombinacionOperacionRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request is null)
        {
            return BadRequest("Payload requerido.");
        }

        if (request.IdOrden <= 0)
        {
            return BadRequest("IdOrden debe ser mayor a 0.");
        }

        if (request.IdMesa <= 0)
        {
            return BadRequest("IdMesa debe ser mayor a 0.");
        }

        var response = await _mesaRepository.AgregarMesaCombinadaAsync(request, cancellationToken);
        return Ok(response);
    }

    [AllowAnonymous]
    [HttpPost("combinadas/quitar", Name = "QuitarMesaCombinada")]
    [ProducesResponseType(typeof(MesaCombinacionOperacionResponse), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<MesaCombinacionOperacionResponse>> QuitarMesaCombinada(
        [FromBody] MesaCombinacionOperacionRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request is null)
        {
            return BadRequest("Payload requerido.");
        }

        if (request.IdOrden <= 0)
        {
            return BadRequest("IdOrden debe ser mayor a 0.");
        }

        if (request.IdMesa <= 0)
        {
            return BadRequest("IdMesa debe ser mayor a 0.");
        }

        var response = await _mesaRepository.QuitarMesaCombinadaAsync(request, cancellationToken);
        return Ok(response);
    }

    [AllowAnonymous]
    [HttpGet("{idOrden:long}/combinadas", Name = "ListarMesasCombinadas")]
    [ProducesResponseType(typeof(IReadOnlyList<MesaCombinada>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<MesaCombinada>>> ListarMesasCombinadas(
        long idOrden,
        CancellationToken cancellationToken = default)
    {
        if (idOrden <= 0)
        {
            return BadRequest("idOrden debe ser mayor a 0.");
        }

        return Ok(await _mesaRepository.ListarMesasCombinadasAsync(idOrden, cancellationToken));
    }

    [AllowAnonymous]
    [HttpGet("libres", Name = "ListarMesasLibres")]
    [ProducesResponseType(typeof(IReadOnlyList<MesaCombinada>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<MesaCombinada>>> ListarMesasLibres(
        CancellationToken cancellationToken = default)
    {
        return Ok(await _mesaRepository.ListarMesasLibresAsync(cancellationToken));
    }

    [AllowAnonymous]
    [HttpGet("ocupadas-listas-cobrar", Name = "ListarMesasOcupadasListasCobrar")]
    [ProducesResponseType(typeof(IReadOnlyList<MesaListaCobro>), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<IReadOnlyList<MesaListaCobro>>> ListarMesasOcupadasListasCobrar(
        CancellationToken cancellationToken = default)
    {
        return Ok(await _mesaRepository.ListarMesasOcupadasListasCobrarAsync(cancellationToken));
    }

    [AllowAnonymous]
    [HttpPost("combinadas/cambiar", Name = "CambiarMesaCombinada")]
    [ProducesResponseType(typeof(MesaCambioResponse), (int)HttpStatusCode.OK)]
    public async Task<ActionResult<MesaCambioResponse>> CambiarMesaCombinada(
        [FromBody] MesaCambioRequest request,
        CancellationToken cancellationToken = default)
    {
        if (request is null)
        {
            return BadRequest("Payload requerido.");
        }

        if (request.IdMesaOcupada <= 0)
        {
            return BadRequest("IdMesaOcupada debe ser mayor a 0.");
        }

        if (request.IdMesaLibre <= 0)
        {
            return BadRequest("IdMesaLibre debe ser mayor a 0.");
        }

        if (request.IdMesaOcupada == request.IdMesaLibre)
        {
            return BadRequest("IdMesaOcupada y IdMesaLibre no pueden ser iguales.");
        }

        var response = await _mesaRepository.CambiarMesaCombinadaAsync(request, cancellationToken);
        return Ok(response);
    }

    private static string NormalizarEstadoPedido(string? estado)
    {
        if (string.IsNullOrWhiteSpace(estado))
        {
            return string.Empty;
        }

        return estado.Trim()
            .Replace(" ", "_", StringComparison.Ordinal)
            .ToUpperInvariant();
    }

    private static DateTime? ParseFechaOrdenTexto(string? value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        var valor = value.Trim();
        return DateTime.TryParse(valor, out var fecha) ? fecha : null;
    }

    private static IReadOnlyList<string>? ParseEstadosPedido(string? estado, string? estados)
    {
        var salida = new List<string>();

        if (!string.IsNullOrWhiteSpace(estado))
        {
            var estadoNormalizado = NormalizarEstadoPedido(estado);
            if (!string.IsNullOrWhiteSpace(estadoNormalizado))
            {
                salida.Add(estadoNormalizado);
            }
        }

        if (!string.IsNullOrWhiteSpace(estados))
        {
            var partes = estados.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
            foreach (var parte in partes)
            {
                var estadoNormalizado = NormalizarEstadoPedido(parte);
                if (!string.IsNullOrWhiteSpace(estadoNormalizado))
                {
                    salida.Add(estadoNormalizado);
                }
            }
        }

        if (salida.Count == 0)
        {
            return null;
        }

        return salida
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToList();
    }
}
