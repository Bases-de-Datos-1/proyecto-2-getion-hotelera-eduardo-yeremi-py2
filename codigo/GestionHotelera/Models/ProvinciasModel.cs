namespace GestionHotelera.Models
{
    public class ProvinciasModel
    {
        public int IdProvincia { get; set; }

        public string NombreProvincia { get; set; }

        public List<CantonModel> Cantones { get; set; } = new List<CantonModel>();
    }
}
