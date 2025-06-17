using GestionHotelera.Models.EmpresaHospedajeModels;
using GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels;
using GestionHotelera.Models.EmpresaRecreacionModels.ServiciosModels;

namespace GestionHotelera.Models.VistasModel
{
    public class CatalogoViewModel
    {

        // Para los filtros de ubicaciones.
        public List<ProvinciasModel> Provincias { get; set; } = new List<ProvinciasModel>();


        // Para los filtros de empresa de hoespdaje.
        public List<TipoInstalacionModel> ListaTiposInstalaciones { get; set; } = new List<TipoInstalacionModel>();

        public List<ServiciosHotelModel> ListaServiciosHotel { get; set; } = new List<ServiciosHotelModel>();


        // Para los filtros de habitaciones.
        public List<TipoCamasModel> ListaTiposDeCamas { get; set; } = new List<TipoCamasModel>();

        public List<ComodidadesHabitacionModel> ListaComodidades { get; set; } = new List<ComodidadesHabitacionModel>();


        // Para los filtros de empresa de recreacion.
        public List<ServiciosEmpresaRecreacionModel> ServiciosEmpresaRecreacion { get; set; } = new List<ServiciosEmpresaRecreacionModel>();


        // Para los filtros de actividades de recreacion.
        public List<ActividadesEmpresaRecreacionModel> ListaActividades { get; set; } = new List<ActividadesEmpresaRecreacionModel>();


    }
}
