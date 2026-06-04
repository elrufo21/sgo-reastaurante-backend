using Ecommerce.Domain;

namespace Ecommerce.Application.Contracts.Mesas;

public interface IMesa
{
    Task<IReadOnlyList<Mesa>> ListarAsync(int page = 1, int pageSize = 50, CancellationToken cancellationToken = default);
    Task<MesaOrdenActiva?> ObtenerOrdenActivaPorMesaAsync(int idMesa, CancellationToken cancellationToken = default);
    Task<MesaSeleccion> ResolverSeleccionMesaAsync(int idMesa, string serie = "0001", CancellationToken cancellationToken = default);
    Task<MesaActualizarEstadoPedidoResponse> ActualizarEstadoPedidoAsync(MesaActualizarEstadoPedidoRequest request, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<MesaPedidoEstadoItem>> ListarPedidosPorEstadoAsync(IReadOnlyList<string>? estados = null, int page = 1, int pageSize = 50, CancellationToken cancellationToken = default);
    Task<MesaGuardarPedidoResponse> GuardarPedidoAsync(MesaGuardarPedidoRequest request, CancellationToken cancellationToken = default);
    Task<MesaCombinacionOperacionResponse> AgregarMesaCombinadaAsync(MesaCombinacionOperacionRequest request, CancellationToken cancellationToken = default);
    Task<MesaCombinacionOperacionResponse> QuitarMesaCombinadaAsync(MesaCombinacionOperacionRequest request, CancellationToken cancellationToken = default);
    Task<MesaCambioResponse> CambiarMesaCombinadaAsync(MesaCambioRequest request, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<MesaCombinada>> ListarMesasCombinadasAsync(long idOrden, CancellationToken cancellationToken = default);
    Task<IReadOnlyList<MesaCombinada>> ListarMesasLibresAsync(CancellationToken cancellationToken = default);
    Task<IReadOnlyList<MesaListaCobro>> ListarMesasOcupadasListasCobrarAsync(CancellationToken cancellationToken = default);
}
