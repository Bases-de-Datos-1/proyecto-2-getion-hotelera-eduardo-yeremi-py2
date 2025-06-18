namespace GestionHotelera.Models.FacturasYReservasModel
{
    public class ReservacionesTemporalesModel
    {

        public int IdReservacionTemporal { get; set; }

        public DateOnly FechaHoraIngreso { get; set; }

        public DateOnly FechaHoraSalida { get; set; }

        public int CantidadPersonas { get; set; }

        public string Vehiculo { get; set; }

        public int PrecioTotal { get; set; }

        public string Estado { get; set; }

        public int EstadiaTotal { get; set; }


        public string Cliente { get; set; }

        public string IdEmpresaHospedaje { get; set; }

        public int IdDatosHabitacion { get; set; }

        public int NumeroHabitacion { get; set; }


    }
}
