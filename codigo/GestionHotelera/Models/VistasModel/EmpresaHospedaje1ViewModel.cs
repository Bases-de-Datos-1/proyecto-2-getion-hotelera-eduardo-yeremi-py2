using GestionHotelera.Models.EmpresaHospedajeModels;
using GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels;

namespace GestionHotelera.Models.VistasModel
{
    public class EmpresaHospedaje1ViewModel
    {
        public EmpresaHospedajeModel DatosEmpresa { get; set; }

        public List<TiposHabitacionesModel> ListaTipoHabitaciones { get; set; } = new List<TiposHabitacionesModel>();

        public List<DatosHabitacionesModel> ListaHabitaciones { get; set; } = new List<DatosHabitacionesModel>();


    }
}
