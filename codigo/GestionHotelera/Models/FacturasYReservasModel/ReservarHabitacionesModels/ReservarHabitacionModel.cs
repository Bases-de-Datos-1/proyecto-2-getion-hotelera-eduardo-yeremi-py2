namespace GestionHotelera.Models.FacturasYReservasModel.ReservarHabitacionesModels
{
    public class ReservarHabitacionModel
    {
        public int IdDatosHabitacion { get; set; }

        public string CedulaJuridica { get; set; }

        public DateTime FechaHoraEntrada { get; set; }

        public DateTime FechaHoraSalida { get; set; }

        public int CantidadPersonas { get; set; }

        public string? PoseeVehiculo { get; set; }


    }
}
