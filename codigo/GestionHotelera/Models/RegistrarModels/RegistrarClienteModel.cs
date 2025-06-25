namespace GestionHotelera.Models.RegistrarModels
{
    public class RegistrarClienteModel
    {
        public string Cedula { get; set; }
        public string NombreCompleto { get; set; }

        public DateOnly FechaNacimiento { get; set; }

        public string TipoIdentificacion { get; set; } 

        public int paisResidencia { get; set; }

        public int? IdProvincia { get; set; }
        public int? IdCanton { get; set; }
        public int? IdDistrito { get; set; }

        public string Telefono1 { get; set; }

        public string? Telefono2 { get; set; }

        public string? Telefono3 { get; set; }

        public string CorreoElectronico { get; set; }
        public string Contrasena { get; set; }

        public string ConfirmarContrasena { get; set; }


    }
}
