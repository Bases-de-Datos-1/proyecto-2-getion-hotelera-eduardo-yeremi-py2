using GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels;

namespace GestionHotelera.Models.VistasModel
{
    public class RegistrarTipoDeHabitacionViewModel
    {
        public List<TipoCamasModel> ListaTiposDeCamas { get; set; } = new List<TipoCamasModel>();

        public List<ComodidadesHabitacionModel> ListaComodidades { get; set; } = new List<ComodidadesHabitacionModel>();
    
    }
}
