namespace GestionHotelera.Models.EmpresaHospedajeModels
{
    public class EmpresaHospedajeModel
    {
        public string CedulaJuridica { get; set; } 

        public string NombreHotel { get; set; }

        public int IdTipoHotel { get; set; }

        public string NombreTipoHotel { get; set; }

        //public geography ReferenciaGPS { get; set; }

        public int IdProvincia { get; set; }
        public string NombreProvincia { get; set; }
        public int IdCanton { get; set; }
        public string NombreCanton { get; set; }

        public int IdDistrito { get; set; }
        public string NombreDistrito { get; set; }

        public string Barrio { get; set; }

        public string SenasExactas { get; set; }


        public string CorreoElectronico { get; set; }

        public string SitioWeb { get; set; }

        public string Contrasena { get; set; }


        public List<RedesSocialesModel> RedesSociales { get; set; } = new List<RedesSocialesModel>();

        public List<TelefonosEmpresaHospedajeModel> Telefonos { get; set; } = new List<TelefonosEmpresaHospedajeModel>();

        public List<ServiciosHotelModel> Servicios { get; set; } = new List<ServiciosHotelModel>();




    }
}
