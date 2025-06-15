namespace GestionHotelera.Models.EmpresaHospedajeModels.HabitacionesModels
{
    public class TiposHabitacionesModel
    {

        public string IdEmpresa { get; set; }

        public int IdTipoHabitacion { get; set; }

        public string NombreTipoHabitacion { get; set; }

        public string Descripcion { get; set; }

        public int IdTipoCama { get; set; }

        public string NombreCama { get; set; }

        public string Precio { get; set; }

        public List<FotosTipoHabitacionModel> Imagenes { get; set; } = new List<FotosTipoHabitacionModel>();

        public List<ComodidadesHabitacionModel> Comodidades { get; set; } = new List<ComodidadesHabitacionModel>();

    }
}
