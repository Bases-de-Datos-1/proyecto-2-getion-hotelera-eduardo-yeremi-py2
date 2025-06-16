namespace GestionHotelera.Models.EmpresaRecreacionModels.ServiciosModels
{
    public class ServiciosEmpresaRecreacionModel
    {
        public int IdServicio { get; set; }

        public string NombreServicio { get; set; }

        public double Precio { get; set; } 

        public string CedulaJuridica { get; set; }

        public int IdProvincia { get; set; }

        public string NombreProvincia { get; set; }

        public int IdCanton { get; set; }

        public string NombreCanton { get; set; }

        public int IdDistrito { get; set; }

        public string NombreDistrito { get; set; }

        public List<ActividadesEmpresaRecreacionModel> ListaActividades = new List<ActividadesEmpresaRecreacionModel>();
    }
}
