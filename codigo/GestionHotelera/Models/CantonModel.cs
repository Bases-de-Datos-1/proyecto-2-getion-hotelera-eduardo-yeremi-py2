namespace GestionHotelera.Models
{
    public class CantonModel
    {
        public int IdCanton { get; set; }

        public string NombreCanton { get; set; }

        public int IdProvincia { get; set; }

        public List<DistritoModel> Distritos { get; set; } = new List<DistritoModel>();

    }
}
