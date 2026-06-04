using Ecommerce.Application.Contracts.Mesas;
using Ecommerce.Domain;
using Ecommerce.Infrastructure.Persistence;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;
using System.Data;
using System.Globalization;
using System.Net;

namespace Ecommerce.Infrastructure.Persistence.Repositories;

public class MesaRepository : IMesa
{
    private readonly string _connectionString;
    private readonly AccesoDatos _accesoDatos;

    public MesaRepository(IConfiguration configuration, AccesoDatos accesoDatos)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Missing connection string: DefaultConnection");
        _accesoDatos = accesoDatos;
    }

    public async Task<IReadOnlyList<Mesa>> ListarAsync(int page = 1, int pageSize = 50, CancellationToken cancellationToken = default)
    {
        var data = await _accesoDatos.EjecutarComandoAsync("uspListarMesasMenuPrincipal", cancellationToken: cancellationToken);
        var lista = ParseMesas(data);
        return ApplyPagination(lista, page, pageSize);
    }

    public async Task<MesaOrdenActiva?> ObtenerOrdenActivaPorMesaAsync(int idMesa, CancellationToken cancellationToken = default)
    {
        var raw = await _accesoDatos.EjecutarComandoAsync(
            "obtenerIdOrden",
            "@id_mesa",
            idMesa.ToString(CultureInfo.InvariantCulture),
            cancellationToken);

        return ParseOrdenActiva(raw);
    }

    public async Task<MesaSeleccion> ResolverSeleccionMesaAsync(int idMesa, string serie = "0001", CancellationToken cancellationToken = default)
    {
        var mesasRaw = await _accesoDatos.EjecutarComandoAsync("uspListarMesasMenuPrincipal", cancellationToken: cancellationToken);
        var mesas = ParseMesas(mesasRaw);
        var mesa = mesas.FirstOrDefault(x => x.IdMesa == idMesa);
        var ordenActiva = await ObtenerOrdenActivaPorMesaAsync(idMesa, cancellationToken);

        var response = new MesaSeleccion
        {
            IdMesa = idMesa,
            NroMesa = mesa?.NroMesa ?? idMesa.ToString(CultureInfo.InvariantCulture),
            EstadoMesa = mesa?.Estado ?? string.Empty,
            TipoRegistro = "-",
            Serie = string.IsNullOrWhiteSpace(serie) ? "0001" : serie.Trim()
        };

        if (ordenActiva is null)
        {
            response.TieneOrdenActiva = false;
            response.ModoApertura = "NUEVA";
            response.CodigoPedidoOrden = "0";
            response.CorrelativoTicket = await ObtenerCorrelativoTicketAsync(response.Serie, cancellationToken);
            return response;
        }

        response.TieneOrdenActiva = true;
        response.ModoApertura = "CARGADA";
        response.CodigoPedidoOrden = ordenActiva.IdOrden.ToString(CultureInfo.InvariantCulture);

        var raw = await _accesoDatos.EjecutarComandoAsync(
            "cargarDatosOrdenPedido",
            "@IdOrden",
            response.CodigoPedidoOrden,
            cancellationToken);

        (response.Cabecera, response.Detalles) = ParsePedido(raw);
        if (response.Cabecera is not null)
        {
            response.CorrelativoTicket = response.Cabecera.OrdenNumero;
            response.Serie = string.IsNullOrWhiteSpace(response.Cabecera.OrdenSerie)
                ? response.Serie
                : response.Cabecera.OrdenSerie;
        }

        return response;
    }

    public async Task<MesaActualizarEstadoPedidoResponse> ActualizarEstadoPedidoAsync(MesaActualizarEstadoPedidoRequest request, CancellationToken cancellationToken = default)
    {
        const string sqlSelect = """
            SELECT TOP 1 Estado
            FROM Tbl_Orden_Pedido
            WHERE IdOrden = @IdOrden;
            """;

        const string sqlUpdate = """
            UPDATE Tbl_Orden_Pedido
            SET Estado = @Estado
            WHERE IdOrden = @IdOrden;
            """;

        await using var con = new SqlConnection(_connectionString);
        await con.OpenAsync(cancellationToken);

        string? estadoAnterior;
        await using (var selectCmd = new SqlCommand(sqlSelect, con))
        {
            selectCmd.Parameters.AddWithValue("@IdOrden", request.IdOrden);
            var raw = await selectCmd.ExecuteScalarAsync(cancellationToken);
            estadoAnterior = raw == null || raw == DBNull.Value
                ? null
                : Convert.ToString(raw, CultureInfo.CurrentCulture)?.Trim();
        }

        if (string.IsNullOrWhiteSpace(estadoAnterior))
        {
            return new MesaActualizarEstadoPedidoResponse
            {
                Ok = false,
                IdOrden = request.IdOrden,
                EstadoActual = request.Estado,
                Resultado = "orden_no_encontrada"
            };
        }

        await using var updateCmd = new SqlCommand(sqlUpdate, con);
        updateCmd.Parameters.AddWithValue("@Estado", request.Estado);
        updateCmd.Parameters.AddWithValue("@IdOrden", request.IdOrden);

        var affected = await updateCmd.ExecuteNonQueryAsync(cancellationToken);
        return new MesaActualizarEstadoPedidoResponse
        {
            Ok = affected > 0,
            IdOrden = request.IdOrden,
            EstadoAnterior = estadoAnterior,
            EstadoActual = request.Estado,
            Resultado = affected > 0 ? "actualizado" : "sin_cambios"
        };
    }

    public async Task<IReadOnlyList<MesaPedidoEstadoItem>> ListarPedidosPorEstadoAsync(
        IReadOnlyList<string>? estados = null,
        int page = 1,
        int pageSize = 50,
        CancellationToken cancellationToken = default)
    {
        (page, pageSize) = NormalizePagination(page, pageSize);

        const string sqlBase = """
            SELECT
                o.IdOrden,
                o.Estado AS EstadoOrden,
                o.ClienteId,
                o.FechaOrden,
                o.HoraFin,
                o.OrdenSerie,
                o.OrdenNumero,
                o.NroMesas,
                o.Usuario,
                o.Total,
                m.id_mesa AS IdMesa,
                m.estado AS EstadoMesa
            FROM Tbl_Orden_Pedido o
            LEFT JOIN Combinacion_Mesas c
                ON c.IdOrden = o.IdOrden
            LEFT JOIN tbl_mesa m
                ON m.id_mesa = c.id_mesa
            """;

        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand { Connection = con };

        var estadosNormalizados = (estados ?? Array.Empty<string>())
            .Where(x => !string.IsNullOrWhiteSpace(x))
            .Select(x => x.Trim().ToUpperInvariant())
            .Distinct(StringComparer.OrdinalIgnoreCase)
            .ToList();

        if (estadosNormalizados.Count == 0)
        {
            cmd.CommandText = $"{sqlBase}{Environment.NewLine}ORDER BY o.IdOrden DESC;";
        }
        else
        {
            var parametros = new List<string>(estadosNormalizados.Count);
            for (var i = 0; i < estadosNormalizados.Count; i++)
            {
                var paramName = $"@Estado{i}";
                parametros.Add(paramName);
                cmd.Parameters.AddWithValue(paramName, estadosNormalizados[i]);
            }

            cmd.CommandText = $"""
                {sqlBase}
                WHERE UPPER(LTRIM(RTRIM(ISNULL(o.Estado, '')))) IN ({string.Join(", ", parametros)})
                ORDER BY o.IdOrden DESC;
                """;
        }

        await con.OpenAsync(cancellationToken);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);

        var lista = new List<MesaPedidoEstadoItem>();
        while (await reader.ReadAsync(cancellationToken))
        {
            lista.Add(new MesaPedidoEstadoItem
            {
                IdOrden = ToLong(reader["IdOrden"]) ?? 0,
                EstadoOrden = ToNullableString(reader["EstadoOrden"]) ?? string.Empty,
                ClienteId = ToLong(reader["ClienteId"]),
                FechaOrden = ToDateTime(reader["FechaOrden"]),
                HoraFin = ToDateTime(reader["HoraFin"]),
                OrdenSerie = ToNullableString(reader["OrdenSerie"]),
                OrdenNumero = ToNullableString(reader["OrdenNumero"]),
                NroMesas = ToNullableString(reader["NroMesas"]),
                Usuario = ToNullableString(reader["Usuario"]),
                Total = ToDecimal(reader["Total"]),
                IdMesa = ToInt(reader["IdMesa"]),
                EstadoMesa = ToNullableString(reader["EstadoMesa"])
            });
        }

        return lista.Skip((page - 1) * pageSize).Take(pageSize).ToList();
    }

    public async Task<MesaGuardarPedidoResponse> GuardarPedidoAsync(MesaGuardarPedidoRequest request, CancellationToken cancellationToken = default)
    {
        var serie = string.IsNullOrWhiteSpace(request.Serie) ? "0001" : request.Serie.Trim();
        var estadoMesa = ResolveEstadoMesa(request);
        var nroMesas = BuildNroMesas(request);
        var numero = string.IsNullOrWhiteSpace(request.Numero)
            ? await ObtenerCorrelativoTicketAsync(serie, cancellationToken)
            : request.Numero.Trim();
        var total = request.Total ?? request.Detalles.Sum(x => ResolveImporte(x));

        var header = string.Join("|",
            request.IdOrden.ToString(CultureInfo.InvariantCulture),
            request.ClienteId.ToString(CultureInfo.InvariantCulture),
            SanitizeField(serie),
            SanitizeField(numero),
            SanitizeField(nroMesas),
            SanitizeField(request.Observaciones),
            SanitizeField(request.Usuario),
            FormatDecimal(total),
            SanitizeField(string.IsNullOrWhiteSpace(request.EstadoOrden) ? "REGISTRADO" : request.EstadoOrden),
            SanitizeField(estadoMesa));

        var details = BuildDetails(request.Detalles);
        var mesas = BuildMesaIds(request.Mesas);
        var payload = $"{header}[{details}[{mesas}";

        var result = await _accesoDatos.EjecutarComandoAsync(
            "uspInsertaCabeceraDetalle",
            "@ListaOrden",
            payload,
            cancellationToken);

        var isOk = string.Equals(result?.Trim(), "true", StringComparison.OrdinalIgnoreCase);
        long? idOrden = request.IdOrden > 0 ? request.IdOrden : null;

        if (idOrden is null && request.Mesas.Count > 0)
        {
            var ordenActiva = await ObtenerOrdenActivaPorMesaAsync(request.Mesas[0], cancellationToken);
            if (ordenActiva is not null && ordenActiva.IdOrden > 0)
            {
                idOrden = ordenActiva.IdOrden;
            }
        }

        return new MesaGuardarPedidoResponse
        {
            Ok = isOk,
            Resultado = string.IsNullOrWhiteSpace(result) ? "error" : result.Trim(),
            IdOrden = idOrden,
            EstadoMesa = estadoMesa
        };
    }

    public Task<MesaCombinacionOperacionResponse> AgregarMesaCombinadaAsync(MesaCombinacionOperacionRequest request, CancellationToken cancellationToken = default)
    {
        return EjecutarOperacionMesaCombinadaAsync(request, 0, cancellationToken);
    }

    public Task<MesaCombinacionOperacionResponse> QuitarMesaCombinadaAsync(MesaCombinacionOperacionRequest request, CancellationToken cancellationToken = default)
    {
        return EjecutarOperacionMesaCombinadaAsync(request, 1, cancellationToken);
    }

    public async Task<MesaCambioResponse> CambiarMesaCombinadaAsync(MesaCambioRequest request, CancellationToken cancellationToken = default)
    {
        var ordenActiva = await ObtenerOrdenActivaPorMesaAsync(request.IdMesaOcupada, cancellationToken);
        if (ordenActiva is null || ordenActiva.IdOrden <= 0)
        {
            return new MesaCambioResponse
            {
                Ok = false,
                Resultado = "sin_orden_activa",
                IdMesaOcupada = request.IdMesaOcupada,
                IdMesaLibre = request.IdMesaLibre
            };
        }

        var mesasActualizadas = ReplaceMesaId(ordenActiva.NroMesa, request.IdMesaOcupada, request.IdMesaLibre);
        var data = string.Join("|",
            ordenActiva.IdOrden.ToString(CultureInfo.InvariantCulture),
            request.IdMesaOcupada.ToString(CultureInfo.InvariantCulture),
            request.IdMesaLibre.ToString(CultureInfo.InvariantCulture),
            mesasActualizadas);

        var result = await _accesoDatos.EjecutarComandoAsync(
            "upsEditarCombinacionMesas",
            "@Data",
            data,
            cancellationToken);

        return new MesaCambioResponse
        {
            Ok = string.Equals(result?.Trim(), "true", StringComparison.OrdinalIgnoreCase),
            Resultado = string.IsNullOrWhiteSpace(result) ? "error" : result.Trim(),
            IdOrden = ordenActiva.IdOrden,
            IdMesaOcupada = request.IdMesaOcupada,
            IdMesaLibre = request.IdMesaLibre,
            MesasActualizadasCsv = mesasActualizadas
        };
    }

    public async Task<IReadOnlyList<MesaCombinada>> ListarMesasCombinadasAsync(long idOrden, CancellationToken cancellationToken = default)
    {
        const string sql = """
            SELECT c.id_mesa
            FROM Combinacion_Mesas c
            WHERE c.IdOrden = @IdOrden
            ORDER BY c.id_mesa ASC;
            """;

        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@IdOrden", idOrden);
        await con.OpenAsync(cancellationToken);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);

        var lista = new List<MesaCombinada>();
        while (await reader.ReadAsync(cancellationToken))
        {
            var idMesa = reader["id_mesa"] == DBNull.Value ? 0 : Convert.ToInt32(reader["id_mesa"], CultureInfo.InvariantCulture);
            if (idMesa <= 0)
            {
                continue;
            }

            lista.Add(new MesaCombinada
            {
                IdMesa = idMesa,
                Nombre = $"MESA {idMesa}"
            });
        }

        return lista;
    }

    public async Task<IReadOnlyList<MesaCombinada>> ListarMesasLibresAsync(CancellationToken cancellationToken = default)
    {
        const string sql = """
            SELECT id_mesa
            FROM tbl_mesa
            WHERE estado = 'LIBRE'
            ORDER BY id_mesa ASC;
            """;

        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(sql, con);
        await con.OpenAsync(cancellationToken);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);

        var lista = new List<MesaCombinada>();
        while (await reader.ReadAsync(cancellationToken))
        {
            var idMesa = reader["id_mesa"] == DBNull.Value ? 0 : Convert.ToInt32(reader["id_mesa"], CultureInfo.InvariantCulture);
            if (idMesa <= 0)
            {
                continue;
            }

            lista.Add(new MesaCombinada
            {
                IdMesa = idMesa,
                Nombre = $"MESA {idMesa}"
            });
        }

        return lista;
    }

    public async Task<IReadOnlyList<MesaListaCobro>> ListarMesasOcupadasListasCobrarAsync(CancellationToken cancellationToken = default)
    {
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand("uspListarMesasOcupadasListasCobrar", con)
        {
            CommandType = CommandType.StoredProcedure,
            CommandTimeout = 300
        };
        await con.OpenAsync(cancellationToken);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);

        var lista = new List<MesaListaCobro>();
        while (await reader.ReadAsync(cancellationToken))
        {
            lista.Add(new MesaListaCobro
            {
                IdMesa = ToInt(reader["IdMesa"]) ?? 0,
                NroMesa = ToNullableString(reader["NroMesa"]),
                Capacidad = ToInt(reader["Capacidad"]),
                Ubicacion = ToNullableString(reader["Ubicacion"]),
                EstadoMesa = ToNullableString(reader["EstadoMesa"]),
                IdOrden = ToLong(reader["IdOrden"]) ?? 0,
                ClienteId = ToLong(reader["ClienteId"]),
                FechaOrden = ToDateTime(reader["FechaOrden"]),
                HoraFin = ToDateTime(reader["HoraFin"]),
                OrdenSerie = ToNullableString(reader["OrdenSerie"]),
                OrdenNumero = ToNullableString(reader["OrdenNumero"]),
                Ticket = ToNullableString(reader["Ticket"]),
                NroMesas = ToNullableString(reader["NroMesas"]),
                Usuario = ToNullableString(reader["Usuario"]),
                Total = ToDecimal(reader["Total"]),
                EstadoOrden = ToNullableString(reader["EstadoOrden"]),
                MinutosAbierta = ToInt(reader["MinutosAbierta"])
            });
        }

        return lista;
    }

    private static IReadOnlyList<Mesa> ApplyPagination(IReadOnlyList<Mesa> source, int page, int pageSize)
    {
        (page, pageSize) = NormalizePagination(page, pageSize);
        return source.Skip((page - 1) * pageSize).Take(pageSize).ToList();
    }

    private static (int page, int pageSize) NormalizePagination(int page, int pageSize)
    {
        var normalizedPage = page < 1 ? 1 : page;
        var normalizedPageSize = pageSize < 1 ? 1 : Math.Min(pageSize, 100);
        return (normalizedPage, normalizedPageSize);
    }

    private static List<Mesa> ParseMesas(string? data)
    {
        var lista = new List<Mesa>();
        if (string.IsNullOrWhiteSpace(data))
        {
            return lista;
        }

        var registros = data.Split('¬', StringSplitOptions.RemoveEmptyEntries);
        foreach (var registro in registros)
        {
            var campos = registro.Split('|');
            if (campos.Length == 0 || campos[0] == "~")
            {
                break;
            }

            lista.Add(new Mesa
            {
                IdMesa = ParseInt(campos, 0),
                NroMesa = ToNullableString(campos, 1),
                Capacidad = ParseInt(campos, 2),
                Ubicacion = ToNullableString(campos, 3),
                Estado = ToNullableString(campos, 4)
            });
        }

        return lista;
    }

    private static string? ToNullableString(string[] campos, int index)
    {
        if (index >= campos.Length)
        {
            return null;
        }

        var value = campos[index]?.Trim();
        return string.IsNullOrWhiteSpace(value) ? null : value;
    }

    private static int ParseInt(string[] campos, int index)
    {
        var value = ToNullableString(campos, index);
        return int.TryParse(value, out var result) ? result : 0;
    }

    private static MesaOrdenActiva? ParseOrdenActiva(string? raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return null;
        }

        var campos = raw.Split('|');
        if (campos.Length < 2)
        {
            return null;
        }

        if (!long.TryParse(campos[0].Trim(), out var idOrden) || idOrden <= 0)
        {
            return null;
        }

        return new MesaOrdenActiva
        {
            IdOrden = idOrden,
            NroMesa = campos[1].Trim()
        };
    }

    private async Task<MesaCombinacionOperacionResponse> EjecutarOperacionMesaCombinadaAsync(
        MesaCombinacionOperacionRequest request,
        int condicion,
        CancellationToken cancellationToken)
    {
        var idMesasOrden = string.IsNullOrWhiteSpace(request.IdMesasOrden)
            ? string.Empty
            : request.IdMesasOrden.Trim();

        var data = string.Join("|",
            request.IdOrden.ToString(CultureInfo.InvariantCulture),
            request.IdMesa.ToString(CultureInfo.InvariantCulture),
            condicion.ToString(CultureInfo.InvariantCulture),
            idMesasOrden);

        var raw = await _accesoDatos.EjecutarComandoAsync(
            "upsAgregarEliminarMesas",
            "@Data",
            data,
            cancellationToken);

        return ParseMesaCombinacionResultado(raw);
    }

    private async Task<string> ObtenerCorrelativoTicketAsync(string serie, CancellationToken cancellationToken)
    {
        var correlativo = await _accesoDatos.EjecutarComandoAsync(
            "correlativoNroTicket",
            "@dato",
            serie,
            cancellationToken);

        return string.IsNullOrWhiteSpace(correlativo) ? "00000001" : correlativo.Trim();
    }

    private static (MesaPedidoCabecera? cabecera, List<MesaPedidoDetalle> detalles) ParsePedido(string? raw)
    {
        var detalles = new List<MesaPedidoDetalle>();
        if (string.IsNullOrWhiteSpace(raw))
        {
            return (null, detalles);
        }

        var bloques = raw.Split('[');
        var cabeceraRaw = bloques.Length > 0 ? bloques[0] : string.Empty;
        var detalleRaw = bloques.Length > 1 ? bloques[1] : string.Empty;

        var cabecera = ParseCabecera(cabeceraRaw);
        detalles = ParseDetalles(detalleRaw);
        return (cabecera, detalles);
    }

    private static MesaPedidoCabecera? ParseCabecera(string raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return null;
        }

        var fila = raw
            .Split('¬', StringSplitOptions.RemoveEmptyEntries)
            .FirstOrDefault(x => !string.Equals(x.Trim(), "~", StringComparison.Ordinal));

        if (string.IsNullOrWhiteSpace(fila))
        {
            return null;
        }

        var campos = fila.Split('|');
        if (campos.Length < 11)
        {
            return null;
        }

        return new MesaPedidoCabecera
        {
            IdOrden = ParseLong(campos, 0),
            ClienteId = ParseLong(campos, 1),
            ClienteRazon = DecodeText(campos, 2),
            FechaOrdenTexto = GetText(campos, 3),
            HoraFinTexto = GetText(campos, 4),
            OrdenSerie = GetText(campos, 5),
            OrdenNumero = GetText(campos, 6),
            NroMesas = GetText(campos, 7),
            Observaciones = DecodeText(campos, 8),
            Usuario = GetText(campos, 9),
            EstadoOrden = GetText(campos, 10)
        };
    }

    private static List<MesaPedidoDetalle> ParseDetalles(string raw)
    {
        var lista = new List<MesaPedidoDetalle>();
        if (string.IsNullOrWhiteSpace(raw))
        {
            return lista;
        }

        var filas = raw.Split('¬', StringSplitOptions.RemoveEmptyEntries);
        foreach (var fila in filas)
        {
            if (string.Equals(fila.Trim(), "~", StringComparison.Ordinal))
            {
                continue;
            }

            var campos = fila.Split('|');
            if (campos.Length < 11)
            {
                continue;
            }

            lista.Add(new MesaPedidoDetalle
            {
                DetalleId = ParseLong(campos, 0),
                IdProducto = ParseLong(campos, 1),
                ProductoNombre = DecodeText(campos, 2),
                PrecioUnitario = ParseDecimal(campos, 3),
                Cantidad = ParseDecimal(campos, 4),
                Importe = ParseDecimal(campos, 5),
                ProductoCosto = ParseDecimal(campos, 6),
                ProductoVentaB = ParseDecimal(campos, 7),
                IdOrden = ParseLong(campos, 8),
                EstadoDetalle = GetText(campos, 9),
                EnviarIMP = GetText(campos, 10)
            });
        }

        return lista;
    }

    private static string GetText(string[] campos, int index)
    {
        if (index >= campos.Length)
        {
            return string.Empty;
        }

        return campos[index]?.Trim() ?? string.Empty;
    }

    private static string DecodeText(string[] campos, int index)
    {
        return WebUtility.HtmlDecode(GetText(campos, index));
    }

    private static long ParseLong(string[] campos, int index)
    {
        var value = GetText(campos, index);
        return long.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out var parsed)
            ? parsed
            : 0;
    }

    private static decimal ParseDecimal(string[] campos, int index)
    {
        var value = GetText(campos, index);
        if (string.IsNullOrWhiteSpace(value))
        {
            return 0m;
        }

        if (decimal.TryParse(value, NumberStyles.Any, CultureInfo.InvariantCulture, out var parsedInv))
        {
            return parsedInv;
        }

        return decimal.TryParse(value, NumberStyles.Any, CultureInfo.GetCultureInfo("es-PE"), out var parsedPe)
            ? parsedPe
            : 0m;
    }

    private static string? ToNullableString(object? value)
    {
        if (value is null || value == DBNull.Value)
        {
            return null;
        }

        var text = Convert.ToString(value, CultureInfo.CurrentCulture)?.Trim();
        return string.IsNullOrWhiteSpace(text) ? null : text;
    }

    private static int? ToInt(object? value)
    {
        if (value is null || value == DBNull.Value)
        {
            return null;
        }

        try
        {
            return Convert.ToInt32(value, CultureInfo.InvariantCulture);
        }
        catch
        {
            return null;
        }
    }

    private static long? ToLong(object? value)
    {
        if (value is null || value == DBNull.Value)
        {
            return null;
        }

        try
        {
            return Convert.ToInt64(value, CultureInfo.InvariantCulture);
        }
        catch
        {
            return null;
        }
    }

    private static decimal? ToDecimal(object? value)
    {
        if (value is null || value == DBNull.Value)
        {
            return null;
        }

        try
        {
            return Convert.ToDecimal(value, CultureInfo.InvariantCulture);
        }
        catch
        {
            return null;
        }
    }

    private static DateTime? ToDateTime(object? value)
    {
        if (value is null || value == DBNull.Value)
        {
            return null;
        }

        try
        {
            return Convert.ToDateTime(value, CultureInfo.InvariantCulture);
        }
        catch
        {
            return null;
        }
    }

    private static string ResolveEstadoMesa(MesaGuardarPedidoRequest request)
    {
        if (!string.IsNullOrWhiteSpace(request.EstadoMesa))
        {
            return request.EstadoMesa.Trim().ToUpperInvariant();
        }

        return string.Equals(request.TipoRegistro, "RESERVAR", StringComparison.OrdinalIgnoreCase)
            ? "RESERVADA"
            : "OCUPADA";
    }

    private static string BuildNroMesas(MesaGuardarPedidoRequest request)
    {
        if (!string.IsNullOrWhiteSpace(request.NroMesas))
        {
            return request.NroMesas.Trim();
        }

        if (request.Mesas.Count == 0)
        {
            return string.Empty;
        }

        return string.Join(" ,", request.Mesas.Select(m => $"MESA {m}"));
    }

    private static string BuildMesaIds(IReadOnlyList<int> mesas)
    {
        return string.Join(";", mesas.Where(x => x > 0).Distinct());
    }

    private static string ReplaceMesaId(string mesasCsv, int oldMesa, int newMesa)
    {
        var ids = mesasCsv
            .Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries)
            .Select(x => int.TryParse(x, NumberStyles.Any, CultureInfo.InvariantCulture, out var id) ? id : 0)
            .Where(x => x > 0)
            .ToList();

        for (var i = 0; i < ids.Count; i++)
        {
            if (ids[i] == oldMesa)
            {
                ids[i] = newMesa;
            }
        }

        return string.Join(",", ids);
    }

    private static string BuildDetails(IReadOnlyList<MesaGuardarPedidoDetalleRequest> detalles)
    {
        if (detalles.Count == 0)
        {
            return string.Empty;
        }

        var rows = new List<string>(detalles.Count);
        foreach (var item in detalles)
        {
            var row = string.Join("|",
                item.DetalleId.ToString(CultureInfo.InvariantCulture),
                item.IdProducto.ToString(CultureInfo.InvariantCulture),
                FormatDecimal(item.Cantidad),
                FormatDecimal(item.PrecioUnitario),
                FormatDecimal(ResolveImporte(item)),
                SanitizeField(string.IsNullOrWhiteSpace(item.EstadoDetalle) ? "PENDIENTE" : item.EstadoDetalle));
            rows.Add(row);
        }

        return string.Join(";", rows);
    }

    private static decimal ResolveImporte(MesaGuardarPedidoDetalleRequest item)
    {
        return item.Importe ?? (item.Cantidad * item.PrecioUnitario);
    }

    private static string FormatDecimal(decimal value)
    {
        return value.ToString("0.##", CultureInfo.InvariantCulture);
    }

    private static string SanitizeField(string? input)
    {
        if (string.IsNullOrWhiteSpace(input))
        {
            return string.Empty;
        }

        var sanitized = input.Trim()
            .Replace('|', ' ')
            .Replace('[', ' ')
            .Replace(']', ' ')
            .Replace(';', ' ');

        return WebUtility.HtmlDecode(sanitized);
    }

    private static MesaCombinacionOperacionResponse ParseMesaCombinacionResultado(string? raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return new MesaCombinacionOperacionResponse
            {
                Ok = false,
                Resultado = "error"
            };
        }

        var bloques = raw.Split('¬');
        var mesasIds = bloques.Length > 0 ? (bloques[0] ?? string.Empty).Trim() : string.Empty;
        var nroMesas = bloques.Length > 1 ? (bloques[1] ?? string.Empty).Trim() : string.Empty;

        var lista = new List<int>();
        if (!string.IsNullOrWhiteSpace(mesasIds) && mesasIds != "~")
        {
            foreach (var token in mesasIds.Split(',', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries))
            {
                if (int.TryParse(token, NumberStyles.Any, CultureInfo.InvariantCulture, out var idMesa) && idMesa > 0)
                {
                    lista.Add(idMesa);
                }
            }
        }

        return new MesaCombinacionOperacionResponse
        {
            Ok = true,
            Resultado = raw.Trim(),
            MesasIdsCsv = mesasIds,
            NroMesas = nroMesas,
            Mesas = lista
        };
    }
}
