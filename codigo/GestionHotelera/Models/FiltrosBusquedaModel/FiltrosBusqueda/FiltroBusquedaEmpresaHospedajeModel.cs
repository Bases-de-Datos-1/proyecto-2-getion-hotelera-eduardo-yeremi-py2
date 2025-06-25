namespace GestionHotelera.Models.FiltrosBusquedaModel.FiltrosBusqueda
{
    public class FiltroBusquedaEmpresaHospedajeModel
    {
        public string BarraBusqueda { get; set; }

        public int? IdTipoHotel { get; set; }

        public List<int> ListaServicios { get; set; }

        public int? IdProvincia { get; set; }
        public int? IdCanton { get; set; }
        public int? IdDistrito { get; set; }

    }
}
