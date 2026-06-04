using System.Data;
using System.Globalization;
using System.Text;
using Ecommerce.Application.Contracts.NotaPedido;
using Ecommerce.Domain;
using Ecommerce.Infrastructure.Persistence;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Configuration;

namespace Ecommerce.Infrastructure.Persistence.Repositories;

public class NotaPedidoRepository : INotaPedido
{
    private readonly string _connectionString;
    private readonly AccesoDatos _accesoDatos;

    public NotaPedidoRepository(IConfiguration configuration, AccesoDatos accesoDatos)
    {
        _connectionString = configuration.GetConnectionString("DefaultConnection")
            ?? throw new InvalidOperationException("Missing connection string: DefaultConnection");
        _accesoDatos = accesoDatos;
    }

    public async Task<string> RegistrarOrdenAsync(string data, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspinsertarNotaB", "@ListaOrden", data, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? "error" : result;
    }

    public async Task<string> EditarOrdenAsync(string data, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspEditarNotaPedido", "@Data", data, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? "error" : result;
    }

    public async Task<string> AnularDocumentoAsync(string listaOrden, CancellationToken cancellationToken = default)
    {
        var attempts = new (string Sp, string Param)[]
        {
            ("anularOrden", "@ListaOrden"),
            ("anularOrden", "@Data"),
            ("anularDocumento", "@ListaOrden"),
            ("anularDocumento", "@Data")
        };

        SqlException? lastFallbackException = null;

        foreach (var attempt in attempts)
        {
            try
            {
                var result = await _accesoDatos.EjecutarComandoAsync(
                    attempt.Sp,
                    attempt.Param,
                    listaOrden,
                    cancellationToken);

                return string.IsNullOrWhiteSpace(result) ? "error" : result;
            }
            catch (SqlException ex) when (IsMissingProcedureOrParameter(ex))
            {
                lastFallbackException = ex;
            }
        }

        if (lastFallbackException is not null)
        {
            throw lastFallbackException;
        }

        return "error";
    }

    private static bool IsMissingProcedureOrParameter(SqlException ex)
    {
        // 2812: stored procedure not found
        // 201 : expects parameter not supplied
        // 8144: too many arguments
        return ex.Number == 2812 || ex.Number == 201 || ex.Number == 8144;
    }

    public async Task<string> ListarDocumentosAsync(string data, CancellationToken cancellationToken = default)
    {
        return await _accesoDatos.EjecutarComandoAsync("uspListaDocumentos", "@Data", data, cancellationToken);
    }

    public async Task<string> ListarLdDocumentosAsync(int mes, int anno, CancellationToken cancellationToken = default)
    {
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand("LDdocumentos", con)
        {
            CommandTimeout = 300,
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@Mes", mes);
        cmd.Parameters.AddWithValue("@ANNO", anno);

        await con.OpenAsync(cancellationToken);
        var result = await cmd.ExecuteScalarAsync(cancellationToken);
        var texto = result?.ToString();
        return string.IsNullOrWhiteSpace(texto) ? "~" : texto;
    }

    public async Task<string> ListarLdDocumentosRangoAsync(DateTime fechaInicio, DateTime fechaFin, CancellationToken cancellationToken = default)
    {
        if (fechaInicio.Date > fechaFin.Date)
        {
            return "~";
        }

        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand("LDdocumentos", con)
        {
            CommandTimeout = 300,
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@FechaInicio", fechaInicio.Date);
        cmd.Parameters.AddWithValue("@FechaFin", fechaFin.Date);

        await con.OpenAsync(cancellationToken);
        var result = await cmd.ExecuteScalarAsync(cancellationToken);
        var texto = result?.ToString();
        return string.IsNullOrWhiteSpace(texto) ? "~" : texto;
    }

    public async Task<string> ListarBajasAsync(string data, CancellationToken cancellationToken = default)
    {
        return await _accesoDatos.EjecutarComandoAsync("uspListaBajas", "@Data", data, cancellationToken);
    }

    public async Task<string> RegistrarResumenBoletasAsync(string listaOrden, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspinsertarRB", "@ListaOrden", listaOrden, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? "~" : result;
    }

    public async Task<string> EditarResumenBoletasAsync(string data, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspEditarRB", "@Data", data, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? string.Empty : result;
    }

    public async Task<string> ReenviarFacturaAsync(string data, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspReEnviarFactura", "@Data", data, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? string.Empty : result;
    }

    public async Task<string> RegistrarNotaCreditoAsync(string listaOrden, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspinsertarNC", "@ListaOrden", listaOrden, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? string.Empty : result;
    }

    public async Task<string> ReenviarNotaCreditoAsync(string data, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspReEnviarNotaCredito", "@Data", data, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? string.Empty : result;
    }

    public async Task<string> RetornaBoletaPorTicketAsync(string resumenId, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspRetornaBoletaPorTicket", "@ResumenId", resumenId, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? string.Empty : result;
    }

    public async Task<string> RetornarBoletasAsync(string resumenId, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync("uspRetornarBoletas", "@ResumenId", resumenId, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? string.Empty : result;
    }

    public async Task<string?> ObtenerCdrBase64ResumenAsync(long resumenId, CancellationToken cancellationToken = default)
    {
        if (resumenId <= 0)
        {
            return null;
        }

        const string sql = @"SELECT TOP 1 NULLIF(LTRIM(RTRIM(CDRBase64)), '')
                             FROM ResumenBoletas
                             WHERE ResumenId = @ResumenId;";

        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@ResumenId", resumenId);

        await con.OpenAsync(cancellationToken);
        var value = await cmd.ExecuteScalarAsync(cancellationToken);
        var cdr = value?.ToString();
        return string.IsNullOrWhiteSpace(cdr) ? null : cdr.Trim();
    }

    public async Task<int> ActualizarRespuestaSunatDocumentoVentaPorResumenAsync(
        long resumenId,
        string codigoSunat,
        string mensajeSunat,
        string hashCdr,
        CancellationToken cancellationToken = default)
    {
        if (resumenId <= 0)
        {
            return 0;
        }

        await using var con = new SqlConnection(_connectionString);
        await con.OpenAsync(cancellationToken);

        const string sqlResumen = @"
            SELECT TOP 1
                CompaniaId,
                FechaReferencia,
                NULLIF(LTRIM(RTRIM(RangoNumero)), '') AS RangoNumero
            FROM ResumenBoletas
            WHERE ResumenId = @ResumenId;";

        int companiaId;
        DateTime fechaReferencia;
        string? rangoNumero;

        await using (var cmdResumen = new SqlCommand(sqlResumen, con))
        {
            cmdResumen.Parameters.AddWithValue("@ResumenId", resumenId);
            await using var reader = await cmdResumen.ExecuteReaderAsync(cancellationToken);
            if (!await reader.ReadAsync(cancellationToken))
            {
                return 0;
            }

            if (reader["CompaniaId"] == DBNull.Value || reader["FechaReferencia"] == DBNull.Value)
            {
                return 0;
            }

            companiaId = Convert.ToInt32(reader["CompaniaId"], CultureInfo.InvariantCulture);
            fechaReferencia = Convert.ToDateTime(reader["FechaReferencia"], CultureInfo.InvariantCulture).Date;
            rangoNumero = reader["RangoNumero"] == DBNull.Value ? null : reader["RangoNumero"]?.ToString();
        }

        var filtroRango = ParsearFiltroRango(rangoNumero);

        var sql = new StringBuilder("""
            UPDATE d
               SET d.CodigoSunat = @CodigoSunat,
                   d.MensajeSunat = @MensajeSunat
            """);

        if (!string.IsNullOrWhiteSpace(hashCdr))
        {
            sql.AppendLine(",                   d.DocuHash = @DocuHash");
        }

        sql.Append("""
            FROM DocumentoVenta d
            WHERE d.CompaniaId = @CompaniaId
              AND d.TipoCodigo = '03'
              AND d.DocuEmision = @FechaReferencia
              AND d.EstadoSunat = 'ENVIADO'
            """);

        if (filtroRango.Tipo == TipoFiltroRango.ComprobanteUnico)
        {
            sql.AppendLine("  AND d.DocuSerie = @SerieInicio");
            sql.AppendLine("  AND TRY_CONVERT(bigint, d.DocuNumero) = @NumeroInicio");
        }
        else if (filtroRango.Tipo == TipoFiltroRango.RangoMismaSerie)
        {
            sql.AppendLine("  AND d.DocuSerie = @SerieInicio");
            sql.AppendLine("  AND TRY_CONVERT(bigint, d.DocuNumero) BETWEEN @NumeroInicio AND @NumeroFin");
        }

        await using var cmdUpdate = new SqlCommand(sql.ToString(), con);
        cmdUpdate.Parameters.AddWithValue("@CodigoSunat", (object?)codigoSunat ?? string.Empty);
        cmdUpdate.Parameters.AddWithValue("@MensajeSunat", (object?)mensajeSunat ?? string.Empty);
        cmdUpdate.Parameters.AddWithValue("@CompaniaId", companiaId);
        cmdUpdate.Parameters.AddWithValue("@FechaReferencia", fechaReferencia);

        if (!string.IsNullOrWhiteSpace(hashCdr))
        {
            cmdUpdate.Parameters.AddWithValue("@DocuHash", hashCdr.Trim());
        }

        if (filtroRango.Tipo == TipoFiltroRango.ComprobanteUnico || filtroRango.Tipo == TipoFiltroRango.RangoMismaSerie)
        {
            cmdUpdate.Parameters.AddWithValue("@SerieInicio", filtroRango.Serie);
            cmdUpdate.Parameters.AddWithValue("@NumeroInicio", filtroRango.NumeroInicio);
        }

        if (filtroRango.Tipo == TipoFiltroRango.RangoMismaSerie)
        {
            cmdUpdate.Parameters.AddWithValue("@NumeroFin", filtroRango.NumeroFin);
        }

        return await cmdUpdate.ExecuteNonQueryAsync(cancellationToken);
    }

    public async Task<string?> ObtenerUsuarioDocumentoVentaAsync(IEnumerable<long> docuIds, CancellationToken cancellationToken = default)
    {
        var ids = docuIds?
            .Where(x => x > 0)
            .Distinct()
            .ToList() ?? new List<long>();

        if (ids.Count == 0)
        {
            return null;
        }

        var parameterNames = ids.Select((_, index) => $"@Id{index}").ToList();
        var sql = $@"SELECT TOP 1 NULLIF(LTRIM(RTRIM(DocuUsuario)), '')
                     FROM DocumentoVenta
                     WHERE DocuId IN ({string.Join(",", parameterNames)})
                     ORDER BY DocuId DESC;";

        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(sql, con);
        for (var i = 0; i < ids.Count; i++)
        {
            cmd.Parameters.AddWithValue(parameterNames[i], ids[i]);
        }

        await con.OpenAsync(cancellationToken);
        var value = await cmd.ExecuteScalarAsync(cancellationToken);
        var usuario = value?.ToString();
        return string.IsNullOrWhiteSpace(usuario) ? null : usuario.Trim();
    }

    private enum TipoFiltroRango
    {
        Ninguno = 0,
        ComprobanteUnico = 1,
        RangoMismaSerie = 2
    }

    private readonly record struct FiltroRango(TipoFiltroRango Tipo, string Serie, long NumeroInicio, long NumeroFin);

    private static FiltroRango ParsearFiltroRango(string? rangoNumero)
    {
        if (string.IsNullOrWhiteSpace(rangoNumero))
        {
            return new FiltroRango(TipoFiltroRango.Ninguno, string.Empty, 0, 0);
        }

        var valor = rangoNumero.Trim();
        if (TryParseComprobante(valor, out var serieUnica, out var numeroUnico))
        {
            return new FiltroRango(TipoFiltroRango.ComprobanteUnico, serieUnica, numeroUnico, numeroUnico);
        }

        var partes = valor.Split('-', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
        if (partes.Length == 4 &&
            long.TryParse(partes[1], NumberStyles.Integer, CultureInfo.InvariantCulture, out var numeroInicio) &&
            long.TryParse(partes[3], NumberStyles.Integer, CultureInfo.InvariantCulture, out var numeroFin) &&
            !string.IsNullOrWhiteSpace(partes[0]) &&
            !string.IsNullOrWhiteSpace(partes[2]) &&
            string.Equals(partes[0], partes[2], StringComparison.OrdinalIgnoreCase))
        {
            if (numeroInicio > numeroFin)
            {
                (numeroInicio, numeroFin) = (numeroFin, numeroInicio);
            }

            return new FiltroRango(TipoFiltroRango.RangoMismaSerie, partes[0], numeroInicio, numeroFin);
        }

        return new FiltroRango(TipoFiltroRango.Ninguno, string.Empty, 0, 0);
    }

    private static bool TryParseComprobante(string valor, out string serie, out long numero)
    {
        serie = string.Empty;
        numero = 0;

        if (string.IsNullOrWhiteSpace(valor))
        {
            return false;
        }

        var partes = valor.Split('-', StringSplitOptions.RemoveEmptyEntries | StringSplitOptions.TrimEntries);
        if (partes.Length != 2)
        {
            return false;
        }

        if (string.IsNullOrWhiteSpace(partes[0]) ||
            !long.TryParse(partes[1], NumberStyles.Integer, CultureInfo.InvariantCulture, out numero))
        {
            return false;
        }

        serie = partes[0];
        return true;
    }

    public async Task<string> TraerSecuenciaResumenAsync(string companiaId, CancellationToken cancellationToken = default)
    {
        return await _accesoDatos.EjecutarComandoAsync("usptraerSecuenciaResumen", "@CompaniaId", companiaId, cancellationToken);
    }

    public async Task<string> ResumenPorFechaAsync(DateTime fechaInicio, DateTime fechaFin, CancellationToken cancellationToken = default)
    {
        var data = $"{fechaInicio:yyyy-MM-dd}|{fechaFin:yyyy-MM-dd}";
        var result = await _accesoDatos.EjecutarComandoAsync("uspResumenFecha", "@Data", data, cancellationToken);
        return string.IsNullOrWhiteSpace(result) ? "~" : result;
    }

    public async Task<CredencialesSunat?> ObtenerCredencialesSunatAsync(int companiaId, CancellationToken cancellationToken = default)
    {
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand("uspObtenerCredencialesSunat", con)
        {
            CommandTimeout = 300,
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@CompaniaId", companiaId);

        await con.OpenAsync(cancellationToken);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);
        if (!await reader.ReadAsync(cancellationToken))
        {
            return null;
        }

        return new CredencialesSunat
        {
            UsuarioSOL = reader["UsuarioSOL"] == DBNull.Value ? null : reader["UsuarioSOL"].ToString(),
            ClaveSOL = reader["ClaveSOL"] == DBNull.Value ? null : reader["ClaveSOL"].ToString(),
            CertificadoPFX = reader["CertificadoPFX"] == DBNull.Value ? null : reader["CertificadoPFX"].ToString(),
            ClaveCertificado = reader["ClaveCertificado"] == DBNull.Value ? null : reader["ClaveCertificado"].ToString(),
            Entorno = reader["Entorno"] == DBNull.Value ? null : reader["Entorno"].ToString()
        };
    }

    public async Task<bool> GuardarCredencialesSunatAsync(
        int companiaId,
        string usuarioSol,
        string claveSol,
        string certificadoBase64,
        string claveCertificado,
        int entorno,
        CancellationToken cancellationToken = default)
    {
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand("uspGuardarCredencialesSunat", con)
        {
            CommandTimeout = 300,
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@CompaniaId", companiaId);
        cmd.Parameters.AddWithValue("@UsuarioSOL", (object?)usuarioSol ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@ClaveSOL", (object?)claveSol ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@CertificadoBase64", (object?)certificadoBase64 ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@ClaveCertificado", (object?)claveCertificado ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@Entorno", entorno);

        await con.OpenAsync(cancellationToken);
        await cmd.ExecuteNonQueryAsync(cancellationToken);
        return true;
    }

    public async Task<string> InsertarAsync(NotaPedido notaPedido, CancellationToken cancellationToken = default)
    {
        await using var con = new SqlConnection(_connectionString);
        await con.OpenAsync(cancellationToken);
        await using var tx = (SqlTransaction)await con.BeginTransactionAsync(cancellationToken);

        var notaId = await InsertOrUpdateNotaAsync(notaPedido, con, tx, cancellationToken);
        if (notaId <= 0)
        {
            await tx.RollbackAsync(cancellationToken);
            return notaPedido.NotaId > 0 ? "NOT_FOUND" : "error";
        }

        await tx.CommitAsync(cancellationToken);
        return notaPedido.NotaId > 0 ? "UPDATED" : notaId.ToString();
    }

    public async Task<string> InsertarConDetalleAsync(NotaPedido notaPedido, IEnumerable<DetalleNota> detalles, CancellationToken cancellationToken = default)
    {
        await using var con = new SqlConnection(_connectionString);
        await con.OpenAsync(cancellationToken);
        await using var tx = (SqlTransaction)await con.BeginTransactionAsync(cancellationToken);

        var notaId = await InsertOrUpdateNotaAsync(notaPedido, con, tx, cancellationToken);
        if (notaId <= 0)
        {
            await tx.RollbackAsync(cancellationToken);
            return notaPedido.NotaId > 0 ? "NOT_FOUND" : "error";
        }

        var detalleList = detalles?.ToList() ?? new List<DetalleNota>();
        foreach (var detalle in detalleList)
        {
            detalle.NotaId = notaId;
        }
        await MergeDetallesNotaAsync(notaId, detalleList, con, tx, cancellationToken);

        await tx.CommitAsync(cancellationToken);
        return notaId.ToString();
    }

    public async Task<bool> EliminarAsync(long id, CancellationToken cancellationToken = default)
    {
        await using var con = new SqlConnection(_connectionString);
        await con.OpenAsync(cancellationToken);
        await using var tx = (SqlTransaction)await con.BeginTransactionAsync(cancellationToken);

        const string sqlDeleteDetalles = "DELETE FROM DetallePedido WHERE NotaId = @NotaId";
        await using var cmdDet = new SqlCommand(sqlDeleteDetalles, con, tx);
        cmdDet.Parameters.AddWithValue("@NotaId", id);
        await cmdDet.ExecuteNonQueryAsync(cancellationToken);

        const string sqlDeleteNota = "DELETE FROM NotaPedido WHERE NotaId = @Id";
        await using var cmd = new SqlCommand(sqlDeleteNota, con, tx);
        cmd.Parameters.AddWithValue("@Id", id);
        var rows = await cmd.ExecuteNonQueryAsync(cancellationToken);
        if (rows > 0)
        {
            await tx.CommitAsync(cancellationToken);
            return true;
        }

        await tx.RollbackAsync(cancellationToken);
        return false;
    }

    public async Task<NotaPedido?> ObtenerPorIdAsync(long id, CancellationToken cancellationToken = default)
    {
        return await ObtenerPorIdDesdeListarPedidosAsync(id, cancellationToken);
    }

    public async Task<string> ObtenerNotaPedidoSpAsync(long id, CancellationToken cancellationToken = default)
    {
        var result = await _accesoDatos.EjecutarComandoAsync(
            "uspObtenerNotaPedido",
            "@Valores",
            id.ToString(),
            cancellationToken);

        return string.IsNullOrWhiteSpace(result) ? "~" : result;
    }

    public async Task<IReadOnlyList<NotaPedido>> ListarCrudAsync(string? estado = null, int page = 1, int pageSize = 50, CancellationToken cancellationToken = default)
    {
        (page, pageSize) = NormalizePagination(page, pageSize);

        await using var con = new SqlConnection(_connectionString);
        await con.OpenAsync(cancellationToken);

        var hasEntidadBancaria = await HasColumnAsync(con, "NotaPedido", "EntidadBancaria", cancellationToken);
        var hasNroOperacion = await HasColumnAsync(con, "NotaPedido", "NroOperacion", cancellationToken);
        var hasEfectivo = await HasColumnAsync(con, "NotaPedido", "Efectivo", cancellationToken);
        var hasDeposito = await HasColumnAsync(con, "NotaPedido", "Deposito", cancellationToken);

        var sql = $@"WITH notas AS
                     (
                         SELECT NotaId,
                                NotaDocu,
                                ClienteId,
                                NotaFecha,
                                NotaUsuario,
                                NotaFormaPago,
                                NotaCondicion,
                                NotaFechaPago,
                                NotaDireccion,
                                NotaTelefono,
                                NotaSubtotal,
                                NotaMovilidad,
                                NotaDescuento,
                                NotaTotal,
                                NotaAcuenta,
                                NotaSaldo,
                                NotaAdicional,
                                NotaTarjeta,
                                NotaPagar,
                                NotaEstado,
                                CompaniaId,
                                NotaEntrega,
                                ModificadoPor,
                                FechaEdita,
                                NotaConcepto,
                                NotaSerie,
                                NotaNumero,
                                NotaGanancia,
                                ICBPER,
                                CajaId,
                                {SelectOrNull("EntidadBancaria", "varchar(80)", hasEntidadBancaria)},
                                {SelectOrNull("NroOperacion", "varchar(80)", hasNroOperacion)},
                                {SelectOrNull("Efectivo", "decimal(18,2)", hasEfectivo)},
                                {SelectOrNull("Deposito", "decimal(18,2)", hasDeposito)},
                                (
                                    SELECT TOP (1) d.EstadoSunat
                                    FROM DocumentoVenta d
                                    WHERE d.NotaId = NotaPedido.NotaId
                                    ORDER BY d.DocuId DESC
                                ) AS EstadoSunat,
                                ROW_NUMBER() OVER (ORDER BY NotaId DESC) AS RowNum
                         FROM NotaPedido
                         WHERE (@Estado IS NULL OR NotaEstado = @Estado)
                     )
                     SELECT NotaId,
                            NotaDocu,
                            ClienteId,
                            NotaFecha,
                            NotaUsuario,
                            NotaFormaPago,
                            NotaCondicion,
                            NotaFechaPago,
                            NotaDireccion,
                            NotaTelefono,
                            NotaSubtotal,
                            NotaMovilidad,
                            NotaDescuento,
                            NotaTotal,
                            NotaAcuenta,
                            NotaSaldo,
                            NotaAdicional,
                            NotaTarjeta,
                            NotaPagar,
                            NotaEstado,
                            CompaniaId,
                            NotaEntrega,
                            ModificadoPor,
                            FechaEdita,
                            NotaConcepto,
                            NotaSerie,
                            NotaNumero,
                            NotaGanancia,
                            ICBPER,
                            CajaId,
                            EntidadBancaria,
                            NroOperacion,
                            Efectivo,
                            Deposito,
                            EstadoSunat
                     FROM notas
                     WHERE RowNum BETWEEN @StartRow AND @EndRow
                     ORDER BY RowNum;";

        await using var cmd = new SqlCommand(sql, con);
        cmd.Parameters.AddWithValue("@Estado", (object?)estado ?? DBNull.Value);
        cmd.Parameters.AddWithValue("@StartRow", ((page - 1) * pageSize) + 1);
        cmd.Parameters.AddWithValue("@EndRow", page * pageSize);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);

        var lista = new List<NotaPedido>();
        while (await reader.ReadAsync(cancellationToken))
        {
            lista.Add(Map(reader));
        }
        return lista;
    }

    public async Task<IReadOnlyList<DetalleNota>> ListarDetalleAsync(long notaId, int page = 1, int pageSize = 50, CancellationToken cancellationToken = default)
    {
        (page, pageSize) = NormalizePagination(page, pageSize);
        var data = $"{notaId}|18";
        var raw = await _accesoDatos.EjecutarComandoAsync(
            "listaDetalleNotaB",
            "@Data",
            data,
            cancellationToken);

        var lista = ParseDetalleNotaDesdeListaDetalleNotaB(raw);
        return lista.Skip((page - 1) * pageSize).Take(pageSize).ToList();
    }

    public async Task<IReadOnlyList<EListaNota>> ListarAsync(DateTime fechaInicio, DateTime fechaFin, int page = 1, int pageSize = 50, CancellationToken cancellationToken = default)
    {
        (page, pageSize) = NormalizePagination(page, pageSize);

        const string sp = "listaNotaPedido";
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand(sp, con)
        {
            CommandTimeout = 300,
            CommandType = CommandType.StoredProcedure
        };
        cmd.Parameters.AddWithValue("@FechaInicio", fechaInicio.Date);
        cmd.Parameters.AddWithValue("@FechaFin", fechaFin.Date);

        await con.OpenAsync(cancellationToken);
        var scalar = await cmd.ExecuteScalarAsync(cancellationToken);
        var result = scalar?.ToString() ?? string.Empty;

        if (string.IsNullOrWhiteSpace(result))
        {
            return new List<EListaNota>();
        }

        var lista = Cadena.AlistaCamposNota(result);
        return lista.Skip((page - 1) * pageSize).Take(pageSize).ToList();
    }

    public async Task<IReadOnlyList<EListaPedidoFecha>> ListarFechaAsync(
        DateTime fechaInicio,
        DateTime fechaFin,
        int page = 1,
        int pageSize = 50,
        CancellationToken cancellationToken = default)
    {
        (page, pageSize) = NormalizePagination(page, pageSize);

        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand("listaPedidosFecha", con)
        {
            CommandType = CommandType.StoredProcedure,
            CommandTimeout = 300
        };
        cmd.Parameters.AddWithValue("@fechainicio", fechaInicio.Date);
        cmd.Parameters.AddWithValue("@fechafin", fechaFin.Date);

        await con.OpenAsync(cancellationToken);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);

        var lista = new List<EListaPedidoFecha>();
        var ordinals = BuildOrdinals(reader);

        while (await reader.ReadAsync(cancellationToken))
        {
            lista.Add(new EListaPedidoFecha
            {
                Numero = GetString(reader, ordinals, "NotaId"),
                Documento = GetString(reader, ordinals, "NotaDocu"),
                FechaEmision = GetString(reader, ordinals, "NotaFecha"),
                ClienteId = GetString(reader, ordinals, "ClienteId"),
                Cliente = GetString(reader, ordinals, "ClienteRazon"),
                RUC = GetString(reader, ordinals, "ClienteRuc"),
                DNI = GetString(reader, ordinals, "ClienteDni"),
                Condicion = GetString(reader, ordinals, "NotaCondicion"),
                FormaPago = GetString(reader, ordinals, "NotaFormaPago"),
                Dias = GetString(reader, ordinals, "NotaDias"),
                FechaPago = GetString(reader, ordinals, "NotaFechaPago"),
                SubTotal = GetString(reader, ordinals, "NotaSubtotal"),
                Movilidad = GetString(reader, ordinals, "NotaMovilidad"),
                Descuento = GetString(reader, ordinals, "NotaDescuento"),
                OpGravada = GetString(reader, ordinals, "OpGravada", "NotaTotal"),
                Acuenta = GetString(reader, ordinals, "NotaAcuenta"),
                SaldoDoc = GetString(reader, ordinals, "SaldoDocumento", "NotaSaldo"),
                Adicional = GetString(reader, ordinals, "NotaAdicional"),
                Tarjeta = GetString(reader, ordinals, "TotalTarjeta", "NotaTarjeta"),
                TotalPagar = GetString(reader, ordinals, "TotalPagar", "NotaPagar"),
                Atendido_Por = GetString(reader, ordinals, "NotaUsuario"),
                Estado = GetString(reader, ordinals, "NotaEstado"),
                Compania = GetString(reader, ordinals, "compania", "CompaniaRazonSocial"),
                Direccion = GetString(reader, ordinals, "Direccion", "ClienteDireccion"),
                Despacho = GetString(reader, ordinals, "NotaDireccion"),
                Telefono = GetString(reader, ordinals, "NotaTelefono"),
                Entrega = GetString(reader, ordinals, "Entrega", "NotaEntrega"),
                ModificadoPor = GetString(reader, ordinals, "ModificadoPor"),
                Modificado = GetString(reader, ordinals, "FechaEdita"),
                Concepto = GetString(reader, ordinals, "NotaConcepto"),
                Serie = GetString(reader, ordinals, "NotaSerie"),
                NroDoc = GetString(reader, ordinals, "NotaNumero"),
                Efectivo = GetString(reader, ordinals, "NotaEfectivo", "Efectivo"),
                Vuelto = GetString(reader, ordinals, "NotaVuelto", "Vuelto")
            });
        }

        return lista.Skip((page - 1) * pageSize).Take(pageSize).ToList();
    }

    private static async Task<long> InsertOrUpdateNotaAsync(NotaPedido notaPedido, SqlConnection con, SqlTransaction tx, CancellationToken cancellationToken)
    {
        if (notaPedido.NotaId > 0)
        {
            const string sqlUpdate = @"UPDATE NotaPedido
                                       SET NotaDocu = @NotaDocu,
                                           ClienteId = @ClienteId,
                                           NotaFecha = @NotaFecha,
                                           NotaUsuario = @NotaUsuario,
                                           NotaFormaPago = @NotaFormaPago,
                                           NotaCondicion = @NotaCondicion,
                                           NotaFechaPago = @NotaFechaPago,
                                           NotaDireccion = @NotaDireccion,
                                           NotaTelefono = @NotaTelefono,
                                           NotaSubtotal = @NotaSubtotal,
                                           NotaMovilidad = @NotaMovilidad,
                                           NotaDescuento = @NotaDescuento,
                                           NotaTotal = @NotaTotal,
                                           NotaAcuenta = @NotaAcuenta,
                                           NotaSaldo = @NotaSaldo,
                                           NotaAdicional = @NotaAdicional,
                                           NotaTarjeta = @NotaTarjeta,
                                           NotaPagar = @NotaPagar,
                                           NotaEstado = @NotaEstado,
                                           CompaniaId = @CompaniaId,
                                           NotaEntrega = @NotaEntrega,
                                           ModificadoPor = @ModificadoPor,
                                           FechaEdita = @FechaEdita,
                                           NotaConcepto = @NotaConcepto,
                                           NotaSerie = @NotaSerie,
                                           NotaNumero = @NotaNumero,
                                           NotaGanancia = @NotaGanancia,
                                           ICBPER = @ICBPER,
                                           CajaId = @CajaId,
                                           EntidadBancaria = @EntidadBancaria,
                                           NroOperacion = @NroOperacion,
                                           Efectivo = @Efectivo,
                                           Deposito = @Deposito
                                       WHERE NotaId = @NotaId";

            await using var cmd = new SqlCommand(sqlUpdate, con, tx);
            AddParameters(cmd, notaPedido);
            cmd.Parameters.AddWithValue("@NotaId", notaPedido.NotaId);
            var rows = await cmd.ExecuteNonQueryAsync(cancellationToken);
            return rows > 0 ? notaPedido.NotaId : 0;
        }

        const string sqlInsert = @"INSERT INTO NotaPedido
                                    (NotaDocu, ClienteId, NotaFecha, NotaUsuario, NotaFormaPago, NotaCondicion,
                                     NotaFechaPago, NotaDireccion, NotaTelefono, NotaSubtotal, NotaMovilidad,
                                     NotaDescuento, NotaTotal, NotaAcuenta, NotaSaldo, NotaAdicional, NotaTarjeta,
                                     NotaPagar, NotaEstado, CompaniaId, NotaEntrega, ModificadoPor, FechaEdita,
                                     NotaConcepto, NotaSerie, NotaNumero, NotaGanancia, ICBPER, CajaId,
                                     EntidadBancaria, NroOperacion, Efectivo, Deposito)
                               VALUES (@NotaDocu, @ClienteId, @NotaFecha, @NotaUsuario, @NotaFormaPago, @NotaCondicion,
                                       @NotaFechaPago, @NotaDireccion, @NotaTelefono, @NotaSubtotal, @NotaMovilidad,
                                       @NotaDescuento, @NotaTotal, @NotaAcuenta, @NotaSaldo, @NotaAdicional, @NotaTarjeta,
                                       @NotaPagar, @NotaEstado, @CompaniaId, @NotaEntrega, @ModificadoPor, @FechaEdita,
                                       @NotaConcepto, @NotaSerie, @NotaNumero, @NotaGanancia, @ICBPER, @CajaId,
                                       @EntidadBancaria, @NroOperacion, @Efectivo, @Deposito);
                               SELECT SCOPE_IDENTITY();";

        await using var insertCmd = new SqlCommand(sqlInsert, con, tx);
        AddParameters(insertCmd, notaPedido);
        var result = await insertCmd.ExecuteScalarAsync(cancellationToken);
        return result == null ? 0 : Convert.ToInt64(result);
    }

    private static async Task MergeDetallesNotaAsync(long notaId, IReadOnlyList<DetalleNota> detalles, SqlConnection con, SqlTransaction tx, CancellationToken cancellationToken)
    {
        if (detalles.Count == 0)
        {
            const string deleteSql = "DELETE FROM DetallePedido WHERE NotaId = @NotaId";
            await using var deleteCmd = new SqlCommand(deleteSql, con, tx);
            deleteCmd.Parameters.AddWithValue("@NotaId", notaId);
            await deleteCmd.ExecuteNonQueryAsync(cancellationToken);
            return;
        }

        var sb = new StringBuilder();
        sb.AppendLine("MERGE DetallePedido AS target");
        sb.AppendLine("USING (VALUES");

        for (var i = 0; i < detalles.Count; i++)
        {
            if (i > 0) sb.AppendLine(",");
            sb.Append($"(@NotaId, @DetalleId{i}, @IdProducto{i}, @DetalleCantidad{i}, @DetalleUm{i}, @DetalleDescripcion{i}, @DetalleCosto{i}, @DetallePrecio{i}, @DetalleImporte{i}, @DetalleEstado{i}, @CantidadSaldo{i}, @ValorUM{i})");
        }

        sb.AppendLine(") AS source (NotaId, DetalleId, IdProducto, DetalleCantidad, DetalleUm, DetalleDescripcion, DetalleCosto, DetallePrecio, DetalleImporte, DetalleEstado, CantidadSaldo, ValorUM)");
        sb.AppendLine("ON target.NotaId = source.NotaId AND target.DetalleId = source.DetalleId AND source.DetalleId > 0");
        sb.AppendLine("WHEN MATCHED THEN UPDATE SET");
        sb.AppendLine("    IdProducto = source.IdProducto,");
        sb.AppendLine("    DetalleCantidad = source.DetalleCantidad,");
        sb.AppendLine("    DetalleUm = source.DetalleUm,");
        sb.AppendLine("    DetalleDescripcion = source.DetalleDescripcion,");
        sb.AppendLine("    DetalleCosto = source.DetalleCosto,");
        sb.AppendLine("    DetallePrecio = source.DetallePrecio,");
        sb.AppendLine("    DetalleImporte = source.DetalleImporte,");
        sb.AppendLine("    DetalleEstado = source.DetalleEstado,");
        sb.AppendLine("    CantidadSaldo = source.CantidadSaldo,");
        sb.AppendLine("    ValorUM = source.ValorUM");
        sb.AppendLine("WHEN NOT MATCHED BY TARGET THEN");
        sb.AppendLine("    INSERT (NotaId, IdProducto, DetalleCantidad, DetalleUm, DetalleDescripcion, DetalleCosto, DetallePrecio, DetalleImporte, DetalleEstado, CantidadSaldo, ValorUM)");
        sb.AppendLine("    VALUES (source.NotaId, source.IdProducto, source.DetalleCantidad, source.DetalleUm, source.DetalleDescripcion, source.DetalleCosto, source.DetallePrecio, source.DetalleImporte, source.DetalleEstado, source.CantidadSaldo, source.ValorUM)");
        sb.AppendLine("WHEN NOT MATCHED BY SOURCE AND target.NotaId = @NotaId THEN DELETE;");

        await using var cmd = new SqlCommand(sb.ToString(), con, tx);
        cmd.Parameters.AddWithValue("@NotaId", notaId);

        for (var i = 0; i < detalles.Count; i++)
        {
            var detalle = detalles[i];
            cmd.Parameters.AddWithValue($"@DetalleId{i}", detalle.DetalleId);
            cmd.Parameters.AddWithValue($"@IdProducto{i}", (object?)detalle.IdProducto ?? DBNull.Value);
            cmd.Parameters.AddWithValue($"@DetalleCantidad{i}", (object?)detalle.DetalleCantidad ?? DBNull.Value);
            cmd.Parameters.AddWithValue($"@DetalleUm{i}", (object?)detalle.DetalleUm ?? DBNull.Value);
            cmd.Parameters.AddWithValue($"@DetalleDescripcion{i}", (object?)detalle.DetalleDescripcion ?? DBNull.Value);
            cmd.Parameters.AddWithValue($"@DetalleCosto{i}", (object?)detalle.DetalleCosto ?? DBNull.Value);
            cmd.Parameters.AddWithValue($"@DetallePrecio{i}", (object?)detalle.DetallePrecio ?? DBNull.Value);
            cmd.Parameters.AddWithValue($"@DetalleImporte{i}", (object?)detalle.DetalleImporte ?? DBNull.Value);
            cmd.Parameters.AddWithValue($"@DetalleEstado{i}", (object?)detalle.DetalleEstado ?? DBNull.Value);
            cmd.Parameters.AddWithValue($"@CantidadSaldo{i}", (object?)detalle.CantidadSaldo ?? DBNull.Value);
            cmd.Parameters.AddWithValue($"@ValorUM{i}", (object?)detalle.ValorUM ?? DBNull.Value);
        }

        await cmd.ExecuteNonQueryAsync(cancellationToken);
    }

    private static void AddParameters(SqlCommand cmd, NotaPedido notaPedido)
    {
        AddParam(cmd, "@NotaDocu", notaPedido.NotaDocu);
        AddParam(cmd, "@ClienteId", notaPedido.ClienteId);
        AddParam(cmd, "@NotaFecha", notaPedido.NotaFecha);
        AddParam(cmd, "@NotaUsuario", notaPedido.NotaUsuario);
        AddParam(cmd, "@NotaFormaPago", notaPedido.NotaFormaPago);
        AddParam(cmd, "@NotaCondicion", notaPedido.NotaCondicion);
        AddParam(cmd, "@NotaFechaPago", notaPedido.NotaFechaPago);
        AddParam(cmd, "@NotaDireccion", notaPedido.NotaDireccion);
        AddParam(cmd, "@NotaTelefono", notaPedido.NotaTelefono);
        AddParam(cmd, "@NotaSubtotal", notaPedido.NotaSubtotal);
        AddParam(cmd, "@NotaMovilidad", notaPedido.NotaMovilidad);
        AddParam(cmd, "@NotaDescuento", notaPedido.NotaDescuento);
        AddParam(cmd, "@NotaTotal", notaPedido.NotaTotal);
        AddParam(cmd, "@NotaAcuenta", notaPedido.NotaAcuenta);
        AddParam(cmd, "@NotaSaldo", notaPedido.NotaSaldo);
        AddParam(cmd, "@NotaAdicional", notaPedido.NotaAdicional);
        AddParam(cmd, "@NotaTarjeta", notaPedido.NotaTarjeta);
        AddParam(cmd, "@NotaPagar", notaPedido.NotaPagar);
        AddParam(cmd, "@NotaEstado", notaPedido.NotaEstado);
        AddParam(cmd, "@CompaniaId", notaPedido.CompaniaId);
        AddParam(cmd, "@NotaEntrega", notaPedido.NotaEntrega);
        AddParam(cmd, "@ModificadoPor", notaPedido.ModificadoPor);
        AddParam(cmd, "@FechaEdita", notaPedido.FechaEdita);
        AddParam(cmd, "@NotaConcepto", notaPedido.NotaConcepto);
        AddParam(cmd, "@NotaSerie", notaPedido.NotaSerie);
        AddParam(cmd, "@NotaNumero", notaPedido.NotaNumero);
        AddParam(cmd, "@NotaGanancia", notaPedido.NotaGanancia);
        AddParam(cmd, "@ICBPER", notaPedido.ICBPER);
        AddParam(cmd, "@CajaId", notaPedido.CajaId);
        AddParam(cmd, "@EntidadBancaria", notaPedido.EntidadBancaria);
        AddParam(cmd, "@NroOperacion", notaPedido.NroOperacion);
        AddParam(cmd, "@Efectivo", notaPedido.Efectivo);
        AddParam(cmd, "@Deposito", notaPedido.Deposito);
    }

    private static void AddParam(SqlCommand cmd, string name, object? value)
    {
        cmd.Parameters.AddWithValue(name, value ?? DBNull.Value);
    }

    private static NotaPedido Map(SqlDataReader reader)
    {
        return new NotaPedido
        {
            NotaId = Convert.ToInt64(reader["NotaId"]),
            NotaDocu = reader["NotaDocu"].ToString(),
            ClienteId = reader["ClienteId"] == DBNull.Value ? null : Convert.ToInt64(reader["ClienteId"]),
            NotaFecha = ToNullableDate(reader["NotaFecha"]),
            NotaUsuario = reader["NotaUsuario"].ToString(),
            NotaFormaPago = reader["NotaFormaPago"].ToString(),
            NotaCondicion = reader["NotaCondicion"].ToString(),
            NotaFechaPago = ToNullableDate(reader["NotaFechaPago"]),
            NotaDireccion = reader["NotaDireccion"].ToString(),
            NotaTelefono = reader["NotaTelefono"].ToString(),
            NotaSubtotal = reader["NotaSubtotal"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaSubtotal"]),
            NotaMovilidad = reader["NotaMovilidad"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaMovilidad"]),
            NotaDescuento = reader["NotaDescuento"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaDescuento"]),
            NotaTotal = reader["NotaTotal"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaTotal"]),
            NotaAcuenta = reader["NotaAcuenta"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaAcuenta"]),
            NotaSaldo = reader["NotaSaldo"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaSaldo"]),
            NotaAdicional = reader["NotaAdicional"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaAdicional"]),
            NotaTarjeta = reader["NotaTarjeta"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaTarjeta"]),
            NotaPagar = reader["NotaPagar"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaPagar"]),
            NotaEstado = reader["NotaEstado"].ToString(),
            CompaniaId = reader["CompaniaId"] == DBNull.Value ? null : Convert.ToInt32(reader["CompaniaId"]),
            NotaEntrega = reader["NotaEntrega"].ToString(),
            ModificadoPor = reader["ModificadoPor"].ToString(),
            FechaEdita = ToNullableDate(reader["FechaEdita"]),
            NotaConcepto = reader["NotaConcepto"].ToString(),
            NotaSerie = reader["NotaSerie"].ToString(),
            NotaNumero = reader["NotaNumero"].ToString(),
            NotaGanancia = reader["NotaGanancia"] == DBNull.Value ? null : Convert.ToDecimal(reader["NotaGanancia"]),
            ICBPER = reader["ICBPER"] == DBNull.Value ? null : Convert.ToDecimal(reader["ICBPER"]),
            CajaId = reader["CajaId"] == DBNull.Value ? null : Convert.ToInt32(reader["CajaId"]),
            EntidadBancaria = reader["EntidadBancaria"].ToString(),
            NroOperacion = reader["NroOperacion"].ToString(),
            Efectivo = reader["Efectivo"] == DBNull.Value ? null : Convert.ToDecimal(reader["Efectivo"]),
            Deposito = reader["Deposito"] == DBNull.Value ? null : Convert.ToDecimal(reader["Deposito"]),
            EstadoSunat = reader["EstadoSunat"] == DBNull.Value ? null : reader["EstadoSunat"].ToString()
        };
    }

    private static DateTime? ToNullableDate(object? value)
    {
        if (value == null || value == DBNull.Value) return null;
        if (value is string s)
        {
            if (string.IsNullOrWhiteSpace(s)) return null;
            return DateTime.TryParse(s, out var parsed) ? parsed : null;
        }

        try
        {
            return Convert.ToDateTime(value);
        }
        catch
        {
            return null;
        }
    }

    private static DetalleNota MapDetalle(SqlDataReader reader)
    {
        return new DetalleNota
        {
            DetalleId = Convert.ToInt64(reader["DetalleId"]),
            NotaId = Convert.ToInt64(reader["NotaId"]),
            IdProducto = reader["IdProducto"] == DBNull.Value ? null : Convert.ToInt64(reader["IdProducto"]),
            DetalleCantidad = reader["DetalleCantidad"] == DBNull.Value ? null : Convert.ToDecimal(reader["DetalleCantidad"]),
            DetalleUm = reader["DetalleUm"].ToString(),
            DetalleDescripcion = reader["DetalleDescripcion"].ToString(),
            DetalleCosto = reader["DetalleCosto"] == DBNull.Value ? null : Convert.ToDecimal(reader["DetalleCosto"]),
            DetallePrecio = reader["DetallePrecio"] == DBNull.Value ? null : Convert.ToDecimal(reader["DetallePrecio"]),
            DetalleImporte = reader["DetalleImporte"] == DBNull.Value ? null : Convert.ToDecimal(reader["DetalleImporte"]),
            DetalleEstado = reader["DetalleEstado"].ToString(),
            CantidadSaldo = reader["CantidadSaldo"] == DBNull.Value ? null : Convert.ToDecimal(reader["CantidadSaldo"]),
            ValorUM = reader["ValorUM"] == DBNull.Value ? null : Convert.ToDecimal(reader["ValorUM"])
        };
    }

    private async Task<NotaPedido?> ObtenerPorIdDesdeListarPedidosAsync(long notaId, CancellationToken cancellationToken)
    {
        await using var con = new SqlConnection(_connectionString);
        await using var cmd = new SqlCommand("listarPedidos", con)
        {
            CommandType = CommandType.StoredProcedure,
            CommandTimeout = 300
        };

        await con.OpenAsync(cancellationToken);
        await using var reader = await cmd.ExecuteReaderAsync(cancellationToken);

        while (await reader.ReadAsync(cancellationToken))
        {
            var idValue = SafeToNullableLong(reader["NotaId"]);
            if (idValue != notaId)
            {
                continue;
            }

            return new NotaPedido
            {
                NotaId = idValue ?? 0,
                NotaDocu = SafeToNullableString(reader["NotaDocu"]),
                ClienteId = SafeToNullableLong(reader["ClienteId"]),
                NotaFecha = SafeToNullableDate(reader["NotaFecha"]),
                NotaUsuario = SafeToNullableString(reader["NotaUsuario"]),
                NotaFormaPago = SafeToNullableString(reader["NotaFormaPago"]),
                NotaCondicion = SafeToNullableString(reader["NotaCondicion"]),
                NotaFechaPago = SafeToNullableDate(reader["NotaFechaPago"]),
                NotaDireccion = SafeToNullableString(reader["NotaDireccion"]),
                NotaTelefono = SafeToNullableString(reader["NotaTelefono"]),
                NotaSubtotal = SafeToNullableDecimal(reader["NotaSubtotal"]),
                NotaMovilidad = SafeToNullableDecimal(reader["NotaMovilidad"]),
                NotaDescuento = SafeToNullableDecimal(reader["NotaDescuento"]),
                NotaTotal = SafeToNullableDecimal(reader["OpGravada"] ?? reader["NotaTotal"]),
                NotaAcuenta = SafeToNullableDecimal(reader["NotaAcuenta"]),
                NotaSaldo = SafeToNullableDecimal(reader["SaldoDocumento"] ?? reader["NotaSaldo"]),
                NotaAdicional = SafeToNullableDecimal(reader["NotaAdicional"]),
                NotaTarjeta = SafeToNullableDecimal(reader["TotalTarjeta"] ?? reader["NotaTarjeta"]),
                NotaPagar = SafeToNullableDecimal(reader["TotalPagar"] ?? reader["NotaPagar"]),
                NotaEstado = SafeToNullableString(reader["NotaEstado"]),
                CompaniaId = SafeToNullableInt(reader["CompaniaId"]),
                NotaEntrega = SafeToNullableString(reader["Entrega"] ?? reader["NotaEntrega"]),
                ModificadoPor = SafeToNullableString(reader["ModificadoPor"]),
                FechaEdita = SafeToNullableDate(reader["FechaEdita"]),
                NotaConcepto = SafeToNullableString(reader["NotaConcepto"]),
                NotaSerie = SafeToNullableString(reader["NotaSerie"]),
                NotaNumero = SafeToNullableString(reader["NotaNumero"])
            };
        }

        return null;
    }

    private static NotaPedido? ParseNotaPedidoFromStoredProcedure(string? raw)
    {
        if (string.IsNullOrWhiteSpace(raw))
        {
            return null;
        }

        var normalized = raw.Trim();
        if (normalized == "~" || normalized.Equals("FORMATO_INVALIDO", StringComparison.OrdinalIgnoreCase))
        {
            return null;
        }

        var header = normalized;
        var detailSection = string.Empty;
        var splitIndex = normalized.IndexOf('[');
        if (splitIndex >= 0)
        {
            header = normalized[..splitIndex];
            detailSection = splitIndex + 1 < normalized.Length ? normalized[(splitIndex + 1)..] : string.Empty;
        }

        var fields = header.Split('|');
        if (fields.Length < 32)
        {
            return null;
        }

        var estadoSunat = string.Empty;
        var firstDetail = detailSection
            .Split(';', StringSplitOptions.RemoveEmptyEntries)
            .FirstOrDefault(x => x.StartsWith("DET|", StringComparison.OrdinalIgnoreCase));
        if (!string.IsNullOrWhiteSpace(firstDetail))
        {
            var detailFields = firstDetail.Split('|');
            if (detailFields.Length > 12)
            {
                estadoSunat = detailFields[12].Trim();
            }
        }

        return new NotaPedido
        {
            NotaId = ToLongValue(fields, 0),
            NotaDocu = ToNullableStringValue(fields, 1),
            ClienteId = ToNullableLongValue(fields, 2),
            NotaFecha = ToNullableDateValue(fields, 3),
            NotaUsuario = ToNullableStringValue(fields, 4),
            NotaFormaPago = ToNullableStringValue(fields, 5),
            NotaCondicion = ToNullableStringValue(fields, 6),
            NotaFechaPago = ToNullableDateValue(fields, 7),
            NotaDireccion = ToNullableStringValue(fields, 8),
            NotaTelefono = ToNullableStringValue(fields, 9),
            NotaSubtotal = ToNullableDecimalValue(fields, 10),
            NotaMovilidad = ToNullableDecimalValue(fields, 11),
            NotaDescuento = ToNullableDecimalValue(fields, 12),
            NotaTotal = ToNullableDecimalValue(fields, 13),
            NotaAcuenta = ToNullableDecimalValue(fields, 14),
            NotaSaldo = ToNullableDecimalValue(fields, 15),
            NotaAdicional = ToNullableDecimalValue(fields, 16),
            NotaTarjeta = ToNullableDecimalValue(fields, 17),
            NotaPagar = ToNullableDecimalValue(fields, 18),
            NotaEstado = ToNullableStringValue(fields, 19),
            CompaniaId = ToNullableIntValue(fields, 20),
            NotaEntrega = ToNullableStringValue(fields, 21),
            ModificadoPor = ToNullableStringValue(fields, 22),
            FechaEdita = ToNullableDateValue(fields, 23),
            NotaConcepto = ToNullableStringValue(fields, 24),
            NotaSerie = ToNullableStringValue(fields, 25),
            NotaNumero = ToNullableStringValue(fields, 26),
            NotaGanancia = ToNullableDecimalValue(fields, 27),
            ICBPER = ToNullableDecimalValue(fields, 28),
            CajaId = ToNullableIntValue(fields, 29),
            EntidadBancaria = ToNullableStringValue(fields, 30),
            NroOperacion = ToNullableStringValue(fields, 31),
            EstadoSunat = string.IsNullOrWhiteSpace(estadoSunat) ? null : estadoSunat
        };
    }

    private static List<DetalleNota> ParseDetalleNotaDesdeListaDetalleNotaB(string? raw)
    {
        var lista = new List<DetalleNota>();
        if (string.IsNullOrWhiteSpace(raw))
        {
            return lista;
        }

        var firstBlock = raw.Split('[', 2)[0];
        var rows = firstBlock.Split('¬', StringSplitOptions.RemoveEmptyEntries);
        if (rows.Length <= 3)
        {
            return lista;
        }

        for (var i = 3; i < rows.Length; i++)
        {
            var row = rows[i];
            if (string.IsNullOrWhiteSpace(row) || row == "~")
            {
                continue;
            }

            var fields = row.Split('|');
            if (fields.Length < 14)
            {
                continue;
            }

            lista.Add(new DetalleNota
            {
                DetalleId = ToLongValue(fields, 0),
                NotaId = ToLongValue(fields, 1),
                IdProducto = ToNullableLongValue(fields, 2),
                DetalleCantidad = ToNullableDecimalValue(fields, 4),
                DetalleUm = ToNullableStringValue(fields, 5),
                DetalleDescripcion = ToNullableStringValue(fields, 6),
                DetalleCosto = ToNullableDecimalValue(fields, 7),
                DetallePrecio = ToNullableDecimalValue(fields, 8),
                DetalleImporte = ToNullableDecimalValue(fields, 9),
                DetalleEstado = ToNullableStringValue(fields, 10),
                CantidadSaldo = ToNullableDecimalValue(fields, 11),
                ValorUM = ToNullableDecimalValue(fields, 13)
            });
        }

        return lista;
    }

    private static string? ToNullableStringValue(string[] fields, int index)
    {
        if (index >= fields.Length)
        {
            return null;
        }

        var value = fields[index].Trim();
        return string.IsNullOrWhiteSpace(value) ? null : value;
    }

    private static long ToLongValue(string[] fields, int index)
    {
        var value = ToNullableStringValue(fields, index);
        return long.TryParse(value, NumberStyles.Integer, CultureInfo.InvariantCulture, out var parsed)
            ? parsed
            : 0L;
    }

    private static long? ToNullableLongValue(string[] fields, int index)
    {
        var value = ToNullableStringValue(fields, index);
        return long.TryParse(value, NumberStyles.Integer, CultureInfo.InvariantCulture, out var parsed)
            ? parsed
            : null;
    }

    private static int? ToNullableIntValue(string[] fields, int index)
    {
        var value = ToNullableStringValue(fields, index);
        return int.TryParse(value, NumberStyles.Integer, CultureInfo.InvariantCulture, out var parsed)
            ? parsed
            : null;
    }

    private static DateTime? ToNullableDateValue(string[] fields, int index)
    {
        var value = ToNullableStringValue(fields, index);
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        if (DateTime.TryParse(value, CultureInfo.InvariantCulture, DateTimeStyles.None, out var parsedInvariant))
        {
            return parsedInvariant;
        }

        return DateTime.TryParse(value, CultureInfo.CurrentCulture, DateTimeStyles.None, out var parsedCurrent)
            ? parsedCurrent
            : null;
    }

    private static decimal? ToNullableDecimalValue(string[] fields, int index)
    {
        var value = ToNullableStringValue(fields, index);
        if (string.IsNullOrWhiteSpace(value))
        {
            return null;
        }

        if (decimal.TryParse(value, NumberStyles.Number, CultureInfo.InvariantCulture, out var parsedInvariant))
        {
            return parsedInvariant;
        }

        return decimal.TryParse(value, NumberStyles.Number, CultureInfo.CurrentCulture, out var parsedCurrent)
            ? parsedCurrent
            : null;
    }

    private static string? SafeToNullableString(object? value)
    {
        if (value is null || value == DBNull.Value)
        {
            return null;
        }

        var text = value.ToString()?.Trim();
        return string.IsNullOrWhiteSpace(text) ? null : text;
    }

    private static decimal? SafeToNullableDecimal(object? value)
    {
        var text = SafeToNullableString(value);
        if (string.IsNullOrWhiteSpace(text))
        {
            return null;
        }

        if (decimal.TryParse(text, NumberStyles.Number, CultureInfo.InvariantCulture, out var parsedInvariant))
        {
            return parsedInvariant;
        }

        return decimal.TryParse(text, NumberStyles.Number, CultureInfo.CurrentCulture, out var parsedCurrent)
            ? parsedCurrent
            : null;
    }

    private static long? SafeToNullableLong(object? value)
    {
        var text = SafeToNullableString(value);
        return long.TryParse(text, NumberStyles.Integer, CultureInfo.InvariantCulture, out var parsed)
            ? parsed
            : null;
    }

    private static int? SafeToNullableInt(object? value)
    {
        var text = SafeToNullableString(value);
        return int.TryParse(text, NumberStyles.Integer, CultureInfo.InvariantCulture, out var parsed)
            ? parsed
            : null;
    }

    private static DateTime? SafeToNullableDate(object? value)
    {
        var text = SafeToNullableString(value);
        if (string.IsNullOrWhiteSpace(text))
        {
            return null;
        }

        if (DateTime.TryParse(text, CultureInfo.InvariantCulture, DateTimeStyles.None, out var parsedInvariant))
        {
            return parsedInvariant;
        }

        return DateTime.TryParse(text, CultureInfo.CurrentCulture, DateTimeStyles.None, out var parsedCurrent)
            ? parsedCurrent
            : null;
    }

    private static Dictionary<string, int> BuildOrdinals(SqlDataReader reader)
    {
        var ordinals = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase);
        for (var i = 0; i < reader.FieldCount; i++)
        {
            ordinals[reader.GetName(i)] = i;
        }

        return ordinals;
    }

    private static string? GetString(SqlDataReader reader, IReadOnlyDictionary<string, int> ordinals, params string[] candidateColumns)
    {
        foreach (var column in candidateColumns)
        {
            if (!ordinals.TryGetValue(column, out var ordinal))
            {
                continue;
            }

            if (reader.IsDBNull(ordinal))
            {
                return null;
            }

            return Convert.ToString(reader.GetValue(ordinal), CultureInfo.CurrentCulture);
        }

        return null;
    }

    private static (int page, int pageSize) NormalizePagination(int page, int pageSize)
    {
        var normalizedPage = page < 1 ? 1 : page;
        var normalizedPageSize = pageSize < 1 ? 1 : Math.Min(pageSize, 100);
        return (normalizedPage, normalizedPageSize);
    }

    private static string SelectOrNull(string columnName, string sqlType, bool hasColumn)
    {
        return hasColumn
            ? columnName
            : $"CAST(NULL AS {sqlType}) AS {columnName}";
    }

    private static async Task<bool> HasColumnAsync(
        SqlConnection connection,
        string tableName,
        string columnName,
        CancellationToken cancellationToken)
    {
        const string sql = """
            SELECT TOP 1 1
            FROM sys.columns c
            INNER JOIN sys.tables t ON t.object_id = c.object_id
            WHERE t.name = @TableName
              AND c.name = @ColumnName;
            """;

        await using var cmd = new SqlCommand(sql, connection)
        {
            CommandType = CommandType.Text,
            CommandTimeout = 30
        };
        cmd.Parameters.AddWithValue("@TableName", tableName);
        cmd.Parameters.AddWithValue("@ColumnName", columnName);

        var value = await cmd.ExecuteScalarAsync(cancellationToken);
        return value is not null && value != DBNull.Value;
    }
}
