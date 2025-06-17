namespace GestionHotelera.Models.FiltrosBusquedaModel.FiltrosBusqueda
{
    public class FiltrosBusquedaServiciosRecreacionModel
    {

        public string BarraBusqueda { get; set; }

        public double? PrecioMinimo { get; set; }

        public double? PrecioMaximo { get; set; }

        public List<string> ListaActividades { get; set; }

        public int? IdProvincia { get; set; }

        public int? IdCanton { get; set; }

        public int? IdDistrito { get; set; }

    }
}
