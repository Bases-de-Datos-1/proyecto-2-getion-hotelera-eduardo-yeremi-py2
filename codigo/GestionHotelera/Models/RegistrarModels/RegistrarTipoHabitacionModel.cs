namespace GestionHotelera.Models.RegistrarModels
{
    public class RegistrarTipoHabitacionModel
    {

        public string NombreTipoHabitacion { get; set; }

        public string Descripcion { get; set; }

        public int TipoCama { get; set; }

        public double PrecioPorNoche { get; set; }

        public List<int> ListaComodidades { get; set; }


    }
}
