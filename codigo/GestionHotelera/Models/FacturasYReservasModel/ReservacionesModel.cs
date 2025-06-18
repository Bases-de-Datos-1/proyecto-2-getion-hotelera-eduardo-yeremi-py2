namespace GestionHotelera.Models.FacturasYReservasModel
{
    public class ReservacionesModel
    {

        public int IdReservacion { get; set; }

        public DateOnly FechaHoraIngreso { get; set; }

        public DateOnly FechaHoraSalida { get; set; }

        public int CantidadPersonas { get; set; }

        public string Vehiculo { get; set; }

        public int PrecioTotal { get; set; }

        public string Estado { get; set; }

        public int EstadiaTotal { get; set; }

        public string Cliente { get; set; }

        public string PaisResidencia { get; set; }

        public int Edad { get; set; }


        public int IdDatosHabitacion { get; set; }

        public int NumeroHabitacion { get; set; }

        public string IdEmpresaHospedaje { get; set; }

    }
}
