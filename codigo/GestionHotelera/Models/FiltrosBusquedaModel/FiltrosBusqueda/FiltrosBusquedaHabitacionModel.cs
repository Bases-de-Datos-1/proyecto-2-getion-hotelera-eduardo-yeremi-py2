namespace GestionHotelera.Models.FiltrosBusquedaModel.FiltrosBusqueda
{
    public class FiltrosBusquedaHabitacionModel
    {
        public string BarraBusqueda { get; set; }

        public DateTime? FechaEntrada { get; set; }
        public DateTime? FechaSalida { get; set; }

        public int? IdTipoCama { get; set; }

        public List<int> ListaComodidades { get; set; }

        public double? PrecioMinimo { get; set; }
        public double? PrecioMaximo { get; set; }

        public int? IdProvincia { get; set; }
        public int? IdCanton { get; set; }
        public int? IdDistrito { get; set; }


    }
}
