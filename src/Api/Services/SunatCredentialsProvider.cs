using Ecommerce.Api.Interfaces;
using Ecommerce.Api.Models;
using Ecommerce.Api.Options;
using Microsoft.Extensions.Options;

namespace Ecommerce.Api.Services;

public class SunatCredentialsProvider : ISunatCredentialsProvider
{
    private readonly ILogger<SunatCredentialsProvider> _logger;
    private readonly SunatOptions _options;

    public SunatCredentialsProvider(
        IOptions<SunatOptions> options,
        ILogger<SunatCredentialsProvider> logger)
    {
        _options = options.Value;
        _logger = logger;
    }

    public Task<SunatCredentials> GetCredentialsAsync(CancellationToken cancellationToken = default)
    {
        var credentials = BuildFromOptions();

        _logger.LogWarning(
            "Credenciales SUNAT cargadas desde appsettings.json. No se usara la tabla Compania. RUC: {Ruc}. UsuarioSol: {UsuarioSol}. ClientId: {ClientId}.",
            Mask(credentials.Ruc),
            Mask(credentials.UsuarioSol),
            Mask(credentials.ClientId));

        return Task.FromResult(credentials);
    }

    private SunatCredentials BuildFromOptions()
    {
        return new SunatCredentials
        {
            ClientId = _options.ClientId,
            ClientSecret = _options.ClientSecret,
            Ruc = _options.Ruc,
            UsuarioSol = _options.UsuarioSol,
            ClaveSol = _options.ClaveSol,
            SireBaseUrl = _options.SireBaseUrl,
            Scope = _options.Scope,
            SeguridadBaseUrl = _options.SeguridadBaseUrl
        };
    }

    private static string Mask(string value)
    {
        if (string.IsNullOrWhiteSpace(value))
        {
            return "(vacio)";
        }

        var trimmed = value.Trim();
        if (trimmed.Length <= 4)
        {
            return new string('*', trimmed.Length);
        }

        return $"{trimmed[..2]}***{trimmed[^2..]}";
    }
}
