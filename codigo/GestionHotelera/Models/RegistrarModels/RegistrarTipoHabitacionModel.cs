namespace GestionHotelera.Models.RegistrarModels
{
    public class RegistrarTipoHabitacionModel
    {

        public string NombreTipoHabitacion { get; set; }

        public string Descripcion { get; set; }

        public int IdTipoCama { get; set; }

        public double PresioPorNoche { get; set; }

        public List<int> ListaComodidades { get; set; }


    }
}
