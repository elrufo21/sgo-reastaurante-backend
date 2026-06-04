using System.Diagnostics;
using Microsoft.AspNetCore.Mvc;

namespace Ecommerce.Api.Controllers;

[ApiController]
[Route("api/v1/[controller]")]
public class PrintController : ControllerBase
{
    private const int DefaultTimeoutMs = 15000;
    private const string DefaultPrintSettings = "noscale,portrait";
    private const string DefaultTempFolderName = "PrintTemp";

    private static readonly HashSet<string> AllowedPdfContentTypes = new(StringComparer.OrdinalIgnoreCase)
    {
        "application/pdf",
        "application/octet-stream"
    };

    private readonly IConfiguration _configuration;
    private readonly ILogger<PrintController> _logger;

    public PrintController(IConfiguration configuration, ILogger<PrintController> logger)
    {
        _configuration = configuration;
        _logger = logger;
    }

    [HttpPost("pdf")]
    [Consumes("multipart/form-data")]
    [RequestFormLimits(MultipartBodyLengthLimit = 20 * 1024 * 1024)]
    public async Task<IActionResult> PrintPdf([FromForm] IFormFile? file, CancellationToken cancellationToken)
    {
        var pdf = file ?? Request.Form.Files.FirstOrDefault();
        if (pdf is null || pdf.Length == 0)
        {
            return BadRequest(new { ok = false, message = "No se recibió el PDF." });
        }

        if (!IsValidPdf(pdf, out var validationMessage))
        {
            return BadRequest(new { ok = false, message = validationMessage });
        }

        var printerName = _configuration["PrintSettings:PrinterName"];
        var sumatraPath = _configuration["PrintSettings:SumatraPath"];
        var printSettings = _configuration["PrintSettings:PdfPrintOptions"] ?? DefaultPrintSettings;
        var timeoutMs = GetTimeoutMs();
        var tempFolderName = _configuration["PrintSettings:TempFolderName"] ?? DefaultTempFolderName;

        if (string.IsNullOrWhiteSpace(printerName))
        {
            return StatusCode(500, new { ok = false, message = "Falta configurar PrintSettings:PrinterName." });
        }

        if (string.IsNullOrWhiteSpace(sumatraPath))
        {
            return StatusCode(500, new { ok = false, message = "Falta configurar PrintSettings:SumatraPath." });
        }

        if (!System.IO.File.Exists(sumatraPath))
        {
            return StatusCode(500, new { ok = false, message = $"No se encontró SumatraPDF en: {sumatraPath}" });
        }

        var tempFolder = Path.Combine(Path.GetTempPath(), tempFolderName);
        Directory.CreateDirectory(tempFolder);
        var tempFile = Path.Combine(tempFolder, $"{Guid.NewGuid():N}.pdf");

        try
        {
            await using (var stream = System.IO.File.Create(tempFile))
            {
                await pdf.CopyToAsync(stream, cancellationToken);
            }

            var psi = new ProcessStartInfo
            {
                FileName = sumatraPath,
                Arguments = $"-print-to \"{printerName}\" -print-settings \"{printSettings}\" -silent \"{tempFile}\"",
                CreateNoWindow = true,
                UseShellExecute = false,
                WindowStyle = ProcessWindowStyle.Hidden
            };

            using var process = Process.Start(psi);
            if (process is null)
            {
                throw new InvalidOperationException("No se pudo iniciar SumatraPDF.");
            }

            using var timeoutCts = CancellationTokenSource.CreateLinkedTokenSource(cancellationToken);
            timeoutCts.CancelAfter(timeoutMs);
            try
            {
                await process.WaitForExitAsync(timeoutCts.Token);
            }
            catch (OperationCanceledException) when (!cancellationToken.IsCancellationRequested)
            {
                TryKillProcess(process);
                throw new TimeoutException($"SumatraPDF demoró más de {timeoutMs} ms en imprimir.");
            }

            if (process.ExitCode != 0)
            {
                throw new InvalidOperationException($"SumatraPDF terminó con código {process.ExitCode}.");
            }

            return Ok(new
            {
                ok = true,
                message = "PDF enviado a imprimir."
            });
        }
        catch (OperationCanceledException) when (cancellationToken.IsCancellationRequested)
        {
            return StatusCode(499, new
            {
                ok = false,
                message = "La solicitud fue cancelada por el cliente."
            });
        }
        catch (Exception ex)
        {
            _logger.LogError(ex, "Error al imprimir PDF.");
            return StatusCode(500, new
            {
                ok = false,
                message = "Error al imprimir PDF.",
                error = ex.Message
            });
        }
        finally
        {
            TryDeleteTempFile(tempFile);
        }
    }

    private int GetTimeoutMs()
    {
        if (int.TryParse(_configuration["PrintSettings:TimeoutMs"], out var timeoutMs) && timeoutMs > 0)
        {
            return timeoutMs;
        }

        return DefaultTimeoutMs;
    }

    private static bool IsValidPdf(IFormFile file, out string message)
    {
        var extension = Path.GetExtension(file.FileName);
        if (!string.Equals(extension, ".pdf", StringComparison.OrdinalIgnoreCase))
        {
            message = "El archivo debe tener extensión .pdf.";
            return false;
        }

        if (!string.IsNullOrWhiteSpace(file.ContentType) && !AllowedPdfContentTypes.Contains(file.ContentType))
        {
            message = $"Tipo de archivo no permitido: {file.ContentType}.";
            return false;
        }

        message = string.Empty;
        return true;
    }

    private static void TryKillProcess(Process process)
    {
        try
        {
            if (!process.HasExited)
            {
                process.Kill(true);
            }
        }
        catch
        {
            // Ignorado: mejor esfuerzo para terminar el proceso.
        }
    }

    private static void TryDeleteTempFile(string tempFile)
    {
        try
        {
            if (System.IO.File.Exists(tempFile))
            {
                System.IO.File.Delete(tempFile);
            }
        }
        catch
        {
            // Ignorado: limpieza best effort.
        }
    }
}
