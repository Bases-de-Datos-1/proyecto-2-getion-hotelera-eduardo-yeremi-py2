namespace GestionHotelera.Models.EmpresaRecreacionModels
{
    public class EmpresaRecreacionModel
    {
        public string CedulaJuridica { get; set; }

        public string NombreEmpresa { get; set; }

        public string PersonaAContactar { get; set; }

        public string Telefono { get; set; }


        // Ubicacion.
        public int IdProvincia { get; set; }

        public string NombreProvincia { get; set; }

        public int IdCanton { get; set; }

        public string NombreCanton { get; set; }

        public int IdDistrito { get; set; }

        public string NombreDistrito { get; set; }

        public string SenasExactas { get; set; }


        public string CorreoElectronico { get; set; }

        public string Contrasena { get; set; }


    }
}
