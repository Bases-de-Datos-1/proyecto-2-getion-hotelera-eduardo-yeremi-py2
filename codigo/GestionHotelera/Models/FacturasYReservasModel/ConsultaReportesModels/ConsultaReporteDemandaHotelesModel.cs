namespace GestionHotelera.Models.FacturasYReservasModel.ConsultaReportesModels
{
    public class ConsultaReporteDemandaHotelesModel
    {

        public DateOnly FechaDemanda {  get; set; }

        public int? Provincia { get; set; }

        public int? Canton { get; set; }

        public int? Distrito { get; set; }

    }
}
