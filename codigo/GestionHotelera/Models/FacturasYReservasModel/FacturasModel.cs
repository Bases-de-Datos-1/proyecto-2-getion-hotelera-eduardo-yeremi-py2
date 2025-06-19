namespace GestionHotelera.Models.FacturasYReservasModel
{
    public class FacturasModel
    {

        public int IdFacturacion { get; set; }

        public int IdReservacion { get; set; }

        public DateOnly FechaFacturacion { get; set; }

        public string MetodoPago { get; set; }

        public int CantidadPersonas { get; set; }

        public double PrecioTotal { get; set; }

        public int NumeroHabitacion { get; set; }

        public int IdTipoHabitacion { get; set; }

        public string Cliente { get; set; }

        public int EstadiaTotal { get; set; }


    }
}
