using GestionHotelera.Models.EmpresaHospedajeModels;
using GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels;

namespace GestionHotelera.Models.VistasModel
{
    public class RegistroEmpresaHospedajeViewModel
    {

        //public List<Red> ListaTiposCamas { get; set; } = new List<TipoCamasModel>();

        public List<TipoInstalacionModel> ListaTiposInstalaciones { get; set; } = new List<TipoInstalacionModel>();

        public List<ServiciosHotelModel> ListaServiciosHotel { get; set; } = new List<ServiciosHotelModel>();

        public List<ProvinciasModel> Provincias { get; set; } = new List<ProvinciasModel>();


    }
}
