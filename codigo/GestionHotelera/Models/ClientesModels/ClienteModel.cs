namespace GestionHotelera.Models.ClientesModels
{
    public class ClienteModel
    {

        public string Cedula { get; set; }

        public string NombreCompleto { get; set; }

        public string TipoIdentificacion { get; set; }

        public int  IdPais { get; set; }

        public string PaisResidencia { get; set; }

        public DateOnly FechaNacimiento { get; set; }

        public int Edad { get; set; }

        public string CorreoElectronico { get; set; }

        // La ubicacion.

        public string? NombreProvincia { get; set; }

        public int IdProvincia { get; set; }


        public string? NombreCanton { get; set; }

        public int IdCanton { get; set; }


        public string? NombreDistrito { get; set; }

        public int IdDistrito { get; set; }

        public List<TelefonoClienteModel> Telefonos { get; set; } = new List<TelefonoClienteModel>();


    }
}
