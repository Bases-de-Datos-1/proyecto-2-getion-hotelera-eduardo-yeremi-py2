namespace GestionHotelera.Models.FiltrosBusquedaModel.FiltrosBusqueda
{
    public class FiltrosBusquedaEmpresaRecreacionModel
    {
        public string BarraBusqueda { get; set; }

        public List<string> ListaServicios { get; set; }

        public int? IdProvincia { get; set; }

        public int? IdCanton { get; set; }

        public int? IdDistrito { get; set; }

    }
}
